//
//  TitlesTableViewCell.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 5.10.2022.
//

import UIKit

class TitlesTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var contentsLbl: UILabel!
    
    var order: Order?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderNameLbl.text = order?.name
        contentsLbl.text = "Contents"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func passOrderInfo(order: Order) {
        self.order = order
    }
    
}
