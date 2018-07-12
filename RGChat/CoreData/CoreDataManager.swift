//
//  CoreDataManager.swift
//  RGChat
//
//  Created by Raja Earla on 12/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager  {

    public typealias chatCompletionBlock = (_ chat : Chat) -> Void
    public typealias messageInsertCompletionBlock = (_ message : Message) -> Void


    static let sharedManager = CoreDataManager()

    func insertOrUpdateChatInMoc(with chatId : Int64 , moc : NSManagedObjectContext) -> Chat {
        
        let userFetch = NSFetchRequest<NSManagedObject>(entityName: "Chat")
        userFetch.predicate = NSPredicate(format: "chatId == %lld", chatId)
        var chat = Chat()
        do {
            let fetchedChats = try moc.fetch(userFetch as! NSFetchRequest<NSFetchRequestResult>)
            
            if fetchedChats.count == 0 {
                let chatEntity = NSEntityDescription.entity(forEntityName: "Chat", in: moc)!
                chat = NSManagedObject(entity: chatEntity, insertInto: moc) as! Chat
            } else {
                chat = fetchedChats.first as! Chat
            }
            CoreDataStack.sharedStack.saveContext()
            return chat
        } catch {
            fatalError("Failed to fetch chat: \(error)")
        }
    }

    
    func isChatExistsForChatId(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Chat")
        fetchRequest.predicate = NSPredicate(format: "chatId = %d", id)
        let moc = mainMOC()

        var results: [NSManagedObject] = []
        do {
            results = try moc.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    func insertChatWithProperties(propertyDict : [String  : Any], completionHandler: @escaping chatCompletionBlock) {
        
        let moc = mainMOC()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        fetchRequest.includesSubentities = false
        if let chatId : String = propertyDict["chatId"] as? String {
            fetchRequest.predicate = NSPredicate(format: "chatId = %@", chatId)
        }
        
        do {
            let fetchedUsers = try moc.fetch(fetchRequest )
            
            if fetchedUsers.count == 0 {
                let chatEntity = NSEntityDescription.entity(forEntityName: "Chat", in: moc)!
                let chat = Chat(entity: chatEntity, insertInto: moc)
                chat.setValue(propertyDict["number"], forKey: "number")
                chat.setValue(propertyDict["chatId"], forKey: "chatId")
                chat.setValue(propertyDict["name"], forKey: "name")
                completionHandler(chat)
                CoreDataStack.sharedStack.saveContext()
            } else {
    
            }

        
        } catch {
            fatalError("Failed to insert Chat: \(error)")
        }
    }
    
    func insertMessageWithProperties( forChatId chatId : String, propertyDict : [String  : Any], completionHandler: @escaping messageInsertCompletionBlock) {
        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Message")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        if let messageId : String = propertyDict["messageId"] as? String {
            fetchRequest.predicate = NSPredicate(format: "messageId = %@", messageId)
        }

        let moc = mainMOC()
        
        do {
            let fetchedMessages = try moc.fetch(fetchRequest )
            if fetchedMessages.count == 0 {
                let messageEntity = NSEntityDescription.entity(forEntityName: "Message", in: moc)!
                let message = Message(entity: messageEntity, insertInto: moc)
                message.setValue(propertyDict["senderId"], forKey: "senderId")
                message.setValue(propertyDict["messageId"], forKey: "messageId")
                message.setValue(propertyDict["senderName"], forKey: "senderName")
                message.setValue(propertyDict["text"], forKey: "text")
                message.setValue(propertyDict["messageType"], forKey: "messageType")
                message.setValue(chatId, forKey: "chatRefId")
                CoreDataStack.sharedStack.saveContext()
                completionHandler(message)
            } else {
                let message = fetchedMessages.first as! Message
                CoreDataStack.sharedStack.saveContext()
                completionHandler(message)
            }
            
        } catch {
            fatalError("Failed to insert Chat: \(error)")
        }
    }
    
    
    func fetchChats() -> [Chat] {
        let chatFetch = NSFetchRequest<NSManagedObject>(entityName: "Chat")
        let moc = mainMOC()
        do {
            let fetchedChats = try moc.fetch(chatFetch as! NSFetchRequest<NSFetchRequestResult>)
            return fetchedChats as! [Chat]
        } catch {
            fatalError("Failed to insert Chat: \(error)")
        }
    }
    
    func fetchMessagesForChatId(chatId : String) -> [Message] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.predicate = NSPredicate(format: "chatRefId == %@", chatId)

        let moc = mainMOC()
        var fetchedObjects : [Message]

            do {
                fetchedObjects = try moc.fetch(fetchRequest ) as! [Message]
            } catch {
                fatalError("Failed to insert Chat: \(error)")
            }
            return fetchedObjects
    }


    
    func mainMOC() -> NSManagedObjectContext {
        return CoreDataStack.sharedStack.managedObjectContext
    }
    
    func saveContext()  {
        CoreDataStack.sharedStack.saveContext()
    }



    
    
}
