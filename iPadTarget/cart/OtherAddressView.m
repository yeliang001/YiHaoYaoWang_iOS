//
//  OtherAddressView.m
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OtherAddressView.h"
#import "OtherAddressViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ProvinceVO.h"
#import "DataHandler.h"
#import "OTSGpsHelper.h"

@implementation OtherAddressView
@synthesize mReceiveList;
@synthesize mIsAllAddressunavailable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    mImageView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mImageView.layer.borderWidth =1;
    mTableView.tableHeaderView.hidden = !mIsAllAddressunavailable;
    if (!mTableView.tableHeaderView.hidden) 
    {
        //DataHandler * tempData = [DataHandler sharedDataHandler];
        mProvinceLabel.text = [OTSGpsHelper sharedInstance].provinceVO.provinceName;
        mProvinceLabel.frame =CGRectMake(mProvinceLabel.frame.origin.x, mProvinceLabel.frame.origin.y,[mProvinceLabel.text sizeWithFont:mProvinceLabel.font].width , mProvinceLabel.frame.size.height);
        mProvinceAfterLabel.frame = CGRectMake(mProvinceLabel.frame.origin.x+mProvinceLabel.frame.size.width, mProvinceAfterLabel.frame.origin.y, mProvinceAfterLabel.frame.size.width, mProvinceAfterLabel.frame.size.height);
        mGoToNewImageView.frame = CGRectMake(mProvinceAfterLabel.frame.origin.x+mProvinceAfterLabel.frame.size.width, mGoToNewImageView.frame.origin.y, mGoToNewImageView.frame.size.width, mGoToNewImageView.frame.size.height);
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popaddressunavailable) name:@"addressunavailable" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(EditAddressFromCell:) name:@"EditAddressFromCell" object:nil];
}
-(void)popaddressunavailable
{
    //DataHandler * tempdata = [DataHandler sharedDataHandler];
    UIAlertView * tempalert = [[UIAlertView alloc]initWithTitle:@"无法下订单" message:[NSString stringWithFormat:@"订单地址与收货省份%@不一致，无法下单。\n切换省份，会使您购物车中的部分商品价格变化或者不能购买",[OTSGpsHelper sharedInstance].provinceVO.provinceName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"修改地址",@"更换省份",nil];
    [tempalert show];
    [tempalert release];
}
-(void)EditAddressFromCell:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EditAddressFromOtherAddress" object:[mReceiveList objectAtIndex:((OtherAddressViewCell*)notification.object).mindex] userInfo:nil];
}
-(IBAction)closeClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popotheraddress" object:nil userInfo:nil];
}
-(IBAction)newaddressClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushnewaddressfromotheraddress" object:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mReceiveList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"OtherAddressViewCell";
    
    OtherAddressViewCell *cell = (OtherAddressViewCell*)[tableView dequeueReusableCellWithIdentifier:
                                                 SimpleTableIdentifier];
    if (cell == nil) { 
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"OtherAddressViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.mGoodReceiver = (GoodReceiverVO*)[mReceiveList objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell refresh];
    cell.mindex = indexPath.row;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mreceivelistselectedindex = indexPath.row;
    //DataHandler * tempdata = [DataHandler sharedDataHandler];
    if ([[OTSGpsHelper sharedInstance].provinceVO.nid longValue]!= [((GoodReceiverVO*)[mReceiveList objectAtIndex:mreceivelistselectedindex]).provinceId longValue] ) 
    {
        [self performSelector:@selector(popaddressunavailable)];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"popotheraddress" object:[NSNumber numberWithInt:mreceivelistselectedindex] userInfo:nil];
    }
    
}
#pragma mark - UIAlertViewDelegata
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) 
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"EditAddressFromOtherAddress" object:[mReceiveList objectAtIndex:mreceivelistselectedindex] userInfo:nil];
    }
    else if(buttonIndex == 1)
    {
        
        ProvinceVO *province = [[ProvinceVO alloc]init];
        province.provinceName=((GoodReceiverVO*)[mReceiveList objectAtIndex:mreceivelistselectedindex]).provinceName;
        province.nid=((GoodReceiverVO*)[mReceiveList objectAtIndex:mreceivelistselectedindex]).provinceId;
        //DataHandler * tempdata = [DataHandler sharedDataHandler];
        [OTSGpsHelper sharedInstance].provinceVO = province;
        [GlobalValue getGlobalValueInstance].provinceId=province.nid;
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:province,@"province", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"popotheraddress" object:nil userInfo:nil];
        [province release];
    }
}
#pragma mark - OtherAddressDelegate
-(void)editFromAddressCell:(int)index
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EditAddressFromOtherAddress" object:[mReceiveList objectAtIndex:index] userInfo:nil];
}
@end
