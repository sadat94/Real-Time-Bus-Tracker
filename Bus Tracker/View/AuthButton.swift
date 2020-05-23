//
//  AuthButton.swift
//  Bus Tracker
//
//  Created by Sadat Safuan on 5/13/20.
//  Copyright © 2020 Sadat Safuan. All rights reserved.
//


import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        backgroundColor = .mainBlueTint
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    
        //setTitleColor(.white, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

