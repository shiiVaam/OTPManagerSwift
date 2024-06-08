//
//  UIView+Extenion.swift
//  
//
//  Created by Shivam on 08/06/24.
//

import UIKit

extension UIView {
    
    class func instantiateFromNib() -> Self {
        return instantiateFromNib(self)
    }

    class func instantiateFromNib<T: UIView>(_ viewType: T.Type) -> T {
        
        return Bundle.module.loadNibNamed(String(describing: viewType), owner: nil, options: nil)?.first as! T
    }
}
