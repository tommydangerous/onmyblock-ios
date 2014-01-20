//
//  OMBFilmstripImageCell.m
//  OnMyBlock
//
//  Created by Peter Meyers on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFilmstripImageCell.h"

@implementation OMBFilmstripImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_image = [[UIImageView alloc] initWithFrame:self.bounds];
//		_image.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[self addSubview:_image];
    }
    return self;
}

+ (NSString *)reuseID
{
	return NSStringFromClass([self class]);
}

@end
