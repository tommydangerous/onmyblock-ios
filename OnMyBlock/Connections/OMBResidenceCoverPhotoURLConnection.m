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

@implementation OMBResidenceCoverPhotoURLConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  self = [super init];
  if (self) {
    residence = object;
    // http://localhost:3000/places/141/cover_photo_url.json
    NSString *string = [NSString stringWithFormat:
      @"%@/places/%i/cover_photo_url.json", OnMyBlockAPIURL, residence.uid];
    [self setRequestFromString: string];
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSString *string = [json objectForKey: @"image"];
  // If the cover photo URL is not empty.png
  if ([string rangeOfString: @"empty"].location == NSNotFound) {
    if (![string hasPrefix: @"http"])
      string = [NSString stringWithFormat: @"%@%@", OnMyBlockAPIURL, string];
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
    downloader.position = position;
    [downloader startDownload];
  }
  else {
    [residence.images setObject:
      [UIImage imageNamed: @"placeholder_property.png"] forKey: @"1"];
    [super connectionDidFinishLoading: connection];
  }
}

@end
