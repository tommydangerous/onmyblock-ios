//
//  OMBHomebaseRenterViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterViewController.h"

// Categories
#import "NSString+Extensions.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
// Models
#import "OMBOffer.h"
#import "OMBRenterApplication.h"
// Protocols
#import "OMBConnectionProtocol.h"
// Views
#import "AMBlurView.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBBlurView.h"
#import "OMBEmptyImageTwoLabelCell.h"
#import "OMBHomebaseLandlordOfferCell.h"
#import "OMBSentApplicationCell.h"
// View controllers
#import "OMBInformationHowItWorksViewController.h"
#import "OMBNavigationController.h"
#import "OMBOfferInquiryViewController.h"
#import "OMBSentApplicationDetailViewController.h"

static const CGFloat HomebaseRenterImagePercentage = 0.3f;
static const CGFloat ViewForHeaderHeight           = 13.0f * 2;

@interface OMBHomebaseRenterViewController ()
<
  OMBConnectionProtocol,
  UIScrollViewDelegate,
  UITableViewDataSource,
  UITableViewDelegate
>
{
  OMBActivityViewFullScreen *activityViewFullScreen;
  OMBBlurView *backView;
  CGFloat topSpacing;
}

@end

@implementation OMBHomebaseRenterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Homebase";

  return self;
}

#pragma mark - Override

#pragma mark - UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  // Dimensions
  CGRect screen          = [self screen];
  CGFloat padding        = OMBPadding;
  CGFloat screenHeight   = CGRectGetHeight(screen);
  CGFloat screenWidth    = CGRectGetWidth(screen);
  CGFloat standardHeight = OMBStandardHeight;
  topSpacing             = padding + standardHeight;

  // The image in the back
  CGRect backViewRect = CGRectMake(0.0f, 0.0f,
    screenWidth, topSpacing + (screenHeight * HomebaseRenterImagePercentage));
  UIView *backViewHolder = [[UIView alloc] initWithFrame: backViewRect];
  backViewHolder.backgroundColor = [UIColor clearColor];
  backViewHolder.clipsToBounds = YES;
  [self setupBackgroundWithView: backViewHolder startingOffsetY: 0.0f];
  backView = [[OMBBlurView alloc] initWithFrame: backViewHolder.bounds];
  backView.blurRadius = 5.0f;
  backView.tintColor  = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [backViewHolder addSubview: backView];

  // Welcome
  CGFloat mediumLineHeight  = 27.0f;
  CGFloat normalLineHeight  = 22.0f;
  CGFloat totalLabelHeights = mediumLineHeight + (normalLineHeight * 2);
  UILabel *welcomeLabel = [UILabel new];
  welcomeLabel.font     = [UIFont mediumTextFont];
  welcomeLabel.frame    = CGRectMake(0.0f, 
    (((CGRectGetHeight(tableHeaderView.frame) - topSpacing) 
    - totalLabelHeights) * 0.5f) + topSpacing,
      CGRectGetWidth(tableHeaderView.frame), mediumLineHeight);
  welcomeLabel.text          = @"Welcome to your Homebase.";
  welcomeLabel.textAlignment = NSTextAlignmentCenter;
  welcomeLabel.textColor     = [UIColor whiteColor];
  [tableHeaderView addSubview: welcomeLabel];
  // Description
  UILabel *descriptionLabel = [UILabel new];
  NSString *descriptionString = @"Review all your applications \n"
    @"and bookings here.";
  descriptionLabel.attributedText = 
    [descriptionString attributedStringWithFont:
      [UIFont normalTextFont] lineHeight: normalLineHeight];
  descriptionLabel.frame = CGRectMake(0.0f,
    CGRectGetMinY(welcomeLabel.frame) + CGRectGetHeight(welcomeLabel.frame),
      CGRectGetWidth(welcomeLabel.frame), normalLineHeight * 2);
  descriptionLabel.numberOfLines = 2;
  descriptionLabel.textColor     = welcomeLabel.textColor;
  descriptionLabel.textAlignment = welcomeLabel.textAlignment;
  [tableHeaderView addSubview: descriptionLabel];

  activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
  [self.view addSubview: activityViewFullScreen];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Refresh the blur views with image
  UIImage *backgroundImage = 
    [UIImage imageNamed: @"intro_still_image_slide_2_background.jpg"];
  [backgroundBlurView refreshWithImage: backgroundImage];
  [backView refreshWithImage: backgroundImage];
  
  if ([[self user] loggedIn]) {
    [self fetchSentApplications];
    [self fetchMovedIn];
  }
}

#pragma mark - Methods

#pragma mark - Instance methods

#pragma mark - Private

- (void) fetchMovedIn
{
  [[self user] fetchMovedInWithCompletion:
    ^(NSError *error) {
      [self.table reloadData];
    }
  ];
}

- (void) fetchSentApplications
{
  [[self user].renterApplication fetchSentApplicationsWithDelegate: 
    nil completion: ^(NSError *error) {
      [self.table reloadData];
    }
  ];
}

- (NSArray *) movedIn
{
  return [[OMBUser currentUser].movedIn allValues];
}

- (NSArray *) sentApplications
{
  return [[self user].renterApplication
     sentApplicationsSortedByKey: @"createdAt" ascending: NO];
}

- (void) showHowItWorksForSentApplications
{
  NSString *info1 = [NSString stringWithFormat:
    @"Find a property that’s right for you and apply! "
    @"Once you submit an application it will "
    @"be sent to the landlord to review."];
  NSString *info2 = [NSString stringWithFormat:
    @"If the landlord approves your application and chooses "
    @"you as a tenant you will be given %@ "
    @"to pay the first month’s rent & deposit and sign the lease.",
    [OMBOffer timelineStringForStudent]];
  NSString *info3 = [NSString stringWithFormat:
    @"Once you’ve paid the place is yours, get ready to move-in!"];
  NSArray *array = @[
    @{
      @"title":       @"Send an Application",
      @"information": info1
    },
    @{
      @"title":       @"Landlord Approved",
      @"information": info2
    },
    @{
      @"title":       @"Move In!",
      @"information": info3
    }
  ];
  
  OMBInformationHowItWorksViewController *vc =
    [[OMBInformationHowItWorksViewController alloc] initWithInformationArray:
      array];
  vc.title = @"Applications";
  [(OMBNavigationController *) self.navigationController pushViewController:
    vc animated: YES ];
}

- (OMBUser *) user
{
  return [OMBUser currentUser];
}

#pragma mark - Protocol

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Sent applications
  // Moved in
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *EmptyID = @"EmptyID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyID];
  if (!emptyCell) {
    emptyCell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: EmptyID];
  }
  UIColor *cellBackgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.0f];
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  // Sent applications
  if (section == OMBHomebaseRenterSectionSentApplications) {
    // Empty space
    if (row == OMBHomebaseRenterSectionSentApplicationsRowEmpty) {
      static NSString *EmptySentAppsCellIdentifier =
        @"EmptySentAppsCellIdentifier";
      OMBEmptyImageTwoLabelCell *cell =
        [tableView dequeueReusableCellWithIdentifier:
          EmptySentAppsCellIdentifier];
      if (!cell) {
        cell = [[OMBEmptyImageTwoLabelCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:
            EmptySentAppsCellIdentifier];
        cell.backgroundColor = cellBackgroundColor;
      }
      [cell setTopLabelText:    @"Your sent applications will"];
      [cell setMiddleLabelText: @"appear here after you have"];
      [cell setBottomLabelText: @"applied to a property."];
      [cell setObjectImageViewImage: 
        [UIImage imageNamed: @"papers_icon_white.png"]];
      cell.clipsToBounds = YES;
      return cell;
    }
    // Sent applications
    else {
      static NSString *SentApplicationCellIdentifier =
        @"SentApplicationCellIdentifier";
      OMBSentApplicationCell *cell =
        [tableView dequeueReusableCellWithIdentifier:
          SentApplicationCellIdentifier];
      if (!cell) {
        cell = [[OMBSentApplicationCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: 
            SentApplicationCellIdentifier];
        cell.backgroundColor = cellBackgroundColor;
      }
      [cell loadInfo: 
        [[self sentApplications] objectAtIndex: row - 1]];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  // Move in
  else if (section == OMBHomebaseRenterSectionMovedIn) {
    // Empty
    if (row == OMBHomebaseRenterSectionMovedInRowEmpty) {
      static NSString *EmptyTenantsCellIdentifier =
        @"EmptyTenantsCellIdentifier";
      OMBEmptyImageTwoLabelCell *cell =
        [tableView dequeueReusableCellWithIdentifier:
          EmptyTenantsCellIdentifier];
      if (!cell) {
        cell = [[OMBEmptyImageTwoLabelCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:
            EmptyTenantsCellIdentifier];
        cell.backgroundColor = cellBackgroundColor;
      }
      [cell setTopLabelText:    @"Places you're moving into will"];
      [cell setMiddleLabelText: @"appear here after you have"];
      [cell setBottomLabelText: @"paid and signed the lease."];
      [cell setObjectImageViewImage: [UIImage imageNamed:
        @"confirm_place_icon.png"]];
      cell.clipsToBounds = YES;
      return cell;
    }
    else {
      static NSString *ConfirmedTenantIdentifier =
        @"ConfirmedTenantIdentifier";
      OMBHomebaseLandlordOfferCell *cell =
        [tableView dequeueReusableCellWithIdentifier:
          ConfirmedTenantIdentifier];
      if (!cell) {
        cell = [[OMBHomebaseLandlordOfferCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier:
            ConfirmedTenantIdentifier];
        cell.backgroundColor = cellBackgroundColor;
      }
      [cell loadMoveInConfirmedTenant:
        [[self movedIn] objectAtIndex: row - 1]];
      [cell adjustFramesWithoutImage];
      cell.clipsToBounds = YES;
      return cell; 
    }
  }
  emptyCell.clipsToBounds = YES;
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Sent applications
  if (section == OMBHomebaseRenterSectionSentApplications) {
    return 1 + [self sentApplications].count;
  }
  // Move in
  else if (section == OMBHomebaseRenterSectionMovedIn) {
    return 1 + [self movedIn].count;
  }
  return 0;
}

#pragma mark - UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  // Sent applications
  if (section == OMBHomebaseRenterSectionSentApplications) {
    if (row != OMBHomebaseRenterSectionSentApplicationsRowEmpty) {
      [self.navigationController pushViewController:
        [[OMBSentApplicationDetailViewController alloc] initWithSentApplication:
          [[self sentApplications] objectAtIndex: row - 1]] animated: YES];
    }
  }
  // Moved in
  else if (section == OMBHomebaseRenterSectionMovedIn) {
    if (row != OMBHomebaseRenterSectionMovedInRowEmpty) {
      [self.navigationController pushViewController:
        [[OMBOfferInquiryViewController alloc] initWithOffer: 
          [[self movedIn] objectAtIndex: row - 1]] animated: YES];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForHeaderInSection: (NSInteger) section
{
  return ViewForHeaderHeight;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  // Sent applications
  if (section == OMBHomebaseRenterSectionSentApplications) {
    // Empty
    if (row == OMBHomebaseRenterSectionSentApplicationsRowEmpty) {
      if ([self sentApplications].count == 0) {
        return [OMBEmptyImageTwoLabelCell heightForCell];
      }
    }
    else {
      return [OMBEmptyImageTwoLabelCell heightForCell];
    }
  }
  // Moved in
  else if (section == OMBHomebaseRenterSectionMovedIn) {
    // Empty
    if (row == OMBHomebaseRenterSectionMovedInRowEmpty) {
      if ([self movedIn].count == 0) {
        return [OMBEmptyImageTwoLabelCell heightForCell];
      }
    }
    else {
      return [OMBHomebaseLandlordOfferCell heightForCell]; 
    }
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView
viewForHeaderInSection: (NSInteger) section
{
  CGFloat padding    = OMBPadding;
  AMBlurView *blur   = [[AMBlurView alloc] init];
  blur.blurTintColor = [UIColor grayLight];
  blur.frame = CGRectMake(0.0f, 0.0f,
    tableView.frame.size.width, ViewForHeaderHeight);
  UILabel *label = [UILabel new];
  label.font  = [UIFont smallTextFontBold];
  label.frame = CGRectMake(padding, 0.0f,
    blur.frame.size.width - (padding * 2), blur.frame.size.height);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor     = [UIColor blueDark];
  [blur addSubview: label];
  NSString *titleString = @"";

  // Info button
  UIButton *infoButton = [UIButton new];
  CGFloat widthIcon = 18.f;
  infoButton.frame = CGRectMake(blur.frame.size.width - widthIcon - 5.f,
    4.0f, widthIcon, widthIcon);
  infoButton.layer.borderColor = [UIColor blueDark].CGColor;
  infoButton.layer.borderWidth = 1.0f;
  infoButton.layer.cornerRadius = widthIcon * 0.5f;
  infoButton.titleLabel.font = [UIFont normalTextFontBold];
  [infoButton setTitle: @"i" forState: UIControlStateNormal];
  [infoButton setTitleColor: [UIColor blueDark] forState: UIControlStateNormal];

  // Sent applications
  if (section == OMBHomebaseRenterSectionSentApplications) {
    [infoButton addTarget: self 
      action: @selector(showHowItWorksForSentApplications)
        forControlEvents: UIControlEventTouchUpInside];
    [blur addSubview: infoButton];
    titleString = @"Sent Applications";
  }
  // Moved in
  else if (section == OMBHomebaseRenterSectionMovedIn) {
    titleString = @"Ready to Move In";
  }
  
  label.text = titleString;
  return blur;
}

@end
