//
//  Network.swift
//
//  Created by Christopher Burgess on 6/13/15.
//  Updated for Swift 2.0 11/29/2015
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
// **************************************************
// * Check for network connectivity before API Call *
// **************************************************
public class Network {
     
     class func isConnectedToNetwork()->Bool{
          let url = NSURL(string: "https://www.petfinder.com")
          let request = NSMutableURLRequest(URL: url!)
          request.HTTPMethod = "HEAD"
          request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
          request.timeoutInterval = 3.0

          let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
          var responseCode = -1
          
          let group = dispatch_group_create()
          dispatch_group_enter(group)
          
          session.dataTaskWithRequest(request, completionHandler: {(_, response, _) in
               if let httpResponse = response as? NSHTTPURLResponse {
                    responseCode = httpResponse.statusCode
               }
               dispatch_group_leave(group)
          }).resume()
          
          dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
          
          print("Network Status: \(responseCode == 200)")
          
          return (responseCode == 200)
         }
}