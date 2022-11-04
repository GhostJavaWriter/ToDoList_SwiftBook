//
//  ViewController.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 4.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var titleLabel = UILabel()
    private var warningLabel = UILabel()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var loginButton = UIButton()
    private var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        configureSubviews()
    }

    private func configureSubviews() {
        
        let fontName = "Tamil Sangam MN"
        let titleFontSize: CGFloat = 40
        let labelsTextColor = UIColor.white
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = labelsTextColor
        titleLabel.font = UIFont(name: fontName, size: titleFontSize)
        titleLabel.text = "To do list"
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

