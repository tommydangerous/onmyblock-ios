//
//  SearchManagerTests.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import UIKit
import XCTest

import OnMyBlock

class SearchManagerTests: XCTestCase {
  // Setup
  override func setUp() {
    super.setUp()
  }
  override func tearDown() {
    super.tearDown()
  }

  // Methods
  // Public methods

  // Class methods
  func testSharedInstanceReturningSingleInstance() {
    let instance1 = SearchManager.sharedInstance
    let instance2 = SearchManager.sharedInstance
    XCTAssertEqual(instance1, instance2, "should be the same instance")
  }
}
