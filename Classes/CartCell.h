//
//  CartCell.h
//  TheStoreApp
//
//  Created by yuan jun on 12-10-25.
//
//

#import <UIKit/UIKit.h>
#import "SDWebDataManager.h"
#import "OTSImageView.h"
@interface CartCell : UITableViewCell<SDWebDataManagerDelegate>
{
    UILabel* priceLab;
    UIButton*mountBtn;
    UILabel *tittleLabel;
    OTSImageView*productIcon;
    UILabel*giftLabel,*shakeLabel,*promotionLab,*promotionCountLab,*seckillLab;
    UIImageView* giftlog;
    NSString* productId;
    UILabel* priceHeadLabel;
    UIView* separateLine;
    UIImageView* NNArrow;
    UILabel* pointLab;
}
@property(nonatomic,retain)NSString* productId;
@property(nonatomic,retain)UIImageView* giftlog;
@property(nonatomic,retain)UILabel*giftLabel,*shakeLabel,*promotionLab,*promotionCountLab,* pointLab,*seckillLab;
@property(nonatomic,retain)UILabel* priceLab;
@property(nonatomic,retain)UIButton*mountBtn;
@property(nonatomic,retain)UILabel *tittleLabel;
@property(nonatomic,retain)OTSImageView*productIcon;
@property(nonatomic,retain)UILabel* priceHeadLabel;
@property(nonatomic,retain)UIView* separateLine;
@property(nonatomic,retain)UIImageView* NNArrow;
- (void)addcover;
- (void)editingStatus:(BOOL)editing;
- (void)downloadProductIcon:(NSString*)iconUrl;
- (void)isGiftCell;
- (void)isPromotionCell;
- (void)hasGift;
- (void)isRockBuy;
@end
