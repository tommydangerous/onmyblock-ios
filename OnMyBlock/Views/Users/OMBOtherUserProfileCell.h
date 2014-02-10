//
//  OMBOtherUserProfileCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBOtherUserProfileCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *valueLabel;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;
+ (NSString *) reuseIdentifier;

@end
