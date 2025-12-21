//
//  IPAddressRangeLocatorProtocol.swift
//  IPAddress2City
//
//  Created by Mac on 12/12/25.
//

// MARK: IPAddressStringRangeLocatorProtocol
/// Protocol for locate the `IPRangeLocation` location for a ip `address` string
public protocol IPAddressStringRangeLocatorProtocol {
    /// Find the location for a netword address string
    ///
    /// - Parameter address:IP address rtring
    ///
    /// - Returns: IPRangeLocation
    ///
    func locate(with address: String) throws -> IPRangeLocation
}

// MARK: IPAddressRangeLocatorProtocol
/// Protocol for locate the `IPRangeLocation` location for a ip `address` UInt32
public protocol IPAddressRangeLocatorProtocol {
    /// Find the location for a netword address
    ///
    /// - Note IP (Internet Protocol) uses big-endian byte order, also known as network byte order
    ///
    /// - Parameter address:UInt32 address in network byte order
    ///
    /// - Returns: IPRangeLocation?
    ///
    func locate(from address: UInt32) -> IPRangeLocation?
}

// MARK: IPAddressRangeLocatorProtocol protocol
public protocol LocatorProtocol: IPAddressRangeLocatorProtocol {
    /// Load the location information
    ///
    /// - Returns: Bool
    ///
    func load() -> Bool
}
