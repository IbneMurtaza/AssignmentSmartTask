//
//  TaskCell.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 06/06/2024.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDueDateVal:UILabel!
    @IBOutlet weak var lblDayLeftVal:UILabel!
    
    
    var taskClick:((_ val: Task)->Void)?
    var task = Task()
    var vc:UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(obj:Task){
        self.task = obj
        lblTitle.text = obj.title
        if let dueDate = obj.dueDate {
            
            let formattedDate = DateUtility.convertheDate(input:dueDate)
            lblDueDateVal.text = formattedDate
            
            let remaingDays = DateUtility.findRemainingDays (input:dueDate)
            lblDayLeftVal.text = (remaingDays)
            
        }else {
            lblDueDateVal.text = ""
            lblDayLeftVal.text = ""
        }
       
        
       
    }
    
    
    @IBAction func taskTapped(sender:UIButton!){
        self.taskClick?(task)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
}
