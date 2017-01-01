//
//  IssuesListTableViewController.swift
//  wwJobs
//
//  Created by Paul Williams on 26/12/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//


import UIKit
import Firebase
import UserNotifications

class IssuesListTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [JobItem] = []
   // var user: User!
    
  //  let ref = FIRDatabase.database().reference(withPath: "grocery-items")
  //  let ref = FIRDatabase.database().reference(withPath: API.sharedInstance.getJobsURL())
    //moved to viewDidLoad to avoid error - was initialising before logged in.
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        //user = User(uid: "FakeId", email: "hungry@person.food")
        
        let ref = FIRDatabase.database().reference(withPath: API.sharedInstance.getJobsPath())
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [JobItem] = []
            for item in snapshot.children {
                let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                let descriptionText = jobItem.description
                newItems.append(jobItem)
                self.sendNotification(description: descriptionText)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
  /*      FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        } */
        
    } //ViewDidLoad
    
    
    func sendNotification(description : String) {
        let content = UNMutableNotificationContent()
        
        content.title = "New Job Recieved"
        content.body = description
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
        }
        print("should have been added")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }  //tableView NumberofRows
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let jobItem = items[indexPath.row]
        
        cell.textLabel?.text = jobItem.description
        cell.detailTextLabel?.text = " -> due by \(jobItem.dueByString())"
        
        //cell.detailTextLabel?.text = " -> Due By \(jobItem.dueBy)"
        toggleCellCheckbox(cell, isInProgress: jobItem.isInProgress)
        return cell
    } //tableView CreateRow
    
    
 /*   func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "job done") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGray
        
   /*     let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blueColor() */
        
        //return [share, favorite, more]
        return [more]
    } */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //https://www.hackingwithswift.com/example-code/uikit/how-to-customize-swipe-edit-buttons-in-a-uitableview
        
        /*    
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        } 
        */
        
        let done = UITableViewRowAction(style: .normal, title: "job done") { (action, indexPath) in
            // job is done, delete from notDone, move to done
            let jobItem = self.items[indexPath.row]
            let jobID = jobItem.ID
            //create new
            let ref = FIRDatabase.database().reference(withPath: API.sharedInstance.getJobsDonePath())
            let jobItemRef = ref.child(jobID)
            jobItemRef.setValue(jobItem.toAnyObject())
            //delete Old
            jobItem.ref?.removeValue()
            
        }
        
        done.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.20, alpha:1.0)
        //http://uicolor.xyz/#/hex-to-ui
        
        
        
        //return [delete, done]
        return [done]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  /*  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    */
    
    
 /*   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let jobItem = items[indexPath.row]
            jobItem.ref?.removeValue()
        }
    } //tableView - delete item
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let jobItem = items[indexPath.row]
        let toggledInProgress = !jobItem.isInProgress
        toggleCellCheckbox(cell, isInProgress: toggledInProgress)
        jobItem.ref?.updateChildValues([
            "isInProgress": toggledInProgress
            ])
    } //tableview didSelectRow
    
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isInProgress: Bool) {
        if !isInProgress {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(red:0.20, green:0.40, blue:0.20, alpha:1.0)
            cell.detailTextLabel?.textColor = UIColor.black
        }
    } //toggleCellCheckbox
    
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Issues",
                                      message: "Add an Issue",
                                      preferredStyle: .alert)
        
        //  https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        let newJobID = UUID().uuidString
                                        let jobItem = JobItem(ID : newJobID,
                                                              description: text,
                                                              doneAt : 0.0,
                                                              dueBy : 10000.0,
                                                              isInProgress: false)
                                        //addedByUser: self.user.email,
                                        let ref = FIRDatabase.database().reference(withPath: API.sharedInstance.getJobsPath())
                                        let jobItemRef = ref.child(text.lowercased())
                                        jobItemRef.setValue(jobItem.toAnyObject())
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: AnyObject) {
        do{
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }catch{
            print("wwJobs: Error while signing out!")
        }
        
    }
    
    
}
