//
//  IPAddressRangeIteratorTests.swift
//  NetDiagnostics
//
//  Created by Mac on 7/12/25.
//


import XCTest
@testable import IPAddress2Geolocation

final class IPAddressRangeIteratorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIPAddressRangeIterator() throws {
        let asColl = try IPAddressRangeCollection(lower: "0.0.1.0", upper: "0.0.2.0")
        let asArray = Array(asColl!)
        XCTAssert(asArray.count == 257)
        XCTAssert(asArray[0] == "0.0.1.0")
        XCTAssert(asArray[asArray.count - 1] == "0.0.2.0")
        let asDifferentColl = try IPAddressRangeCollection(lower: "0.0.2.0", upper: "0.0.4.0")
        let asDifferentArray = Array(asDifferentColl!)
        XCTAssert(asDifferentArray.count == 513)
        XCTAssert(asDifferentArray[0] == "0.0.2.0")
        XCTAssert(asDifferentArray[asDifferentArray.count - 1] == "0.0.4.0")

        XCTAssert(!asDifferentColl!.elementsEqual(asColl!))
    }
}
