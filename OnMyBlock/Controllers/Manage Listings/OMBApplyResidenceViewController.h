//
//  OMBApplyResidenceViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterProfileViewController.h"

@class LEffectLabel;
@class OMBActivityViewFullScreen;
@class OMBAlertViewBlur;
@class OMBCenteredImageView;
@class OMBResidence;

@interface OMBApplyResidenceViewController : OMBMyRenterProfileViewController

@property int nextSection;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
