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
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSString *params = [NSString stringWithFormat:
    @"email=%@&"
    @"first_name=%@&"
    @"last_name=%@&"
    @"password=%@",
    [dictionary objectForKey: @"email"],
    [dictionary objectForKey: @"first_name"],
    [dictionary objectForKey: @"last_name"],
    [dictionary objectForKey: @"password"]
  ];
  [req setHTTPBody: [params dataUsingEncoding: NSUTF8StringEncoding]];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([[json objectForKey: @"success"] intValue]) {
    [[OMBUser currentUser] readFromDictionary: json];
    [[NSNotificationCenter defaultCenter] postNotificationName: 
      OMBUserLoggedInNotification object: nil];
  }
  [super connectionDidFinishLoading: connection];
}

@end
