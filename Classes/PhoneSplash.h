//
//  PhoneSplash.h
//  TheStoreApp
//
//  Created by yuan jun on 13-4-16.
//
//

#import <Foundation/Foundation.h>
#import "SDWebDataManager.h"

@interface PhoneSplash : NSObject<SDWebDataManagerDelegate>
{
    UIImageView *launchIv;
}
@property(nonatomic, retain) UIImageView *launchIv;
+ (PhoneSplash *)sharedInstance;
/**
 *  功能:显示渐变画面
 */
- (void)showSplash;
- (void)recoverSplash;
-(void)delayRemove:(NSNumber*)delayTime;

@end
