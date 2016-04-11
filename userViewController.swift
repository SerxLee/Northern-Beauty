//
//  userViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/11.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

var xuefen: Int!

class userViewController: UITableViewController {

    @IBOutlet weak var sumOfScore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sumOfScore.text = String(xuefen)
    }
    
}
