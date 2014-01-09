//
//  OMBResidenceUploadImageConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/8/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceUploadImageConnection.h"

#import "Base64.h"
#import "OMBResidence.h"
#import "OMBResidenceImage.h"
#import "OMBTemporaryResidence.h"
#import "UIImage+FixOrientation.h"

@implementation OMBResidenceUploadImageConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object 
residenceImage: (OMBResidenceImage *) image;
{
  if (!(self = [super init])) return nil;

  residenceImage = image;

  NSString *resource = @"places";
  if ([object isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";
  NSString *string = [NSString stringWithFormat: @"%@/%@/%i/upload_image",
    OnMyBlockAPIURL, resource, object.uid];

  [Base64 initialize];
  NSData *imageData = UIImagePNGRepresentation(
    [residenceImage.image fixOrientation]);

  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"image_data":   [Base64 encode: imageData],
    @"position":     [NSNumber numberWithInt: residenceImage.position]
  };

  [self setPostRequestWithString: string withParameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  residenceImage.absoluteString = 
    [[json objectForKey: @"object"] objectForKey: @"image"];
  residenceImage.uid = 
    [[[json objectForKey: @"object"] objectForKey: @"id"] intValue];

  NSLog(@"OMBResidenceUploadImageConnection");
  NSLog(@"%@", json);

  [super connectionDidFinishLoading: connection];
}

@end
