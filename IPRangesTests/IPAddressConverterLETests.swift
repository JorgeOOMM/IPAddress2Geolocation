//
//  IPAddressConverterLETests.swift
//  IPRanges
//
//  Created by Mac on 13/12/25.
//

import XCTest
@testable import IPRanges

final class IPAddressConverterLETests: XCTestCase {
    var converterLE = IPAddressConverterLE()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func teststringIPToIPNumber() throws {
        XCTAssert(converterLE.stringIPToIPNumber(string: "127.0.0.1") == 2130706433)
        XCTAssert(converterLE.stringIPToIPNumber(string:  "0.0.1.1") == 257)
        XCTAssert(converterLE.stringIPToIPNumber(string: "0.0.0.1") == 1)
    }
    
    func testnumberIPToStringIP() throws {
        XCTAssert(converterLE.numberIPToStringIP(number: 2130706433) == "127.0.0.1")
        XCTAssert(converterLE.numberIPToStringIP(number: 257) == "0.0.1.1")
        XCTAssert(converterLE.numberIPToStringIP(number: 1) == "0.0.0.1")
    }
}
