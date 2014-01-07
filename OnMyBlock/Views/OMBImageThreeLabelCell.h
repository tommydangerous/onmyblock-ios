//
//  OMBImageThreeLabelCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

#import "OMBCenteredImageView.h"

@interface OMBImageThreeLabelCell : OMBTableViewCell
{
  UILabel *bottomLabel;
  UILabel *middleLabel;
  OMBCenteredImageView *objectImageView;
  UILabel *topLabel;
}

@end
