import Foundation
import CoreData

final class FIPSCountryProvider {
    static let shared = FIPSCountryProvider()
    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load Model with \(error)")
            }
        }
    }
}
