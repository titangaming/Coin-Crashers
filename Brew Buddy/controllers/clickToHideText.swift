//
//  clickToHideText.swift
//  Brew Buddy
//
//  Created by Alex Cevicelow on 3/21/19.
//  Copyright © 2019 Alex Cevicelow. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
