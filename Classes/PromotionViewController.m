//
//  PromotionViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 12-10-26.
//
//

#import "PromotionViewController.h"
#import "PromotionCell.h"
#import "GlobalValue.h"
#import "AlertView.h"
#import "TheStoreAppAppDelegate.h"
#import "PromotionInfo.h"
#import "GiftInfo.h"
#import "ProductInfo.h"
#import "ConditionInfo.h"
@interface PromotionViewController ()
@end

@implementation PromotionViewController

#pragma mark - View Life
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    if (iPhone5) {
        self.view.frame=CGRectMake(0, 20, 320, 548);
    }else{
        self.view.frame=CGRectMake(0, 20, 320, 460);
    }
    
    [self initTopView];
    [self initTables];
    
    //    [self.loadingView showInView:self.view];
    
    
}

-(void)dealloc
{
    [giftTable release];
    [_giftPromotionList release];
    [_selectedGiftList release];
    [super dealloc];
}



#pragma mark init views
- (void)initTopView{
    UIImageView* nav=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bg.png"]];
    nav.frame=CGRectMake(0, 0, 320, 44);
    nav.userInteractionEnabled=YES;
    [self.view addSubview:nav];
    [nav release];
    
    UIButton*back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 61, 44);
    [back setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(naviBack) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];
    
    UILabel* titLab=[[UILabel alloc] initWithFrame:CGRectMake(60, 2, 200, 40)];
    titLab.text=@"领取赠品";
    titLab.textAlignment=NSTextAlignmentCenter;
    titLab.textColor=[UIColor whiteColor];
    titLab.font=[UIFont boldSystemFontOfSize:20];
    titLab.shadowColor=[UIColor darkGrayColor];
    titLab.backgroundColor=[UIColor clearColor];
    [nav addSubview:titLab];
    [titLab release];
}

-(void)initTables
{

    giftTable=[[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain] retain];
    giftTable.delegate=self;
    giftTable.dataSource=self;
    [self.view addSubview:giftTable];
    giftTable.hidden = NO;
    [giftTable release];
}

-(void)netError
{
    [self.loadingView hide];
    [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil
                    alertTag:ALERTVIEW_TAG_COMMON];
}



#pragma mark UIAction
-(void)naviBack
{
    if (SharedDelegate.m_UpdateCart)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cartload" object:nil];
    }
    [self dismissPromotion];
}
-(void)dismissPromotion{
    CATransition *animation=[CATransition animation];
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:kCATransitionReveal];
    [animation setSubtype: kCATransitionFromBottom];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
    [self removeSelf];
}

- (void)selectGift:(id)sender withEvent:(UIEvent*)event
{
    NSIndexPath *indexPath=[giftTable indexPathForRowAtPoint:[[[event touchesForView:(UIButton *)sender] anyObject] locationInView:giftTable]];//获得NSIndexPath
    NSLog(@"selected index %@",indexPath);
    PromotionInfo *promotion = _giftPromotionList[indexPath.section];
    GiftInfo *gift = promotion.gifts[indexPath.row];
    
    promotion.selectedGiftCount++;
//    [_selectedGiftList addObject:gift];
    [self addGift2List:gift];
    
    [self showShortTip:@"领取成功"];
    
    
    [giftTable reloadData];
    
}


- (void)addGift2List:(GiftInfo *)selectedGift
{
    for (GiftInfo *gift in _selectedGiftList)
    {
        if ([gift.giftId isEqualToString:selectedGift.giftId] && gift.promotionId == selectedGift.promotionId)
        {
            gift.selectedCount++;
            
            return;
        }
    }
    [_selectedGiftList addObject:selectedGift];
    
}

#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _giftPromotionList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PromotionInfo *promotion = _giftPromotionList[section];
    if (promotion.satisfy == 1)
    {
        return promotion.gifts.count;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* giftCell=@"giftcell";
    
    
    PromotionCell*cell=[tableView dequeueReusableCellWithIdentifier:giftCell];
    if (cell==nil)
    {
        cell=[[[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:giftCell] autorelease];
    }
    PromotionInfo *promotion = _giftPromotionList[indexPath.section];
    GiftInfo *gift = promotion.gifts[indexPath.row];
    cell.tittleLabel.text = gift.giftName;
    cell.priceLab.text=[NSString stringWithFormat:@"¥ %.2f", gift.price];
    
//    cell.conditionLab.text=productvo.totalQuantityLimit;
//    if ([self hasSelectedGift:gift])
//    {
//        cell.checkImg.image=[UIImage imageNamed:@"goodReceiver_sel.png"];
//    }
//    else
//    {
//        cell.checkImg.image=[UIImage imageNamed:@"goodReceiver_unsel.png"];
//    }
    
    
    cell.flogyView.hidden=YES;
    cell.notEnough.hidden=YES;
    cell.userInteractionEnabled=YES;
    
    if (gift.quantity == 0)
    {
        [cell hasNoMore];
    }
    [cell productIcon:[gift giftImageStr]];
    
    
    
    for (UIView *view in [cell.contentView subviews])
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    if (gift.quantity != 0)
    {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(250, 25, 50, 26);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"lingqu.png"] forState:UIControlStateNormal];
//        [selectBtn setBackgroundImage:[UIImage imageNamed:@"gray_bg.png"] forState:UIControlStateDisabled];
        [selectBtn addTarget:self action:@selector(selectGift:withEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [selectBtn setTitle:@"领取一件" forState:UIControlStateNormal];
//        [selectBtn setTitle:@"不能再领取" forState:UIControlStateDisabled];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [cell.contentView addSubview:selectBtn];
        
        //已经选择的小于 可选的数量，才可以选择
        if (promotion.satisfy == 1 && promotion.selectedGiftCount < ((ConditionInfo *)promotion.conditions[0]).reward)
        {
            selectBtn.enabled = YES;
        }
        else
        {
            selectBtn.enabled = NO;
        }
        
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//        MobilePromotionVO*mobileProVO=(MobilePromotionVO*)
//        [OTSUtility safeObjectAtIndex:indexPath.section inArray:[CartCache sharedCartCache].giftArCache];
//        ProductVO*productvo=(ProductVO*)[OTSUtility safeObjectAtIndex:indexPath.row inArray:mobileProVO.productVOList];
//        [self addPromotionToCart:productvo type:0];
//
//        SharedDelegate.m_UpdateCart=YES;
//    [self.loadingView showInView:self.view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    v.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cutoff_sectionBG@2x.png"]];
    if (tableView==giftTable)
    {
        PromotionInfo *promotion = _giftPromotionList[section];
        UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 40)];
        title.numberOfLines = 0;
        title.text = [NSString stringWithFormat:@"%@%@",[(ProductInfo *)promotion.productArr[0] name],[promotion.productArr count]>1?@"等":@""];
        title.font=[UIFont systemFontOfSize:16];
        title.backgroundColor=[UIColor clearColor];
        [v addSubview:title];
        [title release];
        
        UILabel* des=[[UILabel alloc] initWithFrame:CGRectMake(10, 40, 310, 40)];
        des.numberOfLines = 0;
        des.text = [NSString stringWithFormat:@"%@%@",promotion.promotionDesc,promotion.promotionResult];
        des.font=[UIFont systemFontOfSize:14];
        des.textColor=[UIColor grayColor];
        des.backgroundColor=[UIColor clearColor];
        [v addSubview:des];
        [des release];

//        if (![mobliePromotionVo.canJoin intValue])
//        {
//            UILabel*join=[[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, 40)];
//            join.text=@"未满足";
//            join.textColor=[UIColor colorWithRed:0.686 green:0.078 blue:0.01 alpha:1];
//            join.textAlignment=NSTextAlignmentRight;
//            join.font=[UIFont systemFontOfSize:14];
//            join.backgroundColor=[UIColor clearColor];
//            [v addSubview:join];
//            [join release];
//        }
    }

    
    return [v autorelease];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}


@end
