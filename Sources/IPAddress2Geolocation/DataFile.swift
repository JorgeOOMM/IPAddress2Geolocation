//
//  DataFile.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 11/12/25.
//

import Foundation

//
// Simple Data Read and write enum that dont throw exceptions
//

// MARK: DataFile
enum DataFile {
    ///  Read file from URL
    ///
    ///  - Parameters:
    ///  - Parameter url:The file URL to read from
    ///
    ///  - Returns: Data?
    ///
    static func read( from url: URL) -> Data? {
        do {
            let content = try Data(contentsOf: url)
            return content
        } catch {
            print("Unable to read Data from \(url). Error: \(error.localizedDescription)")
        }
        return nil
    }
    ///  Write file to URL
    ///
    ///   - Parameters:
    ///   - Parameter  url: The file URL to write to
    ///   - Parameter  data:  Data
    ///
    /// - Returns: Bool
    static func write(output url: URL, data: Data) -> Bool {
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            return true
        } catch {
            print("Unable to write Data to \(url). Error: \(error.localizedDescription)")
            return false
        }
    }
    
    ///  Write file to Documents
    ///
    /// - Parameters:
    /// - Parameter fileName: The file name to write to
    /// - Parameter data:  Data
    ///
    /// - Returns: Bool
    static func writeToDocuments( fileName: String, data: Data) -> Bool {
        let url = URL.documentsDirectoryURL.appendingPathComponent(fileName)
        return DataFile.write(output: url, data: data)
    }
    
    ///  Read file from Documents
    ///
    ///  - Parameters:
    ///  - Parameter fileName: The file name to read from
    ///
    /// - Returns: Data?
    static func readFromDocuments( fileName: String) -> Data? {
        let url = URL.documentsDirectoryURL.appendingPathComponent(fileName)
        return DataFile.read(from: url)
    }
    
    /// Read file from Resources
    /// 
    ///  - Parameters:
    ///  - Parameter fileName:The file name to read from
    ///  - Parameter withExtension: withExtension
    ///  - Parameter subpath: subpath
    ///  - Parameter bundle: bundle
    /// 
    ///  - Returns: Data?
    static func readFromResources(
        fileName: String,
        withExtension: String? = nil,
        subdirectory subpath: String? = nil,
        bundle: Bundle = .module
    ) -> Data? {
        guard let url = bundle.url(
            forResource: fileName,
            withExtension: withExtension,
            subdirectory: subpath
        )  else {
            print("Unable to locate \(fileName).\(withExtension ?? "") at Bundle (\(bundle)) Resources.")
            return nil
        }
        return DataFile.read(from: url)
    }
}
