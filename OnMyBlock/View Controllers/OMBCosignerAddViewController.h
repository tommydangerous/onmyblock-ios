//
//  OMBAddCosignerViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationAddModelViewController.h"

@interface OMBCosignerAddViewController : 
  OMBRenterApplicationAddModelViewController
  
@property (nonatomic, strong) TextFieldPadding *emailTextField;
@property (nonatomic, strong) TextFieldPadding *firstNameTextField;
@property (nonatomic, strong) TextFieldPadding *lastNameTextField;
@property (nonatomic, strong) TextFieldPadding *phoneTextField;

@end
