//
//  ContentView.swift
//  WhiteChristmases
//
//  Created by Diana Dezso on 19/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()

    var body: some View {
        List(viewModel.snowRecords, id: \.date) { record in
            HStack {
                Text(record.date)
                Spacer()
                Text("\(record.value, specifier: "%.1f") mm")
            }
        }
        .onAppear {

            let loader = FIPSCountryLoader()
            let _ = loader.loadAllFIPSCodesFromFile()

            USStateLoader().seedUSStatesIfNeeded()
            FIPSCodeCountryMapper().getFIPSCodeFromCoordinates(
                latitude: 64.831037,
                longitude: -147.829153
                // alaska: 64.831037, -147.829153
                // aragua, venezuela
               // 10.117207, -67.268136
            ) { country in
                print(country)
                viewModel.loadSnowData()
            }
//            { result in
//                switch result {
//                case .success(let countries):
//                    print("✅ Loaded \(countries.count) countries")
//                case .failure(let error):
//                    print("❌ Failed to load countries: \(error)")
//                }
//            }
        }
    }
}
