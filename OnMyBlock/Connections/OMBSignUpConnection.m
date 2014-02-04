//
//  OMBSignUpConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSignUpConnection.h"

#import "OMBAppDelegate.h"
#import "OMBMenuViewController.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"

@implementation OMBSignUpConnection

#pragma mark - Initializer

- (id) initWithParameters: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/users/", OnMyBlockAPIURL];
  [self setRequestWithString: string method: @"POST" parameters: dictionary];

  return self;
}

#pragma mark - Override

#pragma mark - Override OMBConnection

- (void) start
{
  [self startWithTimeoutInterval: 30 onMainRunLoop: YES];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBSignUpConnection\n%@", [self json]);
  
  if ([self successful]) {
    [[OMBUser currentUser] readFromDictionary: [self objectDictionary]];
    [[NSNotificationCenter defaultCenter] postNotificationName: 
      OMBUserLoggedInNotification object: nil];
  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainUser
      code: OMBConnectionErrorDomainUserCodeSignUpFailed];
  }
  [super connectionDidFinishLoading: connection];
}

@end
