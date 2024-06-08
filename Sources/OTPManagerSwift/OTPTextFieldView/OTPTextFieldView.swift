//
//  OTPTextFieldView.swift
//
//
//  Created by Shivam on 08/06/24.
//

import UIKit

protocol OTPTextFieldViewDelegate: AnyObject {
    func textEntered(in view: OTPTextFieldView)
    func textRemoved(from view: OTPTextFieldView)
    func textBeginEditing(_ view: OTPTextFieldView)
    func textCompleted()
}

final public class OTPTextFieldView: UIView {
    
    @IBOutlet weak var txtFldOtpPart: OTPTextField!
    
    weak var delegate: OTPTextFieldViewDelegate?
    
    static var selectedBorderColor: UIColor?
    static var deselectedBorderColor: UIColor?
    static var font: UIFont?
    static var tintFieldColor: UIColor?
    static var selectedTextColor: UIColor?
    static var deselectedTextColor: UIColor?
    static var borderWidth: CGFloat?
    static var cornerRadius: CGFloat?

    
    private var isEmpty = true
    
    public override var tag: Int {
        willSet {
            txtFldOtpPart.tag = newValue
            txtFldOtpPart.keyboardType = .numberPad
            txtFldOtpPart.delegate = self
            txtFldOtpPart.otpDelegate = self
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = OTPTextFieldView.cornerRadius ?? 12
        self.layer.borderColor = OTPTextFieldView.deselectedBorderColor?.cgColor
        self.layer.borderWidth = OTPTextFieldView.borderWidth ?? 1.0
        self.clipsToBounds = true
        txtFldOtpPart.tintColor = OTPTextFieldView.tintFieldColor
        txtFldOtpPart.textColor = OTPTextFieldView.deselectedTextColor
        txtFldOtpPart.font = OTPTextFieldView.font
//        txtFldOtpPart.attributedPlaceholder = NSAttributedString(string:"0", attributes: [.foregroundColor: Colors.Hutan20.value, .font : OTPTextFieldView.font])

    }
    
    var otpPart: String? {
        return txtFldOtpPart.text
    }
    
    func deselectedField() {
        self.layer.borderColor = OTPTextFieldView.deselectedBorderColor?.cgColor
        txtFldOtpPart.textColor = OTPTextFieldView.deselectedTextColor
    }
    
    func selectedField() {
        self.layer.borderColor = OTPTextFieldView.selectedBorderColor?.cgColor
        txtFldOtpPart.textColor = OTPTextFieldView.selectedTextColor
    }
    
    func invalidOTP(){
        self.layer.borderColor = UIColor.red.cgColor
        txtFldOtpPart.textColor = UIColor.red
    }
    
    func resetOTP() {
        self.deselectedField()
    }
    
    func resignResponder() {
        txtFldOtpPart.resignFirstResponder()
        deselectedField()
        delegate?.textCompleted()
    }
        
    func becomeResponder() {
        txtFldOtpPart.becomeFirstResponder()
        selectedField()
    }
}

// MARK: - UItextfield delegates
extension OTPTextFieldView: UITextFieldDelegate {
    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.count > 0 {
            textField.text = string
            isEmpty = false
            delegate?.textEntered(in: self)
            return false
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textBeginEditing(self)
    }
}

// MARK: - OTPTextField delegates
extension OTPTextFieldView: OTPTextFieldDelegate {
    func backspaceTapped(for textField: UITextField) {
        if isEmpty {
            delegate?.textRemoved(from: self)
        }
        isEmpty = true
    }
}
