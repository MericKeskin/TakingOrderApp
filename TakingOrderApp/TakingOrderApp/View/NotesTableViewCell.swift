//
//  NotesTableViewCell.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 5.10.2022.
//

import UIKit
import CoreData

protocol NotesTableViewCellDelegate: AnyObject {
    
    func didTapDone()
}

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var notesTxtField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    weak var delegate: NotesTableViewCellDelegate?
    
    var order: Order?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notesLbl.text = "Notes"
        notesTxtField.text = order?.notes
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func doneBtnClick(_ sender: Any) {
        order?.notes = notesTxtField.text
        delegate?.didTapDone()
    }
}
