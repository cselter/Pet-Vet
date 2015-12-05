# PetVet
5th Project of Udacity's iOS Developer Nanodegree

### Project Description: 
In this capstone project, students will create an app of their own design that showcases our iOS development skills.

### App Description:
PetVet is an iOS Application that allows pet owners to record and store information about the furrier members of their family. No, not Dad! Their pets!

Main Features include:
* Add/Edit/Delete Pets
* Add/Delete Weight Records
* Search for Breed Names using PetFinder.com's API
* View current information about each Pet (examples: Calculated Age, Saved Photo, Owner's Information)
* Save a Pet ID Card or Missing Pet Poster with Pet's information

App Screenshots:
![alt tag](http://www.cottontailsolutions.com/PetVetApp/AppScreenshots/IMG_0892.jpg)
![alt tag](http://www.cottontailsolutions.com/PetVetApp/AppScreenshots/IMG_0888.jpg)
![alt tag](http://www.cottontailsolutions.com/PetVetApp/AppScreenshots/IMG_0889.jpg)

#### User Interface Requirements:
* More than one view controller
  * *App contains numerous view controllers*
* A table or collection view
  * *App contains several table view controllers*
* Navigation and modal presentation
  * *App contains both navigational and modal presentation of view controllers*
* Image assets in 1x, 2x, and 3x formats. Or in vector format.
  * *Image assets are in Vector format*

#### Networking Requirements:
* Choose an API and integrate downloaded data into the app
  * *PetFinder.com's API is integrated into this app to download a list of breeds based on the species of animal (dog, cat, etc.)*
* Give users feedback around network activity, displaying activity indicators and/or progress bars when appropriate, and an alert in case of connection failures
  * *Activity indicator and message is displayed over the table view within BreedPickerListViewController while the data is downloaded into the app*
  * *Network availability is checked prior to loading the BreedPickerViewController and an alert is displayed if it is unable to connect*
* Encapsulate networking code in a class to reduce detail in View Controllers
  * *Networking code is encapsulated in its own class: PetFinderAPIClient*
  * *Network availability code is also encapsulated in its own Class: Network*

#### Persistence Requirements: 
* Include an object graph that can be persisted in Core Data
  * *Object graphs are persisted in Core Data, including 'Pet' and 'Weight' for example*
  * *Additional objects will be added in the same manner as the 'Weight' object including: 'Vaccinations', 'Alergies', 'Medications', etc.*
* Manage the Core Data Stack outside of your view controllers, either in the App Delegate or in a separate Core Data Stack manager class
  * *Core Data Stack is managed within the CoreDataStackManager class*
* Aside from your primary app state, you should find some additional state that can be stored outside of Core Data, either in NSUserDefaults, or in the documents directory using an NSKeyedArchiver
  * *Using NSUserDefaults, the current number of 'Pet' objects stored is stored as well as the preferred Weight Measurement Setting (lbs. or kg.)*

#### README Requirements:
* Describe the intended user experience
* Include all specific actions and/or commands necessary for the reviewer to compile, run, and access any aspect of the project

### Requirements to Use:
* Xcode 7.0, Swift 2.0

### Planned Future Enhancements:
* Expand Core Data Model to include other data graphs (Vet Appointment History, Vaccinations, Medications, etc.)
* Add iCloud Sync 
* Add iCloud Sharing with other users 
* Appointment/Vaccination Reminders (w/ Push Notifications)
