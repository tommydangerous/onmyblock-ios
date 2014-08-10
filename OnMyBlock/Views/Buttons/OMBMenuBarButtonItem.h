//
//  OMBMenuBarButtonItem.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/9/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBMenuBarButtonItem : UIBarButtonItem

#pragma mark - Initializer

- (id)initWithFrame:(CGRect)rect;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addTarget:(id)target action:(SEL)action;

@end
