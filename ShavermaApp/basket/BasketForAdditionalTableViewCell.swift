//
//  BasketForAdditionalTableViewCell.swift
//  ShavermaApp
//
//  Created by Mac on 08.01.2021.
//

import UIKit
import SDWebImage

class BasketForAdditionalTableViewCell: UITableViewCell {

    @IBOutlet weak var addLabel: UILabel!
    static let id = "BasketForAdditionalTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    var cellSize: CGSize = CGSize()
    let screenSize = UIScreen.main.bounds.height
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: BasketDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellSize = CGSize(width: screenSize / 4, height: screenSize / 6 - 30 - addLabel.frame.height)
        collectionView.register(AdditionalBasketCollectionViewCell.nib(), forCellWithReuseIdentifier: AdditionalBasketCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }

}

extension BasketForAdditionalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(additionalMutable.count)
        return additionalMutable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdditionalBasketCollectionViewCell.id, for: indexPath) as! AdditionalBasketCollectionViewCell
        cell.product = additionalMutable[indexPath.row]
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        order.insert(OrderProduct(product: additionalMutable[indexPath.row], productCount: 1), at: 0)
        additionalMutable.remove(at: indexPath.row)
        collectionView.reloadData()
        delegate?.updateTableView()
    }
}
