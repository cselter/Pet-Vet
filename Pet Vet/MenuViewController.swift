//
//  MenuViewController.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/15/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MenuViewController: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
     @IBOutlet weak var pawPrintImageView: UIImageView!
     @IBOutlet weak var petNameLabel: UILabel!
     
     @IBOutlet weak var sexAndBreedLabel: UILabel!
     @IBOutlet weak var ageLabel: UILabel!
     
     @IBOutlet weak var photoImageView: UIImageView!
     
     
     // Currently Selected Pet
     var selectedPet: Pet!
     
     
     let imagePicker = UIImagePickerController()
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          self.navigationItem.title = "Menu"
          
          petNameLabel.text = selectedPet.name
          
          let petSex = selectedPet.valueForKey("sex")!
          let petBreed = selectedPet.valueForKey("breed")!
          
          let detailText = "\(petSex) \(petBreed)"
          
          self.sexAndBreedLabel.text = detailText
          
          let age = selectedPet.calculateAge()
          
          self.ageLabel.text = age
          
          // set the paw print image
          if selectedPet.sex == "Male" {
               pawPrintImageView.image = UIImage(named: "pawBlue")
          } else {
               pawPrintImageView.image = UIImage(named: "pawPink")
          }
          
          imagePicker.delegate = self
          imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
          
          if selectedPet.photo != nil {
               photoImageView.image = UIImage(data: selectedPet.photo!)
               
          } else {
               photoImageView.image = UIImage(named: "cameraBlue")
               photoImageView.contentMode = UIViewContentMode.Center
          }
          
          
          //  use ImageView as button
          let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
          photoImageView.userInteractionEnabled = true
          photoImageView.addGestureRecognizer(tapGestureRecognizer)
     }
   
     func imageTapped(img: AnyObject) {
          self.presentViewController(imagePicker, animated: true, completion: nil)
     }
   
     func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
          
          self.dismissViewControllerAnimated(true, completion: nil)
          photoImageView.image = image
          let imageData = UIImageJPEGRepresentation(image, 1)
          // Save selected image to Pet Object
          selectedPet.photo = imageData
          CoreDataStackManager.sharedInstance().saveContext()
          
     }
     
     @IBAction func weightButtonPressed(sender: AnyObject) {
          let controller = storyboard!.instantiateViewControllerWithIdentifier("WeightTableViewController") as! WeightTableViewController
          
          let pet = selectedPet
          controller.selectedPet = pet
          self.navigationController!.pushViewController(controller, animated: true)
     }
     
     
     
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

          if segue.identifier == "editPetSegue" {
               print(segue.identifier)
               
               if let editPetVC = segue.destinationViewController as? EditPetViewController {
                   
                    
                    
                    editPetVC.selectedPet = self.selectedPet
                    
               }
               
               
               
          }
     }
     
     
     
}