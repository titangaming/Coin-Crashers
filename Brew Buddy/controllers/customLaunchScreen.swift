//
//  customLaunchScreen.swift
//  Brew Buddy
//
//  Created by Alex Cevicelow on 2/2/19.
//  Copyright © 2019 Alex Cevicelow. All rights reserved.
//

import UIKit
import Firebase

//code for checking auth state and how do direct user

//Setting up data base
var db: Firestore!

class customLaunchScreen: UIViewController {
    
    
    
    var actMon:UIActivityIndicatorView = UIActivityIndicatorView()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;

        
        actMon.center = self.view.center
        actMon.hidesWhenStopped = true
        actMon.style = UIActivityIndicatorView.Style.gray
        view.addSubview(actMon)
        actMon.startAnimating()
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        //This is checking if the device has a device id
        if (UserDefaults.standard.string(forKey: "settingAuth") == nil) {
            //if no device id go to login and get id
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "goLogin", sender: self)
            }
            
        }
            //if device has a device id
        else if (UserDefaults.standard.string(forKey: "settingAuth") != nil){
            //checking with server to validate device id
            print(UserDefaults.standard.string(forKey: "settingAuth") as? String)
            print("device has id")
            checkDeviceID()

        }
        else {
            print("error in new code")
        }
        

    }
    
    func checkDeviceID() {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            print(uid as Any)
            let email = user.email
            print(email as Any)
            
            // [START get_document]
            
            
            let docRef = db.collection("homeBase").document(uid)
            //let docRef = db.collection("homeBase").whereField("deviceID", isEqualTo: uid)
            
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    
                    //looking for the device id within firestore using query
                    if let serverDeviceID = document.data()?["deviceID"] as? String{
                        //testing to see if local device id is the same as server
                        let localDeviceID = UIDevice.current.identifierForVendor?.uuidString
                        if localDeviceID == serverDeviceID {
                            //take user to home screen based validation of device ID auth
                            //takes you to home screen
                            
                            self.performSegue(withIdentifier: "customLaunchLoginGood", sender: nil)

                            
                            //end takes you to home screen
                            
                        }
                        else{
                            //take user to login screen here
                            print("device id is not equal")
                            self.performSegue(withIdentifier: "goLogin", sender: nil)

                            
                        }
                        
                    }
                        //TODO add error message here
                    else {
                        print("error getting deviceID")
                    }
                    //TODO add propper error message here
                } else {
                    print("Document does not exist")
                }
            }
            // [END get_document]
        }
        
    }


}
















