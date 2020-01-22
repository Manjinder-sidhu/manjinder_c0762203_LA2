//
//  Task.swift
//  manjinder_c0762203_LA2
//
//  Created by Manjinder Aulakh on 2020-01-19.
//  Copyright © 2020 Manjinder kaur. All rights reserved.
//

import Foundation


class Task{
    var title : String
    var days : Int
    var count_completed_days = 0
    var date:String
//    var hour : String
   
    
    init(title : String,days: Int,date:String){
        self.title = title
        self.days = days
               
        self.date = date
//        self.hour = hour
        
    }
}
