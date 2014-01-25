//
//  OMBPayoutMethodEditViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodEditViewController.h"

#import "OMBLabelTextFieldCell.h"
#import "OMBPayoutMethod.h"
#import "OMBPayoutMethodUpdateConnection.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"

@implementation OMBPayoutMethodEditViewController

#pragma mark - Initializer

- (id) initWithPayoutMethod: (OMBPayoutMethod *) object
{
  if (!(self = [super init])) return nil;

  payoutMethod = object;
  deposit = payoutMethod.deposit;
  primary = payoutMethod.primary;

  self.screenName = @"Edit Payout Method";
  NSString *string;
  if ([[payoutMethod.payoutType lowercaseString] isEqualToString: @"paypal"])
    string = @"PayPal";
  else if ([[payoutMethod.payoutType lowercaseString] isEqualToString: 
    @"venmo"])
    string = @"Venmo";
  self.title = [NSString stringWithFormat: @"Edit %@", string];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  UIBarButtonItem *saveBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont boldSystemFontOfSize: 17]
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  [self setupForTable];

  self.table.tableHeaderView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, self.table.frame.size.width, 44.0f)];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  // Switch
  NSInteger switchTag = 9999;
  UISwitch *switchButton = (UISwitch *) [cell.contentView viewWithTag: 
    switchTag];
  if (!switchButton) {
    switchButton = [UISwitch new];
    switchButton.frame = CGRectMake(
      tableView.frame.size.width - (switchButton.frame.size.width + 20), 
        (44 - switchButton.frame.size.height) * 0.5f,
          switchButton.frame.size.width, switchButton.frame.size.height);
    switchButton.onTintColor = [UIColor blue];
    switchButton.tag = switchTag;
    [cell.contentView addSubview: switchButton];
  }
  // Top border
  NSInteger topBorderTag = 9998;
  UIView *topBorder = [cell.contentView viewWithTag: topBorderTag];
  if (!topBorder) {
    topBorder = [UIView new];
    topBorder.backgroundColor = tableView.separatorColor;
    topBorder.frame = CGRectMake(0.0f, 0.0f, 
      tableView.frame.size.width, 0.5f);
    topBorder.tag = topBorderTag;
  }
  // Bottom border
  NSInteger bottomBorderTag = 9997;
  UIView *bottomBorder = [cell.contentView viewWithTag: bottomBorderTag];
  if (!bottomBorder) {
    bottomBorder = [UIView new];
    bottomBorder.backgroundColor = tableView.separatorColor;
    bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
      tableView.frame.size.width, 0.5f);
    bottomBorder.tag = bottomBorderTag;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  cell.textLabel.textColor = [UIColor textColor];
  // Primary
  if (indexPath.row == 0) {
    cell.textLabel.text = @"Primary method";
    switchButton.on = primary ? YES : NO;
    [switchButton removeTarget: self action: @selector(changeDeposit:)
      forControlEvents: UIControlEventValueChanged];
    [switchButton addTarget: self action: @selector(changePrimary:)
      forControlEvents: UIControlEventValueChanged];
    [topBorder removeFromSuperview];
    [cell.contentView addSubview: topBorder];
  }
  // Deposit
  else if (indexPath.row == 1) {
    cell.textLabel.text = @"Deposit method";
    switchButton.on = deposit ? YES : NO;
    [switchButton removeTarget: self action: @selector(changePrimary:)
      forControlEvents: UIControlEventValueChanged];
    [switchButton addTarget: self action: @selector(changeDeposit:)
      forControlEvents: UIControlEventValueChanged];
  }
  // Email
  else if (indexPath.row == 2) {
    static NSString *LabelCellIdentifier = @"LabelCellIdentifier";
    OMBLabelTextFieldCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
      LabelCellIdentifier];
    if (!cell1) {
      cell1 = [[OMBLabelTextFieldCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: LabelCellIdentifier];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.textField.text = [payoutMethod.email lowercaseString];
    cell1.textField.textAlignment = NSTextAlignmentRight;
    cell1.textField.textColor = [UIColor grayMedium];
    cell1.textField.userInteractionEnabled = NO;
    cell1.textFieldLabel.text = @"Email";
    [cell1 setFramesUsingString: @"Email"];
    [bottomBorder removeFromSuperview];
    [cell1.contentView addSubview: bottomBorder];
    return cell1;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Primary
  // Deposit
  // Email
  return 3;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) changeDeposit: (UISwitch *) button
{
  deposit = button.on ? YES : NO;
}

- (void) changePrimary: (UISwitch *) button
{
  primary = button.on ? YES : NO;
}

- (void) save
{
  // If payout method is the primary and user is making it not primary
  // or if payout method is primary and is changing the deposit/payment type
  if ((payoutMethod.primary && !primary) || 
    (payoutMethod.primary && payoutMethod.deposit == !deposit)) {
    NSArray *array;
    if (deposit)
      array = [[OMBUser currentUser] depositPayoutMethods];
    else
      array = [[OMBUser currentUser] paymentPayoutMethods];
    if ([array count] < 2) {
      NSString *title = @"Whoops";
      NSString *message = [NSString stringWithFormat:
        @"Please have at least one primary %@ method.", 
          deposit ? @"deposit" : @"payment"];
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
        message: message delegate: nil cancelButtonTitle: @"OK" 
          otherButtonTitles: nil];
      [alertView show];

      UITableViewCell *cell1 = [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 0 inSection: 0]];
      UISwitch *switchButton1 = 
        (UISwitch *) [cell1.contentView viewWithTag: 9999];
      [switchButton1 setOn: payoutMethod.primary animated: YES];

      UITableViewCell *cell2 = [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 1 inSection: 0]];
      UISwitch *switchButton2 = 
        (UISwitch *) [cell2.contentView viewWithTag: 9999];
      [switchButton2 setOn: payoutMethod.deposit animated: YES];
      return;
    }
  }
  payoutMethod.deposit = deposit;
  payoutMethod.primary = primary;

  OMBPayoutMethodUpdateConnection *conn =
    [[OMBPayoutMethodUpdateConnection alloc] initWithPayoutMethod:
      payoutMethod attributes: @[@"deposit", @"primary"]];
  conn.completionBlock = ^(NSError *error) {
    if (payoutMethod.deposit == deposit && 
      payoutMethod.primary == primary && !error) {
      // Make all other payout methods that are primary and the 
      // same deposit (or payment) not primary
      if (payoutMethod.primary)
        [[OMBUser currentUser] changeOtherSamePrimaryPayoutMethods:
          payoutMethod];
      [self.navigationController popViewControllerAnimated: YES];
    }
    else {
      [self showAlertViewWithError: error];
    }
    [[self appDelegate].container stopSpinning];
  };
  [[self appDelegate].container startSpinning];
  [conn start];
}

@end
