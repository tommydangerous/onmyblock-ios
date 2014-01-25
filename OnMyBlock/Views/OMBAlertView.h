//
//  OMBAlertView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMBlurView;

@interface OMBAlertView : UIView
{
  AMBlurView *alert;
  UIView *alertButtonsView;
  UIView *alertButtonsViewMiddleBorder;
  UIView *fadedBackground;
}

@property (nonatomic, strong) UIButton *alertCancel;
@property (nonatomic, strong) UIButton *alertConfirm;
@property (nonatomic, strong) UILabel *alertMessage;
@property (nonatomic, strong) UILabel *alertTitle;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *elasticityBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addTarget: (id) target action: (SEL) action 
forButton: (UIButton *) button;
- (void) animateChangeOfContent;
- (void) hideAlert;
- (void) onlyShowOneButton: (UIButton *) button;
- (void) showAlert;
- (void) showBothButtons;

@end
