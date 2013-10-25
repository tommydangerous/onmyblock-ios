//
//  OMBResidenceImageDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImageDownloader.h"

#import "OMBResidence.h"

@implementation OMBResidenceImageDownloader

@synthesize position  = _position;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  _residence = object;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  UIImage *image = [[UIImage alloc] initWithData: activeDownload];
  if (image)
    [_residence.images setObject: image
      forKey: [NSString stringWithFormat: @"%i", _position]];
  [super connectionDidFinishLoading: connection];
}

@end
