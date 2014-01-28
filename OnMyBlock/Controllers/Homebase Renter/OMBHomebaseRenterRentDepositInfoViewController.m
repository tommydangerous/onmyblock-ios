//
//  OMBHomebaseRenterRentDepositInfoViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterRentDepositInfoViewController.h"

#import "DRNRealTimeBlurView.h"
#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBHomebaseRenterAddRemoveRoommatesViewController.h"
#import "OMBHomebaseRenterViewController.h"
#import "OMBRentDepositInfoCell.h"
#import "OMBResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIImage+Color.h"

@implementation OMBHomebaseRenterRentDepositInfoViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Rent & Deposit Info";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  doneBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  saveBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  self.view.backgroundColor = [UIColor clearColor];
  [self setupForTable];
  self.table.backgroundColor = [UIColor clearColor];

  CGRect screen        = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;

  // Back view that will move up and down
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, 0.0f, screenWidth, 
    padding + standardHeight + (screenHeight * 0.4f) + 
    standardHeight + padding);
  [self.view insertSubview: backView belowSubview: self.table];
  // Residence image view
  residenceImageView = [[OMBCenteredImageView alloc] init];
  residenceImageView.frame = backView.frame;
  residenceImageView.image = [OMBResidence fakeResidence].coverPhoto;
  [backView addSubview: residenceImageView];
  // Black tint
  UIView *colorView = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  colorView.frame = residenceImageView.frame;
  [backView addSubview: colorView];
  // Blur
  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];

  blurView.frame = residenceImageView.frame;  
  blurView.renderStatic = YES;
  [backView addSubview: blurView];

  UIView *tableHeaderView = [UIView new];
  tableHeaderView.frame = CGRectMake(0.0f, 0.0f, screenWidth,
    padding + standardHeight + (screenHeight * 0.4f));
  self.table.tableHeaderView = tableHeaderView;

  CGFloat topSpacing = ((screenHeight * 0.4f) - ((22.0f * 2.5) * 3)) * 0.5f;
  // First Month Rent Label
  firstMonthRentLabel = [UILabel new];
  firstMonthRentLabel.frame = CGRectMake(padding, 
    padding + standardHeight + topSpacing,
      tableHeaderView.frame.size.width - (padding * 2), 22.0f * 2.5);
  NSMutableAttributedString *aString1 = (NSMutableAttributedString *)
    [@"First Month's Rent" attributedStringWithFont: 
      [UIFont fontWithName: @"HelveticaNeue-Light" size: 22] 
        lineHeight: 26];
  [aString1 appendAttributedString: [@" $1,750" attributedStringWithFont:
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 24] 
      lineHeight: 26]];
  firstMonthRentLabel.attributedText = aString1;
  firstMonthRentLabel.textColor = [UIColor whiteColor];
  [tableHeaderView addSubview: firstMonthRentLabel];

  // Deposit Label
  depositLabel = [UILabel new];
  depositLabel.frame = CGRectMake(firstMonthRentLabel.frame.origin.x,
    firstMonthRentLabel.frame.origin.y + firstMonthRentLabel.frame.size.height,
      firstMonthRentLabel.frame.size.width, 
        firstMonthRentLabel.frame.size.height);
  NSMutableAttributedString *aString2 = (NSMutableAttributedString *)
    [@"Deposit" attributedStringWithFont: 
      [UIFont fontWithName: @"HelveticaNeue-Light" size: 22] 
        lineHeight: 26];
  [aString2 appendAttributedString: [@" $3,250" attributedStringWithFont:
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 24] 
      lineHeight: 26]];
  depositLabel.attributedText = aString2;
  depositLabel.textColor = firstMonthRentLabel.textColor;
  [tableHeaderView addSubview: depositLabel];

  // Due label
  dueLabel = [UILabel new];
  dueLabel.frame = CGRectMake(depositLabel.frame.origin.x,
    depositLabel.frame.origin.y + depositLabel.frame.size.height,
      depositLabel.frame.size.width,
        depositLabel.frame.size.height);
  NSMutableAttributedString *aString3 = (NSMutableAttributedString *)
    [@"Due in" attributedStringWithFont: 
      [UIFont fontWithName: @"HelveticaNeue-Light" size: 22] 
        lineHeight: 26];
  [aString3 appendAttributedString: 
    [@" 3 weeks 5 days" attributedStringWithFont:
      [UIFont fontWithName: @"HelveticaNeue-Medium" size: 24] 
        lineHeight: 26]];
  dueLabel.attributedText = aString3;
  dueLabel.textColor = depositLabel.textColor;
  [tableHeaderView addSubview: dueLabel];

  CGFloat cellLabelWidth = (screenWidth - (padding * 4)) / 3.0f;
  // Total deposit label
  totalDepositLabel = [UILabel new];
  totalDepositLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 20];
  totalDepositLabel.frame = CGRectMake(padding + cellLabelWidth + padding, 0.0f,
    cellLabelWidth, standardHeight);
  totalDepositLabel.text = @"$1,525";
  totalDepositLabel.textColor = [UIColor blueDark];
  totalDepositLabel.textAlignment = NSTextAlignmentCenter;
  // Total rent label
  totalRentLabel = [UILabel new];
  totalRentLabel.font = totalDepositLabel.font;
  totalRentLabel.frame = CGRectMake(
    totalDepositLabel.frame.origin.x + totalDepositLabel.frame.size.width + 
    padding, totalDepositLabel.frame.origin.y,
      totalDepositLabel.frame.size.width, totalDepositLabel.frame.size.height);
  totalRentLabel.text = @"$725";
  totalRentLabel.textColor = totalDepositLabel.textColor;
  totalRentLabel.textAlignment = totalDepositLabel.textAlignment;

  // Add/Remove Roommates
  addButton = [UIButton new];
  addButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.95f];
  addButton.clipsToBounds = YES;
  addButton.frame = CGRectMake(padding, 
    screenHeight - (standardHeight + padding), screenWidth - (padding * 2),
      standardHeight);
  addButton.layer.borderColor = [UIColor blue].CGColor;
  addButton.layer.borderWidth = 1.0f;
  addButton.layer.cornerRadius = addButton.frame.size.height * 0.5f;
  addButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  [addButton setBackgroundImage: [UIImage imageWithColor: [UIColor blue]]
    forState: UIControlStateHighlighted];
  [addButton addTarget: self action: @selector(showAddRemoveRoommates)
    forControlEvents: UIControlEventTouchUpInside];
  [addButton setTitle: @"Add/Remove Roommates" forState: UIControlStateNormal];
  [addButton setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [addButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [self.view addSubview: addButton];

  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, self.table.frame.size.width, 
      padding + addButton.frame.size.height + padding)];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat y = scrollView.contentOffset.y;

  CGRect backViewRect = backView.frame;
  backViewRect.origin.y = 0.0f - (y / 3.0f);
  backView.frame = backViewRect;
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Rent Deposit
  // Price splitting
  // Total
  // Spacing for editing
  return 4;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat width = (screenWidth - (padding * 4)) / 3.0f;

  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  // Rent Deposit
  if (indexPath.section == 0) {
    static NSString *HeaderCellIdentifier = @"HeaderCellIdentifier";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
      HeaderCellIdentifier];
    if (!cell1) {
      cell1 = [[UITableViewCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: HeaderCellIdentifier];
      // Deposit
      UILabel *dLabel = [UILabel new];
      dLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 17];
      dLabel.frame = CGRectMake(padding + width + padding, 0.0f, 
        width, standardHeight);
      dLabel.text = @"Deposit";
      dLabel.textAlignment = NSTextAlignmentCenter;
      dLabel.textColor = [UIColor grayMedium];
      [cell1.contentView addSubview: dLabel];
      if (editingRentalPayments) {
        dLabel.hidden = YES;
      }
      // Rent
      UILabel *rLabel = [UILabel new];
      rLabel.font = dLabel.font;
      rLabel.frame = CGRectMake(
        dLabel.frame.origin.x + dLabel.frame.size.width + padding,
          dLabel.frame.origin.y, dLabel.frame.size.width, 
            dLabel.frame.size.height);
      rLabel.text = @"Rent";
      rLabel.textAlignment = dLabel.textAlignment;
      rLabel.textColor = dLabel.textColor;
      [cell1.contentView addSubview: rLabel];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell1;
  }
  // Price splitting
  else if (indexPath.section == 1) {
    static NSString *RentDepositIdentifier = @"RentDepositIdentifier";
    OMBRentDepositInfoCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: RentDepositIdentifier];
    if (!cell1)
      cell1 = [[OMBRentDepositInfoCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: RentDepositIdentifier];
    if (indexPath.row == 0) {
      cell1.nameLabel.text = @"You";
    }
    else if (indexPath.row == 1) {
      cell1.nameLabel.text = @"Jonathan";
    }
    else if (indexPath.row == 2) {
      cell1.nameLabel.text = @"Marvin";
    }
    if (editingRentalPayments) {
      cell1.depositTextField.hidden = YES;
    }
    else {
      cell1.depositTextField.delegate = self;
      cell1.depositTextField.tag = indexPath.row;
    }
    cell1.rentTextField.delegate = self;
    cell1.rentTextField.tag    = indexPath.row;
    return cell1;
  }
  // Total
  else if (indexPath.section == 2) {
    static NSString *TotalCellIdentifier = @"TotalCellIdentifier";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
      TotalCellIdentifier];
    [totalDepositLabel removeFromSuperview];
    [totalRentLabel removeFromSuperview];
    if (!cell1) {
      cell1 = [[UITableViewCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: TotalCellIdentifier];
      // Total
      UILabel *totalLabel = [UILabel new];
      totalLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 20];
      totalLabel.frame = CGRectMake(padding, 0.0f, width, standardHeight);
      totalLabel.text = @"Total";
      totalLabel.textColor = [UIColor textColor];
      [cell1.contentView addSubview: totalLabel];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    // Total Deposit label
    [cell1.contentView addSubview: totalDepositLabel];
    // Total Rent label
    [cell1.contentView addSubview: totalRentLabel];
    return cell1;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Rent Deposit
  if (section == 0) {
    return 1;
  }
  // Price splitting
  else if (section == 1) {
    return 3;
  }
  // Total
  else if (section == 2) {
    return 1;
  }
  // Spacing for editing
  else if (section == [tableView numberOfSections] - 1) {
    return 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat standardHeight = 44.0f;
  // Rent Deposit
  if (indexPath.section == 0) {
    return standardHeight;
  }
  // Price splitting
  else if (indexPath.section == 1) {
    return [OMBRentDepositInfoCell heightForCell];
  }
  // Total
  else if (indexPath.section == 2) {
    return standardHeight;
  }
  // Spacing for editing
  else if (indexPath.section == [tableView numberOfSections] - 1) {
    if (isEditing) {
      return 216.0f;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  isEditing = YES;
  [self.table reloadRowsAtIndexPaths: @[
    [NSIndexPath indexPathForRow: 0 
        inSection: [self.table numberOfSections] - 1] 
  ] withRowAnimation: UITableViewRowAnimationFade];
  // Scroll to that row
  [self.table scrollToRowAtIndexPath: 
    [NSIndexPath indexPathForRow: textField.tag inSection: 1]
      atScrollPosition: UITableViewScrollPositionMiddle animated: YES];
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) done
{
  [self.view endEditing: YES];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  isEditing = NO;
  [self.table reloadRowsAtIndexPaths: @[
    [NSIndexPath indexPathForRow: 0 
        inSection: [self.table numberOfSections] - 1] 
  ] withRowAnimation: UITableViewRowAnimationFade];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
}

- (void) save
{
  OMBHomebaseRenterViewController *vc = 
    (OMBHomebaseRenterViewController *) _delegate;
  [vc switchToPaymentsTableView];
  [self.navigationController popViewControllerAnimated: YES];

  NSLog(@"REMOVE THIS");
  [[self appDelegate].container showOfferAccepted];
}

- (void) setupForEditRentalPayments
{
  editingRentalPayments = YES;

  CGRect screen        = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  // CGFloat screenWidth  = screen.size.width;

  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat topSpacing = ((screenHeight * 0.4f) - ((22.0f * 2.5) * 2)) * 0.5f;

  // Rent
  NSMutableAttributedString *aString1 = (NSMutableAttributedString *)
    [@"Next Month's Rent" attributedStringWithFont: 
      [UIFont fontWithName: @"HelveticaNeue-Light" size: 22] 
        lineHeight: 26];
  [aString1 appendAttributedString: [@" $1,750" attributedStringWithFont:
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 24] 
      lineHeight: 26]];
  firstMonthRentLabel.attributedText = aString1;
  firstMonthRentLabel.frame = CGRectMake(firstMonthRentLabel.frame.origin.x, 
    padding + standardHeight + topSpacing, firstMonthRentLabel.frame.size.width,
      firstMonthRentLabel.frame.size.height);

  // Deposit
  depositLabel.hidden = YES;

  // Due
  NSMutableAttributedString *aString3 = (NSMutableAttributedString *)
    [@"Due in" attributedStringWithFont: 
      [UIFont fontWithName: @"HelveticaNeue-Light" size: 22] 
        lineHeight: 26];
  [aString3 appendAttributedString: 
    [@" 1 week 3 days" attributedStringWithFont:
      [UIFont fontWithName: @"HelveticaNeue-Medium" size: 24] 
        lineHeight: 26]];
  dueLabel.attributedText = aString3;
  dueLabel.frame = CGRectMake(dueLabel.frame.origin.x, 
    firstMonthRentLabel.frame.origin.y + firstMonthRentLabel.frame.size.height, 
      dueLabel.frame.size.width, dueLabel.frame.size.height);

  // Total deposit label
  totalDepositLabel.hidden = YES;

  [self.table reloadData];
}

- (void) showAddRemoveRoommates
{
  [self.navigationController pushViewController: 
    [[OMBHomebaseRenterAddRemoveRoommatesViewController alloc] init] 
      animated: YES];
}

@end
