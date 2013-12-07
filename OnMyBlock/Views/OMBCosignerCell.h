//
//  OMBCosignerCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBCosigner;

@interface OMBCosignerCell : UITableViewCell
{
  UILabel *emailLabel;
  UILabel *nameLabel;
  UILabel *phoneLabel;
}

@property (nonatomic, strong) OMBCosigner *cosigner;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBCosigner *) object;

@end
