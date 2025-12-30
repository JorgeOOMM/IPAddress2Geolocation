//
//  IPGeolocation.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 14/12/25.
//

import CoreLocation

// MARK: GeoCoordinate
extension GeoCoordinate {
    public var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}

public protocol IPGeolocationProtocol {
    func location(with address: String) async throws -> GeoCoordinate
}

/// GeoCoordinateLookup is a class that locate a Geocoordinate type from Location Address string
public class IPGeolocation: FileCacheable {
    typealias Handler = (Result<GeoCoordinate, Error>) -> Void
    
    private let geocoder: IPGeolocationCoderProtocol
    // Don't limit the lifetime of the cache entries
    internal lazy var cache = Cache<String, GeoCoordinate>(dateProvider: nil)
    
    public init(geocoder: IPGeolocationCoderProtocol = IPGeolocationCoder()) {
        self.geocoder = geocoder
    }
}
// MARK: GeoCoordinateLookup
extension IPGeolocation: IPGeolocationProtocol {
    public func location(with address: String) async throws -> GeoCoordinate {
        guard !address.isEmpty else {
            throw IPAddress2GeolocationError.parameterError
        }
        if let cached = cache[address] {
            return cached
        }
        let location = try await geocoder.coordinate(with: address)
        self.cache[address] = location
        return location
    }
}
