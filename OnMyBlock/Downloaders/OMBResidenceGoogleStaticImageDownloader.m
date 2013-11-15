//
//  OMBResidenceGoogleStaticImageDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/13/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceGoogleStaticImageDownloader.h"

#import "OMBResidence.h"

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
  if (image)
    [residence.images setObject: image forKey: @"1"];
  [super connectionDidFinishLoading: connection];
}

@end
