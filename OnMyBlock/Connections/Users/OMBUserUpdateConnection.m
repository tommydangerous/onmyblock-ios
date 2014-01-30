//
//  OMBUserUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUserUpdateConnection.h"

@implementation OMBUserUpdateConnection

#pragma mark - Initializer

- (id) initWithDictionary: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/users/%i",
    OnMyBlockAPIURL, [OMBUser currentUser].uid];

  NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
  for (NSString *attribute in [dictionary allKeys]) {
    NSString *key = attribute;
    id value = [dictionary objectForKey: attribute];
    // First name
    if ([attribute isEqualToString: @"firstName"])
      key = @"first_name";
    // Last name
    if ([attribute isEqualToString: @"lastName"])
      key = @"last_name";
    [attributeDictionary setObject: value forKey: key];
  }

  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"user": attributeDictionary
  };
  [self setRequestWithString: string method: @"PATCH" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSLog(@"OMBUserUpdateConnection\n%@", [self json]);

  if ([self successful]) {
    [[OMBUser currentUser] readFromDictionary: [self objectDictionary]];
  }
  else {
    internalError = [NSError errorWithDomain: OMBConnectionErrorDomainUser
      code: OMBConnectionErrorDomainUserCodeSaveFailed userInfo: @{
        @"message": @"Update unsuccessful.",
        @"title": @"Save failed"
      }
    ];
  }

  [super connectionDidFinishLoading: connection];
}


@end
