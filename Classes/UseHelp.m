//
//  UseHelp.m
//  TheStoreApp
//
//  Created by lix on 11-3-1.
     //modify tianjsh 0303
//  Copyright 2011 vsc. All rights reserved.
//
#import<QuartzCore/QuartzCore.h>
#import "GroupBuyGuide.h"

#import "UseHelp.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum _EOTSHelpItem
{
    KOTSHelpItemQureyOrder = 0
    , KOTSHelpItemModifyOrder
    , KOTSHelpItemCancelOrder
    , KOTSHelpItemGroupBuy
 //   , KOTSHelpItemDivideOrder
 //   , KOTSHelpItemMailCostOfDividedOrder
 //   , KOTSHelpItemBuyByPhone
    , KOTSHelpItemFailedRecieveProducts
    , KOTSHelpItemSendBackProducts
    , KOTSHelpItemSignProducts
}EOTSHelpItem;

@implementation UseHelp


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[returnBtnInMainView setTitleColor:[UIColor whiteColor] forState:0];
	[frontBtnInShowView setTitleColor:[UIColor whiteColor] forState:0];
	[moreBtnInShowView setTitleColor:[UIColor whiteColor] forState:0];
	table.frame=CGRectMake(0, 44, 320, self.view.frame.size.height-44);
	UserHelpList = [[NSArray alloc] initWithObjects:@"如何查询订单"
                    , @"如何修改订单"
                    , @"如何取消订单"
                    , @"团购规则"
                    , @"收不到商品怎么办"
                    , @"退换货说明"
                    , @"如何签收与拒收商品"
                    , nil];
	[UIView setAnimationsEnabled:NO];
}
//返回上一页
-(void)returnFront:(id)sender
{  
	CATransition *animation = [CATransition animation]; 
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
    [showView removeFromSuperview];


}
//到更多主页
-(void)returnMoreMainpage:(id)sender
{
	CATransition *animation = [CATransition animation]; 
	animation.duration = 0.3f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
	[self removeSelf];
}

//返回每一项标题
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	return [UserHelpList count];
}

//构建使用帮助每一项
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *useHelp = @"usehelp";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:useHelp];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:useHelp] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
	}
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.textColor=UIColorFromRGB(0x333333);
	cell.textLabel.text = [UserHelpList objectAtIndex:[indexPath row]];
	return cell;
}

//处理行选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	CATransition *animation = [CATransition animation]; 
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[self.view addSubview:showView];
    
    // 容器VIEW,加载文字信息,用于方便的管理复用的showview上的内容
    if (containerView != nil) {
        [containerView removeFromSuperview];
        [containerView release];
    }
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [containerView setBackgroundColor:[UIColor clearColor]];
	
	UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
	scrollview.backgroundColor = tableView.backgroundColor;
	[scrollview setShowsVerticalScrollIndicator:NO];
	
	UILabel *Qlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
	Qlabel.backgroundColor = [UIColor colorWithRed:238 green:238 blue:238 alpha:0.01];
	[Qlabel setFont:[UIFont systemFontOfSize:18.0]];
	switch ([indexPath row]) 
    {
		case KOTSHelpItemQureyOrder:
			Qlabel.text = @"   Q : 如何查询订单？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:selectOrder];
			scrollview.contentSize = CGSizeMake(320, 400);
			[selectOrder setFrame:CGRectMake(10, 50, 300, selectOrder.frame.size.height)];
			break;
            
		case KOTSHelpItemModifyOrder:
			Qlabel.text = @"   Q : 如何修改订单？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:modifyOrder];
			scrollview.contentSize = CGSizeMake(320, 400);		
			[modifyOrder setFrame:CGRectMake(10, 50, 300, modifyOrder.frame.size.height)];
			break;
            
		case KOTSHelpItemCancelOrder:
			
			Qlabel.text = @"   Q : 如何取消订单？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:cancelOrder];
			scrollview.contentSize = CGSizeMake(320, 400);			
			[cancelOrder setFrame:CGRectMake(10, 50, 300, cancelOrder.frame.size.height)];
			break;
            
        case KOTSHelpItemGroupBuy: // 如何团购
        {
			Qlabel.text = @"   Q : 如何团购？";
            GroupBuyGuide* groupBuyGuideVC = [[[GroupBuyGuide alloc] initWithNibName:@"GroupBuyGuide" bundle:nil] autorelease];
			[containerView addSubview:groupBuyGuideVC.view];
            groupBuyGuideVC.view.frame = CGRectMake(groupBuyGuideVC.view.frame.origin.x
                                                    , 6
                                                    , groupBuyGuideVC.view.frame.size.width
                                                    , groupBuyGuideVC.view.frame.size.height);

        }
			break;
            
/*		case KOTSHelpItemDivideOrder:
			Qlabel.text = @"  Q : 什么是订单拆分？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:orderToken];
			scrollview.contentSize = CGSizeMake(320, 400);			

			[orderToken setFrame:CGRectMake(10, 50, 300, orderToken.frame.size.height)];

			break;
            
		case KOTSHelpItemMailCostOfDividedOrder:
			Qlabel.text = @"   Q : 订单拆分的邮费怎么计算？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:postageCalculate];
			scrollview.contentSize = CGSizeMake(320, 400);			

			[postageCalculate setFrame:CGRectMake(10, 50, 300, postageCalculate.frame.size.height)];
			break;
            
		case KOTSHelpItemBuyByPhone:
			Qlabel.text = @" Q : 如何电话订购1号店商品？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:PhoneBuyProduct];
			scrollview.contentSize = CGSizeMake(320, 400);			

			[PhoneBuyProduct setFrame:CGRectMake(10, 50, 300, PhoneBuyProduct.frame.size.height)];
			break;
 */
            
		case KOTSHelpItemFailedRecieveProducts:
			Qlabel.text = @"   Q : 收不到商品怎么办？";
			[containerView addSubview:scrollview];
			[scrollview addSubview:Qlabel];
			[scrollview addSubview:NoRecProduct];
			scrollview.contentSize = CGSizeMake(320, 400);			

			[NoRecProduct setFrame:CGRectMake(10, 50, 300, NoRecProduct.frame.size.height)];
			break;
            
		case KOTSHelpItemSendBackProducts:
			Qlabel.text = @"   Q : 如何办理退换货？";

			[scrollview addSubview:Qlabel];
			scrollview.contentSize = CGSizeMake(300, 2800);
			[containerView addSubview:scrollview];
			[HowReturnProduct setFrame:CGRectMake(10,50, 300, 2750)];
			[scrollview addSubview:HowReturnProduct];
			break;
            
		case KOTSHelpItemSignProducts:
			Qlabel.text = @"  Q : 如何签收与拒收商品？";

			[scrollview addSubview:Qlabel];
			scrollview.contentSize = CGSizeMake(300, 500);
			[scrollview addSubview:HowRecAndRejectProduct];
			[containerView addSubview:scrollview];
			[HowRecAndRejectProduct setFrame:CGRectMake(10, 50, 300, HowRecAndRejectProduct.frame.size.height)];

			break;
            
		default:
			break;
	}
    [showView addSubview:containerView];
	[Qlabel release];
	[scrollview release];//tianjsh
	
} 

//返回每一项cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

	DebugLog(@"waring==%@",[self.view description]);

    // Release any cached data, images, etc that aren't in use.
}



#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(UserHelpList);
    
    // release outlet
    OTS_SAFE_RELEASE(selectOrder);                             //选择订单;
	OTS_SAFE_RELEASE(modifyOrder);							   //修改订单
	OTS_SAFE_RELEASE(cancelOrder);							   //取消订单	
	OTS_SAFE_RELEASE(orderToken);							   //订单拆分	
	OTS_SAFE_RELEASE(postageCalculate);						   //邮费计算		
	OTS_SAFE_RELEASE(PhoneBuyProduct);						   //电话订购
	OTS_SAFE_RELEASE(NoRecProduct);							   //没收到货物怎么办
	OTS_SAFE_RELEASE(HowReturnProduct);                     //怎样退货
	OTS_SAFE_RELEASE(HowRecAndRejectProduct);				   //怎样拒收与签收货物
	OTS_SAFE_RELEASE(showView);                                 //展示视图
	OTS_SAFE_RELEASE(returnBtnInMainView);                    //使用帮助主页的返回按钮
	OTS_SAFE_RELEASE(moreBtnInShowView);					   //使用帮助个分页的更多按钮
	OTS_SAFE_RELEASE(frontBtnInShowView);					   //使用帮助各分页的上一页按钮
    OTS_SAFE_RELEASE(containerView);
    
	// remove vc
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [super dealloc];
}

@end
