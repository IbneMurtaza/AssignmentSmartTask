//
//  ViewController.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 05/06/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var tasks = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        fetchTasks()
        // Do any additional setup after loading the view.
    }
    @IBAction func nextTapped(sender:UIButton!){
        
    }
    @IBAction func backTapped(sender:UIButton!){
        
    }
    func fetchTasks(){
        let Url = String(format:  "http://demo1414406.mockable.io/")
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
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
                            self.tasks = response.tasks ?? [Task]()
                            self.tableView.reloadData()
                        }
                        
                       
                    }else {
                        print("no tasks found")
                    }
                  
                    
                } catch (let error) {
                    print(error.localizedDescription)
                   
                }
                
            }else {
                print(error?.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
    
    func moveToDetailTaskVC(task:Task){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailVC") as! TaskDetailVC
        vc.obj = task
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func registerCell() {
        let tableViewCellNib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: "TaskCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        let task = tasks[indexPath.row]
        cell.vc = self
        cell.configureCell(obj: task)
        cell.taskClick = { [weak self] task in
            self?.moveToDetailTaskVC(task:task)
        }
        return cell
    }
    
  
}

