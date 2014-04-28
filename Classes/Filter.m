//
//  Filter.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_GET_FILTER            1
#define TABLEVIEW_CELL_HEIGHT               45
#define TABLEVIEW_SECOND_CELL_HEIGHT        45
#define VIEW_TAG_LABEL                      200
#define VIEW_TAG_IMAGEVIEW                  201
#define VIEW_TAG_SECOND_TABLEVIEW           200

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "Filter.h"
#import "GlobalValue.h"
#import "SearchAttributeVO.h"
#import "FacetValue.h"
#import "PriceRange.h"
#import "SearchCategoryVO.h"
#import "TheStoreAppAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ChinesePinYin.h"
#import "SearchService.h"
@interface Filter ()
@property(nonatomic, retain)NSMutableArray* brandSortArr;
@property(nonatomic, retain)NSMutableDictionary* brandDic;
@property(nonatomic, retain)NSArray* brandIndexArr;
@property(nonatomic, retain)NSArray* merchantTypeArr;
-(NSString*)getFirstLetter:(NSString*)str;
@end

@implementation Filter
@synthesize m_SearchResultVO;
@synthesize m_SelectedConditions;
@synthesize m_FromTag;
@synthesize brandSortArr,brandDic,brandIndexArr,merchantTypeArr;


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshFilterView:) name:@"SearchAttributeOK" object:nil];
    if (m_SearchResultVO==nil) {
        [self.loadingView showInView:self.view];
    }else{
        [self freshFilterView:nil];
    }
}

-(void)retryRequest{
    [self performInThreadBlock:^{
        
//        NSNumber* tempBrandId=[m_SelectedConditions objectForKey:@"brandId"];
//        NSString* tempAttr=[m_SelectedConditions objectForKey:@"attributes"];
//        NSString* tempPromotionType=[m_SelectedConditions objectForKey:@"promotionType"];
//        NSString*  tempPriceRange=[m_SelectedConditions objectForKey:@"priceRange"];

        Trader *trader=[GlobalValue getGlobalValueInstance].trader;
        NSNumber *mcsiteId=[NSNumber numberWithInt:1];
        NSNumber *provinceId=[GlobalValue getGlobalValueInstance].provinceId;
//        NSString *keyword=@"";
//        NSNumber *categoryId=[NSNumber numberWithLong:[self.cateId longValue]];
//        NSNumber *brandId = m_BrandId;
//        NSString *attributes  = [m_SelectedConditions objectForKey:@"attributes"];
//        NSString *priceRange  = m_PriceRange;
//        NSString *filter  = m_PromotionType;
//        NSNumber *curSortType=[NSNumber numberWithInt:sortType];
        NSString *token=[GlobalValue getGlobalValueInstance].token;
        
//        SearchParameterVO * serParam = [[[SearchParameterVO alloc]init] autorelease];
//        [serParam setKeyword:keyword];
//        [serParam setCategoryId:categoryId];
//        [serParam setBrandId:brandId];
//        [serParam setAttributes:attributes];
//        [serParam setPriceRange:priceRange];
//        [serParam setFilter:filter];
//        [serParam setSortType:curSortType];
//        [serParam setPromotionId:promotionId];
        
        SearchService* sser=[[SearchService alloc] init];
        if (token != nil && [token isKindOfClass:[NSString class]]) {
            token=@"";
        }
        m_SearchResultVO = [[sser searchAttributesOnly:trader provinceId:provinceId mcsiteid:mcsiteId isDianzhongdian:[NSNumber numberWithInt:0] searchParameterVO:sPrama token:token] retain];
    } completionInMainBlock:^{
        [self.loadingView hide];
        if (m_SearchResultVO==nil) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"网络异常，请检查网络配置..." message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self popSelfAnimated:YES];
}
-(void)freshFilterView:(NSNotification*)notify{
    if (m_SearchResultVO==nil) {
        if ([[notify object] isKindOfClass:[SearchResultVO class]]) {
            m_SearchResultVO=[[notify object] retain];
            [self.loadingView hide];
        }else{
            sPrama=[[notify object] retain];
            [self.loadingView showInView:self.view];
            [self retryRequest];
        }
    }
    [self initFilter];
    [self initSecondView];
    // iphone5适配
    if(iPhone5)
    {
        float offsetY = 5.0;
        CGRect rc = m_ScrollView.frame;
        rc.size.height = self.view.frame.size.height + offsetY ;
        rc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
        m_ScrollView.frame = rc;
        
        CGRect rcTab = m_SecondView.frame;
        rcTab.size.height = self.view.frame.size.height +OTS_IPHONE_NAVI_BAR_HEIGHT + offsetY;
        rcTab.origin.y = 0;
        m_SecondView.frame = rcTab;
    }
}


-(void)initFilter
{
    
//    CGRect theRc = self.view.frame;
//    theRc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
//    m_ScrollView.frame = theRc;
    
    if (m_SearchResultVO==nil) {
        return;
    }
    brandDic = [[NSMutableDictionary alloc]init];
    m_PromotionTypes=[[NSMutableArray alloc] init];
    [m_PromotionTypes addObject:@"有赠品"];
    merchantTypeArr = [[NSArray alloc]initWithObjects:@"1号药店商品",@"1号商城商品", nil];
    if (m_SelectedConditions==nil) {
        m_SelectedConditions=[[NSMutableDictionary alloc] init];
        
    }
    //过滤条件总数量
    m_FilterNum=[[m_SearchResultVO searchAttributes] count]+4;
    
    self.brandSortArr = [NSMutableArray arrayWithArray:[[m_SearchResultVO searchBrandVO] brandChilds]];
    for (FacetValue *facetValue in brandSortArr) {
        NSString* str = facetValue.name;
        NSString* strFirstLetter = [[self getFirstLetter:str]uppercaseString];
        NSMutableArray* arr = [brandDic objectForKey:strFirstLetter];
        if (arr) {
            [arr addObject:facetValue];
        }else{
            NSMutableArray* newArr = [NSMutableArray array];
            [brandDic setObject:newArr forKey:strFirstLetter];
            [newArr addObject:facetValue];
        }
    }
    self.brandIndexArr = [[brandDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    CGFloat yValue=0.0;
    int i;
    for (i=0; i<m_FilterNum; i++) {
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, TABLEVIEW_CELL_HEIGHT+20) style:UITableViewStyleGrouped];
        [tableView setTag:100+i];
        [tableView setScrollEnabled:NO];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setBackgroundView:nil];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [m_ScrollView addSubview:tableView];
        [tableView release];
        yValue+=TABLEVIEW_CELL_HEIGHT+20;
        tableView.backgroundView=nil;
    }
    //重置筛选条件按钮
    yValue+=20.0;
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(200, yValue, 110, 35)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
    [button setTitle:@"重置筛选条件" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
    [button setTag:150];
    [button addTarget:self action:@selector(resetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [m_ScrollView addSubview:button];
    [button release];
    
    [m_ScrollView setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    if (iPhone5)
    {
        [m_ScrollView setContentSize:CGSizeMake(320, yValue+90)];
    }
    else
    {
        [m_ScrollView setContentSize:CGSizeMake(320, yValue+50)];
    }
}

-(void)initSecondView
{
    [m_SecondTableView setTag:VIEW_TAG_SECOND_TABLEVIEW];
}

-(void)removeView
{
    CATransition *animation=[CATransition animation];
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromBottom];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
    
    [self removeSelf];
}

-(IBAction)cancelBtnClicked:(id)sender
{
    [self removeView];
}

-(IBAction)finishBtnClicked:(id)sender
{
    NSMutableString *attributesStr=[[NSMutableString alloc] init];
    int brandIndex=0;
    int i;
    for (i=0; i<m_FilterNum; i++)
    {
        UITableView *tableView=(UITableView *)[m_ScrollView viewWithTag:100+i];
        UILabel *label=(UILabel *)[tableView viewWithTag:VIEW_TAG_LABEL];
         if (i>brandIndex && i<m_FilterNum-3)
         {//导购属性
            if ([label text]==nil || [[label text] isEqualToString:@""])
            {
            }
            else
            {
                SearchAttributeVO *searchAttributeVO=[[m_SearchResultVO searchAttributes] objectAtIndex:i-brandIndex-1];
                for (FacetValue *facetValue in [searchAttributeVO attrChilds])
                {
                    if ([[facetValue name] isEqualToString:[label text]])
                    {
                        [attributesStr appendFormat:@"%@,",[facetValue nid]];
                        break;
                    }
                }
            }
        }
    }
    
    if ([attributesStr length]>0) {
        [attributesStr deleteCharactersInRange:NSMakeRange([attributesStr length]-1, 1)];
        [m_SelectedConditions setValue:attributesStr forKey:@"attributes"];
    } else {
        [m_SelectedConditions setValue:@"" forKey:@"attributes"];
    }
    
    DebugLog(@"========%@",m_SelectedConditions);
    
    if (m_FromTag==FROM_SEARCH) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SearchFilterConditionChanged" object:m_SelectedConditions];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryFilterConditionChanged" object:m_SelectedConditions];
	}
    [attributesStr release];
    
    [self removeView];
}

-(void)addSecondView
{
    if (m_SecondView!=nil) {
        CATransition *animation=[CATransition animation];
        [animation setDuration:0.3f];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:kCATransitionPush];
        [animation setSubtype: kCATransitionFromRight];
        [self.view.layer addAnimation:animation forKey:@"Reveal"];
        
        [self.view addSubview:m_SecondView];
    }
}

-(void)removeSecondView
{
    if (m_SecondView!=nil) {
        CATransition *animation=[CATransition animation];
        [animation setDuration:0.3f];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:kCATransitionPush];
        [animation setSubtype: kCATransitionFromLeft];
        [self.view.layer addAnimation:animation forKey:@"Reveal"];
        
        [m_SecondView removeFromSuperview];
    }
}

-(IBAction)secondReturnBtnClicked:(id)sender
{
    [self removeSecondView];
}
-(NSString*)getFirstLetter:(NSString*)str{
    if ([[str substringToIndex:1] canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语
        return [str substringToIndex:1];
    }
    else { //如果是非英语
        DebugLog(@"the first word is:%@",[str substringToIndex:1]);
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([str characterAtIndex:0])];
    }
}
-(void)resetBtnClicked:(id)sender
{
    if (m_SelectedConditions!=nil) {
        [m_SelectedConditions release];
    }
    m_SelectedConditions=[[NSMutableDictionary alloc] init];
    int i;
    for (i=0; i<m_FilterNum; i++) {
        UITableView *tableView=(UITableView *)[m_ScrollView viewWithTag:100+i];
        [tableView reloadData];
    }
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int brandIndex=0;
    if ([tableView tag]==VIEW_TAG_SECOND_TABLEVIEW) {
        NSString *selectedString = nil;
        if ([indexPath row]==0 && [indexPath section] == 0) {
            selectedString=@"";
            if (m_CurrentTableIndex==brandIndex) {//品牌
                [m_SelectedConditions setValue:[NSNumber numberWithInt:0] forKey:@"brandId"];
                [m_SelectedConditions setValue:@"" forKey:@"brandShow"];
            } else if (m_CurrentTableIndex==m_FilterNum-3) {//价格区间
                [m_SelectedConditions setValue:@"" forKey:@"priceRangeShow"];
                [m_SelectedConditions setValue:@"" forKey:@"priceRange"];
            } else if (m_CurrentTableIndex==m_FilterNum-2) {//促销类型
                [m_SelectedConditions setValue:@"" forKey:@"promotionTypeShow"];
                [m_SelectedConditions setValue:@"0" forKey:@"promotionType"];
            }else if (m_CurrentTableIndex==m_FilterNum-1) {//商家类型
                [m_SelectedConditions setValue:@"" forKey:@"merchantTypeShow"];
                [m_SelectedConditions setValue:@"0" forKey:@"merchantType"];
            }
            else if (m_CurrentTableIndex>brandIndex && m_CurrentTableIndex<m_FilterNum-1) {//导购属性
                [m_SelectedConditions setValue:@"" forKey:[NSString stringWithFormat:@"attribute%d",m_CurrentTableIndex]];
            }
        } else {
            if (m_CurrentTableIndex==brandIndex) {//品牌
                NSMutableArray* arr = [brandDic objectForKey:[brandIndexArr objectAtIndex:[indexPath section]-1]];
                FacetValue *facetValue=[arr objectAtIndex:[indexPath row]];
                //FacetValue *facetValue=[m_SecondArray objectAtIndex:[indexPath row]-1];
                selectedString=[facetValue name];
                [m_SelectedConditions setValue:[facetValue nid] forKey:@"brandId"];
                [m_SelectedConditions setValue:[facetValue name] forKey:@"brandShow"];
            } else if (m_CurrentTableIndex==m_FilterNum-3) {//价格区间
                PriceRange *priceRange=[m_SecondArray objectAtIndex:[indexPath row]-1];
                if ([priceRange end]==nil || [[priceRange end] floatValue]>100000000) {
                    selectedString=[NSString stringWithFormat:@"%@以上",[priceRange start]];
                } else {
                    selectedString=[NSString stringWithFormat:@"%@-%@",[priceRange start],[priceRange end]];
                }
                [m_SelectedConditions setValue:selectedString forKey:@"priceRangeShow"];
                NSString *priceRangeStr=[NSString stringWithFormat:@"%@,%@",[priceRange start],[priceRange end]];
                [m_SelectedConditions setValue:priceRangeStr forKey:@"priceRange"];
            } else if (m_CurrentTableIndex==m_FilterNum-2) {//促销类型
                selectedString=[m_SecondArray objectAtIndex:[indexPath row]-1];
                [m_SelectedConditions setValue:@"有赠品" forKey:@"promotionTypeShow"];
                [m_SelectedConditions setValue:@"02" forKey:@"promotionType"];
            }else if (m_CurrentTableIndex==m_FilterNum-1) {//商家类型
                selectedString=[m_SecondArray objectAtIndex:[indexPath row]-1];
                [m_SelectedConditions setValue:selectedString forKey:@"merchantTypeShow"];
                if ([selectedString isEqualToString:@"1号商城商品"]) {
                    [m_SelectedConditions setValue:[NSNumber numberWithInt:1] forKey:@"merchantType"];
                }else{
                    [m_SelectedConditions setValue:[NSNumber numberWithInt:2] forKey:@"merchantType"];
                }
            }
            else if (m_CurrentTableIndex>brandIndex && m_CurrentTableIndex<m_FilterNum-1) {//导购属性
                FacetValue *facetValue=[m_SecondArray objectAtIndex:[indexPath row]-1];
                selectedString=[facetValue name];
                [m_SelectedConditions setValue:[facetValue name] forKey:[NSString stringWithFormat:@"attribute%d",m_CurrentTableIndex]];
            }
        }
        UITableView *tableView=(UITableView *)[m_ScrollView viewWithTag:m_CurrentTableIndex+100];
        UILabel *label=(UILabel *)[tableView viewWithTag:VIEW_TAG_LABEL];
        [label setText:selectedString];
        
        [self removeSecondView];
        return;
    } else {
        m_CurrentTableIndex=[tableView tag]-100;
        if (m_CurrentTableIndex==brandIndex) {//品牌
            m_SecondArray=[[m_SearchResultVO searchBrandVO] brandChilds];
            [m_SecondTitle setText:@"品牌"];
        } else if (m_CurrentTableIndex==m_FilterNum-3) {//价格区间
            m_SecondArray=[[m_SearchResultVO searchPriceVO] childs];
            [m_SecondTitle setText:@"价格"];
        } else if (m_CurrentTableIndex==m_FilterNum-2) {//促销类型
            m_SecondArray=m_PromotionTypes;
            [m_SecondTitle setText:@"促销类型"];
        }else if (m_CurrentTableIndex==m_FilterNum-1) {//商家类型
            m_SecondArray=merchantTypeArr;
            [m_SecondTitle setText:@"商家类型"];
        }
        else if (m_CurrentTableIndex>brandIndex && m_CurrentTableIndex<m_FilterNum-1) {//导购属性
            SearchAttributeVO *searchAttributeVO=[[m_SearchResultVO searchAttributes] objectAtIndex:m_CurrentTableIndex-brandIndex-1];
            m_SecondArray=[searchAttributeVO attrChilds];
            [m_SecondTitle setText:[searchAttributeVO attrName]];
        }
        
        if(iPhone5)
            [m_SecondTableView setContentSize:CGSizeMake(320, TABLEVIEW_SECOND_CELL_HEIGHT*([m_SecondArray count]+41))];
        else
            [m_SecondTableView setContentSize:CGSizeMake(320, TABLEVIEW_SECOND_CELL_HEIGHT*([m_SecondArray count]+1))];
        [m_SecondTableView reloadData];
        [self addSecondView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView tag]==VIEW_TAG_SECOND_TABLEVIEW) {
        if (m_CurrentTableIndex == 0) {
            if (section == 0) {
                return 1;
            }
            NSMutableArray* arr = [brandDic objectForKey:[brandIndexArr objectAtIndex:section-1]];
            return arr.count;
        }else
            if (m_SecondArray==nil) {
                return 1;
            } else {
                return [m_SecondArray count]+1;
            }
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int brandIndex=0;
	if ([tableView tag]==VIEW_TAG_SECOND_TABLEVIEW) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SecondFilterCell"];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondFilterCell"] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            
            //选中的勾号
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(320-13-40, (TABLEVIEW_SECOND_CELL_HEIGHT-14)/2, 13, 14)];
            [imageView setTag:VIEW_TAG_IMAGEVIEW];
            [imageView setImage:[UIImage imageNamed:@"filter_tick.png"]];
            [imageView setHidden:YES];
            [cell addSubview:imageView];
            [imageView release];
            
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        NSString *keyWord=nil;
        if ([indexPath row]==0 && [indexPath section]==0) {
            keyWord=@"全部";
            [[cell textLabel] setText:keyWord];
        } else {
            if (m_CurrentTableIndex==m_FilterNum-3) {//价格区间
                PriceRange *priceRange=[m_SecondArray objectAtIndex:[indexPath row]-1];
                if ([priceRange end]==nil || [[priceRange end] floatValue]>100000000) {
                    keyWord=[NSString stringWithFormat:@"%@以上",[priceRange start]];
                } else {
                    keyWord=[NSString stringWithFormat:@"%@-%@",[priceRange start],[priceRange end]];
                }
                [[cell textLabel] setText:keyWord];
            } else if (m_CurrentTableIndex==m_FilterNum-2) {//促销类型
                keyWord=@"有赠品";
                [[cell textLabel] setText:@"有赠品"];
            }else if (m_CurrentTableIndex==m_FilterNum-1) {//商家类型
                if ([indexPath row] == 1) {
                    keyWord=@"1号药店商品";
                    [[cell textLabel] setText:@"1号药店商品"];
                }else if([indexPath row] == 2){
                    keyWord=@"1号商城商品";
                    [[cell textLabel] setText:@"1号商城商品"];
                }
            }
            else if(m_CurrentTableIndex==0){ // 品牌
                
                NSMutableArray* arr = [brandDic objectForKey:[brandIndexArr objectAtIndex:[indexPath section]-1]];
                FacetValue *facetValue=[arr objectAtIndex:[indexPath row]];
                //cell.textLabel.text = [[arr sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:[indexPath row]];
                keyWord=[facetValue name];
                [[cell textLabel] setText:[NSString stringWithFormat:@"%@（%@）",[facetValue name],[facetValue num]]];
                
            }else {//导购属性
                FacetValue *facetValue=[m_SecondArray objectAtIndex:[indexPath row]-1];
                keyWord=[facetValue name];
                [[cell textLabel] setText:[NSString stringWithFormat:@"%@（%@）",[facetValue name],[facetValue num]]];
            }
        }
        
        //用户选择的用勾号标识
        UIImageView *imageView=(UIImageView *)[cell viewWithTag:VIEW_TAG_IMAGEVIEW];
        NSString *selectedStr=nil;
        if (m_CurrentTableIndex==brandIndex) {//品牌
            NSString *brandName=[m_SelectedConditions valueForKey:@"brandShow"];
            if (brandName!=nil && ![brandName isEqualToString:@""]) {
                selectedStr=brandName;
            } else {
                selectedStr=@"全部";
            }
        } else if (m_CurrentTableIndex==m_FilterNum-3) {//价格区间
            NSString *priceRangeShow=[m_SelectedConditions valueForKey:@"priceRangeShow"];
            if (priceRangeShow!=nil && ![priceRangeShow isEqualToString:@""]) {
                selectedStr=priceRangeShow;
            } else {
                selectedStr=@"全部";
            }
        } else if (m_CurrentTableIndex==m_FilterNum-2) {//促销类型
            NSString *promotionTypeShow=[m_SelectedConditions valueForKey:@"promotionTypeShow"];
            if (promotionTypeShow!=nil && ![promotionTypeShow isEqualToString:@""]) {
                selectedStr=promotionTypeShow;
            } else {
                selectedStr=@"全部";
            }
        }else if (m_CurrentTableIndex==m_FilterNum-1) {//商家类型
            NSString *merchantTypeShow=[m_SelectedConditions valueForKey:@"merchantTypeShow"];
            if (merchantTypeShow!=nil && ![merchantTypeShow isEqualToString:@""]) {
                selectedStr=merchantTypeShow;
            } else {
                selectedStr=@"全部";
            }
        }
        else {//导购属性
            NSString *attributeShow=[m_SelectedConditions valueForKey:[NSString stringWithFormat:@"attribute%d",m_CurrentTableIndex]];
            if (attributeShow!=nil && ![attributeShow isEqualToString:@""]) {
                selectedStr=attributeShow;
            } else {
                selectedStr=@"全部";
            }
        }
        if ([keyWord isEqualToString:selectedStr]) {
            [imageView setHidden:NO];
        } else {
            [imageView setHidden:YES];
        }
        
        return cell;
    } else {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(120, 0, 150, TABLEVIEW_CELL_HEIGHT)];
            [label setTag:VIEW_TAG_LABEL];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setFont:[UIFont systemFontOfSize:14.0]];
            [label setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:label];
            [label release];
        }
        
        if (m_SearchResultVO==nil) {
            return cell;
        }
        
        //筛选条件名称和用户选择的筛选条件
        NSString *selectedStr=nil;
        int tableIndex=[tableView tag]-100;
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:16.0]];
        if (tableIndex==brandIndex) {//品牌
            [[cell textLabel] setText:@"品牌"];
            
            NSString *brandName=[m_SelectedConditions valueForKey:@"brandShow"];
            if (brandName!=nil && ![brandName isEqualToString:@""]) {
                selectedStr=brandName;
            } else {
                selectedStr=@"";
            }
        } else if (tableIndex==m_FilterNum-3) {//价格区间
            [[cell textLabel] setText:@"价格"];
            
            NSString *priceRangeShow=[m_SelectedConditions valueForKey:@"priceRangeShow"];
            if (priceRangeShow!=nil && ![priceRangeShow isEqualToString:@""]) {
                selectedStr=priceRangeShow;
            } else {
                selectedStr=@"";
            }
        } else if (tableIndex==m_FilterNum-2) {//促销类型
            [[cell textLabel] setText:@"促销类型"];
            
            NSString *promotionTypeShow=[m_SelectedConditions valueForKey:@"promotionTypeShow"];
            if (promotionTypeShow!=nil && ![promotionTypeShow isEqualToString:@""]) {
                selectedStr=promotionTypeShow;
            } else {
                selectedStr=@"";
            }
        }else if (tableIndex==m_FilterNum-1) {//商家类型
            [[cell textLabel] setText:@"商家类型"];
            
            NSString *merchantTypeShow=[m_SelectedConditions valueForKey:@"merchantTypeShow"];
            if (merchantTypeShow!=nil && ![merchantTypeShow isEqualToString:@""]) {
                selectedStr=merchantTypeShow;
            } else {
                selectedStr=@"";
            }
        }
        else {//导购属性
            SearchAttributeVO *searchAttributeVO=[[m_SearchResultVO searchAttributes] objectAtIndex:tableIndex-brandIndex-1];
            [[cell textLabel] setText:[searchAttributeVO attrName]];
            
            NSString *attributeShow=[m_SelectedConditions valueForKey:[NSString stringWithFormat:@"attribute%d",tableIndex]];
            if (attributeShow!=nil && ![attributeShow isEqualToString:@""]) {
                selectedStr=attributeShow;
            } else {
                selectedStr=@"";
            }
        }
        UILabel *label=(UILabel *)[cell viewWithTag:VIEW_TAG_LABEL];
        [label setText:selectedStr];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView tag]==VIEW_TAG_SECOND_TABLEVIEW) {
        return TABLEVIEW_SECOND_CELL_HEIGHT;
    } else {
        return TABLEVIEW_CELL_HEIGHT;
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView.tag == VIEW_TAG_SECOND_TABLEVIEW) {
        if (m_CurrentTableIndex == 0) {
            return brandIndexArr;
            //return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
        }
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index+1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == VIEW_TAG_SECOND_TABLEVIEW) {
        if (m_CurrentTableIndex == 0 && section!=0) {
            return [brandIndexArr objectAtIndex:(section-1)];
        }
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == VIEW_TAG_SECOND_TABLEVIEW) {
        if (m_CurrentTableIndex == 0) {
            return brandIndexArr.count+1;
        }
    }
    return 1;
}
//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(m_PromotionTypes);
    OTS_SAFE_RELEASE(m_SearchResultVO);
    OTS_SAFE_RELEASE(m_SelectedConditions);
    
    // release outlet
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_SecondView);
    OTS_SAFE_RELEASE(m_SecondTableView);
    OTS_SAFE_RELEASE(m_SecondRtnBtn);
    OTS_SAFE_RELEASE(m_SecondTitle);
    OTS_SAFE_RELEASE(brandIndexArr);
    OTS_SAFE_RELEASE(brandDic);
    OTS_SAFE_RELEASE(brandSortArr);
    OTS_SAFE_RELEASE(merchantTypeArr);
    
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
