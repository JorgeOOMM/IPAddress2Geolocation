//
//  IPAddressConverter.swift
//  IPAddress2City
//
//  Created by Mac on 12/12/25.
//


// MARK: IPAddressConverter - Big endian
public class IPAddressConverter: IPAddressable {
    
}


// MARK: IPAddressConverter - Little endian
public class IPAddressConverterLE: IPAddressable {
    /// Convert IP address string to UInt32 host endian
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
    public static func toString(number: UInt32) throws -> String {
        guard number > 0 else {
            throw IPAddress2CityError.parameterError
        }
        let octet3 = number & 0xFF
        let octet2 = (number >> 8) & 0xFF
        let octet1 = (number >> 16) & 0xFF
        let octet0 = (number >> 24) & 0xFF
        
        return "\(octet0).\(octet1).\(octet2).\(octet3)"
    }
}
