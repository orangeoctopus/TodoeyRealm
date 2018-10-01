//
//  SwipeTableViewController.swift
//  TodoeyRealm
//
//  Created by Telstra on 1/10/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//                do{
//                    try self.realm.write{
//                        self.realm.delete(categoryForDeletion)
//                    }
//                } catch {
//                    print("Error deleting \(error)")
//                }
//
//                tableView.reloadData()
//            }
            print("delte stuffo")
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

}
