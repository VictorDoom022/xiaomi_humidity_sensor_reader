// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xiaomi_sensor_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetXiaomiSensorDataCollection on Isar {
  IsarCollection<XiaomiSensorData> get xiaomiSensorDatas => this.collection();
}

const XiaomiSensorDataSchema = CollectionSchema(
  name: r'XiaomiSensorData',
  id: -2422179222502744478,
  properties: {
    r'battery': PropertySchema(
      id: 0,
      name: r'battery',
      type: IsarType.long,
    ),
    r'humidity': PropertySchema(
      id: 1,
      name: r'humidity',
      type: IsarType.long,
    ),
    r'lastUpdateTime': PropertySchema(
      id: 2,
      name: r'lastUpdateTime',
      type: IsarType.dateTime,
    ),
    r'macAddress': PropertySchema(
      id: 3,
      name: r'macAddress',
      type: IsarType.string,
    ),
    r'sensorName': PropertySchema(
      id: 4,
      name: r'sensorName',
      type: IsarType.string,
    ),
    r'temperature': PropertySchema(
      id: 5,
      name: r'temperature',
      type: IsarType.double,
    )
  },
  estimateSize: _xiaomiSensorDataEstimateSize,
  serialize: _xiaomiSensorDataSerialize,
  deserialize: _xiaomiSensorDataDeserialize,
  deserializeProp: _xiaomiSensorDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _xiaomiSensorDataGetId,
  getLinks: _xiaomiSensorDataGetLinks,
  attach: _xiaomiSensorDataAttach,
  version: '3.1.0+1',
);

int _xiaomiSensorDataEstimateSize(
  XiaomiSensorData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.macAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sensorName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _xiaomiSensorDataSerialize(
  XiaomiSensorData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.battery);
  writer.writeLong(offsets[1], object.humidity);
  writer.writeDateTime(offsets[2], object.lastUpdateTime);
  writer.writeString(offsets[3], object.macAddress);
  writer.writeString(offsets[4], object.sensorName);
  writer.writeDouble(offsets[5], object.temperature);
}

XiaomiSensorData _xiaomiSensorDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = XiaomiSensorData(
    battery: reader.readLongOrNull(offsets[0]),
    humidity: reader.readLongOrNull(offsets[1]),
    lastUpdateTime: reader.readDateTimeOrNull(offsets[2]),
    macAddress: reader.readStringOrNull(offsets[3]),
    sensorName: reader.readStringOrNull(offsets[4]),
    temperature: reader.readDoubleOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _xiaomiSensorDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _xiaomiSensorDataGetId(XiaomiSensorData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _xiaomiSensorDataGetLinks(XiaomiSensorData object) {
  return [];
}

void _xiaomiSensorDataAttach(
    IsarCollection<dynamic> col, Id id, XiaomiSensorData object) {
  object.id = id;
}

extension XiaomiSensorDataQueryWhereSort
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QWhere> {
  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension XiaomiSensorDataQueryWhere
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QWhereClause> {
  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterWhereClause> idBetween(
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
}

extension XiaomiSensorDataQueryFilter
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QFilterCondition> {
  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      batteryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'battery',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      batteryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'battery',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      batteryEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'battery',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      batteryGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'battery',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      batteryLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'battery',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      batteryBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'battery',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      humidityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'humidity',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      humidityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'humidity',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      humidityEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'humidity',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      humidityGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'humidity',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      humidityLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'humidity',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      humidityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'humidity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
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

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
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

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      lastUpdateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUpdateTime',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      lastUpdateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUpdateTime',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      lastUpdateTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      lastUpdateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      lastUpdateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      lastUpdateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'macAddress',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'macAddress',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'macAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'macAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'macAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'macAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'macAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'macAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'macAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      macAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'macAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sensorName',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sensorName',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sensorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sensorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sensorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sensorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sensorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sensorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sensorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sensorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sensorName',
        value: '',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      sensorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sensorName',
        value: '',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      temperatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'temperature',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      temperatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'temperature',
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      temperatureEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      temperatureGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      temperatureLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterFilterCondition>
      temperatureBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'temperature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension XiaomiSensorDataQueryObject
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QFilterCondition> {}

extension XiaomiSensorDataQueryLinks
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QFilterCondition> {}

extension XiaomiSensorDataQuerySortBy
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QSortBy> {
  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByBattery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battery', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByBatteryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battery', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByHumidity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByHumidityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByLastUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByLastUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByMacAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macAddress', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByMacAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macAddress', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortBySensorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorName', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortBySensorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorName', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }
}

extension XiaomiSensorDataQuerySortThenBy
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QSortThenBy> {
  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByBattery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battery', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByBatteryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battery', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByHumidity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByHumidityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByLastUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByLastUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByMacAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macAddress', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByMacAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macAddress', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenBySensorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorName', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenBySensorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sensorName', Sort.desc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QAfterSortBy>
      thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }
}

extension XiaomiSensorDataQueryWhereDistinct
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct> {
  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct>
      distinctByBattery() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'battery');
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct>
      distinctByHumidity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'humidity');
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct>
      distinctByLastUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdateTime');
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct>
      distinctByMacAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct>
      distinctBySensorName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sensorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<XiaomiSensorData, XiaomiSensorData, QDistinct>
      distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }
}

extension XiaomiSensorDataQueryProperty
    on QueryBuilder<XiaomiSensorData, XiaomiSensorData, QQueryProperty> {
  QueryBuilder<XiaomiSensorData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<XiaomiSensorData, int?, QQueryOperations> batteryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'battery');
    });
  }

  QueryBuilder<XiaomiSensorData, int?, QQueryOperations> humidityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'humidity');
    });
  }

  QueryBuilder<XiaomiSensorData, DateTime?, QQueryOperations>
      lastUpdateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdateTime');
    });
  }

  QueryBuilder<XiaomiSensorData, String?, QQueryOperations>
      macAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macAddress');
    });
  }

  QueryBuilder<XiaomiSensorData, String?, QQueryOperations>
      sensorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sensorName');
    });
  }

  QueryBuilder<XiaomiSensorData, double?, QQueryOperations>
      temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XiaomiSensorData _$XiaomiSensorDataFromJson(Map<String, dynamic> json) =>
    XiaomiSensorData(
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toInt(),
      battery: (json['battery'] as num?)?.toInt(),
      lastUpdateTime: json['lastUpdateTime'] == null
          ? null
          : DateTime.parse(json['lastUpdateTime'] as String),
      sensorName: json['sensorName'] as String?,
      macAddress: json['macAddress'] as String?,
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$XiaomiSensorDataToJson(XiaomiSensorData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'battery': instance.battery,
      'lastUpdateTime': instance.lastUpdateTime?.toIso8601String(),
      'sensorName': instance.sensorName,
      'macAddress': instance.macAddress,
    };
