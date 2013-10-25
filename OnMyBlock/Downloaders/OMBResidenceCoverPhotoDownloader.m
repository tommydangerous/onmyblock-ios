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

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.imageURL = self.residence.coverPhotoURL;

  return self;
}

@end
