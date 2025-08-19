import Foundation
import CoreData

final class FIPSCountry: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var name: String

    override func awakeFromInsert() {
        super.awakeFromInsert()
    }
}

final class USState: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var abbreviation: String

    override func awakeFromInsert() {
        super.awakeFromInsert()
    }
}

