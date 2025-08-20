import SwiftUI

final class NOAAService {
    let apiKey = "PYGpfpWjTAMEZFeaZrFwBhmUvEmNHSru"

    private let baseURL = "https://www.ncdc.noaa.gov/cdo-web/api/v2/data"

    func fetchChristmasData(stationId: String, completion: @escaping ([NOAAWeatherRecord]) -> Void) {
        let years = (1995...2024).reversed()  // Last 30 years

        var allRecords: [NOAAWeatherRecord] = []
        let group = DispatchGroup()

        for year in years {
            guard let url = makeURL(for: year, stationId: stationId) else { continue }

            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "token")

            group.enter()
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { group.leave() }

                guard let data = data else { return }

                if let decoded = try? JSONDecoder().decode(NOAADataResponse.self, from: data) {
                    allRecords.append(contentsOf: decoded.results)
                }
            }.resume()
        }

        group.notify(queue: .main) {
            completion(allRecords)
        }
    }

    private func makeURL(for year: Int, stationId: String) -> URL? {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "datasetid", value: "GHCND"),
            URLQueryItem(name: "stationid", value: stationId),
            URLQueryItem(name: "startdate", value: "\(year)-12-25"),
            URLQueryItem(name: "enddate", value: "\(year)-12-25"),
            URLQueryItem(name: "datatypeid", value: "SNWD"), // Add PRCP, TMAX, TMIN as needed
            URLQueryItem(name: "limit", value: "1000"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components.url
    }
}
