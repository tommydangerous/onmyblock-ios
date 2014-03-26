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
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@implementation OMBPayoutMethodEditViewController

#pragma mark - Initializer

- (id) initWithPayoutMethod: (OMBPayoutMethod *) object
{
  if (!(self = [super init])) return nil;

  payoutMethod = object;
  deposit = payoutMethod.deposit;
  primary = payoutMethod.primary;

  CGRect rect = [@"Email" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFont]];
  sizeForLabelTextFieldCell = rect.size;

  self.screenName = @"Edit Payout Method";
  NSString *string;
  if ([[payoutMethod.payoutType lowercaseString] isEqualToString: @"paypal"])
    string = @"PayPal";
  else if ([[payoutMethod.payoutType lowercaseString] isEqualToString: 
    @"venmo"])
    string = @"Venmo";
  else if ([[payoutMethod.payoutType lowercaseString] isEqualToString:
     @"credit_card"])
    string = @"Credit Card";
  self.title = [NSString stringWithFormat: @"Edit %@", string];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  saveBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: [UIFont boldSystemFontOfSize: 17]
  } forState: UIControlStateNormal];
  // self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding = OMBPadding;
  CGFloat width = screenWidth - (padding * 2);

  [self setupForTable];

  self.table.scrollEnabled = NO;
  self.table.tableHeaderView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, self.table.frame.size.width, OMBStandardHeight)];

  CGFloat pbvOriginY = padding + OMBStandardHeight + (OMBStandardHeight * 4);
  primaryButtonView = [UIView new];
  primaryButtonView.frame = CGRectMake(0.0f, pbvOriginY,
    screenWidth, screenHeight - pbvOriginY);
  [self.view addSubview: primaryButtonView];

  UILabel *label1 = [UILabel new];
  label1.font = [UIFont normalTextFont];
  label1.frame = CGRectMake(padding, 0.0f, width, 22.0f);
  label1.text = @"Would you like to use this account";
  label1.textColor = [UIColor textColor];
  label1.textAlignment = NSTextAlignmentCenter;
  [primaryButtonView addSubview: label1];

  UILabel *label2 = [UILabel new];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x,
    label1.frame.origin.y + label1.frame.size.height,
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"as your primary funding source";
  label2.textColor = label1.textColor;
  label2.textAlignment = label1.textAlignment;
  [primaryButtonView addSubview: label2];

  UILabel *label3 = [UILabel new];
  label3.font = label1.font;
  label3.frame = CGRectMake(label1.frame.origin.x,
    label2.frame.origin.y + label2.frame.size.height,
      label1.frame.size.width, label1.frame.size.height);
  label3.text = @"to make and receive payments?";
  label3.textColor = label1.textColor;
  label3.textAlignment = label1.textAlignment;
  [primaryButtonView addSubview: label3];

  primaryButton = [UIButton new];
  primaryButton.backgroundColor = [UIColor blue];
  primaryButton.clipsToBounds = YES;
  primaryButton.frame = CGRectMake(padding, 
    label3.frame.origin.y + label3.frame.size.height + OMBStandardHeight, 
      width, OMBStandardButtonHeight);
  primaryButton.layer.cornerRadius = OMBCornerRadius;
  primaryButton.titleLabel.font = [UIFont mediumTextFont];
  [primaryButton addTarget: self action: @selector(setAsPrimary)
    forControlEvents: UIControlEventTouchUpInside];
  [primaryButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [primaryButton setTitle: @"Set as Primary Funding Source"
    forState: UIControlStateNormal];
  [primaryButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [primaryButtonView addSubview: primaryButton];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (payoutMethod.primary)
    primaryButtonView.hidden = YES;
  else
    primaryButtonView.hidden = NO;
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
      UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier];
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
    // [cell.contentView addSubview: switchButton];
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
  cell.detailTextLabel.font = [UIFont normalTextFontBold];
  cell.detailTextLabel.text = @"";
  cell.detailTextLabel.textColor = [UIColor blueDark];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont normalTextFont];
  cell.textLabel.textColor = [UIColor textColor];
  // Primary
  if (indexPath.row == 0) {
    // cell.textLabel.text = @"Primary method";
    // if (payoutMethod.primary)
    //   cell.detailTextLabel.text = @"Yes";
    // else
    //   cell.detailTextLabel.text = @"No";
    // switchButton.on = primary ? YES : NO;
    // [switchButton removeTarget: self action: @selector(changeDeposit:)
    //   forControlEvents: UIControlEventValueChanged];
    // [switchButton addTarget: self action: @selector(changePrimary:)
    //   forControlEvents: UIControlEventValueChanged];
    // [topBorder removeFromSuperview];
    // [cell.contentView addSubview: topBorder];
    static NSString *PrimaryID = @"PrimaryID";
    OMBLabelTextFieldCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
      PrimaryID];
    if (!cell1) {
      cell1 = [[OMBLabelTextFieldCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: PrimaryID];
      [cell1 setFramesUsingString: @"Primary funding source"];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    if (payoutMethod.primary)
      cell1.textField.text = @"Yes";
    else
      cell1.textField.text = @"No";
    cell1.textField.font = [UIFont normalTextFontBold];
    cell1.textField.textAlignment = NSTextAlignmentRight;
    cell1.textField.textColor = [UIColor blueDark];
    cell1.textField.userInteractionEnabled = NO;
    cell1.textFieldLabel.text = @"Primary funding source";
    [topBorder removeFromSuperview];
    [cell1.contentView addSubview: topBorder];
    return cell1;
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
      [cell1 setFrameUsingSize: sizeForLabelTextFieldCell];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.textField.text = [payoutMethod.email lowercaseString];
    cell1.textField.textAlignment = NSTextAlignmentRight;
    cell1.textField.textColor = [UIColor grayMedium];
    cell1.textField.userInteractionEnabled = NO;
    cell1.textFieldLabel.text = @"Email";
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
  if (indexPath.section == 0 && indexPath.row == 1)
    return 0.0f;
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

- (void) setAsPrimary
{
  payoutMethod.primary = YES;
  OMBPayoutMethodUpdateConnection *conn =
    [[OMBPayoutMethodUpdateConnection alloc] initWithPayoutMethod:
      payoutMethod attributes: @[@"primary"]];
  conn.completionBlock = ^(NSError *error) {
    if (payoutMethod.primary == YES && !error) {
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
