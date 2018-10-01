//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Telstra on 25/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() //try! is code smell - becaus realm may be null here at initialisation if resources are constrained - but can onyl practice on first time on a thread - doc says ok to do this
    
    var categories : Results<Category>? //Reseult object is what you get everytime you query realm db
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        

    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //call super's cell for row method
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //tap into teh cell that gets created in teh super view  and taps nto cell at this indexpath
        
        //now further modify cell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //nil coelessing operator, if category is nill, return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //go to items in category
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController //if statement if other possible destinations
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            }
    }
    
    
    
    //MARK - Data Manipulation Methods
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
       categories = realm.objects(Category.self) //pull out all objects in realm of type cateogry

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath) //call to super class, otherise super class method is not called - not needed here but just for testing
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting \(error)")
            }
            
            tableView.reloadData()
        }

    }

    //MARK - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
         let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //no need to append - rlts is auto updating
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            //on appearnace of alert box because showign texrfield
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)

    }
    
    
    
    
}


