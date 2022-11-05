//
//  ViewController.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 4.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    private var titleLabel = UILabel()
    private var warningLabel = UILabel()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var loginButton = UIButton()
    private var registerButton = UIButton()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 118/255,
                                       green: 190/255,
                                       blue: 208/255,
                                       alpha: 1)
        configureSubviews()
    }

    //MARK: - Support functions
    private func configureSubviews() {
        
        // Common configuration
        let fontName = "Tamil Sangam MN"
        let titleFontSize: CGFloat = 40
        let warningTextColor = UIColor.red
        let warningFontSize: CGFloat = 18
        
        let registerFontSize: CGFloat = 14
        let loginFontSize: CGFloat = 18
        let loginBackground = UIColor(white: 1, alpha: 0.5)
        let buttonsWidthRation: CGFloat = 0.5
        let cornerRadius: CGFloat = 5
        
        let labelsTextColor = UIColor.white
        let textFieldsBackgroundColor = UIColor.white
        
        let textFieldsHeight: CGFloat = 30
        
        let spaceBtwStackViews: CGFloat = 50
        let spaceBtwSubviews: CGFloat = 10
        let generalStackViewPadding: CGFloat = 40
        let textFieldsWidthRatio: CGFloat = 0.75
        
        let generalStackView = UIStackView()
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        generalStackView.alignment = .center
        generalStackView.axis = .vertical
        generalStackView.spacing = spaceBtwStackViews
        view.addSubview(generalStackView)
        
        // Setup top stack view
        let topStackView = UIStackView()
        topStackView.alignment = .center
        topStackView.axis = .vertical
        topStackView.spacing = spaceBtwSubviews
        generalStackView.addArrangedSubview(topStackView)
        
        titleLabel.textColor = labelsTextColor
        titleLabel.font = UIFont(name: fontName, size: titleFontSize)
        titleLabel.text = "To do list"
        topStackView.addArrangedSubview(titleLabel)
        
        warningLabel.textColor = warningTextColor
        warningLabel.font = UIFont(name: fontName, size: warningFontSize)
        warningLabel.text = "User does not exist"
        topStackView.addArrangedSubview(warningLabel)
        
        // Setup middle stack view
        let middleStackView = UIStackView()
        middleStackView.alignment = .center
        middleStackView.axis = .vertical
        middleStackView.spacing = spaceBtwSubviews
        generalStackView.addArrangedSubview(middleStackView)
        
        //TODO: fix placeholder text edge insets
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.clearButtonMode = .always
        emailTextField.backgroundColor = textFieldsBackgroundColor
        middleStackView.addArrangedSubview(emailTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = textFieldsBackgroundColor
        middleStackView.addArrangedSubview(passwordTextField)
        
        // Setup bottom stack view
        let bottomStackView = UIStackView()
        bottomStackView.alignment = .center
        bottomStackView.axis = .vertical
        bottomStackView.spacing = spaceBtwSubviews
        generalStackView.addArrangedSubview(bottomStackView)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.tintColor = labelsTextColor
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = loginBackground
        loginButton.layer.cornerRadius = cornerRadius
        loginButton.titleLabel?.font = UIFont(name: fontName, size: loginFontSize)
        bottomStackView.addArrangedSubview(loginButton)
        
        registerButton.tintColor = labelsTextColor
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: fontName, size: registerFontSize)
        registerButton.layer.cornerRadius = cornerRadius
        bottomStackView.addArrangedSubview(registerButton)
        
        NSLayoutConstraint.activate([
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: generalStackViewPadding),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -generalStackViewPadding),
            generalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emailTextField.widthAnchor.constraint(equalTo: generalStackView.widthAnchor,
                                                  multiplier: textFieldsWidthRatio),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight),
            passwordTextField.widthAnchor.constraint(equalTo: generalStackView.widthAnchor,
                                                     multiplier: textFieldsWidthRatio),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight),
            loginButton.widthAnchor.constraint(equalTo: generalStackView.widthAnchor,
                                               multiplier: buttonsWidthRation),
            registerButton.widthAnchor.constraint(equalTo: generalStackView.widthAnchor,
                                                  multiplier: buttonsWidthRation),
        ])
    }
}

