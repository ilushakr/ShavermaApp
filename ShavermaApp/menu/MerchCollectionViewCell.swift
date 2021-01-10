//
//  MerchCollectionViewCell.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit

class MerchCollectionViewCell: UICollectionViewCell {
    
    static let id = "MerchCollectionViewCell"
    private var _name = ""
    
    private let _nameLable: UILabel = {
        let label = UILabel()
        label.text = "name"
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "kitten1")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews(){
//        contentView.addSubview(_nameLable)
        contentView.addSubview(imageView)
    }
    
    func configure(product: Product, cellWidth: CGFloat){
        self._name = product.name ?? "null"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        _nameLable.text = _name
//        _nameLable.frame = CGRect(x: 0, y: 0, width: _nameLable.intrinsicContentSize.width, height: _nameLable.intrinsicContentSize.height)
//        _nameLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        _nameLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
    }
    
}
