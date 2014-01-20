//
//  OMBHomebaseRenterAddRoommatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterAddRoommatesViewController.h"

#import "OMBImageOneLabelCell.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterAddRoommatesViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Add Roommate";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  // CGRect screen = [[UIScreen mainScreen] bounds];
  // CGFloat screenWidth = screen.size.width;
  CGFloat padding = 10.0f;
  CGFloat standardHeight = padding + 15.0f + padding;

  UIView *headerView = [UIView new];
  headerView.backgroundColor = self.table.backgroundColor;
  headerView.frame = CGRectMake(0.0f, 0.0f, 
    self.table.frame.size.width, padding + standardHeight + padding);
  self.table.tableHeaderView = headerView;
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
  bottomBorder.frame = CGRectMake(0.0f, headerView.frame.size.height - 1.0f,
    headerView.frame.size.width, 1.0f);
  [headerView.layer addSublayer: bottomBorder];

  searchTextField = [[TextFieldPadding alloc] init];
  searchTextField.backgroundColor = [UIColor whiteColor];
  searchTextField.delegate = self;
  searchTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  searchTextField.frame = CGRectMake(padding, padding, 
    headerView.frame.size.width - (padding * 2), standardHeight);
  searchTextField.layer.borderColor = [UIColor grayLight].CGColor;
  searchTextField.layer.borderWidth = 1.0f;
  searchTextField.layer.cornerRadius = 5.0f;
  searchTextField.paddingX = padding;
  searchTextField.placeholder = @"Type here to search";
  searchTextField.returnKeyType = UIReturnKeySearch;
  [headerView addSubview: searchTextField];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  [searchTextField becomeFirstResponder];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  [self.view endEditing: YES];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Roommates
  // Add Roommates
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBImageOneLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBImageOneLabelCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  CGSize size = CGSizeMake(38.0f, 38.0f);
  [cell setImage: [[OMBUser fakeUser] imageForSizeKey: 
    [NSString stringWithFormat: @"%f, %f", size.width, size.height]]
      text: [[OMBUser fakeUser] fullName]];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 10;
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
  return [OMBImageOneLabelCell heightForCell];
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) searchFromContacts
{
  self.screenName = self.title = @"Add From Contacts";
}

- (void) searchFromFacebook
{
  self.screenName = self.title = @"Add From Facebook";
}

- (void) searchFromOnMyBlock
{
  self.screenName = self.title = @"Add From OnMyBlock";
}


@end
