//
//  UserNameMatch.swift
//  autoFillText
//
//  Created by Serx on 16/4/17.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation

class  UserNameMatch: NSObject {
    
    var matchedArray: Array = [String]()
    var matchStr: String?
    
    init(array: [String], string: String) {
        
        self.matchedArray = array
        self.matchStr = string
    }
    
    func sl_matchlist() -> [String]{
        
        var resultArray: [String] = []
        for matched in matchedArray{
            
            if matched.characters.count >= matchStr!.characters.count{
                
                if userMatch(matchStr!, str2: matched){
                    resultArray.append(matched)
                }
            }
        }
        return resultArray
    }
    
    //return true or false, indicate two string is equel and not equel
    
    /*
     从头全匹配
     */
    func userMatch(str1: String , str2: String) -> Bool{
        let lim = str1.endIndex
        let limStr2 = str2.substringToIndex(lim)
        if str1 == limStr2{
            return true
        }else{
            return false
        }
    }
    
    /*
     
     */
    
}