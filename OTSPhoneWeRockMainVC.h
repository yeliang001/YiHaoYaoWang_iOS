//
//  OTSPhoneWeRockMainVC.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import <UIKit/UIKit.h>
#import "OTSPhoneWeRockBaseVC.h"
#include "OTSPhoneWebRock.h"
#import "OTSPhoneWeRockResultNormalView.h"
#import "OTSPhoneMotionableView.h"
#import "GameViewController.h"
#import <CoreLocation/CLLocationManagerDelegate.h>

@class OTSPhoneWeRockBubbleView;

@interface OTSPhoneWeRockMainVC : OTSPhoneWeRockBaseVC
<OTSPhoneWeRockResultNormalViewDelegate, OTSPhoneMotionableViewDelegate, CLLocationManagerDelegate>{
    GameViewController*gameVc;
}
@property(retain,nonatomic) GameViewController*gameVc;
@property (retain, nonatomic) IBOutlet UIButton *inventoryBtn;
@property (retain, nonatomic) IBOutlet UIButton *gameBtn;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UIButton *ruleBtn;

@property (retain, nonatomic) IBOutlet OTSPhoneWeRockBubbleView *bubbleView;

@end
