import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shieldcam/core/errors/app_exception.dart';
import 'package:shieldcam/core/utils/app_folders.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Builds ZIP archives and PDF reports for one or more events.
class ExportService {
  ExportService(this._repository);

  final EventRepository _repository;

  /// Exports [events] to a ZIP containing the evidence images plus a PDF
  /// report and a machine-readable metadata.json. Returns the file path.
  Future<File> exportZip(List<IntrusionEvent> events, {String? name}) async {
    if (events.isEmpty) {
      throw const AppException('Nothing to export');
    }

    final archive = Archive();
    for (final e in events) {
      final prefix = 'events/${DateTimeUtils.eventFilename(e.timestamp)}_${e.uuid.substring(0, 8)}';
      if (e.hasFrontImage && File(e.frontImagePath).existsSync()) {
        final bytes = await File(e.frontImagePath).readAsBytes();
        archive.addFile(ArchiveFile('$prefix/front.jpg', bytes.length, bytes));
      }
      if (e.hasRearImage && File(e.rearImagePath).existsSync()) {
        final bytes = await File(e.rearImagePath).readAsBytes();
        archive.addFile(ArchiveFile('$prefix/rear.jpg', bytes.length, bytes));
      }
    }

    final pdfBytes = await buildPdf(events);
    archive.addFile(ArchiveFile('report.pdf', pdfBytes.length, pdfBytes));

    final metadata = jsonEncode(
      {
        'exportedAt': DateTimeUtils.formatTimestamp(DateTime.now()),
        'app': 'ShieldCam',
        'count': events.length,
        'events': events.map(_eventToJson).toList(),
      },
    );
    archive.addFile(
      ArchiveFile('metadata.json', utf8.encode(metadata).length, utf8.encode(metadata)),
    );

    final dir = await AppFolders.exports();
    final stamp = DateTimeUtils.eventFilename(DateTime.now());
    final file = File(p.join(dir.path, '${name ?? 'shieldcam_export'}_$stamp.zip'));
    final output = ZipEncoder().encode(archive);
    if (output == null) {
      throw const AppException('Failed to create archive');
    }
    await file.writeAsBytes(output, flush: true);
    AppLogger.i('Export created: ${file.path} (${file.lengthSync()} bytes)');
    return file;
  }

  /// Exports a plain JSON archive of all event metadata.
  Future<File> exportJson(List<IntrusionEvent> events, {String? name}) async {
    final metadata = jsonEncode({
      'exportedAt': DateTimeUtils.formatTimestamp(DateTime.now()),
      'app': 'ShieldCam',
      'count': events.length,
      'events': events.map(_eventToJson).toList(),
    });
    final dir = await AppFolders.exports();
    final stamp = DateTimeUtils.eventFilename(DateTime.now());
    final file = File(p.join(dir.path, '${name ?? 'shieldcam_data'}_$stamp.json'));
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(jsonDecode(metadata)));
    return file;
  }

  /// Builds a PDF report for [events].
  Future<Uint8List> buildPdf(List<IntrusionEvent> events) async {
    final doc = pw.Document(title: 'ShieldCam Report');
    for (final e in events) {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(level: 0, child: pw.Text('ShieldCam Event Report')),
            pw.SizedBox(height: 8),
            pw.Text('Event ${DateTimeUtils.formatTimestamp(e.timestamp)}'),
            pw.SizedBox(height: 12),
            _metaRow('Attempt', '#${e.attemptCount}'),
            _metaRow('Source', e.source.isEmpty ? 'native' : e.source),
            _metaRow('Battery', '${e.batteryLevel ?? 'unknown'}%'),
            _metaRow('Device', e.deviceModel.isEmpty ? 'unknown' : '${e.manufacturer} ${e.deviceModel}'),
            _metaRow('Android', e.androidVersion.isEmpty ? 'unknown' : 'Android ${e.androidVersion}'),
            if (e.hasLocation) ...[
              _metaRow('Latitude', e.latitude!.toStringAsFixed(6)),
              _metaRow('Longitude', e.longitude!.toStringAsFixed(6)),
            ],
            _metaRow('Address', e.address.isEmpty ? 'unknown' : e.address),
            pw.SizedBox(height: 12),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Text(
              e.hasFrontImage
                  ? 'Front camera'
                  : 'Front camera: no image was captured',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            if (e.hasFrontImage) _image(e.frontImagePath),
            pw.SizedBox(height: 12),
            pw.Text(
              e.hasRearImage
                  ? 'Rear camera'
                  : 'Rear camera: no image was captured',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            if (e.hasRearImage) _image(e.rearImagePath),
            pw.SizedBox(height: 16),
            pw.Text(
              'Generated by ShieldCam on ${DateTimeUtils.formatTimestamp(DateTime.now())}',
              style: const pw.TextStyle(color: PdfColors.grey, fontSize: 9),
            ),
          ],
        ),
      );
    }
    return doc.save();
  }

  pw.Widget _metaRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(label, style: const pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  pw.Widget _image(String path) {
    final file = File(path);
    if (!file.existsSync()) return pw.SizedBox.shrink();
    try {
      final bytes = file.readAsBytesSync();
      final image = pw.MemoryImage(bytes);
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Center(
          child: pw.Container(
            constraints: const pw.BoxConstraints(maxWidth: 300, maxHeight: 400),
            child: pw.Image(image),
          ),
        ),
      );
    } catch (_) {
      return pw.SizedBox.shrink();
    }
  }

  Map<String, dynamic> _eventToJson(IntrusionEvent e) {
    return {
      'uuid': e.uuid,
      'timestamp': DateTimeUtils.formatTimestamp(e.timestamp),
      'attemptCount': e.attemptCount,
      'batteryLevel': e.batteryLevel,
      'batteryCharging': e.batteryCharging,
      'deviceModel': e.deviceModel,
      'manufacturer': e.manufacturer,
      'androidVersion': e.androidVersion,
      'frontImage': e.hasFrontImage ? p.basename(e.frontImagePath) : null,
      'rearImage': e.hasRearImage ? p.basename(e.rearImagePath) : null,
      'latitude': e.latitude,
      'longitude': e.longitude,
      'address': e.address,
      'source': e.source,
      'notes': e.notes,
    };
  }
}
