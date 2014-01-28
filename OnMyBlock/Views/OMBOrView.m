//
//  OMBOrView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOrView.h"

#import "UIFont+OnMyBlock.h"

@implementation OMBOrView

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect color: (UIColor *) color
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat padding = 20.0f;

  orLabel = [[UILabel alloc] init];
  orLabel.font = [UIFont largeTextFontBold];
  orLabel.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 
    self.frame.size.height);
  orLabel.text = @"OR";
  orLabel.textAlignment = NSTextAlignmentCenter;
  orLabel.textColor = color;
  [self addSubview: orLabel];

  // Lines
  CGFloat orViewCenter = self.frame.size.width * 0.5f;
  CGFloat lineWidth = self.frame.size.width * 0.2f;
  UIView *leftLine = [UIView new];
  leftLine.backgroundColor = orLabel.textColor;
  leftLine.frame = CGRectMake(orViewCenter - (lineWidth + padding + padding), 
    (self.frame.size.height - 0.5f) * 0.5f, lineWidth, 0.5f);
  [self addSubview: leftLine];
  UIView *rightLine = [UIView new];
  rightLine.backgroundColor = leftLine.backgroundColor;
  rightLine.frame = CGRectMake(orViewCenter + padding + padding,
    leftLine.frame.origin.y, leftLine.frame.size.width, 
      leftLine.frame.size.height);
  [self addSubview: rightLine];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setLabelBold: (BOOL) bold
{
  if (bold)
    orLabel.font = [UIFont largeTextFontBold];
  else
    orLabel.font = [UIFont largeTextFont];
}

@end
