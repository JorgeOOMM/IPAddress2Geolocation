//
//  IPAddressConverterTests.swift
//
//  Created by Mac on 7/12/25.
//


import XCTest
@testable import IPAddress2Geolocation

final class IPAddressConverterTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func teststringIPToIPNumber() throws {
        XCTAssert(try IPAddressConverter.toUInt32(string: "127.0.0.1") == UInt32(bigEndian: 2130706433))
        XCTAssert(try IPAddressConverter.toUInt32(string:  "0.0.1.1") == UInt32(bigEndian: 257))
        XCTAssert(try IPAddressConverter.toUInt32(string: "0.0.0.1") == UInt32(bigEndian: 1))
    }
    
    func testnumberIPToStringIP() throws {
        XCTAssert(try IPAddressConverter.toString(number: UInt32(bigEndian: 2130706433)) == "127.0.0.1")
        XCTAssert(try IPAddressConverter.toString(number: UInt32(bigEndian: 257)) == "0.0.1.1")
        XCTAssert(try IPAddressConverter.toString(number: UInt32(bigEndian: 1)) == "0.0.0.1")
    }
}
