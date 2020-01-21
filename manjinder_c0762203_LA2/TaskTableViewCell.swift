//
//  TaskTableViewCell.swift
//  manjinder_c0762203_LA2
//
//  Created by Manjinder Aulakh on 2020-01-20.
//  Copyright © 2020 Manjinder kaur. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var completedIMG: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var DaysLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    
//    func settask(at:IndexPath,task:[Task]){
//        titleLbl.text = task[at].title
//        DaysLbl.text = task[at].days
//        
//           
//       }
}
