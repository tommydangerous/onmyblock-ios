//
//  OMBPayoutMethodBillingInfoViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodBillingInfoViewController.h"

#import "OMBLabelTextFieldCell.h"
#import "OMBPayoutMethodCreditCardInfoViewController.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "UIImage+Resize.h"

@implementation OMBPayoutMethodBillingInfoViewController

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
  
  UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc]
    initWithTitle:@"Next" style:UIBarButtonItemStylePlain
      target:self action:@selector(next)];
  
  [nextBarButton setTitleTextAttributes: @{
      NSFontAttributeName: boldFont
    } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = nextBarButton;
  self.navigationItem.rightBarButtonItem.enabled = NO;
  
  [self setupForTable];
  self.table.separatorInset  = UIEdgeInsetsZero;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
#warning Need to add model to support credit card variable
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.view endEditing:YES];
  
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
  // Last Name
  if(indexPath.section == OMBBillingInfoSectionName){
    
    if(indexPath.row == OMBBillingInfoSectionNameRowLastName)
      return 0.f;
    return [OMBLabelTextFieldCell heightForCellWithIconImageView];
  }
  // Zip
  else if(indexPath.section == OMBBillingInfoSectionAddress){
    
    if(indexPath.row == OMBBillingInfoSectionAddressRowTitle)
      return [OMBTwoLabelTextFieldCell heightForCellWithIconImageView];
    
    else if(indexPath.row == OMBBillingInfoSectionAddressRowZip)
      return 0.f;
    
    return [OMBTwoLabelTextFieldCell heightForCellWithIconImageView];
  }
  // Spacing
  else if(indexPath.section == OMBBillingInfoSectionSpacing){
    
    if (isEditing) {
      return OMBKeyboardHeight;
    }
  }
  
  return 0.0f;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
  // Name
  // Address
  // Spacing
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Name
  if(section == OMBBillingInfoSectionName)
  {
    // Title
    // First
    // Last Name
    return 3;
  }
  // Billing Address
  else if(section == OMBBillingInfoSectionAddress){
    // Title
    // Street
    // City
    // State
    // Zip
    return 5;
  }
  // Spacing
  else if(section == OMBBillingInfoSectionSpacing){
    return 1;
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  int row = indexPath.row;
  int section = indexPath.section;
  
  static NSString *cellID = @"emptyCellID";
  UITableViewCell *emptycell = [tableView
    dequeueReusableCellWithIdentifier:cellID];
  
  if(!emptycell)
    emptycell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier:cellID];
  
    emptycell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  // Section Name
  if(section == OMBBillingInfoSectionName){
    
    if(row == OMBBillingInfoSectionNameRowTitle){
      emptycell.backgroundColor = UIColor.clearColor;
      emptycell.SelectionStyle = UITableViewCellSelectionStyleNone;
      
      UILabel *lbTitle = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55.0f)];
      [lbTitle setBackgroundColor:[UIColor clearColor]];
      [lbTitle setTextColor:[UIColor grayMedium]];
      [lbTitle setFont:[UIFont mediumTextFont]];
      [lbTitle setText:@"Name on Card"];
      [lbTitle setTextAlignment:NSTextAlignmentCenter];
      [emptycell addSubview:lbTitle];
      return emptycell;
    
    }
    // First Name and Last Name
    else if (row == OMBBillingInfoSectionNameRowFirstName) {
      
      //NSString *imageName = @"user_icon.png";
      static NSString *nameCellID = @"nameCellID";
      OMBTwoLabelTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier: nameCellID];
      if (!cell) {
        cell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: nameCellID];
        [cell setFrameUsingIconImageView];
      }
      
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.firstTextField.delegate  = self;
      cell.firstTextField.font = [UIFont normalTextFont];
      cell.firstTextField.indexPath = indexPath;
      cell.firstTextField.keyboardType = UIKeyboardTypeDefault;
      cell.firstTextField.placeholder  = @"First name";
      //cell.firstTextField.textColor = @"";
      cell.firstTextField.textColor = [UIColor textColor];
      cell.firstTextFieldLabel.font = [UIFont normalTextFont];
      //cell.firstTextFieldLabel.text = @"";
      cell.firstIconImageView.image = [UIImage image: [UIImage imageNamed:
        @"user_icon.png"] size: cell.firstIconImageView.bounds.size];
      cell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.secondTextField.delegate  = self;
      cell.secondTextField.font = cell.firstTextField.font;
      cell.secondTextField.indexPath = [NSIndexPath
        indexPathForRow: OMBBillingInfoSectionNameRowLastName
          inSection:indexPath.section] ;
      cell.secondTextField.keyboardType = UIKeyboardTypeDefault;
      cell.secondTextField.placeholder = @"Last name";
      cell.secondTextField.tag = OMBBillingInfoSectionNameRowLastName;
      //cell.secondTextField.text = [valueDictionary objectForKey: @"lastName"];
      cell.secondTextField.textColor = cell.firstTextField.textColor;
      cell.secondTextFieldLabel.font = cell.firstTextFieldLabel.font;
      //cell.secondTextFieldLabel.text = lastNameLabelString;
      cell.secondIconImageView.image = [UIImage image: [UIImage imageNamed: @"user_icon.png"]
        size: cell.secondIconImageView.frame.size];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell.firstTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      [cell.secondTextField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      
      return cell;

    }
  }
  // Address
  else if(section == OMBBillingInfoSectionAddress){
    
    // Title
    if(row == OMBBillingInfoSectionAddressRowTitle){
      
      emptycell.backgroundColor = UIColor.clearColor;
      emptycell.SelectionStyle = UITableViewCellSelectionStyleNone;
      
      UILabel *lbTitle = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55.0f)];
      [lbTitle setBackgroundColor:[UIColor clearColor]];
      [lbTitle setTextColor:[UIColor grayMedium]];
      [lbTitle setFont:[UIFont mediumTextFont]];
      [lbTitle setText:@"Billing Address "];
      [lbTitle setTextAlignment:NSTextAlignmentCenter];
      [emptycell addSubview:lbTitle];
      return emptycell;
      
    }
    else{
      
      static NSString *addressCellID = @"addressCellID";
      OMBLabelTextFieldCell *cell = [tableView
        dequeueReusableCellWithIdentifier:addressCellID];
      
      if(!cell){
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:addressCellID];
        
        [cell setFrameUsingSize:CGSizeZero];
        [cell setFrameUsingHeight:[OMBLabelTextFieldCell
          heightForCellWithIconImageView]];
      }
      
      // cell.backgroundColor = transparentWhite;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textField.font = [UIFont normalTextFont];
      cell.textField.textColor = [UIColor textColor];
      cell.textFieldLabel.font = [UIFont normalTextFont];
      
      NSString *labelString;
      NSString *imageName = @"user_icon.png";
      
      // State Zip
      if (row == OMBBillingInfoSectionAddressRowState) {
        //imageName = @"user_icon.png";
        static NSString *stateZipCellID = @"stateZipCellID";
        OMBTwoLabelTextFieldCell *twoCell =
          [tableView dequeueReusableCellWithIdentifier: stateZipCellID];
        if (!twoCell) {
          twoCell = [[OMBTwoLabelTextFieldCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: stateZipCellID];
          [twoCell setFrameUsingLabelSize:CGSizeZero];
        }
        twoCell.firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        twoCell.firstTextField.delegate  = self;
        twoCell.firstTextField.indexPath = indexPath;
        twoCell.firstTextField.placeholder  = @"State";
        /*twoCell.firstIconImageView.image = [UIImage image: [UIImage imageNamed:
          @"user_icon.png"] size: twoCell.firstIconImageView.bounds.size];*/
        twoCell.secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        twoCell.secondTextField.delegate  = self;
        twoCell.secondTextField.indexPath = [NSIndexPath
          indexPathForRow:OMBBillingInfoSectionAddressRowZip inSection:section];
        twoCell.secondTextField.keyboardType = UIKeyboardTypeNumberPad;
        twoCell.secondTextField.placeholder = @"Zip Code";
        twoCell.secondTextField.tag = OMBBillingInfoSectionAddressRowZip;
        twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [twoCell.firstTextField addTarget: self
          action: @selector(textFieldDidChange:)
            forControlEvents: UIControlEventEditingChanged];
        [twoCell.secondTextField addTarget: self
          action: @selector(textFieldDidChange:)
            forControlEvents: UIControlEventEditingChanged];
        twoCell.clipsToBounds = YES;
        
        return twoCell;
      }
      // Street
      else if(row == OMBBillingInfoSectionAddressRowStreet)
        labelString = @"street";
      // City
      else if(row == OMBBillingInfoSectionAddressRowCity)
        labelString = @"city";
      
      cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.iconImageView.frame.size];
      cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = [labelString capitalizedString];
      //cell.textField.text = [valueDictionary objectForKey: key];
      cell.textFieldLabel.text = [labelString capitalizedString];
      [cell.textField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      
      return cell;
    }
  }
  // Spacing
  else if(section == OMBBillingInfoSectionSpacing){
    emptycell.backgroundColor = UIColor.clearColor;
    emptycell.separatorInset = UIEdgeInsetsMake(0.0f,
      tableView.frame.size.width, 0.0f, 0.0f);
   
  }
  
  return emptycell;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  
  //textField.inputAccessoryView = textFieldToolbar;
  // [self scrollToRectAtIndexPath: textField.indexPath];
  
  // Last Name
  if (textField.indexPath.row == OMBBillingInfoSectionNameRowLastName)
    [self scrollToRectAtIndexPath:
      [NSIndexPath indexPathForRow:
        OMBBillingInfoSectionNameRowFirstName
          inSection:textField.indexPath.section]];
  // Zip
  else if(textField.indexPath.row == OMBBillingInfoSectionAddressRowZip){
    [self scrollToRectAtIndexPath:
      [NSIndexPath indexPathForRow:
         OMBBillingInfoSectionAddressRowState
           inSection:textField.indexPath.section]];
  }
  
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
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

- (void) doneFromInputAccessoryView
{
  [self cancelFromInputAccessoryView];
}

- (void)next
{
  
  NSLog(@"%s %@",__PRETTY_FUNCTION__, [valueDictionary description]);
  
  [self.navigationController pushViewController:
    [[OMBPayoutMethodCreditCardInfoViewController alloc] init] animated:YES];
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void) scrollToRectAtIndexPath: (NSIndexPath *) indexPath
{
  
  CGRect rect = [self.table rectForRowAtIndexPath: indexPath];
  rect.origin.y -= (OMBPadding);
  [self.table setContentOffset: rect.origin animated: YES];
  
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


- (void)textFieldDidChange:(TextFieldPadding *)textField
{
  NSInteger row     = textField.indexPath.row;
  NSInteger section = textField.indexPath.section;
  NSString *string = textField.text;
  
  if(section == OMBBillingInfoSectionName){
    if(row == OMBBillingInfoSectionNameRowLastName)
      [valueDictionary setObject: string forKey: @"lastName"];
    else
      [valueDictionary setObject: string forKey: @"firstName"];
    
  }
  else if(section == OMBBillingInfoSectionAddress){
    if (row == OMBBillingInfoSectionAddressRowStreet) {
      [valueDictionary setObject: string forKey: @"street"];
    }
    else if (row == OMBBillingInfoSectionAddressRowCity) {
      [valueDictionary setObject: string forKey: @"city"];
    }
    else if (row == OMBBillingInfoSectionAddressRowState){
      [valueDictionary setObject: string forKey: @"state"];
    }
    else if (row == OMBBillingInfoSectionAddressRowZip){
       [valueDictionary setObject: string forKey: @"zip"];
    }
  }
  
  BOOL enable = [valueDictionary count] >= 6;
  
  for(NSString *key in [valueDictionary allKeys]){
    
    if(![[valueDictionary objectForKey:key] length])
      enable = NO;
  }
  
  self.navigationItem.rightBarButtonItem.enabled = enable;
  
}

@end
