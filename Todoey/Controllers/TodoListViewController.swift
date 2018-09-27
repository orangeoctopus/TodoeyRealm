//
//  ViewController.swift
//  Todoey
//
//  Created by Telstra on 20/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems(); //so when we call load items we can be certain selected category is set
        }
    }
    
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //shared signleton object which is our current app as an object, tapping into its delegate adn cast to AppDelegate - so now access to Appdelegate as an object, so now can grab persistentwcontrainer.context
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        searchBar.delegate = self
        
        //initialised once no need anymore
//        let newItem = Item()
//        newItem.title = "orange"
//        newItem.done = true
//        itemArray.append(newItem)
//
//        let newItem3 = Item()
//        newItem3.title = "orange octopus"
//        itemArray.append(newItem3)
        
        //not good to use for arrays
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        //moved loading to seting selected category
//        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        //update
//        itemArray[indexPath.row].setValue("completed", forKey: "title")
        
//        Delete - remove from array then remove from context - to not mess up indexpath orders
//        itemArray.remove(at: indexPath.row)
//        context.delete(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       saveItems() //save chekmark save
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when user clicks add item button on dialog
//            print(textField.text)
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem) //textfields always have somehting, even if empty so force unwrap
            
            //save updated array to use defualts
            
            //not good to use for arrays
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
            
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

    //MARK:  model manipulation methods
    func saveItems(){
        //NSencoder
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        }catch{
//            print("Eerro encoidng array, \(error)")
//        }
        
        //commit context to permanet storage in contaniner
        do {
            try context.save()
        }catch {
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //internal(request) and external(with) parameters
        
// //nsdecoding
//        // doSomething succeeded, and result is unwrapped.
////        One final note here, by using try? note that you’re discarding the error that took place, as it’s translated to a nil. Use try? when you’re focusing more on successes and failure, not on why things failed.
//        if let data = try? Data(contentsOf: dataFilePath!) {
//
//            let decoder = PropertyListDecoder()
//        do{
//            itemArray = try decoder.decode([Item].self, from: data)
//            //use dot self because we not refering to array of items but the type array of items
//        }catch {
//            print("\(error)")
//        }
//    }
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let Categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,additionalPredicate])
        } else {
            request.predicate = Categorypredicate
        }

        
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    


}

//MARK: -search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //[cd] makes the string searhc not case and diacritic sensitive
        
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //load data - but this time request has predicates
        loadItems(with: request, predicate: predicate)
        
//        tableView.reloadData() //already inside load items
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

