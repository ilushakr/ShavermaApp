//
//  UnsrollableSegmanedControl.swift
//  ShavermaApp
//
//  Created by Mac on 07.01.2021.
//

import UIKit

class UnscrollableSegmentedControl: UISegmentedControl{
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard type(of: gestureRecognizer).description() != "UIScrollViewPanGestureRecognizer" else {
            return true
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}
