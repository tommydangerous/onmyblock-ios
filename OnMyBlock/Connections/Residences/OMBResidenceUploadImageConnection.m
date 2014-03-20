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
#import "UIImage+Resize.h"

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
  // NSData *imageData = UIImagePNGRepresentation(
  //   [residenceImage.image fixOrientation]);
  NSData *imageData = [UIImage compressImage: 
    [residenceImage.image fixOrientation] withMinimumResolution: 0];

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
  residenceImage.imageURL =
    [[json objectForKey: @"object"] objectForKey: @"image"];
  
  NSString *originalString = [[json objectForKey: @"object"] objectForKey: @"image"];
  NSString *string         = [[json objectForKey: @"object"] objectForKey: @"image"];
  
  // If URL is something like this //ombrb-prod.s3.amazonaws.com
  if ([string hasPrefix: @"//"]) {
    string = [@"http:" stringByAppendingString: string];
  }
  else if (![string hasPrefix: @"http"]) {
    NSString *baseURLString =
    [[OnMyBlockAPIURL componentsSeparatedByString:
      OnMyBlockAPI] objectAtIndex: 0];
    string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
  }
  residenceImage.absoluteString = originalString;
  residenceImage.imageURL = [NSURL URLWithString:string];
  
  residenceImage.uid =
    [[[json objectForKey: @"object"] objectForKey: @"id"] intValue];

  NSLog(@"OMBResidenceUploadImageConnection");
  NSLog(@"%@", json);

  [super connectionDidFinishLoading: connection];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) start
{
  [self startWithTimeoutInterval: 120 onMainRunLoop: NO];
}

@end
