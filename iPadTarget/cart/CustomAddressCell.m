//
//  CustomAddressCell.m
//  yhd
//
//  Created by dev dev on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomAddressCell.h"
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"
#import "GlobalValue.h"
@implementation CustomAddressCell
@synthesize mGoodReceiver;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showAddress
{
    NSString * mphonenumber;
    if (mGoodReceiver.receiverMobile)
    {
        mphonenumber = mGoodReceiver.receiverMobile;
    }
    else {
        mphonenumber = mGoodReceiver.receiverPhone;
    }
    if ([mGoodReceiver.provinceName isEqualToString:@"上海"]) {
        mlabel.text = [NSString stringWithFormat:@"%@   %@   %@   %@   %@",mGoodReceiver.receiveName,mGoodReceiver.provinceName,mGoodReceiver.cityName,mGoodReceiver.address1,mphonenumber];
    } else {
        mlabel.text = [NSString stringWithFormat:@"%@   %@   %@   %@   %@   %@",mGoodReceiver.receiveName,mGoodReceiver.provinceName,mGoodReceiver.cityName,mGoodReceiver.countyName,mGoodReceiver.address1,mphonenumber];
    }
    NSLog(@"%@,%@",mGoodReceiver.nid,mGoodReceiver.defaultAddressId);
    if ([mGoodReceiver.nid doubleValue]== [mGoodReceiver.defaultAddressId doubleValue])
    {
        mSetDefaultButton.hidden = YES;
    }
}
-(void)dealloc
{
    [mGoodReceiver release];
    [super dealloc];
}
-(IBAction)setDefaultAddress:(id)sender
{
    mGoodReceiver.defaultAddressId =  [NSNumber numberWithLong:1];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(DefaultAddress) toTarget:self withObject:nil];
}
-(IBAction)deleteAddress:(id)sender
{
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(DeleteAddress) toTarget:self withObject:nil];
    [self.delegate deleteAddressByAddressId:mGoodReceiver.nid]; 
}
-(IBAction)editAddress:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kEditAddress" object:self userInfo:nil];
}
-(void)DefaultAddress
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    [service updateGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverVO:mGoodReceiver];
    [pool drain];
}
-(void)DeleteAddress
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service deleteGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverId:mGoodReceiver.nid];
    if (result ==1)
    {
        [self performSelectorOnMainThread:@selector(PushRefreshAddress) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}
-(void)PushRefreshAddress
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kRefreshAddress" object:nil userInfo:nil];
}
@end
