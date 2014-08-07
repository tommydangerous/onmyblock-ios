//
// Created by Tommy DANGerous on 8/4/14.
// Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBObject.h"

@interface OMBGroup : OMBObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger ownerId;
@property (nonatomic, strong) NSMutableDictionary *users;

@end
