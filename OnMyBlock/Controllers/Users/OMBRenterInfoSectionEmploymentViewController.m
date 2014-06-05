//
//  OMBRenterInfoEmploymentViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionEmploymentViewController.h"

#import "NSString+OnMyBlock.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "OMBEmployment.h"
#import "OMBEmploymentCell.h"
#import "OMBNavigationController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddEmploymentViewController.h"
#import "UIFont+OnMyBlock.h"

@interface OMBRenterInfoSectionEmploymentViewController ()
{
  UIButton *linkedInButton;
  LIALinkedInHttpClient *linkedInClient;
}

@end

@implementation OMBRenterInfoSectionEmploymentViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;
  
  self.title = @"Work & School History";
  tagSection = OMBUserDefaultsRenterApplicationCheckedWorkHistory;
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [self screen];

  linkedInButton = [UIButton new];
  linkedInButton.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  linkedInButton.frame = CGRectMake(0.0f, 0.0f, 
    screen.size.width, OMBStandardButtonHeight);
  linkedInButton.titleLabel.font = [UIFont normalTextFontBold];
  [linkedInButton addTarget: self action: @selector(linkedInButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [linkedInButton setTitle: @"Connect my LinkedIn" 
    forState: UIControlStateNormal];
  [linkedInButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  self.table.tableHeaderView = linkedInButton;
  
  [self setEmptyLabelText: @"Have jobs or involved on campus?\n"
   @"Connect your LinkedIn or add them here."];
  
  [addButton setTitle: @"Add Employment" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Employment" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  key = OMBUserDefaultsRenterApplicationCheckedWorkHistory;
  
  [self fetchObjects];
  
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromDictionary: dictionary 
    forModelName: [OMBEmployment modelName]];
  [self reloadTable];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  
  static NSString *EmploymentID = @"EmploymentID";
  OMBEmploymentCell *cell = [tableView dequeueReusableCellWithIdentifier:
                           EmploymentID];
  if (!cell)
    cell = [[OMBEmploymentCell alloc] initWithStyle: UITableViewCellStyleDefault
                                  reuseIdentifier: EmploymentID];
  [cell loadData: [[self objects] objectAtIndex: row]];
  // Last row
  if (row == [self tableView: tableView numberOfRowsInSection: section] - 1) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  else {
    cell.separatorInset = tableView.separatorInset;
  }
  return cell;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBEmploymentCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController:
   [[OMBNavigationController alloc] initWithRootViewController:
    [[OMBRenterInfoAddEmploymentViewController alloc] init]] animated: YES
      completion: nil];
}

- (void) fetchObjects
{
  [self fetchObjectsForResourceName: [OMBEmployment resourceName]];
}

- (void) linkedInButtonSelected
{
  LIALinkedInApplication *app = 
    [LIALinkedInApplication applicationWithRedirectURL: @"https://onmyblock.com"
      clientId: @"75zr1yumwx0wld" clientSecret: @"XNY3VsMzvdhyR1ej"
        state: @"DCEEFWF45453sdffef424" grantedAccess: @[@"r_fullprofile"]];
  linkedInClient = [LIALinkedInHttpClient clientForApplication: app 
    presentingViewController: self];
  [linkedInClient getAuthorizationCode: ^(NSString *code) {
    [linkedInClient getAccessToken: code success: 
      ^(NSDictionary *accessTokenData) {
        NSString *accessToken = [accessTokenData objectForKey: @"access_token"];
        [user createAuthenticationForLinkedInWithAccessToken:
          accessToken completion: ^(NSError *error) {
            if (!error) {
              user.renterApplication.linkedinAuthenticated = YES;
              [self reloadTable];
              [self fetchObjects];
            }
            else {
              [self showAlertViewWithError: error];
            }
            [self containerStopSpinning];
          }
        ];
        [self containerStartSpinning];
      }
    failure: ^(NSError *error) {
      [self showAlertViewWithError: error];
    }];
  } cancel: ^{
    NSLog(@"LINKEDIN CANCELED");
  } failure: ^(NSError *error) {
    [self showAlertViewWithError: error];
  }];
}

- (NSArray *) objects
{
  return [[self renterApplication] objectsWithModelName: 
    [OMBEmployment modelName] sortedWithKey: @"startDate" ascending: NO];
}

- (void) reloadTable
{
  if (user.renterApplication.linkedinAuthenticated)
    self.table.tableHeaderView = [[UIView alloc] initWithFrame: CGRectZero];
  else
    self.table.tableHeaderView = linkedInButton;
  [self.table reloadData];
}

@end
