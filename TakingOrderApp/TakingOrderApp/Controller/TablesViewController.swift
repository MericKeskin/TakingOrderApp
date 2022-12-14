//
//  TablesViewController.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 26.09.2022.
//

import UIKit
import CoreData

protocol TablesViewControllerDelegateFromMenu: AnyObject {
    
    var orders: [Order] { get set }
    
    func getOrders()
}

protocol TablesViewControllerDelegateFromDetail: AnyObject {

    func dismissBack()
}

class TablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tablesTableView: UITableView!
    
    weak var delegateMenu: TablesViewControllerDelegateFromMenu?
    weak var delegateDetail: TablesViewControllerDelegateFromDetail?
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var tables = [Table]()
    
    var from = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tablesTableView.register(UINib(nibName:"TableTableViewCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        
        if from == "none" {
            navigationItem.setLeftBarButton(nil, animated: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTableBtnClick))
        } else {
            navigationItem.setRightBarButton(nil, animated: false)
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClick))
        }
        
        getTables()
    }
    
    @objc func addTableBtnClick() {
        let alert = UIAlertController(title: "New Table", message: "Enter table number", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Enter", style: .cancel) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self?.createTable(number: Int64(text) ?? 0)
        })
        present(alert, animated: true)
    }
    
    @objc func cancelBtnClick() {
        from = "none"
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tablesTableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableTableViewCell {
            cell.tableNameLbl.text = "Table \(tables[indexPath.row].number)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablesTableView.deselectRow(at: indexPath, animated: true)
        let table = self.tables[indexPath.row]
        if from == "menu" {
            delegateMenu?.getOrders()
            delegateMenu?.orders.first(where: { $0.tableNumber == 0 })?.tableNumber = table.number
            from = "none"
            dismiss(animated: true)
        } else if from == "detail" {
            delegateMenu?.getOrders()
            delegateMenu?.orders.first(where: { $0.tableNumber == 0 })?.tableNumber = table.number
            from = "none"
            delegateDetail?.dismissBack()
        } else {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Show orders", style: .default, handler: { [weak self] _ in
                self?.performSegue(withIdentifier: "toOrders", sender: nil)
            }))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
                let alert = UIAlertController(title: "Edit Table", message: "Edit the item", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = "\(table.number)"
                alert.addAction(UIAlertAction(title: "Enter", style: .cancel) { [weak self] _ in
                    guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
                    self?.updateTable(table: table, newNumber: Int64(text) ?? 0)
                })
                self?.present(alert, animated: true)
            }))
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.deleteTable(table: table)
            }))
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(sheet, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OrdersViewController {
            
        }
    }
    
    func passFromInfo(from: String) {
        self.from = from
    }
    
    func getTables() {
        do {
            tables = try context?.fetch(Table.fetchRequest()) ?? []
            DispatchQueue.main.async {
                self.tablesTableView.reloadData()
            }
        } catch let e {
            print(e)
        }
    }
    
    func createTable(number: Int64) {
        if let context = context ?? self.context {
            let newTable = Table(context: context)
            newTable.number = number
        }
        do {
            try context?.save()
            getTables()
        } catch let e {
            print(e)
        }
    }
    
    func updateTable(table: Table, newNumber: Int64) {
        table.number = newNumber
        do {
            try context?.save()
            getTables()
        } catch let e {
            print(e)
        }
    }
    
    func deleteTable(table: Table) {
        context?.delete(table)
        do {
            try context?.save()
            getTables()
        } catch let e {
            print(e)
        }
    }
}
