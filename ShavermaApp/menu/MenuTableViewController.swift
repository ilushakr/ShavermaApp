//
//  MenuTableViewController.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit

import MaterialComponents.MaterialBottomSheet
import SDWebImage

let menuItems = menu.getProducts()
let menuIndexes = menu.getIndexes()
let merch = menu.groups![0].products!
let items = menu.getGroups()
var order: [OrderProduct] = [OrderProduct]()
let additional: [Product] = menu.groups![1].products!

class MenuTableViewController: UITableViewController {
    
    let merchCellSpacing = (1 / 16) * UIScreen.main.bounds.width
    let merchCellWidth = (3 / 4) * UIScreen.main.bounds.width
    let merchCellHeight = (1 / 4) * UIScreen.main.bounds.width
    let spacing = (1 / 8) * UIScreen.main.bounds.width
    
    lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.sectionInset = .init(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
        layout.minimumLineSpacing = self.merchCellSpacing
        layout.itemSize = .init(width: self.merchCellWidth, height: self.merchCellHeight)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()
    
    var scrollForGroups: UIScrollView!
    lazy var unscrollableSegmentedControl : UnscrollableSegmentedControl = UnscrollableSegmentedControl(items: items)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.register(TableViewCellForMerch.self, forCellReuseIdentifier: TableViewCellForMerch.id)
        tableView.register(TableViewCellForMenuUI.nib(), forCellReuseIdentifier: TableViewCellForMenuUI.id)
        
        collectionView.register(MerchCollectionViewCell.self, forCellWithReuseIdentifier: MerchCollectionViewCell.id)
        
        initHeaderForMenu()
        
    }

    private func initHeaderForMenu(){
        navigationItem.title = "Меню"
        
        unscrollableSegmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        unscrollableSegmentedControl.selectedSegmentIndex = 0
//        unscrollableSegmentedControl.backgroundColor = UIColor(patternImage: UIImage(named: "kitten1")!)
        unscrollableSegmentedControl.selectedSegmentTintColor = .systemYellow
        
        scrollForGroups = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: unscrollableSegmentedControl.frame.height + 10))
        view.addSubview(scrollForGroups)

        scrollForGroups.translatesAutoresizingMaskIntoConstraints = false

        scrollForGroups.addSubview(unscrollableSegmentedControl)

        scrollForGroups.contentSize = CGSize(width: unscrollableSegmentedControl.frame.width, height: unscrollableSegmentedControl.frame.height)
        scrollForGroups.showsHorizontalScrollIndicator = false
        scrollForGroups.backgroundColor = .white
    }

//    Tabs
    @objc func indexChanged(_ sender: UISegmentedControl) {
        let itemWidth = unscrollableSegmentedControl.frame.width / CGFloat(items.count)
        
        if(itemWidth * CGFloat(sender.selectedSegmentIndex) + itemWidth / 2 >= UIScreen.main.bounds.width / 2){
            if(unscrollableSegmentedControl.frame.width - itemWidth * CGFloat(sender.selectedSegmentIndex) - itemWidth / 2 >= UIScreen.main.bounds.width / 2){
                scrollForGroups.setContentOffset(CGPoint(x: itemWidth * CGFloat(sender.selectedSegmentIndex) - UIScreen.main.bounds.width / 2 + itemWidth / 2, y: 0), animated: true)
            }
            else{
                scrollForGroups.setContentOffset(CGPoint(x: scrollForGroups.contentSize.width - scrollForGroups.bounds.width + scrollForGroups.contentInset.right, y: 0), animated: true)
            }
        }
        else{
            scrollForGroups.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    
        if(sender.selectedSegmentIndex == 0){
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        else{
            tableView.scrollToRow(at: IndexPath(row: menuIndexes[sender.selectedSegmentIndex], section: 1), at: .top, animated: true)
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
            return nil
        }
        else{
            return scrollForGroups
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return CGFloat(0)
        }
        else{
            return CGFloat(scrollForGroups.frame.height)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else{
            return menuItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellForMerch.id, for: indexPath) as! TableViewCellForMerch
            cell.contentView.addSubview(self.collectionView)
            
            self.collectionView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            self.collectionView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            self.collectionView.heightAnchor.constraint(equalToConstant: merchCellHeight).isActive = true
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellForMenuUI.id, for: indexPath) as! TableViewCellForMenuUI
//            cell.configure(product: menuItems[indexPath.row], image: "kitten1", row: indexPath.row)
            cell.product = menuItems[indexPath.row]
            cell.delegate = self
            cell.configure(row: indexPath.row)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return merchCellHeight
        }
        else{
            return UIScreen.main.bounds.height / 5
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bottomSheetController = PageViewControllerBottomSheet(products: menuItems)
        bottomSheetController.startPage = indexPath.row
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: bottomSheetController)
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height)
        bottomSheetController.bottomSheet = bottomSheet

        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    //    handle scrolling with tabs
    private var lastContentOffset: CGFloat = 0
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            if(menuIndexes.contains((tableView.indexPathsForVisibleRows?.last?[1])!)){
                unscrollableSegmentedControl.selectedSegmentIndex = menuIndexes.firstIndex(of: (tableView.indexPathsForVisibleRows?.last?[1])!)! - 1
                moveSegment()
            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            if(menuIndexes.contains((tableView.indexPathsForVisibleRows?.last?[1])! - 1)){
                unscrollableSegmentedControl.selectedSegmentIndex = menuIndexes.firstIndex(of: (tableView.indexPathsForVisibleRows?.last?[1])! - 1)!
                
                moveSegment()
            }
        }

            // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    private func moveSegment(){
        let itemWidth = unscrollableSegmentedControl.frame.width / CGFloat(items.count)
        
        if(itemWidth * CGFloat(unscrollableSegmentedControl.selectedSegmentIndex) + itemWidth / 2 >= UIScreen.main.bounds.width / 2){
            if(unscrollableSegmentedControl.frame.width - itemWidth * CGFloat(unscrollableSegmentedControl.selectedSegmentIndex) - itemWidth / 2 >= UIScreen.main.bounds.width / 2){
                scrollForGroups.setContentOffset(CGPoint(x: itemWidth * CGFloat(unscrollableSegmentedControl.selectedSegmentIndex) - UIScreen.main.bounds.width / 2 + itemWidth / 2, y: 0), animated: true)
            }
            else{
                scrollForGroups.setContentOffset(CGPoint(x: scrollForGroups.contentSize.width - scrollForGroups.bounds.width + scrollForGroups.contentInset.right, y: 0), animated: true)
            }
        }
        else{
            scrollForGroups.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height - 250, width: UIScreen.main.bounds.width / 2, height: 35))
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

extension MenuTableViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merch.count
    }
       
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MerchCollectionViewCell.id, for: indexPath) as! MerchCollectionViewCell
        cell.backgroundColor = .red
        cell.configure(product: merch[indexPath.row], cellWidth: merchCellWidth)
       
        return cell
   }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bottomSheetController = PageViewControllerBottomSheet(products: merch)
        bottomSheetController.startPage = indexPath.row
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: bottomSheetController)
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height)
        bottomSheetController.bottomSheet = bottomSheet

        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
    }
    
}


extension MenuTableViewController: TableViewCellForMenuUIDelegate{
    func didTapped(_ tag: Int) {
        self.showToast(message: "Добавлено в корзину", font: .systemFont(ofSize: 12.0))
        order.insert(OrderProduct(product: menuItems[tag], productCount: 1), at: 0)
    }
}
