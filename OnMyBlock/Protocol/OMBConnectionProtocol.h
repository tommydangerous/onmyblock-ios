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
- (void) numberOfPages: (NSUInteger) pages;

@end
