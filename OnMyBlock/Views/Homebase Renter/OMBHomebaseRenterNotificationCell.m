//
//  OMBHomebaseRenterNotificationCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterNotificationCell.h"

#import "OMBUser.h"
#import "UIImage+Resize.h"

@implementation OMBHomebaseRenterNotificationCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleDefault;

  CGRect screen   = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;
  CGFloat width   = (screen.size.width - (padding * 2));

  CGFloat topLabelWidth = width - (objectImageView.frame.size.width + padding);

  topLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  topLabel.frame = CGRectMake(topLabel.frame.origin.x, topLabel.frame.origin.y,
    topLabelWidth, 22.0f * 2);
  topLabel.numberOfLines = 2;

  middleLabel.hidden = YES;
  self.noButton.hidden    = YES;
  self.yesButton.hidden   = YES;

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGFloat padding = 20.0f;
  return padding + 22.0f + 22.0f + padding;
}

#pragma mark - Instance Methods

- (void) loadData
{
  // CGRect screen   = [[UIScreen mainScreen] bounds];
  // CGFloat padding = 20.0f;
  // CGFloat width   = (screen.size.width - (padding * 2));

  // CGFloat topLabelWidth = width - (objectImageView.frame.size.width + padding);

  dateTimeLabel.text = @"3d";

  CGFloat imageSize = objectImageView.frame.size.width;
  objectImageView.image = [[OMBUser fakeUser] imageForSize: imageSize];

  CGFloat lineHeight = 22.0f;
  UIFont *boldFont = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  // Text
  NSMutableAttributedString *aString = (NSMutableAttributedString *)
    [@"Edward D. " attributedStringWithFont: boldFont lineHeight: lineHeight];
  [aString appendAttributedString: 
    [@"paid" attributedStringWithFont: font lineHeight: lineHeight]];
  [aString appendAttributedString: [@" $700 " attributedStringWithFont: boldFont
    lineHeight: lineHeight]];
  [aString appendAttributedString: 
    [@"rent to John at 275 Lane Way." attributedStringWithFont: font 
      lineHeight: lineHeight]];
  topLabel.attributedText = aString;
}

@end
