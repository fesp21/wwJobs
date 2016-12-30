//
//  CDS.swift
//  wwJobs
//
//  Created by Paul Williams on 24/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications



class CDS : NSObject {
    
    
    let myCDSURL = "https://wwjobs-8336c.firebaseio.com"
    //let myEmail = "pangtuwi@gmail.com"
    //let myPassword = "xxxxxx"
    var userUIDString = ""
    var userEmailString = ""
    var userFamilyUIDString = "" //"f0bc6c07-c8a1-4802-92d7-97464e90c484"
    var userNameString = ""
  //  var myUid = ""
    var connectionStatus = "not Connected"
    

    
    //MARK: Initialisation
    
    override init() {
        
        super.init()
     //   FIRApp.configure();
        
        //FIRDatabase.database().persistenceEnabled = true

        //Authenticate
       // FIRAuth.auth()?.signIn(withEmail: getEmail(), password: "xxxxxx") { (user, error) in
            //not sure what to put here
       // }
        
        if let user = FIRAuth.auth()?.currentUser {
            userUIDString = user.uid;  // The user's ID, unique to the Firebase project.
            print ("wwJobs: Got userID: \(userUIDString)")
        } else {
            // No user is signed in.
        }
        
        let myLoginRef = FIRDatabase.database().reference(fromURL: usersURL())
        print (usersURL())

        //read data from database
        if let myUserID = FIRAuth.auth()?.currentUser?.uid {
            myLoginRef.child(myUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.userNameString = (snapshot.value as! NSDictionary)["name"] as! String
                self.connectionStatus = "logged in"
                self.userFamilyUIDString = (snapshot.value! as! NSDictionary)["familyID"] as! String
                print ("wwJobs: Got familyID: \(self.userFamilyUIDString)")
                
                // Create a reference to a Firebase location
                
                let myJobsRef = FIRDatabase.database().reference(fromURL: self.jobsURL())
                print (self.jobsURL())
                
                //Read Job Data
                myJobsRef.observe(.childAdded, with: { (snapshot) -> Void in
                    let description = (snapshot.value! as! NSDictionary)["description"] as! String
                    //print ("Found new Job: "+description)
                    let dueBy = (snapshot.value as! NSDictionary)["dueBy"] as! Double
                    let ID = (snapshot.value! as! NSDictionary) ["ID"] as! String
                    let job1 = Job(ID : ID, description: description, dueBy: dueBy)!
                    API.sharedInstance.addJobToList(job1)
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name(rawValue: "CDSJobAdded"), object: nil)
                    
                    //New Notifications iOS10
                    //http://useyourloaf.com/blog/local-notifications-with-ios-10/
                
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "Don't forget"
                    content.body = "Buy some milk"
                    content.sound = UNNotificationSound.default()
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                                    repeats: false)
                    
                    let identifier = "UYLLocalNotification"
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if error != nil {
                            // Something went wrong
                        }
                    })
                    
                    
                    
                    
                    
                    //Show Notification
                    // create a corresponding local notification
                /*    let notification = UILocalNotification()
                    notification.alertBody = "New Job Recieved" // text that will be displayed in the notification
                    notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
                    notification.fireDate = Date(timeIntervalSinceNow:5)//item.deadline // todo item due date (when notification will be fired)
                    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                    notification.userInfo = ["title": description, "UUID": UUID().uuidString] // assign a unique identifier to the notification so that we can retrieve it later
                    
                    UIApplication.shared.scheduleLocalNotification(notification) */
                    
                    
                })
                
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
           // self.ConnectionLabel.text = "could not log in"
            connectionStatus = "log in Error"
        }
        

        
    }
    
    
    
    func usersURL() -> String {
        return myCDSURL+"/users"
    }
    
    func jobsPath() -> String {
        return "/jobs/"+userFamilyUIDString+"/"+userUIDString+"/notDone"
    }
    
    
    func jobsDonePath () -> String {
        return "/jobs/"+userFamilyUIDString+"/"+userUIDString+"/done"
    }
    
    func jobsURL() -> String {
        return myCDSURL+jobsPath()
    }
    
    func oldJobsURL() -> String {
        return myCDSURL+"/jobs/"+userFamilyUIDString+"/"+userUIDString+"/done"
    }
    
    func setJobDone(_ job : Job) {
        let doneAt = round(Date().timeIntervalSince1970)
        // Write data to Firebase
        let myOldJobsRef = FIRDatabase.database().reference(fromURL: self.oldJobsURL())
        myOldJobsRef.child(job.ID).setValue(["ID": job.ID, "description": job.description, "dueBy": job.dueBy, "doneAt": doneAt])
        
        let currentJobsRef = FIRDatabase.database().reference(fromURL: self.jobsURL())
        currentJobsRef.child(job.ID).removeValue()
        
    }
    
    func addNewJob (_ job : Job) {
        let jobsRef = FIRDatabase.database().reference(fromURL: self.jobsURL())
        jobsRef.child(job.ID).setValue(["ID": job.ID, "description": job.description, "dueBy": job.dueBy])
    }
  
    
    

}
