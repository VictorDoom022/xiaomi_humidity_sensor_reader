// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'added_device_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAddedDeviceDataCollection on Isar {
  IsarCollection<AddedDeviceData> get addedDeviceDatas => this.collection();
}

const AddedDeviceDataSchema = CollectionSchema(
  name: r'AddedDeviceData',
  id: -7947973974966537719,
  properties: {
    r'deviceMacAddress': PropertySchema(
      id: 0,
      name: r'deviceMacAddress',
      type: IsarType.string,
    ),
    r'deviceName': PropertySchema(
      id: 1,
      name: r'deviceName',
      type: IsarType.string,
    ),
    r'timeAdded': PropertySchema(
      id: 2,
      name: r'timeAdded',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _addedDeviceDataEstimateSize,
  serialize: _addedDeviceDataSerialize,
  deserialize: _addedDeviceDataDeserialize,
  deserializeProp: _addedDeviceDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _addedDeviceDataGetId,
  getLinks: _addedDeviceDataGetLinks,
  attach: _addedDeviceDataAttach,
  version: '3.1.0+1',
);

int _addedDeviceDataEstimateSize(
  AddedDeviceData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.deviceMacAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.deviceName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _addedDeviceDataSerialize(
  AddedDeviceData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.deviceMacAddress);
  writer.writeString(offsets[1], object.deviceName);
  writer.writeDateTime(offsets[2], object.timeAdded);
}

AddedDeviceData _addedDeviceDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AddedDeviceData(
    deviceMacAddress: reader.readStringOrNull(offsets[0]),
    deviceName: reader.readStringOrNull(offsets[1]),
    timeAdded: reader.readDateTimeOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _addedDeviceDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _addedDeviceDataGetId(AddedDeviceData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _addedDeviceDataGetLinks(AddedDeviceData object) {
  return [];
}

void _addedDeviceDataAttach(
    IsarCollection<dynamic> col, Id id, AddedDeviceData object) {
  object.id = id;
}

extension AddedDeviceDataQueryWhereSort
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QWhere> {
  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AddedDeviceDataQueryWhere
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QWhereClause> {
  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterWhereClause>
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

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterWhereClause> idBetween(
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

extension AddedDeviceDataQueryFilter
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QFilterCondition> {
  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deviceMacAddress',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deviceMacAddress',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceMacAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceMacAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceMacAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceMacAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceMacAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceMacAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceMacAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceMacAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceMacAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceMacAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceMacAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deviceName',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deviceName',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceName',
        value: '',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      deviceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceName',
        value: '',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
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

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
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

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
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

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      timeAddedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeAdded',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      timeAddedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeAdded',
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      timeAddedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      timeAddedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      timeAddedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterFilterCondition>
      timeAddedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AddedDeviceDataQueryObject
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QFilterCondition> {}

extension AddedDeviceDataQueryLinks
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QFilterCondition> {}

extension AddedDeviceDataQuerySortBy
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QSortBy> {
  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      sortByDeviceMacAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceMacAddress', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      sortByDeviceMacAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceMacAddress', Sort.desc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      sortByDeviceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceName', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      sortByDeviceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceName', Sort.desc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      sortByTimeAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAdded', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      sortByTimeAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAdded', Sort.desc);
    });
  }
}

extension AddedDeviceDataQuerySortThenBy
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QSortThenBy> {
  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      thenByDeviceMacAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceMacAddress', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      thenByDeviceMacAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceMacAddress', Sort.desc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      thenByDeviceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceName', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      thenByDeviceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceName', Sort.desc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      thenByTimeAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAdded', Sort.asc);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QAfterSortBy>
      thenByTimeAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAdded', Sort.desc);
    });
  }
}

extension AddedDeviceDataQueryWhereDistinct
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QDistinct> {
  QueryBuilder<AddedDeviceData, AddedDeviceData, QDistinct>
      distinctByDeviceMacAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceMacAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QDistinct>
      distinctByDeviceName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AddedDeviceData, AddedDeviceData, QDistinct>
      distinctByTimeAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeAdded');
    });
  }
}

extension AddedDeviceDataQueryProperty
    on QueryBuilder<AddedDeviceData, AddedDeviceData, QQueryProperty> {
  QueryBuilder<AddedDeviceData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AddedDeviceData, String?, QQueryOperations>
      deviceMacAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceMacAddress');
    });
  }

  QueryBuilder<AddedDeviceData, String?, QQueryOperations>
      deviceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceName');
    });
  }

  QueryBuilder<AddedDeviceData, DateTime?, QQueryOperations>
      timeAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeAdded');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddedDeviceData _$AddedDeviceDataFromJson(Map<String, dynamic> json) =>
    AddedDeviceData(
      deviceName: json['deviceName'] as String?,
      deviceMacAddress: json['deviceMacAddress'] as String?,
      timeAdded: json['timeAdded'] == null
          ? null
          : DateTime.parse(json['timeAdded'] as String),
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$AddedDeviceDataToJson(AddedDeviceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceName': instance.deviceName,
      'deviceMacAddress': instance.deviceMacAddress,
      'timeAdded': instance.timeAdded?.toIso8601String(),
    };
