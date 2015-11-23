//
//  BreedPickerListViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/22/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit

protocol BreedPickerListViewControllerDelegate {
     func breedPicker(breedPicker: BreedPickerListViewController, didPickBreed breed: String?)
}

class BreedPickerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
     //var appDelegate: AppDelegate!
     let client = PetFinderAPIClient.sharedInstance()
     
     var delegate: BreedPickerListViewControllerDelegate!
     
     @IBOutlet weak var breedListTableView: UITableView!
   
     //var breedArr = NSArray()
     
     var breedData: [String] = [String]()
     
     override func viewDidLoad() {
          super.viewDidLoad()

          breedListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "breedCell")
          breedListTableView.delegate = self
          breedListTableView.dataSource = self
          //appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
          getBreeds()
          breedListTableView.reloadData()
     }
     
     func getBreeds() {
          
          let parseDataClient = PetFinderAPIClient.sharedInstance()
          
          parseDataClient.loadBreeds() {
               breeds, errorString in
               
               if let breeds = breeds {
                    //if let appDelegate = self.appDelegate {
                         let breedList = breeds["breed"]! as! NSArray
                         
                         for item in breedList {
                              let breedName = item.valueForKey("$t")
                              self.breedData.append("\(breedName!)")
                         }
                         
                         //appDelegate.breedList = self.breedData
                         
                         dispatch_async(dispatch_get_main_queue(), {
                              self.breedListTableView.reloadData()

                         })
                   // }
               } else {
                    if let error = errorString {
                         print(error)
                    }
               }
          }
     }
     
     
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return breedData.count ?? 0
     }
     
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          
          let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("breedCell", forIndexPath: indexPath) as UITableViewCell
          
          cell.textLabel!.text = self.breedData[indexPath.row]
          return cell
     }
     
     
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          let breed = breedData[indexPath.row]
          
          // Alert the delegate
          delegate?.breedPicker(self, didPickBreed: breed)
          // print(breed)
                    
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     
     @IBAction func cancelButtonPressed(sender: AnyObject) {
          delegate?.breedPicker(self, didPickBreed: nil)
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
}