//
//  OMBUserDetailSectionHeaderCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUserDetailSectionHeaderCell.h"

// Categories
#import "UIFont+OnMyBlock.h"
// View controllers
#import "OMBViewController.h"

@implementation OMBUserDetailSectionHeaderCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) {
    return nil;
  }

  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle  = UITableViewCellSelectionStyleNone;
  // self.separatorInset  = UIEdgeInsetsZero;
  self.separatorInset = UIEdgeInsetsMake(0.f, CGRectGetWidth(self.frame),
    0.f, 0.f);

  self.headerLabel           = [UILabel new];
  self.headerLabel.font      = [UIFont normalSmallTextFontBold];
  self.headerLabel.frame     = CGRectMake(OMBPadding, OMBPadding * 1.5f,
    CGRectGetWidth(self.frame), OMBPadding);
  self.headerLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: self.headerLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public

+ (CGFloat) heightForCell
{
  return OMBPadding * 3;
}

@end
