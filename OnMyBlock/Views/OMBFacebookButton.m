//
//  OMBFacebookButton.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFacebookButton.h"

@implementation OMBFacebookButton

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.backgroundColor = [UIColor facebookBlue];

  [self setBackgroundImage: [UIImage imageWithColor: [UIColor facebookBlueDark]]
    forState: UIControlStateHighlighted];
  [self setImage: [UIImage imageNamed: @"facebook_icon.png"]];


  return self;
}

@end
