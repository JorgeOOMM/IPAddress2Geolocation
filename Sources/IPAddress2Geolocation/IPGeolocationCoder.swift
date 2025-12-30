//
//  IPGeolocationCoder.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 14/12/25.
//

import CoreLocation

// MARK: GeocoderProtocol
public protocol IPGeolocationCoderProtocol {
    /// Get the GeoCoordinate from a country location.
    /// For example country state, country province, country subdivision
    ///
    /// - Parameter address: String
    ///
    /// - Returns: GeoCoordinate
    ///
    func coordinate(with address: String) async throws -> GeoCoordinate
}

// MARK: Geocoder: GeocoderProtocol
public struct IPGeolocationCoder: IPGeolocationCoderProtocol {
    typealias Handler = (Result<GeoCoordinate, Error>)
    private func geocodeIPAddress(
        with address: String,
        completion: @escaping (Handler) -> Void
    ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            }
            if let placemark = placemarks?.first {
                if let location = placemark.location {
                    // TODO: Use the rest of usefull fields from CLPlacemark object
                    let coordinate = GeoCoordinate(
                        name: placemark.name ?? "",
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    completion(.success(coordinate))
                }
            }
        }
    }
    
    public init() {
        
    }
    
    /// Get the GeoCoordinate from a country location.
    /// For example country state, country province, country subdivision
    ///
    /// - Parameter address: String
    ///
    /// - Returns: GeoCoordinate
    ///
    public func coordinate(with address: String) async throws -> GeoCoordinate {
        try await withCheckedThrowingContinuation { continuation in
            geocodeIPAddress(with: address) { result in
                switch result {
                case .success(let coordinates):
                    continuation.resume(returning: coordinates)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

