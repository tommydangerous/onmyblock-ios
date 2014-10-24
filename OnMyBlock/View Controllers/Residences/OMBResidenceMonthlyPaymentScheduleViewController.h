//
//  OMBResidenceMonthlyPaymentScheduleViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBResidenceMonthlyPaymentScheduleViewController : 
  OMBTableViewController
{
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
