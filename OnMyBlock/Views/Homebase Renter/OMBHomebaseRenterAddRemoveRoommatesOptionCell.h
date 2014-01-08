//
//  OMBHomebaseRenterAddRemoveRoommatesOptionCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageOneLabelCell.h"

@interface OMBHomebaseRenterAddRemoveRoommatesOptionCell : OMBImageOneLabelCell
{
  UIView *imageBackgroundView;
  UIImageView *backgroundImageView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setupForContacts;
- (void) setupForEmail;
- (void) setupForFacebook;
- (void) setupForOnMyBlock;

@end
