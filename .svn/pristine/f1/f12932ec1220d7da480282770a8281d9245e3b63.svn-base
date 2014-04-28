//
//  Gift.h
//  TheStoreApp
//
//  Created by jiming huang on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define VIEW_GIFT   1
#define RECEIVE_GIFT   2

#import <UIKit/UIKit.h>

@interface Gift : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UILabel *m_TitleLabel;//
    IBOutlet UIButton *m_TitleLeftBtn;//
    IBOutlet UIButton *m_TitleRightBtn;//
    IBOutlet UIScrollView *m_ScrollView;//
    
    NSArray *m_GiftArray;//传入参数，MobilePromotionVO列表
    NSMutableArray *m_SelectedGiftArray;
    int m_Tag;//传入参数，查看赠品或领取赠品
    NSArray *m_UserSelectedGiftArray;//传入参数，用户选中的赠品，包含NSMutableDictionary
}
@property(nonatomic,retain) NSArray *m_GiftArray;//传入参数，MobilePromotionVO列表
@property int m_Tag;//传入参数，1查看赠品，2领取赠品
@property(nonatomic,retain) NSArray *m_UserSelectedGiftArray;//传入参数，用户选中的赠品，包含NSMutableDictionary
-(void)initGiftArray;
-(IBAction)cancelBtnClicked:(id)sender;
-(IBAction)finishBtnClicked:(id)sender;
@end
