//
//  ProtoExtensions.swift
//  Cost Track
//
//  Created by Karthik M S on 02/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import SwiftProtobuf

extension SwiftProtobuf.Message {

	var safeJsonString: String {
		var json = ""
		do {
			json = try jsonString()
		} catch {
			assertionFailure("Proto to json conversion error")
		}
		return json
	}

	var safeSerializedData: Data {
		var data = Data()
		do {
			data = try serializedData()
		} catch {
			assertionFailure("Proto to data conversion error")
		}
		return data
	}
}
