//
//  PopViewController.h
//  yhd
//
//  Created by  on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class SearchBrandVO,SearchPriceVO;
@protocol PopViewControllerDelegate <NSObject>
@required
- (void)popItemSelected:(NSNumber *)brandid attribute:(NSString *) attribute priceRange:(NSString *)priceRange;
-(NSString*)attributesFilterString;
- (void)popClose;
@end

// CLASS_DESC: view pop over product list for filtering
@interface PopViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
     IBOutlet UITableView *popTableView;
    NSMutableArray *listData;
    SearchBrandVO *searchBrandVO;
    //NSArray *searchCategorys;
    SearchPriceVO *searchPriceVO;
    NSDictionary *itemDic;
    id<PopViewControllerDelegate> popDelegate;
    NSInteger type;//1，一级 2，二级
    
    //NSString *facetValueIds;//二级页面保存 ids字符串
    IBOutlet UILabel *nameLabel;
}
@property(nonatomic,retain)NSMutableArray *listData;
@property(nonatomic,retain)NSDictionary *itemDic;
//@property(nonatomic,copy)NSString *facetValueIds;
@property(nonatomic,assign)id<PopViewControllerDelegate> popDelegate;
@property(nonatomic)NSInteger type;
//@property(nonatomic,retain)NSArray *searchCategorys;
@property(nonatomic,retain)SearchBrandVO *searchBrandVO;
@property(nonatomic,retain)SearchPriceVO *searchPriceVO;

@end
