//
//  LoginViewController.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 4.11.2022.
//

// TODO: fix button behavior. It should animate when tapped
// TODO: add user name for title of tasks page
// TODO: add alert when user successful register

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private var titleLabel = UILabel()
    private var warningLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        return label
    }()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var loginButton = UIButton()
    private var registerButton = UIButton()
    private let generalStackView = UIStackView()

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .pagesBackgroundColor
        configureSubviews()
        
        // Check user authentication
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.showTasksViewController()
            }
        }
        
        // Add observers to adjust view when keyboard will show and hide
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Actions
    
    private func displayWarningLabel(with text: String) {
        warningLabel.text = text
        warningLabel.alpha = 1
    }
    
    private func showTasksViewController() {
        let navController = UINavigationController(rootViewController: TasksViewController())
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func loginTapped() {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != ""
        else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if let error = error {
                self?.displayWarningLabel(with: "Error: \(error)")
                return
            }
            if let _ = user {
                self?.showTasksViewController()
                return
            }
            
            self?.displayWarningLabel(with: "No such user or password is incorrect")
        })
    }
    
    @objc private func registerTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != ""
        else {
            displayWarningLabel(with: "Empty field(s)")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    
                } else {
                    self?.displayWarningLabel(with: "user = nil")
                }
            } else {
                self?.displayWarningLabel(with: "error occured: \(error!)")
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let shift = generalStackView.frame.size.height + generalStackView.frame.origin.y - keyboardFrame.origin.y
        
        view.frame.origin.y = -shift
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = .zero
    }

    //MARK: - Configure subviews
    
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
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        bottomStackView.addArrangedSubview(loginButton)
        
        registerButton.tintColor = labelsTextColor
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: fontName, size: registerFontSize)
        registerButton.layer.cornerRadius = cornerRadius
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
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

