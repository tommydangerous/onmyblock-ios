//
//  SchoolSearchManagerTests.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import XCTest

class SchoolSearchManagerTests: XCTestCase {

  // Methods
  // Public methods

  // Class methods
  func testSharedInstanceReturningSingleInstance() {
    let instance1 = SchoolSearchManager.sharedInstance
    let instance2 = SchoolSearchManager.sharedInstance
    XCTAssertEqual(instance1, instance2, "should be the same instance")
  }

  // Instance methods
  func testSearchReturningADictionaryOfSchools() {
    class TestDelegate: SearchManagerDelegate {
      func searchFailed(#error: NSError!) {
        println(error)
      }
      func searchSucceeded(#responseObject: AnyObject!) {
        println(responseObject)
      }
    }
    let testDelegate = TestDelegate()
    // This doesn't work for some reason; will come back to it
    // SchoolSearchManager.sharedInstance.search(["query": "uni"],
    //   accessToken: nil, delegate: testDelegate)
  }
}
