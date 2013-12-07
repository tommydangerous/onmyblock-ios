//
//  OMBPreviousRentalAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRentalAddViewController.h"

#import "OMBPreviousRental.h"

@implementation OMBPreviousRentalAddViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Add Previous Rental";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
    
  _addressTextField       = [[TextFieldPadding alloc] init];
  _cityTextField          = [[TextFieldPadding alloc] init];
  _landlordEmailTextField = [[TextFieldPadding alloc] init];
  _landlordNameTextField  = [[TextFieldPadding alloc] init];
  _landlordPhoneTextField = [[TextFieldPadding alloc] init];
  _leaseMonthsTextField   = [[TextFieldPadding alloc] init];
  _rentTextField          = [[TextFieldPadding alloc] init];
  _stateTextField         = [[TextFieldPadding alloc] init];
  _zipTextField           = [[TextFieldPadding alloc] init];
  textFieldArray = @[
    _addressTextField,
    _cityTextField,
    _stateTextField,
    _zipTextField,
    _rentTextField,
    _leaseMonthsTextField,
    _landlordNameTextField,
    _landlordEmailTextField,
    _landlordPhoneTextField,  
  ];

  _addressTextField.placeholder       = @"Address (required)";
  _cityTextField.placeholder          = @"City (required)";
  _landlordEmailTextField.placeholder = @"Landlord email";
  _landlordEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
  _landlordNameTextField.placeholder  = @"Landlord name";
  _landlordPhoneTextField.placeholder = @"Landlord phone";
  _landlordPhoneTextField.keyboardAppearance = UIKeyboardAppearanceDark;
  _landlordPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
  _leaseMonthsTextField.placeholder   = @"Lease months (required)";
  _leaseMonthsTextField.keyboardAppearance = UIKeyboardAppearanceDark;
  _leaseMonthsTextField.keyboardType  = UIKeyboardTypeNumberPad;
  _rentTextField.placeholder          = @"Rent";
  _rentTextField.keyboardAppearance   = UIKeyboardAppearanceDark;
  _rentTextField.keyboardType         = UIKeyboardTypeDecimalPad;
  _stateTextField.placeholder         = @"State (required)";
  _zipTextField.placeholder           = @"Zip";
  _zipTextField.keyboardAppearance    = UIKeyboardAppearanceDark;
  _zipTextField.keyboardType          = UIKeyboardTypeNumberPad;

  [self setFrameForTextFields];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  NSArray *array = @[
    _addressTextField, 
    _cityTextField, 
    _stateTextField,
    _leaseMonthsTextField
  ];
  if ([self validateFieldsInArray: array])
    return;
  // Save the previous rental
  OMBPreviousRental *previousRental = [[OMBPreviousRental alloc] init];
  previousRental.address       = [_addressTextField.text lowercaseString];
  previousRental.city          = [_cityTextField.text lowercaseString];
  previousRental.landlordEmail = [_landlordEmailTextField.text lowercaseString];
  previousRental.landlordName  = [_landlordNameTextField.text lowercaseString];
  previousRental.landlordPhone = _landlordPhoneTextField.text;
  previousRental.leaseMonths   = [_leaseMonthsTextField.text intValue];
  previousRental.rent          = [_rentTextField.text floatValue];
  previousRental.state         = [_stateTextField.text lowercaseString];
  previousRental.zip           = _zipTextField.text;
  [[OMBUser currentUser] addPreviousRental: previousRental];
  // Connection
  [self cancel];
}


@end
