//
//  OMBResidenceCoverPhotoDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCoverPhotoDownloader.h"

#import "OMBResidence.h"

@implementation OMBResidenceCoverPhotoDownloader

@synthesize position  = _position;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  self = [super init];
  if (self) {
    _residence = object;
    imageURL   = _residence.coverPhotoURL;
  }
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
