//
//  OMBRenterApplicationAddModelCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationAddModelCell.h"

#import "TextFieldPadding.h"

@implementation OMBRenterApplicationAddModelCell

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  _textField = [[TextFieldPadding alloc] init];

  return self;
}

- (void) setTextField: (TextFieldPadding *) object
{
  for (UIView *view in self.contentView.subviews) {
    [view removeFromSuperview];
  }
  _textField = object;
  [self.contentView addSubview: _textField];
}

@end
