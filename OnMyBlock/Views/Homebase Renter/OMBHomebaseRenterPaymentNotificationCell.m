//
//  OMBHomebaseRenterPaymentNotificationCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterPaymentNotificationCell.h"

#import "OMBUser.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

@implementation OMBHomebaseRenterPaymentNotificationCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGFloat padding = 20.0f;

  topLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  bottomLabel.hidden = YES;

  _responseButton = [UIButton new];
  _responseButton.clipsToBounds = YES;
  _responseButton.frame = CGRectMake(topLabel.frame.origin.x, 
    middleLabel.frame.origin.y + middleLabel.frame.size.height + padding,
      topLabel.frame.size.width * 0.5f, 10 + 15.0f + 10);
  _responseButton.layer.borderColor = [UIColor blue].CGColor;
  _responseButton.layer.borderWidth = 1.0f;
  _responseButton.layer.cornerRadius = 5.0f;
  _responseButton.titleLabel.font = topLabel.font;
  [_responseButton setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
    forState: UIControlStateHighlighted];
  [_responseButton setTitleColor: [UIColor blue] 
    forState: UIControlStateNormal];
  [_responseButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [self.contentView addSubview: _responseButton];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 22.0f + 22.0f + padding + (10 + 15.0f + 10) + padding;
}

#pragma mark - Instance Methods

- (void) loadData
{
  CGFloat imageSize = objectImageView.frame.size.width;
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    imageSize, imageSize];
  objectImageView.image = [[OMBUser fakeUser] imageForSizeKey: sizeKey];
}

- (void) setupForRoommate
{
  topLabel.text    = @"George owes $550 for rent.";
  middleLabel.text = @"Due 9/21/14 in 3 days";
  _responseButton.tag = 1;
  [_responseButton setTitle: @"Remind" forState: UIControlStateNormal];
}

- (void) setupForSelf
{
  topLabel.text    = @"You owe $650 for rent.";
  middleLabel.text = @"Due 9/21/14 in 3 days";
  _responseButton.tag = 0;
  [_responseButton setTitle: @"Pay" forState: UIControlStateNormal];
}

@end
