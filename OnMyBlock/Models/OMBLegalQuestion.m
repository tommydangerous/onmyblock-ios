//
//  OMBLegalQuestion.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalQuestion.h"

#import "OMBLegalQuestionStore.h"

@implementation OMBLegalQuestion

#pragma mark - Methods

#pragma mark - Class Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  _question = [dictionary objectForKey: @"question"];
  _uid      = [[dictionary objectForKey: @"id"] intValue];
  [[OMBLegalQuestionStore sharedStore] addLegalQuestion: self];
}

@end
