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
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSString *originalString = [json objectForKey: @"image"];
  NSString *string         = [json objectForKey: @"image"];

    OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];

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
//    // Download the residence cover photo from the cover photo url
//    coverPhotoDownloader = 
//      [[OMBResidenceCoverPhotoDownloader alloc] initWithResidence:
//        residence];
//    coverPhotoDownloader.completionBlock = ^(NSError *error) {
//      [super connectionDidFinishLoading: connection];
//    };
      NSString *postionValue = [json objectForKey: @"position"];
      int position = (id)postionValue != [NSNull null] ? [postionValue intValue] : 1;

      residenceImage.absoluteString = originalString;
      residenceImage.imageURL = residence.coverPhotoURL;
      residenceImage.position       = position;
      residenceImage.uid            = [[json objectForKey: @"id"] intValue];

  }
  // If residence is not a temporary residence
  else if (![residence isKindOfClass: [OMBTemporaryResidence class]]) {
      
      residenceImage.imageURL = [residence googleStaticStreetViewImageURL];
      residenceImage.absoluteString = residenceImage.imageURL.absoluteString;
      residenceImage.position = 0;
      residenceImage.uid      = -9999 + arc4random_uniform(1000);
      [residence addResidenceImage: residenceImage];
      
//    // If the residence has no image, show the Google Static street view
//     googleStaticImageDownloader =
//      [[OMBResidenceGoogleStaticImageDownloader alloc] initWithResidence:
//        residence url: [residence googleStaticStreetViewImageURL]];
//    googleStaticImageDownloader.completionBlock = ^(NSError *error) {
//      [super connectionDidFinishLoading: connection];
//    };
//    [googleStaticImageDownloader startDownload];
  }
    residence.coverPhotoURL = residenceImage.imageURL;
    [residence addResidenceImage:residenceImage];
    [super connectionDidFinishLoading:connection];
}

#pragma mark - Override

#pragma mark - OMBConnection

- (void) cancelConnection
{
  [super cancelConnection];
  if (coverPhotoDownloader)
    [coverPhotoDownloader cancelDownload];
  if (googleStaticImageDownloader)
    [googleStaticImageDownloader cancelDownload];
}

@end
