//
//  OMBAttributedTextCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBAttributedTextCell.h"

@implementation OMBAttributedTextCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!([super initWithStyle: style reuseIdentifier: reuseIdentifier])) {
    return nil;
  }

  self.attributedTextLabel               = [UILabel new];
  self.attributedTextLabel.numberOfLines = 0;
  [self.contentView addSubview: self.attributedTextLabel];

  return self;
}

@end
