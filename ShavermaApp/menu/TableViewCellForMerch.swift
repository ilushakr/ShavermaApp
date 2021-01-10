//
//  TableViewCellForMerch.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit

class TableViewCellForMerch: UITableViewCell {

    static let id = "MenuTableViewController"
    
    static func nib() -> UINib{
        return UINib(nibName: self.id, bundle: nil)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
