//
//  OMBApplyRenterApplicationViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 5/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBApplyRenterApplicationViewController.h"

#import "AMBlurView.h"
#import "LEffectLabel.h"
#import "OMBAlertViewBlur.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBApplyRenterApplicationViewController

#pragma mark - Initializer

- (id)init
{
  if (!(self = [super init])) return nil;
  
  self.title = @"My Application";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void)loadView
{
  [super loadView];
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth = screen.size.width;
  
  CGFloat submitHeight = OMBStandardHeight;
  submitHeight = OMBStandardButtonHeight;
  // Table footer view
  UIView *footerView = [[UIView alloc] init];
  footerView.frame = CGRectMake(0.0f, 0.0f, screenWidth, submitHeight);
  self.table.tableFooterView = footerView;
  
  // Submit offer view
  AMBlurView *submitView = [[AMBlurView alloc] init];
  submitView.blurTintColor = [UIColor blue];
  submitView.frame = CGRectMake(0.0f, screenHeight - submitHeight,
    screenWidth, submitHeight);
  [self.view addSubview: submitView];
  
  submitOfferButton = [UIButton new];
  submitOfferButton.frame = submitView.bounds;
  [submitOfferButton addTarget: self
    action: @selector(submitApplication)
      forControlEvents: UIControlEventTouchUpInside];
  [submitOfferButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlightedAlpha: 0.3f]]
      forState: UIControlStateHighlighted];
  [submitView addSubview: submitOfferButton];
  
  // Effect label
  effectLabel = [[LEffectLabel alloc] init];
  effectLabel.effectColor = [UIColor grayMedium];
  effectLabel.effectDirection = EffectDirectionLeftToRight;
  effectLabel.font = [UIFont mediumTextFontBold];
  effectLabel.frame = submitOfferButton.frame;
  effectLabel.sizeToFit = NO;
  effectLabel.text = @"Submit Application";
  effectLabel.textColor = [UIColor whiteColor];
  effectLabel.textAlignment = NSTextAlignmentCenter;
  [submitView insertSubview: effectLabel
    belowSubview: submitOfferButton];
  
  alertBlur = [[OMBAlertViewBlur alloc] init];

}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [effectLabel performEffectAnimation];

}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) closeAlertBlur
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertBlur.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished) {
      [self.navigationController popViewControllerAnimated: YES];
      [alertBlur close];
    }
  }];
}

- (void)showRenterHomebase
{
  [self closeAlertBlur];
}

- (void)submitApplication
{
  
  [alertBlur setTitle: @"Application Submitted!"];
  [alertBlur setMessage: @"The landlord will review your application and make a decision. "
    @"If you have applied with co-applicants make sure they have "
    @"completed applications as well. Feel free to message the "
    @"landlord for more information about the property "
    @"or to schedule a viewing."];
  [alertBlur setConfirmButtonTitle: @"Okay"];
  [alertBlur addTargetForConfirmButton: self
    action: @selector(showRenterHomebase)];
  [alertBlur addTargetForCancelButton: self
    action: @selector(submitCanceled)];
  [alertBlur showInView: self.view withDetails: NO];
  [alertBlur showBothButtons];
  [alertBlur hideQuestionButton];
  
}

- (void)submitCanceled
{
  [alertBlur close];
}

@end
