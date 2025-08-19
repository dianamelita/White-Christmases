import CoreLocation
import SwiftUI

class StationService {
    private let baseURL = "https://www.ncdc.noaa.gov/cdo-web/api/v2/stations"
    let apiKey = "PYGpfpWjTAMEZFeaZrFwBhmUvEmNHSru"

    func fetchStations(near lat: Double, lon: Double, completion: @escaping ([NOAAStation]) -> Void) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "datasetid", value: "GHCND"),
            URLQueryItem(name: "locationid", value: "FIPS:02"),
            URLQueryItem(name: "limit", value: "1000"),
            URLQueryItem(name: "sortfield", value: "name")
        ]

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(NOAAStationsResponse.self, from: data)

                if let closestStation = self.closestStation(to: .init(latitude: lat, longitude: lon), from: decoded.results) {
                    completion([closestStation])
                } else {
                    completion([])
                }

            } catch {
                print("Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }

    func closestStation(to location: CLLocation, from stations: [NOAAStation]) -> NOAAStation? {
        return stations.min(by: { stationA, stationB in
            let locationA = CLLocation(latitude: stationA.latitude, longitude: stationA.longitude)
            let locationB = CLLocation(latitude: stationB.latitude, longitude: stationB.longitude)
            return location.distance(from: locationA) < location.distance(from: locationB)
        })
    }
}

struct NOAAStationsResponse: Decodable {
    let results: [NOAAStation]
}

struct NOAAStation: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}
