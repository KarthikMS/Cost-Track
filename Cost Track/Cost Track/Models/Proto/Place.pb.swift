// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Place.proto
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

struct Place {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: String {
    get {return _id ?? String()}
    set {_id = newValue}
  }
  /// Returns true if `id` has been explicitly set.
  var hasID: Bool {return self._id != nil}
  /// Clears the value of `id`. Subsequent reads from it will return its default value.
  mutating func clearID() {self._id = nil}

  var name: String {
    get {return _name ?? String()}
    set {_name = newValue}
  }
  /// Returns true if `name` has been explicitly set.
  var hasName: Bool {return self._name != nil}
  /// Clears the value of `name`. Subsequent reads from it will return its default value.
  mutating func clearName() {self._name = nil}

  var latitude: Double {
    get {return _latitude ?? 0}
    set {_latitude = newValue}
  }
  /// Returns true if `latitude` has been explicitly set.
  var hasLatitude: Bool {return self._latitude != nil}
  /// Clears the value of `latitude`. Subsequent reads from it will return its default value.
  mutating func clearLatitude() {self._latitude = nil}

  var longitude: Double {
    get {return _longitude ?? 0}
    set {_longitude = newValue}
  }
  /// Returns true if `longitude` has been explicitly set.
  var hasLongitude: Bool {return self._longitude != nil}
  /// Clears the value of `longitude`. Subsequent reads from it will return its default value.
  mutating func clearLongitude() {self._longitude = nil}

  var address: String {
    get {return _address ?? String()}
    set {_address = newValue}
  }
  /// Returns true if `address` has been explicitly set.
  var hasAddress: Bool {return self._address != nil}
  /// Clears the value of `address`. Subsequent reads from it will return its default value.
  mutating func clearAddress() {self._address = nil}

  var phoneNumber: String {
    get {return _phoneNumber ?? String()}
    set {_phoneNumber = newValue}
  }
  /// Returns true if `phoneNumber` has been explicitly set.
  var hasPhoneNumber: Bool {return self._phoneNumber != nil}
  /// Clears the value of `phoneNumber`. Subsequent reads from it will return its default value.
  mutating func clearPhoneNumber() {self._phoneNumber = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _id: String? = nil
  fileprivate var _name: String? = nil
  fileprivate var _latitude: Double? = nil
  fileprivate var _longitude: Double? = nil
  fileprivate var _address: String? = nil
  fileprivate var _phoneNumber: String? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Place: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Place"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "name"),
    3: .same(proto: "latitude"),
    4: .same(proto: "longitude"),
    5: .same(proto: "address"),
    6: .same(proto: "phoneNumber"),
  ]

  public var isInitialized: Bool {
    if self._id == nil {return false}
    if self._name == nil {return false}
    if self._latitude == nil {return false}
    if self._longitude == nil {return false}
    return true
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self._id)
      case 2: try decoder.decodeSingularStringField(value: &self._name)
      case 3: try decoder.decodeSingularDoubleField(value: &self._latitude)
      case 4: try decoder.decodeSingularDoubleField(value: &self._longitude)
      case 5: try decoder.decodeSingularStringField(value: &self._address)
      case 6: try decoder.decodeSingularStringField(value: &self._phoneNumber)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._id {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    if let v = self._name {
      try visitor.visitSingularStringField(value: v, fieldNumber: 2)
    }
    if let v = self._latitude {
      try visitor.visitSingularDoubleField(value: v, fieldNumber: 3)
    }
    if let v = self._longitude {
      try visitor.visitSingularDoubleField(value: v, fieldNumber: 4)
    }
    if let v = self._address {
      try visitor.visitSingularStringField(value: v, fieldNumber: 5)
    }
    if let v = self._phoneNumber {
      try visitor.visitSingularStringField(value: v, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

	func _protobuf_generated_isEqualTo(other: Place) -> Bool {
		if self._id != other._id {return false}
		if self._name != other._name {return false}
		if self._latitude != other._latitude {return false}
		if self._longitude != other._longitude {return false}
		if self._address != other._address {return false}
		if self._phoneNumber != other._phoneNumber {return false}
		if self.unknownFields != other.unknownFields {return false}
		return true
	}
}
