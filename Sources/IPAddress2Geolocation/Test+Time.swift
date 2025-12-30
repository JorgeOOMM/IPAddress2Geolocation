//
//  Test+Time.swift
//  IPAddress2Geolocation
//
//  Created by Mac on 12/12/25.
//

import Foundation

func timeTest( _ function: () -> Void) -> (Double) {
    let start = Date()
    function()
    let end = Date()
    let time = end.timeIntervalSince(start)
    return (time)
}
func test( _ function: () -> Void) {
    let timer = timeTest {
        function()
    }
    print("\(timer * 1000.0) ms")
}
// Example
// func testAll(title: String, listOfStrings: [String]) {
//     let result = listOfStrings.reduce(0) { accumulation, string in
//         accumulation + tests(string) {
//              processItem(string)
//             }
//         }
//     }
//     print("[\(title)] \(result) secs")
// }

func tests(_ nane: String, _ function: () -> Void) -> Double {
    let timer = timeTest {
        function()
    }
    return timer
}
