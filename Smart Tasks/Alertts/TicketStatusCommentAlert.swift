//
//  TicketStatusCommentAlert.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 09/06/2024.
//

import UIKit

class TicketStatusCommentAlert: UIViewController {
    @IBOutlet weak var textView:UITextView!
    var cancelClick:((Task)->Void)?
    var submitClick:((Task)->Void)?
    var obj = Task()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewConfigure()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textViewConfigure() {

        textView.text = Constants.placeholderText
        textView.textColor = UIColor.hexStringToUIColor (hex: "#434343")
        textView.delegate = self
       
    }
    @IBAction func submitTapped(sender:UIButton){
       
        self.dismiss(animated: true)
        if self.textView.text  == Constants.placeholderText {
            obj.comments = self.textView.text ?? ""
        }
        self.submitClick?(obj)
    }
    @IBAction func cancelTapped(sender:UIButton){
        obj.status = TaskStatus.Unresolved.rawValue
        self.dismiss(animated: true)
        self.cancelClick?(obj)
    }
}
extension TicketStatusCommentAlert: UITextViewDelegate {
    
   
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constants.placeholderText {
            textView.textColor = UIColor.hexStringToUIColor (hex: "#000000")
            textView.text = ""
 
            
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholderText
            textView.textColor = UIColor.hexStringToUIColor (hex: "#434343")

          
        }
    }
}
