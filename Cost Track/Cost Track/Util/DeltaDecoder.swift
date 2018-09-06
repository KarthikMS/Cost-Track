//
//  DeltaDecoder.swift
//  Cost Track
//
//  Created by Karthik M S on 31/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation
import SwiftProtobuf

public enum DeltaApplierError: Error {
	case failure
	case fieldStringError
	case unImplementedOpType
	case arrayIndexOutOfBounds
	case callingDecodeOnLiteralType
	case decodingUnInitializedObject
	case stringConversionFailure
}

// swiftlint:disable type_body_length
public struct DeltaDataApplier: SwiftProtobuf.Decoder {

	/// Returns the next field number, or nil when the end of the input is
	/// reached.
	///
	/// For JSON and text format, the decoder translates the field name to a
	/// number at this point, based on information it obtained from the message
	/// when it was initialized.
	mutating public func nextFieldNumber() throws -> Int? {
		if fieldNumbers.isEmpty || currentIndex >= fieldNumbers.count {
			return nil
		}
		let index = currentIndex
		currentIndex += 1
		return fieldNumbers[index]
	}

	mutating public func decodeSingularFloatField(value: inout Float) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularFloatField(value: inout Float?) throws {
		if let valueString = String(data: self.dataValue, encoding: .utf8) {
			value = Float(valueString)
		}
	}

	mutating public func decodeRepeatedFloatField(value: inout [Float]) throws {
		guard let index = try self.nextFieldNumber() else {
			throw DeltaApplierError.failure
		}
		if self.currentIndex == self.fieldNumbers.count {
			switch self.opType {
			case .insert:
				if index <= value.count {
					if let float = Float(String(data: self.dataValue, encoding: .utf8) ?? "") {
						value.insert(float, at: index)
					} else {
						throw DeltaApplierError.stringConversionFailure
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .update:
				if index < value.count {
					if let float = Float(String(data: self.dataValue, encoding: .utf8) ?? "") {
						value[index] = float
					} else {
						throw DeltaApplierError.stringConversionFailure
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .delete:
				if index < value.count {
					value.remove(at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .custom:
				assert(false)
				throw DeltaApplierError.unImplementedOpType
			case .reorder:
				if index < value.count {
					let temp = value[index]
					value.remove(at: index)
					if newIndex < value.count {
						value.insert(temp, at: newIndex)
					} else if newIndex == value.count {
						value.insert(temp, at: value.endIndex)
					} else {
						throw DeltaApplierError.arrayIndexOutOfBounds
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			}
		} else {
			throw DeltaApplierError.callingDecodeOnLiteralType
		}
	}

	mutating public func decodeSingularDoubleField(value: inout Double) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularDoubleField(value: inout Double?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedDoubleField(value: inout [Double]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularInt32Field(value: inout Int32) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularInt32Field(value: inout Int32?) throws {
		if let valueString = String(data: self.dataValue, encoding: .utf8) {
			value = Int32(valueString)
		}
	}

	mutating public func decodeRepeatedInt32Field(value: inout [Int32]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularInt64Field(value: inout Int64) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularInt64Field(value: inout Int64?) throws {
		if let valueString = String(data: self.dataValue, encoding: .utf8), let int64Value = Int64(valueString) {
			value = int64Value
		}
	}

	mutating public func decodeRepeatedInt64Field(value: inout [Int64]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularUInt32Field(value: inout UInt32) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularUInt32Field(value: inout UInt32?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedUInt32Field(value: inout [UInt32]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularUInt64Field(value: inout UInt64) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularUInt64Field(value: inout UInt64?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedUInt64Field(value: inout [UInt64]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSInt32Field(value: inout Int32) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSInt32Field(value: inout Int32?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedSInt32Field(value: inout [Int32]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSInt64Field(value: inout Int64) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSInt64Field(value: inout Int64?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedSInt64Field(value: inout [Int64]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularFixed32Field(value: inout UInt32) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularFixed32Field(value: inout UInt32?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedFixed32Field(value: inout [UInt32]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularFixed64Field(value: inout UInt64) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularFixed64Field(value: inout UInt64?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedFixed64Field(value: inout [UInt64]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSFixed32Field(value: inout Int32) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSFixed32Field(value: inout Int32?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedSFixed32Field(value: inout [Int32]) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSFixed64Field(value: inout Int64) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularSFixed64Field(value: inout Int64?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedSFixed64Field(value: inout [Int64]) throws {
		assert(false, "decoding logic not written yet")
	}

	// swiftlint:disable discouraged_optional_boolean
	mutating public func decodeSingularBoolField(value: inout Bool) throws {
		if let valueString = String(data: self.dataValue, encoding: .utf8), let bool = Bool(valueString) {
			value = bool
		} else {
			throw DeltaApplierError.stringConversionFailure
		}
	}

	mutating public func decodeSingularBoolField(value: inout Bool?) throws {
		if self.opType == .delete {
			value = nil
			return
		}
		if let valueString = String(data: self.dataValue, encoding: .utf8), let bool = Bool(valueString) {
			value = bool
		} else {
			throw DeltaApplierError.stringConversionFailure
		}
	}

	mutating public func decodeRepeatedBoolField(value: inout [Bool]) throws {
		guard let index = try self.nextFieldNumber() else {
			throw DeltaApplierError.failure
		}
		if self.currentIndex == self.fieldNumbers.count {
			switch self.opType {
			case .insert:
				if index <= value.count {
					if let valueString = String(data: self.dataValue, encoding: .utf8), let bool = Bool(valueString) {
						value.insert(bool, at: index)
					} else {
						throw DeltaApplierError.stringConversionFailure
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .update:
				if index < value.count {
					if let valueString = String(data: self.dataValue, encoding: .utf8), let bool = Bool(valueString) {
						value[index] = bool
					} else {
						throw DeltaApplierError.stringConversionFailure
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .delete:
				if index < value.count {
					value.remove(at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .custom:
				assert(false)
				throw DeltaApplierError.unImplementedOpType
			case .reorder:
				if index < value.count {
					let temp = value[index]
					value.remove(at: index)
					if newIndex < value.count {
						value.insert(temp, at: newIndex)
					} else if newIndex == value.count {
						value.insert(temp, at: value.endIndex)
					} else {
						throw DeltaApplierError.arrayIndexOutOfBounds
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}            }
		} else {
			throw DeltaApplierError.callingDecodeOnLiteralType
		}
	}
	// swiftlint:enable discouraged_optional_boolean

	mutating public func decodeSingularStringField(value: inout String) throws {
		if let valueString = String(data: self.dataValue, encoding: .utf8) {
			value = valueString
		} else {
			throw DeltaApplierError.stringConversionFailure
		}
	}

	mutating public func decodeSingularStringField(value: inout String?) throws {
		value = String(data: self.dataValue, encoding: .utf8)
	}

	mutating public func decodeRepeatedStringField(value: inout [String]) throws {
		guard let index = try self.nextFieldNumber() else {
			throw DeltaApplierError.failure
		}
		guard let valueString = String(data: self.dataValue, encoding: .utf8) else {
			throw DeltaApplierError.failure
		}
		if self.currentIndex == self.fieldNumbers.count {
			switch self.opType {
			case .insert:
				if index <= value.count {
					value.insert(valueString, at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .update:
				if index < value.count {
					value[index] = valueString
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .delete:
				if index < value.count {
					value.remove(at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .custom:
				assert(false)
				throw DeltaApplierError.unImplementedOpType
			case .reorder:
				if index < value.count {
					let temp = value[index]
					value.remove(at: index)
					if newIndex < value.count {
						value.insert(temp, at: newIndex)
					} else if newIndex == value.count {
						value.insert(temp, at: value.endIndex)
					} else {
						throw DeltaApplierError.arrayIndexOutOfBounds
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			}
		} else {
			throw DeltaApplierError.callingDecodeOnLiteralType
		}
	}

	mutating public func decodeSingularBytesField(value: inout Data) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeSingularBytesField(value: inout Data?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedBytesField(value: inout [Data]) throws {
		assert(false, "decoding logic not written yet")
	}

	// Decode Enum fields
	mutating public func decodeSingularEnumField<E: Enum>(value: inout E) throws where E.RawValue == Int {
		if let valueString = String(data: self.dataValue, encoding: .utf8), let decodedValue = E(name: valueString.uppercased()) {
			value = decodedValue
		} else {
			throw DeltaApplierError.stringConversionFailure
		}
	}

	mutating public func decodeSingularEnumField<E: Enum>(value: inout E?) throws where E.RawValue == Int {
		if let valueString = String(data: self.dataValue, encoding: .utf8), let decodedValue = E(name: valueString.uppercased()) {
			value = decodedValue
		} else {
			throw DeltaApplierError.stringConversionFailure
		}
	}

	mutating public func decodeRepeatedEnumField<E: Enum>(value: inout [E]) throws where E.RawValue == Int {
		guard let index = try self.nextFieldNumber() else {
			throw DeltaApplierError.failure
		}
		guard let valueString = String(data: self.dataValue, encoding: .utf8) else {
			throw DeltaApplierError.failure
		}
		if self.currentIndex == self.fieldNumbers.count {
			switch self.opType {
			case .insert:
				if index <= value.count {
					if let enumValue = E(name: valueString.uppercased()) {
						value.insert(enumValue, at: index)
					} else {
						throw DeltaApplierError.stringConversionFailure
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .update:
				if index < value.count {
					if let enumValue = E(name: valueString.uppercased()) {
						value.insert(enumValue, at: index)
					} else {
						throw DeltaApplierError.stringConversionFailure
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .delete:
				if index < value.count {
					value.remove(at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .custom:
				assert(false)
				throw DeltaApplierError.unImplementedOpType
			case .reorder:
				if index < value.count {
					let temp = value[index]
					value.remove(at: index)
					if newIndex < value.count {
						value.insert(temp, at: newIndex)
					} else if newIndex == value.count {
						value.insert(temp, at: value.endIndex)
					} else {
						throw DeltaApplierError.arrayIndexOutOfBounds
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			}
		} else {
			throw DeltaApplierError.callingDecodeOnLiteralType
		}
	}

	// Decode Message fields
	mutating public func decodeSingularMessageField<M: Message>(value: inout M?) throws {
		if currentIndex == fieldNumbers.count {
			switch opType {
			case .insert:
				value = try M(serializedData: self.dataValue)
			case .update:
				value = try M(serializedData: self.dataValue)
			case .delete:
				value = nil
			case .custom:
				assert(false)
				throw DeltaApplierError.unImplementedOpType
			case .reorder:
				assert(false, "not implemented yet")
				throw DeltaApplierError.unImplementedOpType
			}
		} else {
			if value == nil {
				value = M()
				//throw DeltaApplierError.decodingUnInitializedObject
			}
			try value?.decodeMessage(decoder: &self)
		}
	}

	mutating public func decodeRepeatedMessageField<M: Message>(value: inout [M]) throws {
		guard let index = try self.nextFieldNumber() else {
			throw DeltaApplierError.failure
		}

		if self.currentIndex == self.fieldNumbers.count {
			switch self.opType {
			case .insert:
				if index <= value.count {
					let message = try M(serializedData: self.dataValue)
					value.insert(message, at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .update:
				if index < value.count {
					let message = try M(serializedData: self.dataValue)
					value[index] = message
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .delete:
				if index < value.count {
					value.remove(at: index)
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			case .custom:
				assert(false)
				throw DeltaApplierError.unImplementedOpType
			case .reorder:
				if index < value.count {
					let temp = value[index]
					value.remove(at: index)
					if newIndex < value.count {
						value.insert(temp, at: newIndex)
					} else if newIndex == value.count {
						value.insert(temp, at: value.endIndex)
					} else {
						throw DeltaApplierError.arrayIndexOutOfBounds
					}
				} else {
					throw DeltaApplierError.arrayIndexOutOfBounds
				}
			}
		} else {
			if index < value.count {
				try value[index].decodeMessage(decoder: &self)
			} else {
				throw DeltaApplierError.arrayIndexOutOfBounds
			}
		}

		// Second check is done so that shapePathOperation isn't called twice.

	}

	// Decode Group fields
	mutating public func decodeSingularGroupField<G: Message>(value: inout G?) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeRepeatedGroupField<G: Message>(value: inout [G]) throws {
		assert(false, "decoding logic not written yet")
	}

	// Decode Map fields.
	// This is broken into separate methods depending on whether the value
	// type is primitive (_ProtobufMap), enum (_ProtobufEnumMap), or message
	// (_ProtobufMessageMap)
	mutating public func decodeMapField<KeyType, ValueType: MapValueType>(
		fieldType: _ProtobufMap<KeyType, ValueType>.Type,
		value: inout _ProtobufMap<KeyType, ValueType>.BaseType) throws {
		assert(false, "decoding logic not written yet")
	}

	mutating public func decodeMapField<KeyType, ValueType>(
		fieldType: _ProtobufEnumMap<KeyType, ValueType>.Type,
		value: inout _ProtobufEnumMap<KeyType, ValueType>.BaseType) throws where ValueType.RawValue == Int {

	}

	mutating public func decodeMapField<KeyType, ValueType>(
		fieldType: _ProtobufMessageMap<KeyType, ValueType>.Type,
		value: inout _ProtobufMessageMap<KeyType, ValueType>.BaseType) throws {
		assert(false, "decoding logic not written yet")
	}

	// Decode extension fields
	mutating public func decodeExtensionField(values: inout ExtensionFieldValueSet, messageType: Message.Type, fieldNumber: Int) throws {
		assert(false, "decoding logic not written yet")
	}

	// Run a decode loop decoding the MessageSet format for Extensions.
	mutating public func decodeExtensionFieldsAsMessageSet(
		values: inout ExtensionFieldValueSet,
		messageType: Message.Type) throws {
		assert(false, "decoding logic not written yet")
	}

	/// Called by a `oneof` when it already has a value and is being asked to
	/// accept a new value. Some formats require `oneof` decoding to fail in this
	/// case.
	mutating public func handleConflictingOneOf() throws {
		assert(false, "decoding logic not written yet")
	}

	internal var fieldNumbers: [Int]
	internal var dataValue: Data
	internal var currentIndex: Int
	internal var opType: DocumentContentOperation.Component.OperationType
	internal var newIndex: Int = 0

	init(fieldString: String, value: Data, operationType: DocumentContentOperation.Component.OperationType, newIndex: Int32? = nil) throws {
		self.dataValue = value
		self.opType = operationType

		let fields = fieldString
			.replacingOccurrences(of: "arr:", with: "")
			.split(separator: ",")
			.flatMap { Int($0) }
		if fields.contains(where: { $0 < 0 }) || fields.isEmpty {
			throw DeltaApplierError.fieldStringError
		}

		self.fieldNumbers = fields
		self.currentIndex = 0
		if let newIndex = newIndex {
			self.newIndex = Int(newIndex)
		}
	}

	func getDetails() -> (Any, DocumentContentOperation.Component.OperationType) {
		return (self.dataValue, self.opType)
	}

	private mutating func setFieldNumbers (fieldString: String) throws {
		let fields = fieldString
			.replacingOccurrences(of: "arr:", with: "")
			.split(separator: ",")
			.flatMap { Int($0) }
		if fields.contains(where: { $0 < 0 }) || fields.isEmpty {
			throw DeltaApplierError.fieldStringError
		}
		self.fieldNumbers = fields
	}
}
// swiftlint:enable type_body_length

