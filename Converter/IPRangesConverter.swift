//
//  IPRangesConverter.swift
//  IPRanges
//
//  Created by Mac on 9/12/25.
//

import Foundation
import OrderedCollections


// MARK: ConverterProtocol protocol
protocol ConverterProtocol {
    /// The target directory of the conversion
    func load(from url: URL) -> Bool
    func runAndSave(to url: URL) -> Bool
}

// MARK: IPRangesConverter object
class IPRangesConverter {
    
    //internal var lines: [IPRange] = []
    var lineReader: LineReader?
    
    /// Get the ranges
    ///
    /// - Parameter reader: LineReader
    ///
    /// - Returns: [IPRange]
    //    private func ranges(reader: LineReader) -> [IPRange] {
    //        var ipRanges = [IPRange]()
    //        for line in reader {
    //            let item = line.components( separatedBy: "\",").map { item in
    //                item.replacingOccurrences(of: "\"", with: "")
    //            }
    //            let start = UInt32(item[0]) ?? 0
    //            let end   = UInt32(item[1]) ?? 0
    //            let isoA2 = item[2]
    //            // let isoA3 = item[3]
    //            let place = item[4]
    //            let range = IPRange(
    //                start: start,
    //                end: end,
    //                alpha2: isoA2,
    //                subdiv: place
    //            )
    //            ipRanges.append(range)
    //        }
    //        return ipRanges
    //    }
    
    //    func location(from address: UInt32) -> IPRange? {
    //        var lowIndex = 0
    //        var highIndex = lines.count
    //        var midIndex = 0
    //        while lowIndex <= highIndex {
    //            midIndex = (Int)((lowIndex + highIndex) / 2)
    //            let line = lines[midIndex]
    //            if address >= line.start && address < line.end {
    //                return line
    //            } else {
    //                if address < line.end {
    //                    highIndex = midIndex - 1
    //                } else {
    //                    lowIndex = midIndex + 1
    //                }
    //            }
    //        }
    //        return nil
    //    }
    
    /// prepareSubdiv
    ///
    ///   Fix the elements that contain the character "-", used for separate the country subdivisions
    ///
    /// - Parameter item: String
    ///
    /// - Returns: String
    ///
    fileprivate func prepareSubdiv(subdiv: String) -> String {
        var result = subdiv
        if let slices = result.slice(from: "(", end: ")")?.split(separator: " - ", maxSplits: 3) {
            if slices.count > 1 {
                if slices.count == 2 {
                    result = result.replacingOccurrences(
                        of: "(\(slices[0]) - \(slices[1])",
                        with: "(\(slices[0])-\(slices[1])"
                    )
                } else if slices.count == 3 {
                    result = result.replacingOccurrences(
                        of: "(\(slices[0]) - \(slices[1]) - \(slices[2])",
                        with: "(\(slices[0])-\(slices[1])-\(slices[2])"
                    )
                } else if slices.count == 4 {
                    result = result.replacingOccurrences(
                        of: "(\(slices[0]) - \(slices[1]) - \(slices[2]) - \(slices[3])",
                        with: "(\(slices[0])-\(slices[1])-\(slices[2])-\(slices[3])"
                    )
                } else {
                    assertionFailure()
                }
            }
        }
        return result
    }
    
    /// processSubdiv
    ///
    /// - Parameter place: String
    ///
    /// - Returns: String?
    ///
    fileprivate func processSubdiv(subdiv: String) -> String? {
        // Fix the elements that contain the character "-", used for separate the places
        let newSubdiv = prepareSubdiv(subdiv: subdiv)
        let subdivs = newSubdiv.split(separator: " - ", maxSplits: 2)
        if subdivs.count == 1 {
            // Don't save the country because the alpha2 contains it
            // Case for 1 item
            // Antarctica
        } else if subdivs.count == 2 {
            // Case for 2 items
            // Singapore (Tanjong Pagar) - Singapore
            return String(subdivs[0])
        } else {
            // Case for 3 items
            // Paterna - Valencia - España
            return subdivs[0].appending("#").appending(subdivs[1])
        }
        return nil
    }
    
    fileprivate func saveConversion(to url: URL,
                                    ranges: [IPRangeIdx],
                                    subdivs: [String]) throws {
        let dataURL =
        url.appendingPathComponent("IP-COUNTRY.bin")
        
        let dataURLSubdivs =
        url.appendingPathComponent("COUNTRY-SUBDIVS.bin")
        
        try arrayToFile(
            array: ranges,
            to: dataURL
        )
        
        try arrayToFileString(
            array: subdivs,
            to: dataURLSubdivs
        )
    }
}

// MARK: ConverterProtocol
extension IPRangesConverter: ConverterProtocol {
    
    /// Perform the  conversion and save its results
    ///
    /// - Parameter url: Directory URL
    ///
    /// - Returns: Bool
    ///
    func runAndSave(to url: URL) -> Bool {
        guard let lineReader = lineReader else {
            return false
        }
        var uniqueSubdivs = OrderedSet<String>()
        uniqueSubdivs.reserveCapacity(128171)
        var ranges = [IPRangeIdx]()
        ranges.reserveCapacity(3192665)
        
        for line in lineReader {
            let item = line.split(separator: ",", maxSplits: 4)
            //.map { item in
            //    item.replacingOccurrences(of: "\"", with: "")
            //}
            //assert(item.count == 5)
            if let alpha2Idx = Countries.shared.indexes[String(item[2])] {
                var subdivIdx: Int?
                if let result = processSubdiv(subdiv: String(item[4])) {
                    // Add the subdivision line
                    uniqueSubdivs.append(result)
                    // Get the index of the subdivision at the array
                    subdivIdx = uniqueSubdivs.firstIndex(of: result)
                }
                ranges.append(
                    IPRangeIdx(
                        start: UInt32(item[0]) ?? 0,
                        end: UInt32(item[1]) ?? 0,
                        alpha2Idx: alpha2Idx,
                        subdivIdx: UInt32(subdivIdx ?? 0xffffffff)
                    )
                )
            } else {
                assertionFailure("The alpha2 code \(item[2]) it not valid index.")
                return false
            }
        }
        
        do {
            // Save the conversion result
            try saveConversion(to: url,
                               ranges: ranges,
                               subdivs: uniqueSubdivs.elements)
        } catch {
            print("Unable to save the conversion result. Error: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    /// Load the file to process and prepare for the conversion
    ///
    /// - Returns: Bool
    ///
    /// - Parameter url: File URL to process
    ///
    func load(from url: URL) -> Bool {
        guard let lineReader = LineReader(from: url.path()) else {
            print("Unable open file \(url).")
            return false
        }
        //self.lines = ranges(reader: lineReader)
        self.lineReader = lineReader
        return true
    }
}
