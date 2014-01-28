//
//  OMBOrView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@interface OMBOrView : OMBView
{
  UILabel *orLabel;
}

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect color: (UIColor *) color;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setLabelBold: (BOOL) bold;

@end
