// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Document.proto
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

struct Document {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var costSheets: [CostSheet] = []

  var groups: [CostSheetGroup] = []

  var categories: [Category] = []

  var places: [Place] = []

  var createdOnDate: Data {
    get {return _createdOnDate ?? SwiftProtobuf.Internal.emptyData}
    set {_createdOnDate = newValue}
  }
  /// Returns true if `createdOnDate` has been explicitly set.
  var hasCreatedOnDate: Bool {return self._createdOnDate != nil}
  /// Clears the value of `createdOnDate`. Subsequent reads from it will return its default value.
  mutating func clearCreatedOnDate() {self._createdOnDate = nil}

  var lastModifiedOnDate: Data {
    get {return _lastModifiedOnDate ?? SwiftProtobuf.Internal.emptyData}
    set {_lastModifiedOnDate = newValue}
  }
  /// Returns true if `lastModifiedOnDate` has been explicitly set.
  var hasLastModifiedOnDate: Bool {return self._lastModifiedOnDate != nil}
  /// Clears the value of `lastModifiedOnDate`. Subsequent reads from it will return its default value.
  mutating func clearLastModifiedOnDate() {self._lastModifiedOnDate = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _createdOnDate: Data? = nil
  fileprivate var _lastModifiedOnDate: Data? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Document: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Document"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "costSheets"),
    2: .same(proto: "groups"),
    3: .same(proto: "categories"),
    4: .same(proto: "places"),
    5: .same(proto: "createdOnDate"),
    6: .same(proto: "lastModifiedOnDate"),
  ]

  public var isInitialized: Bool {
    if self._createdOnDate == nil {return false}
    if self._lastModifiedOnDate == nil {return false}
    if !SwiftProtobuf.Internal.areAllInitialized(self.costSheets) {return false}
    if !SwiftProtobuf.Internal.areAllInitialized(self.groups) {return false}
    if !SwiftProtobuf.Internal.areAllInitialized(self.categories) {return false}
    if !SwiftProtobuf.Internal.areAllInitialized(self.places) {return false}
    return true
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.costSheets)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.groups)
      case 3: try decoder.decodeRepeatedMessageField(value: &self.categories)
      case 4: try decoder.decodeRepeatedMessageField(value: &self.places)
      case 5: try decoder.decodeSingularBytesField(value: &self._createdOnDate)
      case 6: try decoder.decodeSingularBytesField(value: &self._lastModifiedOnDate)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.costSheets.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.costSheets, fieldNumber: 1)
    }
    if !self.groups.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.groups, fieldNumber: 2)
    }
    if !self.categories.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.categories, fieldNumber: 3)
    }
    if !self.places.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.places, fieldNumber: 4)
    }
    if let v = self._createdOnDate {
      try visitor.visitSingularBytesField(value: v, fieldNumber: 5)
    }
    if let v = self._lastModifiedOnDate {
      try visitor.visitSingularBytesField(value: v, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Document, rhs: Document) -> Bool {
    if lhs.costSheets != rhs.costSheets {return false}
    if lhs.groups != rhs.groups {return false}
    if lhs.categories != rhs.categories {return false}
    if lhs.places != rhs.places {return false}
    if lhs._createdOnDate != rhs._createdOnDate {return false}
    if lhs._lastModifiedOnDate != rhs._lastModifiedOnDate {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
