//
//  ProductCellImageView.m
//  yhd
//
//  Created by dev dev on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductCellImageView.h"

@implementation ProductCellImageView
@synthesize mURL;
@synthesize mCount;
@synthesize mPrice;
@synthesize mImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    SDWebDataManager * tempdownloader = [SDWebDataManager sharedManager];
//    [tempdownloader downloadWithURL:mURL delegate:self];
//    
//    mPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[mPrice doubleValue]];
//    mCountLabel.text = [NSString stringWithFormat:@"%i",[mCount intValue]];
//}
-(void)refreshImage
{
    mImageView.image = nil;
    [mImageIndicator startAnimating];
    mImageIndicator.hidden = NO;
    SDWebDataManager * tempdownloader = [SDWebDataManager sharedManager];
    [tempdownloader downloadWithURL:mURL delegate:self];
    
    mPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[mPrice doubleValue]];
    mCountLabel.text = [NSString stringWithFormat:@"%i",[mCount intValue]];
}
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    mImageView.image = [UIImage imageWithData:aData]; 
    mImageView.frame = CGRectMake(24, 15, 60, 60);
    [mImageIndicator stopAnimating];
    mImageIndicator.hidden = YES;
}
-(void)dealloc
{
    [mURL release];
    [mCount release];
    [mPrice release];
    [super dealloc];
}
@end
