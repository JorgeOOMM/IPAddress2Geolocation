//
//  IPAddressable.swift
//  IPAddress2City
//
//  Created by Mac on 20/12/25.
//

// MARK: IPAddressable
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
