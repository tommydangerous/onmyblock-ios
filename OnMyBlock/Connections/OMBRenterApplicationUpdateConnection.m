//
//  OMBRenterApplicationUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationUpdateConnection.h"

#import "OMBRenterApplication.h"

@implementation OMBRenterApplicationUpdateConnection

#pragma mark - Initializer

- (id) initWithRenterApplication: (OMBRenterApplication *) object
dictionary: (NSDictionary *) dictionary
{
  if (!(self = [super init])) return nil;

  renterApplication = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/renter_applications/update_renter_application", OnMyBlockAPIURL];
  NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
  for (NSString *attribute in [dictionary allKeys]) {
    NSString *key = attribute;
    id value = [dictionary objectForKey: attribute];
    // Cats
    if ([key isEqualToString: @"cats"]) {
      if ([value intValue])
        value = @"true";
      else
        value = @"false";
    }
    // Coapplicant count
    if ([key isEqualToString: @"coapplicantCount"])
      key = @"coapplicant_count";
    // Dogs
    if ([key isEqualToString: @"dogs"]) {
      if ([value intValue])
        value = @"true";
      else
        value = @"false";
    }
    // Has cosigner
    if ([key isEqualToString: @"hasCosigner"]) {
      key = @"has_cosigner";
      if ([value intValue])
        value = @"true";
      else
        value = @"false";
    }
    [attributeDictionary setObject: value forKey: key];
  }
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"renter_application": attributeDictionary
  };
  [self setRequestWithString: string method: @"PATCH" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBRenterApplicationUpdateConnection\n%@", [self json]);

  if ([self successful]) {
    [renterApplication readFromDictionary: [self objectDictionary]];
  }
  else {
    internalError = [NSError errorWithDomain: OMBConnectionErrorDomainUser
      code: OMBConnectionErrorDomainUserCodeSaveFailed userInfo: @{
        @"message": @"Update unsuccessful.",
        @"title":   @"Save failed"
      }
    ];
  }

  [super connectionDidFinishLoading: connection];
}


@end
