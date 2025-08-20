import CoreLocation
import SwiftUI

class StationService {
    private let baseURL = "https://www.ncdc.noaa.gov/cdo-web/api/v2/stations"
    let apiKey = "PYGpfpWjTAMEZFeaZrFwBhmUvEmNHSru"

    func fetchStations(
        near lat: Double,
        lon: Double,
        fipsCode: String,
        completion: @escaping ([NOAAStation]) -> Void
    ) {
        var queryValue = fipsCode // e.g., "US02" or "VE04"

        if queryValue.hasPrefix("US") {
            queryValue = String(queryValue.dropFirst(2))  // results in "02"
        } else {
            // All other countries → use first 2 characters
            queryValue = String(fipsCode.prefix(2))
        }

        print("Station code for query: \(queryValue)")
        var components = URLComponents(string: baseURL)!
        let queryItems = buildQueryItems(
            for: queryValue,
            latitude: lat,
            longitude: lon
        )

        components.queryItems = queryItems

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            if let error = error {
                print("Network error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status code: \(httpResponse.statusCode)")
            }

            if let text = String(data: data, encoding: .utf8) {
                print("🔍 Raw response body:\n\(text)")
            }

            do {
                let decoded = try JSONDecoder().decode(NOAAStationsResponse.self, from: data)

                if let closestStation = self.closestStation(
                    to: .init(latitude: lat, longitude: lon),
                    from: decoded.results
                ) {
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

    func buildQueryItems(
        for fipsCode: String,
        latitude: Double,
        longitude: Double
    ) -> [URLQueryItem] {

        var items: [URLQueryItem] = [
            URLQueryItem(name: "datasetid", value: "GHCND"),
        ]

        if fipsCode.hasPrefix("US") {
            // 🇺🇸 US: use coordinates + radius
            items.append(contentsOf: [
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "radius", value: "200"), // increase if needed
                URLQueryItem(name: "limit", value: "25")
            ])
        } else {
            // 🌍 International: use country code from first 2 chars
            let countryCode = String(fipsCode.prefix(2))
            items.append(URLQueryItem(name: "locationid", value: "FIPS:\(countryCode)"))
        }

        return items
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
