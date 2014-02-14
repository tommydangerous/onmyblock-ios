//
//  OMBInformationHowItWorksCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBInformationHowItWorksCell.h"

#import "NSString+Extensions.h"
#import "OMBViewController.h"

CGFloat kInformationHowItWorksCellInformationLineHeight = 27.0f;

@implementation OMBInformationHowItWorksCell

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat padding = OMBPadding;

  // self.backgroundColor = [UIColor redColor];

  // Number label
  numberLabel = [UILabel new];
  numberLabel.font = [UIFont largeTextFontBold];
  numberLabel.frame = CGRectMake(0.0f, 0.0f, 27.0f, 
    [OMBInformationHowItWorksCell heightForTitleLabel]);
  // numberLabel.textAlignment = NSTextAlignmentCenter;
  numberLabel.textColor = [UIColor blue];
  [self addSubview: numberLabel];

  // Title label
  titleLabel = [UILabel new];
  titleLabel.font = [UIFont mediumLargeTextFontBold];
  titleLabel.frame = CGRectMake(numberLabel.frame.origin.x + 
    numberLabel.frame.size.width, // + (padding * 0.5f), 
      numberLabel.frame.origin.y, 
        self.frame.size.width - (numberLabel.frame.origin.x + 
        numberLabel.frame.size.width + padding), 
          numberLabel.frame.size.height);
  titleLabel.textColor = [UIColor textColor];
  [self addSubview: titleLabel];

  informationLabel = [UILabel new];
  informationLabel.font = [UIFont mediumTextFont];
  informationLabel.frame = CGRectMake(0.0f, titleLabel.frame.origin.y +
    titleLabel.frame.size.height, // - 
    // (kInformationHowItWorksCellInformationLineHeight * 0.3f), 
      self.frame.size.width, 0.0f);
  informationLabel.numberOfLines = 0;
  informationLabel.textColor = [UIColor textColor];
  [self addSubview: informationLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForTitleLabel
{
  return 36.0f;
}

#pragma mark - Instance Methods

- (void) loadInformation: (NSDictionary *) dictionary
atIndexPath: (NSIndexPath *) indexPath size: (CGSize) size
{
  numberLabel.text = [NSString stringWithFormat: @"%i", indexPath.row + 1];
  titleLabel.text  = [dictionary objectForKey: @"title"];
  informationLabel.attributedText = 
    [[dictionary objectForKey: @"information"] attributedStringWithFont:
      informationLabel.font lineHeight: 
        kInformationHowItWorksCellInformationLineHeight];
  informationLabel.frame = CGRectMake(informationLabel.frame.origin.x,
    informationLabel.frame.origin.y, informationLabel.frame.size.width,
      size.height);
}

@end
