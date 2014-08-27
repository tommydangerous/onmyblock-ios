//
//  OMBNeedHelpTitleCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBNeedHelpTitleCell.h"

#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBNeedHelpTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  if(!(self = [super initWithStyle:style
      reuseIdentifier:reuseIdentifier]))
    return nil;
  
  CGRect screen = [UIScreen mainScreen].bounds;
  
  self.clipsToBounds = YES;
  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellStyleDefault;
  
  _titleLabel = [UILabel new];
  _titleLabel.font = [UIFont normalTextFontBold];
  _titleLabel.frame = CGRectMake(20.f, 10.f,
    screen.size.width - 2 * 20.f, 20.f);
  _titleLabel.textColor = UIColor.darkGrayColor;
  [self.contentView addSubview:_titleLabel];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 30.f;
}

@end
