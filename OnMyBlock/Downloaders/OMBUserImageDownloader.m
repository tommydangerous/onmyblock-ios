//
//  OMBUserImageDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBUserImageDownloader.h"

#import "OMBUser.h"

@implementation OMBUserImageDownloader

@synthesize user = _user;

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  _user         = object;
  self.imageURL = _user.imageURL;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // OMBUser readFromDictionary: also sets the default image
  
  UIImage *image = [[UIImage alloc] initWithData: activeDownload];
  if (image) {
    _user.hasDefaultImage = NO;
  }
  else {
    _user.hasDefaultImage = YES;
    image = [UIImage imageNamed: @"profile_default_pic.png"];
  }
  _user.image = image;

  // NSLog(@"OMBUserImageDownloader\n%@", self.imageURL);
  
  [super connectionDidFinishLoading: connection];
}

@end
