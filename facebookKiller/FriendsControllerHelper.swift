//
//  FriendsControllerHelper.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 15.03.2022.
//

import UIKit
import CoreData

extension FriendsController {
    
    func clearData() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
         let context = delegate.persistentContainer.viewContext
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            let friends = try(context.fetch(fetchRequest)) as! [Friend]
            
            for friend in friends {
                context.delete(friend)
            }
            
            try(context.save())
            
        }catch let err {
            
            print(err)
        }
        
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
         let context = delegate.persistentContainer.viewContext
            
        //createMorfMessagesWith(context: context)
        createUrsaMessagesWith(context: context)
        
        

        let am = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        am.name = "Anti - Mage"
        am.profileImageName = "whoiam"
        
        FriendsController.createMessageWithText(text: "Hello, do you have any bf item? Its be nice to you have it. Have a nice game", friend: am, minutesAgo: 5, context: context)
        
        let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        gandhi.name = "Mahatma Gandhi"
        gandhi.profileImageName = "gandhi"
        
        FriendsController.createMessageWithText(text: "Love, peace and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steveJobs"
        
        FriendsController.createMessageWithText(text: "Hello, lets do something great. i am so proud of my company! We create future! Please, come with us in better world! Billy jean not my lover, she just a girl, who say i am a one, but the kid is not my son!", friend: steve, minutesAgo: 8 * 60 * 24, context: context)

        do {
            
          try (context.save())

        }catch let err {
            
            print(err)
        }
        
        loadData()
    }
    
     func createMorfMessagesWith(context: NSManagedObjectContext) {
        
        let  morf = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        morf.name = "Morf undefeated1"
        morf.profileImageName = "morfContact1"
        
         FriendsController.createMessageWithText(text: "Hello, lets play some interesting. Nice to meet you...", friend: morf, minutesAgo: 0, context: context)
         
         let  bill = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
         bill.name = "Bill"
         bill.profileImageName = "ya"
         
          FriendsController.createMessageWithText(text: "Hello, lets play some interesting. Nice to meet you...", friend: bill, minutesAgo: 0, context: context)
    }
    
    private func createUrsaMessagesWith(context: NSManagedObjectContext) {
        
        let ursa = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        ursa.name = "ursa the great"
        ursa.profileImageName = "ursafb"
        
        FriendsController.createMessageWithText(text: "Good morning ...", friend: ursa,minutesAgo: 10, context: context)
        FriendsController.createMessageWithText(text: "Hello, how are you?", friend: ursa,minutesAgo: 9, context: context)
        FriendsController.createMessageWithText(text: "Are you interested in buying an Apple device?", friend: ursa,minutesAgo: 8, context: context)
        
        // responce message
        
        FriendsController.createMessageWithText(text: "Yes, totally looking to buy an iphone 123 in future", friend: ursa,minutesAgo: 7, context: context, isSender: true)
        
        FriendsController.createMessageWithText(text: "Totally understand that you want iphone 7, but you have to wait untill September for the new release. Sorry but thats just how Apple like to do things", friend: ursa, minutesAgo: 6, context: context)
        
        FriendsController.createMessageWithText(text: "Absolutely i ll just use my gigantic iPhone 6 plus until then!!!", friend: ursa, minutesAgo: 5, context: context, isSender: true)
        
        
    }

    
    static func createMessageWithText(text: String,friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(booleanLiteral: isSender)
        
        friend.lastMessage = message
        
        return message
    }
    
    func loadData() {
//        
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//         let context = delegate.persistentContainer.viewContext
//        
//        if let friends = fetchFriend() {
//            
//            messages = [Message]()
//            
//            for friend in friends {
//                
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
//                let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
//                fetchRequest.sortDescriptors = [sortDescriptor]
//                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
//                fetchRequest.fetchLimit = 1
//                
//                do {
//                    
//                    let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
//                    messages?.append(contentsOf: fetchedMessages!)
//                    
//                }catch let err {
//                    
//                    print(err)
//                }
//            }
//            messages?.sort(by: {$0.date!.compare($1.date!) == .orderedDescending})
//        }
        
    }
    
   private func fetchFriend() -> [Friend]? {
       
       let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
       
       
       do {
           return try(context.fetch(request)) as? [Friend]
       }catch let err {
           print(err)
       }
       
       return nil
    }
}
