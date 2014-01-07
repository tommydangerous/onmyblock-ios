//
//  OMBUserFacebookAuthenticationConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserFacebookAuthenticationConnection.h"

@implementation OMBUserFacebookAuthenticationConnection

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;
  NSString *string = [NSString stringWithFormat: 
    @"%@/auth/facebook/", OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSString *params = [NSString stringWithFormat:
    @"email=%@&"
    @"facebook_access_token=%@&"
    @"facebook_id=%@&"
    @"first_name=%@&"
    @"last_name=%@",
    user.email, 
    user.facebookAccessToken, 
    user.facebookId, 
    user.firstName, 
    user.lastName
  ];
  [req setHTTPBody: [params dataUsingEncoding: NSUTF8StringEncoding]];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

#pragma mark - Override

#pragma mark - Override OMBConnection

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: self.request
    delegate: self startImmediately: NO];
  [internalConnection scheduleInRunLoop: [NSRunLoop mainRunLoop]
    forMode: NSDefaultRunLoopMode];
  [internalConnection start];
  if (!sharedConnectionList) {
    sharedConnectionList = [NSMutableArray array];
  }
  [sharedConnectionList addObject: self];
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  [[OMBUser currentUser] readFromDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
