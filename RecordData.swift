//
//  RecordData.swift
//  autoFillText
//
//  Created by Serx on 16/4/17.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation


class RecordData: NSObject{
    
    /*
        toWriteArray: befroe change the record, you should put data to 
     
        toReadArray:  the data read from .plist,
                        get data via this property
    */
    var toWriteArray: NSMutableArray!
    var toReadArray: [String] = []
    
    /*
        write the data to the .plist
    */
    func dataWrite(){
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("userNameData.plist")
        
        //writing to GameData.plist
        toWriteArray.writeToFile(path, atomically: false)
        
        let resultArray = NSArray(contentsOfFile: path)
        print("Saved userNameData.plist file is --> \(resultArray?.description)")
    }
    
    
    func dataRead(){
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("userNameData.plist")
        
        let fileManager = NSFileManager()
        
        if !fileManager.fileExistsAtPath(path){
            
            if let bundlePath = NSBundle.mainBundle().pathForResource("userNameData", ofType: "plist"){
                
                let resultArray = NSArray(contentsOfFile: path)
                print("Saved userNameData.plist file is --> \(resultArray?.description)")
                
                do{
                    _ = try fileManager.copyItemAtPath(bundlePath, toPath: path)
                }catch{
                    
                }
            }else{
                print("userName.plist not found. Please, make sure it is part of the bundle.")
            }
        }else{
            print("userName.plist already exits at path.")
            
            //TODO: clean all record

            
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
            
        }
        if let resultArray = NSArray(contentsOfFile: path) as? [String]{
            print("Loaded userNameData.plist file is --> \(resultArray.description)")
            self.toReadArray = resultArray
        }
    }
}