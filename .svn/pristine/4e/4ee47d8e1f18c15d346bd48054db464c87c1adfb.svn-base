//
//  MyListEmptyView.h
//  yhd
//
//  Created by dev dev on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyListEmptyDelegate<NSObject>
-(void)NewAddress;
@end
@interface MyListEmptyView : UIView
{
    IBOutlet UIImageView *mIconView;
    IBOutlet UILabel * mTextLabel1;
    IBOutlet UILabel * mTextLabel2;
    IBOutlet UILabel * mTextLabel3;
    IBOutlet UIButton * mNewAddressButton;
    NSNumber * type;//1for ongoing order 2for finished order 3for canceled order 4for history order 5for favourite 6 for receivelist
    id <MyListEmptyDelegate>delegate;
}
@property(nonatomic,retain)NSNumber * type;
@property(nonatomic,retain)id<MyListEmptyDelegate>delegate;
-(IBAction)NewAddressClicked:(id)sender;
-(void)refreshEmptyView;
@end
