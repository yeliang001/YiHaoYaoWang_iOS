//
//  PromotionCell.h
//  TheStoreApp
//
//  Created by yuan jun on 12-10-29.
//
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "SDWebDataManager.h"
#import "OTSImageView.h"

@interface PromotionCell : UITableViewCell<SDWebDataManagerDelegate>
{
    BOOL isMulti,isNotEnough,isSelected;
    OTSImageView*productIcon;
    UIImageView*checkImg;
    UILabel* tittleLabel,*priceLab;
    StrikeThroughLabel* marketPriceLbl;
    UILabel* conditionLab;
    UIView* flogyView;
    UIView*notEnough;
}
@property(nonatomic,retain)UIView* flogyView,*notEnough;
@property(nonatomic,retain)StrikeThroughLabel* marketPriceLbl;
@property(nonatomic,retain)UILabel* tittleLabel,*priceLab,*conditionLab;
@property(nonatomic,retain)OTSImageView* productIcon;
@property(nonatomic,retain)UIImageView*checkImg;
@property(nonatomic,assign)BOOL isMulti,isNotEnough;
-(void)hasNoMore;
-(void)addCheckView;
-(void)productIcon:(NSString*)iconUrl;
-(void)selectCell;
-(void)canNotJoin;
@end
