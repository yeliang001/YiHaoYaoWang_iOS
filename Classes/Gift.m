//
//  Gift.m
//  TheStoreApp
//
//  Created by jiming huang on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Gift.h"
#import "MobilePromotionVO.h"
#import "ProductVO.h"
#import "DataController.h"
#import "PromotionVO.h"
#import <QuartzCore/QuartzCore.h>
#import "StrikeThroughLabel.h"
#import "ProductService.h"
#import "GlobalValue.h"
#import "AlertView.h"
#import "TheStoreAppAppDelegate.h"

@implementation Gift
@synthesize m_GiftArray;//传入参数，MobilePromotionVO列表
@synthesize m_Tag;//传入参数，1查看赠品，2领取赠品
@synthesize m_UserSelectedGiftArray;//传入参数，用户选中的赠品，包含NSMutableDictionary

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
    [self initGiftArray];
}

//初始化赠品
-(void)initGiftArray
{
    //获取用户已选的赠品
    if (m_UserSelectedGiftArray!=nil) {
        m_SelectedGiftArray=[[NSMutableArray alloc] initWithArray:m_UserSelectedGiftArray];
    } else {
        m_SelectedGiftArray=[[NSMutableArray alloc] init];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    CGFloat yValue=0.0;
    if (m_Tag==VIEW_GIFT) {//查看赠品
        [m_ScrollView setFrame:CGRectMake(0, 44, 320, 367)];
        [m_TitleLabel setText:@"赠品"];
        [m_TitleLeftBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
        [m_TitleLeftBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
        //[m_TitleLeftBtn setTitle:@"返回" forState:UIControlStateNormal];
        [m_TitleRightBtn setHidden:YES];
        //赠品提示
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(9,13,302,35)];
        [view.layer setBorderWidth:1.0];
        [view.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:219.0/255.0 blue:167.0/255.0 alpha:1.0] CGColor]];
        [view setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:254.0/254.0 blue:238.0/255.0 alpha:1.0]];
        [m_ScrollView addSubview:view];
        [view release];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(11,9,16,16)];
        [imageView setImage:[UIImage imageNamed:@"switchProvince_warn.png"]];
        [view addSubview:imageView];
        [imageView release];
        
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 270, 35)];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setText:@"领取赠品需要先将商品加入购物车，然后在购物车界面领取"];
//        [label setFont:[UIFont systemFontOfSize:13.0]];
//        [view addSubview:label];
//        [label release];
        NSString * str = @"领取赠品需要先将商品加入购物车，然后在购物车界面领取";
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:12.0f]
                           constrainedToSize:CGSizeMake(275, 100) 
                               lineBreakMode:UILineBreakModeCharacterWrap];   // str是要显示的字符串
        UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, labelSize.width, labelSize.height)];    
        patternLabel.text = str;
        patternLabel.backgroundColor = [UIColor clearColor];
        patternLabel.font = [UIFont systemFontOfSize:12.0f];
        patternLabel.numberOfLines = 0;     // 不可少Label属性之一
        patternLabel.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
        [view addSubview:patternLabel];
        [patternLabel release];
        
        yValue+=55.0;
    } else if (m_Tag==RECEIVE_GIFT) {//领取赠品
        [m_ScrollView setFrame:CGRectMake(0, 44, 320, 416)];
        [m_TitleLabel setText:@"领取赠品"];
        [m_TitleLeftBtn setBackgroundImage:[UIImage imageNamed:@"title_left_cancel.png"] forState:UIControlStateNormal];
        [m_TitleLeftBtn setBackgroundImage:[UIImage imageNamed:@"title_left_cancel_sel.png"] forState:UIControlStateHighlighted];
        //[m_TitleLeftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [m_TitleRightBtn setHidden:NO];
        yValue+=10.0;
    }
    int i;
    for (i=0; i<[m_GiftArray count]; i++) {
        MobilePromotionVO *mobilePromotionVO=[m_GiftArray objectAtIndex:i];
        int canJoin=[[mobilePromotionVO canJoin] intValue];
        //标题
        NSString *title=[mobilePromotionVO title];
        if (title==nil) {
            title=@"";
        }
        NSString *description=[mobilePromotionVO description];
        if (description==nil) {
            description=@"";
        }
        CGFloat titleWidth=[title sizeWithFont:[UIFont boldSystemFontOfSize:17.0]].width;
        NSInteger titleLines=titleWidth/300.0;
        if (titleWidth/300.0>titleLines) {
            titleLines++;
        }
        CGFloat descriptionWidth=[description sizeWithFont:[UIFont boldSystemFontOfSize:17.0]].width;
        NSInteger descriptionLines=descriptionWidth/300.0;
        if (descriptionWidth/300.0>descriptionLines) {
            descriptionLines++;
        }
        NSInteger totalLines=titleLines+descriptionLines;
        //标题+描述
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, yValue, 300, 20*totalLines)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"%@\n%@",title,description]];
        [label setNumberOfLines:2];
        [label setFont:[UIFont boldSystemFontOfSize:15.0]];
        [label setTextColor:[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0]];
        [m_ScrollView addSubview:label];
        [label release];
        yValue+=20*totalLines;
        //"不可领取"
        if (m_Tag==RECEIVE_GIFT && canJoin==0) {
            label=[[UILabel alloc] initWithFrame:CGRectMake(10, yValue, 300, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"未满足领取条件"];
            [label setFont:[UIFont systemFontOfSize:14.0]];
            [label setTextColor:[UIColor colorWithRed:203.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]];
            [m_ScrollView addSubview:label];
            [label release];
            yValue+=20.0;
        }
        
        CGFloat height=[[mobilePromotionVO productVOList] count]*82.0+15.0;
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
        [tableView setTag:100+i];
        [tableView setScrollEnabled:NO];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setBackgroundView:nil];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [m_ScrollView addSubview:tableView];
        tableView.backgroundView=nil;
        [tableView release];
        yValue+=height+20;
    }
    [m_ScrollView setContentSize:CGSizeMake(320, yValue)];
    //新线程获取商品图片
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetProductImages) toTarget:self withObject:nil];
}

-(void)removeView
{
    CATransition *animation=[CATransition animation]; 
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    if (m_Tag==VIEW_GIFT) {
        [animation setType:kCATransitionPush];
        [animation setSubtype: kCATransitionFromLeft];
    } else if (m_Tag==RECEIVE_GIFT) {
        [animation setType:kCATransitionReveal];
        [animation setSubtype: kCATransitionFromBottom];
    }
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
    
    [self removeSelf];
}

//取消
-(IBAction)cancelBtnClicked:(id)sender
{
    [self removeView];
}

//选择的赠品是否改变
-(BOOL)selectedGiftChanged
{
    BOOL giftChanged=NO;
    if ([m_UserSelectedGiftArray count]!=[m_SelectedGiftArray count]) {
        giftChanged=YES;
    } else {
        int i;
        for (i=0; i<[m_SelectedGiftArray count]; i++) {
            NSMutableDictionary *selDictionary=[m_SelectedGiftArray objectAtIndex:i];
            ProductVO *selProduct=[selDictionary objectForKey:@"productVO"];
            int selProductId=[[selProduct productId] intValue];
            BOOL hasSelProduct=NO;
            int j;
            for (j=0; j<[m_UserSelectedGiftArray count]; j++) {
                NSMutableDictionary *mDictionary=[m_UserSelectedGiftArray objectAtIndex:j];
                ProductVO *productVO=[mDictionary objectForKey:@"productVO"];
                int productId=[[productVO productId] intValue];
                if (productId==selProductId) {
                    hasSelProduct=YES;
                    break;
                }
            }
            if (!hasSelProduct) {
                giftChanged=YES;
                break;
            }
        }
    }
    return giftChanged;
}

//完成
-(IBAction)finishBtnClicked:(id)sender
{
    if (![self selectedGiftChanged]) {//选择的赠品没变
        [self removeView];
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowShowLoading" object:[NSNumber numberWithBool:YES]];
        [self showLoading:YES];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadReceiveGift) toTarget:self withObject:NO];
    }
}

//刷新tableview
-(void)updateTableView:(id)object
{
    NSNumber *indexNum=object;
    int index=[indexNum intValue];
    UITableView *tableView=(UITableView *)[m_ScrollView viewWithTag:100+index];
    [tableView reloadData];
}

-(void)deleteSelectedProduct:(ProductVO *)theProductVO
{
    int i;
    for (i=0; i<[m_SelectedGiftArray count]; ) {
        NSMutableDictionary *mDictionary=[m_SelectedGiftArray objectAtIndex:i];
        ProductVO *productVO=[mDictionary objectForKey:@"productVO"];
        if ([[productVO productId] intValue]==[[theProductVO productId] intValue]) {
            [m_SelectedGiftArray removeObjectAtIndex:i];
        } else {
            i++;
        }
    }
}

-(BOOL)hasSelectedProduct:(ProductVO *)theProductVO
{
    BOOL hasProduct=NO;
    int i;
    for (i=0; i<[m_SelectedGiftArray count]; i++) {
        NSMutableDictionary *mDictionary=[m_SelectedGiftArray objectAtIndex:i];
        ProductVO *productVO=[mDictionary objectForKey:@"productVO"];
        if ([[productVO productId] intValue]==[[theProductVO productId] intValue]) {
            hasProduct=YES;
            break;
        }
    }
    return hasProduct;
}

-(void)addSelectedProduct:(ProductVO *)theProductVO
{
    BOOL hasProduct=[self hasSelectedProduct:theProductVO];
    if (!hasProduct) {
        NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
        [mDictionary setObject:theProductVO forKey:@"productVO"];
        [m_SelectedGiftArray addObject:mDictionary];
        [mDictionary release];
    }
}

-(void)showReceiveGiftResult:(NSNumber *)result
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
    [self hideLoading];
    if ([result intValue]!=1) {
        [AlertView showAlertView:nil alertMsg:@"领取赠品失败" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cartload" object:nil];
        [self removeView];
    }
}

#pragma mark    新线程获取赠品图片
-(void)newThreadGetProductImages
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    NSArray *tempArray=[[NSArray alloc] initWithArray:m_GiftArray];
    int i;
    for (i=0;i<[tempArray count];i++) {
        MobilePromotionVO *mobilePromotionVO=[tempArray objectAtIndex:i];
        for (ProductVO *productVO in [mobilePromotionVO productVOList]) {
            NSURL *url=[NSURL URLWithString:[productVO miniDefaultProductUrl]];
            NSData *data=[NSData dataWithContentsOfURL:url];
            if(data!=nil){
                [DataController writeApplicationData:data name:[NSString stringWithFormat:@"mini_%@",[productVO productId]]];
                [self performSelectorOnMainThread:@selector(updateTableView:) withObject:[NSNumber numberWithInt:i] waitUntilDone:NO];
            }
        }
    }
    [tempArray release];
    [pool drain];
}

-(void)newThreadReceiveGift
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    ProductService *pServ=[[ProductService alloc] init];
	
	NSMutableArray *productIdArray=[[NSMutableArray alloc] init];
	NSMutableArray *promotionIdArray=[[NSMutableArray alloc] init];
    NSMutableArray *merchantIdArray=[[NSMutableArray alloc] init];
    NSMutableArray *quantityArray=[[NSMutableArray alloc] init];
    
	if ([GlobalValue getGlobalValueInstance].token!=nil) {
		int i;
        for (i=0; i<[m_SelectedGiftArray count]; i++) {
            NSMutableDictionary *mDictionary=[m_SelectedGiftArray objectAtIndex:i];
            ProductVO *productVO=[mDictionary objectForKey:@"productVO"];
			[productIdArray addObject:[NSNumber numberWithInt:[productVO.productId intValue]]];
			[promotionIdArray addObject:[NSString stringWithString:productVO.promotionId]];
            [merchantIdArray addObject:[NSNumber numberWithInt:[productVO.merchantId intValue]]];
            [quantityArray addObject:[NSNumber numberWithInt:[productVO.quantity intValue]]];
        }
		int result=[pServ updateGiftProducts:[GlobalValue getGlobalValueInstance].token
                           giftProductIdList:productIdArray
                             promotionIdList:promotionIdArray
                              merchantIdList:merchantIdArray
                                quantityList:quantityArray];
        [self performSelectorOnMainThread:@selector(showReceiveGiftResult:) withObject:[NSNumber numberWithInt:result] waitUntilDone:NO];
	}
    [productIdArray release];
    [promotionIdArray release];
    [merchantIdArray release];
    [quantityArray release];
    [pServ release];
    [pool drain];
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    if (m_Tag==VIEW_GIFT) {//查看赠品
        return;
    }
    //领取赠品
    int index=[tableView tag]-100;
    MobilePromotionVO *mobilePromotionVO=[m_GiftArray objectAtIndex:index];
    ProductVO *productVO=[[mobilePromotionVO productVOList] objectAtIndex:[indexPath row]];
    int canJoin=[[mobilePromotionVO canJoin] intValue];
    if (canJoin==0 || [[productVO isSoldOut] intValue]==1) {//不可领取或赠品已领完
        return;
    }
    
    int i;
    int count=[tableView numberOfRowsInSection:0];
    for (i=0; i<count; i++) {
        if (i!=[indexPath row]) {
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.accessoryType=UITableViewCellAccessoryNone;     
//            //赠品单选代码，屏蔽为多选
//            ProductVO *tmpPV=[[mobilePromotionVO productVOList] objectAtIndex:i];
//            cell.accessoryView = nil;
//            [self deleteSelectedProduct:tmpPV]; 
        }
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryView!=nil) {
        cell.accessoryView=nil;
        [self deleteSelectedProduct:productVO];
    } else {
        cell.accessoryView=[SharedDelegate checkMarkView];
        [self addSelectedProduct:productVO];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int index=[tableView tag]-100;
    MobilePromotionVO *mobilePromotionVO=[m_GiftArray objectAtIndex:index];
    return [[mobilePromotionVO productVOList] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GiftCell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GiftCell"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //图片
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        [imageView setTag:1];
        [cell addSubview:imageView];
        [imageView release];
        //名称
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 195, 48)];
        [label setTag:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:2];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //"原价"
        label=[[UILabel alloc] initWithFrame:CGRectMake(70, 53, 40, 24)];
        [label setText:@"原价:"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //原价
        StrikeThroughLabel *marketPrice=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(110, 53, 85, 24)];
        [marketPrice setTag:3];
        [marketPrice setTextColor:[UIColor colorWithRed:206.0/255.0 green:0 blue:0 alpha:1.0]];
        [marketPrice setBackgroundColor:[UIColor clearColor]];
        [marketPrice setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:marketPrice];
        [marketPrice release];
        //限量
        label=[[UILabel alloc] initWithFrame:CGRectMake(195, 53, 100, 24)];
        [label setTag:4];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //已领完
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(248, 0, 62, 62)];
        [imageView setTag:5];
        [imageView setImage:[UIImage imageNamed:@"gift_nil.png"]];
        [cell addSubview:imageView];
        [imageView release];
        [imageView setHidden:YES];
    }
    
    int index=[tableView tag]-100;
    MobilePromotionVO *mobilePromotionVO=[m_GiftArray objectAtIndex:index];
    ProductVO *productVO=[[mobilePromotionVO productVOList] objectAtIndex:[indexPath row]];
    int canJoin=[[mobilePromotionVO canJoin] intValue];
    BOOL hasSelectedProduct=[self hasSelectedProduct:productVO];
    //图片
    UIImageView *imageView=(UIImageView *)[cell viewWithTag:1];
    NSString *fileName=[NSString stringWithFormat:@"mini_%@",[productVO productId]];
    NSData *data=[DataController applicationDataFromFile:fileName];
    if (data!=nil) {
        UIImage *image=[UIImage imageWithData:data];
        [imageView setImage:image];
    } else {
        [imageView setImage:[UIImage imageNamed:@"defaultimg85.png"]];
    }
    //名称
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:2];
    [nameLabel setText:[productVO cnName]];
    //原价
    //StrikeThroughLabel *marketPrice=(StrikeThroughLabel *)[cell viewWithTag:3];
    //[marketPrice setText:[NSString stringWithFormat:@"￥%.2f",[[productVO maketPrice] floatValue]]];
    
    //限量
    UILabel *countLabel=(UILabel *)[cell viewWithTag:4];
    if ([productVO totalQuantityLimit]==nil) {
        [countLabel setText:[NSString stringWithFormat:@"限量0件"]];
    } else {
        [countLabel setText:[NSString stringWithFormat:@"%@",[productVO totalQuantityLimit]]];
    }
    
    //已领完
    UIImageView *noGiftImage=(UIImageView *)[cell viewWithTag:5];
    
    if (m_Tag==VIEW_GIFT) {//查看赠品
        if ([[productVO isSoldOut] intValue]==1) {//已领完
            [noGiftImage setHidden:NO];
            [nameLabel setFrame:CGRectMake(70, 5, 195, 48)];
            [cell setAlpha:0.5];
            for (UIView *sub in cell.subviews) {
                [sub setAlpha:0.5];
            }
        } else {
            [noGiftImage setHidden:YES];
            [nameLabel setFrame:CGRectMake(70, 5, 210, 48)];
            [cell setAlpha:1.0];
            for (UIView *sub in cell.subviews) {
                [sub setAlpha:1.0];
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
    } else {//领取赠品
        if ([[productVO isSoldOut] intValue]==1) {//已领完
            [noGiftImage setHidden:NO];
            [nameLabel setFrame:CGRectMake(70, 5, 195, 48)];
            [cell setAlpha:0.5];
            for (UIView *sub in cell.subviews) {
                [sub setAlpha:0.5];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
        } else if (canJoin==0) {//不可领取
            [noGiftImage setHidden:YES];
            [nameLabel setFrame:CGRectMake(70, 5, 210, 48)];
            [cell setAlpha:0.5];
            for (UIView *sub in cell.subviews) {
                [sub setAlpha:0.5];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
        } else {
            if (m_UserSelectedGiftArray==nil || [m_UserSelectedGiftArray count]==0) {//没有选中任何赠品
                if ([indexPath row]==0) {
                    //默认选中并加入
                    [self addSelectedProduct:productVO];
                    cell.accessoryView=[SharedDelegate checkMarkView];
                } else {
                    cell.accessoryView=nil;
                }
            } else {//有选中的赠品
                if (hasSelectedProduct) {
                    cell.accessoryView=[SharedDelegate checkMarkView];
                } else {
                    cell.accessoryView=nil;
                }
            }
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        }
    }
    
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82.0;
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}



#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(m_GiftArray);
    OTS_SAFE_RELEASE(m_SelectedGiftArray);
    OTS_SAFE_RELEASE(m_UserSelectedGiftArray);
    
    // release outlet
    OTS_SAFE_RELEASE(m_TitleLabel);
    OTS_SAFE_RELEASE(m_TitleLeftBtn);
    OTS_SAFE_RELEASE(m_TitleRightBtn);
    OTS_SAFE_RELEASE(m_ScrollView);
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
