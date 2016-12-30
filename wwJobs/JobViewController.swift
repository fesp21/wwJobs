//
//  JobViewController.swift
//  wwJobs
//
//  Created by Paul Williams on 16/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit
import Firebase

class JobViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

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
        let job1 = Job(ID : uuid, description: textView.text, dueBy: newDueBy)!
        API.sharedInstance.addNewJob(job1)
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "CDSJobAdded"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    

    


}

