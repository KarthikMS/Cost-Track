// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: CTEnums.proto
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

enum EntryType: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case income // = 0
  case expense // = 1

  init() {
    self = .income
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .income
    case 1: self = .expense
    default: return nil
    }
  }

  var rawValue: Int {
    switch self {
    case .income: return 0
    case .expense: return 1
    }
  }

}

#if swift(>=4.2)

extension EntryType: CaseIterable {
  // Support synthesized by the compiler.
}

#endif  // swift(>=4.2)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension EntryType: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "INCOME"),
    1: .same(proto: "EXPENSE"),
  ]
}
