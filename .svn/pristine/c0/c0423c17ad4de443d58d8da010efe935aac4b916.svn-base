//
//  CustomOrderCell.h
//  yhd
//
//  Created by dev dev on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderV2;
@protocol CustomOrderCellDelegate <NSObject>
@required 
-(void)payclicked:(OrderV2*)order;
-(void)addtoCart:(OrderV2*)order;
-(void)productViewClicked:(OrderV2*)order;
@end

@interface CustomOrderCell : UITableViewCell<UIScrollViewDelegate>
{
    IBOutlet UILabel * mlabel;
    OrderV2* mOrder;
    IBOutlet UIScrollView * mItemScrollView;
    
    IBOutlet UILabel * mDateLabel;
    IBOutlet UILabel * mNameLabel;
    IBOutlet UILabel * mPaymentLabel;
    IBOutlet UILabel * mTotalPriceLabel;
    IBOutlet UIView * mBackView;
    IBOutlet UILabel * mOrderStatueLabel;
    id<CustomOrderCellDelegate> delegate;
    
    IBOutlet UIButton * mGotoPayButton;
    IBOutlet UIButton * mAddtoCartButton;
    IBOutlet UIButton * m_CancelButton;
}
@property(nonatomic,retain)UILabel * mlabel;
@property(nonatomic,retain)OrderV2 * mOrder;
@property(nonatomic,retain)id<CustomOrderCellDelegate> delegate;
@property(nonatomic, retain)IBOutlet UIButton*  payButton;

-(IBAction)GotoPayClicked:(id)sender;
-(IBAction)AddToCartClicked:(id)sender;
-(IBAction)PushOrderTrackNotification;
-(IBAction)cancelButtonClicked:(id)sender;
-(void)reloadCellWithOrder:(OrderV2 *)orderV2;
-(void)updateCell;
@end
