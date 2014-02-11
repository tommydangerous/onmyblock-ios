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

@synthesize residence = _residence;
@synthesize residencePartialView = _residencePartialView;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

	
  _residencePartialView = [[OMBResidencePartialView alloc] init];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.frame = CGRectMake(_residencePartialView.frame.origin.x,
    screen.size.height, _residencePartialView.frame.size.width,
      _residencePartialView.frame.size.height);
	
	
  [self addSubview: _residencePartialView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  _residence = object;
  [_residencePartialView loadResidenceData: _residence];
  [_residencePartialView downloadResidenceImages];
}

@end
