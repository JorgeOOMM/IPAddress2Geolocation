//
//  Model.swift
//
//  Created by Mac on 11/12/25.
//

import Foundation

// MARK: IPRange struct (Internet Protocol version 4 (IPv4))
struct IPRange: IPRangeProtocol, Codable {
    var start: UInt32
    var end: UInt32
    var alpha2: String
    var subdiv: String
}

struct IPRangeIdx: IPRangeProtocol {
    var start: UInt32
    var end: UInt32
    var alpha2Idx: UInt32
    var subdivIdx: UInt32
}
