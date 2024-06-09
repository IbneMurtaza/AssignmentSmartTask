//
//  TaskDetailVC.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 06/06/2024.
//


import UIKit

class TaskDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDueDate:UILabel!
    @IBOutlet weak var lblDueDateVal:UILabel!
    @IBOutlet weak var lblDayLeft:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblDayLeftVal:UILabel!
    @IBOutlet weak var viewButtons:UIView!
    @IBOutlet weak var imgCrossOrTick:UIImageView!
    var obj = Task()
    var ticketStatusUpdated:Bool = false
    var updatedTicket:((Task)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        // Do any additional setup after loading the view.
    }
    @IBAction func resolveTapped(sender:UIButton!){
        movetoCommentAlert(status: TaskStatus.Resolved)
    }
    @IBAction func cantResolveTapped(sender:UIButton!){
        movetoCommentAlert(status: TaskStatus.Unresolved)
    }
    func configureData(){
        lblTitle.text = obj.title
        
        setTaskStatus()
        
        if let dueDate = obj.dueDate {
            
            let formattedDate = DateUtility.convertheDate(input:dueDate)
            lblDueDateVal.text = formattedDate
            if obj.status == TaskStatus.Resolved.rawValue {
                lblDayLeftVal.text = "0"
            }else {
                let remaingDays = DateUtility.findRemainingDays(input:dueDate)
                lblDayLeftVal.text = remaingDays
            }
            
        }else {
            lblDueDateVal.text = ""
            lblDayLeftVal.text = ""
        }
        lblDescription.text = obj.description
        lblStatus.text = "Unresolved"
       
       
    }
    
    func setTaskStatus(){
        if obj.status == TaskStatus.Unresolved.rawValue {
            imgCrossOrTick.isHidden = false
            imgCrossOrTick.image = UIImage(named: "unresolved_sign")
            viewButtons.isHidden = true
            lblStatus.text = "Unresolved"
            
            lblTitle.textColor = #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
            lblDueDateVal.textColor = #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
            lblStatus.textColor = #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
        }else if obj.status == TaskStatus.Resolved.rawValue {
            imgCrossOrTick.isHidden = false
            imgCrossOrTick.image = UIImage(named: "sign_resolved")
            viewButtons.isHidden = true
            lblStatus.text = "Resolved"
            
            
            lblTitle.textColor = #colorLiteral(red: 0.2352941176, green: 0.5294117647, blue: 0.4823529412, alpha: 1)
            lblDueDateVal.textColor = #colorLiteral(red: 0.2352941176, green: 0.5294117647, blue: 0.4823529412, alpha: 1)
            lblStatus.textColor = #colorLiteral(red: 0.2352941176, green: 0.5294117647, blue: 0.4823529412, alpha: 1)
        }else if obj.status == TaskStatus.Unresolve.rawValue || obj.status == nil {
            imgCrossOrTick.isHidden = true
            viewButtons.isHidden = false
            lblStatus.text = "Unresolve"
            
            
            lblTitle.textColor = #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
            lblDueDateVal.textColor = #colorLiteral(red: 0.937254902, green: 0.2941176471, blue: 0.368627451, alpha: 1)
            lblStatus.textColor = #colorLiteral(red: 1, green: 0.8705882353, blue: 0.3803921569, alpha: 1)
        }
    }
    
    
    func movetoCommentAlert(status:TaskStatus){
        ticketStatusUpdated = true
        let alertVc = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "TicketStatusCommentAlert") as! TicketStatusCommentAlert
        alertVc.modalPresentationStyle = .overFullScreen
        alertVc.modalTransitionStyle = .crossDissolve
        alertVc.obj = self.obj
        alertVc.submitClick = { [weak self] task in
            
            self?.obj = task
            self?.obj.status = status.rawValue
            self?.configureData()
        }
        alertVc.cancelClick = { [weak self] task in
            self?.obj = task
            self?.obj.status = status.rawValue
            self?.configureData()
        }
        self.present(alertVc, animated: true)
    }
    
    
    @IBAction func backTapped(sender:UIButton!){
        if ticketStatusUpdated {
            self.updatedTicket?(obj)
            self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
       
    }

}
