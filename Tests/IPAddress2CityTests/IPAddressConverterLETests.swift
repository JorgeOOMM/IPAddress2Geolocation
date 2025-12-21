//
//  IPAddressConverterLETests.swift
//
//  Created by Mac on 13/12/25.
//

import XCTest
@testable import IPAddress2City

final class IPAddressConverterLETests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func teststringIPToIPNumber() throws {
        XCTAssert(try IPAddressConverterLE.toUInt32(string: "127.0.0.1") == 2130706433)
        XCTAssert(try IPAddressConverterLE.toUInt32(string:  "0.0.1.1") == 257)
        XCTAssert(try IPAddressConverterLE.toUInt32(string: "0.0.0.1") == 1)
    }
    
    func testnumberIPToStringIP() throws {
        XCTAssert(try IPAddressConverterLE.toString(number: 2130706433) == "127.0.0.1")
        XCTAssert(try IPAddressConverterLE.toString(number: 257) == "0.0.1.1")
        XCTAssert(try IPAddressConverterLE.toString(number: 1) == "0.0.0.1")
    }
}
