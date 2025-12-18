//
//  IPAddressGeolocationLookup.swift
//  IPAddressGeolocationLookup
//
//  Created by Mac on 11/12/25.
//
import Foundation

// MARK: FileCacheable
/// IPAddress2City is a class thast locate a IPRange types from IP Address string
public class IPAddressGeolocationLookup: FileCacheable {
    
    typealias Handler = (Result<IPRangeLocation, Error>) -> Void
    
    private let locator: IPAddressable&IPAddressRangeLocatorProtocol&IPAddressPrintable
    // Don't limit the lifetime of the cache entries
    internal lazy var cache = Cache<String, IPRangeLocation>(dateProvider: nil)
    
    public init(locator: IPAddressable&IPAddressRangeLocatorProtocol&IPAddressPrintable = IPAddressRangeGeolocation()) {
        self.locator = locator
    }
}

// MARK: IPAddressGeolocationLookup
extension IPAddressGeolocationLookup {
    func location(with address: String) throws -> IPRangeLocation {
        guard !address.isEmpty else {
            print("Empty parameter address error.")
            throw IPAddress2CityError.parameterError
        }
        if let cached = cache[address] {
            // Cache hit
            return cached
        }
        
        let addressUInt32 = locator.stringIPToIPNumber(string: address)
        guard addressUInt32 > 0 else {
            print("Conversion of address \(address) failed.")
            throw IPAddress2CityError.conversionError
        }
        if let location = locator.locate(from: UInt32(bigEndian: addressUInt32)) {
            self.cache[address] = location
            return location
        } else {
            print("The address \(address) not found in location database.")
            throw IPAddress2CityError.locationError
        }
    }
}

// MARK: IPAddressPrintable
extension IPAddressGeolocationLookup: IPAddressPrintable {
    ///  Print a geo location from a IP address string
    ///
    /// - Parameter address: IP address string
    public func printAddress(for address: String) {
        locator.printAddress(for: address)
    }
}
// MARK: IPAddressGeolocationLookup
extension IPAddressGeolocationLookup {
    public func start(with location: IPRangeLocation) -> String {
        locator.numberIPToStringIP(number: UInt32(bigEndian: location.start))
    }
    public func end(with location: IPRangeLocation) -> String {
        locator.numberIPToStringIP(number: UInt32(bigEndian: location.end))
    }
    public func country(with location: IPRangeLocation) -> String {
        guard !location.alpha2.isEmpty else {
            return ""
        }
        guard let country = Countries.shared.name(for: location.alpha2) else {
            return ""
        }
        return country
    }
    public func subdivision(with location: IPRangeLocation) -> String {
        location.subdiv
    }
    public func flag(with location: IPRangeLocation) -> String {
        guard !location.alpha2.isEmpty else {
            return ""
        }
        return Countries.flag(from: location.alpha2)
    }
}
// MARK: IPAddressGeolocationLookup
extension IPAddressGeolocationLookup {
    public func country(for address: String) -> String? {
        do {
            let range = try location(with: address)
            return self.country(with: range)
        } catch {
            return nil
        }
    }
    public func start(for address: String) -> String? {
        do {
            let range = try location(with: address)
            return self.start(with: range)
        } catch {
            return nil
        }
    }
    public func end(for address: String) -> String? {
        do {
            let range = try location(with: address)
            return self.end(with: range)
        } catch {
            return nil
        }
    }
    public func subdivision(for address: String) -> String? {
        do {
            let range = try location(with: address)
            return self.subdivision(with: range)
        } catch {
            return nil
        }
    }
    public func flag(for address: String) -> String? {
        do {
            let range = try location(with: address)
            return self.flag(with: range)
        } catch {
            return nil
        }
    }
}
