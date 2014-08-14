//
//  OMBUserDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUserDetailViewController.h"

// Categories
#import "NSString+Extensions.h"
#import "NSString+PhoneNumber.h"
#import "OMBUser+Groups.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Resize.h"
// Models
#import "OMBCosigner.h"
#import "OMBEmployment.h"
#import "OMBGroup.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalQuestion.h"
#import "OMBPreviousRental.h"
#import "OMBRenterApplication.h"
#import "OMBRoommate.h"
#import "OMBUser.h"
// Stores
#import "OMBLegalQuestionStore.h"
// View
#import "OMBAttributedTextCell.h"
#import "OMBBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBCosignerCell.h"
#import "OMBEmploymentCell.h"
#import "OMBLegalQuestionCell.h"
#import "OMBManageListingsCell.h"
#import "OMBOtherUserProfileCell.h"
#import "OMBPreviousRentalCell.h"
#import "OMBRoommateCell.h"
#import "OMBTableViewCell.h"
#import "OMBUserDetailSectionHeaderCell.h"
// View controllers
#import "OMBMessageDetailViewController.h"
#import "OMBResidenceDetailViewController.h"

static const CGFloat UserDetailImagePercentage = 0.4f;

@interface OMBUserDetailViewController ()
<
  MFMailComposeViewControllerDelegate,
  OMBUserGroupsDelegate,
  UIActionSheetDelegate,
  UICollectionViewDataSource, 
  UICollectionViewDelegate, 
  UICollectionViewDelegateFlowLayout
>
{
  OMBBlurView *backView;
  CGRect backViewRect;
  UIColor *blurredImageColor;
  UIImage *blurredUserImage;
  UIBarButtonItem *contactBarButtonItem;
  NSDictionary *legalAnswers;
  NSArray *legalQuestionSizeArray;
  UILabel *nameTitleLabel;
  UIImageView *navigationBackgroundImageView;
  UIImage *navigationBarImage;
  CGFloat topSpacing;
  OMBUser *user;
  NSArray *userAttributes;
  UICollectionView *userCollectionView;
  OMBCenteredImageView *userImageView;
  UILabel *userNameLabel;
  UILabel *userSubnameTitleLabel;
}

@end

@implementation OMBUserDetailViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  return self;
}

#pragma mark - Override

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear: animated];

  // Update the images
  if ([self user].image) {
    [self updateBlurredImages];   
  }
  else {
    [[self user] downloadImageFromImageURLWithCompletion: ^(NSError *error) {
      if ([self user].image) {
        [self updateBlurredImages];
      }
    }];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Dimensions
  CGRect screen          = [self screen];
  CGFloat padding        = OMBPadding;
  CGFloat screenHeight   = CGRectGetHeight(screen);
  CGFloat screenWidth    = CGRectGetWidth(screen);
  CGFloat standardHeight = OMBStandardHeight;
  topSpacing             = padding + standardHeight;

  self.extendedLayoutIncludesOpaqueBars = YES;

  self.table.showsVerticalScrollIndicator = NO;

  // Contact button
  contactBarButtonItem = [[UIBarButtonItem alloc] initWithImage:
    [UIImage image: [UIImage imageNamed: @"group_icon.png"] 
      size: CGSizeMake(padding + 6, padding + 6)] 
        style: UIBarButtonItemStylePlain target: self 
          action: @selector(showActionSheet)];

  // Background blur view
  backgroundBlurView.imageView.alpha = 0.f;

  // Navigation background image view
  navigationBackgroundImageView = [UIImageView new];
  navigationBackgroundImageView.alpha           = 0.f;
  navigationBackgroundImageView.backgroundColor = [UIColor blackColor];
  navigationBackgroundImageView.clipsToBounds   = YES;
  navigationBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  navigationBackgroundImageView.frame = CGRectMake(0.f, 0.f, 
    screenWidth, topSpacing);
  [self.view addSubview: navigationBackgroundImageView];

  // Name title label
  nameTitleLabel = [UILabel new];
  nameTitleLabel.font = [UIFont mediumTextFontBold];
  nameTitleLabel.frame = CGRectMake(padding, padding,
    screenWidth - (padding * 2), standardHeight);
  nameTitleLabel.textAlignment = NSTextAlignmentCenter;
  nameTitleLabel.textColor = [UIColor whiteColor];
  [self.view addSubview: nameTitleLabel];

  // Back view image
  backViewRect = CGRectMake(0.0f, 0.0f,
    screenWidth, topSpacing + (screenHeight * UserDetailImagePercentage));
  UIView *backViewHolder = [[UIView alloc] initWithFrame: backViewRect];
  backViewHolder.backgroundColor = [UIColor clearColor];
  backViewHolder.clipsToBounds = YES;
  [self setupBackgroundWithView: backViewHolder startingOffsetY: 0.0f];
  backView = [[OMBBlurView alloc] initWithFrame: backViewHolder.bounds];
  backView.backgroundColor = [UIColor blackColor];
  backView.blurRadius      = 30.0f;
  backView.imageView.alpha = 0.f;
  backView.tintColor       = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [backViewHolder addSubview: backView];

  // User image
  CGFloat userImageWidth = screenHeight * UserDetailImagePercentage * 0.7f;
  userImageView = [[OMBCenteredImageView alloc] initWithFrame:
    CGRectMake((screenWidth - userImageWidth) * 0.5f, topSpacing, 
      userImageWidth, userImageWidth)];
  userImageView.alpha              = 0.f;
  userImageView.backgroundColor    = [UIColor blackColor];
  userImageView.layer.cornerRadius = userImageWidth * 0.5f;
  [self.view insertSubview: userImageView belowSubview: self.table];
  
  // User full name
  userNameLabel = [UILabel new];
  userNameLabel.font = [UIFont mediumTextFontBold];
  userNameLabel.frame = CGRectMake(padding, 
    CGRectGetMinY(userImageView.frame) + CGRectGetHeight(userImageView.frame),
      screenWidth - (padding * 2), 27.f);
  userNameLabel.textAlignment = NSTextAlignmentCenter;
  userNameLabel.textColor = [UIColor whiteColor];
  [self.view insertSubview: userNameLabel belowSubview: userImageView];

  // User subtitle (school, student, landlord)
  userSubnameTitleLabel = [UILabel new];
  userSubnameTitleLabel.font = [UIFont normalTextFont];
  userSubnameTitleLabel.frame = CGRectMake(CGRectGetMinX(userNameLabel.frame),
    CGRectGetMinY(userNameLabel.frame) + CGRectGetHeight(userNameLabel.frame),
      CGRectGetWidth(userNameLabel.frame), 22.f);
  userSubnameTitleLabel.textAlignment = userNameLabel.textAlignment;
  userSubnameTitleLabel.textColor = userNameLabel.textColor;
  [self.view insertSubview: userSubnameTitleLabel belowSubview: userNameLabel];

  // User collection view
  // Layout
  UICollectionViewFlowLayout *layout = 
    [[UICollectionViewFlowLayout alloc] init];

  // Collection view
  CGFloat userCollectionViewHeight = (padding * 3) +
    ([OMBOtherUserProfileCell heightForCell] * 2);
  userCollectionView = [[UICollectionView alloc] initWithFrame:
    CGRectMake(0.0, 0.f, screenWidth, userCollectionViewHeight)
      collectionViewLayout: layout];
  userCollectionView.backgroundColor = [UIColor whiteColor];
  userCollectionView.dataSource = self;
  userCollectionView.delegate   = self;

  [userCollectionView registerClass: [OMBOtherUserProfileCell class]
    forCellWithReuseIdentifier: [OMBOtherUserProfileCell reuseIdentifier]];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self animateStatusBarLight];
  [self setNavigationControllerNavigationBarTransparent];
  [self updateNameTitleLabelOpacity];

  if (![[self user] isCurrentUser]) {
    self.navigationItem.rightBarButtonItem = contactBarButtonItem;
  }

  // Resize collection view
  CGFloat padding = OMBPadding;
  // Use the padding for inset top, bottom and spacing in between each row
  CGFloat userCollectionViewHeight = (padding * 3) +
    [OMBOtherUserProfileCell heightForCell] * 2;
  // If user is landlord and not subletter, do not show Facebook & LinkedIn
  if ([[self user] isLandlord] && ![[self user] isSubletter]) {
    userCollectionViewHeight = (padding * 2) +
      ([OMBOtherUserProfileCell heightForCell] * 1);
  }
  CGRect collectionViewRect = userCollectionView.frame;
  collectionViewRect.size.height = userCollectionViewHeight;
  userCollectionView.frame = collectionViewRect;

  // Fetch
  // Profile and renter application
  [[self user] fetchUserProfileWithCompletion: ^(NSError *error) {
    [self reloadTable];
    [self updateUserInfoData];
  }];
  if ([[self user] isLandlord]) {
    // Listings
    [[self user] fetchListingsWithCompletion: ^(NSError *error) {
      [self reloadTable];
    }];
  }
  else {
    // Roommates
    [user fetchPrimaryGroupWithAccessToken:@"" delegate:self];
    // Cosigners
    [[self renterApplication] fetchCosignersForUserUID: [self user].uid
      delegate: self completion: ^(NSError *error) {
        [self reloadTable];
    }];
    // Previous rentals
    [self fetchObjectsForResourceName: [OMBPreviousRental resourceName]];
    // Employments
    [self fetchObjectsForResourceName: [OMBEmployment resourceName]];
    // Legal questions
    [[self user] fetchLegalAnswersWithCompletion: ^(NSError *error) {
      legalAnswers = [NSDictionary dictionaryWithDictionary:
        [self renterApplication].legalAnswers];
      [self setupLegalQuestionSizeArray];
      [self reloadTable];
    }];
  }

  [self updateUserInfoData];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  [self animateStatusBarDefault];
  [self setNavigationControllerNavigationBarDefault];
  self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (UIColor *) blurredImageColor
{
  if (!blurredImageColor) {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [backView.imageView.image drawInRect: self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    blurredImageColor = [UIColor colorWithPatternImage: image];
  }
  return blurredImageColor;
}

- (NSArray *) cosigners
{
  return [[self renterApplication] cosignersSortedByFirstName];
}

- (void) email: (NSArray *) recipients
{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailer =
      [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    // Subject
    [mailer setSubject: @"Hello"];
    // Recipients
    [mailer setToRecipients: recipients];
    // Body
    NSString *emailBody = @"";
    [mailer setMessageBody: emailBody isHTML: NO];
    if (mailer) {
      [self presentViewController: mailer animated: YES completion: nil];
    }
  }
}

- (void) emailCosigner: (id) sender
{
  OMBCosigner *cosigner = [[self cosigners] objectAtIndex: 
    ((UIButton *) sender).tag];
  [self email: @[cosigner.email]];
}

- (NSArray *) employments
{
  return [[self renterApplication] employmentsSortedByStartDate];
}

- (void) fetchObjectsForResourceName: (NSString *) resourceName
{
  [[self renterApplication] fetchListForResourceName: resourceName
    userUID: [self user].uid delegate: self completion: ^(NSError *error) {
      [self reloadTable];
  }];
}

- (NSArray *) listings
{
  return [[self user] residencesActive: YES sortedWithKey: @"createdAt" 
    ascending: NO];
}

- (void) phoneCall: (NSString *) phone
{
  if ([phone length]) {
    NSString *string = [@"telprompt:" stringByAppendingString: phone];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: string]];
  }
}

- (void) phoneCallCosigner: (id) sender
{
  OMBCosigner *cosigner = [[self cosigners] objectAtIndex: 
    ((UIButton *) sender).tag];
  [self phoneCall: cosigner.phone];
}

- (void) phoneCallUser
{
  if (![[self user] isCurrentUser]) {
    [self phoneCall: [[self user].phone stringWithNumbersOnly]];
  }
}

- (NSArray *) previousRentals
{
  return [[self renterApplication] objectsWithModelName:
    [OMBPreviousRental modelName] sortedWithKey: @"moveInDate" ascending: NO];
}

- (void) reloadTable
{
  [self.table reloadData];
}

- (OMBRenterApplication *) renterApplication
{
  return [self user].renterApplication;
}

- (NSArray *)roommates
{
  return [[user primaryGroup] otherUsersAndInvitations:user];
}

- (void) setupLegalQuestionSizeArray
{
  CGFloat padding = OMBPadding;
  NSMutableArray *array = [NSMutableArray array];
  NSArray *legalQuestions = 
    [[OMBLegalQuestionStore sharedStore] questionsSortedByQuestion];
  for (OMBLegalQuestion *legalQuestion in legalQuestions) {
    NSString *text = [NSString stringWithFormat: @"%i. %@",
      [legalQuestions indexOfObject: legalQuestion] + 1, 
        legalQuestion.question];
    CGRect rect = [text boundingRectWithSize:
      CGSizeMake([OMBLegalQuestionCell widthForQuestionLabel], 9999.f)
        options: NSStringDrawingUsesLineFragmentOrigin
          attributes: @{ 
            NSFontAttributeName: 
              [OMBLegalQuestionCell fontForQuestionLabelForOtherUser] 
            }
          context: nil];
    CGFloat height = padding + CGRectGetHeight(rect) + (padding * 0.5f) +
      22.f + padding;
    OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey:
      @(legalQuestion.uid)];
    if (legalAnswer && legalAnswer.answer && 
      [legalAnswer.explanation stripWhiteSpace].length) {
      
      CGRect rect2 = [legalAnswer.explanation boundingRectWithSize:
        CGSizeMake([OMBLegalQuestionCell widthForQuestionLabel], 9999.f)
          options: NSStringDrawingUsesLineFragmentOrigin
            attributes: @{ 
              NSFontAttributeName: 
                [OMBLegalQuestionCell fontForQuestionLabelForOtherUser] 
              }
            context: nil];
      height += CGRectGetHeight(rect2);
    }
    [array addObject: @(height)];
  }
  legalQuestionSizeArray = [NSArray arrayWithArray: array];
}

- (void) showActionSheet
{
  // Contact action sheet
  UIActionSheet *actionSheet;
  if ([[self user] hasPhone]) {
    actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self 
      cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil 
        otherButtonTitles: @"Send Message", @"Call Phone", nil];
  }
  else {
    actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self 
      cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil 
        otherButtonTitles: @"Send Message", nil]; 
  }
  if (actionSheet) {
    [actionSheet showInView: self.view];
  }
}

- (void) updateBlurredImages
{
  if (!blurredUserImage) {
    blurredUserImage = [self user].image;
    // Update image
    [backgroundBlurView refreshWithImage: blurredUserImage];
    [backView refreshWithImage: blurredUserImage];
    [userImageView setImage: blurredUserImage];
    [UIView animateWithDuration: OMBStandardDuration animations: ^{
      backgroundBlurView.imageView.alpha = 1.f;
      backView.imageView.alpha           = 1.f;
      userImageView.alpha                = 1.f;
    }];
  }
}

- (void) updateNameTitleLabelOpacity
{
  CGFloat offsetY = self.table.contentOffset.y;
  CGFloat offsetY2 = offsetY;
  if (offsetY2 < 0) {
    offsetY2 = 0;
  }
  CGFloat alpha =
    pow(offsetY2 / (CGRectGetHeight(userImageView.frame) * 1.3), 4.f);
  if (alpha > 1.f) {
    alpha = 1.f;
  }
  else if (alpha < 0.f) {
    alpha = 0.f;
  }
  nameTitleLabel.alpha = alpha;
}

- (void) updateUserInfoData
{
  // Name title label
  nameTitleLabel.text = [[self user] fullName];

  // Update the contact toolbar, email, phone

  // Update name
  userNameLabel.text = [[self user] fullName];
  // Update subtitle
  // If user is landlord and not subletter
  if ([[self user] isLandlord] && ![[self user] isSubletter]) {
    userSubnameTitleLabel.text = @"Landlord";
  }
  else if ([self user].school && [[self user].school length]) {
    userSubnameTitleLabel.text = [self user].school;
  }
  else {
    userSubnameTitleLabel.text = @"No school specified";
  }

  // Collection view
  userAttributes = @[
    @{
      @"imageName": @"phone_icon.png",
      @"name":      @"Phone",
      @"value": [user.phone length] ? @"Verified" : @"Not verified",
    },
    @{
      @"imageName": @"messages_icon_dark.png",
      @"name":      @"Email",
      @"value": [user.email length] ? @"Verified" : @"Not verified",
    },
    /*@{
      @"imageName": @"group_icon.png",
      @"name":      @"Co-applicants",
      @"value": [NSString stringWithFormat: @"%i",
        user.renterApplication.coapplicantCount],
    },
    @{
      @"imageName": @"landlord_icon.png",
      @"name":      @"Co-signers",
      @"value": user.renterApplication.hasCosigner ? @"Yes" : @"No",
    },*/
    @{
      @"imageName": @"facebook_icon_blue.png",
      @"name":      @"Facebook",
      @"value": user.renterApplication.facebookAuthenticated ?
        @"Verified" : @"Not verified",
    },
    @{
      @"imageName": @"linkedin_icon.png",
      @"name": @"LinkedIn",
      @"value": user.renterApplication.linkedinAuthenticated ?
        @"Verified" : @"Not verified",
    },
  ];
}

- (void) setNavigationBarImage
{
  UIImage *image = [self user].image;
  // Blur image
  CGSize blurredImageSize = CGSizeMake(image.size.width * image.scale,
    image.size.height * image.scale);
  UIGraphicsBeginImageContextWithOptions(blurredImageSize, NO, 
    [UIScreen mainScreen].scale);
  [image drawInRect: CGRectMake(0.f, 0.f, 
    blurredImageSize.width, blurredImageSize.height)];
  UIImage *blurredImage = [image applyBlurWithRadius: 
    backView.blurRadius tintColor: backView.tintColor
      saturationDeltaFactor: 1.5 maskImage: nil];
  UIGraphicsEndImageContext();

  CGFloat adjustment = 
    (CGRectGetHeight(backView.frame) - topSpacing) / scrollFactor;
  // adjustment *= scaleRatio;
  UIImage *resizedImage = [UIImage image: blurredImage
    size: blurredImageSize point: CGPointMake(0.f, adjustment)];

  navigationBarImage = resizedImage;
  navigationBackgroundImageView.image = navigationBarImage;

  // CGFloat height = topSpacing;
  // CGFloat width  = CGRectGetWidth(backViewRect);

  // CGSize imageSize = CGSizeMake(width, height);
  // // Blur image
  // UIGraphicsBeginImageContextWithOptions(imageSize, NO, 
  //   [UIScreen mainScreen].scale);
  // [image drawInRect: CGRectMake(0.f, 0.f, 
  //   imageSize.width, imageSize.height)];
  // UIImage *blurredImage = [image applyBlurWithRadius: 
  //   backView.blurRadius tintColor: backView.tintColor
  //     saturationDeltaFactor: 1.5 maskImage: nil];
  // UIGraphicsEndImageContext();

  // CGFloat adjustment = 
  //   (CGRectGetHeight(backView.frame) - topSpacing) / scrollFactor;
  // CGFloat cropRatio = image.size.width / width;
  // // Crop image
  // CGRect cropRect = CGRectMake(0.f, adjustment, 
  //   image.scale * image.size.width, image.scale * height * cropRatio);
  // CGImageRef imageRef = CGImageCreateWithImageInRect(
  //   [blurredImage CGImage], cropRect);
  // UIImage *croppedImage = [UIImage imageWithCGImage: imageRef];
  // CGImageRelease(imageRef);
  
  // // Resize image
  // UIImage *resizedImage = [UIImage image: croppedImage size: imageSize];

  // navigationBarImage = resizedImage;
  // navigationBackgroundImageView.image = navigationBarImage;
}

- (void) updateNavigationImage
{
  // Navigation bar image
  if (!navigationBarImage) {
    if ([self user].image) {
      [self setNavigationBarImage];   
    }
    else {
      [[self user] downloadImageFromImageURLWithCompletion: ^(NSError *error) {
        [self setNavigationBarImage];
      }];
    }
  }
}

- (OMBUser *) user
{
  return user;
}

#pragma mark - Protocol

#pragma mark - Protocol MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController *) controller
didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error
{
  [controller dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
forResourceName: (NSString *) resourceName
{
  // Cosigners
  if ([resourceName isEqualToString: [OMBCosigner resourceName]]) {
    [[self renterApplication] readFromCosignerDictionary: dictionary];
  }
  // Previous rentals
  else if ([resourceName isEqualToString: [OMBPreviousRental resourceName]]) {
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBPreviousRental modelName]];
  }
  // Employments
  else if ([resourceName isEqualToString: [OMBEmployment resourceName]]) {
    [[self renterApplication] readFromDictionary: dictionary
      forModelName: [OMBEmployment modelName]];
  }
}

#pragma mark - Protocol OMBUserGroupsDelegate

- (void)primaryGroupFetchedFailed:(NSError *)error {
  [self showAlertViewWithError:error];
}

- (void)primaryGroupFetchedSucceeded {
  [self.table reloadSections:
    [NSIndexSet indexSetWithIndex:OMBUserDetailSectionRoommates]
      withRowAnimation:UITableViewRowAnimationFade]; 
}

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  // Send Message
  if (buttonIndex == 0) {
    if (![[self user] isCurrentUser]) {
      [self.navigationController pushViewController:
        [[OMBMessageDetailViewController alloc] initWithUser: [self user]]
          animated: YES];
    }
  }
  // Call Phone
  else if (buttonIndex == 1) {
    [self phoneCallUser];
  }
}

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBOtherUserProfileCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
      [OMBOtherUserProfileCell reuseIdentifier] forIndexPath: indexPath];

  NSInteger row = indexPath.row;
  NSDictionary *dictionary = [userAttributes objectAtIndex: row];
  UIImage *image = [UIImage image: [UIImage imageNamed:
    [dictionary objectForKey: @"imageName"]] size: cell.imageView.frame.size];
  cell.imageView.image = image;
  cell.label.text      = [dictionary objectForKey: @"name"];
  cell.valueLabel.text = [dictionary objectForKey: @"value"];
  // Facebook
  if (row == 2 && [self renterApplication].facebookAuthenticated) {
    cell.imageView.alpha = 1.0f;
  }
  // LinkedIn
  else if (row == 3 && [self renterApplication].linkedinAuthenticated) {
    cell.imageView.alpha = 1.0f;
  }
  cell.clipsToBounds = YES;
  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
numberOfItemsInSection: (NSInteger) section
{
  // If user is a landlord and not a subletter
  if ([[self user] isLandlord] && ![[self user] isSubletter]) {
    return 2;
  }
  return 4;
}

- (NSInteger) numberOfSectionsInCollectionView:
(UICollectionView *) collectionView
{
  return 1;
}

#pragma mark - Protocol UICollectionViewDelegateFlowLayout

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView
layout: (UICollectionViewLayout*) collectionViewLayout
insetForSectionAtIndex: (NSInteger) section
{
  return UIEdgeInsetsMake(OMBPadding, OMBPadding, OMBPadding, OMBPadding);
}

- (CGFloat) collectionView: (UICollectionView *) collectionView
layout: (UICollectionViewLayout*) collectionViewLayout
minimumInteritemSpacingForSectionAtIndex: (NSInteger) section
{
  return OMBPadding;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView
layout: (UICollectionViewLayout*) collectionViewLayout
minimumLineSpacingForSectionAtIndex: (NSInteger) section
{
  return OMBPadding;
}

- (CGSize) collectionView: (UICollectionView * ) collectionView
layout: (UICollectionViewLayout*) collectionViewLayout
sizeForItemAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat width = (collectionView.frame.size.width - (OMBPadding * 3)) * 0.5f;
  return CGSizeMake(width, [OMBOtherUserProfileCell heightForCell]);
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  [super scrollViewDidScroll: scrollView];

  // Adjust the transparency of the view controller's title
  [self updateNameTitleLabelOpacity];

  CGFloat offsetY = scrollView.contentOffset.y;

  // Adjust transparency of user name and subtitle
  if (offsetY >= CGRectGetHeight(userCollectionView.frame)) {
    userNameLabel.alpha     = 0.f;
    userSubnameTitleLabel.alpha = 0.f;
  }
  else {
    userNameLabel.alpha     = 1.f;
    userSubnameTitleLabel.alpha = 1.f;
  }
  // Adjust transparency of user circular image
  CGFloat offsetY2 = offsetY;
  if (offsetY2 < 0) {
    offsetY2 = 0;
  }
  CGFloat userImageViewAlpha =
    pow(offsetY2 / (CGRectGetHeight(userImageView.frame) * 1.3), 4.f);
  userImageViewAlpha = 1 - userImageViewAlpha;
  if (userImageViewAlpha > 1.f) {
    userImageViewAlpha = 1.f;
  }
  else if (userImageViewAlpha < 0.f) {
    userImageViewAlpha = 0.f;
  }
  userImageView.alpha = userImageViewAlpha;

  // Navigation bar background image
  [self updateNavigationImage];
  if (offsetY >= CGRectGetHeight(backView.frame) - topSpacing) {
    // self.navigationController.navigationBar.translucent = NO;
    // [self.navigationController.navigationBar setBackgroundImage: 
    //   navigationBarImage forBarMetrics: UIBarMetricsDefault];
    navigationBackgroundImageView.alpha = 1.f;
  }
  else {
    // self.navigationController.navigationBar.translucent = YES;
    // [self.navigationController.navigationBar setBackgroundImage: 
    //   [UIImage new] forBarMetrics: UIBarMetricsDefault];
    navigationBackgroundImageView.alpha = 0.f;
  }

  // NSLog(@"%f", userImageViewAlpha);
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 8;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  CGFloat padding   = OMBPadding;
  CGFloat width     = CGRectGetWidth(tableView.frame);

  UIColor *cellBackgroundColor = [UIColor clearColor];
  UIEdgeInsets maxInsets       = UIEdgeInsetsMake(0.0f, width, 0.0f, 0.0f);
  UIView *selectedBackgroundView = [[UIImageView alloc] initWithImage:
    [UIImage imageWithColor: [UIColor blueLightAlpha: 0.5f]]];

  // About
  if (section == OMBUserDetailSectionAbout) {
    // About
    if (row == OMBUserDetailSectionAboutRowAbout) {
      static NSString *AboutID = @"AboutID";
      OMBAttributedTextCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: AboutID];
      if (!cell) {
        cell = [[OMBAttributedTextCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: AboutID];
        NSString *text = @"Nothing about me yet.";
        if ([self user].about && [[self user].about length]) {
          text = [self user].about;
        }
        cell.attributedTextLabel.attributedText = 
          [text attributedStringWithFont: [UIFont normalTextFont] 
            lineHeight: 22.f];
        CGFloat h = [[self user] heightForAboutTextWithWidth: 
          width - (padding * 2)];
        if (h < 22.0f) {
          h = 22.0f;
        }
        cell.attributedTextLabel.frame = CGRectMake(padding, padding,
          width - (padding * 2), h);
        cell.attributedTextLabel.numberOfLines = 0;
        cell.attributedTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.attributedTextLabel.textColor     = [UIColor textColor];
        cell.backgroundColor                   = [UIColor whiteColor];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.separatorInset  = UIEdgeInsetsZero;
      }
      cell.clipsToBounds   = YES;
      return cell;
    }
  }

  // Stats
  else if (section == OMBUserDetailSectionStats) {
    // Collection view
    if (row == OMBUserDetailSectionStatsRowCollectionView) {
      static NSString *CollectionViewID = @"CollectionViewID";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        CollectionViewID];
      if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: CollectionViewID];
        [cell.contentView addSubview: userCollectionView];
      }
      cell.backgroundColor = [UIColor whiteColor];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.separatorInset = maxInsets;
      cell.clipsToBounds  = YES;
      return cell;
    }
  }

  // Roommates
  else if (section == OMBUserDetailSectionRoommates) {
    // Header
    if (row == 0) {
      static NSString *RoommatesHeaderID = @"RoommatesHeaderID";
      OMBUserDetailSectionHeaderCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:
          RoommatesHeaderID];
      if (!cell) {
        cell = [[OMBUserDetailSectionHeaderCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: RoommatesHeaderID];
      }
      cell.headerLabel.text = @"CO-APPLICANTS";
      cell.clipsToBounds    = YES;
      return cell;
    }
    // Roommates
    else {
      static NSString *RoommateID = @"RoommateID";
      OMBRoommateCell *cell = [tableView dequeueReusableCellWithIdentifier:
        RoommateID];
      if (!cell) {
        cell = [[OMBRoommateCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: RoommateID];
      }
      if (row == [[self roommates] count]) {
        cell.separatorInset = maxInsets;
      }
      else {
        cell.separatorInset = tableView.separatorInset;
      }
      id object = [[self roommates] objectAtIndex: row - 1];
      // User
      if ([object isKindOfClass:[OMBUser class]]) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell loadDataFromUser:object];
      }
      // Invitation
      else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadDataFromInvitation:object];
      }
      cell.clipsToBounds          = YES;
      cell.selectedBackgroundView = selectedBackgroundView;
      return cell;
    }
  }

  // Cosigners
  else if (section == OMBUserDetailSectionCosigners) {
    // Header
    if (row == 0) {
      static NSString *CosignersHeaderID = @"CosignersHeaderID";
      OMBUserDetailSectionHeaderCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:
          CosignersHeaderID];
      if (!cell) {
        cell = [[OMBUserDetailSectionHeaderCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CosignersHeaderID];
      }
      cell.headerLabel.text = @"CO-SIGNER";
      cell.clipsToBounds    = YES;
      return cell;
    }
    // Cosigners
    else {
      static NSString *CosignerID = @"CosignerID";
      OMBCosignerCell *cell = [tableView dequeueReusableCellWithIdentifier:
        CosignerID];
      if (!cell) {
        cell = [[OMBCosignerCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CosignerID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      if (row == [[self cosigners] count]) {
        cell.separatorInset = maxInsets;
      }
      else {
        cell.separatorInset = tableView.separatorInset;
      }
      cell.emailButton.tag = row - 1;
      cell.phoneButton.tag = row - 1;
      [cell.emailButton addTarget: self action: @selector(emailCosigner:)
        forControlEvents: UIControlEventTouchUpInside];
      [cell.phoneButton addTarget: self action: @selector(phoneCallCosigner:)
        forControlEvents: UIControlEventTouchUpInside];
      [cell loadData: [[self cosigners] objectAtIndex: row - 1]];
      cell.clipsToBounds = YES;
      return cell;
    }
  }

  // Previous rentals
  else if (section == OMBUserDetailSectionPreviousRentals) {
    // Header
    if (row == 0) {
      static NSString *PreviousRentalHeaderID = @"PreviousRentalHeaderID";
      OMBUserDetailSectionHeaderCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:
          PreviousRentalHeaderID];
      if (!cell) {
        cell = [[OMBUserDetailSectionHeaderCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: PreviousRentalHeaderID];
      }
      cell.headerLabel.text = @"RENTAL HISTORY";
      cell.clipsToBounds    = YES;
      return cell;
    }
    // Previous rentals
    else {
      static NSString *PreviousRentalID = @"PreviousRentalID";
      OMBPreviousRentalCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: PreviousRentalID];
      if (!cell) {
        cell = [[OMBPreviousRentalCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: PreviousRentalID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      if (row == [[self previousRentals] count]) {
        cell.separatorInset = maxInsets;
      }
      else {
        cell.separatorInset = tableView.separatorInset;
      }
      [cell loadData2: [[self previousRentals] objectAtIndex: row - 1]];
      cell.clipsToBounds = YES;
      return cell;
    }
  }

  // Employments
  else if (section == OMBUserDetailSectionEmployments) {
    // Header
    if (row == 0) {
      static NSString *EmploymentHeaderID = @"EmploymentHeaderID";
      OMBUserDetailSectionHeaderCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:
          EmploymentHeaderID];
      if (!cell) {
        cell = [[OMBUserDetailSectionHeaderCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: EmploymentHeaderID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
      cell.headerLabel.text = @"WORK HISTORY";
      cell.clipsToBounds    = YES;
      return cell;
    }
    // Employments
    else {
      static NSString *EmploymentID = @"EmploymentID";
      OMBEmploymentCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: EmploymentID];
      if (!cell) {
        cell = [[OMBEmploymentCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: EmploymentID];
      }
      if (row == [[self employments] count]) {
        cell.separatorInset = maxInsets;
      }
      else {
        cell.separatorInset = tableView.separatorInset;
      }
      [cell loadData: [[self employments] objectAtIndex: row - 1]];
      cell.clipsToBounds = YES;
      return cell;
    }
  }

  // Legal questions
  else if (section == OMBUserDetailSectionLegalQuestions) {
    // Header
    if (row == 0) {
      static NSString *LegalQuestionHeaderID = @"LegalQuestionHeaderID";
      OMBUserDetailSectionHeaderCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:
          LegalQuestionHeaderID];
      if (!cell) {
        cell = [[OMBUserDetailSectionHeaderCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: LegalQuestionHeaderID];
      }
      cell.headerLabel.text = @"LEGAL QUESTIONS";
      cell.clipsToBounds    = YES;
      return cell;
    }
    // Legal questions
    else {
      static NSString *LegalQuestionID = @"LegalQuestionID";
      OMBLegalQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:
        LegalQuestionID];
      if (!cell) {
        cell = [[OMBLegalQuestionCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: LegalQuestionID];
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      OMBLegalQuestion *legalQuestion = [[[OMBLegalQuestionStore sharedStore]
        questionsSortedByQuestion] objectAtIndex: row - 1];
      // Load the question
      [cell loadData: legalQuestion atIndexPathForOtherUser:
        [NSIndexPath indexPathForRow: row - 1  inSection:section]];
      // Load the answer
      OMBLegalAnswer *legalAnswer = [legalAnswers objectForKey:
        [NSNumber numberWithInt: legalQuestion.uid]];
      [cell loadLegalAnswerForOtherUser: legalAnswer];
      
      if (row == [[[OMBLegalQuestionStore sharedStore] 
        questionsSortedByQuestion] count]) {
        cell.separatorInset = maxInsets;
      }
      else {
        cell.separatorInset = tableView.separatorInset;
      }
      cell.clipsToBounds = YES;
      return cell;
    }
  }

  // Listings
  else if (section == OMBUserDetailSectionListings) {
    // Header
    if (row == 0) {
      static NSString *ListingsHeaderID = @"ListingsHeaderID";
      OMBUserDetailSectionHeaderCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:
          ListingsHeaderID];
      if (!cell) {
        cell = [[OMBUserDetailSectionHeaderCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: ListingsHeaderID];
      }
      cell.headerLabel.text = @"LISTINGS";
      cell.clipsToBounds    = YES;
      return cell;
    }
    // Listings
    else {
      static NSString *ListingsID = @"ListingsID";
      OMBManageListingsCell *cell = 
        [tableView dequeueReusableCellWithIdentifier: ListingsID];
      if (!cell) {
        cell = [[OMBManageListingsCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: ListingsID];
      }
      [cell loadResidenceData: [[self listings] objectAtIndex: row - 1]];
      cell.separatorInset     = UIEdgeInsetsZero;
      cell.statusLabel.hidden = YES;
      cell.clipsToBounds      = YES;
      return cell;
    }
  }

  static NSString *EmptyCellID = @"EmptyCellID";
  UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:
    EmptyCellID];
  if (!emptyCell) {
    emptyCell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier: EmptyCellID];
  }
  emptyCell.backgroundColor = cellBackgroundColor;
  emptyCell.clipsToBounds   = YES;
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // About
  if (section == OMBUserDetailSectionAbout) {
    return 1;
  }
  // Stats
  else if (section == OMBUserDetailSectionStats) {
    return 1;
  }

  // Landlord
  if ([[self user] isLandlord]) {
    // Listings
    if (section == OMBUserDetailSectionListings) {
      if ([[self listings] count]) {
        return 1 + [[self listings] count];
      }
    }
  }
  // Student
  else {
    // Roommates
    if (section == OMBUserDetailSectionRoommates) {
      if ([[self roommates] count]) {
        return 1 + [[self roommates] count];
      }
    }
    // Cosigners
    else if (section == OMBUserDetailSectionCosigners) {
      if ([[self cosigners] count]) {
        return 1 + [[self cosigners] count];
      }
    }
    // Previous rentals
    else if (section == OMBUserDetailSectionPreviousRentals) {
      if ([[self previousRentals] count]) {
        return 1 + [[self previousRentals] count];
      }
    }
    // Employments
    else if (section == OMBUserDetailSectionEmployments) {
      if ([[self employments] count]) {
        return 1 + [[self employments] count];
      }
    }
    // Legal Question
    else if (section == OMBUserDetailSectionLegalQuestions) {
      if ([[[OMBLegalQuestionStore sharedStore]
        questionsSortedByQuestion] count]) {
        return 1 + [[[OMBLegalQuestionStore sharedStore]
          questionsSortedByQuestion] count];
      }
    }
  }
  return 0;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  CGFloat padding   = OMBPadding;
  CGFloat width     = CGRectGetWidth(tableView.frame);
  CGFloat headerHeight = [OMBUserDetailSectionHeaderCell heightForCell];

  // About
  if (section == OMBUserDetailSectionAbout) {
    // About
    if (row == OMBUserDetailSectionAboutRowAbout) {
      CGFloat height =
        [[self user] heightForAboutTextWithWidth: width - (padding * 2)];
      if (height < 22.0f) {
        height = 22.0f;
      }
      return padding + height + padding;
    }
  }
  // Stats
  else if (section == OMBUserDetailSectionStats) {
    // Collection view
    if (row == OMBUserDetailSectionStatsRowCollectionView) {
      return CGRectGetHeight(userCollectionView.frame);
    }
  }
  // Roommates
  else if (section == OMBUserDetailSectionRoommates) {
    // Header
    if (row == 0) {
      return headerHeight;
    }
    else {
      return [OMBRoommateCell heightForCell];
    }
  }
  // Cosigners
  else if (section == OMBUserDetailSectionCosigners) {
    // Header
    if (row == 0) {
      return headerHeight;
    }
    else {
      return [OMBCosignerCell heightForCell];
    }
  }
  // Previous rentals
  else if (section == OMBUserDetailSectionPreviousRentals) {
    // Header
    if (row == 0) {
      return headerHeight;
    }
    else {
      CGFloat adjustment       = 0.f;
      CGFloat adjustmentHeight = 22.f;
      OMBPreviousRental *previousRental = 
        [[self previousRentals] objectAtIndex: row - 1];
      if ([[previousRental.landlordName stripWhiteSpace] length] > 0) {
        adjustment += adjustmentHeight;
      }
      if ([[previousRental.landlordEmail stripWhiteSpace] length] > 0) {
        adjustment += adjustmentHeight;
      }
      if ([[[previousRental.landlordPhone stripWhiteSpace] 
        phoneNumberString] length] > 0) {
        adjustment += adjustmentHeight;
      }
      if (adjustment > 0.f) {
        adjustment += padding;
      }
      return [OMBPreviousRentalCell heightForCell2] + adjustment;
    }
  }
  // Employments
  else if (section == OMBUserDetailSectionEmployments) {
    // Header
    if (row == 0) {
      return headerHeight;
    }
    else {
      return [OMBEmploymentCell heightForCell];
    }
  }
  // Legal questions
  else if (section == OMBUserDetailSectionLegalQuestions) {
    // Header
    if (row == 0) {
      return headerHeight;
    }
    else {
      if (legalQuestionSizeArray) {
        return [[legalQuestionSizeArray objectAtIndex: row - 1] floatValue];
      }
    }
  }
  // Listings
  else if (section == OMBUserDetailSectionListings) {
    // Header
    if (row == 0) {
      return headerHeight;
    }
    else {
      return [OMBManageListingsCell heightForCell];
    }
  }
  return 0.f;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  // Roommates
  if (section == OMBUserDetailSectionRoommates) {
    if (row > 0 ) {
      id object = [[self roommates] objectAtIndex: row - 1];
      // If user
      if ([object isKindOfClass:[OMBUser class]]) {
        [self.navigationController pushViewController:
          [[OMBUserDetailViewController alloc] initWithUser:object] 
            animated:YES];
      }
    }
  }
  // Listings
  else if (section == OMBUserDetailSectionListings) {
    if (row > 0) {
      [self.navigationController pushViewController:
        [[OMBResidenceDetailViewController alloc] initWithResidence:
          [[self listings] objectAtIndex: indexPath.row - 1]]
            animated: YES];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
