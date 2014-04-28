//
//  CategorySelectionCell.h
//  TheStoreApp
//
//  Created by jun yuan on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySelectionCell : UITableViewCell{
    UIImageView* arrowImg;
    UIImageView* nextCateImg;
    UIImageView* upback;
    UILabel* cateNameLab;
    UILabel* cateproduct;
    BOOL showNextCate;
    BOOL showArrow;
}
@property(nonatomic,retain)UILabel* cateNameLab;
@property(nonatomic,retain)UILabel* cateproduct;
-(void)setShowArrow:(BOOL)_showArrow;
-(void)setShowNextCate:(BOOL)_showNextCate;
-(void)setShowUpBack:(BOOL)_upback;
-(void)setShowCatePro:(BOOL)_catepro;
@end
