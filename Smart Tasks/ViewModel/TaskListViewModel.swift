//
//  TaskListViewModel.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 09/06/2024.
//

import Foundation


protocol TaskListViewModelDelegate: AnyObject {
    func didReceiveTaskResponse(taskResponse: [Task]?,error:String?)
  
}

struct TaskListViewModel {
    
    weak var delegate: TaskListViewModelDelegate?
    
    func fetchTasks(){
        let Url = String(format:  "http://demo1414406.mockable.io/")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let request = URLRequest(url: serviceUrl)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            print("API Response: \n", serviceUrl)
            if error == nil {
                guard let jsonData = data else {
                    print("no data found")
                    return
                }
                print(String(data: jsonData, encoding: .utf8) ?? "")
                do {
                    let decorder = JSONDecoder()
                    let response = try decorder.decode(TasksData.self, from: jsonData)
                  
                    if response.tasks?.count ?? 0 > 0 {
                        DispatchQueue.main.async {
                            self.delegate?.didReceiveTaskResponse(taskResponse: response.tasks, error: nil)
                        }
                        
                    }else {
                        print("no tasks found")
                        DispatchQueue.main.async {
                            self.delegate?.didReceiveTaskResponse(taskResponse: response.tasks, error: nil)
                        }
                    }
                  
                    
                } catch (let error) {
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveTaskResponse(taskResponse: nil, error: error.localizedDescription)
                    }
                   
                }
                
            }else {
                print(error?.localizedDescription)
                DispatchQueue.main.async {
                    self.delegate?.didReceiveTaskResponse(taskResponse: nil, error: error?.localizedDescription)
                }
            }
            
        }
        dataTask.resume()
    }
}
