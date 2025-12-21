//
//  IPAddressRangeCollection.swift
//  IPAddress2City
//
//  Created by Mac on 13/12/25.
//

// MARK: IPStringRangeCollection
class IPAddressRangeCollection {
    internal lazy var range = [String]()
    
    init?(lower: String, upper: String, ranger: IPAddressGenerator = IPAddressRangeGenerator()) throws {
        self.range = try ranger.range(lower: lower, upper: upper)
    }
}
// MARK: IPStringRangeCollection: Sequence
extension IPAddressRangeCollection: Sequence {
    public func makeIterator() -> IPAddressRangeIterator {
        IPAddressRangeIterator(self)
    }
}
