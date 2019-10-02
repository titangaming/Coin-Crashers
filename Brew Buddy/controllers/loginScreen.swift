//
//  loginScreen.swift
//  Brew Buddy
//
//  Created by Alex Cevicelow on 1/31/19.
//  Copyright © 2019 Alex Cevicelow. All rights reserved.
//

import UIKit

import Firebase


class loginScreen: UIViewController {

    
   
    @IBOutlet weak var getStarted: UIButton!
    
    @IBOutlet weak var emailField: HoshiTextField!
    
    @IBOutlet weak var passwordField: HoshiTextField!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;

        //refrencing extension for hiding keyboard 
        self.hideKeyboard()

        
       //rounded corners for get started button
        getStarted.layer.cornerRadius = 5
 
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        


        // Do any additional setup after loading the view.
        
        

    }
    

    


    

    @IBAction func loginTap(_ sender: Any) {

        
        if let email = self.emailField.text, let password = self.passwordField.text {

                // [START headless_email_auth]
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    
                        if let error = error {
                            //error with login details show notice
                            let alert = UIAlertController(title: "Login Error", message: "Invalid Login Credentials", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    //This is all the code for if the login is valid and is working
                    //setting device identification for no login auth

                    //this is for setting up db and getting the correct doc
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        print(uid as Any)
                        let email = user.email
                        print(email as Any)
   
                    }
                
                    // [END update_document]

                    //updatting device id in firestore
                    settingDeviceId()
                    
                    
                    
                
                    OperationQueue.main.addOperation {
                        [weak self] in
                        self?.performSegue(withIdentifier: "goHomeAfterLogin", sender: self)

                    }


                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            
        }
        else {
            print("the fill area is empty")
            //self.showMessagePrompt("email/password can't be empty")
        }

    }//end button press
    
}
private func settingDeviceId() {
    // [START update_document]
    let testingDataChange = db.collection("homeBase").document("oPqMqzTLx4g12wVPfHzgFhrAsxa2")
    let settingDeviceID = UIDevice.current.identifierForVendor?.uuidString
    UserDefaults.standard.set(settingDeviceID, forKey: "settingAuth")

    
    // Set the "capital" field of the city 'DC'
    testingDataChange.updateData([
        "deviceID": settingDeviceID
    ]) { err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("Document successfully updated")
        }
    }
    // [END update_document]
}


