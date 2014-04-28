//
//  OTSImageView.h
//  TheStoreApp
//
//  Created by yuan jun on 12-12-20.
//
//

#import <UIKit/UIKit.h>
#import "SDWebDataManager.h"
@interface OTSImageView : UIImageView<SDWebDataManagerDelegate>
{
    NSString* imageUrl;
    UIButton* downBtn;
}
@property(nonatomic,retain) NSString* imageUrl;
@property(nonatomic,assign) UIButton* downBtn;
-(void)loadImgUrl:(NSString*)imgUrlStr;
@end
