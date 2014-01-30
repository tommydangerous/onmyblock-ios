//
//  OMBLinkedInButton.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBLinkedInButton.h"

@implementation OMBLinkedInButton

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  self.backgroundColor = [UIColor linkedinGray];

  [self setBackgroundImage: [UIImage imageWithColor: [UIColor grayVeryLight]]
    forState: UIControlStateHighlighted];
  [self setImage: [UIImage imageNamed: @"linkedin_icon.png"]];


  return self;
}

@end
