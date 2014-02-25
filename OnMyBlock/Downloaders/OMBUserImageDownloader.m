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
  UIImage *image = [[UIImage alloc] initWithData: activeDownload];
  if (image) {
    _user.image = image;
  }
  else {
    _user.image = [UIImage imageNamed: @"profile_default_pic.png"];
  }

  // NSLog(@"OMBUserImageDownloader\n%@", self.imageURL);
  
  [super connectionDidFinishLoading: connection];
}

@end
