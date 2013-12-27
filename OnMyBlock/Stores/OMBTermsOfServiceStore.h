//
//  OMBTermsOfServiceStore.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBTermsOfServiceStore : NSObject

@property (nonatomic, strong) NSArray *sections;

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBTermsOfServiceStore *) sharedStore;

@end
