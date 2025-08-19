import CoreData

final class USStateLoader {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = FIPSCountryProvider.shared.viewContext) {
        self.context = context
    }

    func seedUSStatesIfNeeded() {
        let request = NSFetchRequest<USState>(entityName: "USState")
        request.fetchLimit = 1

        let count = (try? context.count(for: request)) ?? 0
        guard count == 0 else {
            print("✅ US States already seeded.")
            return
        }

        let states: [(name: String, abbreviation: String)] = [
            ("Alabama", "AL"), ("Alaska", "AK"), ("Arizona", "AZ"), ("Arkansas", "AR"),
            ("California", "CA"), ("Colorado", "CO"), ("Connecticut", "CT"), ("Delaware", "DE"),
            ("Florida", "FL"), ("Georgia", "GA"), ("Hawaii", "HI"), ("Idaho", "ID"),
            ("Illinois", "IL"), ("Indiana", "IN"), ("Iowa", "IA"), ("Kansas", "KS"),
            ("Kentucky", "KY"), ("Louisiana", "LA"), ("Maine", "ME"), ("Maryland", "MD"),
            ("Massachusetts", "MA"), ("Michigan", "MI"), ("Minnesota", "MN"), ("Mississippi", "MS"),
            ("Missouri", "MO"), ("Montana", "MT"), ("Nebraska", "NE"), ("Nevada", "NV"),
            ("New Hampshire", "NH"), ("New Jersey", "NJ"), ("New Mexico", "NM"), ("New York", "NY"),
            ("North Carolina", "NC"), ("North Dakota", "ND"), ("Ohio", "OH"), ("Oklahoma", "OK"),
            ("Oregon", "OR"), ("Pennsylvania", "PA"), ("Rhode Island", "RI"), ("South Carolina", "SC"),
            ("South Dakota", "SD"), ("Tennessee", "TN"), ("Texas", "TX"), ("Utah", "UT"),
            ("Vermont", "VT"), ("Virginia", "VA"), ("Washington", "WA"), ("West Virginia", "WV"),
            ("Wisconsin", "WI"), ("Wyoming", "WY"), ("District of Columbia", "DC")
        ]

        for state in states {
            let entity = USState(context: context)
            entity.name = state.name
            entity.abbreviation = state.abbreviation
        }

        do {
            try context.save()
            print("✅ US States seeded successfully.")
        } catch {
            print("❌ Failed to seed US States: \(error)")
        }
    }

    func stateName(fromAbbreviation abbr: String) -> String? {
        let request = NSFetchRequest<USState>(entityName: "USState")
        request.predicate = NSPredicate(format: "abbreviation ==[c] %@", abbr)

        return (try? FIPSCountryProvider.shared.viewContext.fetch(request).first)?.name
    }
}
