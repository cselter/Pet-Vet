//
//  PetFinderAPIClient.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/11/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit

// petfinder.com API
class PetFinderAPIClient : NSObject {
     
     var session: NSURLSession
     
     let PETFINDER_BASE_URL = "https://api.petfinder.com/breed.list"
     let PETFINDER_API_KEY = "96864f7686fdf133e83c99c2ad3ae809"
     
     var animal: String? = "dog"   // default value if one not provided
     
     override init() {
          session = NSURLSession.sharedSession()
          super.init()
     }
     
     func loadBreeds(completionHandler: (data: NSDictionary?, errorString: String?) -> Void) {

          print(animal)
          
          let keyValuePairs = [
               "key": PETFINDER_API_KEY,
               "animal": "\(animal!)",
               "format": "json"
          ]
     
          /* Create the NSURLRequest using properly escaped URL */
          let urlString = PETFINDER_BASE_URL + escapedParameters(keyValuePairs)
          let url = NSURL(string: urlString)!
          let request = NSURLRequest(URL: url)
          
          /* Create NSURLSessionDataTask and completion handler */
          let task = session.dataTaskWithRequest(request) {data, response, downloadError in
               if let error = downloadError {
                    print("Could not complete the request \(error)")
               } else {
                    // var parsingError: NSError? = nil
                    do {
                         let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                         
                         if let results = parsedResult.valueForKey("petfinder") as? [String:AnyObject] {
                              if let breedList = results["breeds"] as? NSDictionary {
                                   completionHandler(data: breedList, errorString: nil)
                              } else {
                                   print("Could not retrieve breed dictionary")
                              }
                         } else {
                              print("Count not retrieve petfinder data")
                         }
                         
                         //returnBreeds = breeds
                    } catch _ {
                         print("Unable to parse json data")
                         // print(response)
                    }
               }
          }
          /* Resume (execute) the task */
          task.resume()
     }
     
     
     class func sharedInstance() -> PetFinderAPIClient {
          struct Singleton {
               static var sharedInstance = PetFinderAPIClient()
          }
          return Singleton.sharedInstance
     }
     
     
     func escapedParameters(parameters: [String : AnyObject]) -> String {
          
          var urlVars = [String]()
          
          for (key, value) in parameters {
               
               /* Make sure that it is a string value */
               let stringValue = "\(value)"
               
               /* Escape it */
               let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
               
               /* Append it */
               urlVars += [key + "=" + "\(escapedValue!)"]
               
          }
          
          return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
     }

}