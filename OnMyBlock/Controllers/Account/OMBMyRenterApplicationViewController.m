//
//  OMBMyRenterApplicationViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterApplicationViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBCoapplicantCell.h"
#import "OMBCosigner.h"
#import "OMBCosignerCell.h"
#import "OMBCosignerListConnection.h"
#import "OMBEmployment.h"
#import "OMBEmploymentCell.h"
#import "OMBEmploymentListConnection.h"
#import "OMBLegalAnswerListConnection.h"
#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionAndAnswerCell.h"
#import "OMBLegalQuestionStore.h"
#import "OMBMyRenterApplicationEmailPhoneCell.h"
#import "OMBPreviousRentalCell.h"
#import "OMBPreviousRentalListConnection.h"
#import "OMBRenterApplication.h"
#import "OMBWebViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBMyRenterApplicationViewController

#pragma mark - Initialzer

- (id) initWithUser: (OMBUser *) object;
{
  if (!(self = [super init])) return nil;

  user = object;

  self.screenName = self.title = @"My Renter App";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(edit)];
  [editBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = editBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;
  CGFloat standardHeight = 44.0f;

  self.view.backgroundColor = [UIColor clearColor];
  [self setupForTable];
  self.table.backgroundColor = [UIColor clearColor];
  self.table.frame = CGRectMake(self.table.frame.origin.x,
    padding + standardHeight, self.table.frame.size.width,
      screenHeight - (padding + standardHeight));

  backViewOffsetY = padding + standardHeight;
  // The image in the back
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, backViewOffsetY, 
    screenWidth, screenHeight * 0.4f);
  [self.view insertSubview: backView belowSubview: self.table];
  // Image of user
  userImageView =
    [[OMBCenteredImageView alloc] init];
  userImageView.frame = CGRectMake(0.0f, 0.0f, backView.frame.size.width,
    backView.frame.size.height);
  userImageView.image = [UIImage imageNamed: @"edward_d.jpg"];
  [backView addSubview: userImageView];

  // Table header view
  UIView *headerView = [UIView new];
  headerView.frame = CGRectMake(0.0f, 0.0f, screen.size.width, 
    userImageView.frame.size.height);
  self.table.tableHeaderView = headerView;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Another controller besides the view container can present this
  // We only want to show the menu icon on the inbox from the side menu
  if ([self.navigationController.viewControllers count] == 1) {
    [self setMenuBarButtonItem];
  }

  // Download cosigners
  OMBCosignerListConnection *cosignerConn = 
    [[OMBCosignerListConnection alloc] initWithUser: user];
  cosignerConn.completionBlock = ^(NSError *error) {
    [self.table reloadSections: [NSIndexSet indexSetWithIndex: 2]
      withRowAnimation: UITableViewRowAnimationNone];
  };
  [cosignerConn start];

  // Rental History
  OMBPreviousRentalListConnection *rentalListConn = 
    [[OMBPreviousRentalListConnection alloc] initWithUser: user];
  rentalListConn.completionBlock = ^(NSError *error) {
    [self.table reloadSections: [NSIndexSet indexSetWithIndex: 4]
      withRowAnimation: UITableViewRowAnimationNone];
  };
  [rentalListConn start];

  // Work History
  OMBEmploymentListConnection *employmentConn =
    [[OMBEmploymentListConnection alloc] initWithUser: user];
  employmentConn.completionBlock = ^(NSError *error) {
    [self.table reloadSections: [NSIndexSet indexSetWithIndex: 5]
      withRowAnimation: UITableViewRowAnimationNone];
  };
  [employmentConn start];

  // Legal Questions
  [[OMBLegalQuestionStore sharedStore] fetchLegalQuestionsWithCompletion: 
    ^(NSError *error) {
      legalQuestions = 
        [[OMBLegalQuestionStore sharedStore] questionsSortedByQuestion];
      // Legal answers
      OMBLegalAnswerListConnection *connection =
        [[OMBLegalAnswerListConnection alloc] initWithUser: user];
      connection.completionBlock = ^(NSError *error) {
        [self.table reloadSections: [NSIndexSet indexSetWithIndex: 6]
          withRowAnimation: UITableViewRowAnimationNone];
      };
      [connection start];
      [self.table reloadSections: [NSIndexSet indexSetWithIndex: 6]
        withRowAnimation: UITableViewRowAnimationNone];
    }
  ];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGFloat y = scrollView.contentOffset.y;

  // Move view up
  CGFloat adjustment = y / 3.0f;
  // Adjust the header image view
  CGRect backViewRect = backView.frame;
  CGFloat newOriginY = backViewOffsetY - adjustment;
  if (newOriginY > backViewOffsetY)
    newOriginY = backViewOffsetY;
  backViewRect.origin.y = newOriginY;
  backView.frame = backViewRect;

  CGFloat newScale = 1 + ((y * -1) / userImageView.frame.size.height);
  if (newScale < 1)
    newScale = 1;
  userImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
    newScale, newScale);
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Name, school, about, email, phone
  // Co-applicants
  // Co-signers
  // Pets
  // Rental history
  // Work history
  // Legal stuff
  return 7;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
      reuseIdentifier: CellIdentifier];
  cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  cell.detailTextLabel.text = @"";
  cell.detailTextLabel.textColor = [UIColor blueDark];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  cell.textLabel.numberOfLines = 1;
  cell.textLabel.text = @"";
  cell.textLabel.textColor = [UIColor textColor];
  // Name, school, about
  if (indexPath.section == 0) {
    // Name and school
    if (indexPath.row == 0) {
      static NSString *NameCellIdentifier = @"NameCellIdentifier";
      UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
        NameCellIdentifier];
      if (!cell1)
        cell1 = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleSubtitle reuseIdentifier: NameCellIdentifier];
      cell1.detailTextLabel.font = 
        [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
      cell1.detailTextLabel.text = @"University of California - Berkeley";
      cell1.detailTextLabel.textColor = [UIColor grayMedium];
      cell1.selectionStyle = UITableViewCellSelectionStyleNone;
      cell1.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
        size: 18];
      cell1.textLabel.text = @"Edward Drake";
      cell1.textLabel.textColor = [UIColor blueDark];
      return cell1;
    }
    // About
    else if (indexPath.row == 1) {
      cell.textLabel.attributedText = 
        [user.about attributedStringWithFont: 
          cell.textLabel.font lineHeight: 22.0f];
      cell.textLabel.numberOfLines = 0;
    }
    // Email, phone
    else if (indexPath.row == 2) {
      static NSString *EmailPhoneCellIdentifier = @"EmailPhoneCellIdentifier";
      OMBMyRenterApplicationEmailPhoneCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          EmailPhoneCellIdentifier];
      if (!cell1)
        cell1 = [[OMBMyRenterApplicationEmailPhoneCell alloc] initWithStyle: 
          UITableViewCellStyleDefault 
            reuseIdentifier: EmailPhoneCellIdentifier];
      cell1.selectionStyle = UITableViewCellSelectionStyleNone;
      cell1.emailLabel.text = user.email;
      cell1.phoneLabel.text = [user phoneString];
      return cell1;
    }
  }
  // Co-applicants
  else if (indexPath.section == 1) {
    static NSString *CoapplicantCellIdentifier = @"CoapplicantCellIdentifier";
    OMBCoapplicantCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: 
        CoapplicantCellIdentifier];
    if (!cell1)
      cell1 = [[OMBCoapplicantCell alloc] initWithStyle: 
        UITableViewCellStyleDefault
          reuseIdentifier: CoapplicantCellIdentifier];
    if (indexPath.row % 2) {
      [cell1 loadUserData];
    }
    else {
      [cell1 loadUnregisteredUserData];
    }
    return cell1;
  }
  // Co-signers
  else if (indexPath.section == 2) {
    static NSString *CosignerCellIdentifier = @"CosignerCellIdentifier";
    OMBCosignerCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: CosignerCellIdentifier];
    if (!cell1)
      cell1 = [[OMBCosignerCell alloc] initWithStyle: 
        UITableViewCellStyleDefault
          reuseIdentifier: CosignerCellIdentifier];
    [cell1 loadData: 
    [[user.renterApplication cosignersSortedByFirstName] 
      objectAtIndex: indexPath.row]];
    return cell1;
  }
  // Pets
  else if (indexPath.section == 3) {
    static NSString *PetCellIdentifier = @"PetCellIdentifier";
    UITableViewCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: 
        PetCellIdentifier];
    if (!cell1) {
      cell1 = [[UITableViewCell alloc] initWithStyle: 
        UITableViewCellStyleDefault
          reuseIdentifier: PetCellIdentifier];
      UIImageView *imageView1 = [UIImageView new];
      imageView1.frame = CGRectMake(padding, padding, 
        standardHeight, standardHeight);
      if (user.renterApplication.cats) {
        imageView1.image = [UIImage imageNamed: @"cats_icon.png"];
      }
      else if (user.renterApplication.dogs) {
        imageView1.image = [UIImage imageNamed: @"dogs_icon.png"];
      }
      [cell1.contentView addSubview: imageView1];
      if (user.renterApplication.cats && user.renterApplication.dogs) {
        UIImageView *imageView2 = [UIImageView new];
        imageView2.frame = CGRectMake(padding + standardHeight + padding, 
          padding, standardHeight, standardHeight);
        imageView2.image = [UIImage imageNamed: @"dogs_icon.png"];
        [cell1.contentView addSubview: imageView2];
      }
    }
    return cell1;
  }
  // Rental History
  else if (indexPath.section == 4) {
    static NSString *RentalCellIdentifier = @"RentalCellIdentifier";
    OMBPreviousRentalCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: 
        RentalCellIdentifier];
    if (!cell1)
      cell1 = [[OMBPreviousRentalCell alloc] initWithStyle: 
        UITableViewCellStyleDefault
          reuseIdentifier: RentalCellIdentifier];
    [cell1 loadData: 
      [user.renterApplication.previousRentals objectAtIndex: indexPath.row]];
    return cell1;
  }
  // Work History
  else if (indexPath.section == 5) {
    static NSString *EmploymentCellIdentifier = @"EmploymentCellIdentifier";
    OMBEmploymentCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: 
        EmploymentCellIdentifier];
    if (!cell1)
      cell1 = [[OMBEmploymentCell alloc] initWithStyle: 
        UITableViewCellStyleDefault
          reuseIdentifier: EmploymentCellIdentifier];
    [cell1 loadData: 
      [[user.renterApplication employmentsSortedByStartDate] 
        objectAtIndex: indexPath.row]];
    cell1.delegate = self;
    return cell1;
  }
  // Legal Stuff
  else if (indexPath.section == 6) {
    static NSString *LegalCellIdentifier = @"LegalCellIdentifier";
    OMBLegalQuestionAndAnswerCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: 
        LegalCellIdentifier];
    if (!cell1)
      cell1 = [[OMBLegalQuestionAndAnswerCell alloc] initWithStyle: 
        UITableViewCellStyleDefault
          reuseIdentifier: LegalCellIdentifier];
    OMBLegalQuestion *legalQuestion = [legalQuestions objectAtIndex: 
      indexPath.row];
    OMBLegalAnswer *legalAnswer = 
      [user.renterApplication legalAnswerForLegalQuestion: legalQuestion];
    [cell1 loadQuestion: legalQuestion answer: legalAnswer 
      atIndexPath: indexPath];
    return cell1;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Name & school, email & phone, about
  if (section == 0) {
    // Name, school
    // About
    // Email, phone
    return 3;
  }
  // Co-applicants
  else if (section == 1) {
    return 2;
  }
  // Co-signers
  else if (section == 2) {
    return [user.renterApplication.cosigners count];
  }
  // Pets
  else if (section == 3) {
    if (user.renterApplication.cats || user.renterApplication.dogs) {
      return 1;
    }
  }
  // Rental History
  else if (section == 4) {
    return [user.renterApplication.previousRentals count];
  }
  // Work History
  else if (section == 5) {
    return [user.renterApplication.employments count];
  }
  // Legal Stuff
  else if (section == 6) {
    return [legalQuestions count];
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
heightForHeaderInSection: (NSInteger) section
{
  if (section > 0) {
    // Pets
    if (section == 3) {
      if (!user.renterApplication.cats && !user.renterApplication.dogs) {
        return 0.0f;
      }
    }
    return 13.0f * 2;
  }
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;
  // Name & school, about
  if (indexPath.section == 0) {
    // Name & school
    if (indexPath.row == 0) {
      return padding + 23.0f + 20.0f + padding;
    }
    // About
    else if (indexPath.row == 1) {
      NSAttributedString *aString = 
        [user.about attributedStringWithFont: 
          [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] 
            lineHeight: 22.0f];
      CGRect rect = [aString boundingRectWithSize: 
        CGSizeMake(tableView.frame.size.width - (padding * 2), 9999) 
          options: NSStringDrawingUsesLineFragmentOrigin context: nil];
      return padding + rect.size.height + padding;
    }
    // Email & phone
    else if (indexPath.row == 2) {
      return [OMBMyRenterApplicationEmailPhoneCell heightForCell];
    }
  }
  // Co-applicants
  else if (indexPath.section == 1) {
    return [OMBCoapplicantCell heightForCell];
  }
  // Co-signers
  else if (indexPath.section == 2) {
    return [OMBCosignerCell heightForCell];
  }
  // Pets
  else if (indexPath.section == 3) {
    return padding + standardHeight + padding;
  }
  // Rental History
  else if (indexPath.section == 4) {
    return [OMBPreviousRentalCell heightForCell];
  }
  // Work History
  else if (indexPath.section == 5) {
    return padding + (22.0f * 3) + padding;
  }
  // Legal Stuff
  else if (indexPath.section == 6) {
    OMBLegalQuestion *legalQuestion = [legalQuestions objectAtIndex: 
      indexPath.row];
    CGRect rect = [legalQuestion.question boundingRectWithSize:
      CGSizeMake([OMBLegalQuestionAndAnswerCell widthForQuestionLabel], 9999)
        font: [OMBLegalQuestionAndAnswerCell fontForQuestionLabel]];
    return padding + rect.size.height + (padding * 0.5) + 22.0f + padding;
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  CGFloat padding = 20.0f;
  AMBlurView *blurView = [[AMBlurView alloc] init];
  blurView.blurTintColor = [UIColor blueLight];
  blurView.frame = CGRectMake(0.0f, 0.0f, 
    tableView.frame.size.width, 13.0f * 2);
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
  label.frame = CGRectMake(padding, 0.0f, 
    blurView.frame.size.width - (padding * 2), blurView.frame.size.height);
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  // Co-applicants
  if (section == 1) {
    titleString = @"Co-applicants";
  }
  // Co-signers
  else if (section == 2) {
    titleString = @"Co-signers";
  }
  // Pets
  else if (section == 3) {
    titleString = @"Pets";
  }
  // Rental History
  else if (section == 4) {
    titleString = @"Rental History";
  }
  // Work History
  else if (section == 5) {
    titleString = @"Work History";
  }
  // Legal Stuff
  else if (section == 6) {
    titleString = @"Legal Stuff";
  }
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) edit
{
  NSLog(@"EDIT");
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
