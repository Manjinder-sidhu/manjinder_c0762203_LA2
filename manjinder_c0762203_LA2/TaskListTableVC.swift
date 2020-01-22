//
//  TaskListTableVC.swift
//  manjinder_c0762203_LA2
//
//  Created by Manjinder Aulakh on 2020-01-19.
//  Copyright © 2020 Manjinder kaur. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableVC: UITableViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet var tableview: UITableView!
    
   // @IBOutlet weak var completed: UIButton!
    
    var isImportant = false
    var tasks : [Task]?
    var curIndex = -1
      var filteredData: [Task]?
     var count_completed_Days = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       LoadCoreData()
        
        //array for seraching
          filteredData = tasks!
        
        //need to add delegate for searchbar
        searchbar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData?.count ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let task = filteredData![indexPath.row]
     let cell = tableView.dequeueReusableCell(withIdentifier:"TaskCell")
        cell?.textLabel?.text = task.title
        cell?.detailTextLabel?.text = "\(task.days) alloted days" + " and \(task.count_completed_days)completed days" + "\(task.date)"
        // Configure the cell...

//        print("\(tasks!.count)######")
//
//        cell.settask(at: indexPath,task: [(tasks?[indexPath.row])!])
       
        
        if task.days == task.count_completed_days{
            cell?.backgroundColor = UIColor.red
            cell?.textLabel?.text = "COMPLETED"
            cell?.detailTextLabel?.text = ""
            
        }
        return cell!
    }
    
    
   
//    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.reloadData()
//    }
   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Addaction = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
            print("addDay clicked")
            
            
            
            
            
            let alertcontroller = UIAlertController(title: "Add Day", message: "Enter a day for this task", preferredStyle: .alert)
                           
                           alertcontroller.addTextField { (textField ) in
                                           textField.placeholder = "number of days"
                               textField.text = ""
                           }
                           let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                           CancelAction.setValue(UIColor.brown, forKey: "titleTextColor")
                           let AddItemAction = UIAlertAction(title: "Add Day", style: .default){
                               (action) in
                            let added_days = alertcontroller.textFields?.first?.text
                            self.filteredData?[indexPath.row].count_completed_days += Int(added_days!) ?? 0
                            
                            print(added_days)
                            
                            
                            
                            self.tableView.reloadData()
                            
                            
                    
                }
                    AddItemAction.setValue(UIColor.black, forKey: "titleTextColor")
                                         alertcontroller.addAction(CancelAction)
                                         alertcontroller.addAction(AddItemAction)
                                         self.present(alertcontroller, animated: true, completion: nil)
          
            
            
//            self.addDay(indexpath: indexPath)
        }
        Addaction.backgroundColor = UIColor.green
        
        
        let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
                   print("delete  btn clicked")
            //let A_task = self.tasks![indexPath.row] as? NSManagedObject
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

                             // context
            let ManagedContext = appDelegate.persistentContainer.viewContext
            
          
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModal")
//               fetchRequest.returnsObjectsAsFaults = false
            do{
                     let results = try ManagedContext.fetch(fetchRequest)
                    let objectToDelete = results[indexPath.row] as! NSManagedObject
                
                self.filteredData?.remove(at: indexPath.row)
                  self.tasks?.remove(at: indexPath.row)
                ManagedContext.delete(objectToDelete)
                tableView.reloadData()
//                for managedObjects in results{
//                    if let managedObjectsData = managedObjects as? NSManagedObject{

               
                do {
                    try ManagedContext.save();
                  
                } catch {
                    print(error)
                    // Error occured while deleting objects
                }

        }
            
            catch{
                print(error)
            }
           

        }
    
       
              
        return [Addaction,deleteaction]
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert{
            
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailview = segue.destination as? AddTaskVC{
            detailview.delegate = self
            detailview.tasks = tasks
        
        
        if let tableViewCell = sender as? UITableViewCell{
            if let index = tableView.indexPath(for: tableViewCell)?.row{
                detailview.task_title = filteredData![index].title
                detailview.alloted_days = String(filteredData![index].days)
                curIndex = index
            }
        }
        }
        
        
    }
    
    
    func updateArray(taskArray:[Task]){
        self.tasks = taskArray
        tableview.reloadData()
    }

    
     func LoadCoreData(){

           tasks = [Task]()
           //create an instance of app delegate
                  let appDelegate = UIApplication.shared.delegate as! AppDelegate

                  // context
                  let ManagedContext = appDelegate.persistentContainer.viewContext

           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModal")

           do{
               let results = try ManagedContext.fetch(fetchRequest)
               if results is [NSManagedObject]{
                   for result in results as! [NSManagedObject]{
                       let title = result.value(forKey:"title") as! String

                       let days = result.value(forKey: "days") as! Int
                    let date = result.value(forKey: "date")  as? String
                                      
                        tasks?.append(Task(title: title, days: days,date: date ?? ""))

               

                   }
               }
           } catch{
               print(error)
           }
//           print("\(tasks!.count )@@@@@@@@@@@@@")
         
       }
    
    
    @IBAction func sort_Datetime(_ sender: UIBarButtonItem) {
        
        let itemSort = self.filteredData!
        self.filteredData! = itemSort.sorted { $0.date < $1.date }
           self.tableView.reloadData()
        
    }
    
    
    @IBAction func Sort_title(_ sender: UIBarButtonItem) {
        
        let itemSort = self.filteredData!
            self.filteredData! = itemSort.sorted { $0.title < $1.title }
               self.tableView.reloadData()
    }
    
    
    
    
//    func addDay(indexpath:IndexPath){
//        let index_path = indexpath
//        let alertcontroller = UIAlertController(title: "Add Day", message: "Enter a day for this task", preferredStyle: .alert)
//
//               alertcontroller.addTextField { (textField ) in
//                               textField.placeholder = "number of days"
//                   textField.text = ""
//               }
//               let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//               CancelAction.setValue(UIColor.brown, forKey: "titleTextColor")
//               let AddItemAction = UIAlertAction(title: "Add Day", style: .default){
//                   (action) in
//                let added_days = alertcontroller.textFields?.first?.text
//                self.tasks?[indexpath.row] += Int(added_days!) ?? 0
//
//                print(added_days)
//
//                self.tableView.reloadData()
//
//
//
//    }
//        AddItemAction.setValue(UIColor.black, forKey: "titleTextColor")
//                             alertcontroller.addAction(CancelAction)
//                             alertcontroller.addAction(AddItemAction)
//                             self.present(alertcontroller, animated: true, completion: nil)
//}
    
    
    
    
    
    
     
    
    
}

extension TaskListTableVC : UISearchBarDelegate, UISearchDisplayDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
               
            filteredData = searchText.isEmpty ? tasks : tasks!.filter ({ (item: Task) -> Bool in
                    // If dataItem matches the searchText, return true to include it
        //            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    //            let task = item.title
    //                return task.lowercased().contains(searchText.lowercased())
                print(filteredData!)
                print(searchText)
                return item.title.range(of: searchText, options: .caseInsensitive) != nil
                })
                
                tableView.reloadData()
            }
            
        override func viewWillAppear(_ animated: Bool) {
            
            filteredData = tasks!
            tableview.reloadData()
        }
}
