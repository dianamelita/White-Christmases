import Foundation

// Weather station models
struct NOAAStationsResponse: Decodable {
    let results: [NOAAStation]
}

struct NOAAStation: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}

// weather record models
struct NOAADataResponse: Decodable {
    let results: [NOAAWeatherRecord]
}

struct NOAAWeatherRecord: Decodable {
    let date: String
    let datatype: String
    let value: Double
}
