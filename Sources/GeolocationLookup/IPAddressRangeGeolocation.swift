//
//  AddressRangeGeolocation.swift
//
//  Created by Mac on 18/9/24.
//

import Foundation

/// A type that can print a geo location from a IP address string .
protocol IPAddressPrintable {
    ///  Print a geo location from a IP address string
    ///
    /// - Parameter address: IP address string
    func printAddress(for address: String)
}

// MARK: AddressRangeGeolocation object
/// Locate the address range, country and country subdivision for a IP address
class IPAddressRangeGeolocation: IPAddressConverterBE {
    private var locator: IPAddressRangeLocatorProtocol
    
    init(locator: IPAddressRangeLocatorProtocol = IPAddressRangeBinaryFileLocator()) {
        
        // Initialize the LocatorProtocol interface
        self.locator = locator
        
        super.init()
        
        // Prepare the infrastructure
        if !load() {
            print("Unable to prepare the basic infrastructure.")
        }
        // Test that the infrastructure works
        printAddress(for: "102.130.125.86")
    }
}

// MARK: CustomDebugStringConvertible
extension IPRangeLocation: CustomDebugStringConvertible {
    var debugDescription: String {
        let converter = IPAddressConverterBE()
        let start = converter.numberIPToStringIP(number: UInt32(bigEndian: start))
        let end = converter.numberIPToStringIP(number: UInt32(bigEndian: end))
        let country = Countries.shared.names[alpha2] ?? ""
        let flag = Countries.flag(from: alpha2)
        return "\(subdiv) - \(country) [\(flag)] (\(start) - \(end))"
    }
}

// MARK: AddressRangeGeolocation
extension IPAddressRangeGeolocation: IPAddressPrintable {
    /// Print a geo location from a IP address string
    ///
    /// - Parameter address: IP address string
    func printAddress(for address: String) {
        print("Printing geo location record for: \(address)")
        
        if let addressUInt32 = stringIPToIPNumber(string: address) {
            if let location = locate(from: UInt32(bigEndian: addressUInt32)) {
                print(location)
            }
        }
    }
}

// MARK: LocatorProtocol
extension IPAddressRangeGeolocation: IPAddressRangeLocatorProtocol {
    
    func locate(from address: UInt32) -> IPRangeLocation? {
        guard address > 0 else {
            return nil
        }
        // Delegate in the inner locator
        return locator.locate(from: address)
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
    func load() -> Bool {
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
