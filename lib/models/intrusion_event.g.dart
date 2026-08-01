// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intrusion_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIntrusionEventCollection on Isar {
  IsarCollection<IntrusionEvent> get intrusionEvents => this.collection();
}

const IntrusionEventSchema = CollectionSchema(
  name: r'IntrusionEvent',
  id: -7582806799134066907,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'androidVersion': PropertySchema(
      id: 1,
      name: r'androidVersion',
      type: IsarType.string,
    ),
    r'attemptCount': PropertySchema(
      id: 2,
      name: r'attemptCount',
      type: IsarType.long,
    ),
    r'batteryCharging': PropertySchema(
      id: 3,
      name: r'batteryCharging',
      type: IsarType.bool,
    ),
    r'batteryLevel': PropertySchema(
      id: 4,
      name: r'batteryLevel',
      type: IsarType.long,
    ),
    r'deviceModel': PropertySchema(
      id: 5,
      name: r'deviceModel',
      type: IsarType.string,
    ),
    r'frontImagePath': PropertySchema(
      id: 6,
      name: r'frontImagePath',
      type: IsarType.string,
    ),
    r'hasFrontImage': PropertySchema(
      id: 7,
      name: r'hasFrontImage',
      type: IsarType.bool,
    ),
    r'hasLocation': PropertySchema(
      id: 8,
      name: r'hasLocation',
      type: IsarType.bool,
    ),
    r'hasRearImage': PropertySchema(
      id: 9,
      name: r'hasRearImage',
      type: IsarType.bool,
    ),
    r'latitude': PropertySchema(
      id: 10,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 11,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'manufacturer': PropertySchema(
      id: 12,
      name: r'manufacturer',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 13,
      name: r'notes',
      type: IsarType.string,
    ),
    r'rearImagePath': PropertySchema(
      id: 14,
      name: r'rearImagePath',
      type: IsarType.string,
    ),
    r'sdkInt': PropertySchema(
      id: 15,
      name: r'sdkInt',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 16,
      name: r'source',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 17,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 18,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _intrusionEventEstimateSize,
  serialize: _intrusionEventSerialize,
  deserialize: _intrusionEventDeserialize,
  deserializeProp: _intrusionEventDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _intrusionEventGetId,
  getLinks: _intrusionEventGetLinks,
  attach: _intrusionEventAttach,
  version: '3.1.0+1',
);

int _intrusionEventEstimateSize(
  IntrusionEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.androidVersion.length * 3;
  bytesCount += 3 + object.deviceModel.length * 3;
  bytesCount += 3 + object.frontImagePath.length * 3;
  bytesCount += 3 + object.manufacturer.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.rearImagePath.length * 3;
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _intrusionEventSerialize(
  IntrusionEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.androidVersion);
  writer.writeLong(offsets[2], object.attemptCount);
  writer.writeBool(offsets[3], object.batteryCharging);
  writer.writeLong(offsets[4], object.batteryLevel);
  writer.writeString(offsets[5], object.deviceModel);
  writer.writeString(offsets[6], object.frontImagePath);
  writer.writeBool(offsets[7], object.hasFrontImage);
  writer.writeBool(offsets[8], object.hasLocation);
  writer.writeBool(offsets[9], object.hasRearImage);
  writer.writeDouble(offsets[10], object.latitude);
  writer.writeDouble(offsets[11], object.longitude);
  writer.writeString(offsets[12], object.manufacturer);
  writer.writeString(offsets[13], object.notes);
  writer.writeString(offsets[14], object.rearImagePath);
  writer.writeLong(offsets[15], object.sdkInt);
  writer.writeString(offsets[16], object.source);
  writer.writeDateTime(offsets[17], object.timestamp);
  writer.writeString(offsets[18], object.uuid);
}

IntrusionEvent _intrusionEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IntrusionEvent();
  object.address = reader.readString(offsets[0]);
  object.androidVersion = reader.readString(offsets[1]);
  object.attemptCount = reader.readLong(offsets[2]);
  object.batteryCharging = reader.readBool(offsets[3]);
  object.batteryLevel = reader.readLongOrNull(offsets[4]);
  object.deviceModel = reader.readString(offsets[5]);
  object.frontImagePath = reader.readString(offsets[6]);
  object.id = id;
  object.latitude = reader.readDoubleOrNull(offsets[10]);
  object.longitude = reader.readDoubleOrNull(offsets[11]);
  object.manufacturer = reader.readString(offsets[12]);
  object.notes = reader.readString(offsets[13]);
  object.rearImagePath = reader.readString(offsets[14]);
  object.sdkInt = reader.readLong(offsets[15]);
  object.source = reader.readString(offsets[16]);
  object.timestamp = reader.readDateTime(offsets[17]);
  object.uuid = reader.readString(offsets[18]);
  return object;
}

P _intrusionEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readDateTime(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _intrusionEventGetId(IntrusionEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _intrusionEventGetLinks(IntrusionEvent object) {
  return [];
}

void _intrusionEventAttach(
    IsarCollection<dynamic> col, Id id, IntrusionEvent object) {
  object.id = id;
}

extension IntrusionEventQueryWhereSort
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QWhere> {
  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension IntrusionEventQueryWhere
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QWhereClause> {
  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause>
      timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause>
      timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause>
      timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause>
      timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterWhereClause>
      timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IntrusionEventQueryFilter
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QFilterCondition> {
  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'androidVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'androidVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'androidVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'androidVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'androidVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'androidVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'androidVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'androidVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'androidVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      androidVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'androidVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      attemptCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      attemptCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      attemptCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      attemptCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryChargingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batteryCharging',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'batteryLevel',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'batteryLevel',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryLevelEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batteryLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryLevelGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batteryLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryLevelLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batteryLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      batteryLevelBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batteryLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      deviceModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frontImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frontImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frontImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frontImagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frontImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frontImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frontImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frontImagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frontImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      frontImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frontImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      hasFrontImageEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasFrontImage',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      hasLocationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasLocation',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      hasRearImageEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasRearImage',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      latitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      longitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manufacturer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'manufacturer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'manufacturer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'manufacturer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'manufacturer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'manufacturer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'manufacturer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'manufacturer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manufacturer',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      manufacturerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'manufacturer',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rearImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rearImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rearImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rearImagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rearImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rearImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rearImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rearImagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rearImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      rearImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rearImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sdkIntEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sdkInt',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sdkIntGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sdkInt',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sdkIntLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sdkInt',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sdkIntBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sdkInt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension IntrusionEventQueryObject
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QFilterCondition> {}

extension IntrusionEventQueryLinks
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QFilterCondition> {}

extension IntrusionEventQuerySortBy
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QSortBy> {
  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByAndroidVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidVersion', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByAndroidVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidVersion', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByAttemptCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByAttemptCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByBatteryCharging() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryCharging', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByBatteryChargingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryCharging', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByBatteryLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryLevel', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByBatteryLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryLevel', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByFrontImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frontImagePath', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByFrontImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frontImagePath', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByHasFrontImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasFrontImage', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByHasFrontImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasFrontImage', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByHasLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocation', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByHasLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocation', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByHasRearImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRearImage', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByHasRearImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRearImage', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByManufacturer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufacturer', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByManufacturerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufacturer', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByRearImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rearImagePath', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByRearImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rearImagePath', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortBySdkInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdkInt', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortBySdkIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdkInt', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension IntrusionEventQuerySortThenBy
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QSortThenBy> {
  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByAndroidVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidVersion', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByAndroidVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidVersion', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByAttemptCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByAttemptCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByBatteryCharging() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryCharging', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByBatteryChargingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryCharging', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByBatteryLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryLevel', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByBatteryLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryLevel', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByFrontImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frontImagePath', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByFrontImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frontImagePath', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByHasFrontImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasFrontImage', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByHasFrontImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasFrontImage', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByHasLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocation', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByHasLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLocation', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByHasRearImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRearImage', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByHasRearImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRearImage', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByManufacturer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufacturer', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByManufacturerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manufacturer', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByRearImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rearImagePath', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByRearImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rearImagePath', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenBySdkInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdkInt', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenBySdkIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdkInt', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension IntrusionEventQueryWhereDistinct
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> {
  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByAndroidVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'androidVersion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByAttemptCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attemptCount');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByBatteryCharging() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batteryCharging');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByBatteryLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batteryLevel');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctByDeviceModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByFrontImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frontImagePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByHasFrontImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasFrontImage');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByHasLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasLocation');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByHasRearImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasRearImage');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByManufacturer({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manufacturer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByRearImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rearImagePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctBySdkInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sdkInt');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<IntrusionEvent, IntrusionEvent, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension IntrusionEventQueryProperty
    on QueryBuilder<IntrusionEvent, IntrusionEvent, QQueryProperty> {
  QueryBuilder<IntrusionEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations>
      androidVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'androidVersion');
    });
  }

  QueryBuilder<IntrusionEvent, int, QQueryOperations> attemptCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attemptCount');
    });
  }

  QueryBuilder<IntrusionEvent, bool, QQueryOperations>
      batteryChargingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batteryCharging');
    });
  }

  QueryBuilder<IntrusionEvent, int?, QQueryOperations> batteryLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batteryLevel');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations> deviceModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceModel');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations>
      frontImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frontImagePath');
    });
  }

  QueryBuilder<IntrusionEvent, bool, QQueryOperations> hasFrontImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasFrontImage');
    });
  }

  QueryBuilder<IntrusionEvent, bool, QQueryOperations> hasLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasLocation');
    });
  }

  QueryBuilder<IntrusionEvent, bool, QQueryOperations> hasRearImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasRearImage');
    });
  }

  QueryBuilder<IntrusionEvent, double?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<IntrusionEvent, double?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations>
      manufacturerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manufacturer');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations>
      rearImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rearImagePath');
    });
  }

  QueryBuilder<IntrusionEvent, int, QQueryOperations> sdkIntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sdkInt');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<IntrusionEvent, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<IntrusionEvent, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
