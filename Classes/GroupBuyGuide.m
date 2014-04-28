//
//  GroupBuyGuide.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define TAG_GUIDE_TABLEVIEW                 100
#define TAG_PROBLEM_TABLEVIEW               101

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "GroupBuyGuide.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupBuyGuide

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [m_ScrollView setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    m_ScrollView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-44);
    [self updateGroupBuyGuide];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)returnBtnClicked:(id)sender
{
    CATransition * animation = [CATransition animation];
	animation.duration = 0.3f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];

    [self removeSelf];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarIndexChanged" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GroupBuyGuideReleased" object:self];
}

-(void)updateGroupBuyGuide
{
    //1号团指南
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 292) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_GUIDE_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    //常见问题
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 292, 320, 625) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_PROBLEM_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    
    [m_ScrollView setContentSize:CGSizeMake(320, 920)];
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
	switch ([tableView tag]) {
        case TAG_GUIDE_TABLEVIEW: {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(17, 0, 288, 242)];
            [label setNumberOfLines:14];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"1.仅网站注册会员可参与1号团。\n"
             "2.1号团不支持货到付款，仅限在线支付（支持账户支付）。\n"
             "3.因商品数量有限，请在下单后24小时完成付款，团购结束前未支付将视为放弃团购机会，订单自动取消。\n"
             "4.团购不可使用抵用券、VIP卡等优惠。\n"
             "5.团购成团后，订单支付成功后2-3天发货（如遇特殊情况，另行通知。\n"
             "6.1号团接受由商品质量问题导致的退货，退货成功后退款将在3个工作日退入您的1号药店账户。\n"
             "7.因团购商品数量有限，当购买数量超过限购数量时，订单按先后顺序，取消超过部分的订单。款项将根据需求返还到1号药店账户或者银行账户。"];
            
            [label setFont:[UIFont systemFontOfSize:13.0]];
            [cell addSubview:label];
            [label release];
            break;
        }
        case TAG_PROBLEM_TABLEVIEW: {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(17, 0, 288, 575)];
            [label setNumberOfLines:35];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"1、1号团购是什么？\n"
             "1号团购是1号店提供的精品消费，为您精选各类超低价产品，每日推出新款，只要订购就能享受无敌折扣。\n"
             "2、今天的团购看起来不错，怎么购买？ \n"
             "只需在团购截止时间之前点击\"购买\"按钮，根据提示下订单付款购买即可。\n"
             "3、1号团购有哪些支付方式？\n"
             "目前1号团支持1号店所有的网络支付平台，比如支付宝、银联在线、信用卡等支付方式。\n"
             "4、什么是1号团的订单号，怎么确认？\n"
             "当在1号团成功购买后，系统自动生成订单号，在“我的1号店”-“我的团购”中查看，作为您的购物凭证。\n"
             "5、购买1号团商品有积分吗？怎样获得积分？积分如何支付？\n"
             "购买1号团的商品是没有任何积分的，但是在1号店成功购物即可获赠积分。\n"
             "6、参加1号团购时，能同时享用其他优惠购物吗？\n"
             "一般不可以，只能单独支付。如果可以，我们会在团购提示里特别说明。\n"
             "7、我购买的1号团购商品，可以给其他人使用吗？\n"
             "当然可以！你可以在购买的时候填写他/她的信息，给他/她一个惊喜！\n"
             "8、如果遇到团购产品有质量问题，造成无法使用的情况怎么办？\n"
             "1号团接受由于产品质量问题引起的退货，一定会给消费者一个满意的售后服务。\n"
             "9、我是商家，想在1号团组织团购，怎么联系？\n"
             "欢迎能提供高品质服务或产品的优质商家、淘宝大卖家等成为1号团特约合作伙伴，如您有意，请联系我们。在1号团首页点击商务合作，填写相关信息。"];
            [label setFont:[UIFont systemFontOfSize:13.0]];
            [cell addSubview:label];
            [label release];
            break;
        }
        default:
            break;
    }
	
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch ([tableView tag]) {
		case TAG_GUIDE_TABLEVIEW:
			return @"1号团指南";
			break;
		case TAG_PROBLEM_TABLEVIEW:
			return @"常见问题";
			break;
        default:
			return nil;
			break;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([tableView tag]) {
		case TAG_GUIDE_TABLEVIEW:
            return 242;
			break;
		case TAG_PROBLEM_TABLEVIEW: {
			return 575;
			break;
        }
		default:
			return 0;
			break;
	}
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark -
-(void)releaseMyResoures
{
    // release outlet
    OTS_SAFE_RELEASE(m_ScrollView);
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
