//
//  ViewController.swift
//  wwJobs
//
//  Created by Paul Williams on 16/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var ConnectionLabel: UILabel!
    
    let myEmail = "pangtuwi@gmail.com"
    var myName = ""
    var myUid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRApp.configure();
        
        FIRAuth.auth()?.signInWithEmail("pangtuwi@gmail.com", password: "xxxxxx") { (user, error) in
            //not sure what to put here
        }
        if let user = FIRAuth.auth()?.currentUser {
            //let myName = user.displayName
            //let myEemail = user.email
            //let photoUrl = user.photoURL
            myUid = user.uid;  // The user's ID, unique to the Firebase project.
        } else {
            // No user is signed in.
        }
        // Create a reference to a Firebase location
        let myRootRef = FIRDatabase.database().referenceFromURL("https://wwjobs-8336c.firebaseio.com/")
        //authenticate
        
        
        // Write data to Firebase
        // myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        //read data from database
        if let myUserID = FIRAuth.auth()?.currentUser?.uid {
            myRootRef.child("users").child(myUserID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    // Get user value
                    self.myName = snapshot.value!["name"] as! String
                    self.ConnectionLabel.text = "logged in as "+self.myName
                
                }) { (error) in
                    print(error.localizedDescription)
                }
        } else {
            self.ConnectionLabel.text = "could not log in"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}

