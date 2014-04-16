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
  
  titlelabel = [UILabel new];
  titlelabel.font = [UIFont normalSmallTextFontBold];
  titlelabel.frame = CGRectMake(padding, padding,
    widthBottomStatus - 2 * padding, 23.f);
  titlelabel.textAlignment = NSTextAlignmentCenter;
  titlelabel.textColor = [UIColor textColor];
  [bottomStatus addSubview:titlelabel];
  
  NSString *description =
    @"When you stop a listing, it is moved into your "
    @"inactive listings area. It will not be deleted.";
  CGRect descriptionRect = [description boundingRectWithSize:
    CGSizeMake(widthBottomStatus - 2 * padding, 9999)
      font: [UIFont normalSmallTextFont]];
  descriptionLabel = [UILabel new];
  descriptionLabel.font = [UIFont normalSmallTextFont];
  descriptionLabel.frame = CGRectMake(padding,
    titlelabel.frame.origin.y + titlelabel.frame.size.height + padding * 0.5f,
      widthBottomStatus - 2 * padding, descriptionRect.size.height);
  descriptionLabel.numberOfLines = 0;
  descriptionLabel.text = description;
  descriptionLabel.textAlignment = NSTextAlignmentCenter;
  descriptionLabel.textColor = [UIColor grayMedium];
  [bottomStatus addSubview:descriptionLabel];

  CGSize sizeButton =
    CGSizeMake(widthBottomStatus - 2 * padding,
      OMBStandardButtonHeight);
  
  rentedButton = [UIButton new];
  rentedButton.backgroundColor = [UIColor grayUltraLight];
  rentedButton.frame = CGRectMake(padding,
    descriptionLabel.frame.origin.y +
      descriptionLabel.frame.size.height + padding,
        sizeButton.width, sizeButton.height);
  rentedButton.layer.borderColor = [UIColor grayLight].CGColor;
  rentedButton.layer.borderWidth = 1.f;
  rentedButton.titleLabel.font = [UIFont normalTextFontBold];
  rentedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [rentedButton addTarget:self action:@selector(showDatePicker)
    forControlEvents:UIControlEventTouchUpInside];
  [rentedButton setTitle:@"I rented this pad" forState:UIControlStateNormal];
  [rentedButton setTitleColor:[UIColor grayDark] forState:UIControlStateNormal];
  [bottomStatus addSubview:rentedButton];
  
  rentedTextField = [UITextField new];
  rentedTextField.backgroundColor = [UIColor whiteColor];
  rentedTextField.enabled = NO;
  rentedTextField.frame = CGRectMake(padding,
    rentedButton.frame.origin.y + rentedButton.frame.size.height,
      sizeButton.width, sizeButton.height);
  rentedTextField.font = [UIFont normalTextFont];
  rentedTextField.textAlignment = NSTextAlignmentCenter;
  rentedTextField.placeholder = @"When will this place be available?";
  rentedTextField.textColor = [UIColor textColor];
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
  
  cancelStatusButton = [UIButton new];
  cancelStatusButton.backgroundColor = reasonTwoButton.backgroundColor;
  cancelStatusButton.frame = CGRectMake(padding,
    reasonTwoButton.frame.origin.y +
      reasonTwoButton.frame.size.height + padding * 0.5f,
        sizeButton.width, sizeButton.height);
  cancelStatusButton.layer.borderColor = reasonTwoButton.layer.borderColor;
  cancelStatusButton.layer.borderWidth = reasonTwoButton.layer.borderWidth;
  cancelStatusButton.titleLabel.font = reasonTwoButton.titleLabel.font;
  cancelStatusButton.titleLabel.textAlignment = reasonTwoButton.titleLabel.textAlignment;
  [cancelStatusButton addTarget:self
    action:@selector(hideBottomStatus)
      forControlEvents:UIControlEventTouchUpInside];
  [cancelStatusButton setTitle:@"Cancel" forState:UIControlStateNormal];
  [cancelStatusButton setTitleColor:[UIColor blue] forState:UIControlStateNormal];
  [bottomStatus addSubview:cancelStatusButton];
  
  bottomStatus.frame =
    CGRectMake(0.0f, self.view.frame.size.height,
      widthBottomStatus, cancelStatusButton.frame.origin.y +
        cancelStatusButton.frame.size.height + padding);
  
  // Date picker
  // Picker view container
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];
  
  // Header for picker view with cancel and done button
  UIView *pickerViewHeader = [[UIView alloc] init];
  pickerViewHeader.backgroundColor = [UIColor grayUltraLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, 44.0f);
  [pickerViewContainer addSubview: pickerViewHeader];
  
  pickerViewHeaderLabel = [[UILabel alloc] init];
  pickerViewHeaderLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  pickerViewHeaderLabel.frame = pickerViewHeader.frame;
  pickerViewHeaderLabel.textAlignment = NSTextAlignmentCenter;
  pickerViewHeaderLabel.textColor = [UIColor textColor];
  [pickerViewHeader addSubview: pickerViewHeaderLabel];
  // Cancel button
  UIButton *cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont fontWithName:
    @"HelveticaNeue-Medium" size: 15];
  CGRect cancelButtonRect = [@"Cancel" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width, pickerViewHeader.frame.size.height)
      font: cancelButton.titleLabel.font];
  cancelButton.frame = CGRectMake(padding, 0.0f,
    cancelButtonRect.size.width, pickerViewHeader.frame.size.height);
  [cancelButton addTarget: self
    action: @selector(cancelPicker)
      forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor blueDark]
    forState: UIControlStateNormal];
  [pickerViewHeader addSubview: cancelButton];
  // Done button
  UIButton *doneButton = [UIButton new];
  doneButton.titleLabel.font = cancelButton.titleLabel.font;
  CGRect doneButtonRect = [@"Save" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height)
        font: doneButton.titleLabel.font];
  doneButton.frame = CGRectMake(pickerViewHeader.frame.size.width -
    (padding + doneButtonRect.size.width), 0.0f,
      doneButtonRect.size.width, pickerViewHeader.frame.size.height);
  [doneButton addTarget: self
    action: @selector(donePicker)
      forControlEvents: UIControlEventTouchUpInside];
  [doneButton setTitle: @"Save" forState: UIControlStateNormal];
  [doneButton setTitleColor: [UIColor blueDark]
     forState: UIControlStateNormal];
  [pickerViewHeader addSubview: doneButton];
  
  datePicker = [[UIDatePicker alloc] init];
  datePicker.backgroundColor = UIColor.whiteColor;
  datePicker.frame = CGRectMake(0.0f, pickerViewHeader.frame.origin.y +
    pickerViewHeader.frame.size.height,
      datePicker.frame.size.width, datePicker.frame.size.height);
  datePicker.datePickerMode = UIDatePickerModeDate;
  datePicker.maximumDate = [NSDate date];
  /*[datePicker addTarget: self action: @selector(dateChanged)
       forControlEvents: UIControlEventValueChanged];*/
  [pickerViewContainer addSubview: datePicker];
  
  pickerViewContainer.frame =
    CGRectMake(0.0f, self.view.frame.size.height,
      self.view.frame.size.width,
        pickerViewHeader.frame.size.height +
          datePicker.frame.size.height);
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

- (void) cancelPicker
{
  [self updatePicker];
  [self hideDatePicker];
}


- (void) donePicker
{
  [self hideDatePicker];
  availableDate = [datePicker.date timeIntervalSince1970];
  [self updatePicker];
  [self hideBottomStatus];
}

- (void) hideBottomStatus
{
  CGRect rect = bottomStatus.frame;
  CGRect rect2 = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  rect2.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    bottomStatus.frame = rect;
    pickerViewContainer.frame = rect2;
  }];
}

- (void) hideDatePicker
{
  isShowingPicker = NO;
  [self resize];
  CGRect rect = pickerViewContainer.frame;
  CGRect rect2 = bottomStatus.frame;
  rect.origin.y = self.view.frame.size.height;
  rect2.origin.y = self.view.frame.size.height -
    bottomStatus.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    bottomStatus.frame = rect2;
    pickerViewContainer.frame = rect;
  }];
}

- (void) noLonger
{
  
}

- (void) resize
{
  CGFloat padding = 20.f;
  CGRect rect1 = rentedTextField.frame;
  CGRect rect2 = bottomStatus.frame;
  if(isShowingPicker){
    titlelabel.text = @"When will this place become available?";
    rentedTextField.hidden = NO;
    reasonTwoButton.hidden = YES;
    cancelStatusButton.hidden = YES;
    descriptionLabel.hidden = YES;
    rentedButton.hidden = YES;
    rect1.origin.y = titlelabel.frame.origin.y +
      titlelabel.frame.size.height + padding;
    rect2.size.height = rect1.origin.y +
      rect1.size.height + padding;
  }else{
    rentedTextField.hidden = YES;
    reasonTwoButton.hidden = NO;
    cancelStatusButton.hidden = NO;
    descriptionLabel.hidden = NO;
    rentedButton.hidden = NO;
    isShowingPicker = NO;
    titlelabel.text = @"Stop listing because...";
    rect1.origin.y = rentedButton.frame.origin.y +
      rentedButton.frame.size.height;
    rect2.size.height = cancelStatusButton.frame.origin.y +
    cancelStatusButton.frame.size.height + padding;
  }
  
  rentedTextField.frame = rect1;
  bottomStatus.frame = rect2;
}

- (void) showBottomStatus
{
  [self resize];
  CGRect rect = bottomStatus.frame;
  rect.origin.y = self.view.frame.size.height -
    rect.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    bottomStatus.frame = rect;
  }];
}

- (void) showDatePicker
{
  if(!isShowingPicker){
    isShowingPicker = YES;
    [self resize];
    CGRect rect = pickerViewContainer.frame;
    CGRect rect2 = bottomStatus.frame;
    rect2.origin.y = self.view.frame.size.height -
      (bottomStatus.frame.size.height + rect.size.height);
    rect.origin.y = self.view.frame.size.height - pickerViewContainer.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
      bottomStatus.frame = rect2;
      pickerViewContainer.frame = rect;
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

- (void) updatePicker
{
  if(availableDate){
    [datePicker setDate:[NSDate dateWithTimeIntervalSince1970: availableDate]
               animated: NO];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MMMM yyyy";
    rentedTextField.text = [dateFormat stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: availableDate]];
  }
}

@end
