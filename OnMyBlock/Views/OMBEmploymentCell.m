//
//  OMBEmploymentCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEmploymentCell.h"

#import "OMBEmployment.h"
#import "OMBEmploymentListViewController.h"
#import "OMBMyRenterApplicationViewController.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBEmploymentCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style 
    reuseIdentifier: reuseIdentifier])) return nil;

  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  float padding = OMBPadding;

  float originX = padding;
  float height  = 22.0f;
  float width   = screenWidth - (originX * 2);

  companyNameLabel = [[UILabel alloc] init];
  companyNameLabel.font = [UIFont normalTextFontBold];
  companyNameLabel.frame = CGRectMake(originX, padding, width, height);
  companyNameLabel.textColor = [UIColor textColor];
  [self.contentView addSubview: companyNameLabel];

  _companyWebsiteButton = [[UIButton alloc] init];
  _companyWebsiteButton.frame = companyNameLabel.frame;
  _companyWebsiteButton.titleLabel.font = [UIFont fontWithName: 
    @"HelveticaNeue-Light" size: 13];
  [_companyWebsiteButton addTarget: self action: @selector(showCompanyWebsite)
    forControlEvents: UIControlEventTouchUpInside];
  [_companyWebsiteButton setTitleColor: [UIColor blue]
    forState: UIControlStateNormal];
  [_companyWebsiteButton setTitleColor: [UIColor blueDark]
    forState: UIControlStateHighlighted];
  [self.contentView addSubview: _companyWebsiteButton];

  titleIncomeLabel = [[UILabel alloc] init];
  titleIncomeLabel.font = [UIFont normalTextFont];
  titleIncomeLabel.frame = CGRectMake(originX, 
    companyNameLabel.frame.origin.y + companyNameLabel.frame.size.height,
      width, height);
  titleIncomeLabel.textColor = [UIColor blueDark];
  [self.contentView addSubview: titleIncomeLabel];

  startDateEndDateLabel = [[UILabel alloc] init];
  startDateEndDateLabel.font = [UIFont smallTextFont];
  startDateEndDateLabel.frame = CGRectMake(originX,
    titleIncomeLabel.frame.origin.y + titleIncomeLabel.frame.size.height,
      width, height);
  startDateEndDateLabel.textColor = [UIColor grayMedium];
  [self.contentView addSubview: startDateEndDateLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  return OMBPadding + (22.0f * 3) + OMBPadding;
}

#pragma mark - Instance Methods

- (void) loadData: (OMBEmployment *) object
{
  _employment = object;

  // CGRect screen     = [[UIScreen mainScreen] bounds];
  // float screenWidth = screen.size.width;
  // float padding     = 20.0f;
  // float originX     = padding;
  // float width       = screenWidth - (originX * 2);

  // Company name
  // companyNameLabel.text = [_employment.companyName capitalizedString];
  companyNameLabel.text = _employment.title;
  // companyNameLabel.text = _employment.companyName;
  
  // CGRect companyNameRect = [companyNameLabel.text boundingRectWithSize:
  //   CGSizeMake(width, companyNameLabel.frame.size.height)
  //     options: NSStringDrawingUsesLineFragmentOrigin
  //       attributes: @{ NSFontAttributeName: companyNameLabel.font }
  //         context: nil];
  // companyNameLabel.frame = CGRectMake(companyNameLabel.frame.origin.x,
  //   companyNameLabel.frame.origin.y, companyNameRect.size.width,
  //     companyNameLabel.frame.size.height);

  // Website
  // if ([_employment.companyWebsite length] > 0) {
  //   [_companyWebsiteButton setTitle: [_employment shortCompanyWebsiteString] 
  //     forState: UIControlStateNormal];
  //   CGRect companyWebsiteRect = 
  //     [[_employment shortCompanyWebsiteString] boundingRectWithSize:
  //       CGSizeMake(width, _companyWebsiteButton.frame.size.height)
  //         options: NSStringDrawingUsesLineFragmentOrigin
  //           attributes: 
  //           @{ NSFontAttributeName: _companyWebsiteButton.titleLabel.font }
  //             context: nil];
  //   _companyWebsiteButton.frame = CGRectMake(
  //     companyNameLabel.frame.origin.x + companyNameLabel.frame.size.width + 
  //     (padding * 0.5), 
  //       _companyWebsiteButton.frame.origin.y, companyWebsiteRect.size.width, 
  //         _companyWebsiteButton.frame.size.height);
  // }
  // else {
  //   [_companyWebsiteButton setTitle: @"" forState: UIControlStateNormal];
  // }

  // Title, income
  // Move the date labels back down
  // startDateEndDateLabel.frame = CGRectMake(
  //   startDateEndDateLabel.frame.origin.x, 
  //     titleIncomeLabel.frame.origin.y + titleIncomeLabel.frame.size.height, 
  //       startDateEndDateLabel.frame.size.width, 
  //         startDateEndDateLabel.frame.size.height);
  // NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  // [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
  // if ([_employment.title length] > 0 && _employment.income) {
  //   NSString *string = [numberFormatter stringFromNumber: 
  //     [NSNumber numberWithFloat: _employment.income]];
  //   string = [[string componentsSeparatedByString: @"."] objectAtIndex: 0];
  //   titleIncomeLabel.text = [NSString stringWithFormat: @"%@ - %@ / mo",
  //     _employment.title, string];
  // }
  // else if ([_employment.title length] > 0) {
  //   titleIncomeLabel.text = _employment.title;
  // }
  // else if (_employment.income) {
  //   NSString *string = [numberFormatter stringFromNumber: 
  //     [NSNumber numberWithFloat: _employment.income]];
  //   titleIncomeLabel.text = string;
  // }
  // else {
  //   titleIncomeLabel.text = @"";
  //   // If there is nothing in the title income label, move the date label up
  //   startDateEndDateLabel.frame = CGRectMake(
  //     startDateEndDateLabel.frame.origin.x, titleIncomeLabel.frame.origin.y, 
  //       startDateEndDateLabel.frame.size.width, 
  //         startDateEndDateLabel.frame.size.height);
  // }
  titleIncomeLabel.text = _employment.companyName;
  // titleIncomeLabel.text = _employment.title;

  // Start date
  if (_employment.startDate) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM yyyy";
    startDateEndDateLabel.text = [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: _employment.startDate]];
    NSString *endDateString = @"Present";
    if (_employment.endDate) {
      endDateString = [dateFormatter stringFromDate: 
        [NSDate dateWithTimeIntervalSince1970: _employment.endDate]];
      endDateString = [NSString stringWithFormat: @"%@ (%@)",
        endDateString, [_employment numberOfMonthsEmployedString]];
    }
    startDateEndDateLabel.text = [NSString stringWithFormat: @"%@ - %@",
      startDateEndDateLabel.text, endDateString];
  }
  else {
    startDateEndDateLabel.text = @"";
  }
}

- (void) loadFakeData
{
  OMBEmployment *e = [[OMBEmployment alloc] init];
  e.companyName = @"OnMyBlock";
  e.companyWebsite = @"www.onmyblock.com";
  e.endDate = [[NSDate date] timeIntervalSince1970];
  e.income = 2000.0;
  e.startDate = [[NSDate date] timeIntervalSince1970];
  e.title = @"Campus Founder";
  e.uid = 9999;
  [self loadData: e];
}

- (void) showCompanyWebsite
{
  if (_employment) {
    id vc = nil;
    if ([_delegate isKindOfClass: [OMBEmploymentListViewController class]]) {
      vc = (OMBEmploymentListViewController *) _delegate;
    }
    else if ([_delegate isKindOfClass: 
      [OMBMyRenterApplicationViewController class]]) {
      
      vc = (OMBMyRenterApplicationViewController *) _delegate;
    }
    if (vc)
      [vc showCompanyWebsiteWebViewForEmployment: _employment];
  }
}

@end
