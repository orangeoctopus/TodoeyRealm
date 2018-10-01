//
//  ViewController.swift
//  Todoey
//
//  Created by Telstra on 20/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController{

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems(); //so when we call load items we can be certain selected category is set
        }
    }
    
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done //update value
                    
                }
            } catch {
                print("Error saving, \(error)")
            }
        }

        tableView.reloadData() //calls cellForRowAt indexPath again
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when user clicks add item button on dialog
//
            if let currentCategory = self.selectedCategory { //because selected category may be null
                do {
                    try self.realm.write {
                        let newItem = Item();
                        newItem.title = textField.text!
                        newItem.dateCreated = Date() //gets current date
                        currentCategory.items.append(newItem) //add this item to the selected category
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            //on appearnace of alert box because showign texrfield
            alertTextField.placeholder = "Create new item"
//            print(alertTextField.text)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }


    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //items relationship

        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath) //call to super class, otherise super class method is not called - not needed here but just for testing
        if let ItemForDeletion = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(ItemForDeletion)
                }
            } catch {
                print("Error deleting \(error)")
            }
            
            tableView.reloadData()
        }
        
    }


}

//MARK: -search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //no longer in focus
            }
        
        }
    }
}

