//
//  OMBPreviousRentalAddViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationAddModelViewController.h"

@interface OMBPreviousRentalAddViewController : 
  OMBRenterApplicationAddModelViewController

@property (nonatomic, strong) TextFieldPadding *addressTextField;
@property (nonatomic, strong) TextFieldPadding *cityTextField;
@property (nonatomic, strong) TextFieldPadding *landlordEmailTextField;
@property (nonatomic, strong) TextFieldPadding *landlordNameTextField;
@property (nonatomic, strong) TextFieldPadding *landlordPhoneTextField;
@property (nonatomic, strong) TextFieldPadding *leaseMonthsTextField;
@property (nonatomic, strong) TextFieldPadding *rentTextField;
@property (nonatomic, strong) TextFieldPadding *stateTextField;
@property (nonatomic, strong) TextFieldPadding *zipTextField;

@end
