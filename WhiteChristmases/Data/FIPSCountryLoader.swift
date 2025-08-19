import Foundation
import CoreData

final class FIPSCountryLoader {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = FIPSCountryProvider.shared.viewContext) {
        self.context = context
    }

    private var fipsCountriesLoaded: Bool = {
        let context = FIPSCountryProvider.shared.viewContext
        let fetchRequest:  NSFetchRequest<any NSFetchRequestResult> = FIPSCountry.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            }
        } catch {
            return false
        }
        return false
    }()

    func loadAllFIPSCodesFromFile() -> [FIPSCountry] {
        guard !fipsCountriesLoaded else { return [] }

        guard let url = Bundle.main.url(forResource: "fips-countries", withExtension: "txt") else {
            print("❌ Could not find fips-countries.txt")
            return []
        }

        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            var countries: [FIPSCountry] = []

            // Updated pattern:
            // 1: 4-character FIPS code
            // 2: Raw name (everything after ___ or ____)
            let pattern = #"^(.{4})_.*?_{3,}(.*?)__*$"#
            let regex = try NSRegularExpression(pattern: pattern)

            for line in lines {
                let range = NSRange(line.startIndex..., in: line)
                guard let match = regex.firstMatch(in: line, options: [], range: range),
                      match.numberOfRanges == 3 else {
                    continue
                }

                let code = String(line[Range(match.range(at: 1), in: line)!])
                let rawName = String(line[Range(match.range(at: 2), in: line)!])
                let name = rawName
                    .replacingOccurrences(of: "_", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                let region = FIPSCountry(context: FIPSCountryProvider.shared.viewContext)
                region.code = code
                region.name = name
                countries.append(region)
            }

            try FIPSCountryProvider.shared.viewContext.save()
            print("✅ Loaded \(countries.count) FIPS entries with flexible parsing.")
            return countries

        } catch {
            print("❌ Failed to parse FIPS file: \(error)")
            return []
        }
    }
}
