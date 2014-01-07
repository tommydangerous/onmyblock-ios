//
//  OMBRenterApplicationPetCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBRenterApplicationPetCell : UITableViewCell

@property (nonatomic, strong) UIView *checkmarkBox;
@property (nonatomic, strong) UIImageView *checkmarkImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic) BOOL isSelected;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) emptyCheckmarkBox;
- (void) fillInCheckmarkBox;
- (void) toggleCheckmarkBox;

@end
