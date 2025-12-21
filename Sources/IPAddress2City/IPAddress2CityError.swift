//
//  IPAddress2CityError.swift
//  IPAddress2City
//
//  Created by Mac on 15/12/25.
//

import Foundation

// MARK: IPAddress2CityError
enum IPAddress2CityError: Error {
    case conversionError
    case locationError
    case memoryError
    case alpha2Error
    case parameterError
    case flagError
}
