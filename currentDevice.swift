//
//  currentDevice.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/23.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation
import UIKit

class currentDevice {
    
    let iOSDeviceScreenSize: CGSize = UIScreen.mainScreen().bounds.size
    
    func getInfo(){
        
        /*
            iPhone 6 plus/ 6s plus: 736 x 414
            iPhone 6/ 6s          : 667 x 375
            iPhone 5/ 5s/ se/ 5c  : 568 x 320
            iPhone 4s             : 480 x 320
            
            iPad Air              : 1024 x 768
            iPad3                 : 1024 x 768
            iPad2                 : 1024 x 768
            iPad mini2            : 1024 x 768
            iPad mini             : 1024 x 768
        */
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone{
            
            if iOSDeviceScreenSize.height > iOSDeviceScreenSize.width{
                
                if iOSDeviceScreenSize.height == 568{
                    NSLog("iPhone 5/5s/5c/se/ipod touch5")
                }else if iOSDeviceScreenSize.height == 667{
                    NSLog("iPhone 6/6s")
                }else if iOSDeviceScreenSize.height == 736{
                    NSLog("iPhone 6 plus/ 6s plus")
                }else{
                    NSLog("iPhone 4s and other device")
                }
            }
            if iOSDeviceScreenSize.width > iOSDeviceScreenSize.height{
                
                if iOSDeviceScreenSize.width == 568{
                    NSLog("iPhone 5/5s/5c/se/ipod touch5")
                }else if iOSDeviceScreenSize.width == 667{
                    NSLog("iPhone 6/6s")
                }else if iOSDeviceScreenSize.width == 736{
                    NSLog("iPhone 6 plus/ 6s plus")
                }else{
                    NSLog("iPhone 4s and other device")
                }
            }
        }
    }
}