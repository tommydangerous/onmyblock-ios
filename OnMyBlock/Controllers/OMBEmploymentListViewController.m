//
//  OMBEmploymentViewController.m
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEmploymentListViewController.h"

#import "OMBDeleteRenterApplicationSectionModelConnection.h"
#import "OMBEmployment.h"
#import "OMBEmploymentCell.h"
#import "OMBEmploymentAddViewController.h"
#import "OMBEmploymentListConnection.h"
#import "OMBNavigationController.h"
#import "OMBWebViewController.h"

@implementation OMBEmploymentListViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  self.screenName = self.title = @"Employment";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setAddBarButtonItem];
  
  sheet = [[UIActionSheet alloc] initWithTitle: nil 
    delegate: self cancelButtonTitle: @"Cancel" 
      destructiveButtonTitle: @"Remove Employment" otherButtonTitles: nil];
  [self.view addSubview: sheet];

  [self setupForTable];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  OMBEmploymentListConnection *connection =
    [[OMBEmploymentListConnection alloc] initWithUser: user];
  connection.completionBlock = ^(NSError *error) {
    if ([[user.renterApplication employmentsSortedByStartDate] count] == 0 &&
      !showedAddModelViewControllerForTheFirstTime) {
      
      showedAddModelViewControllerForTheFirstTime = YES;
      [self addModel];
    }
    else
      [self.table reloadData];
  };
  [connection start];
  
  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  // Remove cosigner
  if (buttonIndex == 0) {
    [self.table beginUpdates];
    OMBEmployment *object = 
      [[user.renterApplication employmentsSortedByStartDate] objectAtIndex:
        selectedIndexPath.row];
    // Delete connection
    [[[OMBDeleteRenterApplicationSectionModelConnection alloc]
      initWithObject: object] start];
    // Remove employment from user's employments
    [user.renterApplication.employments removeObject: object];
    // Delete the row
    [self.table deleteRowsAtIndexPaths: @[selectedIndexPath]
      withRowAnimation: UITableViewRowAnimationFade];
    [self.table endUpdates];
    selectedIndexPath = nil;
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBEmploymentCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBEmploymentCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  [cell loadData: 
    [[user.renterApplication employmentsSortedByStartDate] 
      objectAtIndex: indexPath.row]];
  cell.delegate = self;
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[user.renterApplication employmentsSortedByStartDate] count];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  OMBEmployment *employment = 
    [[user.renterApplication employmentsSortedByStartDate] objectAtIndex: 
      indexPath.row];
  float padding  = 20.0f;
  CGFloat height = padding + 22.0f + padding;
  if ([employment.title length] > 0 || employment.income)
    height += 22.0f;
  if (employment.startDate)
    height += 22.0f;
  // Padding top              = 20
  // Company name and website = 22
  // Title and income         = 22
  // Start date and end date  = 22
  // Padding bottom           = 20
  return height;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addModel
{
  OMBEmploymentAddViewController *viewController =
    [[OMBEmploymentAddViewController alloc] init];
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      viewController] animated: YES
        completion: ^{
          [viewController firstTextFieldBecomeFirstResponder];
        }];
}

- (void) showCompanyWebsiteWebViewForEmployment: (OMBEmployment *) employment
{
  NSURL *url = [NSURL URLWithString: [employment companyWebsiteString]];
  NSURLRequest *request = [NSURLRequest requestWithURL: url];
  OMBWebViewController *webViewController = [[OMBWebViewController alloc] init];
  webViewController.title = [employment.companyName capitalizedString];
  [webViewController.webView loadRequest: request];
  [self.navigationController pushViewController: webViewController 
    animated: YES];
}

@end
