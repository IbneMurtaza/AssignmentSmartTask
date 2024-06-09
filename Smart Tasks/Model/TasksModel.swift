//
//  TasksModel.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 06/06/2024.
//

import Foundation

struct TasksData :Codable {
    var tasks :[Task]?
}


struct Task : Codable {

    var id:String?
    var targetDate:String?
    var dueDate:String?
    var title:String?
    var description:String?
    var priority:Int?
    var status:String? = "Unresolved"
    var createTaskDate:Date?
    var comments:String?
      
    enum CodingKeys: String, CodingKey {

        case targetDate = "TargetDate"
        case dueDate = "DueDate"
        case title = "Title"
        case description = "Description"
        case priority = "Priority"
        case status
        case createTaskDate
        case comments
    }
  
}

enum TaskStatus :String {
    case Unresolve = "Unresolve"
    case Resolved = "Resolved"
    case Unresolved = "Unresolved"
}
