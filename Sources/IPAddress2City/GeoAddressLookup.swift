//
//  GeoAddressLookup.swift
//  GeoAddressLookup
//
//  Created by Mac on 11/12/25.
//
import Foundation



// MARK: GeoAddressLookup: FileCacheable
/// GeoAddressLookup is a class thast locate a IPRange types from IP Address string
public class GeoAddressLookup: FileCacheable {
    
    typealias Handler = (Result<IPRangeLocation, Error>) -> Void
    
    private let locator: IPAddressRangeLocatorProtocol&IPAddressPrintable
    // Don't limit the lifetime of the cache entries
    internal lazy var cache = Cache<String, IPRangeLocation>(dateProvider: nil)
    
    public init(locator: IPAddressRangeLocatorProtocol&IPAddressPrintable = IPAddressRangeGeolocation()) {
        self.locator = locator
    }
}

// MARK: GeoAddressLookup
extension GeoAddressLookup: IPAddressStringRangeLocatorProtocol {
    
    /// Find the location for a network address string using cached data if available
    ///
    /// - Parameter address:IP address rtring
    ///
    /// - Returns: IPRangeLocation
    ///
    public func location(with address: String) throws -> IPRangeLocation {
        guard !address.isEmpty else {
            print("Empty parameter address error.")
            throw IPAddress2CityError.parameterError
        }
        if let cached = cache[address] {
            // Cache hit
            return cached
        }
        let addressUInt32 = try IPAddressConverterBE.toUInt32(string: address)
        guard addressUInt32 > 0 else {
            print("Conversion of address \(address) failed.")
            throw IPAddress2CityError.conversionError
        }
        if let location = locator.location(from: UInt32(bigEndian: addressUInt32)) {
            self.cache[address] = location
            return location
        } else {
            print("The address \(address) not found in location database.")
            throw IPAddress2CityError.locationError
        }
    }
}


// MARK: IPAddressPrintable
extension GeoAddressLookup: IPAddressPrintable {
    ///  Print a geo location from a IP address string
    ///
    /// - Parameter address: IP address string
    public func printAddress(for address: String) throws {
       try locator.printAddress(for: address)
    }
}

// MARK: GeoAddressLookup
extension GeoAddressLookup {
    public func start(with location: IPRangeLocation) throws -> String {
        try IPAddressConverterBE.toString(number: UInt32(bigEndian: location.start))
    }
    public func end(with location: IPRangeLocation) throws -> String {
        try IPAddressConverterBE.toString(number: UInt32(bigEndian: location.end))
    }
    public func country(with location: IPRangeLocation) throws -> String {
        guard let country = Countries.shared.name(for: location.alpha2) else {
            throw IPAddress2CityError.alpha2Error
        }
        return country
    }
    public func subdivision(with location: IPRangeLocation) -> String {
        location.subdiv
    }
    public func flag(with location: IPRangeLocation) -> String {
        Countries.flag(from: location.alpha2)
    }
}

// MARK: GeoAddressLookup
extension GeoAddressLookup {
    public func country(for address: String) throws -> String {
        let range = try location(with: address)
        return try self.country(with: range)
    }
    public func start(for address: String) throws -> String {
        let range = try location(with: address)
        return try self.start(with: range)
    }
    public func end(for address: String) throws -> String {
        let range = try location(with: address)
        return try self.end(with: range)
    }
    public func subdivision(for address: String) throws -> String {
        let range = try location(with: address)
        return self.subdivision(with: range)
    }
    public func flag(for address: String) throws -> String {
        let range = try location(with: address)
        return self.flag(with: range)
    }
}
