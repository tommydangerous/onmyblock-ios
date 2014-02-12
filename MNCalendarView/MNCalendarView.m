//
//  MNCalendarView.m
//  MNCalendarView
//
//  Created by Min Kim on 7/23/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarView.h"
#import "MNCalendarViewLayout.h"
#import "MNCalendarViewDayCell.h"
#import "MNCalendarViewWeekdayCell.h"
#import "MNFastDateEnumeration.h"
#import "NSDate+MNAdditions.h"
#import "UIColor+Extensions.h"

@interface MNCalendarView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong,readwrite) UICollectionView *collectionView;
@property(nonatomic,strong,readwrite) UICollectionViewFlowLayout *layout;

@property(nonatomic,strong,readwrite) NSArray *monthDates;
@property(nonatomic,strong,readwrite) NSArray *weekdaySymbols;
@property(nonatomic,assign,readwrite) NSUInteger daysInWeek;

@property(nonatomic,strong,readwrite) NSDateFormatter *monthFormatter;

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date;
- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date;

- (BOOL)dateEnabled:(NSDate *)date;
- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)applyConstraints;

@end

@implementation MNCalendarView

- (void)commonInit {
  self.calendar   = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  self.fromDate   = [NSDate.date mn_beginningOfDay:self.calendar];
  // last day of next year
  NSDateComponents *comps = [self.calendar components:NSYearCalendarUnit fromDate:self.fromDate];
  [comps setDay   :31];
  [comps setMonth :12];
  [comps setYear  :[comps year] +1];
  self.toDate     = [self.calendar dateFromComponents:comps];
  self.daysInWeek = 7;
  
  self.weekdayCellClass = MNCalendarViewWeekdayCell.class;
  self.dayCellClass     = MNCalendarViewDayCell.class;
  
  _separatorColor = [UIColor colorWithRed:.85f green:.85f blue:.85f alpha:1.f];
  
  [self addSubview:self.collectionView];
  [self applyConstraints];
  [self reloadData];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.selectedFirst = nil;
    self.selectedSecond = nil;
    [self commonInit];
  }
  return self;
}

- (UICollectionView *)collectionView {
  if (nil == _collectionView) {
    MNCalendarViewLayout *layout = [[MNCalendarViewLayout alloc] init];
    
    _collectionView =
    [[UICollectionView alloc] initWithFrame:CGRectZero
                       collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor grayUltraLight];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self registerUICollectionViewClasses];
  }
  return _collectionView;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
  _separatorColor = separatorColor;
}

- (void)setCalendar:(NSCalendar *)calendar {
  _calendar = calendar;
}

- (void)reloadData {
  NSMutableArray *monthDates = @[].mutableCopy;
  MNFastDateEnumeration *enumeration =
  [[MNFastDateEnumeration alloc] initWithFromDate:[self.fromDate mn_firstDateOfMonth:self.calendar]
                                           toDate:[self.toDate mn_firstDateOfMonth:self.calendar]
                                         calendar:self.calendar
                                             unit:NSMonthCalendarUnit];
  for (NSDate *date in enumeration) {
    [monthDates addObject:date];
  }
  self.monthDates = monthDates;
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.calendar = self.calendar;
  
  self.weekdaySymbols = formatter.shortWeekdaySymbols;
  
  [self.collectionView reloadData];
}

- (void)registerUICollectionViewClasses {
  [_collectionView registerClass:self.dayCellClass
      forCellWithReuseIdentifier:MNCalendarViewDayCellIdentifier];
  
  [_collectionView registerClass:self.weekdayCellClass
      forCellWithReuseIdentifier:MNCalendarViewWeekdayCellIdentifier];
  
}

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date {
  date = [date mn_firstDateOfMonth:self.calendar];
  
  NSDateComponents *components =
  [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                   fromDate:date];
  // -1 , -4
  return
  [[date mn_dateWithDay:-((components.weekday - 1) % self.daysInWeek) calendar:self.calendar] dateByAddingTimeInterval:MN_DAY];
}

- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date {
  date = [date mn_lastDateOfMonth:self.calendar];
  
  NSDateComponents *components =
  [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                   fromDate:date];
  // 31 , 34
  return
  [date mn_dateWithDay:components.day + (self.daysInWeek - 1) - ((components.weekday - 1) % self.daysInWeek)
              calendar:self.calendar];
}

- (void)applyConstraints {
  NSDictionary *views = @{@"collectionView" : self.collectionView};
  [self addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                           options:0
                                           metrics:nil
                                             views:views]];
  
  [self addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                           options:0
                                           metrics:nil
                                             views:views]
   ];
}

- (BOOL)dateEnabled:(NSDate *)date {
  if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
    return [self.delegate calendarView:self shouldSelectDate:date];
  }
  return YES;
}

- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"2");
  MNCalendarViewCell *cell = (MNCalendarViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
  
  BOOL enabled = cell.enabled;
  
  if ([cell isKindOfClass:MNCalendarViewDayCell.class] && enabled) {
    MNCalendarViewDayCell *dayCell = (MNCalendarViewDayCell *)cell;
    enabled = [self dateEnabled:dayCell.date];
  }
  return enabled;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  // months: 2 year = 24 months
  return self.monthDates.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSDate *monthDate = self.monthDates[section];
  
  NSDateComponents *components =
  [self.calendar components:NSDayCalendarUnit
                   fromDate:[self firstVisibleDateOfMonth:monthDate]
                     toDate:[self lastVisibleDateOfMonth:monthDate]
                    options:0];
  
  return self.daysInWeek + components.day + 1;
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.item < self.daysInWeek) {
    // Sun, Mon, Tue, Wed cells
    MNCalendarViewWeekdayCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
     MNCalendarViewWeekdayCellIdentifier forIndexPath: indexPath];
    cell.backgroundColor = self.collectionView.backgroundColor;
    cell.titleLabel.text = self.weekdaySymbols[indexPath.item];
    cell.separatorColor  = self.separatorColor;
    
    return cell;
  }
  
  // 1, 2, 3, 4, 5, 6... days
  MNCalendarViewDayCell *cell =
  [collectionView dequeueReusableCellWithReuseIdentifier:
   MNCalendarViewDayCellIdentifier forIndexPath: indexPath];
  cell.separatorColor = self.separatorColor;
  
  NSDate *monthDate = self.monthDates[indexPath.section];
  NSDate *firstDateInMonth = [self firstVisibleDateOfMonth: monthDate];
  NSUInteger day = indexPath.item - self.daysInWeek;
  
  NSDateComponents *components =
  [self.calendar components:
   (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                   fromDate: firstDateInMonth];
  components.day += day;
  
  NSDate *date = [self.calendar dateFromComponents: components];
  
  // This sets the title label text
  [cell setDate: date month: monthDate calendar: self.calendar];
  
  // This sets the color of the text
  if (cell.enabled) {
    [cell setEnabled: [self dateEnabled: date]];
  }

  // UIColor *blue = [UIColor colorWithRed: 111/255.0f green: 174/255.0f
  //   blue: 193/255.0f alpha: 1.0f];
  UIColor *blue = [UIColor colorWithRed: (41/255.0) green: (184/255.0) 
    blue: (229/255.0) alpha: 1.0f];

  NSDateComponents *components2 = [self.calendar components:
    NSMonthCalendarUnit fromDate: date];
  NSDateComponents *monthComponents =
    [self.calendar components: NSMonthCalendarUnit fromDate: monthDate];
  BOOL isInSameMonthCell = components2.month == monthComponents.month;
  
  // if (_selectedDate && [date compare: _selectedDate] == NSOrderedSame) {
  if ((_moveInDate && [date compare: _moveInDate] == NSOrderedSame)
    || (_moveOutDate && [date compare: _moveOutDate] == NSOrderedSame)) {
    
    // If the date cell is within the same month section
    if (isInSameMonthCell) {
      if (_moveInDate && [date compare: _moveInDate] == NSOrderedSame) {
        cell.titleLabel.textColor = [UIColor colorWithRed: (193/255.0) 
          green: (25/255.0) blue: (120/255.0) alpha: 1];
      }
      else {
        cell.titleLabel.textColor = [UIColor whiteColor];
      }
      cell.backgroundColor = blue;
    }
  }
  else if ((_moveInDate && [date compare: _moveInDate] == NSOrderedDescending)
    && (_moveOutDate && [date compare: _moveOutDate] == NSOrderedAscending)
    && isInSameMonthCell) {

    cell.backgroundColor = blue;
    cell.titleLabel.textColor = [UIColor whiteColor];
  }
  
  // if (self.selectedSecond && cell.enabled) {
  //   NSIndexPath *selection = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
  //   [self.collectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
  // }
  
  // if (_selectedDate && [date compare: _selectedDate] == NSOrderedSame) {
  //   NSLog(@"%@", _selectedDate);
  //   NSIndexPath *selection = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
  //   [self.collectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
  // }
  
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL) collectionView: (UICollectionView *) collectionView
shouldHighlightItemAtIndexPath: (NSIndexPath *) indexPath
{
  return YES;
  // if(self.selectedSecond){
  //   self.collectionView.allowsSelection = NO;
  //   return NO;
  // }
  // return [self canSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if(self.selectedSecond){
    self.collectionView.allowsSelection = NO;
    return NO;
  }
  return [self canSelectItemAtIndexPath:indexPath];
}

- (void) collectionView: (UICollectionView *) collectionView
didSelectItemAtIndexPath: (NSIndexPath *) indexPath
{
  NSLog(@"DID SELECT");
  
  MNCalendarViewCell *cell = (MNCalendarViewCell *)
  [self collectionView: collectionView cellForItemAtIndexPath: indexPath];
  
  NSLog(@"%@", cell.selected ? @"SELECTED" : @"NOT SELECTED");
  
  if ([cell isKindOfClass: [MNCalendarViewCell class]] && cell.enabled) {
    MNCalendarViewDayCell *dayCell = (MNCalendarViewDayCell *) cell;
    
    if (self.delegate && [self.delegate respondsToSelector:
                          @selector(calendarView:didSelectDate:)]) {
      
      [self.delegate calendarView: self didSelectDate: dayCell.date];
    }
    
    [self.collectionView reloadData];
  }
  
  
  // if ([cell isKindOfClass:MNCalendarViewDayCell.class] && cell.enabled) {
  //   MNCalendarViewDayCell *dayCell = (MNCalendarViewDayCell *)cell;
  
  //   if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
  //     [self.delegate calendarView:self didSelectDate:dayCell.date];
  //   }
  
  //   // [cell setSelected:YES];
  //   [self.collectionView reloadData];
  
  //   NSIndexPath *selection = [NSIndexPath indexPathForItem: indexPath.row
  //     inSection: indexPath.section];
  //   [self.collectionView selectItemAtIndexPath: selection animated: YES
  //     scrollPosition: UICollectionViewScrollPositionNone];
  // }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat width      = self.bounds.size.width;
  CGFloat itemWidth  = roundf(width / self.daysInWeek);
  CGFloat itemHeight = indexPath.item < self.daysInWeek ? 20.0f : itemWidth; // 30.f
  
  // 0..6
  NSUInteger weekday = indexPath.item % self.daysInWeek;
  // indexPath / 7 = number of weeks
  
  if (weekday == self.daysInWeek - 1) {
    itemWidth = width - (itemWidth * (self.daysInWeek - 1));
  }
  
  return CGSizeMake(itemWidth, itemHeight);
}

@end