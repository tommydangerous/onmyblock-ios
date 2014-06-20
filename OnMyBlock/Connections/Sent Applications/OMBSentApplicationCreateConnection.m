//
//  OMBSentApplicationCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplicationCreateConnection.h"

#import "OMBRenterApplication.h"

@implementation OMBSentApplicationCreateConnection

#pragma mark - Initializer

- (id) initWithResidenceUID: (NSUInteger) residenceUID
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/sent_applications",
    OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"residence_id": @(residenceUID)
  };
  [self setPostRequestWithString: string parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    [[OMBUser currentUser].renterApplication readFromSentApplicationDictionary:
      @{
        @"objects": @[[[self json] objectForKey: @"object"]]
      }];
  }
  [super connectionDidFinishLoading: connection];
}

@end
