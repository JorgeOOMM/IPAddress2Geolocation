//
//  ContentView.swift
//  IPRange
//
//  Created by Mac on 8/12/25.
//

import SwiftUI

struct GridCellView: View {
    var value: String
    var body: some View {
        Text(value)
    }
}
// MARK: PingGridView
struct AddressGridView: View {
    var addresses: [AddressElement]
    let columns = [
        GridItem(.flexible(minimum: 150, maximum: 150)),
        GridItem(.flexible(minimum: 150, maximum: 150)),
        GridItem(.flexible(minimum: 50, maximum: 50))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                // Add the Grid Header
                GridRow {
                    GridCellView(value: "Address")
                        .font(.subheadline)
                    GridCellView(value: "Country")
                        .font(.subheadline)
                    GridCellView(value: "Flag")
                        .font(.subheadline)

                }
                ForEach(addresses) { item in
                    GridRow {
                        GridCellView(value: "\(item.address)")
                            .font(.caption)
                        GridCellView(value: "\(item.country)")
                            .font(.caption)
                        GridCellView(value: "\(item.flag)")
                            .font(.caption)
                    }
                }
            }.padding(.leading, 0)
        }
    }
}
struct ContentView: View {
    @State private var viewModel = ViewModel()
    var body: some View {
        AddressGridView(addresses: viewModel.addresses)
    }
}

#Preview {
    ContentView()
}
