//
//  OMBPaymentMethodVenmoViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodVenmoViewController.h"

@implementation OMBPayoutMethodVenmoViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Payout Method Venmo";
  self.title      = @"Payout";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.nameLabel.text = @"Venmo";
  self.nameLabel.textColor = [UIColor venmoBlue];

  self.detailLabel1.text = @"Venmo is an online processing service";
  self.detailLabel2.text = @"that allows you to pay and receive";
  self.detailLabel3.text = @"payments from OnMyBlock.";

  self.connectButton.backgroundColor = [UIColor venmoBlue];
  [self.connectButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor venmoBlueDark]]
      forState: UIControlStateHighlighted];
  [self.connectButton setTitle: @"I have a Venmo account"
    forState: UIControlStateNormal];
  [self.signUpButton setTitle: @"Sign up for Venmo"
    forState: UIControlStateNormal];
}

@end
