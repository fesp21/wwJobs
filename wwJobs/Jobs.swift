//
//  Jobs.swift
//  wwJobs
//
//  Created by Paul Williams on 24/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit

class Jobs : NSObject {
    
    var list = [Job]()
    
    override init(){
        super.init()
    }
    
    func add(_ job: Job) -> Int? {
        for (index, thisJob) in list.enumerated() {
            if thisJob.ID == job.ID {
                return index
            }
        }
        self.list += [job]
        return  nil
    }
    
    func count () -> Int{
        return list.count
    }
    
    func job (_ index: Int) -> Job{
        return list[index]
    }
    
    func jobByID (_ ID : String) -> Job? {     // ? means it can also return nil?
        for (index, thisJob) in list.enumerated() {
            if thisJob.ID == ID {
                return list[index]
            }
        }
        return nil
    }
    
    func getJobList() -> [Job] {
        return list
    }
    
    func deleteJob (_ ID : String) -> Bool{
        //https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html
        
        for (index, thisJob) in list.enumerated() {
            print (thisJob.description)
            if thisJob.ID == ID {
                list.remove(at: index)
                return true
            }
        }
        return false
    }
}
