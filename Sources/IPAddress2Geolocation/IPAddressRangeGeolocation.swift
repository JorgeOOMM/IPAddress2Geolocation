//
//  AddressRangeGeolocation.swift
//
//  Created by Mac on 18/9/24.
//

import Foundation

/// A type that can print a geo location from a IP address string .
public protocol IPAddressPrintable {
    ///  Print a geo location from a IP address string
    ///
    /// - Parameter address: IP address string
    func printAddress(for address: String) throws
}

// MARK: AddressRangeGeolocation object
/// Locate the address range, country and country subdivision for a IP address
public class IPAddressRangeGeolocation {
    private var locator: LocatorProtocol
    
    public init(locator: LocatorProtocol = IPAddressRangeBinaryFileLocator()) {
        
        // Initialize the LocatorProtocol interface
        self.locator = locator
        
        // Prepare the infrastructure
        if !load() {
            print("Unable to prepare the basic infrastructure.")
        }
        // Test that the infrastructure works
        try? printAddress(for: "102.130.125.86")
    }
}

// MARK: CustomDebugStringConvertible
extension IPRangeLocation: CustomDebugStringConvertible {
    public var debugDescription: String {

        do {
            let start = try IPAddressConverterBE.toString(number: UInt32(bigEndian: start))
            let end = try IPAddressConverterBE.toString(number: UInt32(bigEndian: end))
            let country = Countries.shared.name(for:alpha2) ?? ""
            let flag = Countries.flag(from: alpha2)
            return "\(subdiv) - \(country) [\(flag)] (\(start) - \(end))"
        } catch {
            return ""
        }
    }
}

// MARK: AddressRangeGeolocation
extension IPAddressRangeGeolocation: IPAddressPrintable {
    /// Print a geo location from a IP address string
    ///
    /// - Parameter address: IP address string
    public func printAddress(for address: String) throws {
        print("Printing geo location record for: \(address)")
        
        let addressUInt32 = try IPAddressConverterBE.toUInt32(string: address)
        guard addressUInt32 > 0 else {
            return
        }
        if let location = location(from: UInt32(bigEndian: addressUInt32)) {
            print(location)
        }
    }
}

// MARK: LocatorProtocol
extension IPAddressRangeGeolocation: IPAddressRangeLocatorProtocol {
    
    public func location(from address: UInt32) -> IPRangeLocation? {
        guard address > 0 else {
            return nil
        }
        // Delegate in the inner locator
        return locator.location(from: address)
    }
    
    /// Decompresing the binary files from Resource directory to Documents directory if not exist
    ///
    /// - Parameters:
    ///   - fileName: String
    ///   - withExtension: String
    ///
    /// - Returns: Bool
    ///
    fileprivate func copyResourcesIfNeeded(fileName: String, withExtension: String) -> Bool {
        let path = URL.documentsDirectoryURL.appendingPathComponent("\(fileName).\(withExtension)")
        var result = true
        if !FileManager.default.fileExists(atPath: path.path) {
            // Decompress the file
            if !Compressor.decompressFromResources(
                fileName: fileName,
                withExtension: withExtension,
                output: path
            ) {
                result = false
            }
        }
        return result
    }
    
    /// Load the needed resources
    ///
    /// - Returns: Bool
    ///
    public func load() -> Bool {
        // Copy the bundle resouces needed
        
        if copyResourcesIfNeeded(
            fileName: Constants.fileCountry,
            withExtension: Constants.fileExtension
        ) &&
            copyResourcesIfNeeded(
                fileName: Constants.fileSubdivs,
                withExtension: Constants.fileExtension
            ) {
            // Delegating the locator loader
            return self.locator.load()
        }
        return true
    }
}
