//
//  OMBConnectionProtocol.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/25/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMBConnectionProtocol <NSObject>

@optional
- (void) JSONDictionary: (NSDictionary *) dictionary;
- (void) JSONDictionary: (NSDictionary *) dictionary forResourceName:(NSString *)resource;
- (void) numberOfPages: (NSUInteger) pages;

@end
