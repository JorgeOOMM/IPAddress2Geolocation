//
//  IPAddress2LocationTests.swift
//
//  Created by Mac on 15/12/25.
//


import XCTest
@testable import IPAddress2Geolocation

func xCTAssertThrowsError<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        XCTFail(message())
    } catch {
        errorHandler(error)
    }
}

final class IPGeolocationTests: XCTestCase {
    
    let lookup = IPGeolocation(geocoder: IPGeolocationCoder())
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidGeoCoordinate() async throws {
        let geoCoordinate = try await lookup.location(with: "Cape Town (Manenberg) - Western Cape - South Africa" )
        XCTAssert(geoCoordinate.name == "Manenberg")
        XCTAssert(geoCoordinate.latitude == -33.9808841)
        XCTAssert(geoCoordinate.longitude == 18.5562717)
    }
    
    
    func testInvalidGeoCoordinate() async throws {
        await xCTAssertThrowsError(try await lookup.location(with: ""))
    }
}
