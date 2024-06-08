//
//  OTPStackView.swift
//
//
//  Created by Shivam on 08/06/24.
//

import Foundation
import UIKit

public protocol OTPDelegate: AnyObject {
    func completed()
}

final public class OTPStackView: UIStackView {
    
    public var fields = [OTPTextFieldView]()
    private var digits = OTPManager.OTPLength.four
    
    public weak var delegate: OTPDelegate?
    
    @IBInspectable var otpLength: Int {
        get {
            return digits.value
        }
        set(length) {
            digits = OTPManager.OTPLength.instance(for: length)
        }
    }
    
    @IBInspectable public var borderDeselectedColor: UIColor {
        get {
            return OTPTextFieldView.deselectedBorderColor ?? .gray
        }
        set {
            OTPTextFieldView.deselectedBorderColor = newValue
        }
    }
    
    @IBInspectable public var borderSelectedColor: UIColor {
        get {
            return OTPTextFieldView.selectedBorderColor ?? .gray
        }
        set {
            OTPTextFieldView.selectedBorderColor = newValue
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return OTPTextFieldView.borderWidth ?? 1.0
        }
        set {
            OTPTextFieldView.borderWidth = newValue
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return OTPTextFieldView.cornerRadius ?? 12.0
        }
        set {
            OTPTextFieldView.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var selectedTextColor: UIColor {
        get {
            return OTPTextFieldView.selectedTextColor ?? .gray
        }
        set {
            OTPTextFieldView.selectedTextColor = newValue
        }
    }
    
    @IBInspectable public var deselectedTextColor: UIColor {
        get {
            return OTPTextFieldView.deselectedTextColor ?? .gray
        }
        set {
            OTPTextFieldView.deselectedTextColor = newValue
        }
    }
    
    @IBInspectable public var tintfieldColor: UIColor {
        get {
            return OTPTextFieldView.tintFieldColor ?? .gray
        }
        set {
            OTPTextFieldView.tintFieldColor = newValue
        }
    }
    
    @IBInspectable var fontText: UIFont {
        get {
            return OTPTextFieldView.font ?? .systemFont(ofSize: 14)
        }
        set {
            OTPTextFieldView.font = newValue
        }
    }
    
    
    /**
     OTP value entered by the user.
     */
    public var otpString: String? {
        var otpValue = String()
        for view in fields {
            if let part = view.otpPart {
                otpValue.append(part)
            } else {
                return nil
            }
        }
        return otpValue.isEmpty ? nil : otpValue
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configurations
    /**
     Method for UI configuration of the OTP Field.
     - Parameter active: Should become active and open up the keyboard as soon as you show up the view.
     */
    public func configure(withFirstResponder active: Bool = true) {
        prepareLayout()
        if active {
            (arrangedSubviews.first as? OTPTextFieldView)?.becomeResponder()
        }
    }
    
    public func clear() {
        fields.forEach {
            $0.txtFldOtpPart.text = nil
        }
    }
    
    public func invalidOTP() {
        fields.forEach {
            $0.invalidOTP()
        }
    }
    
    public func resetOTP() {
        clear()
        fields.forEach { $0.deselectedField() }
    }
    
    private func prepareLayout() {
        (0..<digits.value).forEach { index in
            let otpView = OTPTextFieldView.instantiateFromNib()
            otpView.tag = index
            otpView.delegate = self
            fields.append(otpView)
            addArrangedSubview(otpView)
        }
    }
}

// MARK: - Textfield controlling delegates
extension OTPStackView: OTPTextFieldViewDelegate {
    func textBeginEditing(_ view: OTPTextFieldView) {
        fields.forEach { $0.deselectedField()}
        view.selectedField()
    }
    
    
    func textEntered(in view: OTPTextFieldView) {
        switch view.tag {
        case _ where view.tag == otpLength - 1:
            view.resignResponder()
        case _ where view.tag < otpLength - 1:
            let nextView = fields[view.tag + 1]
            nextView.becomeResponder()
        default:
            break
        }
    }
    
    func textRemoved(from view: OTPTextFieldView) {
        if view.tag > 0 {
            let previousView = fields[view.tag - 1]
            previousView.becomeResponder()
        }
    }
    
    func textCompleted() {
        delegate?.completed()
    }
}
