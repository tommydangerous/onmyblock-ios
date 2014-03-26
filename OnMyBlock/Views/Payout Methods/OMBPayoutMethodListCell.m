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

  // self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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
    [self setUpForPaypal: object primary: object.primary];
  }
  else if ([payoutType isEqualToString: @"venmo"]) {
    [self setUpForVenmo: object primary: object.primary];
  }
  else if ([payoutType isEqualToString: @"credit_card"]) {
    [self setUpForCreditCard: object primary: object.primary];
  }

  middleLabel.text = [object.email lowercaseString];
}

- (void) setUpForPaypal: (OMBPayoutMethod *) object primary: (BOOL) primary
{
  topLabel.text = @"PayPal";
  if (primary) {
    imageHolder.backgroundColor = [UIColor paypalBlue];
  }
  else {
    imageHolder.backgroundColor = [UIColor grayMedium];
  }
  objectImageView.image = [UIImage imageNamed: @"paypal_icon.png"];
  // [self setUpTypeAndPrimary: object];
  if (object.primary)
    self.accessoryType = UITableViewCellAccessoryCheckmark;
  else
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void) setUpForVenmo: (OMBPayoutMethod *) object primary: (BOOL) primary
{
  topLabel.text = @"Venmo";
  if (primary) {
    imageHolder.backgroundColor = [UIColor venmoBlue];
  }
  else {
    imageHolder.backgroundColor = [UIColor grayMedium];
  }
  objectImageView.image = [UIImage imageNamed: @"venmo_icon.png"];
  // [self setUpTypeAndPrimary: object];
  if (object.primary)
    self.accessoryType = UITableViewCellAccessoryCheckmark;
  else
    self.accessoryType = UITableViewCellAccessoryNone;
}


- (void) setUpForCreditCard: (OMBPayoutMethod *) object primary: (BOOL) primary
{
  topLabel.text = @"Credit Card";
  if (primary) {
    imageHolder.backgroundColor = [UIColor whiteColor];
  }
  else {
    imageHolder.backgroundColor = [UIColor grayLight];
  }
  objectImageView.image = [UIImage imageNamed: @"credit_card_icon.png"];
  
  if (object.primary)
    self.accessoryType = UITableViewCellAccessoryCheckmark;
  else
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void) setUpTypeAndPrimary: (OMBPayoutMethod *) object
{
  NSString *string;
  if (object.deposit) {
    string = @"   Deposit";
  }
  else {
    string = @"   Payment";
  }
  UIColor *color;
  if (object.primary) {
    string = [string stringByAppendingString: @" - Primary"];
    color = [UIColor textColor];
    middleLabel.textColor = [UIColor textColor];
  }
  else {
    color = [UIColor grayMedium];
    middleLabel.textColor = [UIColor grayMedium];
  }
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.maximumLineHeight = style.minimumLineHeight = 15.0f;
  NSMutableAttributedString *string1 = 
    [[NSMutableAttributedString alloc] initWithString: topLabel.text 
      attributes: @{
        NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" 
          size: 15],
        NSForegroundColorAttributeName: color
      }
    ];
  NSMutableAttributedString *string2 = 
    [[NSMutableAttributedString alloc] initWithString: string 
      attributes: @{
        NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" 
          size: 13],
        NSForegroundColorAttributeName: [UIColor grayMedium],
        NSParagraphStyleAttributeName: style
      }
    ];
  [string1 appendAttributedString: string2];
  topLabel.attributedText = string1;
}

@end
