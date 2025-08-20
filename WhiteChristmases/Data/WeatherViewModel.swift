import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var snowRecords: [NOAAWeatherRecord] = []

    private let service = NOAAService()

    func loadSnowData(for latitude: Double, longitude: Double, fipsCode: String) {
        let stationService = StationService()

        stationService.fetchStations(
            near: latitude,
            lon: longitude,
            fipsCode: fipsCode
        ) { stations in
            for station in stations {

                print("📍 Station: \(station.name), ID: \(station.id), lat: \(station.latitude), lon: \(station.longitude)")

                self.service.fetchChristmasData(stationId: station.id) { [weak self] records in
                    DispatchQueue.main.async {
                        self?.snowRecords = records.filter { $0.datatype == "SNWD" }
                    }
                }
            }
        }
    }
}
