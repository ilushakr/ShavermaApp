//
//  TableViewCellForMenuUI.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit
import SDWebImage

protocol TableViewCellForMenuUIDelegate: class {
    func didTapped(_ tag: Int)
}

class TableViewCellForMenuUI: UITableViewCell {

    static let id = "TableViewCellForMenuUI"
    var product: Product?
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var delegate: TableViewCellForMenuUIDelegate?
    private var index = -1
    
    @IBAction func addToOrder(_ sender: UIButton) {
        delegate?.didTapped(sender.tag)
    }
    
    override func awakeFromNib() {

        priceButton.layer.borderWidth = 2
        priceButton.layer.cornerRadius = 10
        priceButton.layer.borderColor = UIColor.orange.cgColor
        priceButton.setTitleColor(UIColor.orange, for: .normal)
        
        itemImage.clipsToBounds = true
        itemImage.contentMode = .scaleAspectFill
        
        super.awakeFromNib()
        // Initialization code
    }

    func configure(row : Int) {

        nameLabel.text = product?.name
        descriptionLabel.text = "product?. product?. product?. product?. product?. product?. product?. product?. product?. product?. product?. product?. product?. product?. "
        priceButton.setTitle("\(product?.price ?? 100)", for: .normal)
        priceButton.tag = row
        weightLabel.text = "\(product?.weight ?? 500)"
        let url = URL(string: "https://play-lh.googleusercontent.com/IeNJWoKYx1waOhfWF6TiuSiWBLfqLb18lmZYXSgsH1fvb8v1IYiZr5aYWe0Gxu-pVZX3=s360")
        itemImage.sd_setImage(with: url, placeholderImage: UIImage(named: "kitten1"), options: SDWebImageOptions.highPriority, completed: nil)
    }
    
}
