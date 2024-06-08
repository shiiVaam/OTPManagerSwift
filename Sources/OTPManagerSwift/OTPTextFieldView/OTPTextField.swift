//
//  OTPTextField.swift
//
//
//  Created by Shivam on 08/06/24.
//

import UIKit

protocol OTPTextFieldDelegate: AnyObject {
    func backspaceTapped(for textField: UITextField)
}

final class OTPTextField: UITextField {
    
   weak var otpDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        otpDelegate?.backspaceTapped(for: self)
    }
}
