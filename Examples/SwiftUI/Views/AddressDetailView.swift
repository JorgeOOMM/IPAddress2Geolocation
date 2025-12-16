//
//  AddressDetailView.swift
//  GeolocationLookup
//
//  Created by Mac on 14/12/25.
//

import CoreLocation
import MapKit
import SwiftUI
import GeolocationLookup

// MARK: MapLocation
struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D {
    static let newYork: Self = .init(
        latitude: 40.730610,
        longitude: -73.935242
    )
}

// MARK: AddressDetailView
struct AddressDetailView: View {
    let address: AddressElement
    @State private var location = MapLocation(name: "New York", coordinate: .newYork)
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: .newYork,
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    private let coordinateLookup = GeoCoordinateLookup()
    var body: some View {
        VStack {
            Divider()
            Text(address.address)
            Text(address.start)
            Text(address.end)
            HStack {
                Text(address.country)
                Text(address.flag)
            }
            Text(address.subdiv)
            Divider()
            Map(position: $position, interactionModes: .all) {
                Marker(coordinate: location.coordinate) {
                    Label(location.name, systemImage: "mappin")
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let coordinate = try await coordinateLookup.location(with: address.locationName)
                    // Used the default name in case that the original name are unavailable
                    let name = coordinate.name.isEmpty ? address.locationName : coordinate.name
                    self.location = MapLocation(
                        name: name,
                        coordinate: coordinate.location
                    )
                    self.position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: coordinate.location,
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
