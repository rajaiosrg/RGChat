//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Raja Earla on 12/07/18.
//
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var senderId: String?
    @NSManaged public var messageId: String?
    @NSManaged public var senderName: String?
    @NSManaged public var text: String?
    @NSManaged public var messageType: String?
    @NSManaged public var chatRefId: String?
}
