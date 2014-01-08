//
//  OMBOfferAcceptedView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBCenteredImageView;

@interface OMBOfferAcceptedView : UIView
{
  UIDynamicAnimator *animatorLeft;
  UIDynamicAnimator *animatorRight;
  UIButton *cancelButton;
  UIButton *confirmButton;
  UIView *fadedBackground;
  OMBCenteredImageView *leftImageView;
  UILabel *middleLabel;
  OMBCenteredImageView *rightImageView;
  UILabel *topLabel;
}

#pragma mark - Initializer

- (id) initWithOffer: (id) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) show;

@end
