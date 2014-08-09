//
//  OMBRenterInfoSectionRoommatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionRoommateViewController.h"

#import "NSString+OnMyBlock.h"
#import "OMBNavigationController.h"
#import "OMBUserDetailViewController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddRoommateViewController.h"
#import "OMBRoommate.h"
#import "OMBRoommateCell.h"

// Categories
#import "OMBGroup+Users.h"

// Connections
#import "OMBModelListConnection.h"

// Models
#import "OMBGroup.h"
#import "OMBUser+Groups.h"

@interface OMBRenterInfoSectionRoommateViewController ()
<OMBGroupUsersDelegate, OMBUserGroupsDelegate>
{
  UIActionSheet *profileDeleteActionSheet;
  NSIndexPath *selectedIndexPath;
}

@end

@implementation OMBRenterInfoSectionRoommateViewController

#pragma mark - Initializer

- (id)initWithUser:(OMBUser *)object
{
  if (!(self = [super initWithUser:object])) return nil;

  self.title = @"Roommates";
  tagSection = 1;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) viewDidLoad
{
  [super viewDidLoad];

  [self setEmptyLabelText:
    @"When you add a co-applicant, \n"
    @"we will send them an invitation \n"
    @"to fill out their renter profiles."
  ];

  [addButton setTitle:@"Add Co-applicant" forState:UIControlStateNormal];
  [addButtonMiddle setTitle:@"Add Co-applicant"
    forState:UIControlStateNormal];
  
  profileDeleteActionSheet = [[UIActionSheet alloc] initWithTitle:nil 
    delegate:self cancelButtonTitle:@"Cancel" 
      destructiveButtonTitle:@"View Profile" 
        otherButtonTitles:@"Delete", nil];
  profileDeleteActionSheet.destructiveButtonIndex = 1;
  [self.view addSubview:profileDeleteActionSheet];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  key = OMBUserDefaultsRenterApplicationCheckedCoapplicants;

  [self fetchObjects];

  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBGroupDelegate

- (void)deleteUserFailed:(NSError *)error
{
  [self showAlertViewWithError:error];
  [self refresh];
}

- (void)deleteUserSucceeded
{
  [self refresh];
}

#pragma mark - Protocol OMBUserGroupsDelegate

- (void)groupsFetchedFailed:(NSError *)error
{
  [self showAlertViewWithError:error];
  [self refresh];
}

- (void)groupsFetchedSucceeded
{
  [self refresh];
}

#pragma mark - Protocol UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (actionSheet == profileDeleteActionSheet) {
    OMBUser *aUser = [self userAtIndexPath:selectedIndexPath];
    // View Profile
    if (buttonIndex == 0) {
      [self.navigationController pushViewController:
        [[OMBUserDetailViewController alloc] initWithUser:aUser] animated:YES];
    }
    // Delete
    else if (buttonIndex == 1) {
      OMBGroup *group = [self groupAtIndexPath:selectedIndexPath];
      [group deleteUser:aUser accessToken:user.accessToken 
        delegate:self];
      selectedIndexPath = nil;
      [self startSpinning];
    }
  }
  else {
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self objects] count];
}

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  OMBGroup *group = 
    [self groupAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
  return [group.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;

  static NSString *RoommateID = @"RoommateID";
  OMBRoommateCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:RoommateID];
  if (!cell) {
    cell = [[OMBRoommateCell alloc] initWithStyle:UITableViewCellStyleDefault
      reuseIdentifier:RoommateID];
  }
  [cell loadDataFromUser:[self userAtIndexPath:indexPath]];
  if (row == [self tableView:tableView numberOfRowsInSection:section] - 1) {
    cell.separatorInset = UIEdgeInsetsMake(
      0, CGRectGetWidth(tableView.frame), 0, 0
    );
  }
  else {
    cell.separatorInset = tableView.separatorInset;
  }
  return cell;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [OMBRoommateCell heightForCell];
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedIndexPath = indexPath;
  [profileDeleteActionSheet showInView:self.view];

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addButtonSelected
{
  [self presentViewController:
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBRenterInfoAddRoommateViewController alloc] init]] animated: YES
        completion: nil];
}

- (void)fetchObjects
{
  [user fetchGroupsWithAccessToken:[OMBUser currentUser].accessToken 
    delegate:self];
  if ([[self objects] count] == 0) {
    [self startSpinning];
  }
}

- (NSArray *)objects
{
  return [user.groups allValues];
}

#pragma mark - Private

- (OMBGroup *)groupAtIndexPath:(NSIndexPath *)indexPath
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name"
    ascending:YES];
  return [[[self objects] sortedArrayUsingDescriptors:
    @[sort]] objectAtIndex:indexPath.section];
}

- (void)refresh
{
  [self hideEmptyLabel:[[self users] count]];
  [self stopSpinning];
  [self reloadTable];
}

- (void)reloadTable
{
  [self.table reloadData];
}

- (OMBUser *)userAtIndexPath:(NSIndexPath *)indexPath
{
  OMBGroup *group = [self groupAtIndexPath:indexPath];
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
    ascending:YES];
  return [[[group.users allValues] sortedArrayUsingDescriptors:
    @[sort]] objectAtIndex:indexPath.row];
}

- (NSArray *)users
{
  NSMutableArray *users = [NSMutableArray array];
  for (OMBGroup *group in [self objects]) {
    [users addObjectsFromArray: [group.users allValues]];
  }
  return users;
}

@end
