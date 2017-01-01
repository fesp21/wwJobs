//
//  LibraryAPI.swift
//  wwJobs
//
//  Created by Paul Williams on 25/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit

class API: NSObject {
    
    //fileprivate let jobs : Jobs
    fileprivate let cds : CDS
    fileprivate let isOnline : Bool

    
    
  /*  var indexPaths = [String : NSIndexPath]()
    var tableViewRowIndexPath = [NSIndexPath]()
    var indexRowString : String = "" */
   
    
    class var sharedInstance: API {
        
        struct Singleton {
            
            static let instance = API()
        }
        
        return Singleton.instance
    }
    
    override init() {
      //  jobs = Jobs()
        cds = CDS()
        isOnline = false
        super.init()
    }
    
    
    //- - - - - - - - - - - - - - - - - - - - CREDENTIALS - - - - - - - - - - - - - - - - - - - - //
    
    func setUserUIDString (newUID : String) {
        cds.userUIDString = newUID
    }
    
    func setUserEmailString (newEmail : String) {
        cds.userEmailString = newEmail
    }

     //- - - - - - - - - - - - - - - - - - - - FIREBASE - - - - - - - - - - - - - - - - - - - - //
    
    func getJobsPath () -> String {
        return cds.jobsPath()
    }
    
    func getJobsDonePath () -> String {
        return cds.jobsDonePath ()
    }
    
    //- - - - - - - - - - - - - - - - - - - - - - JOBS - - - - - - - - - - - - - - - - - - - - - - //
  /*
    func getJobs() -> [Job] {
        return jobs.getJobList()

    }
    
    func getJob(_ index : Int) -> Job {
        return jobs.job(index)
    }
    
    func getJobByID (_ ID : String) -> Job {
            return jobs.jobByID (ID)!
    }
    
    
    func jobCount() -> Int {
        return jobs.count()
    }
    
    func addJobToList(_ job: Job) {
       // jobs.add(job)
    }
    
    func addNewJob(_ job : Job) {
      //  jobs.add(job)
        cds.addNewJob(job)
    }
    */
 /*   func setJobDone(_ ID : String) {
        cds.setJobDone(jobs.jobByID(ID)!)
      //  jobs.deleteJob(ID)
    } */
    
    

}
