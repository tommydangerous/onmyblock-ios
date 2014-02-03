//
//  OMBLoginConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLoginConnection.h"

#import "OMBAppDelegate.h"
#import "OMBMenuViewController.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"

@implementation OMBLoginConnection

#pragma mark - Initializer

- (id) initWithParameters: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/login/", OnMyBlockAPIURL];
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
  NSLog(@"OMBLoginConnection\n%@", [self json]);

  if ([self successful]) {
    [[OMBUser currentUser] readFromDictionary: [self objectDictionary]];
    [[NSNotificationCenter defaultCenter] postNotificationName: 
      OMBUserLoggedInNotification object: nil];
  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainSession
      code: OMBConnectionErrorDomainSessionCodeLoginFailed];
  }

  [super connectionDidFinishLoading: connection];
}

@end
