//
//  OMBApplicationDelegateObject.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBApplicationDelegateObject : NSObject

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public Methods

+ (OMBApplicationDelegateObject *)sharedObject;

#pragma mark - Instance Methods

#pragma mark - Private Methods

- (void)checkMinimumVersion;

@end
