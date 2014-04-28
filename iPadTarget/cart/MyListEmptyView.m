//
//  MyListEmptyView.m
//  yhd
//
//  Created by dev dev on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyListEmptyView.h"

@implementation MyListEmptyView
@synthesize type;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)refreshEmptyView
{
    switch ([type intValue])
    {
        case 0:
            break;
        case 1:
        {
            UIImage * icon = [UIImage imageNamed:@"listemptyicon@2x.png"];
            mIconView.image =  icon;
            mIconView.frame = CGRectMake((725-icon.size.width/2)/2, mIconView.frame.origin.y, 112, 152);
            mTextLabel1.text = @"最近没有处理中的订单";
            mTextLabel2.text = nil;
            mNewAddressButton.hidden = YES;
        }
            break;
        case 2:
        {
            UIImage * icon = [UIImage imageNamed:@"listemptyicon@2x.png"];
            mIconView.image =  icon;
            mIconView.frame = CGRectMake((725-icon.size.width/2)/2, mIconView.frame.origin.y, 112, 152);
            mTextLabel1.text = @"还没有已完成的订单";
            mTextLabel2.text = nil;
            mNewAddressButton.hidden = YES;
        }
            break;
        case 3:
        {
            UIImage * icon = [UIImage imageNamed:@"listemptyicon@2x.png"];
            mIconView.image =  icon;
            mIconView.frame = CGRectMake((725-icon.size.width/2)/2, mIconView.frame.origin.y, 112, 152);
            mTextLabel1.text = @"没有已取消的订单";
            mTextLabel2.text = nil;
            mNewAddressButton.hidden = YES;
        }
            break;
        case 4:
        {
            UIImage * icon = [UIImage imageNamed:@"listemptyicon@2x.png"];
            mIconView.image =  icon;
            mIconView.frame = CGRectMake((725-icon.size.width/2)/2, mIconView.frame.origin.y, 112, 152);
            mTextLabel1.text = @"还没有购买过订单";
            mTextLabel2.text = nil;
            mNewAddressButton.hidden = YES;
        }
            break;
        case 5:
        {
            UIImage * icon = [UIImage imageNamed:@"favouriteemptyicon@2x.png"]; 
            mIconView.image = icon;
            mIconView.frame = CGRectMake((725-icon.size.width/2)/2, mIconView.frame.origin.y, 148, 145);
            mTextLabel1.text = @"还没有收藏过商品";
            mTextLabel2.text = @"可以将经常购买、犹豫是否购买的商品放入收藏夹";
            mTextLabel3.text = @"，方便下次购买。";
            mNewAddressButton.hidden = YES;
        }
            break;
        case 6:
        {
            UIImage * icon = [UIImage imageNamed:@"addressemptyicon@2x.png"]; 
            mIconView.image = icon;
            mIconView.frame = CGRectMake((725-icon.size.width/2)/2, mIconView.frame.origin.y, 148, 143);
            mTextLabel1.text = @"还没有收货地址";
            mTextLabel2.text = @"可以添加常用地址，方便购物";
            mNewAddressButton.hidden = NO;
        }
            break;
        default:
            break;
    }
}
-(IBAction)NewAddressClicked:(id)sender
{
    [self.delegate NewAddress];
}
@end
