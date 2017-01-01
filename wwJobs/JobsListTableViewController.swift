//
//  JobsListTableViewController.swift
//  wwJobs
//
//  Created by Paul Williams on 26/12/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//


import UIKit
import Firebase
import UserNotifications

class JobsListTableViewController: UITableViewController {
    
    let listToUsers = "ListToUsers"
    var items: [JobItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        let ref = FIRDatabase.database().reference(withPath: API.sharedInstance.getJobsPath())
        
        ref.queryOrdered(byChild: "isInProgress").observe(.value, with: { snapshot in
            print("wwJobs: Started Observer for Jobs")
            var newItems: [JobItem] = []
            for item in snapshot.children {
                
                let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                let descriptionText = jobItem.description
                print("wwJobs: Loading Job : \(descriptionText)")
                newItems.append(jobItem)
                self.sendNotification(description: descriptionText)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        
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
            print("wwJobs: Error in User Notification : \(error)")
        }
        print("wwJobs: Notification should have been added")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }  //tableView NumberofRows
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let jobItem = items[indexPath.row]
        
        cell.textLabel?.text = jobItem.description
        cell.detailTextLabel?.text = " -> due by \(jobItem.dueByString())"
        toggleCellCheckbox(cell, isInProgress: jobItem.isInProgress)
        return cell
    } //tableView CreateRow
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //https://www.hackingwithswift.com/example-code/uikit/how-to-customize-swipe-edit-buttons-in-a-uitableview
        
        
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
