//
//  OMBExtendedHitAreaViewContainer.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/4/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBExtendedHitAreaViewContainer.h"

@implementation OMBExtendedHitAreaViewContainer

#pragma mark - Override

#pragma mark - Override UIView

- (UIView *) hitTest: (CGPoint) point withEvent: (UIEvent *) event
{
  UIView *child = nil;
  if ((child = [super hitTest: point withEvent: event]) == self)
    return _scrollView;
  return child;
}

@end
