//
//  OMBPayoutMethodCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodListCell.h"

#import "OMBPayoutMethod.h"

@implementation OMBPayoutMethodListCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  imageHolder = [UIView new];
  imageHolder.frame = objectImageView.frame;
  imageHolder.layer.cornerRadius = 5.0f;
  [self.contentView addSubview: imageHolder];

  // Image
  CGFloat padding = 5.0f;
  objectImageView.frame = CGRectMake(padding, padding, 
    imageHolder.frame.size.width - (padding * 2),
      imageHolder.frame.size.height - (padding * 2));
  objectImageView.layer.cornerRadius = 0.0f;
  [objectImageView removeFromSuperview];
  [imageHolder addSubview: objectImageView];

  // Top label

  // Middle label

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadPayoutMethod: (OMBPayoutMethod *) object
{
  // PayPal, Venmo
  NSString *payoutType = [object.payoutType lowercaseString];
  if ([payoutType isEqualToString: @"paypal"]) {
    [self setUpForPaypalPrimary: object.primary];
  }
  else if ([payoutType isEqualToString: @"venmo"]) {
    [self setUpForVenmoPrimary: object.primary];
  }

  // Middle label
  NSString *string;
  if (object.deposit) {
    string = @"Deposit method";
  }
  else {
    string = @"Payment method";
  }
  if (object.primary) {
    middleLabel.textColor = [UIColor textColor];
    string = [string stringByAppendingString: @" - Primary"];
    topLabel.textColor = [UIColor textColor];
  }
  else {
    middleLabel.textColor = [UIColor grayMedium];
    topLabel.textColor = [UIColor grayMedium];
  }
  middleLabel.text = string;
}

- (void) setUpForPaypalPrimary: (BOOL) primary
{
  topLabel.text = @"PayPal";
  if (primary) {
    imageHolder.backgroundColor = [UIColor paypalBlue];
  }
  else {
    imageHolder.backgroundColor = [UIColor grayMedium];
  }
  objectImageView.image = [UIImage imageNamed: @"paypal_icon.png"];
}

- (void) setUpForVenmoPrimary: (BOOL) primary
{
  topLabel.text = @"Venmo";
  if (primary) {
    imageHolder.backgroundColor = [UIColor venmoBlue];
  }
  else {
    imageHolder.backgroundColor = [UIColor grayMedium];
  }
  objectImageView.image = [UIImage imageNamed: @"venmo_icon.png"];
}

@end
