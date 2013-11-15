//
//  OMBPropertyInfoView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPropertyInfoView.h"

#import "OMBResidencePartialView.h"

@implementation OMBPropertyInfoView

@synthesize imageView = _imageView;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  residencePartialView = [[OMBResidencePartialView alloc] init];
  _imageView = residencePartialView.imageView;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.frame = CGRectMake(residencePartialView.frame.origin.x,
    screen.size.height, residencePartialView.frame.size.width,
      residencePartialView.frame.size.height);
  [self addSubview: residencePartialView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  _residence = object;
  [residencePartialView loadResidenceData: _residence];
}

@end
