//
//  OMBUserUploadImageConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/4/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserUploadImageConnection.h"

#import "Base64.h"
#import "UIImage+FixOrientation.h"

@implementation OMBUserUploadImageConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/users/upload_image", OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];

  // Convert our image to Base64 encoding
  [Base64 initialize];
  NSData *imageData = UIImagePNGRepresentation(
    [[OMBUser currentUser].image fixOrientation]);
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"image_data":   [Base64 encode: imageData]
  };
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject: params 
    options: 0 error: nil];

  // Must have or get: ERROR RangeError: exceeded available parameter key space
  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: jsonData];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  // Set timeout
  [self.request setTimeoutInterval: 60];
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: self.request
    delegate: self startImmediately: YES];
  if (!sharedConnectionList)
    sharedConnectionList = [NSMutableArray array];
  [sharedConnectionList addObject: self];
}

@end
