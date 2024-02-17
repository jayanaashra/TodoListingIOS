//
//  CategoryViewController.swift
//  TodoListing
//
//  Created by Jayana Soneji on 12/02/67 BE.
//  Copyright © 2567 BE App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    var categoriesArray = [CategoryItem]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        
        tableView.separatorStyle = .none
        
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navbar does not exist.")
        }
        
        let appearance = UINavigationBarAppearance()
        //background color of the navigation and status bar
        appearance.backgroundColor = AppConstans.narBarBackgroundColor
        //color when the title is large
        appearance.largeTitleTextAttributes.updateValue(AppConstans.narBarTextColor, forKey: NSAttributedString.Key.foregroundColor)
        //color when the title is small
        appearance.titleTextAttributes.updateValue(AppConstans.narBarTextColor, forKey: NSAttributedString.Key.foregroundColor)

        
        navBar.scrollEdgeAppearance = appearance
        
        navBar.tintColor = AppConstans.narBarTextColor
    }
    

    // MARK: Load table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        if let bgcolor = UIColor(hexString:  categoriesArray[indexPath.row].bgcolor ?? "#ffffff" ) {
            cell.backgroundColor = bgcolor
            
            cell.tintColor = UIColor(contrastingBlackOrWhiteColorOn: bgcolor , isFlat: true)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: bgcolor, isFlat: true)
            
        }
        
        let image = UIImage(systemName: "chevron.right")
        let accessory  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        accessory.image = image
        
        cell.accessoryView = accessory
        
        return cell
    }
    
    
    // MARK: Go to Item List and Prepare Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItemList", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItemList" {
            let destination = segue.destination as! TodoListingViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.selectedCategory = categoriesArray[indexPath.row]
            }
        }
    }
    
    // MARK: Add Category Buttion Action
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        let alert  = AlertViewController(alertTitle: "Add New Category", alertStyle: .alert, buttonText: "Add")
        alert.delegate = self
        alert.showAlert()
        
    }
    
   
    
    // MARK: Save and Load Data
    func saveCategories() {
        do {
            try  todoContext.save()
        }catch {
            print("Error while saving data \(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategories() {
        let fetchcategories: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()
        do {
             categoriesArray = try todoContext.fetch(fetchcategories)
        }catch {
            print("Error while fetching categories \(error)")
        }
        
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        self.todoContext.delete(categoriesArray[indexPath.row])
        self.categoriesArray.remove(at: indexPath.row)

        self.saveCategories()
    }
    
}



extension CategoryViewController: AlertControllerDelegate {
    
    func onAlertAddAction(textField: UITextField) {
        if !(textField.text!.isEmpty)  {
            let newCategory = CategoryItem(context: todoContext)
            newCategory.name = textField.text!
            newCategory.bgcolor = UIColor.randomFlat().hexValue()
            categoriesArray.append(newCategory)
            
            saveCategories()
        }
        
    }
    
}
