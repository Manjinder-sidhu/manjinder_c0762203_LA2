//
//  AddTaskVC.swift
//  manjinder_c0762203_LA2
//
//  Created by Manjinder Aulakh on 2020-01-19.
//  Copyright © 2020 Manjinder kaur. All rights reserved.
//

import UIKit
import CoreData

class AddTaskVC: UIViewController {

    @IBOutlet var textfields : [UITextField]!

    
    var tasks : [Task]?
    weak var delegate : TaskListTableVC?
    var task_title : String?
    var alloted_days:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tasks = [Task]()
//        LoadCoreData()
        SaveCoreData()

//               NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData),name: UIApplication.willResignActiveNotification,object: nil)
               // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(SaveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let title1 = textfields[0].text ?? ""
        let days1 = Int(textfields[1].text ?? "0") ?? 0
        //
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date) 
        print(formattedDate)

        let task = Task(title: title1, days: days1, date: formattedDate)
        
        if tasks != nil && delegate?.curIndex == -1{
              
              
              tasks?.append(task)
                         for textField in textfields {
                             textField.text = ""
                             textField.resignFirstResponder()
                         }
          }
        else if delegate?.curIndex != -1 && tasks != nil{
              
              tasks![delegate!.curIndex].title = title1
              tasks![delegate!.curIndex].days = days1
              
              let indexPath = IndexPath(item: delegate!.curIndex, section: 0)
              delegate?.tableView.reloadRows(at: [indexPath], with: .none)
              delegate?.curIndex = -1
            
            for textfield in textfields{
                textfield.text = ""
                textfield.resignFirstResponder()
                
            }
              
          }
        
    }
        
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
            //delegate?.tableView.reloadData()
        delegate?.updateArray(taskArray: tasks!)
//        print("\(tasks)~~~~~~~~~~~~~~~~~~@!")
   
        }

    
    

    
    @objc func SaveCoreData(){
        //call clear core data
      
            clearCoreData()
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // context
        let ManagedContext = appDelegate.persistentContainer.viewContext

        for task in tasks!{
            let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskModal", into: ManagedContext)
           taskEntity.setValue(task.title, forKey: "title")
           taskEntity.setValue(task.days, forKey: "days")
            taskEntity.setValue(task.date, forKey: "date")
           

            //save  context
            do{
                try ManagedContext.save()
            }catch{
                print(error)
            }


            print("\(task.days)&&&&")
        }
         LoadCoreData()
    }

    
    
    
    
    //load core data
    
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
                    let date = result.value(forKey: "date")  as! String
               


                    tasks?.append(Task(title: title, days: days,date: date))

                }
            }
        } catch{
            print(error)
        }
        print("\(tasks!.count )@@@@@@@@@@@@@")
      
    }


    
    //clear core data
    
    func clearCoreData(){
     //create an instance of app delegate
     let appDelegate = UIApplication.shared.delegate as! AppDelegate

     // context
     let ManagedContext = appDelegate.persistentContainer.viewContext

        //create fetch request
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModal")

        fetchRequest.returnsObjectsAsFaults = false
        do{

            let results = try ManagedContext.fetch(fetchRequest)
            for managedObjects in results{
                if let managedObjectsData = managedObjects as? NSManagedObject{

                    ManagedContext.delete(managedObjectsData)
                }
            }
        }
            catch{
                print(error)
            }

    }

    
    
    
    
    
    
    
    
}
