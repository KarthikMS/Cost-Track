// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: CostSheet.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct CostSheet {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var name: String {
    get {return _storage._name ?? String()}
    set {_uniqueStorage()._name = newValue}
  }
  /// Returns true if `name` has been explicitly set.
  var hasName: Bool {return _storage._name != nil}
  /// Clears the value of `name`. Subsequent reads from it will return its default value.
  mutating func clearName() {_uniqueStorage()._name = nil}

  var initialBalance: Float {
    get {return _storage._initialBalance ?? 0}
    set {_uniqueStorage()._initialBalance = newValue}
  }
  /// Returns true if `initialBalance` has been explicitly set.
  var hasInitialBalance: Bool {return _storage._initialBalance != nil}
  /// Clears the value of `initialBalance`. Subsequent reads from it will return its default value.
  mutating func clearInitialBalance() {_uniqueStorage()._initialBalance = nil}

  var includeInOverallTotal: Bool {
    get {return _storage._includeInOverallTotal ?? false}
    set {_uniqueStorage()._includeInOverallTotal = newValue}
  }
  /// Returns true if `includeInOverallTotal` has been explicitly set.
  var hasIncludeInOverallTotal: Bool {return _storage._includeInOverallTotal != nil}
  /// Clears the value of `includeInOverallTotal`. Subsequent reads from it will return its default value.
  mutating func clearIncludeInOverallTotal() {_uniqueStorage()._includeInOverallTotal = nil}

  var group: CostSheetGroup {
    get {return _storage._group ?? CostSheetGroup()}
    set {_uniqueStorage()._group = newValue}
  }
  /// Returns true if `group` has been explicitly set.
  var hasGroup: Bool {return _storage._group != nil}
  /// Clears the value of `group`. Subsequent reads from it will return its default value.
  mutating func clearGroup() {_uniqueStorage()._group = nil}

  var entries: [CostSheetEntry] {
    get {return _storage._entries}
    set {_uniqueStorage()._entries = newValue}
  }

  var lastModifiedDate: Data {
    get {return _storage._lastModifiedDate ?? SwiftProtobuf.Internal.emptyData}
    set {_uniqueStorage()._lastModifiedDate = newValue}
  }
  /// Returns true if `lastModifiedDate` has been explicitly set.
  var hasLastModifiedDate: Bool {return _storage._lastModifiedDate != nil}
  /// Clears the value of `lastModifiedDate`. Subsequent reads from it will return its default value.
  mutating func clearLastModifiedDate() {_uniqueStorage()._lastModifiedDate = nil}

  var createdOnDate: Data {
    get {return _storage._createdOnDate ?? SwiftProtobuf.Internal.emptyData}
    set {_uniqueStorage()._createdOnDate = newValue}
  }
  /// Returns true if `createdOnDate` has been explicitly set.
  var hasCreatedOnDate: Bool {return _storage._createdOnDate != nil}
  /// Clears the value of `createdOnDate`. Subsequent reads from it will return its default value.
  mutating func clearCreatedOnDate() {_uniqueStorage()._createdOnDate = nil}

  var id: String {
    get {return _storage._id ?? String()}
    set {_uniqueStorage()._id = newValue}
  }
  /// Returns true if `id` has been explicitly set.
  var hasID: Bool {return _storage._id != nil}
  /// Clears the value of `id`. Subsequent reads from it will return its default value.
  mutating func clearID() {_uniqueStorage()._id = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension CostSheet: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CostSheet"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "initialBalance"),
    3: .same(proto: "includeInOverallTotal"),
    4: .same(proto: "group"),
    5: .same(proto: "entries"),
    6: .same(proto: "lastModifiedDate"),
    7: .same(proto: "createdOnDate"),
    8: .same(proto: "id"),
  ]

  fileprivate class _StorageClass {
    var _name: String? = nil
    var _initialBalance: Float? = nil
    var _includeInOverallTotal: Bool? = nil
    var _group: CostSheetGroup? = nil
    var _entries: [CostSheetEntry] = []
    var _lastModifiedDate: Data? = nil
    var _createdOnDate: Data? = nil
    var _id: String? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _name = source._name
      _initialBalance = source._initialBalance
      _includeInOverallTotal = source._includeInOverallTotal
      _group = source._group
      _entries = source._entries
      _lastModifiedDate = source._lastModifiedDate
      _createdOnDate = source._createdOnDate
      _id = source._id
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public var isInitialized: Bool {
    return withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._name == nil {return false}
      if _storage._initialBalance == nil {return false}
      if _storage._includeInOverallTotal == nil {return false}
      if _storage._group == nil {return false}
      if _storage._lastModifiedDate == nil {return false}
      if _storage._createdOnDate == nil {return false}
      if _storage._id == nil {return false}
      if let v = _storage._group, !v.isInitialized {return false}
      if !SwiftProtobuf.Internal.areAllInitialized(_storage._entries) {return false}
      return true
    }
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularStringField(value: &_storage._name)
        case 2: try decoder.decodeSingularFloatField(value: &_storage._initialBalance)
        case 3: try decoder.decodeSingularBoolField(value: &_storage._includeInOverallTotal)
        case 4: try decoder.decodeSingularMessageField(value: &_storage._group)
        case 5: try decoder.decodeRepeatedMessageField(value: &_storage._entries)
        case 6: try decoder.decodeSingularBytesField(value: &_storage._lastModifiedDate)
        case 7: try decoder.decodeSingularBytesField(value: &_storage._createdOnDate)
        case 8: try decoder.decodeSingularStringField(value: &_storage._id)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._name {
        try visitor.visitSingularStringField(value: v, fieldNumber: 1)
      }
      if let v = _storage._initialBalance {
        try visitor.visitSingularFloatField(value: v, fieldNumber: 2)
      }
      if let v = _storage._includeInOverallTotal {
        try visitor.visitSingularBoolField(value: v, fieldNumber: 3)
      }
      if let v = _storage._group {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      }
      if !_storage._entries.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._entries, fieldNumber: 5)
      }
      if let v = _storage._lastModifiedDate {
        try visitor.visitSingularBytesField(value: v, fieldNumber: 6)
      }
      if let v = _storage._createdOnDate {
        try visitor.visitSingularBytesField(value: v, fieldNumber: 7)
      }
      if let v = _storage._id {
        try visitor.visitSingularStringField(value: v, fieldNumber: 8)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: CostSheet) -> Bool {
    if self._storage !== other._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((self._storage, other._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let other_storage = _args.1
        if _storage._name != other_storage._name {return false}
        if _storage._initialBalance != other_storage._initialBalance {return false}
        if _storage._includeInOverallTotal != other_storage._includeInOverallTotal {return false}
        if _storage._group != other_storage._group {return false}
        if _storage._entries != other_storage._entries {return false}
        if _storage._lastModifiedDate != other_storage._lastModifiedDate {return false}
        if _storage._createdOnDate != other_storage._createdOnDate {return false}
        if _storage._id != other_storage._id {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if self.unknownFields != other.unknownFields {return false}
    return true
  }
}
