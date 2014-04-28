//
//  GameRecViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-1.
//
//

#import <UIKit/UIKit.h>
#import "GameBaseViewController.h"
#import "GameProgressView.h"
#import "AudioRecorder.h"
#import "RockGameProductVO.h"
#import "SDWebDataManager.h"
#import "RockGameVO.h"
@interface GameRecViewController : GameBaseViewController<AudioRecorderDelegate,MFMessageComposeViewControllerDelegate,SDWebDataManagerDelegate>
{
    RockGameProductVO*rockGameProductVo;
    GameProgressView*volume;
    AudioRecorder *audioRecorder;
    UIImageView *micImage;
    UIButton* recordBtn,*reRecBtn,*recFinishBtn,*playBtn;
    UIImageView*bg;
    UILabel* timeLab;
    NSString* shareCellPhone,*shareCellName;
    UIImageView*giftPic;
    NSMutableArray* soundBtnArray;
    BOOL recordFinished,rec2Short,rec2Long;
    UIImage*productImg;
    long gameFlowId;
}
@property(nonatomic,retain)NSMutableArray* soundBtnArray;
@property(nonatomic,retain)RockGameProductVO*rockGameProductVo;
@property(nonatomic,retain)NSString* shareCellPhone,*shareCellName;
@end
