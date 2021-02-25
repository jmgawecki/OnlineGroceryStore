//
//  registerTextField.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

class registerTextField: UITextField {

    //MARK: - Overrides

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureKeyboardToolbar()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(placeholder: String, capitalised: UITextAutocapitalizationType, isPassword: Bool) {
        self.init(frame: .zero)
        self.placeholder            = placeholder
        self.autocapitalizationType = capitalised
        self.isSecureTextEntry      = isPassword
    }
    
    
    //MARK:- Objectives
    
    
    @objc private func barButtonTapped() {
        resignFirstResponder()
    }
    
    
    //MARK: - Configurations
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor         = .white
        
        borderStyle             = .roundedRect
        font                    = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        textAlignment           = .left
        returnKeyType           = .done
        autocorrectionType      = .no
        autocapitalizationType  = .none
    }
    
    private func configureKeyboardToolbar() {
        let toolbar         = UIToolbar()
        let flexibleSpace   = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done            = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(barButtonTapped))
        toolbar.items = [flexibleSpace, done]
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }
}
