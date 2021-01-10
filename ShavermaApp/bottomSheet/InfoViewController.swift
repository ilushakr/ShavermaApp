//
//  InfoViewController.swift
//  ShavermaApp
//
//  Created by Mac on 08.01.2021.
//

import UIKit

class InfoViewController: UIViewController {

    var product: Product? = nil
    
    @IBOutlet weak var enegryLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var bacgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let carbo = product?.carbohydrateAmount {
            carbohydratesLabel.text = "\(round(carbo))"
        }
        
        if let energy = product?.energyAmount {
            enegryLabel.text = "\(round(energy))"
        }
        
        if let fat = product?.fatAmount {
            fatLabel.text = "\(round(fat))"
        }
        
        if let protein = product?.fiberAmount {
            proteinLabel.text = "\(round(protein))"
        }
        
        infoView.layer.cornerRadius = 10
        bacgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
    }
    
    @IBAction func closeInfo(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func dismissOnTapOutside(){
       dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
