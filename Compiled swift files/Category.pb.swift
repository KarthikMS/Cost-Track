// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Category.proto
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

struct Category {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var name: String {
    get {return _name ?? String()}
    set {_name = newValue}
  }
  /// Returns true if `name` has been explicitly set.
  var hasName: Bool {return self._name != nil}
  /// Clears the value of `name`. Subsequent reads from it will return its default value.
  mutating func clearName() {self._name = nil}

  var iconType: Category.IconType {
    get {return _iconType ?? .salary}
    set {_iconType = newValue}
  }
  /// Returns true if `iconType` has been explicitly set.
  var hasIconType: Bool {return self._iconType != nil}
  /// Clears the value of `iconType`. Subsequent reads from it will return its default value.
  mutating func clearIconType() {self._iconType = nil}

  var entryTypes: [EntryType] = []

  var id: String {
    get {return _id ?? String()}
    set {_id = newValue}
  }
  /// Returns true if `id` has been explicitly set.
  var hasID: Bool {return self._id != nil}
  /// Clears the value of `id`. Subsequent reads from it will return its default value.
  mutating func clearID() {self._id = nil}

  var canEdit: Bool {
    get {return _canEdit ?? false}
    set {_canEdit = newValue}
  }
  /// Returns true if `canEdit` has been explicitly set.
  var hasCanEdit: Bool {return self._canEdit != nil}
  /// Clears the value of `canEdit`. Subsequent reads from it will return its default value.
  mutating func clearCanEdit() {self._canEdit = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum IconType: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case salary // = 0
    case vehicleAndTransport // = 1
    case household // = 2
    case shopping // = 3
    case phone // = 4
    case entertainment // = 5
    case medicine // = 6
    case investment // = 7
    case tax // = 8
    case insurance // = 9
    case foodAndDrinks // = 10
    case misc // = 11
    case transfer // = 12
    case lend // = 13
    case borrow // = 14

    init() {
      self = .salary
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .salary
      case 1: self = .vehicleAndTransport
      case 2: self = .household
      case 3: self = .shopping
      case 4: self = .phone
      case 5: self = .entertainment
      case 6: self = .medicine
      case 7: self = .investment
      case 8: self = .tax
      case 9: self = .insurance
      case 10: self = .foodAndDrinks
      case 11: self = .misc
      case 12: self = .transfer
      case 13: self = .lend
      case 14: self = .borrow
      default: return nil
      }
    }

    var rawValue: Int {
      switch self {
      case .salary: return 0
      case .vehicleAndTransport: return 1
      case .household: return 2
      case .shopping: return 3
      case .phone: return 4
      case .entertainment: return 5
      case .medicine: return 6
      case .investment: return 7
      case .tax: return 8
      case .insurance: return 9
      case .foodAndDrinks: return 10
      case .misc: return 11
      case .transfer: return 12
      case .lend: return 13
      case .borrow: return 14
      }
    }

  }

  init() {}

  fileprivate var _name: String? = nil
  fileprivate var _iconType: Category.IconType? = nil
  fileprivate var _id: String? = nil
  fileprivate var _canEdit: Bool? = nil
}

#if swift(>=4.2)

extension Category.IconType: CaseIterable {
  // Support synthesized by the compiler.
}

#endif  // swift(>=4.2)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Category: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Category"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "iconType"),
    3: .same(proto: "entryTypes"),
    4: .same(proto: "id"),
    5: .same(proto: "canEdit"),
  ]

  public var isInitialized: Bool {
    if self._name == nil {return false}
    if self._iconType == nil {return false}
    if self._id == nil {return false}
    if self._canEdit == nil {return false}
    return true
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self._name)
      case 2: try decoder.decodeSingularEnumField(value: &self._iconType)
      case 3: try decoder.decodeRepeatedEnumField(value: &self.entryTypes)
      case 4: try decoder.decodeSingularStringField(value: &self._id)
      case 5: try decoder.decodeSingularBoolField(value: &self._canEdit)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._name {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    if let v = self._iconType {
      try visitor.visitSingularEnumField(value: v, fieldNumber: 2)
    }
    if !self.entryTypes.isEmpty {
      try visitor.visitRepeatedEnumField(value: self.entryTypes, fieldNumber: 3)
    }
    if let v = self._id {
      try visitor.visitSingularStringField(value: v, fieldNumber: 4)
    }
    if let v = self._canEdit {
      try visitor.visitSingularBoolField(value: v, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Category, rhs: Category) -> Bool {
    if lhs._name != rhs._name {return false}
    if lhs._iconType != rhs._iconType {return false}
    if lhs.entryTypes != rhs.entryTypes {return false}
    if lhs._id != rhs._id {return false}
    if lhs._canEdit != rhs._canEdit {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Category.IconType: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "SALARY"),
    1: .same(proto: "VEHICLE_AND_TRANSPORT"),
    2: .same(proto: "HOUSEHOLD"),
    3: .same(proto: "SHOPPING"),
    4: .same(proto: "PHONE"),
    5: .same(proto: "ENTERTAINMENT"),
    6: .same(proto: "MEDICINE"),
    7: .same(proto: "INVESTMENT"),
    8: .same(proto: "TAX"),
    9: .same(proto: "INSURANCE"),
    10: .same(proto: "FOOD_AND_DRINKS"),
    11: .same(proto: "MISC"),
    12: .same(proto: "TRANSFER"),
    13: .same(proto: "LEND"),
    14: .same(proto: "BORROW"),
  ]
}
