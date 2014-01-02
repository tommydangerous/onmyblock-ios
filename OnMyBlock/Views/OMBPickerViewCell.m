//
//  OMBPickerViewCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPickerViewCell.h"

@implementation OMBPickerViewCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  _pickerView = [[UIPickerView alloc] init];
  _pickerView.showsSelectionIndicator = NO;
  [self.contentView addSubview: _pickerView];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return 216.0f;
}

@end
