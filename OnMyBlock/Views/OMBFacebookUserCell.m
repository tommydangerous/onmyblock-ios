//
//  OMBFacebookUserCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFacebookUserCell.h"

#import "OMBCenteredImageView.h"
#import "OMBViewController.h"
#import "UIFont+OnMyBlock.h"
#import "UIColor+Extensions.h"
#import "UIImageView+WebCache.h"

@implementation OMBFacebookUserCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *) reuseIdentifier
{
    if (!(self = [super initWithStyle: style
      reuseIdentifier: reuseIdentifier])) return nil;
    
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float screenWidth = screen.size.width;
    float padding = OMBPadding;
    CGFloat imageSize = [OMBFacebookUserCell heightForCell] * .8f;
    
    self.contentView.frame = CGRectMake(0, 0,
      screenWidth, [OMBFacebookUserCell heightForCell]);
    
    // User image
    userImageView = [[OMBCenteredImageView alloc] init];
    userImageView.frame = CGRectMake(padding,
      [OMBFacebookUserCell heightForCell] * .1f,
        imageSize, imageSize);
    userImageView.layer.cornerRadius = userImageView.frame.size.width * 0.5f;
    [self.contentView addSubview: userImageView];
    
    // Full name
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont normalTextFont];
    nameLabel.frame = CGRectMake(userImageView.frame.origin.x +
      userImageView.frame.size.width + padding,
        padding, screenWidth - (padding + imageSize + padding + padding), 22);
    nameLabel.textColor = [UIColor textColor];
    [self.contentView addSubview: nameLabel];
    
    return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat)heightForCell
{
    CGFloat padding = OMBPadding;
    return padding + 22.f + padding;
}

#pragma mark - Instance Methods

- (void) loadFacebooUserData: (NSDictionary *) object{
    
    // Image
    if ([object objectForKey: @"id"]) {
        NSUInteger idFbUser = [[object objectForKey: @"id"] intValue];
        NSURL *imageURL = [NSURL URLWithString: [NSString stringWithFormat:
          @"http://graph.facebook.com/%i/picture?type=large",
            idFbUser]];
        __weak typeof(userImageView) weakImageView = userImageView;
        [userImageView.imageView sd_setImageWithURL: imageURL
          placeholderImage: [OMBUser placeholderImage] options:
            SDWebImageRetryFailed
              completed:
               ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 if(image)
                   weakImageView.image = image;
                 NSLog(@"%@ %@", imageURL, image);
         }];
    }
    else {
        [userImageView setImage: [OMBUser placeholderImage]];
    }
    
    // Name and Last Name
    nameLabel.text = [NSString stringWithFormat: @"%@ %@",
      [object objectForKey: @"first_name"],
        [object objectForKey: @"last_name"]];
    
}

@end
