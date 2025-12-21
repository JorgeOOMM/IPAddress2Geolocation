//
//  IPAddressable.swift
//  IPAddress2City
//
//  Created by Mac on 20/12/25.
//

// MARK: IPAddressable - Big endian
public protocol IPAddressable {
    /// Convert IP address string to UInt32
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    static func toUInt32(string: String) throws -> UInt32
    /// Convert IP address UInt32 to String
    ///
    /// - Parameter number:Address number
    ///
    /// - Returns: String
    ///
    static func toString(number: UInt32) throws -> String
}

// MARK: IPAddressable - Implementation
extension IPAddressable {
    /// Convert IP address string to UInt32 network endian
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    public static func toUInt32(string: String) throws -> UInt32 {
        let octets: [UInt32] = string.split(separator: ".").compactMap { UInt32($0) }
        guard octets.count == 4 else {
            throw IPAddress2CityError.parameterError
        }
        var numValue: UInt32 = 0
        for index in stride(from: 0, through: 3, by: 1) {
            numValue += octets[index] << (index * 8)
        }
        return numValue
    }
    
    /// Convert IP address UInt32 in network endian to String
    ///
    /// - Parameter number:Address number
    ///
    /// - Returns: String
    ///
    public static func toString(number: UInt32) throws -> String {
        guard number > 0 else {
            throw IPAddress2CityError.parameterError
        }
        let octet0 = number & 0xFF
        let octet1 = (number >> 8) & 0xFF
        let octet2 = (number >> 16) & 0xFF
        let octet3 = (number >> 24) & 0xFF
        
        return "\(octet0).\(octet1).\(octet2).\(octet3)"
    }
}

class IPAddressRange: IPAddressable {
    
    public static func isBogon(string: String) throws -> Bool {
        let bogonRanges = [
            "0.0.0.0/8", // Current network (RFC 1122)
            "10.0.0.0/8", // Private network
            "127.0.0.0/8", // Loopback
            "169.254.0.0/16", // Link-local
            "172.16.0.0/12", // Private network
            "192.0.0.0/24", // Reserved (RFC 6890)
            "192.0.2.0/24", // Documentation (RFC 6890)
            "192.88.99.0/24", // 6to4 relay anycast (RFC 3068)
            "192.168.0.0/16", // Private network
            "198.18.0.0/15", // Network benchmark tests (RFC 2544)
            "198.51.100.0/24", // Documentation (RFC 6890)
            "203.0.113.0/24", // Documentation (RFC 6890)
            "224.0.0.0/4", // Multicast (RFC 5771)
            "240.0.0.0/4", // Reserved (RFC 1112)
        ]
        
        for range in bogonRanges {
            let cidrComponents = range.split(separator: "/")
            let ipRange = cidrComponents[0]
            let subnetMask = UInt32(cidrComponents[1]) ?? UInt32()
            let ipAddressInt = try toUInt32(string: string)
            let ipRangeInt = try toUInt32(string: string)
            let subnetMaskInt = (0xFFFFFFFF as UInt32) << (32 - subnetMask)
            if (ipAddressInt & subnetMaskInt) == (ipRangeInt & subnetMaskInt) {
                return true
            }
        }
        return false
    }
}
