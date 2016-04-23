//
//  LastTableViewCell.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/20.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

class LastTableViewCell: UITableViewCell {

//    let delegate = lastCellDelegate()
    
    @IBOutlet weak var clearButton: UIButton!
    
    
}

protocol lastCellDelegate {
    func commentCell(commentCell: SSCourseCell, didClickReplyButton: UIButton)
}
