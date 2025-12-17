//
//  CountryNames.swift
//
//  Created by Mac on 18/9/24.
//
import Foundation

// swiftlint:disable legacy_objc_type
public final class Countries {
    let locale: Locale
    private var indexes: [String: UInt32] = [:]
    private var countries: [String: String] = [:]
    init(identifier: String) {
        self.locale = Locale(identifier: identifier)
        for (index, code) in NSLocale.isoCountryCodes.enumerated() {
            let id: String = Locale.identifier(fromComponents: [
                NSLocale.Key.countryCode.rawValue: code
            ])
            guard let name = (self.locale as NSLocale).displayName(
                forKey: .identifier,
                value: id
            ) else {
                continue
            }
            countries[code] = name
            indexes[code] = UInt32(index + 1)
        }
    }
    static func flag(from country: String) -> String {
        // The flags start at code point 0x1F1E6. The offset for "A" is 65. 0x1F1E6 - 65 = 127397
        let base: UInt32 = 127397
        var output = ""
        for unicodeScalars in country.uppercased().unicodeScalars {
            if let scalar = UnicodeScalar(base + unicodeScalars.value) {
                output.unicodeScalars.append(scalar)
            }
        }
        return output
    }
    
    public func name(for code: String) -> String? {
        return countries[code]
    }
    public func index(for code: String) -> UInt32? {
        return indexes[code]
    }
    public func code(for index: UInt32) -> String? {
        return indexes.key(from: index)
    }
}

extension Countries {
    nonisolated(unsafe) public static let shared = Countries(identifier: "en_EN")
}

// swiftlint:enable legacy_objc_type
