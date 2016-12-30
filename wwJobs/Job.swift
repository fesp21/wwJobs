//
//  Job.swift
//  wwJobs
//
//  Created by Paul Williams on 16/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit

class Job {
    
    // MARK: Properties
    
    var ID : String
    var description: String
    var dueBy : Double
    
    //MARK: Initialisation
    
    init?(ID:String, description: String, dueBy : Double) {
        self.ID = ID
        self.description = description
        self.dueBy = dueBy
        if description.isEmpty {
            return nil
        }
    }
}