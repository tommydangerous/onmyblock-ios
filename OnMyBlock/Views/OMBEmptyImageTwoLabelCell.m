//
//  OMBEmptyImageTwoLabelCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBEmptyImageTwoLabelCell.h"

#import "UIFont+OnMyBlock.h"

@implementation OMBEmptyImageTwoLabelCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  // CGRect topRect = topLabel.frame;
  // topRect.origin.y = objectImageView.frame.origin.y;
  // topRect.size.height = objectImageView.frame.size.height * 0.5f;
  topLabel.font = [UIFont normalTextFont];
  // topLabel.frame = topRect;

  // CGRect middleRect = middleLabel.frame;
  // middleRect.origin.y = topLabel.frame.origin.y + topLabel.frame.size.height;
  // middleRect.size.height = topLabel.frame.size.height;
  middleLabel.font = topLabel.font;
  // middleLabel.frame = middleRect;

  // bottomLabel.hidden = YES;
  bottomLabel.font = topLabel.font;

  objectImageView.alpha = 0.3f;
  objectImageView.layer.cornerRadius = 0.0f;

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setBottomLabelText: (NSString *) string
{
  bottomLabel.text = string;
}

- (void) setMiddleLabelText: (NSString *) string
{
  middleLabel.text = string;
}

- (void) setObjectImageViewImage: (UIImage *) image
{
  objectImageView.image = image;
}

- (void) setTopLabelText: (NSString *) string
{
  topLabel.text = string;  
}

@end
