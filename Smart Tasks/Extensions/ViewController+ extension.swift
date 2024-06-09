//
//  ViewController+ extension.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 07/06/2024.
//

import UIKit

class DateUtility  {
    
    
    static func presentDatePicker(from vc: UIViewController, initialDate: Date? = nil, dateSelected: @escaping (Date) -> Void) {
        // Create an action sheet
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create a UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        if let date = initialDate {
            datePicker.date = date
        }
        alertController.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -60)
        ])
        
        let doneAction = UIAlertAction(title: "Done", style: .cancel) { _ in
            let selectedDate = datePicker.date
            dateSelected(selectedDate)
        }
        alertController.addAction(doneAction)
        
        // Configure popover presentation for iPad
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        vc.present(alertController, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.view.heightAnchor.constraint(equalToConstant: 250).isActive = true // for iPad
        } else {
            alertController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
    }
    
    
    
     static func convertheDate(input:String) ->String {
 
        // Date formatter to parse the input date string
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"

        // Date formatter to format the date in the desired output format
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd yyyy"

        if let date = inputDateFormatter.date(from: input) {
            let outputDateString = outputDateFormatter.string(from: date)
            print(outputDateString) // "Aug 29 2024"
            return outputDateString
        } else {
            print("Invalid date format")
            return ""
        }
    }
    

    static func findRemainingDays (input:String)->String{
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()

        if let targetDate = dateFormatter.date(from: input) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
            
            if let remainingDays = components.day {
                return String(remainingDays)
            } else {
                print("Could not calculate remaining days")
                return ""
            }
        } else {
            print("Invalid date format")
            return ""
        }
    }
  static func dateToFormatString(date:Date,_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let str = formatter.string(from: date)
        return str
    }
    
    static func dateToFormated(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)
          return formattedDateString
      }
}



