//
//  CellForAddDelete.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit
import SDWebImage

class CellForAddDelete: UICollectionViewCell {

    static let id = "CellForAddDelete"
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    
    var isAddDelete = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with str: String){
        let url = URL(string: "https://play-lh.googleusercontent.com/IeNJWoKYx1waOhfWF6TiuSiWBLfqLb18lmZYXSgsH1fvb8v1IYiZr5aYWe0Gxu-pVZX3=s360")
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "kitten1"), options: SDWebImageOptions.highPriority, completed: nil)
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width - 30).isActive = true
        imageView.center.x = self.center.x
        self.nameLabel.text = str
    }
    
}
