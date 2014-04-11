//
//  OMBRenterInfoSectionRoommatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionRoommateViewController.h"

#import "OMBNavigationController.h"
#import "OMBOtherUserProfileViewController.h"
#import "OMBRenterApplication.h"
#import "OMBRenterInfoAddRoommateViewController.h"
#import "OMBRoommate.h"
#import "OMBRoommateCell.h"

@interface OMBRenterInfoSectionRoommateViewController()
{
  UIActionSheet *profileDeleteActionSheet;
  NSIndexPath *selectedIndexPath;
}

@end

@implementation OMBRenterInfoSectionRoommateViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super initWithUser: object])) return nil;

  self.title = @"Co-applicants";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setEmptyLabelText: @"When you add a co-applicant, \n"
    @"we will send them an invitation \n"
    @"to fill out their renter profiles."];

  [addButton setTitle: @"Add Co-applicant" forState: UIControlStateNormal];
  [addButtonMiddle setTitle: @"Add Co-applicant"
    forState: UIControlStateNormal];
  
  profileDeleteActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
    cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Profile"
      otherButtonTitles: @"Delete", nil];
  profileDeleteActionSheet.destructiveButtonIndex = 1;
  [self.view addSubview: profileDeleteActionSheet];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self fetchObjects];

  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [[self renterApplication] readFromDictionary: dictionary
    forModelName: [OMBRoommate modelName]];
  [self reloadTable];
}

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(actionSheet == profileDeleteActionSheet){
    if (buttonIndex == 0){
      OMBRoommate *roommate =
        (OMBRoommate *)[[self objects] objectAtIndex: selectedIndexPath.row];
      [self.navigationController pushViewController:
        [[OMBOtherUserProfileViewController alloc] initWithUser:
          [roommate otherUser: user]] animated: YES];
    }
    else if (buttonIndex == 1) {
      [self deleteModelObjectAtIndexPath: selectedIndexPath];
      selectedIndexPath = nil;
    }
  }else{
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;

  static NSString *RoommateID = @"RoommateID";
  OMBRoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:
    RoommateID];
  if (!cell)
    cell = [[OMBRoommateCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: RoommateID];
  [cell loadData: [[self objects] objectAtIndex: row] user: user];
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
  return [OMBRoommateCell heightForCell];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  OMBRoommate *testUser = (OMBRoommate *)
    [[self objects] objectAtIndex: indexPath.row];
  
  if (!testUser.roommate) {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  }else{
    selectedIndexPath = indexPath;
    [profileDeleteActionSheet showInView: self.view];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  [self presentViewController:
    [[OMBNavigationController alloc] initWithRootViewController:
      [[OMBRenterInfoAddRoommateViewController alloc] init]] animated: YES
        completion: nil];
}

- (void) fetchObjects
{
  [self fetchObjectsForResourceName: [OMBRoommate resourceName]];
}

- (NSArray *) objects
{
  return [[self renterApplication] objectsWithModelName:
    [OMBRoommate modelName] sortedWithKey: @"firstName" ascending: YES];
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
