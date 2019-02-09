//
//  HardcodedTestData.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 02/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track

private var _document: Document?

var testDocument: Document {
	if let document = _document {
		return document
	}

	do {
		_document = try Document(jsonString: documentJSON)
		return _document!
	} catch {
		assertionFailure("Error converting json to document.")
		return Document()
	}
}

var documentJSON = "{\"costSheets\":[{\"name\":\"Purse\",\"initialBalance\":2000,\"includeInOverallTotal\":true,\"groupId\":\"36DE1AC5-713B-44D5-B85B-F1AB287D11B3\",\"entries\":[{\"type\":\"EXPENSE\",\"amount\":120,\"category\":{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},\"placeId\":\"8CCE7666-FF10-40FB-95CB-AA7BC1E7B5E6\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQQ37AAAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Samosa\",\"id\":\"2F3C251A-9984-4DF8-9521-2CED7F3930D7\"},{\"type\":\"EXPENSE\",\"amount\":460,\"category\":{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},\"placeId\":\"29150804-E1E8-49DE-837E-05DA1F322401\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQl+BAAAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"\",\"id\":\"04144981-1CA2-4934-B688-5F9689455834\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeDpXM+aIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeDpXM+aIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"2FB2EC81-D892-49D7-B202-F1200390AB3A\"},{\"name\":\"Aditya Birla Sun Life\",\"initialBalance\":12000,\"includeInOverallTotal\":true,\"groupId\":\"C2B6A069-0606-4930-A1A6-EA07CFD10E2F\",\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeD+JqIrYAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeD3xU+JYAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"8A0F118C-C5A7-4D93-AA38-A7AEDB75AD9B\"},{\"name\":\"Paytm\",\"initialBalance\":500,\"includeInOverallTotal\":true,\"groupId\":\"4F762F5E-89BA-47EC-9B1A-41C62BA61DDA\",\"entries\":[{\"type\":\"INCOME\",\"amount\":1000,\"category\":{\"name\":\"Transfer\",\"iconType\":\"TRANSFER\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeJCQj0WoAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Paytm recharge\",\"id\":\"3F9877C0-05B3-44C4-9CD3-0C1E9C2FD72E\",\"transferCostSheetId\":\"3E26813C-EA5A-4039-B445-E4CCA9F5F804\",\"transferEntryId\":\"2A8D0124-9050-4330-B486-792CCC2FD99C\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeECRVl3IAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeECRVl3IAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"69A3511A-0FE5-4B62-9204-8C70274F415B\"},{\"name\":\"HDFC Savings\",\"initialBalance\":50000,\"includeInOverallTotal\":true,\"groupId\":\"E7ECA182-53D5-4A46-A469-73EB4CB117B0\",\"entries\":[{\"type\":\"EXPENSE\",\"amount\":1000,\"category\":{\"name\":\"Transfer\",\"iconType\":\"TRANSFER\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeJCQj0WoAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Paytm recharge\",\"id\":\"2A8D0124-9050-4330-B486-792CCC2FD99C\",\"transferCostSheetId\":\"69A3511A-0FE5-4B62-9204-8C70274F415B\",\"transferEntryId\":\"3F9877C0-05B3-44C4-9CD3-0C1E9C2FD72E\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeJBFPaMIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeJBFPaMIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"3E26813C-EA5A-4039-B445-E4CCA9F5F804\"}],\"groups\":[{\"name\":\"Not set\",\"id\":\"36DE1AC5-713B-44D5-B85B-F1AB287D11B3\"},{\"name\":\"Savings Accounts\",\"id\":\"E7ECA182-53D5-4A46-A469-73EB4CB117B0\"},{\"name\":\"Phone Wallets\",\"id\":\"4F762F5E-89BA-47EC-9B1A-41C62BA61DDA\"},{\"name\":\"Mutual Funds\",\"id\":\"C2B6A069-0606-4930-A1A6-EA07CFD10E2F\"},{\"name\":\"Cards\",\"id\":\"34536DBC-3E2F-4869-BD69-03EAD3F7D895\"}],\"categories\":[{\"name\":\"Salary\",\"iconType\":\"SALARY\",\"entryTypes\":[\"INCOME\"]},{\"name\":\"Vehicle & Transport\",\"iconType\":\"VEHICLE_AND_TRANSPORT\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Household\",\"iconType\":\"HOUSEHOLD\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Shopping\",\"iconType\":\"SHOPPING\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Phone\",\"iconType\":\"PHONE\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Entertainment\",\"iconType\":\"ENTERTAINMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Medicine\",\"iconType\":\"MEDICINE\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Investment\",\"iconType\":\"INVESTMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Tax\",\"iconType\":\"TAX\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Insurance\",\"iconType\":\"INSURANCE\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Misc\",\"iconType\":\"MISC\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Transfer\",\"iconType\":\"TRANSFER\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Lend\",\"iconType\":\"LEND\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Borrow\",\"iconType\":\"BORROW\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]}],\"places\":[{\"id\":\"8CCE7666-FF10-40FB-95CB-AA7BC1E7B5E6\",\"name\":\"Adyar Bakery\",\"address\":\"Kalakshetra Road, Thiruvanmiyur\"},{\"id\":\"29150804-E1E8-49DE-837E-05DA1F322401\",\"name\":\"Star Briyani\",\"address\":\"GST Road, Guduvancheri\"}],\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeDV8jqloAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"lastModifiedOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQeJJXvxa4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\"}"
