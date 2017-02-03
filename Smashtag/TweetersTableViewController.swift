//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by Chanh Nguyen on 2/3/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController {
    
    var mention: String? {
        didSet {updateUI()}
    }
    var managedObjectContext: NSManagedObjectContext? {
        didSet {updateUI()}
    }
    
    fileprivate func updateUI() {
        if let context = managedObjectContext, let mT = mention, mT.characters.count > 0 {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
            
            request.predicate = NSPredicate(format: "any tweets.text containes[c] %@ and !screenName beginswith[c] %@", mention!, "darkside")
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    fileprivate func tweetCountWithMentionByTwitterUser(_ user: TwitterUser) -> Int? {
        
        var count: Int?
        user.managedObjectContext?.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text containes[c] %@ and tweeter = %@", self.mention!, user)
            count = try! user.managedObjectContext?.count(for: request)
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                 screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountWithMentionByTwitterUser(twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweet" : "\(count) tweets"
            }
        }
        
        return cell
    }
    
}




































