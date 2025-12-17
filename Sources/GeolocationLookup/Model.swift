//
//  Model.swift
//
//  Created by Mac on 11/12/25.
//

import Foundation

// MARK: IPRangeProtocol protocol
/// Protocol  describing address  range in network byte order
protocol IPRangeLocationProtocol {
    /// Start of address  range  in network byte order
    var start: UInt32 {get}
    /// End of address  range in network byte order
    var end: UInt32 {get}
}

// MARK: IPRangeLocation (Internet Protocol version 4 (IPv4))
public struct IPRangeLocation: IPRangeLocationProtocol, Codable {
    /// Start of address  range  in network byte order
    public let start: UInt32
    /// End of address  range in network byte order
    public let end: UInt32
    public let alpha2: String
    public let subdiv: String
}

// MARK: IPRangeLocationIdx (Internet Protocol version 4 (IPv4))
public struct IPRangeLocationIdx: IPRangeLocationProtocol {
    /// Start of address  range  in network byte order
    public let start: UInt32
    /// End of address  range in network byte order
    public let end: UInt32
    public let alpha2Idx: UInt32
    public let subdivIdx: UInt32
    
    public init(start: UInt32, end: UInt32, alpha2Idx: UInt32, subdivIdx: UInt32) {
        self.start = start
        self.end = end
        self.alpha2Idx = alpha2Idx
        self.subdivIdx = subdivIdx
    }
    
}

// MARK: GeoCoordinate
public struct GeoCoordinate: Codable, Sendable {
    public let name: String
    public let latitude: Double
    public let longitude: Double
}
