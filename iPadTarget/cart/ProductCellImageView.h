//
//  ProductCellImageView.h
//  yhd
//
//  Created by dev dev on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebDataManager.h"
@interface ProductCellImageView : UIView<SDWebDataDownloaderDelegate,SDWebDataManagerDelegate>
{
    IBOutlet UIImageView * mImageView;
    IBOutlet UILabel * mPriceLabel;
    IBOutlet UILabel * mCountLabel;
    IBOutlet UIActivityIndicatorView * mImageIndicator;
    NSURL * mURL;
    NSNumber * mPrice;
    NSNumber * mCount;
}
@property(nonatomic,retain)NSURL * mURL;
@property(nonatomic,retain)NSNumber * mPrice;
@property(nonatomic,retain)NSNumber * mCount;
@property(nonatomic,retain)UIImageView * mImageView;
-(void)refreshImage;
@end
