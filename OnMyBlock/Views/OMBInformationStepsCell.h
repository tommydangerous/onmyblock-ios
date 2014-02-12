//
//  OMBInformationStepsCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCollectionViewCell.h"

@interface OMBInformationStepsCell : OMBCollectionViewCell
{
  UIImageView *imageView;
  UILabel *informationLabel;
  UILabel *numberLabel;
  UILabel *titleLabel;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadInformation: (NSString *) information title: (NSString *) title
  step: (NSInteger) step;

@end
