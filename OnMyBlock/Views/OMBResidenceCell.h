//
//  OMBResidenceCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBConnection;
@class OMBResidence;
@class OMBResidencePartialView;

@interface OMBResidenceCell : UITableViewCell

@property (nonatomic, weak) OMBConnection *connection;
@property (nonatomic, weak) OMBResidence *residence;
@property (nonatomic, strong) OMBResidencePartialView *residencePartialView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelResidenceCoverPhotoDownload;
- (void) downloadResidenceImages;
- (void) loadResidenceData: (OMBResidence *) object;

@end
