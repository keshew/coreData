//
//  extensionEditing.swift
//  coreDataDemo
//
//  Created by Артём Коротков on 30.09.2022.
//

import UIKit
import CoreData

extension TableViewController {
    
    func deleteItem(with indexPath: IndexPath, item: Task) {
        let context = getContext()
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRow = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedRow, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentRow = tasks[indexPath.row]
            deleteItem(with: indexPath, item: currentRow)
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDone = doneAction(with: indexPath)
        return UISwipeActionsConfiguration(actions: [actionDone])
    }
    
    func doneAction(with indexPath: IndexPath) -> UIContextualAction  {
        let task = tasks[indexPath.row]
        let done = UIContextualAction(style: .normal, title: "Dine") { action, view, completion in
            task.isDone = !task.isDone
            print(task.isDone)
            self.tasks[indexPath.row] = task
            completion(true)
        }
        done.image = UIImage(systemName: "heart")
        done.backgroundColor = task.isDone ? .systemRed
        : .systemGray
        return done
    }
    
}
