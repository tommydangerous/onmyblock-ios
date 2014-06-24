//
//  OMBPayoutMethodCreditCardInfoViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodCreditCardInfoViewController.h"

#import "OMBCreditCardTextFieldCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "UIImage+Resize.h"

@implementation OMBPayoutMethodCreditCardInfoViewController

- (id)init
{
  if(!(self = [super init]))
    return nil;
  
  self.title = @"Add Payment";
  valueDictionary = [NSMutableDictionary dictionary];
  
  return self;
}

- (void)loadView
{
  [super loadView];
  
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  
  UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
    initWithTitle:@"Done" style:UIBarButtonItemStylePlain
      target:self action:@selector(done)];
  [doneBarButton setTitleTextAttributes:@{
    NSFontAttributeName : boldFont
    } forState:UIControlStateNormal];
  
  self.navigationItem.rightBarButtonItem = doneBarButton;
  self.navigationItem.rightBarButtonItem.enabled = NO;
  
  [self setupForTable];
  self.table.separatorInset  = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self.view endEditing:YES];
  
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  // Credit Card Info
  if(indexPath.section == OMBCreditCardInfoSection){
    
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  // Spacing
  else if(indexPath.section == OMBCreditCardSpacingSection)
    if (isEditing) {
      return OMBKeyboardHeight;
    }
  
  return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Protocol UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

  // Credit Card Info
  // Spacing
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Title
  // Card Number
  // Expiration date and CCV
  if(section == OMBCreditCardInfoSection)
    return 3;
  // Spacing
  else if (section == OMBCreditCardSpacingSection)
    return 1;
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  int row     = indexPath.row;
  int section = indexPath.section;
  
  static NSString *emptyCellID = @"emptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:emptyCellID];
  if(!emptyCell)
    emptyCell = [[UITableViewCell alloc] initWithStyle:
       UITableViewCellStyleDefault reuseIdentifier:emptyCellID];
  
  if(section == OMBCreditCardInfoSection){
    // Title
    if(row == OMBCreditCardInfoSectionRowTitle){
      emptyCell.backgroundColor = UIColor.clearColor;
      emptyCell.SelectionStyle = UITableViewCellSelectionStyleNone;
      
      UILabel *lbTitle = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55.0f)];
      [lbTitle setBackgroundColor:[UIColor clearColor]];
      [lbTitle setTextColor:[UIColor grayMedium]];
      [lbTitle setFont:[UIFont mediumTextFont]];
      [lbTitle setText:@"Credit Card Information"];
      [lbTitle setTextAlignment:NSTextAlignmentCenter];
      [emptyCell addSubview:lbTitle];
      return emptyCell;
      
    }
    // Card Number
    else if(row == OMBCreditCardInfoSectionRowCardNumber){
          
      static NSString *cardNumberCellID = @"cardNumberCellID";
      OMBLabelTextFieldCell *cell = [tableView
         dequeueReusableCellWithIdentifier:cardNumberCellID];
      
      if(!cell){
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:cardNumberCellID];
        
        [cell setFrameUsingIconImageView];
      }
      
      // cell.backgroundColor = transparentWhite;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textField.font = [UIFont normalTextFont];
      cell.textFieldLabel.font = [UIFont normalTextFont];
      
      cell.iconImageView.image = [UIImage image:
        [UIImage imageNamed: @"credit_card_icon"]
          size: cell.iconImageView.frame.size];
      cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypeNumberPad;
      cell.textField.placeholder = @"Card number";
      //cell.textField.text = @"Credit card";
      [cell.textField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      
      return cell;
      
    }
    // Expiration Date and CCV
    else if(row == OMBCreditCardInfoSectionRowExpirationMonth){
      
      //imageName = @"user_icon.png";
      static NSString *expirationCcvCellID = @"expirationCcvCellID";
      OMBCreditCardTextFieldCell *twoCell =
      [tableView dequeueReusableCellWithIdentifier: expirationCcvCellID];
      if (!twoCell) {
        twoCell = [[OMBCreditCardTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: expirationCcvCellID];
        [twoCell setFrameUsingLeftLabel];
      }
      twoCell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      twoCell.firstTextField.delegate  = self;
      twoCell.firstTextField.indexPath = indexPath;
      twoCell.firstTextField.keyboardType = UIKeyboardTypeNumberPad;
      twoCell.firstTextField.placeholder  = @"mm";
      twoCell.firstTextField.tag = indexPath.row;
      twoCell.firstTextFieldLabel.text = @"Exp";
      /*twoCell.firstIconImageView.image = [UIImage image: [UIImage imageNamed:
        @"user_icon.png"] size: twoCell.firstIconImageView.bounds.size];*/
      
      twoCell.yearTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      twoCell.yearTextField.delegate  = self;
      twoCell.yearTextField.indexPath = indexPath;
      twoCell.yearTextField.keyboardType = UIKeyboardTypeNumberPad;
      twoCell.yearTextField.placeholder  = @"yy";
      twoCell.yearTextField.tag = OMBCreditCardInfoSectionRowExpirationYear;
      
      twoCell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      twoCell.secondTextField.delegate  = self;
      twoCell.secondTextField.indexPath = indexPath;
      twoCell.secondTextField.keyboardType = UIKeyboardTypeNumberPad;
      twoCell.secondTextField.placeholder = @"CCV";
      twoCell.secondTextField.tag = OMBCreditCardInfoSectionRowCCV;
      twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
      
      [twoCell.firstTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      [twoCell.yearTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      [twoCell.secondTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      twoCell.clipsToBounds = YES;
      return twoCell;
    }
  }
  // Spacing
  else if (section == OMBCreditCardSpacingSection){
    emptyCell.backgroundColor = UIColor.clearColor;
    emptyCell.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
  }
  
  return emptyCell;
  
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textField:(TextFieldPadding *)textField shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
  
  // Expiration Date
  if(textField.indexPath.row == OMBCreditCardInfoSectionRowExpirationMonth){
    // Year
    if(textField.tag == OMBCreditCardInfoSectionRowExpirationYear){
      
      if([[textField.text stringByReplacingCharactersInRange: range
         withString:string] intValue] > 12)
        return NO;
      
    }
    // CCV
    else if(textField.tag == OMBCreditCardInfoSectionRowCCV){
      
      if([[textField.text stringByReplacingCharactersInRange: range
          withString:string] intValue] > 999)
      return NO;
    
    }
    // Month
    else
      if([[textField.text stringByReplacingCharactersInRange: range
           withString:string] intValue] > 12)
        return NO;
    
  }
  
  return YES;

}

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  
  //textField.inputAccessoryView = textFieldToolbar;
  
  // [self scrollToRectAtIndexPath: textField.indexPath];
  [self scrollToRowAtIndexPath: textField.indexPath];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self doneFromInputAccessoryView];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelFromInputAccessoryView
{
  
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  
}

- (void)done
{
  
  NSLog(@"%s %@",__PRETTY_FUNCTION__, [valueDictionary description]);
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

- (void) doneFromInputAccessoryView
{
  
  [self cancelFromInputAccessoryView];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void)textFieldDidChange:(TextFieldPadding *)textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;
  
  
  if (row == OMBCreditCardInfoSectionRowCardNumber) {
    [valueDictionary setObject: string forKey: @"cardNumber"];
  }
  else if (row == OMBCreditCardInfoSectionRowExpirationMonth) {
    // Year
    if (textField.tag == OMBCreditCardInfoSectionRowExpirationYear) {
      [valueDictionary setObject: string forKey: @"year"];
    }
    // CCV
    else if (textField.tag == OMBCreditCardInfoSectionRowCCV) {
      [valueDictionary setObject: string forKey: @"ccv"];
    }
    // Month
    else
      [valueDictionary setObject: string forKey: @"month"];
  }
  
  BOOL enable = [valueDictionary count] >= 4;
  
  for(NSString *key in [valueDictionary allKeys]){
    
    if(![[valueDictionary objectForKey:key] length])
      enable = NO;
    
  }
  
  self.navigationItem.rightBarButtonItem.enabled = enable;
  
}

@end
