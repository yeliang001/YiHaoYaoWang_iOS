//
//  CateCell.h
//  yhd
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVO.h"
@protocol CateCellDelegate
- (void)openCateView:(CategoryVO *)cate;

@end
@interface CateCell : UITableViewCell{
    UILabel *cateNameLabel;
    BOOL isEven;
    id<CateCellDelegate> cellDelegate;
    CategoryVO *cate;
}
@property(nonatomic,retain)UILabel *cateNameLabel;
@property(nonatomic,retain)CategoryVO *cate;
@property(nonatomic)BOOL isEven;
@property(nonatomic,assign)id<CateCellDelegate> cellDelegate;
@end
