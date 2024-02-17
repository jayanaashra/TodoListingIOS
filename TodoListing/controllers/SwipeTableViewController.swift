//
//  SwipeTableViewController.swift
//  TodoListing
//
//  Created by Jayana Soneji on 14/02/67 BE.
//  Copyright © 2567 BE App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let todoContext = PersistenceController.shared.container.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
    }
    
    // table view datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    
    // delete action delegate method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete"){ action, indexPath in
            
            self.deleteModel(at: indexPath)

        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return [deleteAction]
    }

    func deleteModel(at indexPath: IndexPath) {
        
    }

}
