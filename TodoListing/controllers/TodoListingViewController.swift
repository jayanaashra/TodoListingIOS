//
//  ViewController.swift
//  TodoListing
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class TodoListingViewController: SwipeTableViewController {
    
    var itemArray = [Item]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: CategoryItem? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    let itemsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navbar does not exist.")
        }
        if let bgcolor = UIColor(hexString: selectedCategory?.bgcolor ?? "#ffffff") {
            
            let textColor = UIColor(contrastingBlackOrWhiteColorOn: bgcolor, isFlat: true)
            
            let appearance = UINavigationBarAppearance()
            //background color of the navigation and status bar
            appearance.backgroundColor = bgcolor
            //color when the title is large
            appearance.largeTitleTextAttributes.updateValue(textColor, forKey: NSAttributedString.Key.foregroundColor)
            //color when the title is small
            appearance.titleTextAttributes.updateValue(textColor, forKey: NSAttributedString.Key.foregroundColor)

            
            navBar.scrollEdgeAppearance = appearance
            
            navBar.tintColor = textColor
            
            searchBar.barTintColor = bgcolor
            searchBar.searchTextField.backgroundColor = UIColor.white
        }
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        if let categoryColour = UIColor(hexString: selectedCategory?.bgcolor ?? "#ffffff") {
            let bgcolor = categoryColour.darken(byPercentage: CGFloat(indexPath.row) / 25)
            cell.backgroundColor = bgcolor
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: bgcolor!, isFlat: true)
            cell.tintColor = UIColor(contrastingBlackOrWhiteColorOn: bgcolor!, isFlat: true)
        }
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        itemArray[indexPath.row].done =  itemArray[indexPath.row].done == false ? true : false
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK - Add new item action
    
    @IBAction func addTodoListButton(_ sender: UIBarButtonItem) {
        let alert  = AlertViewController(alertTitle: "Add New Todo Item", alertStyle: .alert, buttonText: "Add")
        alert.delegate = self
        alert.showAlert()
        
       
    }
    
    func saveItems() {
        
        
        do {
            try  todoContext.save()
        }catch {
            print("Error while saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
      // let itemFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let newPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, newPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try todoContext.fetch(request)
        }catch {
            print("Error while fetching data \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        
        self.todoContext.delete(itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
    
        self.saveItems()
    }
    
   
}

// MARK: extention for search bar

extension TodoListingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let itemFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let searchtext = searchBar.text!
        
            
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchtext)
        
            
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        itemFetchRequest.sortDescriptors = [sortDescriptor]
            loadItems(with: itemFetchRequest, predicate: predicate)
        
        
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
}






extension TodoListingViewController: AlertControllerDelegate {
    
    func onAlertAddAction(textField: UITextField) {
        if !(textField.text!.isEmpty)  {
            let newItem =  Item(context: todoContext)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = selectedCategory

            
            itemArray.append(newItem)
            
            saveItems()
        }
        
    }
    
}
