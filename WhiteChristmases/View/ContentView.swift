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
            let latitude = 46.758104
            let longitude = 23.644359

            // alaska: 64.831037, -147.829153
            // aragua, venezuela: 10.117207, -67.268136
            // bath, uk: 51.370732, -2.395558
            // cluj, ro: 46.758104, 23.644359

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
