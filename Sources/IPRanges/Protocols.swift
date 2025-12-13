//
//  Protocols.swift
//  IPRanges
//
//  Created by Mac on 12/12/25.
//

// MARK: IPRangeProtocol protocol
/// Protocol  describing address  range in network byte order
protocol IPRangeProtocol {
    /// Start of address  range  in network byte order
    var start: UInt32 {get set}
    /// End of address  range in network byte order
    var end: UInt32 {get set}
}

// MARK: LocationProtocol protocol
/// Protocol for locate the `IPRange` location for a ip `address`
protocol LocatorProtocol {
    /// Find the location for a netword address
    ///
    /// - Note IP (Internet Protocol) uses big-endian byte order, also known as network byte order
    ///
    /// - Parameter address:UInt32 address in network byte order
    ///
    /// - Returns: IPRange?
    ///
    func locate(from address: UInt32) -> IPRange?
    /// Load the location information
    ///
    /// - Returns: Bool
    ///
    func load() -> Bool
}
