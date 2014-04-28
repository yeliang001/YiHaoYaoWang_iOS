//
//  UIImageView+SDWebCache.m
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDImageView+SDWebCache.h"
#define kSDImageViewActivityViewTag 100
@implementation UIImageView(SDWebCacheCategory)

- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url refreshCache:NO];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache
{
	[self setImageWithURL:url refreshCache:refreshCache placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
    SDWebDataManager *manager = [SDWebDataManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
    self.image = placeholder;
	
    if (url)
    {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake((self.frame.size.width-25)/2,(self.frame.size.height-25)/2, 25.0f, 25.0f);
        //activityView.center=productTableView.center;
        activityView.tag=kSDImageViewActivityViewTag;
        [self  insertSubview:activityView atIndex:1];
        //[self  bringSubviewToFront:activityView];
        [activityView startAnimating];
        [activityView release];
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
    UIActivityIndicatorView *activityView=(UIActivityIndicatorView*)[self viewWithTag:kSDImageViewActivityViewTag];
    if (activityView) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
	UIImage *img=[UIImage imageWithData:aData];
    self.image=img;
}

- (void)webDataManager:(SDWebDataManager *)dataManager didFailWithError:(NSError *)error{
    UIActivityIndicatorView *activityView=(UIActivityIndicatorView*)[self viewWithTag:kSDImageViewActivityViewTag];
    if (activityView) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
}


@end
