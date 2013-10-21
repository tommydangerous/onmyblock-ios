//
//  OMBViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "UIColor+Extensions.h"

@implementation OMBViewController

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) setTitle: (NSString *) string
{
  [super setTitle: string];
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.font            = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 20];
  label.frame           = CGRectMake(0, 0, 0, 44);
  label.shadowColor     = [UIColor clearColor];
  label.shadowOffset    = CGSizeMake(0, 0);
  label.text            = string;
  label.textAlignment   = NSTextAlignmentCenter;
  label.textColor       = [UIColor textColor];
  [label sizeToFit];
  self.navigationItem.titleView = label;
}

@end
