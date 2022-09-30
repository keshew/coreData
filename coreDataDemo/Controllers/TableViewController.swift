//
//  TableViewController.swift
//  coreDataDemo
//
//  Created by Артём Коротков on 29.09.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var tasks: [Task] = []
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.title = "Task to Do"
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        

        return cell
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    func saveTask(withTitle title: String) {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = Task(entity: entity!, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Task", message: "Add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let tf = alert.textFields?.first
            if let newTaskTitle = tf?.text {
                self.saveTask(withTitle: newTaskTitle)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
