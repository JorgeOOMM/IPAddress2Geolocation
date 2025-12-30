//
//  URL+Extensions.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 16/12/25.
//


import Foundation

extension URL {
    static var documentsDirectoryURL: URL {
        if #available(iOS 16, *) {
            return URL.documentsDirectory
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
    }
}
