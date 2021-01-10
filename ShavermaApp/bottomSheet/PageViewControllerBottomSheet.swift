//
//  PageViewControllerBottomSheet.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class PageViewControllerBottomSheet: UIPageViewController, UIPageViewControllerDataSource {
    
    var products: [Product]
    var startPage = 0
    
    var bottomSheet: MDCBottomSheetController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let vc = self.pageViewController(for: startPage){
            setViewControllers([vc], direction: .forward, animated: true) { (bool) in }
        }
        
    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }
    
    init(products: [Product]) {
        self.products = products
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? ItemBottomSheetViewController)?.index ?? 0) - 1
        return self.pageViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? ItemBottomSheetViewController)?.index ?? 0) + 1
        return self.pageViewController(for: index)
    }
    
    func pageViewController(for index: Int) -> ItemBottomSheetViewController?{
        if(index < 0){
            return nil
        }
        if(index > self.products.count - 1){
            return nil
        }
        let vc = ItemBottomSheetViewController(product: self.products[index])
        vc.bottomSheet = self.bottomSheet
        vc.index = index
        return vc
    }
    
}
