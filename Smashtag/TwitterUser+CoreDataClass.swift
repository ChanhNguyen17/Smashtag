//
//  TwitterUser+CoreDataClass.swift
//  Smashtag
//
//  Created by Chanh Nguyen on 2/3/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter

public class TwitterUser: NSManagedObject {

    class func twitterUserWithTwitterInfo(_ twitterInfo: Twitter.User, inManagedObjectContext context: NSManagedObjectContext) -> TwitterUser?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        if let twitterUser = (try? context.fetch(request))?.first as? TwitterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObject(forEntityName: "TwitterUser", into: context) as? TwitterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            return twitterUser
        }
        return nil
    }
    
}
