//
//  IPAddressRangeBinaryFileLocator.swift
//  GeolocationLookup
//
//  Created by Mac on 10/12/25.
//

import Foundation

// MARK: IPAddressRangeBinaryFileLocator
public class IPAddressRangeBinaryFileLocator: IPAddressRangeLocatorProtocol {
    private var subdivs: [Substring] = []
    private var fileHandle: FileHandle = .nullDevice
    private var fileSize: UInt64 = 0
    private let sizeofRange = MemoryLayout<IPRangeLocationIdx>.size
    
    /// Read a binary record for index
    ///
    /// - Parameter index: Int
    ///
    /// - Returns: IPRangeIdx
    ///
    fileprivate func readRecord(index: Int) throws -> IPRangeLocationIdx {
        precondition(self.fileHandle != .nullDevice)
        let offset = UInt64(index * sizeofRange) // Seek to the index
        try fileHandle.seek(toOffset: offset)
        let data = fileHandle.readData(ofLength: sizeofRange) // Read sizeOfRange
        precondition( data.count == sizeofRange)
        let result = data.withUnsafeBytes { buffer in
            buffer.baseAddress?.assumingMemoryBound(to: IPRangeLocationIdx.self).pointee
        }
        guard let result = result else {
            throw GeolocationLookupError.memoryError
        }
        return result
    }
    
    /// Open the country binary file
    fileprivate func openBinaryFile() throws {
        let dataURL =
        URL.documentsDirectoryURL
            .appendingPathComponent(Constants.fileCountry)
            .appendingPathExtension(Constants.fileExtension)
        
        self.fileHandle = try FileHandle(forReadingFrom: dataURL)
        self.fileSize = try fileHandle.seekToEnd()
    }
    
    /// Load the file of subdivisions strings
    fileprivate func loadFileStrings() -> Bool {
        let dataURLSubdivs =
        URL.documentsDirectoryURL
            .appendingPathComponent(Constants.fileSubdivs)
            .appendingPathExtension(Constants.fileExtension)
        
        // The file in Document directory is already decompress
        self.subdivs = fileStringToArray(
            from: dataURLSubdivs,
            compress: false
        )
        return !self.subdivs.isEmpty
    }
    
    /// IPRangeLocationIdx to IPRangeLocation
    ///
    /// - Parameter record: IPRangeLocationIdx
    ///
    /// - Returns: IPRangeLocation
    func recordLocation(from record: IPRangeLocationIdx) throws -> IPRangeLocation {
        guard let alpha2 = Countries.shared.code(for: UInt32(record.alpha2Idx)) else {
            assertionFailure("Unexpected invalid index for alpha2.")
            throw GeolocationLookupError.alpha2IndexError
        }
        let subdiv = self.subdivs[Int(record.subdivIdx)].replacingOccurrences(of: "#", with: " - ")
        return IPRangeLocation(
            start: record.start,
            end: record.end,
            alpha2: alpha2,
            subdiv: subdiv
        )
    }
    // MARK: LocationProtocol
    /// IP addess to IPRange
    ///
    /// - Parameter beIP: Big Endian 32 bits IP address
    /// - Returns: IPRange
    ///
    /// - Note [Algorithm]
    ///
    ///  Calculate the middle element index: mid = start + (end - start) / 2 .
    ///  Compare the value at middle index ( mid ) with the target value.
    ///  If arr[mid] is equal to the target value, return mid (search successful).
    ///  If arr[mid] is less than the target value, set the start to mid + 1 .
    ///
    ///
    public func locate(from address: UInt32) -> IPRangeLocation? {
        var lowIndex = 0
        var highIndex = Int(fileSize) / sizeofRange
        var midIndex = 0
        do {
            while lowIndex <= highIndex {
                midIndex = (Int)((lowIndex + highIndex) / 2)
                let line = try readRecord(index: midIndex)
                // let line = lines[midIndex]
                if address >= line.start && address < line.end {
                    return try recordLocation(from: line)
                } else {
                    if address < line.end {
                        highIndex = midIndex - 1
                    } else {
                        lowIndex = midIndex + 1
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// Load the location information
    ///
    /// - Returns: Bool
    ///
    public func load() -> Bool {
        do {
            try openBinaryFile()
        } catch {
            print(error.localizedDescription)
            return false
        }
        return loadFileStrings()
    }
    
    public init() {
        
    }
}
