//
//  BasketTableViewCell.swift
//  ShavermaApp
//
//  Created by Mac on 08.01.2021.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    static let id = "BasketTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    
    var orderProduct: OrderProduct?
    var index = -1
    var delegate: BasketDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func minus(_ sender: Any) {
        order[index].productCount = order[index].productCount - 1
        countLabel.text = String(order[index].productCount)
        if(order[index].productCount == 0){
            if(additional.contains(order[index].product)){
                additionalMutable.insert(order[index].product, at: 0)
            }
            order.remove(at: index)
            delegate?.updateTableView()
        }
    }
    @IBAction func plus(_ sender: Any) {
        order[index].productCount = order[index].productCount + 1
        countLabel.text = String(order[index].productCount)
//        countLabel.text = String(Int(countLabel.text!)! + 1)
    }
    
    func configure(row : Int) {

        nameLabel.text = orderProduct?.product.name
        countLabel.text = String(orderProduct!.productCount)
    }
    
}
