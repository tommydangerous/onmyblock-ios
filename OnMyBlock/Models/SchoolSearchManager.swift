//
//  SchoolSearchManager.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import Foundation

class SchoolSearchManager: SearchManager {
  let suggestEndPoint = "https://e9da11d9cc7b5c4a000.qbox.io/_suggest"

  // Methods
  // Public methods

  // Class methods
  override class var sharedInstance: SchoolSearchManager {
    struct Static {
      static let instance: SchoolSearchManager = SchoolSearchManager()
    }
    return Static.instance
  }
  // Instance methods
  override func search(dictionary: [String: AnyObject], accessToken: String?,
    delegate: SearchManagerDelegate?) -> () {
    // Pass a dictionary with a key=query and a value of whatever searching for
    operationManager.POST(suggestEndPoint, parameters: [
      "schoolsuggest": [
        "completion": [
          "field": "suggest",
          "size":  "20"
        ],
        "text": dictionary["query"] as NSString
      ]
    ], success: { (operation: AFHTTPRequestOperation!, 
      responseObject: AnyObject!) in

      if delegate? != nil {
        // hits = response.schoolsuggest[0].options
        var array: AnyObject
        let schoolsuggest: AnyObject? = responseObject?["schoolsuggest"]
        if schoolsuggest? != nil {
          array = Array(schoolsuggest as NSArray)
          array = Array(array[0]["options"] as NSArray)
        } else {
          array = [AnyObject]()
        }
        // Sample array
        // [
        //   {
        //     payload =         {
        //       latlon = "40.800732,-77.861644";
        //       "school_id" = 5786;
        //     };
        //     score = 1;
        //     text = "Pennsylvania State University";
        //   }
        // ]
        delegate?.searchSucceeded(responseObject: array)
      }
    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
      if delegate? != nil {
        delegate?.searchFailed(error: error!)
      }
    })
  }
}
