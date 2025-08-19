import CoreData
import CoreLocation

final class FIPSCodeCountryMapper {

    func getFIPSCodeFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }

            let countryName = placemark.country ?? ""
            let regionName = placemark.administrativeArea // Optional — may be nil

            let fips = self.findMostSpecificFIPSCode(for: countryName, region: regionName)
            completion(fips)
        }
    }


    func findMostSpecificFIPSCode(for country: String, region: String?) -> String? {
        let context = FIPSCountryProvider.shared.viewContext

        var regionName = region
        // 🔍 Check if it's a US state abbreviation, and get full name
        if let region = region, country == "United States" {

            let stateRequest = NSFetchRequest<USState>(entityName: "USState")
            stateRequest.predicate = NSPredicate(format: "abbreviation ==[c] %@", region)

            if let state = try? context.fetch(stateRequest).first {
                regionName = state.name
                print("🏞 Translated abbreviation '\(region)' → '\(state.name)'")
            }
        }

        if let regionName = regionName {
            let request = NSFetchRequest<FIPSCountry>(entityName: "FIPSCountry")
            request.predicate = NSPredicate(format: "name ==[c] %@", regionName)
            if let match = try? context.fetch(request).first {
                return match.code
            }
        }

        // Fallback to country match
        let fallbackRequest = NSFetchRequest<FIPSCountry>(entityName: "FIPSCountry")
        fallbackRequest.predicate = NSPredicate(format: "name ==[c] %@", country)

        return (try? context.fetch(fallbackRequest).first)?.code
    }

}
