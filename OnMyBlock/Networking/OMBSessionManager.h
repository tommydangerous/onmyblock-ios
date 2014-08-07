//
//  OMBSessionManager.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface OMBSessionManager : AFHTTPSessionManager

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public

+ (OMBSessionManager *)sharedManager;

@end
