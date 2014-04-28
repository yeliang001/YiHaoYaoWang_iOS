//
//  GameBaseViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-11.
//
//

#import <UIKit/UIKit.h>
#import "OTSPhoneWeRockBaseVC.h"
#import "GameIntroduceView.h"
#import "GameGiftListViewController.h"
#import "RockGameVO.h"
@interface GameBaseViewController : OTSPhoneWeRockBaseVC<giftListDelegate,GameIntroduceDelegate>
{
    GameGiftListViewController*giftList;
    GameIntroduceView* gameIntro;
    UIButton* QABtn;
    UIButton* giftBox;
    RockGameVO* rockGameVO;
}
@property(assign)UIButton* QABtn;
@property(nonatomic,retain)RockGameVO*rockGameVO;

-(void)showGameIntro;
-(void)hiddenGameIntro;
-(void)hiddenGameGiftList;
-(void)showGameGiftList;
-(void)helpShow:(UIButton*)btn;
@end
