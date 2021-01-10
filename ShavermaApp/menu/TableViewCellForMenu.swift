//
//  TableViewCellForMenu.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit
import SDWebImage

protocol TableViewCellForMenuDelegate: class {
    func didTapped(_ tag: Int)
}

class TableViewCellForMenu: UITableViewCell {

    static let id = "TableViewCellForMenu"
    private var _name = ""
    private var _description = ""
    private var _price = ""
    private var _image = ""
    
    weak var delegate: TableViewCellForMenuDelegate?
    private var index = -1
    
    @IBAction func addToMenu(_ sender: UIButton) {
        delegate?.didTapped(sender.tag)
    }
    
    
    private let _imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let _nameLable: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = label.font.withSize(15)
        return label
    }()
    
    private let _descriptionLable: UILabel = {
        let label = UILabel()
        label.text = "description"
        label.font = label.font.withSize(11)
        return label
    }()
    
    private let _priceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("150", for: .normal)
//        button.buttonType =
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.systemBlue.cgColor
//        button.backgroundColor = .blue
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(_imageView)
        contentView.addSubview(_priceButton)
        contentView.addSubview(_nameLable)
        contentView.addSubview(_descriptionLable)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: Product, image:  String, row: Int){
        self._name = product.name ?? "null"
        self._description = product.name ?? "descr null"
        self._price = "\(String(describing: product.price!))"
        self._image = image
        _priceButton.tag = row
        let url = URL(string: "https://play-lh.googleusercontent.com/IeNJWoKYx1waOhfWF6TiuSiWBLfqLb18lmZYXSgsH1fvb8v1IYiZr5aYWe0Gxu-pVZX3=s360")
        self._imageView.sd_setImage(with: url, placeholderImage: UIImage(named: _image), options: SDWebImageOptions.highPriority, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _nameLable.text = _name
        _descriptionLable.text = _description
        _priceButton.setTitle(_price, for: .normal)

        let spacing = 8
        let imageSize = contentView.frame.size.height - CGFloat(2 * spacing)
        let buttonSize = contentView.frame.width / 5
        _imageView.frame = CGRect(x: CGFloat(spacing), y: CGFloat(spacing), width: imageSize, height: imageSize)
        
//        _nameLable.frame = CGRect(x: imageSize + CGFloat(3 * spacing), y: CGFloat(spacing), width: contentView.frame.width - imageSize - CGFloat(3 * spacing), height: _nameLable.frame.height)

//        _nameLable.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        _nameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(spacing)).isActive = true
//        _nameLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CGFloat(spacing)).isActive = true
        _nameLable.leadingAnchor.constraint(equalTo: _imageView.trailingAnchor, constant: CGFloat(spacing)).isActive = true
        _nameLable.center.y = contentView.center.y
        
        _priceButton.frame = CGRect(x: contentView.frame.size.width - buttonSize - CGFloat(spacing), y: contentView.frame.size.height - buttonSize / 2 - CGFloat(spacing), width: buttonSize, height: buttonSize / 2)
//        _priceButton.heightAnchor.constraint(equalToConstant: buttonSize / 2).isActive = true
//        _priceButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        _priceButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(spacing)).isActive = true
//        _priceButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(spacing)).isActive = true
        
        _priceButton.addTarget(self, action: #selector(addToMenu), for: .touchUpInside)
        
        _descriptionLable.frame = CGRect(x: imageSize + CGFloat(3 * spacing), y: CGFloat(3 * spacing) + _nameLable.frame.height, width: contentView.frame.width - imageSize - CGFloat(3 * spacing), height: contentView.frame.size.height - _nameLable.frame.height - _priceButton.frame.height - CGFloat(5 * spacing))
    }

}
