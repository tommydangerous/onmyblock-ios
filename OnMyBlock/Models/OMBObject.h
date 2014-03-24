//
//  OMBObject.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBObject : NSObject

@property (nonatomic) NSUInteger uid;

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName;
+ (NSString *) resourceName;

#pragma mark - Instance Methods

- (NSString *) modelName;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSString *) resourceName;

@end
