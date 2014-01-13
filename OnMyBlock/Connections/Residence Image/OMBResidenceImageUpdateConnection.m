//
//  OMBResidenceImageUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImageUpdateConnection.h"

#import "OMBResidenceImage.h"

@implementation OMBResidenceImageUpdateConnection

#pragma mark - Initializer

- (id) initWithResidenceImage: (OMBResidenceImage *) object
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/residence_images/%i",
    OnMyBlockAPIURL, object.uid];
  NSDictionary *params = @{
    @"access_token":    [OMBUser currentUser].accessToken,
    @"residence_image": @{
      @"position": [NSNumber numberWithInt: object.position]
    }
  };
  [self setRequestWithString: string method: @"PATCH" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  
  NSLog(@"OMBResidenceImageUpdateConnection");
  NSLog(@"%@", json);

  [super connectionDidFinishLoading: connection];
}

@end
