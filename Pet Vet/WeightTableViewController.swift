//
//  WeightTableViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/15/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class WeightTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

     @IBOutlet var weightTableView: UITableView!

     var selectedPet: Pet!
     
     var storedWeights = [Weight]()     // local array of fetched weights
     var deleteWeightIndexPath: NSIndexPath? = nil
     var weightToDelete = [Weight]()

     var searchPredicate: NSPredicate?
     var filteredObjects : [Weight]? = nil
     var weightUnitString: String?
     let WeightSettingKey = "Weight Setting"
     
     let dateFormatter = NSDateFormatter()
     
     override func viewDidLoad() {
          super.viewDidLoad()
          self.weightTableView.delegate = self
          
          self.navigationItem.title = "Weight Tracking: \(selectedPet.name)"
          
          let addButton = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addWeight")
          self.navigationItem.rightBarButtonItem = addButton

          fetchedResultsController.delegate = self
          
          // Retrieve the preferred weight unit
          if NSUserDefaults.standardUserDefaults().integerForKey(WeightSettingKey) == 0 {
               weightUnitString = "lbs"
          } else {
               weightUnitString = "kg"
          }

          dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
          dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
     }
     
     
     override func viewWillAppear(animated: Bool) {
          super.viewWillAppear(animated)
     }
     
     override func viewDidAppear(animated: Bool) {
          super.viewDidAppear(animated)
          
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
               self.storedWeights = self.fetchAllWeights()
               self.weightTableView.reloadData()
          })
     }
     
     func addWeight (){
          let controller = storyboard!.instantiateViewControllerWithIdentifier("AddWeightViewController") as! AddWeightViewController
          controller.selectedPet = self.selectedPet
          self.navigationController!.pushViewController(controller, animated: true)
     }
     
     // ******************************************
     // * Lazy fetchedResultsController property *
     // ******************************************
     lazy var fetchedResultsController: NSFetchedResultsController = {
          let fetchRequest = NSFetchRequest(entityName: "Weight")
          
          fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
          
          let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
          
          return fetchedResultsController
     } ()
     

     // *****************************
     // * Fetches all saved Weights *
     // *****************************
     func fetchAllWeights() -> [Weight] {
          let error: NSErrorPointer = nil
          let fetchRequest = NSFetchRequest(entityName: "Weight")
          fetchRequest.predicate = NSPredicate(format: "pet == %@", self.selectedPet)
          fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
          
          let results: [AnyObject]?
          do {
               results = try self.sharedContext.executeFetchRequest(fetchRequest)
          } catch let error1 as NSError {
               error.memory = error1
               results = nil
          }
          
          if error != nil {
               print("fetchAllWeights() error: \(error)")
          }

          return results as! [Weight]
     }


     var sharedContext: NSManagedObjectContext {
          return CoreDataStackManager.sharedInstance().managedObjectContext!
     }
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          print("numberofRowsInSection - storedWeights.count: \(storedWeights.count)")
          
          return storedWeights.count ?? 0
     }
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCellWithIdentifier("weightCell", forIndexPath: indexPath) as! WeightTableViewCell
          
          let weightTable = storedWeights[indexPath.row]
          
          let weightAmt = weightTable.weight
          let weightDate = weightTable.date
          
          let weightAmtStr = "\(weightAmt) \(weightUnitString!)"

          let weightDateStr = dateFormatter.stringFromDate(weightDate)
          
          cell.dateLabel.text = weightDateStr
          cell.weightLabel.text = weightAmtStr

          return cell
     }

     
     // ***********************
     // * Swipe to delete Pet *
     // ***********************
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
          if editingStyle == .Delete {
               let fetchRequest = NSFetchRequest(entityName: "Weight")
               let weightSearchPredicate = NSPredicate(format: "date == %@", storedWeights[indexPath.row].date)
               let petSearchPredicate = NSPredicate(format: "pet == %@", storedWeights[indexPath.row].pet!)
               let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [petSearchPredicate, weightSearchPredicate])
               fetchRequest.predicate = compoundPredicate
               fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
              
               // Get the single Weight Object to Delete
               let results: [AnyObject]?
               do {
                    results = try self.sharedContext.executeFetchRequest(fetchRequest)
               } catch let error1 as NSError {
                    results = nil
                    print(error1)
               }
               
               weightToDelete = results as! [Weight]
               print(weightToDelete)
               
               deleteWeightIndexPath = indexPath
               confirmDelete()
          }
     }
     
     func confirmDelete () {
          let alert = UIAlertController(title: "Delete Weight", message: "Are you sure you want to remove weight from \(weightToDelete[0].date)?", preferredStyle: .ActionSheet)
          
          let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteWeight)
          let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteWeight)
          alert.addAction(DeleteAction)
          alert.addAction(CancelAction)
          
          self.presentViewController(alert, animated: true, completion: nil)
     }
     
     func handleDeleteWeight(alertAction: UIAlertAction!) -> Void {
          if let _ = deleteWeightIndexPath {
               tableView.beginUpdates()
               
               
               dispatch_async(dispatch_get_main_queue(), {
                    for weight in self.weightToDelete {
                              self.sharedContext.deleteObject(weight)
                              CoreDataStackManager.sharedInstance().saveContext()
                    }
                    self.deleteWeightIndexPath = nil
                    self.weightToDelete = [Weight]()
                    
                    self.storedWeights = self.fetchAllWeights()
                    self.tableView.reloadData()
               })
              tableView.endUpdates()

          }
     }
     
     func cancelDeleteWeight(alertAction: UIAlertAction!) {
          deleteWeightIndexPath = nil
          weightToDelete = [Weight]()
     }
     
}