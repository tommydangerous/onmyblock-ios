//
//  OMBResidenceImagesConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImagesConnection.h"

#import "OMBCenteredImageView.h"
#import "OMBResidenceGoogleStaticImageDownloader.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceGoogleStaticImageDownloader.h"
#import "OMBResidenceImageDownloader.h"
#import "OMBTemporaryResidence.h"
#import "UIImage+Resize.h"
#import "OMBResidenceImage.h"
@implementation OMBResidenceImagesConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  
  NSString *resource = @"places";
  if ([residence isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";

  NSString *string = [NSString stringWithFormat:
    @"%@/%@/%i/show_images/?access_token=%@", 
      OnMyBlockAPIURL, resource, residence.uid, 
        [OMBUser currentUser].accessToken];

  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSArray *array = (NSArray *) [[self json] objectForKey: @"images"];
  // Loop through the array full of image json
  for (NSString *jsonString in array) {
    // Download the image
    NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data
      options: 0 error: nil];
    NSString *originalString = [dict objectForKey: @"image"];
    NSString *string         = [dict objectForKey: @"image"];
    // Set the position of the image
    int position;
    if ([dict objectForKey: @"position"] == [NSNull null]) {
      residence.lastImagePosition += 1;
      position = residence.lastImagePosition;
    }
    else {
      position = [[dict objectForKey: @"position"] intValue];
    }
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
      OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];
      residenceImage.absoluteString = originalString;
      residenceImage.imageURL = [NSURL URLWithString:string];
      residenceImage.position       = position;
      residenceImage.uid            = [[dict objectForKey: @"id"] intValue];
      
      [residence addResidenceImage:residenceImage];
      
    // Download image
//    OMBResidenceImageDownloader *downloader = 
//      [[OMBResidenceImageDownloader alloc] initWithResidence: residence];
//    downloader.completionBlock = self.completionBlock;
//    downloader.imageURL       = [NSURL URLWithString: string];
//    downloader.originalString = originalString;
//    downloader.position       = position;
//    downloader.residenceImageUID = [[dict objectForKey: @"id"] intValue];
//    [downloader startDownload];
  }
  if ([array count] == 0) {
    // If the residence has no image, show the Google Static street view
    // OMBResidenceGoogleStaticImageDownloader *downloader =
    //   [[OMBResidenceGoogleStaticImageDownloader alloc] initWithResidence:
    //     residence url: [residence googleStaticStreetViewImageURL]];
    // downloader.completionBlock = ^(NSError *error) {
    //   [super connectionDidFinishLoading: connection];
    // };
    // [downloader startDownload];
  }
  else {
    self.completionBlock = nil;
  }
  [super connectionDidFinishLoading: connection];
}

@end
