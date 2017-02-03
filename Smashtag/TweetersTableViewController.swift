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
    
    private func updateUI() {
        if let context = managedObjectContext, let mT = mention, mT.characters.count > 0 {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
            
            request.predicate = NSPredicate(format: "any tweets.text containes[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(key: "screenName", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                 screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
        }
        
        return cell
    }
    
}




































