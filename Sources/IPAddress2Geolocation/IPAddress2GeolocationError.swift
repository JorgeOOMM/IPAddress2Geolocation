//
//  IPAddress2GeolocationError.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 15/12/25.
//

import Foundation

// MARK: IPAddress2GeolocationError
enum IPAddress2GeolocationError: Error {
    case conversionError
    case locationError
    case memoryError
    case alpha2Error
    case parameterError
    case flagError
}
