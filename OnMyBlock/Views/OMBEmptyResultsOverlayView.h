//
//  OMBEmptyResultsOverlayView.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 10/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@interface OMBEmptyResultsOverlayView : OMBView
{
  UILabel *subtitleLabel;
  UILabel *titleLabel;
}

#pragma mark - Instance Methods

- (void)setTitle:(NSString *)title;

@end
