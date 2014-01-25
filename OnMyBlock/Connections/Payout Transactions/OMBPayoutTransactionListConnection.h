//
//  OMBPayoutTransactionListConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBPayoutTransactionListConnection : OMBConnection
{
  BOOL deposits;
}

#pragma mark - Initializer

- (id) initForDeposits: (BOOL) deposit;

@end
