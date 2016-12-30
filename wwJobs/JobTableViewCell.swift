//
//  JobTableViewCell.swift
//  wwJobs
//
//  Created by Paul Williams on 16/07/2016.
//  Copyright © 2016 pwilliams. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var jobDoneSwitch: UISwitch!
    @IBOutlet weak var jobDueBy: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
