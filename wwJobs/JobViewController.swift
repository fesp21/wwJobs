//
//  JobViewController.swift
//  wwJobs
//
//  Created by Paul Williams on 16/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit
import Firebase

class JobViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = "Describe the job..."
        textView.textColor = UIColor.lightGray
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewJob() {
        let uuid = UUID().uuidString
        let newDueBy = round(datePicker.date.timeIntervalSince1970)
        let job1 = JobItem(ID : uuid, description: textView.text, doneAt : 0.0, dueBy: newDueBy, isInProgress : false)
        
       // API.sharedInstance.addNewJob(job1)
        
        let ref = FIRDatabase.database().reference(withPath: API.sharedInstance.getJobsPath())
        let jobItemRef = ref.child(uuid)
        jobItemRef.setValue(job1.toAnyObject())
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "CDSJobAdded"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe the job..."
            textView.textColor = UIColor.lightGray
        }
    }
    



}

