//
//  IPAddressRangesConverter.swift
//  IPAddress2City
//
//  Created by Mac on 9/12/25.
//

import Foundation
import OrderedCollections
import IPAddress2City


// MARK: ConverterProtocol protocol
protocol ConverterProtocol {
    /// The target directory of the conversion
    func load(from url: URL) -> Bool
    func runAndSave(to url: URL) -> Bool
}

// MARK: AddressRangesConverter object
class IPAddressRangesConverter {

    var lineReader: LineReader?
    
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
                    assertionFailure("Unexpected number of slices `\(slices.count)`. Maximun: 5")
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
    
    /// Save the conversion results
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - ranges: [IPRangeLocationIdx]
    ///   - subdivs: [String]
    fileprivate func saveConversion(to url: URL,
                                    ranges: [IPRangeLocationIdx],
                                    subdivs: [String]) -> Bool {
        let dataURL =
        url.appendingPathComponent(Constants.fileCountry)
            .appendingPathExtension(Constants.fileExtension)
        
        let dataURLSubdivs =
        url.appendingPathComponent(Constants.fileSubdivs)
            .appendingPathExtension(Constants.fileExtension)
        
        return arrayToFile(
            array: ranges,
            output: dataURL
        ) && arrayToFileString(
            array: subdivs,
            output: dataURLSubdivs
        )
    }
}

// MARK: ConverterProtocol
extension IPAddressRangesConverter: ConverterProtocol {
    
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
        var ranges = [IPRangeLocationIdx]()
        ranges.reserveCapacity(3192665)
        
        for line in lineReader {
            let item = line.split(separator: ",", maxSplits: 3)
            if let alpha2Idx = Countries.shared.index(for: String(item[2])) {
                var subdivIdx: Int?
                if let result = processSubdiv(subdiv: String(item[3])) {
                    // Add the subdivision line
                    uniqueSubdivs.append(result)
                    // Get the index of the subdivision at the array
                    subdivIdx = uniqueSubdivs.firstIndex(of: result)
                }
                ranges.append(
                    IPRangeLocationIdx(
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
        
        return saveConversion(to: url,
                            ranges: ranges,
                            subdivs: uniqueSubdivs.elements)
    }
    
    /// Load the file to process and prepare for the conversion
    ///
    /// - Returns: Bool
    ///
    /// - Parameter url: File URL to process
    ///
    func load(from url: URL) -> Bool {
        guard let lineReader = LineReader(from: url.path) else {
            print("Unable open file \(url).")
            return false
        }
        //self.lines = ranges(reader: lineReader)
        self.lineReader = lineReader
        return true
    }
}
