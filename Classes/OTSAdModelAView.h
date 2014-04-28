//
//  OTSAdModelAView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define LEFT_TYPE   1                   //类型为1时大图在左
#define RIGHT_TYPE  2                   //类型为2时大图在右
#define LEFT_TYPE_IMAGE_HEIGHT  59
#define RIGHT_TYPE_IMAGE_HEIGHT 44

#import <UIKit/UIKit.h>

@protocol OTSAdModelAViewDelegate;
@class AdvertisingPromotionVO;

@interface OTSAdModelAView : UIView<UITableViewDelegate,UITableViewDataSource> {
    id<OTSAdModelAViewDelegate> m_Delegate;
    UITableView *m_TableView;
    UIImageView *m_ImageView;
    AdvertisingPromotionVO *m_AdVO;
}

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate tag:(int)tag;
-(void)reloadModelAView;

@end

@protocol OTSAdModelAViewDelegate <NSObject>

-(AdvertisingPromotionVO *)adModelAViewData:(OTSAdModelAView *)adModelAView;
-(void)adModelAView:(OTSAdModelAView *)adModelAView keyWordBtnClicked:(UIButton *)keyWordBtn;
-(void)adModelAView:(OTSAdModelAView *)adModelAView bigImageBtnClicked:(UIButton *)bigImageBtn;
-(void)adModelAView:(OTSAdModelAView *)adModelAView didSelectRowAtIndexPath:(NSIndexPath * )indexPath;
@end
