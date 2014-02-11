//
//  CustomLoading.h
//  CustomActivityAnimation
//
//  Created by Paul Aguilar on 1/17/14.
//  Copyright (c) 2014 teclalabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomLoading : NSObject

@property(nonatomic,retain)UIView *loadinAlert;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIImageView *loadingImage;
@property(nonatomic)       int numImages;

+ (id)getInstance;
- (void)clearInstance;
- (void)startAnimatingWithProgress:(int)progress withView:(UIView *)view;
- (void)stopAnimatingWithView:(UIView *)view;
@end
