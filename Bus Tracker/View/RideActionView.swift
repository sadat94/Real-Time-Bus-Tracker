//
//  RideActionView.swift
//  Bus Tracker
//
//  Created by Sadat Safuan on 5/13/20.
//  Copyright © 2020 Sadat Safuan. All rights reserved.
//


import UIKit
import MapKit

protocol RideActionViewDelegate: class {
    func uploadTrip(_ view: RideActionView)
    func cancelTrip()
    func pickupPassenger()
    func dropOffPassenger()
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide: return "CONFIRM BUS RIDE"
        case .cancel: return "CANCEL BUS RIDE"
        case .getDirections: return "GET DIRECTIONS"
        case .pickup: return "PICKUP PASSENGER"
        case .dropOff: return "DROP OFF PASSENGER"
        }
    }
    
    init() {
        self = .requestRide
    }
}

class RideActionView: UIView {

    // MARK: - Properties
    
    var destination: MKPlacemark? {
        didSet {
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    
    var buttonAction = ButtonAction()
    weak var delegate: RideActionViewDelegate?
    var user: User?
    
    var config = RideActionViewConfiguration() {
        didSet { configureUI(withConfig: config) }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        view.addSubview(infoViewLabel)
        infoViewLabel.centerX(inView: view)
        infoViewLabel.centerY(inView: view)
        
        return view
    }()
    
    private let infoViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.text = "BUS"
        return label
    }()
    
    private lazy var infoViewReg: UIView = {
         let view = UIView()
         view.backgroundColor = .purple
         
         view.addSubview(infoViewLabelReg)
         infoViewLabelReg.centerX(inView: view)
         infoViewLabelReg.centerY(inView: view)
      
         infoViewLabelReg.textAlignment = .center
         
         return view
     }()
    
    
     private let infoViewLabelReg: UILabel = {

         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 12)
         label.font = UIFont.boldSystemFont(ofSize: 12)
         label.textColor = .white
         label.text = "No info found"
         return label
     }()
    
    private lazy var infoViewMake: UIView = {
         let view = UIView()
         view.backgroundColor = .blue
         
         view.addSubview(infoViewLabelMake)
         infoViewLabelMake.centerX(inView: view)
         infoViewLabelMake.centerY(inView: view)
         
         return view
     }()
     
     private let infoViewLabelMake: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 15)
         label.textColor = .white
         label.text = "No info found"
         return label
     }()
    
    private lazy var infoViewColor: UIView = {
         let view = UIView()
         view.backgroundColor = .red
         
         view.addSubview(infoViewLabelColor)
         infoViewLabelColor.centerX(inView: view)
         infoViewLabelColor.centerY(inView: view)
         
         return view
     }()
     
     private let infoViewLabelColor: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 15)
         label.textColor = .white
         label.text = "No info found"
         label.textAlignment = .center
         return label
     }()
    
    private let uberInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "BUS SHARED SERVICE"
        label.textAlignment = .center
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM BUS RIDE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 16)
        infoView.setDimensions(height: 60, width: 50)
        infoView.layer.cornerRadius = 50 / 2
        
        addSubview(uberInfoLabel)
        uberInfoLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        uberInfoLabel.centerX(inView: self)
        
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: uberInfoLabel.bottomAnchor, left: leftAnchor,
                             right: rightAnchor, paddingTop: 4, height: 0.75)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,
                            right: rightAnchor, paddingLeft: 12, paddingBottom: 12,
                            paddingRight: 12, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed() {
        switch buttonAction {
        case .requestRide:
            delegate?.uploadTrip(self)
        case .cancel:
            delegate?.cancelTrip()
        case .getDirections:
            print("DEBUG: Handle get directions..")
        case .pickup:
            delegate?.pickupPassenger()
        case .dropOff:
            delegate?.dropOffPassenger()
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI(withConfig config: RideActionViewConfiguration) {
        switch config {
        case .requestRide:
            buttonAction = .requestRide
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .tripAccepted:
            guard let user = user else { return }
            
            if user.accountType == .passenger {
                titleLabel.text = "En Route To Passenger"
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
                infoViewLabel.text = String(user.fullname.first ?? "X")

            } else {
                buttonAction = .cancel
                actionButton.setTitle(buttonAction.description, for: .normal)
                titleLabel.text = "Bus Driver En Route"
                
                
                let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
                stack.axis = .vertical
                stack.spacing = 4
                stack.distribution = .fillEqually
                
                addSubview(stack)
                stack.centerX(inView: self)
                stack.anchor(top: topAnchor, paddingTop: 12)
                
                
            // PRINTING LABELS FOR PASSENGERS
                
                   addSubview(infoViewReg)
                  
                   infoViewReg.anchor(top: stack.bottomAnchor, paddingTop: 16)
                   infoViewReg.anchor(left: infoView.rightAnchor, paddingLeft: 16)
                   infoViewReg.setDimensions(height: 60, width: 100)
                   infoViewReg.layer.cornerRadius = 60 / 2
                   
                
                   addSubview(uberInfoLabel)
                   
                   uberInfoLabel.anchor(top: infoViewReg.bottomAnchor, paddingTop: 8)
                   uberInfoLabel.centerX(inView: self)
                   
                 
                
                
                   addSubview(infoViewColor)
                 
                   infoViewColor.anchor(top: stack.bottomAnchor, paddingTop: 16)
                   infoViewColor.anchor(left: infoViewReg.rightAnchor, paddingLeft: 16)
                   infoViewColor.anchor(right: rightAnchor)
                   infoViewColor.setDimensions(height: 60, width: 70)
                   infoViewColor.layer.cornerRadius = 60 / 2
                   
                
                   addSubview(uberInfoLabel)
                
                   uberInfoLabel.anchor(top: infoViewColor.bottomAnchor, paddingTop: 8)
                   uberInfoLabel.centerX(inView: self)
                   
                
                
                
                   addSubview(infoViewMake)
                
                   infoViewMake.anchor(top: stack.bottomAnchor, paddingTop: 16)
                   infoViewMake.anchor(right: infoView.leftAnchor, paddingRight: 16)
                   infoViewMake.anchor(left: leftAnchor)
                   infoViewMake.setDimensions(height: 60, width: 50)
                   infoViewMake.layer.cornerRadius = 60 / 2
                   
                   
                
                   addSubview(uberInfoLabel)
                
                   uberInfoLabel.anchor(top: infoViewMake.bottomAnchor, paddingTop: 8)
                   uberInfoLabel.centerX(inView: self)
                
                
                //SETTING ACTUAL DATA
                
                infoViewLabel.text = user.busnumber
                infoViewLabelReg.text = user.busRegistration
                infoViewLabelMake.text = user.busMake
                infoViewLabelColor.text = user.busColor
            }
            
            uberInfoLabel.text = user.fullname
            
            
        case .driverArrived:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                titleLabel.text = "Driver Has Arrived"
                addressLabel.text = "Please meet driver at pickup location"
            }
            
        case .pickupPassenger:
            titleLabel.text = "Arrived At Passenger Location"
            buttonAction = .pickup
            actionButton.setTitle(buttonAction.description, for: .normal)
            
        case .tripInProgress:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                actionButton.setTitle("TRIP IN PROGRESS", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "En Route To Destination"
            addressLabel.text = ""
            
        case .endTrip:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                actionButton.setTitle("ARRIVED AT DESTINATION", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .dropOff
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "Arrived at Destination"
        }
    }
}
