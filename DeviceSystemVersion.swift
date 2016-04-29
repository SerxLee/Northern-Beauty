//
//  DeviceSystemVersion.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/29.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation
import UIKit


func IS_IOS7() -> Bool {
    return Double(UIDevice.currentDevice().systemVersion as String) >= 7.0
}

func IS_IOS8() -> Bool {
    
    return Double(UIDevice.currentDevice().systemVersion as String) >= 8.0
}

func IS_IOS9() -> Bool {
    return Double(UIDevice.currentDevice().systemVersion as String) >= 9.0
}