//
//  MainViewControllerTableViewCell.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/6.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

class MainViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var CourseNum: UILabel!
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var CourseScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
