//
//  OTSAudioPlayer.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation OTSAudioPlayer
@synthesize audioPlayer;

+(void)playSoundFileInBundle:(NSString*)aSoundFileName type:(NSString*)aSoundType
{
    [self playSoundFile:[[NSBundle mainBundle] pathForResource:aSoundFileName ofType:aSoundType]];
}

+(void)playSoundFile:(NSString*)aSoundFilePath
{
    AudioSessionInitialize(NULL, NULL, NULL, self);
    UInt32 category = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);  
    AudioSessionSetActive(YES);
    
    //NSString *path = [NSString stringWithFormat:@"%@/%@.wav",[[NSBundle mainBundle] resourcePath], sound];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:aSoundFilePath isDirectory:NO];
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
}

// NOTICE:method below is deprecated, for it can stop ipod music ---- dym
+(void)oldPlaySoundFile:(NSString*)aSoundFilePath
{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSData* fileData = [NSData dataWithContentsOfFile:aSoundFilePath];
        NSError* error = nil;
        
        [[self sharedInstance] setAudioPlayer:[[[AVAudioPlayer alloc] initWithData:fileData error:&error] autorelease]];
        [[self sharedInstance] audioPlayer].delegate = [self sharedInstance];
        
        if (error)
        {
            DebugLog(@"error:%@", error);
            return;
        }
        
        BOOL isPlayOK = NO;
        if ([[self sharedInstance] audioPlayer])
        {
            isPlayOK = [[[self sharedInstance] audioPlayer] prepareToPlay];
            if (isPlayOK)
            {
                isPlayOK = [[[self sharedInstance] audioPlayer] play];
            }
        }
        DebugLog(@"play audio OK:%d", isPlayOK);
    });
}

#pragma mark -
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    DebugLog(@"audio finished:%d", flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    DebugLog(@"decode error:%@", error);
}

#pragma mark - singleton methods
static OTSAudioPlayer *sharedInstance = nil;

+ (OTSAudioPlayer *)sharedInstance
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] init]; 
        } 
    } 
    
    return sharedInstance; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [super allocWithZone:zone]; 
            return sharedInstance; 
        } 
    } 
    
    return nil; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
    return self; 
} 

- (id)retain 
{ 
    return self; 
} 

- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax; 
} 

- (oneway void)release
{ 
} 

- (id)autorelease 
{ 
    return self; 
}
@end
