//
//  OMBFilmstripImageCell.h
//  OnMyBlock
//
//  Created by Peter Meyers on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBFilmstripImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) reuseID;

@end
