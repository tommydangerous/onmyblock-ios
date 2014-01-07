//
//  OMBPaymentMethodsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodsViewController.h"

#import "OMBSelectPayoutMethodViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBPayoutMethodsViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Payout Methods";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth = screen.size.width;

  noPayoutMethodsView = [[UIView alloc] init];
  noPayoutMethodsView.frame = CGRectMake(0.0f, 0.0f, screenWidth,
    screenHeight);
  [self.view addSubview: noPayoutMethodsView];

  float padding = 20.0f;

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  label2.frame = CGRectMake(padding, 
    (screenHeight - (22.0f * 3)) * 0.5, 
      screenWidth - (padding * 2), 22.0f * 3);
  label2.numberOfLines = 0;
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = 22.0f;
  style.minimumLineHeight = 22.0f;
  NSString *text = @"Your payout method is how you pay or receive money. "
    @"Funds are transferred within 24 hours after offers are accepted.";
  NSMutableAttributedString *aString = 
    [[NSMutableAttributedString alloc] initWithString: text attributes: @{
      NSParagraphStyleAttributeName: style
    }
  ];
  label2.attributedText = aString;
  label2.textAlignment = NSTextAlignmentCenter;
  label2.textColor = [UIColor grayMedium];
  [noPayoutMethodsView addSubview: label2];

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 27];
  label1.frame = CGRectMake(padding, 
    label2.frame.origin.y - ((padding * 2) + (33.0f * 2)), 
      screenWidth - (padding * 2), 33.0f * 2);
  label1.numberOfLines = 0;
  label1.text = @"Set up your\n"
    @"payout methods.";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor blue];
  [noPayoutMethodsView addSubview: label1];

  UIButton *selectPayoutMethodButton = [[UIButton alloc] init];
  selectPayoutMethodButton.clipsToBounds = YES;
  selectPayoutMethodButton.frame = CGRectMake(label2.frame.origin.x,
    label2.frame.origin.y + label2.frame.size.height + (padding * 2),
      label2.frame.size.width, padding + 18.0f + padding);
  selectPayoutMethodButton.layer.cornerRadius = 2.0f;
  selectPayoutMethodButton.titleLabel.font = [UIFont fontWithName: 
    @"HelveticaNeue-Light" size: 18];
  [selectPayoutMethodButton addTarget: self 
    action: @selector(selectPayoutMethod) 
      forControlEvents: UIControlEventTouchUpInside];
  [selectPayoutMethodButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blue]] forState: UIControlStateNormal];
  [selectPayoutMethodButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueDark]] 
      forState: UIControlStateHighlighted];
  [selectPayoutMethodButton setTitle: @"Select Payout Method"
    forState: UIControlStateNormal];
  [selectPayoutMethodButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [noPayoutMethodsView addSubview: selectPayoutMethodButton];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) selectPayoutMethod
{
  [self.navigationController pushViewController:
    [[OMBSelectPayoutMethodViewController alloc] init] animated: YES];
}

@end
