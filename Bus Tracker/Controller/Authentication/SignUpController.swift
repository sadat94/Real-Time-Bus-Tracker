//
//  SignUpController.swift
//  Bus Tracker
//
//  Created by Sadat Safuan on 5/13/20.
//  Copyright © 2020 Sadat Safuan. All rights reserved.
//


import UIKit
import Firebase
import GeoFire
import CoreLocation

class SignUpController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
        
    var locationManager = CLLocationManager()
    var location: CLLocation!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BUS TRACKER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var busnumberContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "chevron-sign-to-right"), textField: busnumberTextField)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    
    private lazy var busRegistrationContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "chevron-sign-to-right"), textField: busRegistrationTextField)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    private lazy var busMakeContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "chevron-sign-to-right"), textField: busMakeTextField)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    private lazy var busColorContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "chevron-sign-to-right"), textField: busColorTextField)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"),
                                               segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private let busnumberTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Bus Number (Only for drivers)",
                                       isSecureTextEntry: false)
    }()
    
    private let busRegistrationTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Bus Registration (Only for drivers)",
                                       isSecureTextEntry: false)
    }()
    
    private let busMakeTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Bus Make (Only for drivers)",
                                       isSecureTextEntry: false)
    }()
    
    private let busColorTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Bus Color (Only for drivers)",
                                       isSecureTextEntry: false)
    }()
    
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Get Location Permission one time only
        locationManager.requestWhenInUseAuthorization()
        // Need to update location and get location data in locationManager object with delegate
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()

        
        configureUI()
        
    }
    
    // MARK: - Selectors
    
    func authorizelocationstates(){
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                location = locationManager.location
                print("DEBUG: Driver coodinates are \(location!)")
            }
            else{
                // Note : This function is overlap permission
                  locationManager.requestWhenInUseAuthorization()
                  authorizelocationstates()
            }
        }
       
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locationManager = manager
            // Only called when variable have location data
            authorizelocationstates()
        }
        
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let busnumber = busnumberTextField.text else { return }
        guard let busRegistration = busRegistrationTextField.text else { return }
        guard let busMake = busMakeTextField.text else { return }
        guard let busColor = busColorTextField.text else { return }
    
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
                
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullname": fullname,
                          "busnumber": busnumber,
                          "busRegistration": busRegistration,
                          "busMake": busMake,
                          "busColor": busColor,
                          "accountType": accountTypeIndex] as [String : Any]
            
            
            if accountTypeIndex == 1 {
                
                let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                guard let location = self.locationManager.location else { return }
                
                geofire.setLocation(location, forKey: uid, withCompletionBlock: { (error) in
                    self.uploadUserDataAndShowHomeController(uid: uid, values: values)
                })
              
            }
            
            self.uploadUserDataAndShowHomeController(uid: uid, values: values)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    func uploadUserDataAndShowHomeController(uid: String, values: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? ContainerController else { return }
            controller.configure()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullnameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   busnumberContainerView,
                                                   busRegistrationContainerView,
                                                   busMakeContainerView,
                                                   busColorContainerView,
                                                   signUpButton])
        
        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 40, paddingLeft: 16,
                     paddingRight: 16)
        
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
}
