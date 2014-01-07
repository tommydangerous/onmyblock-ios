//
//  OMBAddCosignerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerAddViewController.h"

#import "OMBCosigner.h"
#import "OMBCosignerCreateConnection.h"

@implementation OMBCosignerAddViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Add Co-signer";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  _firstNameTextField = [[TextFieldPadding alloc] init];
  _lastNameTextField  = [[TextFieldPadding alloc] init];
  _emailTextField     = [[TextFieldPadding alloc] init];
  _phoneTextField     = [[TextFieldPadding alloc] init];
  textFieldArray = @[
    _firstNameTextField, _lastNameTextField, _emailTextField, _phoneTextField
  ];

  _firstNameTextField.placeholder = @"First name (required)";
  _lastNameTextField.placeholder  = @"Last name (required)";
  _emailTextField.placeholder     = @"Email (required)";
  _emailTextField.keyboardType    = UIKeyboardTypeEmailAddress;
  _phoneTextField.placeholder     = @"Phone";
  _phoneTextField.keyboardAppearance = UIKeyboardAppearanceDark;
  _phoneTextField.keyboardType       = UIKeyboardTypePhonePad;

  [self setFrameForTextFields];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  NSArray *array = @[
    _firstNameTextField, 
    _lastNameTextField, 
    _emailTextField
  ];
  if ([self validateFieldsInArray: array])
    return;
  // Save the cosigner
  OMBCosigner *cosigner = [[OMBCosigner alloc] init];
  cosigner.email     = [_emailTextField.text lowercaseString];
  cosigner.firstName = [_firstNameTextField.text lowercaseString];
  cosigner.lastName  = [_lastNameTextField.text lowercaseString];
  cosigner.phone     = _phoneTextField.text;
  [[OMBUser currentUser] addCosigner: cosigner];
  [[[OMBCosignerCreateConnection alloc] initWithCosigner: cosigner] start];
  [self cancel];
}

@end
