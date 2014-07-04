//
//  OMBResidenceCoverPhotoURLConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCoverPhotoURLConnection.h"

#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoDownloader.h"
#import "OMBResidenceGoogleStaticImageDownloader.h"
#import "OMBTemporaryResidence.h"
#import "OMBResidenceImage.h"

@implementation OMBResidenceCoverPhotoURLConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  
  NSString *resource = @"places";
  if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
    resource = @"temporary_residences";
  }
  NSString *string = [NSString stringWithFormat:
    @"%@/%@/%i/cover_photo_url/?access_token=%@", 
      OnMyBlockAPIURL, resource, residence.uid, 
        [OMBUser currentUser].accessToken];

  [self setRequestWithString: string];
  
  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json       = [self json];
  NSString *originalString = [json objectForKey: @"image"];
  NSString *string         = [json objectForKey: @"image"];

  OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];

  // If the cover photo URL is not empty.png
  if (json && 
    [string rangeOfString: @"empty"].location == NSNotFound &&
    [string rangeOfString: @"default_residence_image" ].location == NSNotFound) {
    // If URL is something like this //ombrb-prod.s3.amazonaws.com
    if ([string hasPrefix: @"//"]) {
      string = [@"http:" stringByAppendingString: string];
    }
    else if (![string hasPrefix: @"http"]) {
      NSString *baseURLString = [[OnMyBlockAPIURL componentsSeparatedByString: 
        OnMyBlockAPI] objectAtIndex: 0];
      string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
    }
    NSUInteger position = 1;
    id postionValue = [json objectForKey: @"position"];
    if (postionValue != [NSNull null]) {
      position = [postionValue intValue];
    }
    residenceImage.absoluteString = originalString;
    residenceImage.imageURL       = [NSURL URLWithString: string];
    residenceImage.position       = position;
    residenceImage.uid            = [[json objectForKey: @"id"] intValue];
  }
  // If there is a valid image URL
  if (residenceImage.imageURL) {
    residence.coverPhotoURL = residenceImage.imageURL;
    [residence addResidenceImage: residenceImage];
    [super connectionDidFinishLoading: connection];
  }
  else {
    residence.hasNoImage = YES;
  }
}

#pragma mark - Override

#pragma mark - OMBConnection

- (void) cancelConnection
{
  [super cancelConnection];
  if (coverPhotoDownloader) {
    [coverPhotoDownloader cancelDownload];
  }
}

@end
