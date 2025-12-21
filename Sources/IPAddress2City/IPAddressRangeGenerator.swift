//
//  AddressRangeGenerator.swift
//
//  Created by Mac on 7/12/25.
//
//  Note: exploding-ipv4-ranges-using-swift
//

import Foundation

// MARK: AddressGenerator
protocol IPAddressGenerator {
    func range(lower: String, upper: String) throws -> [String]
}
// MARK: IPAddressRange
class IPAddressRangeGenerator: IPAddressGenerator {
    func range(lower: String, upper: String) throws -> [String] {
        guard !(lower.isEmpty || upper.isEmpty) else {
            return []
        }
        let lower = try IPAddressConverterLE.toUInt32(string: lower)
        guard lower > 0 else {
            return []
        }
        let upper = try IPAddressConverterLE.toUInt32(string: upper)
        guard upper > 0 else {
            return []
        }
        guard lower < upper else {
            return []
        }
        var ips: [String] = []
        for index in stride(
            from: lower,
            through: upper,
            by: 1
        ) {
            ips.append(try IPAddressConverterLE.toString(number: index))
        }
        return ips
    }
}
