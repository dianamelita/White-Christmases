import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var snowRecords: [NOAAWeatherRecord] = []

    private let service = NOAAService()

    func loadSnowData() {
        let stationService = StationService()
        let bristolLat = 51.369932
        let bristolLon = -2.400912
        let alaskaLat = 64.831037
        let alaskaLon = -147.829153

        stationService.fetchStations(near: alaskaLat, lon: alaskaLon) { stations in
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
