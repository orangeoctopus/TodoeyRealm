//
//  ViewController.swift
//  Todoey
//
//  Created by Telstra on 20/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(dataFilePath)
        
        //initialised once no need anymore
//        let newItem = Item()
//        newItem.title = "orange"
//        newItem.done = true
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "nfakl dka"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "orange octopus"
//        itemArray.append(newItem3)
        
        //not good to use for arrays
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       saveItems() //save chekmark save
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when user clicks add item button on dialog
//            print(textField.text)
            let newItem = Item()
            newItem.title = textField.text!
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
    
    func saveItems(){
        //NSencoder
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Eerro encoidng array, \(error)")
        }
    }
    
    func loadItems(){
        
        // doSomething succeeded, and result is unwrapped.
//        One final note here, by using try? note that you’re discarding the error that took place, as it’s translated to a nil. Use try? when you’re focusing more on successes and failure, not on why things failed.
        if let data = try? Data(contentsOf: dataFilePath!) {
        
            let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
            //use dot self because we not refering to array of items but the type array of items
        }catch {
            print("\(error)")
        }
    }
    }
    


}

