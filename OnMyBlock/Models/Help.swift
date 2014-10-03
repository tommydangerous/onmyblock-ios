//
//  Help.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/1/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import Foundation

@objc protocol HelpDelegate {
  optional func createHelpForStudentSucceeded()
  optional func createHelpForStudentFailed(#error: NSError!)
}

class Help: Object {

  // Methods
  // Public methods

  // Instance methods
  func createHelpForStudent(dictionary: [String: AnyObject],
    delegate: HelpDelegate?) -> () {
      
    sessionManager().POST("help/student", parameters: [
      "help_student": dictionary
    ], success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
      if delegate? != nil {
        delegate?.createHelpForStudentSucceeded!()
      }
    }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
      if delegate? != nil {
        delegate?.createHelpForStudentFailed!(error: error!)
      }
    })
  }
}
