//
//  AudioRecorder.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-2.
//
//

#import <Foundation/Foundation.h>
#import "SCListener.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "EAFRead.h"
#import "EAFWrite.h"
typedef enum {
    kTypeOrigen=0,
    kTypeHappy=1,
    kTypeToilet=2,
    kTypeSpace=3,
}KTypeAudioProperty;
@protocol AudioRecorderDelegate;
@interface AudioRecorder : NSObject<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    SCListener *listener;
    
    NSTimer *timer;
    //表示监听还是录音状态
    BOOL listen;
    //监听类，录音机，播放器
    NSString *audioPath;
    
    AVAudioRecorder *arecoder;
    AVAudioPlayer *aplayer;
    
    int breakCount;
    KTypeAudioProperty aAudioProperty;
    BOOL timeActive;
    
    NSString*playUrlStr;
    //变音器
    EAFRead *reader;
	EAFWrite *writer;
    int percent;
    id<AudioRecorderDelegate>delegate;
    int origenDuration,happyDuration,toiletDuration,spaceDuration;
}
@property(assign)int origenDuration,happyDuration,toiletDuration,spaceDuration;
@property(assign)KTypeAudioProperty aAudioProperty;
@property(nonatomic,assign)id<AudioRecorderDelegate>delegate;
@property(retain)EAFRead *reader;
+(AudioRecorder*)sharedAudioRecorder;
-(void)stopPlayRecord;
-(void)playRecord;
-(void)listenerStart;
-(void)listenerStop;
-(void)clearRecordTemp;
-(void)changeAudioProperty:(KTypeAudioProperty)audioProperty;
-(int)getAudioDuration:(NSURL*)filePathURL;
@end
@protocol AudioRecorderDelegate <NSObject>
@optional
-(void)audioRecorderTooShort;
-(void)audioRecorderPlayFinished;
-(void)beginMix;
-(void)finishMix;
-(void)audioRecorderTimeOut;
-(void)audioRecorder:(AudioRecorder*)recorder SLpower:(Float32)power;
-(void)audioRecorder:(AudioRecorder *)recorder duration:(int)duration;
@end