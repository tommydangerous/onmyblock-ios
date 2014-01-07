//
//  OMBLegalAnswerCreateOrUpdateConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBLegalAnswer;

@interface OMBLegalAnswerCreateOrUpdateConnection : OMBConnection
{
  OMBLegalAnswer *legalAnswer;
}

#pragma mark - Initializer

- (id) initWithLegalAnswer: (OMBLegalAnswer *) object;

@end
