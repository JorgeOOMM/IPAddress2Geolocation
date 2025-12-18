//
//  IPAddressConverter.swift
//  IPAddress2City
//
//  Created by Mac on 12/12/25.
//

// MARK: IPAddressable
public protocol IPAddressable {
    /// Convert IP address string to UInt32
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    func stringIPToIPNumber(string: String) -> UInt32
    /// Convert IP address UInt32 to String
    ///
    /// - Parameter number:Address number
    ///
    /// - Returns: String
    ///
    func numberIPToStringIP(number: UInt32) -> String
}


// According to standards set forth in Internet Engineering Task Force (IETF) document RFC-1918, the following IPv4 address ranges are reserved by the IANA for private internets, and are not publicly routable on the global internet:
//
// 10.0.0.0/8 IP addresses: 10.0.0.0 – 10.255.255.255
// 172.16.0.0/12 IP addresses: 172.16.0.0 – 172.31.255.255
// 192.168.0.0/16 IP addresses: 192.168.0.0 – 192.168.255.255


extension IPAddressable {
    
    public func isBogonIPAddress(string: String) -> Bool {
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
            let ipAddressInt = stringIPToIPNumber(string: string)
            let ipRangeInt = stringIPToIPNumber(string: string)
            let subnetMaskInt = (0xFFFFFFFF as UInt32) << (32 - subnetMask)
            if (ipAddressInt & subnetMaskInt) == (ipRangeInt & subnetMaskInt) {
                return true
            }
        }
        return false
    }
}


// MARK: IPAddressConverter - Little endian
public class IPAddressConverterLE: IPAddressable {
    /// Convert IP address string to UInt32 host endian
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    public func stringIPToIPNumber(string: String) -> UInt32 {
        let octets: [UInt32] = string.split(separator: ".").compactMap { UInt32($0) }
        guard octets.count == 4 else {
            return UInt32()
        }
        var numValue: UInt32 = 0
        for index in stride(from: 3, through: 0, by: -1) {
            numValue += octets[3 - index] << (index * 8)
        }
        return numValue
    }
    
    /// Convert IP address UInt32 in host endian to String
    ///
    /// - Parameter number:Address number
    ///
    /// - Returns: String
    ///
    public func numberIPToStringIP(number: UInt32) -> String {
        guard number > 0 else {
            return ""
        }
        let octet3 = number & 0xFF
        let octet2 = (number >> 8) & 0xFF
        let octet1 = (number >> 16) & 0xFF
        let octet0 = (number >> 24) & 0xFF
        
        return "\(octet0).\(octet1).\(octet2).\(octet3)"
    }
}

// MARK: IPAddressConverterBE - Big endian
public class IPAddressConverterBE: IPAddressable {
    
    /// Convert IP address string to UInt32 network endian
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    public func stringIPToIPNumber(string: String) -> UInt32 {
        let octets: [UInt32] = string.split(separator: ".").compactMap { UInt32($0) }
        guard octets.count == 4 else {
            return UInt32()
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
    ///
    public func numberIPToStringIP(number: UInt32) -> String {
        guard number > 0 else {
            return ""
        }
        let octet0 = number & 0xFF
        let octet1 = (number >> 8) & 0xFF
        let octet2 = (number >> 16) & 0xFF
        let octet3 = (number >> 24) & 0xFF
        
        return "\(octet0).\(octet1).\(octet2).\(octet3)"
    }
}
