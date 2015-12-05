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

class BreedPickerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
     
     @IBOutlet weak var navBar: UINavigationBar!
     @IBOutlet weak var breedListTableView: UITableView!
     @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
     @IBOutlet weak var loadingBreedsTextView: UITextView!
     
     let client = PetFinderAPIClient.sharedInstance()
     var delegate: BreedPickerListViewControllerDelegate!
     var breedData: [String] = [String]()
     var species: String?
     
     var filteredTableData = [String]()
     var resultSearchController = UISearchController()
     
     @IBOutlet weak var activityView: UIView!
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          self.navBar.topItem!.title = "Select \(species!.capitalizedString) Breed"
          breedListTableView.delegate = self
          breedListTableView.dataSource = self

          activityIndicator.startAnimating()

          getBreeds()
          
          self.resultSearchController = ({
               let controller = UISearchController(searchResultsController: nil)
               controller.searchResultsUpdater = self
               controller.dimsBackgroundDuringPresentation = false
               controller.searchBar.sizeToFit()
               self.breedListTableView.tableHeaderView = controller.searchBar
               return controller
          })()

     }
     
     func getBreeds() {

          let parseDataClient = PetFinderAPIClient.sharedInstance()
          parseDataClient.animal = species
          
          parseDataClient.loadBreeds() {
               breeds, errorString in
               
               if let breeds = breeds {
                         let breedList = breeds["breed"]! as! NSArray
                         
                         for item in breedList {
                              let breedName = item.valueForKey("$t")
                              self.breedData.append("\(breedName!)")
                         }
                         
                         dispatch_async(dispatch_get_main_queue(), {
                              self.breedListTableView.reloadData()
                              self.activityIndicator.stopAnimating()
                              self.activityView.hidden = true
                              self.loadingBreedsTextView.hidden = true
                         })
               } else {
                    if let error = errorString {
                         print(error)
                    }
               }
          }
     }
     
     
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if (self.resultSearchController.active) {
               return self.filteredTableData.count
          }
          else {
               return breedData.count ?? 0
          }
     }
     
     
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          
          let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("breedCell", forIndexPath: indexPath) as UITableViewCell
          
          if (self.resultSearchController.active) {
               cell.textLabel?.text = filteredTableData[indexPath.row]
               return cell
          }
          else {
               cell.textLabel!.text = self.breedData[indexPath.row]
               return cell
          }
     }
     
     
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          
          var breed: String?
          
          if (self.resultSearchController.active) {
               breed = filteredTableData[indexPath.row]
               // Alert the delegate
               delegate?.breedPicker(self, didPickBreed: breed)
               self.dismissViewControllerAnimated(false, completion: nil)
          } else {
               breed = breedData[indexPath.row]
               // Alert the delegate
               delegate?.breedPicker(self, didPickBreed: breed)
          }
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     func updateSearchResultsForSearchController(searchController: UISearchController)
     {
          filteredTableData.removeAll(keepCapacity: false)
          
          let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
          let array = (breedData as NSArray).filteredArrayUsingPredicate(searchPredicate)
          filteredTableData = array as! [String]
          
          self.breedListTableView.reloadData()
     }
     
    
     
     
     // Cancel and return to Add or Edit Pet View Controller
     @IBAction func cancelButtonPressed(sender: AnyObject) {
          delegate?.breedPicker(self, didPickBreed: nil)
          self.dismissViewControllerAnimated(true, completion: nil)
     }
}