//
//  OMBFavoriteResidence.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/31/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMBResidence;
@class OMBUser;

@interface OMBFavoriteResidence : NSObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) OMBResidence *residence;
@property (nonatomic, strong) OMBUser *user;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) dictionaryKey;

@end
