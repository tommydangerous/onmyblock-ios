//
//  OMBLegalQuestion.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBLegalQuestion : NSObject

@property (nonatomic, strong) NSString *question;

@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Class Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
