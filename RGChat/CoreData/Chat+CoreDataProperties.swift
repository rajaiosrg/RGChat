//
//  Chat+CoreDataProperties.swift
//  
//
//  Created by Raja Earla on 12/07/18.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var chatId: String?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    
}
