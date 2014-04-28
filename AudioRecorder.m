//
//  AudioRecorder.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-2.
//
//

#import "AudioRecorder.h"
#include "Dirac.h"
#include <stdio.h>
#include <sys/time.h>
#import "EAFRead.h"
#import "EAFWrite.h"
#import "OTSUtility.h"
//#import "lame.h"
float stime = 1;
float pitch = 1;
float formant = 1;

double gExecTimeTotal = 0.;
static AudioRecorder*audioRecorder=nil;
@interface AudioRecorder ()
@property (retain) NSMutableArray   *audioMixParams;
@end
@implementation AudioRecorder
@synthesize reader;
@synthesize aAudioProperty;
@synthesize delegate;
@synthesize audioMixParams = _audioMixParams;
@synthesize  origenDuration,happyDuration,toiletDuration,spaceDuration;
- (void)dealloc
{
    [_audioMixParams release];
    
    [super dealloc];
}

//#cpp function  C++方法
void DeallocateAudioBuffer(float **audio, int numChannels)
{
	if (!audio) return;
	for (long v = 0; v < numChannels; v++) {
		if (audio[v]) {
			free(audio[v]);
			audio[v] = NULL;
		}
	}
	free(audio);
	audio = NULL;
}

float **AllocateAudioBuffer(int numChannels, int numFrames)
{
	//给输出缓存分配空间
	float **audio = (float**)malloc(numChannels*sizeof(float*));
	if (!audio) return NULL;
	memset(audio, 0, numChannels*sizeof(float*));
	for (long v = 0; v < numChannels; v++) {
		audio[v] = (float*)malloc(numFrames*sizeof(float));
		if (!audio[v]) {
			DeallocateAudioBuffer(audio, numChannels);
			return NULL;
		}
		else memset(audio[v], 0, numFrames*sizeof(float));
	}
	return audio;
}

long myReadData(float **chdata, long numFrames, void *userData)
{
	if (!chdata)
        return 0;
	
    AudioRecorder *Self = (AudioRecorder*)userData;
    if (!Self)	return 0;
    
	gExecTimeTotal += DiracClockTimeSeconds();
    
	OSStatus err = [Self.reader readFloatsConsecutive:numFrames intoArray:chdata];
    
	DiracStartClock();
    
	return err;
	
}
//int pcmToMp3(NSString*src,NSString* dest){
//    int read, write;
//    const char*filePath=[src UTF8String];
//    const char*outPath=[dest UTF8String];
//    FILE *pcm = fopen(filePath, "rb");
//    FILE *mp3 = fopen(outPath, "wb");
//    
//    const int PCM_SIZE = 8192;
//    const int MP3_SIZE = 8192;
//    
//    short int pcm_buffer[PCM_SIZE*2];
//    unsigned char mp3_buffer[MP3_SIZE];
//    
//    lame_t lame = lame_init();
//    lame_set_in_samplerate(lame, 44100);
//    lame_set_VBR(lame, vbr_default);
//    lame_set_num_channels(lame, 1);
//    lame_init_params(lame);
//    do {
//        read = fread(pcm_buffer,2*sizeof(short int), PCM_SIZE, pcm);
//        if (read == 0)
//            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//        else
//            write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//        fwrite(mp3_buffer, write, 1, mp3);
//    } while (read != 0);
//    
//    lame_close(lame);
//    fclose(mp3);
//    fclose(pcm);
//    
//    return 0;
//}
#pragma mark --
+(AudioRecorder*)sharedAudioRecorder{
    @synchronized(self) {
		if (audioRecorder == nil)
			audioRecorder=[[self alloc] init];
	}
    return audioRecorder;
}
-(id)init{
    self=[super init];
    if (self) {
        //设置路径
        audioPath = [OTS_DOC_PATH stringByAppendingPathComponent:@"audio.wav"];
        [audioPath retain];        
        listen = YES;
        //定时执行音量检测
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CheckVolume) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}



#pragma mark 录音接口
-(void)clearRecordTemp{
    NSString*origen=[OTS_DOC_PATH stringByAppendingPathComponent:@"audio.aif"];
    NSString*happy=[OTS_DOC_PATH stringByAppendingPathComponent:@"happy.aif"];
    NSString*toilet=[OTS_DOC_PATH stringByAppendingPathComponent:@"toilet.aif"];
    NSString*space=[OTS_DOC_PATH stringByAppendingPathComponent:@"space.aif"];
    
    [_audioMixParams removeAllObjects];
    if ([[NSFileManager defaultManager] fileExistsAtPath:origen]) {
        [[NSFileManager defaultManager] removeItemAtPath:origen error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:happy]) {
         [[NSFileManager defaultManager] removeItemAtPath:happy error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:toilet]) {
        [[NSFileManager defaultManager] removeItemAtPath:toilet error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:space]) {
        [[NSFileManager defaultManager] removeItemAtPath:space error:nil];
    }

}

-(void)listenerStart{
    //让timer定时方法继续检测
    timeActive = YES;
    //开始监听
    if (arecoder==nil) {
        //设置录音属性
        NSMutableDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                               [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                                               [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                               [NSNumber numberWithInt: AVAudioQualityMin],         AVEncoderAudioQualityKey,
                                               nil];
        
        //初始化录音器的相关属性
        arecoder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:audioPath] settings:recordSettings error:nil];
        [arecoder setMeteringEnabled:YES];
        [arecoder recordForDuration:10];
        [arecoder setDelegate:self];
        [arecoder prepareToRecord];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    [arecoder prepareToRecord];
    [arecoder record];
    [[SCListener sharedListener] listen];
    DebugLog(@"开始监听");
    breakCount=0;

}

-(void)listenerStop{
    timeActive=NO;
    [[SCListener sharedListener] stop];
    [arecoder stop];
}

-(void)stopPlayRecord{
    [aplayer stop];
    [aplayer release];
    aplayer=nil;
}
-(void)playRecord{
    NSURL*tempUrl;
    DebugLog(@"%@",playUrlStr);
    tempUrl=[NSURL fileURLWithPath:playUrlStr];
    NSData* data=[NSData dataWithContentsOfURL:tempUrl];
    if (data!=nil) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (aplayer==nil) {
            aplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tempUrl error:nil];
            [aplayer setNumberOfLoops:0];
            [aplayer setDelegate:self];
        }
        [aplayer prepareToPlay];
        [aplayer play];
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [delegate audioRecorderPlayFinished];
    [aplayer stop];
    [aplayer release];
    aplayer=nil;
    DebugLog(@"fihish playing, start listen");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (breakCount>=100) {
        [delegate audioRecorderTimeOut];
    }else if(breakCount<10){
        [delegate audioRecorderTooShort];
    }
    NSData *data = [NSData dataWithContentsOfURL:arecoder.url];
    [data writeToFile:audioPath atomically:YES];
    
    timeActive = NO;
    [arecoder release];
    arecoder=nil;
    if (breakCount<10) {
        
    }else{
        [delegate beginMix];
        [NSThread detachNewThreadSelector:@selector(mixAllTypeMusic) toTarget:self withObject:nil];
    }
}

#pragma mark --change
-(int)getAudioDuration:(NSURL*)filePathURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:filePathURL options:nil];
    CMTime time = asset.duration;
    int durationInSeconds = (int)(time.value/time.timescale);
    [asset release];
    asset=nil;
    return (durationInSeconds);
}

-(void)changeAudioProperty:(KTypeAudioProperty)audioProperty{
    aAudioProperty=audioProperty;
    switch (audioProperty) {
        case kTypeOrigen:{
            playUrlStr=[[OTS_DOC_PATH stringByAppendingPathComponent:@"audio.aif"] retain];
        }
            break;
        case kTypeHappy:{
            playUrlStr=[[OTS_DOC_PATH stringByAppendingPathComponent:@"happy.aif"] retain];
        }
            break;
        case kTypeToilet:
        {
            playUrlStr=[[OTS_DOC_PATH stringByAppendingPathComponent:@"toilet.aif"] retain];
        }
            break;
        case kTypeSpace:
        {
            playUrlStr=[[OTS_DOC_PATH stringByAppendingPathComponent:@"space.aif"] retain];
            
        }
            break;
        default:
            break;
    }
    DebugLog(@"%@",playUrlStr);
}

#pragma mark mixer
-(void)mixAllTypeMusic{
    @autoreleasepool {
        [self mixOrigen];
        [self mixHappy];
        [self mixToilet];
        [self mixSpace];
        [delegate finishMix];
    }
}
-(void)cucalDuration{
    happyDuration=[self getAudioDuration:[NSURL fileURLWithPath:[OTS_DOC_PATH stringByAppendingPathComponent:@"happy.aif"]]];
    DebugLog(@"happyDuration=====%d",happyDuration);
    toiletDuration=[self getAudioDuration:[NSURL fileURLWithPath:[OTS_DOC_PATH stringByAppendingPathComponent:@"toilet.aif"]]];
    DebugLog(@"toiletDuration=====%d",toiletDuration);
    
    spaceDuration=[self getAudioDuration:[NSURL fileURLWithPath:[OTS_DOC_PATH stringByAppendingPathComponent:@"space.aif"]]];
    DebugLog(@"spaceDuration=====%d",spaceDuration);

}
-(void)mixOrigen{
    stime=1;
    pitch=1;
    formant=1;
    NSString* temp=[OTS_DOC_PATH stringByAppendingPathComponent:@"audio.aif"];

    [self ChangeSound:temp];
    if ([[NSFileManager defaultManager] fileExistsAtPath:temp]) {
        DebugLog(@"audio 成功");
        origenDuration = [self getAudioDuration:[NSURL fileURLWithPath:temp]];
        [delegate audioRecorder:self duration:origenDuration];
        DebugLog(@"origenDuration=====%d",origenDuration);
    }
}
-(void)mixHappy{
    stime=0.5;
    pitch=1.75;
    formant=0.8;
    NSString* temp=[OTS_DOC_PATH stringByAppendingPathComponent:@"happyTep.aif"];
    [self ChangeSound:temp];
    NSString*BGMusicStr=[NSString stringWithString:[[NSBundle mainBundle] pathForResource:@"happy" ofType:@"mp3"]];
    NSString*mixedStr=[OTS_DOC_PATH stringByAppendingPathComponent:@"happy.aif"];
    [self mixAudio:temp withAudio:BGMusicStr outputPath:mixedStr completionBlock:^(int aExportStats){
        [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
    }];
    if ([[NSFileManager defaultManager] fileExistsAtPath:mixedStr]) {
        DebugLog(@"happy.aif 成功");

    }
}
-(void)mixToilet{
    stime=1;
    pitch=0.7;
    formant=0.8;
    NSString* temp=[OTS_DOC_PATH stringByAppendingPathComponent:@"toiletTep.aif"];

    [self ChangeSound:temp];
    NSString*BGMusicStr=[NSString stringWithString:[[NSBundle mainBundle] pathForResource:@"toilet" ofType:@"mp3"]];
    NSString*mixedStr=[OTS_DOC_PATH stringByAppendingPathComponent:@"toilet.aif"];
    [self mixAudio:temp withAudio:BGMusicStr outputPath:mixedStr completionBlock:^(int aExportStats){
        [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
    }];
    if ([[NSFileManager defaultManager] fileExistsAtPath:mixedStr]) {
    }
}
-(void)mixSpace{
    stime=1;
    pitch=1;
    formant=1;
    NSString* origen=[OTS_DOC_PATH stringByAppendingPathComponent:@"audio.aif"];
    NSString* BGMusicStr=[NSString stringWithString:[[NSBundle mainBundle] pathForResource:@"space" ofType:@"mp3"]];
    NSString* mixedStr=[OTS_DOC_PATH stringByAppendingPathComponent:@"space.aif"];
    [self mixAudio:origen withAudio:BGMusicStr outputPath:mixedStr completionBlock:^(int aExportStats){
    }];
    if ([[NSFileManager defaultManager] fileExistsAtPath:mixedStr]) {
        DebugLog(@"space.aif 成功");

    }

}

- (void) setUpAndAddAudioAtPath:(NSURL*)assetURL
                  toComposition:(AVMutableComposition *)composition
                         volume:(float)aVolome

{
    DebugLog(@"%@",assetURL);
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [OTSUtility safeObjectAtIndex:0 inArray:[songAsset tracksWithMediaType:AVMediaTypeAudio]];//数组越界秒退修改
    
    NSError *error = nil;
    
    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
    CMTime trackDuration;
//    if (CMTimeGetSeconds(songAsset.duration)>9) {
//       trackDuration=CMTimeMakeWithSeconds(0, 9);
//    }else
//    {
        trackDuration=songAsset.duration;
//    }
    //CMTime longestTime = CMTimeMake(848896, 44100); //(19.24 seconds)
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:aVolome atTime:startTime];
    [self.audioMixParams addObject:trackMix];
    
    //Insert audio into track
    /*ok = */[track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
}

- (void) mixAudio:(NSString*)anAudioPath
        withAudio:(NSString *)anotherAudioPath
       outputPath:(NSString*)anOutputPath
  completionBlock:(void(^)(int anExportStatus))aCompletionBlock
{
    DebugLog(@"－－－－－---------－－－－－－－－\n%@\n%@\n%@\n－－－－－－－－-－－－－－-----－－",anAudioPath,anotherAudioPath,anOutputPath);
    AVMutableComposition *composition = [AVMutableComposition composition];
    self.audioMixParams = [NSMutableArray array];
    
    //Add Audio Tracks to Composition
    //NSString *URLPath1 = pathToYourAudioFile1;
    NSURL *assetURL1 = [NSURL fileURLWithPath:anAudioPath];
    [self setUpAndAddAudioAtPath:assetURL1 toComposition:composition volume:2.f];
    
    //NSString *URLPath2 = pathToYourAudioFile2;
    NSURL *assetURL2 = [NSURL fileURLWithPath:anotherAudioPath];
    [self setUpAndAddAudioAtPath:assetURL2 toComposition:composition volume:.6f];
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:self .audioMixParams];
    
    //If you need to query what formats you can export to, here's a way to find out
//    DebugLog (@"compatible presets for songAsset: %@",
//           [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: composition
                                      presetName: AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputFileType = AVFileTypeAppleM4A; //@"com.apple.m4a-audio";
    //NSString *fileName = @"someFilename";
    //NSString *exportFile = anOutputPath;
    
    // set up export
    [[NSFileManager defaultManager] removeItemAtPath:anOutputPath error:nil];
    NSURL *exportURL = [NSURL fileURLWithPath:anOutputPath];
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        int exportStatus = exporter.status;
        
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                //NSError *exportError = exporter.error;
                DebugLog(@"AVAssetExportSessionStatusFailed: %@", exporter.error);
                break;
                
            case AVAssetExportSessionStatusCompleted:
                DebugLog (@"AVAssetExportSessionStatusCompleted");
                break;
            case AVAssetExportSessionStatusUnknown:
                DebugLog (@"AVAssetExportSessionStatusUnknown");
                break;
            case AVAssetExportSessionStatusExporting:
                DebugLog (@"AVAssetExportSessionStatusExporting");
                break;
            case AVAssetExportSessionStatusCancelled:
                DebugLog (@"AVAssetExportSessionStatusCancelled");
                break;
            case AVAssetExportSessionStatusWaiting:
                DebugLog (@"AVAssetExportSessionStatusWaiting");
                break;
            default:
                DebugLog (@"didn't get export status");
                break;
        }
        
        aCompletionBlock(exportStatus);
        
    }];
    
}
//转换音频效果
-(void)ChangeSound:(NSString*)outPutUrl
{
        reader = [[EAFRead alloc] init];


        writer = [[EAFWrite alloc] init];

    
    long numChannels = 1;	//声道
	float sampleRate = 44100.0;//采样率
    
    [reader openFileForRead:[NSURL fileURLWithPath:audioPath] sr:sampleRate channels:numChannels];
    [writer openFileForWrite:[NSURL fileURLWithPath:outPutUrl] sr:sampleRate channels:numChannels wordLength:16 type:kAudioFileAIFFType];
    
    //分别是时间，频率，振幅参数
//     stime = 1;
//     pitch = 1.4;
//     formant = 1;
    
    void *dirac = DiracCreate(kDiracLambdaPreview, kDiracQualityPreview, numChannels, sampleRate, &myReadData, (void*)self);
    DiracSetProperty(kDiracPropertyTimeFactor, stime, dirac);
	DiracSetProperty(kDiracPropertyPitchFactor, pitch, dirac);
	DiracSetProperty(kDiracPropertyFormantFactor, formant, dirac);
//    if (pitch > 1.0)
		DiracSetProperty(kDiracPropertyUseConstantCpuPitchShift, pitch, dirac);
    DiracPrintSettings(dirac);
    
    SInt64 numf = [reader fileNumFrames];
	SInt64 outframes = 0;
	SInt64 newOutframe = numf*stime;
	//long lastPercent = -1;
	percent = 0;
    
    long numFrames = 8192;
	float **audio = AllocateAudioBuffer(numChannels, numFrames);
	double bavg = 0;
    
    for(;;)
    {
        DiracStartClock();
        long ret = DiracProcess(audio, numFrames, dirac);
        bavg += (numFrames/sampleRate);
        gExecTimeTotal += DiracClockTimeSeconds();
        
        long framesToWrite = numFrames;
        unsigned long nextWrite = outframes + numFrames;
        if (nextWrite > newOutframe)
            framesToWrite = numFrames - nextWrite + newOutframe;
        if (framesToWrite < 0)
            framesToWrite = 0;
        [writer writeFloats:framesToWrite fromArray:audio];
        outframes += numFrames;
        if (ret <= 0)
            break;
    }
    NSData* data=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outPutUrl]];
    DebugLog(@"%d",data.length);
    DeallocateAudioBuffer(audio, numChannels);
    DiracDestroy( dirac );
    [reader release];
    reader=nil;
    [writer release];
    writer=nil;
}
#pragma mark --
-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    DebugLog(@".....");
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    DebugLog(@"%@",error);
}
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    DebugLog(@"interrupped");
}

//定时检测音量
-(void)CheckVolume
{
//    DebugLog(@"%f",peak);
    if(timeActive)
    {
        Float32 peak = [[SCListener sharedListener] peakPower];
        DebugLog(@"录音中.......%f",peak);
            [delegate audioRecorder:self SLpower:peak];
            breakCount++;
        
    }
    else {
            breakCount=0;
        }
}


@end
