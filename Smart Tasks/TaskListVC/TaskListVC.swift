
//
//  TaskListVC.swift
//  Smart Tasks
//
//  Created by Muhammad Mudassar on 05/06/2024.
//

import UIKit

class TaskListVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var emptyView:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    
    
    
    var tasks = [Task]()
    var currentDay = Date()
    var currentTasks = [Task]()
    var verificationViewModel = TaskListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verificationViewModel.delegate = self
        emptyView.isHidden = true
        registerCell()
        verificationViewModel.fetchTasks()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dateTapped(sender:UIButton!){
      
        DateUtility.presentDatePicker(from: self, initialDate: currentDay) { [weak self] date in
            self?.currentDay = date
            self?.lblTitle.text = DateUtility.dateToFormatString(date:date,"yyyy-MM-dd")
            self?.sortTasks()
        }
    }
    
    @IBAction func nextTapped(sender:UIButton!){
        currentDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay) ?? Date()
        sortTasks()
    }
    
    @IBAction func backTapped(sender:UIButton!){
        currentDay = Calendar.current.date(byAdding: .day, value: -1, to: currentDay) ?? Date()
        sortTasks()
    }
     
    
    func sortTasks() {
       
        let date = currentDay
       let dateFormated = DateUtility.dateToFormated(date: currentDay)
        if Calendar.current.isDateInToday(date) {
            lblTitle.text = "Today"
        }else {
            lblTitle.text = dateFormated
        }
       
        currentTasks.removeAll()
        currentTasks = tasks.filter({$0.targetDate == dateFormated})
        currentTasks = currentTasks.sorted {
                       ($0.priority ?? 0 ) < ($1.priority ?? 0)
                    }
        self.tableView.reloadData()
        
    }
    
    
    
    func moveToDetailTaskVC(task:Task){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailVC") as! TaskDetailVC
        vc.obj = task
        vc.updatedTicket = { [weak self] updatedTask in
            
            if let index = self?.tasks.firstIndex(where: { $0.description == updatedTask.description  }) {
                self?.tasks[index].status = updatedTask.status
                self?.sortTasks()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TaskListVC : UITableViewDelegate, UITableViewDataSource {
    func registerCell() {
        let tableViewCellNib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: "TaskCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentTasks.count == 0 {
            emptyView.isHidden = false
        }else {
            emptyView.isHidden = true
        }
        return currentTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        let task = currentTasks[indexPath.row]
        cell.vc = self
        cell.configureCell(obj: task)
        cell.taskClick = { [weak self] task in
            self?.moveToDetailTaskVC(task:task)
        }
        return cell
    }
    
  
}


extension TaskListVC : TaskListViewModelDelegate {
    func didReceiveTaskResponse(taskResponse: [Task]?, error: String?) {
        
        if error == nil {
            
            self.tasks = taskResponse ?? [Task]()
            self.sortTasks()
            
        }else {
             //  show Error Alert here
            print(error)
        }
        
    }
    
    
}
