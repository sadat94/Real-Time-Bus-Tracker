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
        
        layer.cornerRadius = 5
        backgroundColor = .mainBlueTint
        setTitleColor(.white, for: .normal)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
