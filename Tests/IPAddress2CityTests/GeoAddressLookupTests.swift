//
//  IPAddress2LocationTests.swift
//
//  Created by Mac on 15/12/25.
//


import XCTest
@testable import IPAddress2Geolocation

extension IPRangeLocation {
    nonisolated(unsafe) static let null = IPRangeLocation(start: 0, end: 0, alpha2: "", subdiv: "")
}

final class IPAddressGeolocationLookupTests: XCTestCase {
    
    let lookup = IPAddress2Location(locator: IPAddressRangeGeolocation())
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidLocation()throws {
        let location = try lookup.locate(with: "102.130.125.86")
        
        let start = try lookup.start(with:location)
        let end = try lookup.end(with:location)
        let country = try lookup.country(with:location)
        let subdivision = lookup.subdivision(with:location)
        let flag = lookup.flag(with:location)
        
        XCTAssert("102.130.114.0" == start)
        XCTAssert("102.130.126.255" == end)
        
        XCTAssert("South Africa" == country)
        XCTAssert("🇿🇦" == flag)
        XCTAssert(subdivision == "Cape Town (Manenberg) - Western Cape")
    }
    
    func testValidStartLocation() throws {
        let location = try lookup.locate(with: "102.130.125.86")
        XCTAssert(try lookup.start(with:location) == "102.130.114.0")
    }
    
    func testValidEndLocation() throws {
        let location = try lookup.locate(with: "102.130.125.86")
        XCTAssert(try lookup.end(with:location) == "102.130.126.255")
    }
    
    func testValidCountryLocation() throws {
        let location = try lookup.locate(with: "102.130.125.86")
        XCTAssert(try lookup.country(with:location) == "South Africa")
    }
    func testValidFlagLocation()throws {
        let location = try lookup.locate(with: "102.130.125.86")
        XCTAssert("🇿🇦" == lookup.flag(with:location))
    }
    
    func testValidSubdivisionLocation() throws {
        let location = try lookup.locate(with: "102.130.125.86")
        XCTAssert(lookup.subdivision(with:location) == "Cape Town (Manenberg) - Western Cape")
    }
    
    func testInvalidLocation() throws {
       
        XCTAssertThrowsError(try lookup.locate(with: ""))
        XCTAssertThrowsError(try lookup.locate(with: "...."))
        XCTAssertThrowsError(try lookup.locate(with: "..1.0."))
        XCTAssertThrowsError(try lookup.locate(with: ".1.0.10."))
        XCTAssertThrowsError(try lookup.locate(with: ".10.1.10."))
        XCTAssertThrowsError(try lookup.locate(with: ".10.0.10."))
        XCTAssertThrowsError(try lookup.locate(with: "10..10.10."))
        XCTAssertThrowsError(try lookup.locate(with: "266.25.10.10."))
        XCTAssertThrowsError(try lookup.locate(with: "0.266.25.10.10"))
    }
    
    func testInvalidEmptyFields() throws {
        XCTAssertThrowsError(try lookup.start(with: .null))
        XCTAssertThrowsError(try lookup.end(with: .null))
        XCTAssertThrowsError(try lookup.country(with: .null))
        XCTAssert(lookup.flag(with: .null).isEmpty)
        XCTAssert(lookup.subdivision(with: .null).isEmpty)
    }
    
    func testInvalidStartField() throws{
        XCTAssertThrowsError(try lookup.start(for: ""))
        XCTAssertThrowsError(try lookup.start(for: "...."))
        XCTAssertThrowsError(try lookup.start(for: "..1.0."))
        XCTAssertThrowsError(try lookup.start(for: ".1.0.10."))
        XCTAssertThrowsError(try lookup.start(for: ".10.1.10."))
        XCTAssertThrowsError(try lookup.start(for: ".10.0.10."))
        XCTAssertThrowsError(try lookup.start(for:"10..10.10."))
        XCTAssertThrowsError(try lookup.start(for:"266.25.10.10."))
        XCTAssertThrowsError(try lookup.start(for:"0.266.25.10.10"))
    }
    func testInvalidEndField() throws{
        XCTAssertThrowsError(try lookup.end(for: ""))
        XCTAssertThrowsError(try lookup.end(for: "...."))
        XCTAssertThrowsError(try lookup.end(for: "..1.0."))
        XCTAssertThrowsError(try lookup.end(for: ".1.0.10."))
        XCTAssertThrowsError(try lookup.end(for: ".10.1.10."))
        XCTAssertThrowsError(try lookup.end(for: ".10.0.10."))
        XCTAssertThrowsError(try lookup.end(for:"10..10.10."))
        XCTAssertThrowsError(try lookup.end(for:"266.25.10.10."))
        XCTAssertThrowsError(try lookup.end(for:"0.266.25.10.10"))
    }
    func testInvalidCountryField()throws {
        XCTAssertThrowsError(try lookup.country(for: ""))
        XCTAssertThrowsError(try lookup.country(for: "...."))
        XCTAssertThrowsError(try lookup.country(for: "..1.0."))
        XCTAssertThrowsError(try lookup.country(for: ".1.0.10."))
        XCTAssertThrowsError(try lookup.country(for: ".10.1.10."))
        XCTAssertThrowsError(try lookup.country(for: ".10.0.10."))
        XCTAssertThrowsError(try lookup.country(for:"10..10.10."))
        XCTAssertThrowsError(try lookup.country(for:"266.25.10.10."))
        XCTAssertThrowsError(try lookup.country(for:"0.266.25.10.10"))
    }
    func testInvalidFlagField()throws {
        XCTAssertThrowsError(try lookup.flag(for: ""))
        XCTAssertThrowsError(try lookup.flag(for: "...."))
        XCTAssertThrowsError(try lookup.flag(for: "..1.0."))
        XCTAssertThrowsError(try lookup.flag(for: ".1.0.10."))
        XCTAssertThrowsError(try lookup.flag(for: ".10.1.10."))
        XCTAssertThrowsError(try lookup.flag(for: ".10.0.10."))
        XCTAssertThrowsError(try lookup.flag(for:"10..10.10."))
        XCTAssertThrowsError(try lookup.flag(for:"266.25.10.10."))
        XCTAssertThrowsError(try lookup.flag(for:"0.266.25.10.10"))
    }
    func testInvalidSubdivField() throws{
        XCTAssertThrowsError(try lookup.subdivision(for: ""))
        XCTAssertThrowsError(try lookup.subdivision(for: "...."))
        XCTAssertThrowsError(try lookup.subdivision(for: "..1.0."))
        XCTAssertThrowsError(try lookup.subdivision(for: ".1.0.10."))
        XCTAssertThrowsError(try lookup.subdivision(for: ".10.1.10."))
        XCTAssertThrowsError(try lookup.subdivision(for: ".10.0.10."))
        XCTAssertThrowsError(try lookup.subdivision(for:"10..10.10."))
        XCTAssertThrowsError(try lookup.subdivision(for:"266.25.10.10."))
        XCTAssertThrowsError(try lookup.subdivision(for:"0.266.25.10.10"))
    }
    
}



