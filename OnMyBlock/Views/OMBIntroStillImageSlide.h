//
//  OMBIntroStillImageSlide.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBIntroStillImageSlide : UIView

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

#pragma mark - Initializer

- (id) initWithBackgroundImage: (UIImage *) image;
- (void) setDetailLabelText: (NSString *) string;

@end
