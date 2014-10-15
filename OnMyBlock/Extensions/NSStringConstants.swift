//
//  Constants.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 9/30/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import Foundation

extension NSString {
  class func companyPhoneNumberString() -> String {
    return "6503317819"
  }

  // LinkedIn
  class func linkedInRedirectURL() -> String {
    return "https://onmyblock.com/authentications/linkedin-oauth-redirect"
  }
  class func linkedInClientID() -> String {
    return "75zr1yumwx0wld"
  }
  class func linkedInClientSecret() -> String {
    return "XNY3VsMzvdhyR1ej"
  }
  class func linkedInGrantedAccess() -> [String] {
    return ["r_fullprofile"]
  }
  class func linkedInState() -> String {
    return "DCEEFWF45453sdffef424"
  }
}
