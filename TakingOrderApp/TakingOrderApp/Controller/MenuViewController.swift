//
//  ViewController.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 26.09.2022.
//

import UIKit
import CoreData

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TablesViewControllerDelegateFromMenu {

    @IBOutlet weak var menuTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var sections = [Section]()
    var items = [MenuItem]()
    var orders = [Order]()
    
    var tableNumber: Int64 = 0
    var tableInfoKnown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "sectionCell")
        menuTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        
        if tableInfoKnown {
            navigationController?.isNavigationBarHidden = false
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClick))
        } else {
            navigationController?.isNavigationBarHidden = true
        }
        
        getSections()
        if sections.isEmpty {
            createSection(name: "Breakfast")
            createSection(name: "Wraps")
            createSection(name: "Burgers")
            createSection(name: "Pizzas")
            createSection(name: "Cold Drinks")
            createSection(name: "Hot Drinks")

            createItem(name: "Turkish Breakfast", section: "Breakfast", contents: ["egg", "cheese", "olive", "butter", "honey", "bread"])
            createItem(name: "British Breakfast", section: "Breakfast", contents: ["egg", "ham", "tomato", "olive", "marmelade", "bun"])
            createItem(name: "Veal Wrap", section: "Wraps", contents: ["veal meat", "cheese", "pickle", "bread"])
            createItem(name: "Chicken Wrap", section: "Wraps", contents: ["chicken meat", "fries", "mustard", "bread"])
            createItem(name: "Cheeseburger", section: "Burgers", contents: ["veal meat", "cheese", "pickle", "tomato", "mayonese"])
            createItem(name: "BBQ Burger", section: "Burgers", contents: ["veal meat", "bacon", "pickle", "tomato", "BBQ"])
            createItem(name: "Margherita", section: "Pizzas", contents: ["tomato sauce", "mozzarella"])
            createItem(name: "Peperonni", section: "Pizzas", contents: ["tomato sauce", "mozzarella", "peperonni"])
            createItem(name: "Coca Cola", section: "Cold Drinks", contents: [])
            createItem(name: "Sprite", section: "Cold Drinks", contents: [])
            createItem(name: "Tea", section: "Hot Drinks", contents: ["lemon"])
            createItem(name: "Coffee", section: "Hot Drinks", contents: ["milk"])
        }
        
//        deleteAllSections()
//        deleteAllItems()
        
        getSections()
        getItems()
    }
    
    @objc func cancelBtnClick() {
        tableInfoKnown = false
        dismiss(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].isOpen {
            return items.filter({ $0.section == sections[section].name }).count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = menuTableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as? SectionTableViewCell {
                cell.nameLbl.text = sections[indexPath.section].name
                return cell
            }
        } else {
            if let cell = menuTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell {
                cell.nameLbl.text = items.filter({ $0.section == sections[indexPath.section].name })[indexPath.row - 1].name
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpen = !sections[indexPath.section].isOpen
            menuTableView.reloadSections([indexPath.section], with: .none)
        } else {
            let item = self.items.filter({ $0.section == sections[indexPath.section].name })[indexPath.row - 1]
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Add Order", style: .default, handler: { [weak self] _ in
                if self?.tableInfoKnown != nil {
                    self?.createOrder(name: item.name ?? "", tableNumber: self?.tableNumber ?? 0, item: item)
                } else {
                    self?.createOrder(name: item.name ?? "", item: item)
                }
                self?.performSegue(withIdentifier: "toDetail", sender: nil)
            }))
            sheet.addAction(UIAlertAction(title: "Quick Add", style: .default, handler: { [weak self] _ in
                if self?.tableInfoKnown != nil {
                    self?.createOrder(name: item.name ?? "", tableNumber: self?.tableNumber ?? 0, item: item)
                } else {
                    self?.createOrder(name: item.name ?? "", item: item)
                    self?.performSegue(withIdentifier: "toTablesFromMenu", sender: nil)
                }
            }))
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(sheet, animated: true)
        }
    }
    
    func passTableInfo(tableNumber: Int64) {
        tableInfoKnown = true
        self.tableNumber = tableNumber
    }
    
    func getSections() {
        do {
            sections = try context?.fetch(Section.fetchRequest()) ?? []
            DispatchQueue.main.async {
                self.menuTableView.reloadData()
            }
        } catch let e {
            print(e)
        }
    }
    
    func createSection(name: String) {
        if let context = context ?? self.context {
            let newSection = Section(context: context)
            newSection.name = name
            newSection.isOpen = false
        }
        do {
            try context?.save()
            getSections()
        } catch let e {
            print(e)
        }
    }
    
    func getItems() {
        do {
            items = try context?.fetch(MenuItem.fetchRequest()) ?? []
            DispatchQueue.main.async {
                self.menuTableView.reloadData()
            }
        } catch let e {
            print(e)
        }
    }
    
    func createItem(name: String, section: String, contents: [String]) {
        if let context = context ?? self.context {
            let newItem = MenuItem(context: context)
            newItem.name = name
            newItem.section = section
            newItem.contents = contents
        }
        do {
            try context?.save()
            getItems()
        } catch let e {
            print(e)
        }
    }
    
    func getOrders() {
        do {
            orders = try context?.fetch(Order.fetchRequest()) ?? []
        } catch let e {
            print(e)
        }
    }
    
    func createOrder(name: String, tableNumber: Int64 = 0, item: MenuItem) {
        if let context = context ?? self.context {
            let newOrder = Order(context: context)
            newOrder.name = name
            newOrder.tableNumber = tableNumber
            let contents = item.contents?.toDictionary(key: { $0.self }, value: true)
            newOrder.contents = contents as? [String:Bool]
        }
        do {
            try context?.save()
            getOrders()
        } catch let e {
            print(e)
        }
    }
    
//    func deleteAllSections() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Section")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context?.execute(deleteRequest)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
//    }
//
//    func deleteAllItems() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MenuItem")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context?.execute(deleteRequest)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
//    }
}
