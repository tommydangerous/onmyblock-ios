//
//  OMBAuthenticationFacebookConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBAuthenticationFacebookConnection.h"

@implementation OMBAuthenticationFacebookConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/authentications/facebook",
    OnMyBlockAPIURL];
  NSDictionary *params = @{
    @"access_token":          [OMBUser currentUser].accessToken,
    @"facebook_access_token": [OMBUser currentUser].facebookAccessToken,
    @"facebook_id":           [OMBUser currentUser].facebookId
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBAuthenticationLinkedInConnection\n%@", [self json]);

  if ([self successful]) {
    NSString *imageURLString = [[self objectDictionary] objectForKey:
      @"image_url"];
    [OMBUser currentUser].imageURL = [NSURL URLWithString:
      imageURLString];
  }
  else {
    internalError = [NSError errorWithDomain: 
      OMBConnectionErrorDomainAuthentication
      code: OMBConnectionErrorDomainAuthenticationCodeFacebookFailed
        userInfo: @{
          @"message": @"We couldn't verify your Facebook, please try again.",
          @"title": @"Authentication failed"
        }
      ];
  }

  [super connectionDidFinishLoading: connection];
}

@end
