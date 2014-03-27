//
//  OMBCosignerCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCosigner;

@interface OMBCosignerCell : OMBTableViewCell
{
  UILabel *nameLabel;
}

@property (nonatomic, strong) OMBCosigner *cosigner;
@property UIButton *emailButton;
@property UIButton *phoneButton;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBCosigner *) object;

@end
