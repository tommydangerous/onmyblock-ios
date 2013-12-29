//
//  OMBActivityView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/16/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBActivityView : UIView
{
  UIActivityIndicatorView *activityIndicatorView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) startSpinning;
- (void) stopSpinning;

@end
