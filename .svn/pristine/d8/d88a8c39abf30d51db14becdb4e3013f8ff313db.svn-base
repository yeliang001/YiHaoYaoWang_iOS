//
//  SDButton+SDWebCache.m
//  Complaint51
//
//  Created by mxy on 12-2-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SDButton+SDWebCache.h"


@implementation UIButton(SDWebCacheCategory)
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
    SDWebDataManager *manager = [SDWebDataManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
    [self setImage:placeholder forState:UIControlStateNormal];
    if (url)
    {
        [manager downloadWithURL:url delegate:self refreshCache:refreshCache];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebDataManager sharedManager] cancelForDelegate:self];
}

#pragma mark -
#pragma mark SDWebDataManagerDelegate

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
	UIImage *img=[UIImage imageWithData:aData];
    [self setImage:img forState:UIControlStateNormal];
}


@end
