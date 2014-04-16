//
//  OMBManageListingDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBManageListingDetailViewController.h"

#import "NSString+Extensions.h"
#import "OMBCenteredImageView.h"
#import "OMBFinishListingViewController.h"
#import "OMBImageOneLabelCell.h"
#import "OMBManageListingDetailEditCell.h"
#import "OMBManageListingDetailStatusCell.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceImagesConnection.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Resize.h"
#import "OMBSwitch.h"

@interface OMBManageListingDetailViewController ()
{
  OMBCenteredImageView *backgroundImageView;
  UIImage *editCellImage;
  UIImage *previewCellImage;
  OMBResidence *residence;
  UIImage *statusCellImage;
}

@end

@implementation OMBManageListingDetailViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  editCellImage = [UIImage image: [UIImage imageNamed: @"house_icon.png"]
    size: [OMBManageListingDetailEditCell sizeForImage]];
  previewCellImage = [UIImage image: [UIImage imageNamed: @"eye_icon_black.png"]
    size: [OMBImageOneLabelCell sizeForImage]];
  statusCellImage = [UIImage image:
    [UIImage imageNamed: @"light_bulb_icon_black.png"]
      size: [OMBImageOneLabelCell sizeForImage]];
  residence = object;

  
  self.title = [residence titleOrAddress];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.table.separatorInset = UIEdgeInsetsMake(0.0f, OMBPadding,
    0.0f, OMBPadding);

  CGRect screen = [self screen];
  backgroundImageView = [[OMBCenteredImageView alloc] init];
  backgroundImageView.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, screen.size.height * 0.4f);
  [self setupBackgroundWithView: backgroundImageView
    startingOffsetY: OMBPadding + OMBStandardHeight];
  
  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(hideBottomStatus)];
  [fadedBackground addGestureRecognizer: tapGesture];
  
  CGFloat padding = 20.f;
  
  // Bottom status view
  CGFloat widthBottomStatus = self.view.frame.size.width;
  
  bottomStatus = [UIView new];
  bottomStatus.backgroundColor = [UIColor grayVeryLight];
  [self.view addSubview: bottomStatus];
  
  UILabel *titlelabel = [UILabel new];
  titlelabel.font = [UIFont normalSmallTextFontBold];
  titlelabel.frame = CGRectMake(padding, padding,
    widthBottomStatus - 2 * padding, 23.f);
  titlelabel.text = @"Stop listing because...";
  titlelabel.textAlignment = NSTextAlignmentCenter;
  titlelabel.textColor = [UIColor textColor];
  [bottomStatus addSubview:titlelabel];
  
  NSString *description =
    @"When you stop a listing, it is moved into your "
    @"inactive listings area. It will not be deleted.";
  CGRect rectLabel = [description boundingRectWithSize:
    CGSizeMake(widthBottomStatus - 2 * padding, 9999)
      font: [UIFont normalSmallTextFont]];
  UILabel *descriptionLabel = [UILabel new];
  descriptionLabel.font = [UIFont normalSmallTextFont];
  descriptionLabel.frame = CGRectMake(padding,
    titlelabel.frame.origin.y + titlelabel.frame.size.height + padding * 0.5f,
      widthBottomStatus - 2 * padding, rectLabel.size.height);
  descriptionLabel.numberOfLines = 0;
  descriptionLabel.text = description;
  descriptionLabel.textAlignment = NSTextAlignmentCenter;
  descriptionLabel.textColor = [UIColor grayMedium];
  [bottomStatus addSubview:descriptionLabel];

  CGSize sizeButton =
    CGSizeMake(widthBottomStatus - 2 * padding,
      OMBStandardButtonHeight);
  
  UIButton *rentedButton = [UIButton new];
  rentedButton.backgroundColor = [UIColor grayUltraLight];
  rentedButton.frame = CGRectMake(padding,
    descriptionLabel.frame.origin.y +
      descriptionLabel.frame.size.height + padding,
        sizeButton.width, sizeButton.height);
  rentedButton.layer.borderColor = [UIColor grayLight].CGColor;
  rentedButton.layer.borderWidth = 1.f;
  rentedButton.titleLabel.font = [UIFont normalTextFontBold];
  rentedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [rentedButton addTarget:self action:@selector(rented)
    forControlEvents:UIControlEventTouchUpInside];
  [rentedButton setTitle:@"I rented this pad" forState:UIControlStateNormal];
  [rentedButton setTitleColor:[UIColor grayDark] forState:UIControlStateNormal];
  [bottomStatus addSubview:rentedButton];
  
  rentedTextField = [UIButton new];
  rentedTextField.backgroundColor = [UIColor whiteColor];
  rentedTextField.frame = CGRectMake(padding,
    rentedButton.frame.origin.y + rentedButton.frame.size.height,
      sizeButton.width, sizeButton.height);
  rentedTextField.titleLabel.font = [UIFont normalTextFont];
  rentedTextField.titleLabel.textAlignment = NSTextAlignmentCenter;
  [rentedTextField addTarget:self action:@selector(showDatePicker)
    forControlEvents:UIControlEventTouchUpInside];
  [rentedTextField setTitle:@"When will this place be available?"
    forState:UIControlStateNormal];
  [rentedTextField setTitleColor:[UIColor grayLight]
    forState:UIControlStateNormal];
  [bottomStatus addSubview:rentedTextField];
  
  reasonTwoButton = [UIButton new];
  reasonTwoButton.backgroundColor = rentedButton.backgroundColor;
  reasonTwoButton.frame = CGRectMake(padding,
    rentedButton.frame.origin.y +
      rentedButton.frame.size.height - 0.5f,
        sizeButton.width, sizeButton.height);
  reasonTwoButton.layer.borderColor = rentedButton.layer.borderColor;
  reasonTwoButton.layer.borderWidth = rentedButton.layer.borderWidth;
  reasonTwoButton.titleLabel.font = rentedButton.titleLabel.font;
  [reasonTwoButton addTarget:self action:@selector(noLonger)
    forControlEvents:UIControlEventTouchUpInside];
  reasonTwoButton.titleLabel.textAlignment = rentedButton.titleLabel.textAlignment;
  [reasonTwoButton setTitle:@"I no longer want to list it !!!" forState:UIControlStateNormal];
  [reasonTwoButton setTitleColor:[UIColor grayDark] forState:UIControlStateNormal];
  [bottomStatus addSubview:reasonTwoButton];
  
  UIButton *cancelButton = [UIButton new];
  cancelButton.backgroundColor = reasonTwoButton.backgroundColor;
  cancelButton.frame = CGRectMake(padding,
    reasonTwoButton.frame.origin.y +
      reasonTwoButton.frame.size.height + padding * 0.5f,
        sizeButton.width, sizeButton.height);
  cancelButton.layer.borderColor = reasonTwoButton.layer.borderColor;
  cancelButton.layer.borderWidth = reasonTwoButton.layer.borderWidth;
  cancelButton.titleLabel.font = reasonTwoButton.titleLabel.font;
  cancelButton.titleLabel.textAlignment = reasonTwoButton.titleLabel.textAlignment;
  [cancelButton addTarget:self
    action:@selector(hideBottomStatus)
      forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
  [cancelButton setTitleColor:[UIColor blue] forState:UIControlStateNormal];
  [bottomStatus addSubview:cancelButton];
  
  datePicker = [[UIDatePicker alloc] init];
  datePicker.frame = CGRectMake(0.0f, cancelButton.frame.origin.y +
    cancelButton.frame.size.height + padding, widthBottomStatus, 100.f);
  datePicker.datePickerMode = UIDatePickerModeDate;
  datePicker.maximumDate = [NSDate date];
  [datePicker addTarget: self action: @selector(dateChanged)
     forControlEvents: UIControlEventValueChanged];
  [bottomStatus addSubview: datePicker];
  
  bottomStatus.frame =
    CGRectMake(0.0f, self.view.frame.size.height,
      widthBottomStatus, datePicker.frame.origin.y +
        padding + datePicker.frame.size.height + padding);
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self updateBackgroundImage];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      static NSString *EditID = @"EditID";
      OMBManageListingDetailEditCell *cell =
        [tableView dequeueReusableCellWithIdentifier: EditID];
      if (!cell)
        cell = [[OMBManageListingDetailEditCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: EditID];
      cell.bottomLabel.text = [NSString stringWithFormat: @"%@ - %i bd / %i ba",
        [NSString numberToCurrencyString: residence.minRent],
          (int) residence.bedrooms, (int) residence.bathrooms];
      cell.middleLabel.text = [NSString stringWithFormat: @"%@, %@",
        [residence.city capitalizedString], [residence stateFormattedString]];
      cell.topLabel.text = [residence.address capitalizedString];
      [cell setImage: editCellImage];
      return cell;
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      static NSString *PreviewID = @"PreviewID";
      OMBImageOneLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PreviewID];
      if (!cell) {
        cell = [[OMBImageOneLabelCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: PreviewID];
      }
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      [cell setFont: [UIFont normalTextFontBold]];
      [cell setImage: previewCellImage text: @"Preview Listing"];
      [cell setImageViewAlpha: 0.3f];
      [cell setImageViewCircular: NO];
      return cell;
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus) {
      static NSString *StatusID = @"StatusID";
      OMBManageListingDetailStatusCell *cell =
        [tableView dequeueReusableCellWithIdentifier: StatusID];
      if (!cell)
        cell = [[OMBManageListingDetailStatusCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: StatusID];
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      cell.textFieldLabel.text = @"Listing Status";
      [cell setImage: statusCellImage];
      // custom behavior...
      [cell setSwitchTintColor: [UIColor green]
        withOffColor: [UIColor grayColor] withOnText:@"Listed"
          andOffText:@"Unlisted"];
      [cell addTarget: self action:@selector(switchStatus)];
      return cell;
    }
  }
  return [UITableViewCell new];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Edit
  // Preview
  // Listing Status
  return 3;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      return [OMBManageListingDetailEditCell heightForCell];
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      return [OMBImageOneLabelCell heightForCell];
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus) {
      return [OMBManageListingDetailStatusCell heightForCell];
    }
  }
  return 0.0f;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    UIViewController *vc;
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      vc = [[OMBFinishListingViewController alloc] initWithResidence:
        residence];
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      vc = [[OMBResidenceDetailViewController alloc] initWithResidence:
        residence];
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus)
      [self showBottomStatus];
    
    if (vc)
      [self.navigationController pushViewController: vc animated: YES];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) dateChanged
{
  NSLog(@"dateChanged");
}

- (void) hideBottomStatus
{
  CGRect rect = bottomStatus.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    bottomStatus.frame = rect;
  }];
}

- (void) hideDatePicker
{
  isShowingPicker = NO;
  CGRect rect = bottomStatus.frame;
  rect.origin.y += datePicker.frame.size.height + 20.f;
  [UIView animateWithDuration: 0.25 animations: ^{
    bottomStatus.frame = rect;
  }];
}

- (void) noLonger
{
  
}

- (void) rented
{
  reasonTwoButton.hidden = YES;
  rentedTextField.hidden = NO;
}

- (void) showBottomStatus
{
  reasonTwoButton.hidden = NO;
  rentedTextField.hidden = YES;
  isShowingPicker = NO;
  
  CGRect rect = bottomStatus.frame;
  rect.origin.y = self.view.frame.size.height -
    rect.size.height + datePicker.frame.size.height + 20.f;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    bottomStatus.frame = rect;
  }];
}

- (void) showDatePicker
{
  if(!isShowingPicker){
    isShowingPicker = YES;
    CGRect rect1 = bottomStatus.frame;
    rect1.origin.y -= (datePicker.frame.size.height + 20.f);
    [UIView animateWithDuration:0.25 animations:^{
      bottomStatus.frame = rect1;
    }];
  }
}

- (void) switchStatus
{
  NSLog(@"switch");
}

- (void) updateBackgroundImage
{
  // Download the residence's images
  OMBResidenceImagesConnection *conn =
    [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    // Add the cover photo
    if (!backgroundImageView.image)
      [residence setImageForCenteredImageView: backgroundImageView
        withURL: residence.coverPhotoURL completion: nil];
  };
  [conn start];
}

@end
