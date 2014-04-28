//
//  OTSNavigationBar.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  描述：此类用以简化自定义导航视图的创建

#import <UIKit/UIKit.h>

@interface OTSNavigationBar : UIView
{
    
}
@property(nonatomic, retain)UILabel         *titleLabel;
@property (nonatomic, retain) UIButton* leftNaviBtn;
-(void)setLeftBtnImg:(UIImage*)normal highlight:(UIImage*)highLigth;
- (id)initWithTitle:(NSString*)aTitle;

- (id)initWithTitle:(NSString*)aTitle 
          backTitle:(NSString*)aBackTitle 
         backAction:(SEL)aBackAction 
   backActionTarget:(id)aBackActionTarget;
@end
