//
//  OMBEmploymentAddViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationAddModelViewController.h"

@interface OMBEmploymentAddViewController : 
  OMBRenterApplicationAddModelViewController
{
  NSDateFormatter *dateFormatter;
  BOOL isEditingEndDate;
  BOOL isEditingStartDate;
}

@property (nonatomic, strong) TextFieldPadding *companyNameTextField;
@property (nonatomic, strong) TextFieldPadding *companyWebsiteTextField;
@property (nonatomic, strong) UIDatePicker *endDatePicker;
@property (nonatomic, strong) TextFieldPadding *endDateTextField;
@property (nonatomic, strong) TextFieldPadding *incomeTextField;
@property (nonatomic, strong) UIDatePicker *startDatePicker;
@property (nonatomic, strong) TextFieldPadding *startDateTextField;
@property (nonatomic, strong) TextFieldPadding *titleTextField;

@end
