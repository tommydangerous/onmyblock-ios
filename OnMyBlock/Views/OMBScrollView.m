//
//  OMBScrollView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBScrollView.h"

@implementation OMBScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
    {
       UIView *view = [super hitTest:point withEvent:event];
       // Always return us.
       return view ;    
     }

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // We want EVERYTHING!
    return YES;
}


@end
