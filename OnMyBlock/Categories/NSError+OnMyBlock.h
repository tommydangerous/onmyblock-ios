//
//  NSError+OnMyBlock.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

// Authentication w/ 3rd parties
extern NSString *const OMBConnectionErrorDomainAuthentication;
typedef NS_ENUM(NSInteger, OMBConnectionErrorDomainAuthenticationCode) {
  OMBConnectionErrorDomainAuthenticationCodeFacebookFailed,
  OMBConnectionErrorDomainAuthenticationCodeLinkedInFailed
};

// Messages
extern NSString *const OMBConnectionErrorDomainMessage;
typedef NS_ENUM(NSInteger, OMBConnectionErrorDomainMessageCode) {
  OMBConnectionErrorDomainMessageCodeCreateFailed
};

// Session
extern NSString *const OMBConnectionErrorDomainSession;
typedef NS_ENUM(NSInteger, OMBConnectionErrorDomainSessionCode) {
  OMBConnectionErrorDomainSessionCodeLoginFailed
};

// User
extern NSString *const OMBConnectionErrorDomainUser;
typedef NS_ENUM(NSInteger, OMBConnectionErrorDomainUserCode) {
  OMBConnectionErrorDomainUserCodeSaveFailed,
  OMBConnectionErrorDomainUserCodeSignUpFailed
};

@interface NSError (OnMyBlock)

@end
