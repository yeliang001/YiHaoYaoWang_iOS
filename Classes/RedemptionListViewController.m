//
//  RedemptionListViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-27.
//
//

#import "RedemptionListViewController.h"
#import "PromotionCell.h"
#import "ProductVO.h"
@interface RedemptionListViewController ()

@end

@implementation RedemptionListViewController
@synthesize mobilePromotionVO,delegate,selectedRedemptionArray,fromIndex;
-(void)dealloc{
    [fromIndex release];
    [selectedRedemptionArray release];
    [currentSelectedRedemptionArray release];
    [mobilePromotionVO release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
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
    titLab.text=@"促销活动";
    titLab.textAlignment=NSTextAlignmentCenter;
    titLab.textColor=[UIColor whiteColor];
    titLab.font=[UIFont boldSystemFontOfSize:20];
    titLab.shadowColor=[UIColor darkGrayColor];
    titLab.backgroundColor=[UIColor clearColor];
    [nav addSubview:titLab];
    [titLab release];
}

-(void)naviBack{
//    [delegate didSelectRedemption:currentSelectedRedemptionArray  indexPath:fromIndex];
    [self popSelfAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTopView];
    UITableView* redemptionTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    redemptionTable.delegate=self;
    redemptionTable.dataSource=self;
    [self.view addSubview:redemptionTable];
    [redemptionTable release];
    currentSelectedRedemptionArray=[[NSMutableArray alloc] initWithArray:selectedRedemptionArray];
}


-(void)hasSelectGift:(ProductVO*)productvo InSection:(NSIndexPath*)selectedIndexPath{
    for (ProductVO*proVO in mobilePromotionVO.productVOList) {
        ProductVO*deleteProVo=nil;
        for (NSDictionary* selDic in currentSelectedRedemptionArray) {
            ProductVO*selProVO=[selDic valueForKey:@"productVO"];
            DebugLog(@"%@===%@,%@===%@",proVO.cnName,proVO.promotionId,selProVO.cnName,selProVO.promotionId);
            if ([selProVO.productId longValue]==[proVO.productId longValue]&&[selProVO.promotionId isEqualToString:proVO.promotionId]) {
                deleteProVo=selProVO;
            }
        }
        [self removeSelectedProduct:deleteProVo];
        
    }
}
-(BOOL)hasSelectedProduct:(ProductVO *)theProductVO
{
    BOOL hasProduct=NO;
    int i;
    for (i=0; i<[currentSelectedRedemptionArray count]; i++) {
        NSMutableDictionary *mDictionary=[currentSelectedRedemptionArray objectAtIndex:i];
        ProductVO *productVO=[mDictionary objectForKey:@"productVO"];
        if ([[productVO productId] longValue]==[[theProductVO productId] longValue]&&[productVO.promotionId isEqualToString:theProductVO.promotionId]) {
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
        [currentSelectedRedemptionArray addObject:mDictionary];
        [mDictionary release];
    }
}
-(void)removeSelectedProduct:(ProductVO*)theProductVO{
    NSDictionary* tagDic=nil;
    for (NSDictionary* dic in currentSelectedRedemptionArray) {
        ProductVO*pVo=[dic valueForKey:@"productVO"];
        if ([pVo.productId longValue]==[theProductVO.productId longValue]&&[pVo.promotionId isEqualToString:theProductVO.promotionId]) {
            tagDic=dic;
            break;
        }
    }
    if (tagDic!=nil) {
        [currentSelectedRedemptionArray removeObject:tagDic];
    }
}
#pragma mark --table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return mobilePromotionVO.productVOList.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    v.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cutoff_sectionBG.png"]];
    UILabel*description=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    description.backgroundColor=[UIColor clearColor];
    description.font=[UIFont systemFontOfSize:16];
    description.text=mobilePromotionVO.description;
    [v addSubview:description];
    [description release];
    return [v autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[PromotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    ProductVO*productVO=[mobilePromotionVO.productVOList objectAtIndex:indexPath.row];
    cell.tittleLabel.text=productVO.cnName;
    cell.priceLab.text=[NSString stringWithFormat:@"¥ %@",productVO.promotionPrice];
    //cell.marketPriceLbl.text=[NSString stringWithFormat:@"¥ %@",productVO.maketPrice];
    cell.conditionLab.text=[NSString stringWithFormat:@"%@",productVO.totalQuantityLimit];
    if ([self hasSelectedProduct:productVO]) {
        cell.checkImg.image=[UIImage imageNamed:@"goodReceiver_sel.png"];
    }else{
        cell.checkImg.image=[UIImage imageNamed:@"goodReceiver_unsel.png"];
    }
    
    if ([productVO.isSoldOut intValue]) {
        cell.notEnough.hidden=NO;
        cell.flogyView.hidden=NO;
    }else{
        cell.notEnough.hidden=YES;
        cell.flogyView.hidden=YES;
    }
    if ([mobilePromotionVO.canJoin intValue]==0) {
        cell.notEnough.hidden=YES;
        cell.flogyView.hidden=NO;
        cell.userInteractionEnabled=NO;
    }else{
        if ([productVO.isSoldOut intValue]) {
            cell.notEnough.hidden=NO;
            cell.flogyView.hidden=NO;
            cell.userInteractionEnabled=NO;
        }else{
            cell.notEnough.hidden=YES;
            cell.flogyView.hidden=YES;
            cell.userInteractionEnabled=YES;
        }
    }
    [cell productIcon:productVO.miniDefaultProductUrl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductVO*productvo=(ProductVO*)[mobilePromotionVO.productVOList objectAtIndex:indexPath.row];
//    [delegate didSelectRedemption:currentSelectedRedemptionArray  indexPath:fromIndex];
    [delegate didSelectRedemption:productvo];

//    if ([self hasSelectedProduct:productvo]) {
//        [self removeSelectedProduct:productvo];
//    }else{
//        [self hasSelectGift:productvo InSection:indexPath];
//        [self addSelectedProduct:productvo];
//    }
//    [tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
