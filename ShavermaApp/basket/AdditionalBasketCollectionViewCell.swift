//
//  AdditionalBasketCollectionViewCell.swift
//  ShavermaApp
//
//  Created by Mac on 09.01.2021.
//

import UIKit
import SDWebImage

class AdditionalBasketCollectionViewCell: UICollectionViewCell {

    static let id = "AdditionalBasketCollectionViewCell"
    var product: Product?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        nameLabel.text = product?.name
        let url = URL(string: "https://play-lh.googleusercontent.com/IeNJWoKYx1waOhfWF6TiuSiWBLfqLb18lmZYXSgsH1fvb8v1IYiZr5aYWe0Gxu-pVZX3=s360")
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "kitten1"), options: SDWebImageOptions.highPriority, completed: nil)
    }
    
}
