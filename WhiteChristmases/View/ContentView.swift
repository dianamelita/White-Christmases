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
            let latitude = 64.831037
            let longitude = -147.829153

            // alaska: 64.831037, -147.829153
            // aragua, venezuela: 10.117207, -67.268136
            // bath, uk: 51.370732, -2.395558
            // cluj, ro: 46.758104, 23.644359

            USStateLoader().seedUSStatesIfNeeded()
            FIPSCodeCountryMapper().getFIPSCodeFromCoordinates(
                latitude: latitude,
                longitude: longitude
            ) { country in
                guard let countryCode = country else { return }
                print("🌎 country code found: \(countryCode)")
                viewModel.loadSnowData(
                    for: latitude,
                    longitude: longitude,
                    fipsCode: countryCode
                )
            }
        }
    }
}
