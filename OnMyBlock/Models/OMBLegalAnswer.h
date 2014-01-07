//
//  OMBLegalAnswer.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBLegalAnswer : NSObject

@property (nonatomic) BOOL answer;
@property (nonatomic, strong) NSString *explanation;
@property (nonatomic) int legalQuestionID;

@property (nonatomic) int uid;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
