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

@synthesize originalString = _originalString;
@synthesize position       = _position;
@synthesize residence      = _residence;

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
  // If image was downloaded and the position is not the first (cover photo)
  if (image) {

    // if (_position == 1) {
    //   // Sometimes it is adding the cover photo image again
    // }
    // If image at position already exists
    // else if ([_residence.images objectForKey: 
    //   [NSString stringWithFormat: @"%i", _position]]) {
    //
    //   _residence.lastImagePosition += 1;
    //   _position = _residence.lastImagePosition;
    // }
    // [_residence.images setObject: image
    //   forKey: [NSString stringWithFormat: @"%i", _position]];

    [_residence addImage: image atPosition: _position 
      withString: _originalString];
  }
  [super connectionDidFinishLoading: connection];
}

@end
