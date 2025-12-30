//
//  main.swift
//
//  Created by Mac on 11/12/25.
//

import Foundation
import ArgumentParser
import IPAddress2Geolocation

// Optimization for reduce the size of the original CSV file
//
// - Remove the double quotes.
//
// cat IP-COUNTRY.csv | tr -d \" > IP-COUNTRY.csv
//
// - Remove the unnused alpha3 field
//
// cat IP-COUNTRY.cvs | sed -E 's/,[A-Z][A-Z][A-Z],/,/' > IP-COUNTRY.csv

// MARK: Converter
struct Converter: ParsableCommand {
    @Argument(help: "The path of the file to parse (default: `\\.IP-COUNTRY.csv`).")
    var input: String?
    @Option(help: "The directory path to save the parse results (default: `\\.`) .")
    var output: String?
    @Flag(help: "Decompress the input file with lzma (`.7z`).")
    var decompress: Bool = false
    @Flag(help: "Compress the input file with lzma (`.7z`).")
    var compress: Bool = false
    
    /// Compress the input `csv`file .
    /// 
    /// - Parameter inputFile: input `csv` file.
    /// - Parameter outputDirectory: URL?
    ///
    /// - Note
    /// If the outputDirectory is nil the output  `.7z` file will be in the same directory and with the same name that the original file.
    ///
    /// - Returns: Output file URL
    fileprivate func compressFile(inputFile: URL,  outputFile: URL) -> Bool {
        let decompressing = Date()
        if Compressor.compress(from: inputFile, output: outputFile) {
            print("The input file `\(inputFile.lastPathComponent)` has been compressed into `\(outputFile.lastPathComponent)` sucessfully in \(Date().timeIntervalSince(decompressing)).")
            return true
        }
        return false
    }
    /// Compress the input `.7z`file .
    /// 
    /// - Parameter inputFile: Input `.7z` file.
    /// - Parameter outputDirectory: URL?
    ///
    /// - Note
    ///   If the outputDirectory is nil the output  `.csv` file will be in the same directory and with the same name that the original file.
    ///
    /// - Returns: Output file URL
    fileprivate func decompressFile(inputFile: URL, outputFile: URL) -> Bool {
        let compressing = Date()
        if Compressor.decompress(from: inputFile, output: outputFile) {
            print("The input file `\(inputFile.lastPathComponent)` has been decompressed into `\(outputFile.lastPathComponent)` sucessfully in \(Date().timeIntervalSince(compressing)).")
            return true
        }
        return false
    }
    
    /// Perform the data conversion
    ///
    /// - Parameter inputFile:  Input `.cvs` file.
    ///
    fileprivate func performConversion(inputFile: URL, outputDirectory: URL) {
        let converter = IPAddressRangesConverter()
        print("Loading conversion data.")
        if converter.load(from: inputFile) {
            print("Conversion data has been loaded sucessfully.")
            let converting = Date()
            if converter.runAndSave(to: outputDirectory) {
                print("Conversion has been completed sucessfully in \(Date().timeIntervalSince(converting))")
            } else {
                print("Unable to complete the conversion.")
            }
        } else {
            print("Conversion failed. Unexpected error.")
        }
    }

    mutating func run() throws {

        var inputFile: URL
        if let input = input {
            inputFile = URL(fileURLWithPath: input)
        } else {
            // No input file was selected
            inputFile = URL.currentDirectory().appendingPathComponent("IP-COUNTRY.csv")
            if decompress {
                inputFile = URL.currentDirectory().appendingPathComponent("IP-COUNTRY.7z")
            }
        }
        
        // Check if the input file exist in disk
        if !FileManager.default.fileExists(atPath: inputFile.path) {
            throw ValidationError("Input file `\(inputFile)` not found.")
        }
        
        var outputDirectory: URL
        if let output = output {
            outputDirectory = URL(fileURLWithPath: output, isDirectory: true)
            // Create the output directory if needed
            if FileManager.default.createDirectoryIfNeeded(directory: outputDirectory.path) {
                print("Output directory `\(outputDirectory)` is valid.")
            } else {
                // Check if the output directory exist in disk
                throw ValidationError("Invalid output directory `\(outputDirectory)`.")
            }
        } else {
            outputDirectory = inputFile.deletingLastPathComponent()
        }
        
        var outputFile: URL?
        if compress {
            outputFile = outputDirectory.appendingPathComponent("IP-COUNTRY.7z")
        } else if decompress {
            outputFile = outputDirectory.appendingPathComponent("IP-COUNTRY.csv")
        } else {
            // Without output file
        }
        
        // Compress input file if needed
        if compress {
            // $0 INPUT.csv --compress
            if let outputFile = outputFile {
                print("Compressing `\(inputFile)` with lzma to `\(outputFile)` started.")
                if compressFile(inputFile: inputFile, outputFile: outputFile) {
                    print("The input file `\(inputFile.lastPathComponent)` has been compressed sucessfully `\(outputFile.lastPathComponent)`.")
                }
            }
        // Decompress input file if needed
        } else if decompress {
            // $0 INPUT.7z --decompress
            if let outputFile = outputFile {
                print("Decompressing `\(inputFile)` with lzma to `\(outputFile)` started.")
                
                if decompressFile(inputFile: inputFile,
                                  outputFile: outputFile) {
                    performConversion(inputFile: outputFile, outputDirectory: outputDirectory)
                }
            }
        }  else {
            // $0 \.IP-COUNTRY.csv \.
            print("Conversion of `\(inputFile)` to `\(outputDirectory)` started.")
            performConversion(inputFile: inputFile, outputDirectory: outputDirectory)
        }
    }
}

Converter.main()
