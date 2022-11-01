//
//  IngredientCollectionViewCell.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 5.10.2022.
//

import UIKit
import CoreData

protocol IngredientCollectionViewCellDelegate: AnyObject {
    
    func getOrders()
}

class IngredientCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkboxBtn: UIButton!
    @IBOutlet weak var ingredientLbl: UILabel!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    weak var delegate: IngredientCollectionViewCellDelegate?
    
    var order: Order?
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkboxBtn.layer.borderWidth = 5
    }

    @IBAction func checkboxBtnClick(_ sender: Any) {
        isChecked = !isChecked
        if isChecked {
            checkboxBtn.setImage(UIImage.checkmark, for: UIControl.State.normal)
            ingredientLbl.textColor = UIColor.gray
            order?.contents?.updateValue(false, forKey: ingredientLbl.text ?? "")
        } else {
            checkboxBtn.setImage(nil, for: UIControl.State.normal)
            ingredientLbl.textColor = UIColor.black
            order?.contents?.updateValue(true, forKey: ingredientLbl.text ?? "")
        }
        do {
            try context?.save()
            delegate?.getOrders()
        } catch let e {
            print(e)
        }
    }
    
    func passOrderInfo(order: Order) {
        self.order = order
    }
}
