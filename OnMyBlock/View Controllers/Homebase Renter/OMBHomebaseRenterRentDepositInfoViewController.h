//
//  OMBHomebaseRenterRentDepositInfoViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;

@interface OMBHomebaseRenterRentDepositInfoViewController : 
  OMBTableViewController
<UITextFieldDelegate>
{
  UIButton *addButton;
  UIView *backView;
  UILabel *depositLabel;
  UILabel *dueLabel;
  BOOL editingRentalPayments;
  UILabel *firstMonthRentLabel;
  BOOL isEditing;
  OMBCenteredImageView *residenceImageView;
  UILabel *totalDepositLabel;
  UILabel *totalRentLabel;
}

@property (nonatomic, weak) id delegate;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setupForEditRentalPayments;

@end
