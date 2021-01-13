//
//  ItemBottomSheetViewController.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import SDWebImage

class ItemBottomSheetViewController: UIViewController{
    
    var index = 0
    var bottomSheet: MDCBottomSheetController? = nil

    var product: Product
    var halapenjo: [Product]? = [Product]()
    var bez: [Product]? = [Product]()
        
    @IBOutlet weak var toBasketButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomAnchorConstrait: NSLayoutConstraint!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var hlebSegmentedControl: UISegmentedControl!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var addCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var deleteCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCollectionView.delegate = self
        addCollectionView.dataSource = self
        deleteCollectionView.delegate = self
        deleteCollectionView.dataSource = self
        
        scrollView.delegate = self
                
        initViews()
    }

    private func initViews(){
        let url = URL(string: "https://play-lh.googleusercontent.com/IeNJWoKYx1waOhfWF6TiuSiWBLfqLb18lmZYXSgsH1fvb8v1IYiZr5aYWe0Gxu-pVZX3=s360")
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "kitten1"), options: SDWebImageOptions.highPriority, completed: nil)
        initLabels()
        initHleb()
        initHalapenjo()
        initBez()
        
        deleteCollectionView.register(CellForAddDelete.nib(), forCellWithReuseIdentifier: CellForAddDelete.id)
        deleteCollectionView.layoutIfNeeded()
        addCollectionView.register(CellForAddDelete.nib(), forCellWithReuseIdentifier: CellForAddDelete.id)
        addCollectionView.layoutIfNeeded()
        
//        deleteCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 40).isActive = true
        bottomAnchorConstrait.constant = 20 + toBasketButton.frame.height + 10
    }
    
    private func initLabels(){
        
        toBasketButton.layer.cornerRadius = 10
        
        nameLabel.text = product.name
        descriptionLabel.text = product.productDescription
        weightLabel.text = "\(product.weight ?? 500)"
    }
    
    private func initHleb(){
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
                                                
        let font = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]
        hlebSegmentedControl.setTitleTextAttributes(font, for: .normal)
        
        hlebSegmentedControl.removeAllSegments()
        
        //var mm = menu 0 - all additions/ -2 - ohne group
        let hleb = product.get_specGMod(target: [menu.groups!.last!,menu.groups![menu.groups!.count-2]])
        if(hleb == nil){
            hlebSegmentedControl.heightAnchor.constraint(equalToConstant: 0).isActive = true
            hlebSegmentedControl.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 0).isActive = true
        }
        else{
            updateSegmentControlWithItems(hleb!)
            hlebSegmentedControl.selectedSegmentIndex = 0;
        }
    }
    
    private func updateSegmentControlWithItems(_ items: [Product]) {
        //If no segments were added
        items.enumerated().forEach { (offset, element) in
            hlebSegmentedControl.insertSegment(withTitle: element.name, at: offset, animated: true)
        }

        //If dummy segments were added
        items.enumerated().forEach { (offset, element) in
            hlebSegmentedControl.setTitle(element.name, forSegmentAt: offset)
        }
    }
    
    private func initHalapenjo(){
        halapenjo = product.get_specGMod(target: [menu.groups!.first!])
        if(halapenjo == nil){
            addCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            addLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            addLabel.topAnchor.constraint(equalTo: hlebSegmentedControl.bottomAnchor, constant: 0).isActive = true
            addCollectionView.topAnchor.constraint(equalTo: addLabel.bottomAnchor, constant: 0).isActive = true
        }
        else{
            addCollectionView.reloadData()
        }
    }
    
    
    private func initBez(){
        bez = product.get_specGMod(target: [menu.groups![menu.groups!.count-3]])
        if(bez == nil){
            deleteCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            deleteLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            deleteLabel.topAnchor.constraint(equalTo: addCollectionView.bottomAnchor, constant: 0).isActive = true
            deleteCollectionView.topAnchor.constraint(equalTo: deleteLabel.bottomAnchor, constant: 0).isActive = true
        }
        else{
            deleteCollectionView.reloadData()
        }
    }
    
    init(product: Product){
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func backToMenu(_ sender: Any) {
        bottomSheet?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toBasket(_ sender: Any) {
        self.showToast(message: "Добавлено в корзину", font: .systemFont(ofSize: 12.0))
        order.insert(OrderProduct(product: product, productCount: 1), at: 0)
    }
    
    
    @IBAction func showInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let infoVC = storyboard.instantiateViewController(identifier: "InfoViewController") as! InfoViewController
        infoVC.product = product
        present(infoVC, animated: true)
    }

    func showToast(message : String, font: UIFont) {

        let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/4, y: self.view.frame.size.height - 110 - bottomPadding, width: self.view.frame.size.width/2, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


extension ItemBottomSheetViewController: UIScrollViewDelegate{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0){
            if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0)
            {
                bottomSheet?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension ItemBottomSheetViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.addCollectionView){
            return halapenjo?.count ?? 0
        }
        else{
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.addCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellForAddDelete.id, for: indexPath) as! CellForAddDelete
            cell.configure(with: halapenjo?[indexPath.row].name ?? "\(indexPath.row)")
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellForAddDelete.id, for: indexPath) as! CellForAddDelete
            cell.configure(with: bez?[indexPath.row].name ?? "\(indexPath.row)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == self.addCollectionView){
            let yourWidth = collectionView.frame.size.width / 3.0
            let yourHeight = yourWidth

            if let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {

                collectionViewFlowLayout.minimumInteritemSpacing = 0

            }
            return CGSize(width: yourWidth - 20, height: yourHeight - 20)
        }
        else{
            let yourWidth = collectionView.frame.size.width / 3.0
            let yourHeight = yourWidth

            if let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {

                collectionViewFlowLayout.minimumInteritemSpacing = 0

            }
            return CGSize(width: yourWidth - 20, height: yourHeight - 20)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.addCollectionView){
            print("add -> \(indexPath.row)")
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! CellForAddDelete
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 14
            if(!cell.isAddDelete){
//                cell.backgroundColor = UIColor.systemRed
                cell.layer.borderColor = UIColor.black.cgColor
                cell.isAddDelete = true
            }
            else{
//                cell.backgroundColor = UIColor.systemTeal
                cell.layer.borderColor = UIColor.white.cgColor
                cell.isAddDelete = false
            }
        }
    }
    
}
