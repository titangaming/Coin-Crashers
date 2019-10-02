//
//  ViewController.swift
//  CoffeeBot
//
//  Created by Alex Cevicelow on 1/7/19.
//  Copyright © 2019 Alex Cevicelow. All rights reserved.
//

import UIKit

import Firebase



class ViewController: UIViewController, UITextFieldDelegate {
    //Setting up data base
    var db: Firestore!
    
    //setting up custom colors
    let shapelayer = CAShapeLayer()
    let primaryGreen = UIColor(named: "primaryGreen")
    let secondaryGreen = UIColor(named: "secondaryGreen")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        



        
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            print(uid as Any)
            let email = user.email
            print(email as Any)
            
            // ...
        }
        else {
            print("not working with getting user data")
        }
        //testing area
        
        
        //custom nav
        struct System {
            static func clearNavigationBar(forBar navBar: UINavigationBar) {
                navBar.setBackgroundImage(UIImage(), for: .default)
                navBar.shadowImage = UIImage()
                navBar.isTranslucent = true

            }
        }
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear

        }
        
        
        // [START firestore connection]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        //adding storyboard entry points
        view.addSubview(welcomeName)
        view.addSubview(coffeeMakerName)
        view.addSubview(startBrewQueButton)
        
        //setting up auto layouts for programmatic ui
        setupLayout()
        
        //making track for status ring
        let tracklayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: UIScreen.main.bounds.size.width*0.5, y:400) , radius:130 , startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi , clockwise:true )
        tracklayer.path = circularPath.cgPath
        
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = secondaryGreen?.cgColor
        tracklayer.lineWidth = 5
        tracklayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(tracklayer)
        
        //making circle
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = primaryGreen?.cgColor
        shapelayer.lineWidth = 5
        shapelayer.lineCap = CAShapeLayerLineCap.round
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.strokeEnd = 0
        view.layer.addSublayer(shapelayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    

    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 10
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapelayer.add(basicAnimation, forKey: "ursobasic")

    }
    
    @objc private func startBrewQue() {
        updateServoState()
        getDocument()
        OperationQueue.main.addOperation {
            [weak self] in
            self?.performSegue(withIdentifier: "goingToCoffeeType", sender: self)
            self?.navigationController?.isNavigationBarHidden = false;
        }

    }

    
    private func setupLayout() {
    //username layout
        welcomeName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeName.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        welcomeName.widthAnchor.constraint(equalToConstant: 350).isActive = true
        welcomeName.heightAnchor.constraint(equalToConstant: 60).isActive = true
    //coffee maker name
        coffeeMakerName.centerXAnchor.constraint(equalTo: welcomeName.centerXAnchor).isActive = true
        coffeeMakerName.topAnchor.constraint(equalTo: welcomeName.topAnchor, constant: 100).isActive = true
        coffeeMakerName.widthAnchor.constraint(equalToConstant: 450).isActive = true
        coffeeMakerName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coffeeMakerName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coffeeMakerName.textAlignment = .center
    //Coffee que button
        startBrewQueButton.centerXAnchor.constraint(equalTo: coffeeMakerName.centerXAnchor).isActive = true
        startBrewQueButton.topAnchor.constraint(equalTo: coffeeMakerName.topAnchor, constant: 375).isActive = true
        //startBrewQueButton.widthAnchor.constraint(equalToConstant: 450).isActive = true
        startBrewQueButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        startBrewQueButton.widthAnchor.constraint(equalToConstant: 270).isActive = true
        startBrewQueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //username area
    let welcomeName: UITextView = {
        var userNickname:String = "Alex"
        let textView = UITextView()
        textView.text = "Welcome \(userNickname)"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = textView.font?.withSize(25)
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    //label of coffee maker type/name
    let coffeeMakerName: UILabel = {
        let label = UILabel()
        label.text = "This is label view."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.black
        return label
    }()
    
    //start brew button (server call)
    let startBrewQueButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonColor = UIColor(named: "primaryGreen")
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 30)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = 5
        button.setTitle("Start Brew", for: .normal)
        button.addTarget(self, action: #selector(startBrewQue), for: .touchUpInside)
        return button
    }()
    

    
    
    //setting up firebase connection
    private func updateServoState() {
        // [START update_document]
        
        //setting location
        let servoUpdate = db.collection("servoState").document("FijSHqTyEstie7U9UZHI")
        
        // updating the servo for cup drop
        servoUpdate.updateData([
            "servoDispense": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        // [END update_document]
    }
    
    //setting up device dUID


    
    
    
    private func getDocument() {
        // [START get_document]
        let docRef = db.collection("servoState").document("FijSHqTyEstie7U9UZHI")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        // [END get_document]
    }
    

}

