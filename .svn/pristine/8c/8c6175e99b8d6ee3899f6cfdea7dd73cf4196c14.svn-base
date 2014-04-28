//
//  Cate2Cell.h
//  yhd
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVO.h"
@protocol Cate2CellDelegate
- (void)openProductList:(CategoryVO *)cate2 cate3:(CategoryVO *)cate3;

@end
@interface Cate2Cell : UITableViewCell{
    id<Cate2CellDelegate> cellDelegate;
    CategoryVO *cate2;
    NSArray *cate3Array;
    NSInteger height;
}
@property(nonatomic,assign)id<Cate2CellDelegate> cellDelegate;
@property(nonatomic,retain)CategoryVO *cate2;
@property(nonatomic,retain)NSArray *cate3Array;
@property (nonatomic) NSInteger height;
@end
