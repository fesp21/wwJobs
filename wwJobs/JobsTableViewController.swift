//
//  JobsTableViewController.swift
//  wwJobs
//
//  Created by Paul Williams on 16/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit

class JobsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(JobsTableViewController.CDSUpdateNotificationSent), name: NSNotification.Name(rawValue: "CDSJobAdded"), object: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return jobs.count
        return API.sharedInstance.jobCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "JobTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JobTableViewCell

        // Fetches the appropriate job for the data source layout.
        let job = API.sharedInstance.getJob((indexPath as NSIndexPath).row)
        
        cell.jobLabel.text = job.description
        cell.jobDoneSwitch.setOn(false, animated: true)
        cell.jobDoneSwitch.accessibilityIdentifier = job.ID
     //   API.sharedInstance.indexPaths [job.ID] = indexPath
        cell.jobDoneSwitch.addTarget(self, action: #selector(JobsTableViewController.stateChanged(_:)), for: UIControlEvents.valueChanged)
        
        let date = Date(timeIntervalSince1970: job.dueBy)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE, dd MMM hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        cell.jobDueBy.text = "Due: "+dateString


        return cell
    }
    
    func stateChanged(_ switchState: UISwitch) {
        //print(switchState.accessibilityIdentifier)
        if switchState.isOn {
           // print ("The Switch is On")
           /* API.sharedInstance.indexRowString =  switchState.accessibilityIdentifier!
            API.sharedInstance.tableViewRowIndexPath = [API.sharedInstance.indexPaths[API.sharedInstance.indexRowString]!]
            tableView.deleteRowsAtIndexPaths(API.sharedInstance.tableViewRowIndexPath, withRowAnimation: .Fade) */
            API.sharedInstance.setJobDone(switchState.accessibilityIdentifier!)
            self.tableView.reloadData()
        }
    }
    
    func CDSUpdateNotificationSent() {
        self.tableView.reloadData()
    //    print(UIApplication.shared.scheduledLocalNotifications!)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
