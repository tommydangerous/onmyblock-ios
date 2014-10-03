//
//  SearchManager.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import Foundation

@objc protocol SearchManagerDelegate {
  func searchFailed(#error: NSError!)
  func searchSucceeded(#responseObject: AnyObject!)
}

class SearchManager: Object {

  // Methods
  // Public methods

  // Class methods
  var operationManager: AFHTTPRequestOperationManager {
    struct StaticOperationManager {
      static let instance: AFHTTPRequestOperationManager = 
        AFHTTPRequestOperationManager()
    }
    StaticOperationManager.instance.requestSerializer = 
      AFJSONRequestSerializer()
    return StaticOperationManager.instance
  }
  class var sharedInstance: SearchManager {
    // Subclasses should override this
    struct Static {
      static let instance: SearchManager = SearchManager()
    }
    return Static.instance
  }

  // Instance methods
  func search(dictionary: [String: AnyObject], accessToken: String?,
    delegate: SearchManagerDelegate) -> () {
    // Subclasses should override this
  }
}
