//
//  PetFinderAPIClient.swift
//  Pet Vet
//
//  Created by Christopher Burgess on 11/11/15.
//  Copyright © 2015 Christopher Burgess. All rights reserved.
//

import Foundation

// petfinder.com API
// API Key: 96864f7686fdf133e83c99c2ad3ae809
// API Secret: 644fba2c18394c315d496ba46576a585


class PetFinderAPIClient : NSObject {
     
     var session: NSURLSession
     
     let PETFINDER_BASE_URL = "http://api.petfinder.com/"
     let PETFINDER_BREEDLIST_URL = "breed.list"
     let PETFINDER_API_KEY = "96864f7686fdf133e83c99c2ad3ae809"
     let PETFINDER_API_SECRET = "644fba2c18394c315d496ba46576a585"
     
     override init() {
          session = NSURLSession.sharedSession()
          super.init()
     }
     
     
     func searchBreed() {
     
     
     
          let keyValuePairs = [
               "key": PETFINDER_API_KEY,
               "animal": "dog",
               "format": "json"
          ]
     
     
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