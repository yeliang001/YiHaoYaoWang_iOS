//
//  OTSAudioPlayer.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface OTSAudioPlayer : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer* audioPlayer;
}
@property(retain)AVAudioPlayer* audioPlayer;
+ (OTSAudioPlayer *)sharedInstance;
+(void)playSoundFile:(NSString*)aSoundFilePath;
+(void)playSoundFileInBundle:(NSString*)aSoundFileName type:(NSString*)aSoundType;
@end
