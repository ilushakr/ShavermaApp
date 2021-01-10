//
//  BasketTableViewController.swift
//  ShavermaApp
//
//  Created by Mac on 08.01.2021.
//

import UIKit

protocol BasketDelegate: class {
    func updateTableView()
}

var additionalMutable = additional

class BasketTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BasketTableViewCell.nib(), forCellReuseIdentifier: BasketTableViewCell.id)
        tableView.register(BasketForAdditionalTableViewCell.nib(), forCellReuseIdentifier: BasketForAdditionalTableViewCell.id)
        
        tableView.allowsSelection = false

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }

}

extension BasketTableViewController: BasketDelegate{
    func updateTableView(){
        if let res = try?(tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BasketForAdditionalTableViewCell){
            (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BasketForAdditionalTableViewCell).collectionView.reloadData()
        } else{
            print("error")
        }
        tableView.reloadData()
    }
}
