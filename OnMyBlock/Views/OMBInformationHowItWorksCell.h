//
//  OMBInformationHowItWorksCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCollectionViewCell.h"

extern CGFloat kInformationHowItWorksCellInformationLineHeight;

@interface OMBInformationHowItWorksCell : OMBCollectionViewCell
{
  UILabel *numberLabel;
  UILabel *informationLabel;
  UILabel *titleLabel;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForTitleLabel;

#pragma mark - Instance Methods

- (void) loadInformation: (NSDictionary *) dictionary
atIndexPath: (NSIndexPath *) indexPath size: (CGSize) size;

@end
