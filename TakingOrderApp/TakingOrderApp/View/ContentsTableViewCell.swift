//
//  ContentsTableViewCell.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 5.10.2022.
//

import UIKit
import CoreData

class ContentsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var contentsCollectionView: UICollectionView!
    
    var order: Order?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsCollectionView.register(UINib(nibName: "IngredientCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ingredientCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order?.contents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = contentsCollectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as? IngredientCollectionViewCell {
            
            return cell
        }
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
    
    func passOrderInfo(order: Order) {
        self.order = order
    }
}
