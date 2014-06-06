//
//  OMBImageFourLabelCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

#import "OMBCenteredImageView.h"

@interface OMBImageFourLabelCell : OMBTableViewCell
{
  UILabel *thirdLabel;
  UILabel *fourthlabel;
  UILabel *middleLabel;
  OMBCenteredImageView *objectImageView;
  UILabel *topLabel;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setImageViewAlpha: (CGFloat) value;
- (void) setImageViewCircular: (BOOL) isCircular;

@end