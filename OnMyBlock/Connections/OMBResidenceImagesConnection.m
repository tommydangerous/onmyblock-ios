//
//  OMBResidenceImagesConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImagesConnection.h"

#import "OMBResidence.h"
#import "OMBResidenceImageDownloader.h"

@implementation OMBResidenceImagesConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  // http://localhost:3000/places/135/show_images.json
  NSString *string = [NSString stringWithFormat:
    @"%@/places/%i/show_images.json", OnMyBlockAPIURL, residence.uid];
  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSArray *array = (NSArray *) [json objectForKey: @"images"];
  for (NSString *jsonString in array) {
    NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data
      options: 0 error: nil];
    NSString *string = [dict objectForKey: @"image"];
    int position     = [[dict objectForKey: @"position"] intValue];
    if (![string hasPrefix: @"http"])
      string = [NSString stringWithFormat: @"%@%@", OnMyBlockAPIURL, string];
    // Download the image
    OMBResidenceImageDownloader *downloader = 
     [[OMBResidenceImageDownloader alloc] initWithResidence: residence];
    downloader.imageURL = [NSURL URLWithString: string];

    NSLog(@"%i: %@", position, string);
  }
  [super connectionDidFinishLoading: connection];
}

@end
