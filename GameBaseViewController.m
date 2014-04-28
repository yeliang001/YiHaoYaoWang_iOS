//
//  GameBaseViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-11.
//
//

#import "GameBaseViewController.h"
#import "OTSWeRockService.h"
#import "OTSLoadingView.h"
#import "GlobalValue.h"

#define HelpViewPosY ((iPhone5)?252:208)

@interface GameBaseViewController ()
@end

@implementation GameBaseViewController
@synthesize rockGameVO,QABtn;
-(void)dealloc{
    [rockGameVO release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    gameIntro=[[GameIntroduceView alloc] initWithFrame:CGRectMake(0, -(ApplicationHeight-NAVIGATION_BAR_HEIGHT), 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    gameIntro.delegate=self;
    [self.view addSubview:gameIntro];
    [gameIntro release];
    
    giftList=[[GameGiftListViewController alloc] initWithFrame:CGRectMake(0, -(ApplicationHeight-NAVIGATION_BAR_HEIGHT), 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    giftList.delegate=self;
    [self.view addSubview:giftList];
    [giftList release];
    
    QABtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [QABtn setBackgroundImage:[UIImage imageNamed:@"game_QA.png"] forState:UIControlStateNormal];
    [QABtn setBackgroundImage:[UIImage imageNamed:@"game_QA_touched.png"] forState:UIControlStateSelected];
    QABtn.frame=CGRectMake(280, 0, 40, 44);
    [QABtn addTarget:self action:@selector(helpShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:QABtn];
    
    giftBox=[UIButton buttonWithType:UIButtonTypeCustom];
    [giftBox setBackgroundImage:[UIImage imageNamed:@"game_gift.png"] forState:UIControlStateNormal];
    [giftBox setBackgroundImage:[UIImage imageNamed:@"game_gift_touched.png"] forState:UIControlStateSelected];
    [giftBox addTarget:self action:@selector(showGiftBox:) forControlEvents:UIControlEventTouchUpInside];
    giftBox.frame=CGRectMake(240, 0, 40, 44);
    [self.naviBar addSubview:giftBox];

}
-(void)showGiftBox:(UIButton*)btn{
    if (btn.selected){
        [self hiddenGameGiftList];
        btn.selected=NO;
    }
    else{
        [self showGameGiftList];
        if (QABtn.selected) {
            [self helpShow:QABtn];
        }
        btn.selected=YES;
    }
}

-(void)helpShow:(UIButton*)btn{
    if (btn.selected){
        btn.selected=NO;
        [self hiddenGameIntro];
    }
    else{
        if (giftBox.selected) {
            [self showGiftBox:giftBox];
        }
        btn.selected=YES;
        [self showGameIntro];
    }
}
#pragma mark delegate
-(void)gestureHiddenGiftList{
    [self showGiftBox:giftBox];
}

-(void)gestureHiddenGameIntroduce{
    [self helpShow:QABtn];
}
#pragma mark --
-(void)moveLayer:(CALayer*)layer to:(CGPoint)point{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.fromValue = [layer valueForKey:@"position"];
//    CGPoint p=[animation.fromValue CGPointValue];
//    NSLog(@"%f %f",p.x,p.y);
	animation.toValue = [NSValue valueWithCGPoint:point];
    
    layer.position = point;
	[layer addAnimation:animation forKey:@"position"];
}

-(void)showGameIntro{
    gameIntro.hidden=NO;
    [self moveLayer:gameIntro.layer to:CGPointMake(160, HelpViewPosY+44)];
    [self.view bringSubviewToFront:gameIntro];
    //    gameIntro=[[GameIntroduceView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
    //    [gameIntro.layer addAnimation:[OTSNaviAnimation animationPushFromBottom] forKey:@"Reveal"];
    //    [self.view addSubview:gameIntro];
    //    [gameIntro release];
}

-(void)hiddenGameIntro{
    [self moveLayer:gameIntro.layer to:CGPointMake(160, -HelpViewPosY)];
    [self performBlock:^(void){
        gameIntro.hidden=YES;
    }afterDelay:0.3];
    //    [gameIntro.layer addAnimation:[OTSNaviAnimation animationPushFromBottom] forKey:@"Reveal"];
    //    [gameIntro removeFromSuperview];
    //    gameIntro=nil;
}
-(void)hiddenGameGiftList{
    [self moveLayer:giftList.layer to:CGPointMake(160, -HelpViewPosY)];
    [self performBlock:^(void){
        giftList.hidden=YES;
    } afterDelay:0.3];
}
-(void)showGameGiftList{
    giftList.hidden=NO;
    [self moveLayer:giftList.layer to:CGPointMake(160, HelpViewPosY+44)];
    [self.view bringSubviewToFront:giftList];
    
    [self requestGiftList];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
-(void)requestGiftList
{
    [self performInThreadBlock:^{
        
        [self.loadingView showInView:giftList];
        self.rockGameVO = [[OTSWeRockService myInstance]
                           getRockGameByToken:[GlobalValue getGlobalValueInstance].token
                           type:[NSNumber numberWithInt:1]];
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        if (self.rockGameVO && self.rockGameVO.rockGameProdList.count > 0)
        {
            giftList.loadingView = self.loadingView;
            [giftList updateWihtRockGameVO:self.rockGameVO];
        }
        
    }];
}

@end
