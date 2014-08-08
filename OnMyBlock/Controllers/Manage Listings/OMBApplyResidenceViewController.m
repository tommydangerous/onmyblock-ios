//
//  OMBApplyResidenceViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBApplyResidenceViewController.h"

#import "AMBlurView.h"
#import "LEffectLabel.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBAlertViewBlur.h"
#import "OMBLegalQuestionStore.h"
#import "OMBLegalViewController.h"
#import "OMBPreviousRental.h"
#import "OMBRenterInfoSectionCosignersViewController.h"
#import "OMBRenterInfoSectionEmploymentViewController.h"
#import "OMBRenterInfoSectionPreviousRentalViewController.h"
#import "OMBRenterInfoSectionRoommateViewController.h"
#import "OMBRenterInfoSectionViewController.h"
#import "OMBRenterProfileUserInfoCell.h"
#import "OMBResidence.h"
#import "OMBRoommate.h"
#import "OMBViewControllerContainer.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"

// Categories
#import "OMBUser+Groups.h"

// Connections
#import "OMBSentApplicationRequirementsConnection.h"

// Models
#import "OMBGroup.h"

@interface OMBApplyResidenceViewController () 
<OMBGroupDelegate, OMBUserGroupsDelegate>
{
  OMBAlertViewBlur *alertBlur;
  OMBActivityViewFullScreen *activityView;
  LEffectLabel *effectLabel;
  NSUInteger employmentCount;
  BOOL hasFetchedRequirements;
  NSUInteger legalAnswerCount;
  NSUInteger previousRentalCount;
  OMBResidence *residence;
  BOOL shouldPopViewController;
  UIButton *submitOfferButton;
  
  // NSArray *sections;
}

@end

@implementation OMBApplyResidenceViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;
  
  residence  = object;
  self.title = @"Renter Application";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  
  CGRect screen = [self screen];
  
  // Table footer view
  CGFloat submitHeight = OMBStandardButtonHeight;
  UIView *footerView = [[UIView alloc] init];
  footerView.frame = CGRectMake(0.0f, 0.0f, screen.size.width, submitHeight);
  self.table.tableFooterView = footerView;
  
  // Submit offer view
  AMBlurView *submitView = [[AMBlurView alloc] init];
  submitView.blurTintColor = [UIColor blue];
  submitView.frame = CGRectMake(0.0f, screen.size.height - submitHeight,
    screen.size.width, submitHeight);
  [self.view addSubview: submitView];

  submitOfferButton = [UIButton new];
  submitOfferButton.frame = submitView.bounds;
  [submitOfferButton addTarget: self
    action: @selector(shouldSubmitApplication)
      forControlEvents: UIControlEventTouchUpInside];
  [submitOfferButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlightedAlpha: 0.3f]]
      forState: UIControlStateHighlighted];
  [submitView addSubview: submitOfferButton];
  
  // Effect label
  effectLabel = [[LEffectLabel alloc] init];
  effectLabel.effectColor = [UIColor grayMedium];
  effectLabel.effectDirection = EffectDirectionLeftToRight;
  effectLabel.font = [UIFont mediumTextFontBold];
  effectLabel.frame = submitOfferButton.frame;
  effectLabel.sizeToFit = NO;
  effectLabel.text = @"Submit Application";
  effectLabel.textColor = [UIColor whiteColor];
  effectLabel.textAlignment = NSTextAlignmentCenter;
  [submitView insertSubview: effectLabel
    belowSubview: submitOfferButton];
  
  alertBlur = [[OMBAlertViewBlur alloc] init];
  
  _nextSection = 0;

  activityView = [[OMBActivityViewFullScreen alloc] init];
  [self.view addSubview: activityView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (shouldPopViewController) {
    [self.navigationController popViewControllerAnimated: NO];
    shouldPopViewController = NO;
  }
  else {
    [self updateRequirementCounts];
    void (^legalCompletion) (NSError *error) = ^(NSError *error) {
      // If all of the requirements are not met, fetch
      if (employmentCount == 0 || legalAnswerCount < 
        [[OMBLegalQuestionStore sharedStore] legalQuestionsCount] ||
          previousRentalCount == 0) {
        // Fetch data pertaining to sent application requirements
        if (!hasFetchedRequirements) {
          [self fetchSentApplicationRequirementsForUser: user completion: 
            ^(NSError *error) {
              hasFetchedRequirements = YES;
              [self.table reloadData];
              [activityView stopSpinning];
            }
          ];
          [activityView startSpinning];
        }
      }
    };
    if ([[OMBLegalQuestionStore sharedStore] legalQuestionsCount]) {
      legalCompletion(nil);
    }
    else {
      [[OMBLegalQuestionStore sharedStore] fetchLegalQuestionsWithCompletion:
        legalCompletion
      ];
    }

    if (_nextSection) {
      [self showNextSection];
    }

    [effectLabel performEffectAnimation];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
{
  id count;
  // Employments
  count = [dictionary objectForKey: @"employments"];
  if (count && count != [NSNull null]) {
    employmentCount = [count intValue];
  }
  // Legal answers
  count = [dictionary objectForKey: @"legal_answers"];
  if (count && count != [NSNull null]) {
    legalAnswerCount = [count intValue];
  }
  // Previous rentals
  count = [dictionary objectForKey: @"previous_rentals"];
  if (count && count != [NSNull null]) {
    previousRentalCount = [count intValue];
  }
}

#pragma mark - Protocol OMBGroupDelegate

- (void)createSentApplicationFailed:(NSError *)error
{
  [self showAlertViewWithError: error];
  [self containerStopSpinningFullScreen];
}

- (void)createSentApplicationSucceeded
{
  [alertBlur setTitle:@"Application Submitted!"];
  [alertBlur setMessage: 
    @"The landlord will review your application and make a decision. "
    @"If you have applied with co-applicants make sure they have "
    @"completed applications as well. Feel free to message the "
    @"landlord for more information about the property "
    @"or to schedule a viewing."];
  [alertBlur setConfirmButtonTitle:@"Okay"];
  [alertBlur addTargetForConfirmButton:self
    action:@selector(showHomebaseRenter)];
  [alertBlur showInView:self.view withDetails:NO];

  [alertBlur hideCloseButton];
  [alertBlur hideQuestionButton];
  [alertBlur showOnlyConfirmButton];

  [self trackApplicationSubmitted];

  [self containerStopSpinningFullScreen];
}

- (void)groupsFetchedSucceeded
{
  [self submitApplication];
}

- (void)groupsFetchedFailed:(NSError *)error
{
  [self showAlertViewWithError:error];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  
  // Renter info
  if (section == OMBMyRenterProfileSectionRenterInfo) {
    if (row != OMBMyRenterProfileSectionRenterInfoTopSpacing) {
      static NSString *RenterID = @"RenterID";
      OMBRenterProfileUserInfoCell *cell =
      [tableView dequeueReusableCellWithIdentifier: RenterID];
      if (!cell)
        cell = [[OMBRenterProfileUserInfoCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier: RenterID];
      cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      [cell resetWithCheckmark];
      NSString *iconImageName;
      NSString *string;
      BOOL fillCheckmark = NO;
      // Co-applicants
      if (row == OMBMyRenterProfileSectionRenterInfoRowCoapplicants) {
        iconImageName = @"group_icon.png";
        string = @"Co-applicants";
        if ([[user primaryGroup].users count]) {
          fillCheckmark = YES;
        }
      }
      // Co-signers
      else if (row == OMBMyRenterProfileSectionRenterInfoRowCosigners) {
        iconImageName = @"landlord_icon.png";
        string = @"Co-signer";
        if ([[[self renterApplication] cosignersSortedByFirstName] count]) {
          fillCheckmark = YES;
        }
      }
      // Previous rentals
      else if (row == OMBMyRenterProfileSectionRenterInfoRowRentalHistory) {
        iconImageName = @"house_icon.png";
        string = @"Rental History";
        if (previousRentalCount) {
          fillCheckmark = YES;
        }
      }
      // Employments
      else if (row == OMBMyRenterProfileSectionRenterInfoRowWorkHistory) {
        iconImageName = @"papers_icon_black.png";
        string = @"Work & School History";
        if (employmentCount) {
          fillCheckmark = YES;
        }
      }
      // Legal questions and answers
      else if (row == OMBMyRenterProfileSectionRenterInfoRowLegalQuestions) {
        iconImageName = @"law_icon_black.png";
        string = @"Legal Questions";
        if (legalAnswerCount >=
          [[OMBLegalQuestionStore sharedStore] legalQuestionsCount]) {
          fillCheckmark = YES;
        }
      }
      if (fillCheckmark) {
        [cell fillCheckmark];
      }
      cell.iconImageView.image = [UIImage image:
        [UIImage imageNamed: iconImageName]
          size: cell.iconImageView.bounds.size];
      cell.label.text    = string;
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  
  return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  
  if (section == OMBMyRenterProfileSectionListings)
    return 0;
  
  return [super tableView:tableView numberOfRowsInSection:section];
  
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  
  // User info
  if (section == OMBMyRenterProfileSectionUserInfo) {
    // Image
    if (row == OMBMyRenterProfileSectionUserInfoRowImage) {
      [self showUploadActionSheet];
    }
  }
  // Renter info
  else if (section == OMBMyRenterProfileSectionRenterInfo) {
    // Co-applicants
    if (row == OMBMyRenterProfileSectionRenterInfoRowCoapplicants) {
      OMBRenterInfoSectionRoommateViewController *vc  =
      [[OMBRenterInfoSectionRoommateViewController alloc] initWithUser:
       user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Co-signers
    else if (row == OMBMyRenterProfileSectionRenterInfoRowCosigners) {
      OMBRenterInfoSectionCosignersViewController *vc  =
        [[OMBRenterInfoSectionCosignersViewController alloc] initWithUser:
          user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Rental History
    else if (row == OMBMyRenterProfileSectionRenterInfoRowRentalHistory) {
      OMBRenterInfoSectionPreviousRentalViewController *vc  =
        [[OMBRenterInfoSectionPreviousRentalViewController alloc] initWithUser: 
          user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Work History
    else if (row == OMBMyRenterProfileSectionRenterInfoRowWorkHistory) {
      OMBRenterInfoSectionEmploymentViewController *vc  =
        [[OMBRenterInfoSectionEmploymentViewController alloc] initWithUser:  
          user];
      vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Legal Questions
    else if (row == OMBMyRenterProfileSectionRenterInfoRowLegalQuestions) {
      OMBLegalViewController *vc  = 
        [[OMBLegalViewController alloc] initWithUser: user];
      // vc.delegate = self;
      [self.navigationController pushViewController: vc animated: YES];
    }
  }
  
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  
  NSInteger section = indexPath.section;
  NSInteger row     = indexPath.section;
 
  // Renter info
  if (section == OMBMyRenterProfileSectionRenterInfo){
    // Top spacing
    if (row == OMBMyRenterProfileSectionRenterInfoTopSpacing) {
      return OMBStandardHeight;
    }
    return OMBStandardButtonHeight;
    
  }
  
  return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (OMBUser *)currentUser
{
  return [OMBUser currentUser];
}

- (NSString *) incompleteFieldString
{
  NSString *string = @"";
  
  NSArray *keyArray = @[
    @"firstName",
    @"lastName",
    @"school",
    @"email",
    @"phone"
  ];
  
  for (NSString *key in keyArray)
  {
    if(![[valueDictionary objectForKey:key] length]){
      if([key isEqualToString:@"firstName"])
        string = @"First Name";
      else if([key isEqualToString:@"lastName"])
        string = @"Last Name";
      else if([key isEqualToString:@"school"])
        string = @"School";
      else if([key isEqualToString:@"email"])
        string = @"Email";
      else if([key isEqualToString:@"phone"])
        string = @"Phone";
      break;
    }
  }
  
  return string;
}

- (void) fetchSentApplicationRequirementsForUser: (OMBUser *) object
completion: (void (^) (NSError *error)) block
{
  OMBSentApplicationRequirementsConnection *conn =
    [[OMBSentApplicationRequirementsConnection alloc] initWithUserUID:
      object.uid];
  conn.completionBlock = block;
  conn.delegate        = self;
  [conn start];
}

- (OMBRenterApplication *) renterApplication
{
  return [OMBUser currentUser].renterApplication;
}

- (void) showNextSection
{
  BOOL animated = NO;
  
  int i;
  // If is the last, set the first section to search
  //if(_nextSection == sections.count)
  //  i = 1;
  //else
  i = _nextSection + 1;
  
  switch (i) {
    case 2:
      {OMBRenterInfoSectionCosignersViewController *vc  =
        [[OMBRenterInfoSectionCosignersViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      break;
    case 3:
      {OMBRenterInfoSectionPreviousRentalViewController *vc  =
        [[OMBRenterInfoSectionPreviousRentalViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      break;
    case 4:
      {OMBRenterInfoSectionEmploymentViewController *vc  =
        [[OMBRenterInfoSectionEmploymentViewController alloc] initWithUser: user];
      vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      break;
    case 5:
      _nextSection = 0;
      {OMBLegalViewController *vc  = [[OMBLegalViewController alloc] initWithUser: user];
      //vc.delegate = self;
      [self.navigationController pushViewController:vc animated:animated];}
      break;
  }
}

- (void) showHomebaseRenter
{
  shouldPopViewController = YES;
  [alertBlur close];
  [[self appDelegate].container showHomebaseRenter];
}

- (void) shouldSubmitApplication
{
  BOOL shouldSubmit = YES;
  NSString *message = @"";
  NSString *title   = @"Almost Finished";
  
  NSArray *keyArray = @[@"firstName", @"lastName",
    @"school", @"email", @"phone"];
  
  // Search missing field
  for (NSString *key in keyArray) {
    if (![[valueDictionary objectForKey:key] length]) {
      message = [[self incompleteFieldString] stringByAppendingString:
        @" is required to submit an application"];
      shouldSubmit = NO;
      break;
    }
  }
  
  // If all fields are completed then search for possible sections missing
  // This is just for set the correct message
  
  if (shouldSubmit) {
    // Require
    // Previous rentals
    if (previousRentalCount == 0) {
      message      = @"Rental history";
      shouldSubmit = NO;
    }
    // Employments
    else if (employmentCount == 0) {
      message      = @"Work & School History";
      shouldSubmit = NO;
    }
    // Legal answers
    else if (legalAnswerCount < 
      [[OMBLegalQuestionStore sharedStore] legalQuestionsCount]) {
      message = @"Legal Questions";
      shouldSubmit = NO;
    }
    message = [message stringByAppendingString: 
      @" section is required to submit an application."];
  }
  
  // Submit Application ?
  if (shouldSubmit) {
    if ([[self currentUser] primaryGroup]) {
      [self submitApplication];
    }
    else {
      [[self currentUser] fetchGroupsWithDelegate:self];
    }
  }
  else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
       message: message delegate: nil
        cancelButtonTitle: @"Continue" otherButtonTitles: nil];
    [alertView show];
  }
}

- (void)submitApplication
{
  [[[self currentUser] primaryGroup] createSentApplicationWithDictionary:@{
    @"residenceId": @(residence.uid)
  } accessToken:[self currentUser].accessToken delegate:self];
  [self containerStartSpinningFullScreen];
}

- (void) trackApplicationSubmitted
{
  OMBMixpanelTrackerTrackSubmission(@"Application Submitted",
    residence, [OMBUser currentUser]);
}

- (void) updateRequirementCounts
{
  if (employmentCount == 0) {
    employmentCount =
    [[[self renterApplication] employmentsSortedByStartDate] count];
  }
  if (legalAnswerCount < 
    [[OMBLegalQuestionStore sharedStore] legalQuestionsCount]) {
    
    legalAnswerCount = [[self renterApplication].legalAnswers count];
  }
  if (previousRentalCount == 0) {
    previousRentalCount = [[[self renterApplication] objectsWithModelName:
      [OMBPreviousRental modelName] sortedWithKey: @"moveInDate"
        ascending: NO] count];
  }
}

@end
