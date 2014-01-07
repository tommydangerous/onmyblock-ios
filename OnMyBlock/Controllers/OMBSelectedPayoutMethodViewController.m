//
//  OMBSelectedPaymentMethodViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSelectedPayoutMethodViewController.h"

@implementation OMBSelectedPayoutMethodViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Selected Payout Method";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  float screenHeight = screen.size.height - (20.0f + 44.0f);
  float screenWidth  = screen.size.width;
  float padding      = 20.0f;

  detailLabelView = [[UIView alloc] init];
  [self.view addSubview: detailLabelView];

  _detailLabel1 = [[UILabel alloc] init];
  _detailLabel2 = [[UILabel alloc] init];
  _detailLabel3 = [[UILabel alloc] init];
  NSArray *detailLabelArray = @[_detailLabel1, _detailLabel2, _detailLabel3];
  for (UILabel *label in detailLabelArray) {
    label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    if ([detailLabelArray indexOfObject: label] == 0) {
      label.frame = CGRectMake(padding, 0.0f,
        screenWidth - (padding * 2), 22.0f);
    }
    else {
      UILabel *prev = [detailLabelArray objectAtIndex: 
        [detailLabelArray indexOfObject: label] - 1];
      CGRect rect = prev.frame;
      label.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height,
        rect.size.width, rect.size.height);
    }
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayMedium];
    [detailLabelView addSubview: label];
  }
  float detailLabelViewHeight = 
    _detailLabel1.frame.size.height * [detailLabelArray count];
  detailLabelView.frame = CGRectMake(0, 
    (screenHeight - detailLabelViewHeight) * 0.5f, 
      screenWidth, detailLabelViewHeight);

  _nameLabel = [[UILabel alloc] init];
  _nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36];
  _nameLabel.frame = CGRectMake(padding, 
    detailLabelView.frame.origin.y - (54.0f + (padding * 2)), 
      screenWidth - (padding * 2), 54.0f);
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview: _nameLabel];

  _connectButton = [[UIButton alloc] init];
  _connectButton.clipsToBounds = YES;
  _connectButton.frame = CGRectMake(padding,
    detailLabelView.frame.origin.y + 
    detailLabelView.frame.size.height + (padding * 2),
      _nameLabel.frame.size.width, padding + 18.0f + padding);
  _connectButton.layer.cornerRadius = 2.0f;
  _connectButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 18];
  [_connectButton addTarget: self action: @selector(connectButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [_connectButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self.view addSubview: _connectButton];

  _signUpButton = [[UIButton alloc] init];
  _signUpButton.backgroundColor = [UIColor grayMedium];
  _signUpButton.clipsToBounds = _connectButton.clipsToBounds;
  _signUpButton.frame = CGRectMake(_connectButton.frame.origin.x,
    _connectButton.frame.origin.y + _connectButton.frame.size.height + padding,
      _connectButton.frame.size.width, _connectButton.frame.size.height);
  _signUpButton.layer.cornerRadius = _connectButton.layer.cornerRadius;
  _signUpButton.titleLabel.font = _connectButton.titleLabel.font;
  [_signUpButton addTarget: self action: @selector(signUpButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [_signUpButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor colorWithWhite: (120/255.0) alpha: 1.0f]] 
      forState: UIControlStateHighlighted];
  [_signUpButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self.view addSubview: _signUpButton];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) connectButtonSelected
{
  // Subclasses implement this
}

- (void) signUpButtonSelected
{
  // Subclasses implement this
}

@end
