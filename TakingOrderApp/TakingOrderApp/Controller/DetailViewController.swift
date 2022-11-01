//
//  DetailViewController.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 26.09.2022.
//

import UIKit
import CoreData

protocol DetailViewControllerDelegateFromMenu: AnyObject {
    
    func dismissBack()
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TablesViewControllerDelegateFromDetail, NotesTableViewCellDelegate {

    @IBOutlet weak var detailTableView: UITableView!
    
    weak var delegateMenu: DetailViewControllerDelegateFromMenu?
    
    var order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.register(UINib(nibName: "TitlesTableViewCell", bundle: nil), forCellReuseIdentifier: "titlesCell")
        detailTableView.register(UINib(nibName: "ContentsTableViewCell", bundle: nil), forCellReuseIdentifier: "contentsCell")
        detailTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "notesCell")
    }
    
    func dismissBack() {
        dismiss(animated: true)
    }
    
    func didTapDone() {
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = detailTableView.dequeueReusableCell(withIdentifier: "titlesCell", for: indexPath) as? TitlesTableViewCell {
                cell.orderNameLbl.text = order.name
                return cell
            }
        case 1:
            if let cell = detailTableView.dequeueReusableCell(withIdentifier: "contentsCell", for: indexPath) as? ContentsTableViewCell {
                cell.passOrderInfo(order: order)
                return cell
            }
        case 2:
            if let cell = detailTableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as? NotesTableViewCell {
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}
