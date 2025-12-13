//
//  IPAddressable.swift
//  IPRanges
//
//  Created by Mac on 12/12/25.
//

// MARK: IPAddressable
protocol IPAddressable {
    /// Convert IP address string to UInt32
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    func stringIPToIPNumber(string: String) -> UInt32?
    /// Convert IP address UInt32 to String
    ///
    /// - Parameter number:Address number
    ///
    /// - Returns: String
    ///
    func numberIPToStringIP(number: UInt32) -> String
}

// MARK: IPAddressConverter - Little endian
class IPAddressConverterLE: IPAddressable {
    
    /// Convert IP address string to UInt32 host endian
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    func stringIPToIPNumber(string: String) -> UInt32? {
        let octets: [UInt32] = string.split(separator: ".").compactMap { UInt32($0) }
        guard octets.count == 4 else {
            return nil
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
    func numberIPToStringIP(number: UInt32) -> String {
        "\((number >> 24) & 0xFF).\((number >> 16) & 0xFF).\((number >> 8) & 0xFF).\(number & 0xFF)"
    }
}

// MARK: IPAddressConverterBE - Big endian
class IPAddressConverterBE: IPAddressable {
    
    /// Convert IP address string to UInt32 network endian
    ///
    /// - Parameter string: Address string
    ///
    /// - Returns: UInt32
    ///
    func stringIPToIPNumber(string: String) -> UInt32? {
        let octets: [UInt32] = string.split(separator: ".").compactMap { UInt32($0) }
        guard octets.count == 4 else {
            return nil
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
    func numberIPToStringIP(number: UInt32) -> String {
        "\(number & 0xFF).\((number >> 8) & 0xFF).\((number >> 16) & 0xFF).\((number >> 24) & 0xFF)"
    }
}
