//
//  PayInWebViewCell.h
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebDataManager.h"
@interface PayInWebViewCell : UITableViewCell<SDWebDataDownloaderDelegate,SDWebDataManagerDelegate>
{
    IBOutlet UIImageView* mgouImageView;
    IBOutlet UIImageView* mpaymethodImageView;
    IBOutlet UILabel* mpaymethodLabel;
    
    NSString * mUrl;
}
@property(nonatomic,retain)UIImageView* mpaymethodImageView;
@property(nonatomic,retain)UILabel* mpaymethodLabel;
@property(nonatomic,copy)NSString* mUrl;
-(void)loadimage;
@end
