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

  [self setRequestFromString: string];
  
  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSString *originalString = [json objectForKey: @"image"];
  NSString *string         = [json objectForKey: @"image"];

  // If the cover photo URL is not empty.png
  if (json && [string rangeOfString: @"empty"].location == NSNotFound) {
    // If URL is something like this //ombrb-prod.s3.amazonaws.com
    if ([string hasPrefix: @"//"]) {
      string = [@"http:" stringByAppendingString: string];
    }
    else if (![string hasPrefix: @"http"]) {
      NSString *baseURLString = [[OnMyBlockAPIURL componentsSeparatedByString: 
        OnMyBlockAPI] objectAtIndex: 0];
      string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
    }
    residence.coverPhotoURL = [NSURL URLWithString: string];
    // Download the residence cover photo from the cover photo url
    OMBResidenceCoverPhotoDownloader *downloader = 
      [[OMBResidenceCoverPhotoDownloader alloc] initWithResidence:
        residence];
    downloader.completionBlock = ^(NSError *error) {
      [super connectionDidFinishLoading: connection];
    };

    int position = 1;
    if ([json objectForKey: @"position"] != [NSNull null])
      position = [[json objectForKey: @"position"] intValue];
    
    downloader.originalString = originalString;
    downloader.position       = position;
    downloader.residenceImageUID = [[json objectForKey: @"id"] intValue];
    [downloader startDownload];
  }
  // If residence is not a temporary residence
  else if (![residence isKindOfClass: [OMBTemporaryResidence class]]) {
    // If the residence has no image, show the Google Static street view
    OMBResidenceGoogleStaticImageDownloader *downloader =
      [[OMBResidenceGoogleStaticImageDownloader alloc] initWithResidence:
        residence url: [residence googleStaticStreetViewImageURL]];
    downloader.completionBlock = ^(NSError *error) {
      [super connectionDidFinishLoading: connection];
    };
    [downloader startDownload];
  }
}

@end
