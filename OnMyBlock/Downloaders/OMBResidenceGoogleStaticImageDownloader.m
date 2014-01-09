//
//  OMBResidenceGoogleStaticImageDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/13/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceGoogleStaticImageDownloader.h"

#import "OMBResidence.h"
#import "OMBResidenceImage.h"

@implementation OMBResidenceGoogleStaticImageDownloader

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object url: (NSURL *) url
{
  if (!(self = [super init])) return nil;

  residence     = object;
  self.imageURL = url;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  UIImage *image = [[UIImage alloc] initWithData: activeDownload];
  if (image) {
    OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];
    residenceImage.absoluteString = [self.imageURL absoluteString];
    residenceImage.image    = image;
    residenceImage.position = 0;
    residenceImage.uid      = -999 + arc4random_uniform(100);
  }
  [super connectionDidFinishLoading: connection];
}

@end
