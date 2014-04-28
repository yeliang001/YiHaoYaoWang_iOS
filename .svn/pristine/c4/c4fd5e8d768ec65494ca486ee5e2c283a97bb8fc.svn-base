//
//  GameGiftListViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-10.
//
//

#import <UIKit/UIKit.h>

@class RockGameVO;
@protocol giftListDelegate <NSObject>

-(void)gestureHiddenGiftList;

@end
@interface GameGiftListViewController : UIView{
    UIImageView* bgImg;
    id<giftListDelegate> delegate;
}
@property(assign)id<giftListDelegate> delegate;
@property (nonatomic, retain) OTSLoadingView    *loadingView;

-(void)updateWihtRockGameVO:(RockGameVO*)aGameVO;
@end
