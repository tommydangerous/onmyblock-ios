//
//  OMBManageListingDetailStatusCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBLabelSwitchCell.h"

@class OMBSwitch;

@interface OMBManageListingDetailStatusCell : OMBLabelSwitchCell
{
  OMBSwitch *customSwitch;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setImage: (UIImage *) image;
- (void) setSwitchTintColor:(UIColor *)onTintColor
           withOffColor:(UIColor *)offTintColor
             withOnText:(NSString *)onText andOffText:(NSString *)offText;
@end
