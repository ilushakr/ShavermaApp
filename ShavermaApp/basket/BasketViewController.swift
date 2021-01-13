//
//  BasketViewController.swift
//  ShavermaApp
//
//  Created by Mac on 12.01.2021.
//

import UIKit

protocol BasketDelegate: class {
    func updateTableView()
}

var additionalMutable = additional

class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyBasketLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var basketTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payButton.layer.cornerRadius = 10
        payButton.semanticContentAttribute = .forceRightToLeft
        payButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat(-10))
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
        basketTableView.register(BasketTableViewCell.nib(), forCellReuseIdentifier: BasketTableViewCell.id)
        basketTableView.register(BasketForAdditionalTableViewCell.nib(), forCellReuseIdentifier: BasketForAdditionalTableViewCell.id)
        
        basketTableView.allowsSelection = false
        
        payButton.addTarget(self,action:#selector(payButtonClicked),
                            for:.touchUpInside)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatBasket()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return order.count
        }
        else{
            if(order.count != 0){
                return 1
            }
            else{
                return 0
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.id, for: indexPath) as! BasketTableViewCell

            cell.orderProduct = order[indexPath.row]
            cell.index = indexPath.row
            cell.delegate = self
            cell.configure(row: indexPath.row)

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: BasketForAdditionalTableViewCell.id, for: indexPath) as! BasketForAdditionalTableViewCell
            cell.delegate = self

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath == [1, 0]){
            if(tableView.cellForRow(at: IndexPath(row: 0, section: 1)) != nil){
                (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BasketForAdditionalTableViewCell).collectionView.reloadData()
            }
        }
    }
    
    private func updatBasket()
    {
        if(order.count == 0){
            basketTableView.isHidden = true
            payButton.setTitle("Вернуться в меню", for: .normal)
        }
        else{
            basketTableView.isHidden = false
            payButton.setTitle("Оплатить", for: .normal)
        }
        basketTableView.reloadData()
    }
    
    @objc func payButtonClicked(sender:UIButton)
    {
        if(order.count == 0){
            self.tabBarController?.selectedIndex = 0
        }
        else{
            print("pay")
        }
    }
    
}

extension BasketViewController: BasketDelegate{
    func updateTableView(){
        if(basketTableView.cellForRow(at: IndexPath(row: 0, section: 1)) != nil){
            (basketTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BasketForAdditionalTableViewCell).collectionView.reloadData()
        }
        updatBasket()
    }
}
