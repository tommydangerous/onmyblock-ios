//
//  OMBRenterInfoAddRoommateViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddRoommateViewController.h"

#import "OMBFacebookUserCell.h"
#import "OMBRoommate.h"
#import "OMBRoommatesSearchFacebookFriendsConnection.h"
#import "OMBLabelSwitchCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBRenterApplication.h"
#import "OMBTwoLabelTextFieldCell.h"
#import "OMBViewControllerContainer.h"

// Models
#import "OMBGroup.h"

// Categories
#import "OMBGroup+Users.h"
#import "OMBUser+Groups.h"
#import "UIImage+Resize.h"

@interface OMBRenterInfoAddRoommateViewController () <OMBGroupUsersDelegate>
{
  UIButton *facebookButton;
  BOOL isSearching;
  OMBRoommatesSearchFacebookFriendsConnection *searchFacebookFriendsConnection;
  NSMutableDictionary *searchResultsDictionary;
  UITableView *searchTableView;
}

@end

@implementation OMBRenterInfoAddRoommateViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  searchResultsDictionary = [NSMutableDictionary dictionary];
  self.title = @"Add Co-applicant";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(facebookAuthenticationFinished:)
      name: OMBUserCreateAuthenticationForFacebookNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  [self setupForTable];

  CGRect screen = [self screen];

  facebookButton = [UIButton new];
  facebookButton.backgroundColor = [UIColor facebookBlue];
  facebookButton.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, OMBStandardButtonHeight);
  facebookButton.titleLabel.font = [UIFont normalTextFontBold];
  [facebookButton addTarget: self action: @selector(facebookButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [facebookButton setTitle: @"Connect my Facebook"
    forState: UIControlStateNormal];
  [facebookButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  self.table.tableHeaderView = facebookButton;

  CGFloat tableHeight = self.table.frame.size.height -
    (OMBPadding + OMBStandardHeight +
      [OMBLabelTextFieldCell heightForCellWithIconImageView]);
  searchTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    self.table.frame.size.height - tableHeight, screen.size.width,
      tableHeight)];
  searchTableView.backgroundColor = [UIColor whiteColor];
  searchTableView.dataSource = self;
  searchTableView.delegate = self;
  searchTableView.hidden = YES;
  searchTableView.separatorColor = [UIColor grayLight];
  searchTableView.separatorInset = UIEdgeInsetsMake(0.0f, OMBPadding,
    0.0f, 0.0f);
  searchTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  [self.view addSubview: searchTableView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  modelObject = [[OMBRoommate alloc] init];

  [self updateFacebookButton];
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnection

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  [searchResultsDictionary removeAllObjects];
  if ([dictionary objectForKey: @"objects"] != [NSNull null] &&
    [[dictionary objectForKey: @"objects"] count]) {
    for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
      [searchResultsDictionary setObject: dict forKey:
        [NSString stringWithFormat: @"%@ %@",
          [dict objectForKey: @"first_name"],
            [dict objectForKey: @"last_name"]]];
    }
  }
  [searchTableView reloadData];
}

#pragma mark - Protocol OMBGroupDelegate

- (void)saveUserFailed:(NSError *)error
{
  [self showAlertViewWithError:error];
  [self cancel];
  [self containerStopSpinning];
}

- (void)saveUserSucceeded
{
  [self cancel];
  [self containerStopSpinning];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  if (tableView == self.table) {
    return 2;
  }
  else if (tableView == searchTableView) {
    return 2;
  }
  return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;

  static NSString *EmptyID = @"EmptyID";
  UITableViewCell *empty = [tableView dequeueReusableCellWithIdentifier:
    EmptyID];
  if (!empty) {
    empty = [[UITableViewCell alloc] initWithStyle:
     UITableViewCellStyleDefault reuseIdentifier: EmptyID];
  }

  if (tableView == self.table) {
    // Fields
    if (section == OMBRenterInfoAddRoommateSectionFields) {
      // First name
      static NSString *LabelTextID = @"LabelTextID";
      OMBLabelTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier: LabelTextID];
      if (!cell) {
        cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LabelTextID];
        [cell setFrameUsingIconImageView];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *imageName;
      NSString *placeholderString;

      // First name
      if (row == OMBRenterInfoAddRoommateSectionFieldsRowFirstName) {
        imageName         = @"user_icon.png";
        placeholderString = @"First name";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
      }
      // Last name
      else if (row == OMBRenterInfoAddRoommateSectionFieldsRowLastName) {
        imageName         = @"user_icon.png";
        placeholderString = @"Last name";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
      }
      // Email
      if (row == OMBRenterInfoAddRoommateSectionFieldsRowEmail) {
        imageName         = @"messages_icon_dark.png";
        placeholderString = @"Email";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        // Last row, hide the separator
        cell.separatorInset = UIEdgeInsetsMake(0.0f,
          tableView.frame.size.width, 0.0f, 0.0f);
      }
      cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
        size: cell.iconImageView.bounds.size];
      cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      cell.textField.delegate  = self;
      cell.textField.indexPath = indexPath;
      cell.textField.placeholder = placeholderString;
      [cell.textField addTarget: self
        action: @selector(textFieldDidChange:)
          forControlEvents: UIControlEventEditingChanged];
      cell.clipsToBounds = YES;
      return cell;
    }
    // Spacing
    else if (section == OMBRenterInfoAddRoommateSectionSpacing) {
      empty.backgroundColor = [UIColor clearColor];
      empty.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
    }
  }
  else if (tableView == searchTableView) {
    if (section == OMBRenterInfoAddRoommateSearchSectionResults) {
      // Add co-applicant manually
      if (row == [searchResultsDictionary count]) {
        static NSString *ResultID = @"ResultID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
          ResultID];
        if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: ResultID];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont normalTextFontBold];
        cell.textLabel.text = @"Add co-applicant manually";
        cell.textLabel.textColor = [UIColor blue];
        cell.clipsToBounds = YES;
        return cell;
      }else{
        static NSString *FbuserID = @"FbuserID";
        OMBFacebookUserCell *cell = [tableView dequeueReusableCellWithIdentifier:
          FbuserID];
        if(!cell)
          cell = [[OMBFacebookUserCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:FbuserID];
        
        [cell loadFacebooUserData:
          [searchResultsDictionary objectForKey:
            [[self sortedSearchResultsDictionaryKeys] objectAtIndex: row]]];
        cell.clipsToBounds = YES;
        return cell;
      }
      /*static NSString *ResultID = @"ResultID";
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
       ResultID];
       if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:
       UITableViewCellStyleDefault reuseIdentifier: ResultID];
       }
       cell.backgroundColor = [UIColor whiteColor];
       // Add co-applicant manually
       if (row == [searchResultsDictionary count]) {
       cell.textLabel.font = [UIFont normalTextFontBold];
       cell.textLabel.text = @"Add co-applicant manually";
       cell.textLabel.textColor = [UIColor blue];
       }
       else {
       cell.textLabel.font = [UIFont normalTextFont];
       cell.textLabel.text = [[[self sortedSearchResultsDictionaryKeys]
       objectAtIndex: row] stringByAppendingString:@" (Facebook user)"];
       cell.textLabel.textColor = [UIColor textColor];
       }
       cell.clipsToBounds = YES;
       return cell;
       }*/
    }
    // Spacing
    else if (section == OMBRenterInfoAddRoommateSearchSectionSpacing) {
      empty.backgroundColor = [UIColor clearColor];
      empty.selectionStyle = UITableViewCellSelectionStyleNone;
      empty.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
    }
  }
  empty.clipsToBounds = YES;
  return empty;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (tableView == self.table) {
    if (section == OMBRenterInfoAddRoommateSectionFields)
      return 3;
    else if (section == OMBRenterInfoAddRoommateSectionSpacing)
      return 1;
  }
  else if (tableView == searchTableView) {
    if (section == OMBRenterInfoAddRoommateSearchSectionResults) {
      // Last row for "Add co-applicant manually"
      return [searchResultsDictionary count] + 1;
    }
    else if (section == OMBRenterInfoAddRoommateSearchSectionSpacing) {
      return 1;
    }
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (tableView == searchTableView) {
    if (section == OMBRenterInfoAddRoommateSearchSectionResults) {
      if (row == [searchResultsDictionary count]) {
        [self setupForSearching: NO];
        [self cancelFromInputAccessoryView];
      }
      else {
        NSString *key = 
          [[self sortedSearchResultsDictionaryKeys] objectAtIndex:row];
        NSDictionary *dict = [searchResultsDictionary objectForKey:key];
        // First name
        [valueDictionary setObject:[dict objectForKey:@"first_name"]
          forKey:@"firstName"];
        // Last name
        [valueDictionary setObject:[dict objectForKey:@"last_name"]
          forKey:@"lastName"];
        // Provider id
        [valueDictionary setObject:[dict objectForKey:@"id"]
          forKey:@"providerId"];
        // Username
        [valueDictionary setObject:[dict objectForKey:@"username"]
          forKey:@"username"];
        [self save];
      }
    }
  }
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (tableView == self.table) {
    if (section == OMBRenterInfoAddRoommateSectionFields) {
      if (row == OMBRenterInfoAddRoommateSectionFieldsRowFirstName) {
        return [OMBLabelTextFieldCell heightForCellWithIconImageView];
      }
      else if (!isSearching) {
        return [OMBLabelTextFieldCell heightForCellWithIconImageView];
      }
    }
    else if (section == OMBRenterInfoAddRoommateSectionSpacing && isEditing) {
      return OMBKeyboardHeight + textFieldToolbar.frame.size.height;
    }
  }
  else if (tableView == searchTableView) {
    if (section == OMBRenterInfoAddRoommateSearchSectionResults) {
      if(row == [searchResultsDictionary count])
        return OMBStandardHeight;
      else
        return [OMBFacebookUserCell heightForCell];
    }
    else if (section == OMBRenterInfoAddRoommateSearchSectionSpacing &&
      isEditing) {
      return OMBKeyboardHeight + textFieldToolbar.frame.size.height;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  isEditing = YES;
  if (textField.indexPath.row ==
    OMBRenterInfoAddRoommateSectionFieldsRowFirstName) {
    if ([self user].renterApplication.facebookAuthenticated) {
      if (searchTableView.hidden)
        [self setupForSearching: YES];
      [searchTableView beginUpdates];
      [searchTableView endUpdates];
      [searchResultsDictionary removeAllObjects];
      [searchTableView reloadData];
      // [searchTableView setContentOffset: CGPointZero animated: NO];
    }
  }

  [self.table beginUpdates];
  [self.table endUpdates];

  textField.inputAccessoryView = textFieldToolbar;

  [self scrollToRowAtIndexPath: textField.indexPath];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelFromInputAccessoryView
{
  [self.view endEditing: YES];
  isEditing = NO;
  if ([self user].renterApplication.facebookAuthenticated &&
    !searchTableView.hidden) {
    [searchTableView beginUpdates];
    [searchTableView endUpdates];
  }
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) facebookAuthenticationFinished: (NSNotification *) notification
{
  NSError *error = [notification.userInfo objectForKey: @"error"];
  if (!error) {
    [self user].renterApplication.facebookAuthenticated = YES;
    [[self user] downloadImageFromImageURLWithCompletion: nil];
    [self updateFacebookButton];
  }
  else {
    [self showAlertViewWithError: error];
  }
  [self containerStopSpinning];
}

- (void) facebookButtonSelected
{
  if (![self user].renterApplication.facebookAuthenticated) {
    [self.view endEditing: YES];
    [self containerStartSpinning];
    [[self appDelegate] openSession];
  }
}

- (OMBGroup *)group
{
  return [[self user] primaryGroup];
}

- (void)save
{
  [self.view endEditing:YES];
  [[self group] createUserWithDictionary:valueDictionary
    accessToken:[self user].accessToken delegate:self];
  [self containerStartSpinning];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) searchFacebookFriendsWithQuery: (NSString *) string
{
  if (searchFacebookFriendsConnection)
    [searchFacebookFriendsConnection cancel];
  searchFacebookFriendsConnection =
    [[OMBRoommatesSearchFacebookFriendsConnection alloc] initWithQuery: string];
  searchFacebookFriendsConnection.delegate = self;
  [searchFacebookFriendsConnection start];
}

- (void)setupForSearching:(BOOL)setup
{
  isSearching              = setup;
  self.table.scrollEnabled = !setup;
  searchTableView.hidden   = !setup;
}

- (NSArray *) sortedSearchResultsDictionaryKeys
{
  return [[searchResultsDictionary allKeys] sortedArrayUsingSelector:
    @selector(localizedCaseInsensitiveCompare:)];
}

- (void)textFieldDidChange:(TextFieldPadding *)textField
{
  NSInteger row = textField.indexPath.row;
  NSString *string = textField.text;
  if ([string length]) {
    // First name
    if (row == OMBRenterInfoAddRoommateSectionFieldsRowFirstName) {
      [valueDictionary setObject: string forKey: @"firstName"];
      if ([self user].renterApplication.facebookAuthenticated) {
        [self searchFacebookFriendsWithQuery: string];
      }
    }
    // Last name
    else if (row == OMBRenterInfoAddRoommateSectionFieldsRowLastName) {
      [valueDictionary setObject: string forKey: @"lastName"];
    }
    else if (row == OMBRenterInfoAddRoommateSectionFieldsRowEmail) {
      [valueDictionary setObject: string forKey: @"email"];
    }
  }
}

- (void) updateFacebookButton
{
  if ([self user].renterApplication.facebookAuthenticated) {
    self.table.tableHeaderView = [[UIView alloc] initWithFrame: CGRectZero];
  }
  else {
    self.table.tableHeaderView = facebookButton;
  }
}

- (OMBUser *)user
{
  return [OMBUser currentUser];
}

@end
