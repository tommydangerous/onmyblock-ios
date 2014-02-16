//
//  OMBActivityViewFullScreen.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@class OMBActivityView;

@interface OMBActivityViewFullScreen : OMBView
{
  OMBActivityView *activityView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) startSpinning;
- (void) stopSpinning;

@end
