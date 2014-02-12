//
//  OMBInformationStepsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBInformationStepsCell.h"

#import "NSString+Extensions.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBInformationStepsCell

#pragma mark - Initialzer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat standardHeight = OMBStandardHeight;
  CGFloat padding        = OMBPadding;

  self.backgroundColor = [UIColor blueLight];
  // self.layer.borderWidth = 1.0f;
  // self.layer.borderColor = [UIColor grayLight].CGColor;
  self.layer.cornerRadius = 5.0f;

  // Number label
  numberLabel = [UILabel new];
  numberLabel.font = [UIFont largeTextFontBold];
  numberLabel.frame = CGRectMake(0.0f, 0.0f, 
    OMBStandardButtonHeight, OMBStandardButtonHeight);
  // numberLabel.layer.borderColor = [UIColor blue].CGColor;
  // numberLabel.layer.borderWidth = 1.0f;
  // numberLabel.layer.cornerRadius = numberLabel.frame.size.width * 0.5f;
  numberLabel.textAlignment = NSTextAlignmentCenter;
  numberLabel.textColor = [UIColor whiteColor];
  [self addSubview: numberLabel];

  // Title label
  titleLabel = [UILabel new];
  titleLabel.font = [UIFont mediumLargeTextFontBold];
  titleLabel.frame = CGRectMake(
    numberLabel.frame.origin.x + numberLabel.frame.size.width, 
      numberLabel.frame.origin.y, 
        self.frame.size.width - (numberLabel.frame.origin.x + 
        numberLabel.frame.size.width + padding), numberLabel.frame.size.height);
  titleLabel.textColor = [UIColor textColor];
  [self addSubview: titleLabel];

  informationLabel = [UILabel new];
  informationLabel.font = [UIFont mediumTextFont];
  informationLabel.frame = CGRectMake(padding, titleLabel.frame.origin.y +
    titleLabel.frame.size.height, self.frame.size.width - (padding * 2),
      self.frame.size.height - 
      (titleLabel.frame.origin.y + titleLabel.frame.size.height + padding));
  informationLabel.numberOfLines = 0;
  informationLabel.textColor = [UIColor textColor];
  [self addSubview: informationLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadInformation: (NSString *) information title: (NSString *) title
step: (NSInteger) step
{
  numberLabel.text = [NSString stringWithFormat: @"%i", step];
  titleLabel.text  = title;
  informationLabel.attributedText = [information attributedStringWithFont:
    informationLabel.font lineHeight: 27.0f];
}

@end
