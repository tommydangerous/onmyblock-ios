//
//  OMBOpenHouse.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBOpenHouse : NSObject

@property (nonatomic) NSInteger duration;
@property (nonatomic) NSTimeInterval startDate;

@property (nonatomic) NSInteger uid;

#pragma mark - Methods

#pragma mark - Instace Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
