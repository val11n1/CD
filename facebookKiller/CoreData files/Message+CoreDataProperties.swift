//
//  Message+CoreDataProperties.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 15.03.2022.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var friend: Friend?
    @NSManaged public var isSender: NSNumber?
}

extension Message : Identifiable {

}
