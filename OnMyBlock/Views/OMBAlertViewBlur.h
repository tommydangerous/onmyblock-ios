//
//  OMBAlertViewBlur.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@class OMBActivityView;
@class OMBBlurView;
@class OMBCloseButtonView;

@interface OMBAlertViewBlur : OMBView
{
  OMBActivityView *activityView;
  UIView *alertView;
  UIView *buttonView;
  UIButton *cancelButton;
  UIButton *closeButton;
  OMBCloseButtonView *closeButtonView;
  UIButton *confirmButton;
  BOOL isShowingQuestionDetails;
  UILabel *messageLabel;
  UIView *middleBorder;
  UIButton *questionButton;
  UILabel *questionDetailsLabel;
  UIView *questionDetailsView;
  UILabel *titleLabel;
}

@property (nonatomic, strong) OMBBlurView *backgroundBlurView;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *elasticityBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addTargetForCancelButton: (id) target action: (SEL) action;
- (void) addTargetForConfirmButton: (id) target action: (SEL) action;
- (void) animateChangeOfContent;
- (void) close;
- (void) hideCloseButton;
- (void) hideQuestionButton;
- (void) resetQuestionDetails;
- (void) setCancelButtonTitle: (NSString *) string;
- (void) setConfirmButtonTitle: (NSString *) string;
- (void) setQuestionDetails: (NSString *) string;
- (void) setMessage: (NSString *) string;
- (void) setTitle: (NSString *) string;
- (void) showBothButtons;
- (void) showInView: (UIView *) view;
- (void) showCloseButton;
- (void) showOnlyConfirmButton;
- (void) startSpinning;
- (void) stopSpinning;

@end
