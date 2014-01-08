//
//  OMBHomebaseRenterAddRemoveRoommatesViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBAlertView;

@interface OMBHomebaseRenterAddRemoveRoommatesViewController : 
  OMBTableViewController
<UIAlertViewDelegate>
{
  OMBAlertView *alert;
  int removeRoommateIndex;
}

@end
