//
//  Array+Data.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 9/12/25.
//
import Foundation

/// convertToArray
///
/// - Parameter data: Data
/// - Returns: [T]
///
func convertToArray<T>(from data: Data) -> [T] {
    let capacity = data.count / MemoryLayout<T>.size
    let result = [T](unsafeUninitializedCapacity: capacity) { pointer, copiedCount in
        let lengthWritten = data.copyBytes(to: pointer)
        copiedCount = lengthWritten / MemoryLayout<T>.size
        assert(copiedCount == capacity)
    }
    return result
}
/// convertToData
///
/// - Parameter array: [T]
/// - Returns: Data
///
func convertToData<T>(from array: [T]) -> Data {
    var arrayPointer: UnsafeBufferPointer<T>?
    array.withUnsafeBufferPointer { arrayPointer = $0 }
    guard let arrayPointer = arrayPointer else {
        return Data()
    }
    return Data(buffer: arrayPointer)
}

// func writeBytesFrom<T>(array: [T], toFile url: URL) throws -> Bool {
//    try withUnsafePointer(to: array) { pointer in
//        let data = Data(bytes: pointer, count: array.count * MemoryLayout<T>.stride)
//        try data.write(to: url, options: .atomic)
//    }
//    return true
// }

///  Array  to file Data
///
///  - Note
///   - The array cant contains references to objects; like String...etc
///
///  - Parameters:
///   - array: [T]]
///   - url: URL
///   - compress: Bool
///  - Throws: description
///
public func arrayToFile<T>(array: [T], output url: URL, compress: Bool = true) -> Bool {
    let data = convertToData(from: array)
    if compress {
        if let result = Compressor.compress(content: data) {
            return DataFile.write(output: url, data: result)
        }
    } else {
        return DataFile.write(output: url, data: data)
    }
    return false
}

///  File data to Array
///
/// - Parameters:
///   - url: URL
///   - compress: Bool
///
/// - Throws: description
/// - Returns: [T]
///
public func fileToArray<T>(from url: URL, compress: Bool = true) -> [T] {
    if let data = DataFile.read(from: url) {
        if compress {
            if let result = Compressor.decompress(content: data) {
                return convertToArray(from: result)
            }
        } else {
            return convertToArray(from: data)
        }
    }
    return []
}

/// Array of Strings to file separated by newLine
/// 
/// - Parameters:
///   - array: [String]
///   - url: URL
///   - compress: Bool
/// 
/// - Returns: Bool
///
public func arrayToFileString(array: [String], output url: URL, compress: Bool = true) -> Bool {
    let string = array.joined(separator: "\n")
    if let data = string.data(using: .ascii) {
        if compress {
            if let result = Compressor.compress(content: data) {
                return DataFile.write(output: url, data: result)
            }
        } else {
            return DataFile.write(output: url, data: data)
        }
    }
    return false
}
///  Array of Substring from file separated by newLine
///
/// - Parameters:
///   - url: URL
///   - compress: Bool
///
/// - Returns: [Substring]
///
public func fileStringToArray(from url: URL, compress: Bool = true) -> [Substring] {
    if let data = DataFile.read(from: url) {
        if compress {
            if let result = Compressor.decompress(content: data) {
                if let string = String(data: result, encoding: .ascii) {
                    return string.split(separator: "\n")
                }
            }
        } else {
            if let string = String(data: data, encoding: .ascii) {
                return string.split(separator: "\n")
            }
        }
    }
    return []
}
