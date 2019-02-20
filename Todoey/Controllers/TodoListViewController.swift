//
//  ViewController.swift
//  Todoey
//
//  Created by Angela Yu on 16/11/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //MARK: Global Variables and viewDidLoad actions
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let   colourHex = selectedCategory?.colour else {fatalError()}
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: Set up Nav Bar Method
    
    func updateNavBar(withHexCode colourHexCode: String) {
        guard let   navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist") }
        
        guard let   navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.barTintColor = navBarColour.lighten(byPercentage: 0.95)
        searchBar.barTintColor = navBarColour.lighten(byPercentage: 0.95)
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        cell.tintColor = UIColor.black
        
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row)/(6.5 * CGFloat(toDoItems!.count)))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        }
        else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    //  line below should be uncommented if you want to delete row by selecting
                    //  realm.delete(item)
                    //  ine below should be uncommentred if you want to update by selecting
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK" Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let deleteItem = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteItem)
                }
            } catch {
                print("Error deleting category")
            }
            // tableView.reloadData()
            print("Item Deleted")
            
        }
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                    } catch{
                    print("Error saving new item \(error)")
                            }
                    }
                    self.tableView.reloadData()
                }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }

    
}

    //MARK: - SearchBar extension methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()
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

