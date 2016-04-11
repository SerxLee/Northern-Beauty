//
//  dateExtension.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/10.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation

extension NSDate{
    class func handleDate(date: NSDate) -> NSDate?{
        let dateF = NSDateFormatter()
        dateF.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        let date2 = dateF.stringFromDate(date)
        let date = dateF.dateFromString(date2)
        return date
    }
    func fullDescription() -> String {
        //将日期转换描述字符串
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInToday(self) {
            //确定计算的时间 和当前的时间的差值
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            if delta < 60 {
                return "刚刚"
            } else if delta < 60 * 60 {
                return "\(delta / 60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }else {
            //表示今天
            
            var dateformatString = ""
            //非今天
            if calendar.isDateInYesterday(self) {
                dateformatString = "昨天 HH:mm"
            } else {
                let result = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: [])
                if result.year == 0 {
                    dateformatString = "MM-dd HH:mm"
                    //当年 MM-dd HH:mm(一年内)
                } else {
                    dateformatString = "yyyy-MM-dd HH:mm"
                    //非当年 yyyy-MM-dd HH:mm(更早期)
                }
            }
            //统一计算所有的时间描述
            let df = NSDateFormatter()
            df.dateFormat = dateformatString
            return df.stringFromDate(self)
            
         }
    }
}
