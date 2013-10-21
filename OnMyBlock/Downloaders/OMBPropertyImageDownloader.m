//
//  OMBPropertyImageDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertyImageDownloader.h"

#import "OMBProperty.h"

@implementation OMBPropertyImageDownloader

@synthesize property = _property;

#pragma mark - Initializer

- (id) initWithProperty: (OMBProperty *) object
{
  self = [super init];
  if (self) {
    _property = object;
    imageURL  = [_property imageURL];
  }
  return self;
}

#pragma mark - Protocol

#pragma mark Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  _property.image = [[UIImage alloc] initWithData: activeDownload];
  [super connectionDidFinishLoading: connection];
}

@end
