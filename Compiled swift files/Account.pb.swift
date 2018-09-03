// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Account.proto
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

struct Account {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var costSheets: [CostSheet] = []

  var groups: [CostSheetGroup] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Account: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Account"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "costSheets"),
    2: .same(proto: "groups"),
  ]

  public var isInitialized: Bool {
    if !SwiftProtobuf.Internal.areAllInitialized(self.costSheets) {return false}
    if !SwiftProtobuf.Internal.areAllInitialized(self.groups) {return false}
    return true
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.costSheets)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.groups)
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
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Account) -> Bool {
    if self.costSheets != other.costSheets {return false}
    if self.groups != other.groups {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}