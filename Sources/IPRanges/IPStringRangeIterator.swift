//
//  IPStringRangeIterator.swift
//  IPRanges
//
//  Created by Mac on 12/12/25.
//

// MARK: IPStringRangeIterator
class IPStringRangeIterator {
    
    private let collection: IPStringRangeCollection
    private var index = 0
    
    init(_ collection: IPStringRangeCollection) {
        self.collection = collection
    }
}
// MARK: IPStringRangeIterator: IteratorProtocol
extension IPStringRangeIterator: IteratorProtocol {
    func next() -> String? {
        defer { index += 1 }
        return index < self.collection.range.count ? collection.range[index] : nil
    }
}

// MARK: IPStringRangeCollection
class IPStringRangeCollection {
    fileprivate lazy var range = [String]()
    
    init(lower: String, upper: String, ranger: IPAddressGenerator = IPAddressRange()) {
        self.range = ranger.range(lower: lower, upper: upper)
    }
}
// MARK: IPStringRangeCollection: Sequence
extension IPStringRangeCollection: Sequence {
    public func makeIterator() -> IPStringRangeIterator {
        IPStringRangeIterator(self)
    }
}
