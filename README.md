# IPAddress2Geolocation <a href="https://github.com/jorgeoomm/IPAddress2Geolocation/actions/workflows/test.yml"><img src="https://github.com/jorgeoomm/IPAddress2Geolocation/actions/workflows/test.yml/badge.svg"></a> <a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat"></a> <a href="https://raw.githubusercontent.com/jorgeoomm/IPAddress2Geolocation/master/LICENSE"><img src="https://img.shields.io/badge/license-Apache-black"></a>

IPAddress2Geolocation is a Swift package that geo locate and geo coordinate a internet IP address

## Features

- [x] 1
- [x] 2
- [x] 3
- [x] 4

## Requirements

iOS 13.0+ / macOS 10.15+

## Installation

### SPM

```swift
.package(url: "https://github.com/jorgeoomm/IPAddress2Geolocation.git", from: "0.0.1")
```

## Usage

### Get the geo location of ip address and print the country with the flag

```swift
import IPAddress2Geolocation

let lookup = IPAddress2Location()

guard let var location = try? lookup.location(with: "102.130.125.86") else {
    return
}

print("\(location.country(with: location)) [\(location.flag(with: location))]")

```

### Print a geo location from a IP address string.

```swift
import IPAddress2Geolocation

let lookup = IPAddress2Location()

lookup.printAddress(for: "102.130.125.86")
```

### Get a geo coordinate for a geo location from a IP address string.

```swift
import IPAddress2Geolocation

let lookup = IPAddress2Location()

guard let var location = try? lookup.location(with: "102.130.125.86") else {
    return
}

let coordinateLookup = GeoCoordinateLookup()

let locationName = location.subdiv + " - " + location.country

let coordinate = try await coordinateLookup.location(with: locationName)

print("\(coordinate.name) at longitude:\(coordinate.longitude), latitude:\(coordinate.latitude)")

```


## Principle

IPAddress2Geolocation ...

### How it works

1. 
2. 
3.
4. 
5.

## TODO

- [ ] 
- [ ] 

## Contributing & Support

- Please open an [issue](https://github.com/jorgeoomm/IPAddress2Geolocation/issues/new) or [PR](https://github.com/jorgeoomm/IPAddress2Geolocation/pulls).
- Any bugs or feature requests, please open an [issue](https://github.com/jorgeoomm/IPAddress2Geolocation/issues/new).

## License

Apache
