//
//  OMBApplyResidenceViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterProfileViewController.h"

@class OMBActivityViewFullScreen;
@class LEffectLabel;
@class OMBAlertViewBlur;
@class OMBCenteredImageView;

@interface OMBApplyResidenceViewController : OMBMyRenterProfileViewController

@property int nextSection;

#pragma mark - Initializer

- (id) initWithResidenceUID: (NSUInteger) uid;

@end
