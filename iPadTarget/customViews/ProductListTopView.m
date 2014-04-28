//
//  ProductListTopView.m
//  yhd
//
//  Created by  xuexiang on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductListTopView.h"
#import "ProductListViewController.h"
#import "DataHandler.h"

#define kProCateTableViewTag 201
#define kProCateTableView2Tag 202
#define kProCate1TableViewTag 203
#define kProCate2TableViewTag 204
#define kProCate1ToCate2BgView 205

#define kSelectedCate1 210
#define kSelectedCate2 211
#define kSelectedCate1ToCate2 212

#define CateTableViewTextColor [UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1.0]

@interface ProductListTopView ()

//@property(nonatomic, retain)UIImageView* cateTableViewBgView;
@property(nonatomic, retain)UITableView* cateTableView;
@property(nonatomic, retain)NSMutableArray* categories;
@property(nonatomic)EOtsProductTopviewType type;
@property(nonatomic, retain)UIView *cateDetailView;
@property(nonatomic, retain)NSMutableDictionary *cate2Dic;
@property(nonatomic, retain)DataHandler* dataHandler;
@property(nonatomic, retain)UIView *cateView;

@property(nonatomic, retain)CategoryVO *currentCate2;
@property(nonatomic, retain)NSMutableArray* cate1Array;
@property(nonatomic, retain)NSMutableArray* cate2Array;
@property(nonatomic, assign)NSInteger selectedCate;
@property(nonatomic, assign)NSUInteger selectedCate2Index;
@property(nonatomic, retain)UITableView* cate1Table;
@property(nonatomic, retain)UITableView* cate2Table;
@property(nonatomic, retain)UIView* popBgView;
@property(nonatomic, retain)UIView* cateBtnBgView;

@property(nonatomic, retain)UIButton *cate1But;
@property(nonatomic, retain)UIButton *cate2But;

@end

@implementation ProductListTopView
@synthesize cate1,cate2,cate3,cateid,currentCate2,type,listData,rootViewController;
@synthesize cateTableViewBgView,cateTableView,cateDetailView,cateView,cate1But,cate2But;
@synthesize categories,cate2Dic,dataHandler;
@synthesize cate1Array, cate2Array ,selectedCate,cate1Table,cate2Table,selectedCate2Index;
@synthesize popBgView = _popBgView,searchLabel,activityTitle,cateBtnBgView;

#pragma mark -
- (id)initWithFrame:(CGRect)frame // 继续支持老的使用方式
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"proli_topbg.png"]];
    }
    return self;
}
- (void)fitTheUI{
    dataHandler = [DataHandler sharedDataHandler];
    self.cate2Dic=[NSMutableDictionary dictionaryWithCapacity:1];
    self.cateBtnBgView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 512, 42)]autorelease];
    [cateBtnBgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:cateBtnBgView];
    if (type==kProductTopviewTypeSearch) {
        if (searchLabel!=nil) {
            [searchLabel release];
        }
        searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 285,40) ];
        searchLabel.textColor = kBlackColor;
        [searchLabel setTag:SearchLabelTag];
        searchLabel.backgroundColor=[UIColor clearColor];
        searchLabel.text=@"共搜索到--个商品";
        [cateBtnBgView addSubview:searchLabel];
    }else if(type==kProductTopviewTypePromotion) {
        if (searchLabel!=nil) {
            [searchLabel release];
        }
        searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 285,40) ];
        searchLabel.textColor = kBlackColor;
        searchLabel.backgroundColor=[UIColor clearColor];
        searchLabel.text= @"促销精选";
        [cateBtnBgView addSubview:searchLabel];
        return;
    }
    else if(type==kProductTopviewTypePage) {
        if (searchLabel!=nil) {
            [searchLabel release];
        }
        searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 285,40) ];
        searchLabel.textColor = kBlackColor;
        searchLabel.backgroundColor=[UIColor clearColor];
        searchLabel.text=activityTitle;
        [cateBtnBgView addSubview:searchLabel];
        return;
    }else if(type==kProductTopviewTypeHistory) {
        if (searchLabel!=nil) {
            [searchLabel release];
        }
        searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 285,40) ];
        searchLabel.textColor = kBlackColor;
        searchLabel.backgroundColor=[UIColor clearColor];
        searchLabel.text= @"浏览历史";
        [cateBtnBgView addSubview:searchLabel];
        return;
    }else if (type == kProductTopviewTypeOrderProducts){
        if (searchLabel!=nil) {
            [searchLabel release];
        }
        searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 285,40) ];
        searchLabel.textColor = kBlackColor;
        searchLabel.backgroundColor=[UIColor clearColor];
        searchLabel.text= @"订单商品";
        [cateBtnBgView addSubview:searchLabel];
    }
    else{
        if (listData) {
            UIButton *cateAllBut=[UIButton buttonWithType:UIButtonTypeCustom];
            cateAllBut.titleLabel.lineBreakMode=UILineBreakModeClip;
            cateAllBut.titleLabel.font=[cateAllBut.titleLabel.font fontWithSize:kCateButFontSize];
            [cateAllBut setBackgroundImage:[UIImage imageNamed:@"category_ProListTop.png"] forState:UIControlStateNormal];
            [cateAllBut setTitleColor:kBlackColor forState:UIControlStateNormal];
            [cateAllBut addTarget:self action:@selector(cateAll:) forControlEvents:UIControlEventTouchUpInside];
            [cateAllBut setFrame:CGRectMake(0, 0, 86,41)];
            [cateBtnBgView addSubview:cateAllBut];
        }
        if (cate3) {
            UIButton *cate3But=[UIButton buttonWithType:UIButtonTypeCustom];
            cate3But.titleLabel.lineBreakMode=UILineBreakModeClip;
            [cate3But setTitle:cate3.categoryName  forState:UIControlStateNormal];
            [cate3But setTitleColor:kBlackColor forState:UIControlStateNormal];
            [cate3But setTitleColor:kRedColor forState:UIControlStateSelected];
            cate3But.titleLabel.font=[cate3But.titleLabel.font fontWithSize:kCateButFontSize];
            
            //[cate3But addTarget:self action:@selector(cate3:) forControlEvents:UIControlEventTouchUpInside];
            [cate3But setFrame:CGRectMake(297, 0,125,42)];
            [cateBtnBgView addSubview:cate3But];
            if (cate3.nid==cateid) {
                cate3But.selected=YES;
            }
            UIImageView *jian3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"proli_topjian.png"]];
            jian3.frame=CGRectMake(400, 0, 20, 42);
            [cateBtnBgView addSubview:jian3];
            [jian3 release];
        }
        
        if (cate2) {
            self.cate2But=[UIButton buttonWithType:UIButtonTypeCustom];
            cate2But.titleLabel.lineBreakMode=UILineBreakModeClip;
            NSString* titleStr;
            if (cate2.categoryName.length > 4) {
                titleStr = [cate2.categoryName substringToIndex:4];
            }else{
                titleStr = cate2.categoryName;
            }
            [cate2But setTitle:titleStr  forState:UIControlStateNormal];
            [cate2But setTitleColor:kBlackColor forState:UIControlStateNormal];
            [cate2But setTitleColor:kRedColor forState:UIControlStateSelected];
            cate2But.titleLabel.font=[cate2But.titleLabel.font fontWithSize:kCateButFontSize];
            [cate2But addTarget:self action:@selector(cate2:) forControlEvents:UIControlEventTouchUpInside];
            [cate2But setFrame:CGRectMake(192, 0, 125,42)];
            [cate2But setBackgroundImage:[[UIImage imageNamed:@"bread_up"] stretchableImageWithLeftCapWidth:20 topCapHeight:42] forState:UIControlStateNormal];
            [cate2But setBackgroundImage:[[UIImage imageNamed:@"bread"] stretchableImageWithLeftCapWidth:20 topCapHeight:42] forState:UIControlStateSelected];
            [cate2But setBackgroundImage:[[UIImage imageNamed:@"bread"] stretchableImageWithLeftCapWidth:20 topCapHeight:42] forState:UIControlStateHighlighted];
            [cateBtnBgView addSubview:cate2But];
            if (cate2.nid==cateid) {
                cate2But.selected=YES;
            }
        }
        if (cate1) {
            self.cate1But=[UIButton buttonWithType:UIButtonTypeCustom];
            
            cate1But.titleLabel.lineBreakMode=UILineBreakModeClip;
            NSString* titleStr;
            if (cate1.categoryName.length > 4) {
                titleStr = [cate1.categoryName substringToIndex:4];
            }else{
                titleStr = cate1.categoryName;
            }
            [cate1But setTitle:titleStr  forState:UIControlStateNormal];
            [cate1But setTitleColor:kBlackColor forState:UIControlStateNormal];
            [cate1But setTitleColor:kRedColor forState:UIControlStateSelected];
            cate1But.titleLabel.font=[cate1But.titleLabel.font fontWithSize:kCateButFontSize];
            [cate1But addTarget:self action:@selector(cate1:) forControlEvents:UIControlEventTouchUpInside];
            [cate1But setFrame:CGRectMake(87, 0, 125,42)];
            [cate1But setBackgroundImage:[[UIImage imageNamed:@"bread_up"] stretchableImageWithLeftCapWidth:20 topCapHeight:42] forState:UIControlStateNormal];
            [cate1But setBackgroundImage:[[UIImage imageNamed:@"bread"] stretchableImageWithLeftCapWidth:20 topCapHeight:42] forState:UIControlStateSelected];
            [cate1But setBackgroundImage:[[UIImage imageNamed:@"bread"] stretchableImageWithLeftCapWidth:20 topCapHeight:42] forState:UIControlStateHighlighted];
            [cate1But setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            [cateBtnBgView addSubview:cate1But];
            if (cate1.nid==cateid) {
                cate1But.selected=YES;
            }
        }
    }
}
- (id)initWithFrame:(CGRect)frame type:(EOtsProductTopviewType)atype{ // 包含了分类星系的初始化方式，目前只有在分类和商品详情两种情况
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"proli_topbg.png"]];
        self.type = atype;
    }
    return self;
}
#pragma mark -
#pragma mark 面包屑
-(void)ClosePopview{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade;
    [_popBgView.superview.layer addAnimation:transition forKey:@"fadeOut"];
    [_popBgView removeFromSuperview];
    [cate1But setSelected:NO];
    [cate2But setSelected:NO];
    self.cate1Table = nil;
    self.cate2Table = nil;
}
-(void)showCateView{
    if (_popBgView.superview == nil) {
        // 显示分为3种情况，1.单独显示2级分类，2.单独显示3级分类，3.从2级分类到3级分类
        _popBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, 1024, 713)];
        [_popBgView setBackgroundColor:[UIColor clearColor]];
        
        UIButton* bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1024, 713)];
        [bgBtn setBackgroundColor:[UIColor clearColor]];
        [bgBtn addTarget:self action:@selector(ClosePopview) forControlEvents:UIControlEventTouchUpInside];
        [_popBgView addSubview:bgBtn];
        [bgBtn release];
        
        UIImageView* cateBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(46, 50, 180, 346)];
        if (selectedCate == kSelectedCate2) {
            [cateBgImageView setFrame:CGRectMake(155, 50, 180, 346)];
        }            
        [cateBgImageView setImage:[UIImage imageNamed:@"ProvinceInAddress@2x.png"]];
        [cateBgImageView setBackgroundColor:[UIColor clearColor]];
        [cateBgImageView setTag:kProCate1ToCate2BgView];
        [_popBgView addSubview:cateBgImageView];
        [cateBgImageView release];
        
        UIImageView* upArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(126, 43, 19, 17)];
        if (selectedCate == kSelectedCate2) {
            [upArrowImage setFrame:CGRectMake(235, 43, 19, 17)];
        }
        [upArrowImage setImage:[UIImage imageNamed:@"popoverArrowUpWhite"]];
        [upArrowImage setBackgroundColor:[UIColor clearColor]];
        [_popBgView addSubview:upArrowImage];
        [upArrowImage release];
        
    }
    
    if (selectedCate == kSelectedCate1) {
        self.cate1Table = [[[UITableView alloc]initWithFrame:CGRectMake(56, 60, 160, 322)]autorelease];
        [cate1Table setDataSource:self];
        [cate1Table setDelegate:self];
        [cate1Table setShowsHorizontalScrollIndicator:NO];
        [cate1Table setShowsVerticalScrollIndicator:NO];
        [cate1Table setBackgroundColor:[UIColor clearColor]];
        [cate1Table setTag:kProCate1TableViewTag];
        [_popBgView addSubview:cate1Table];
    }else{
        if (cate2Table.superview == nil) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.25;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type =kCATransitionFade;
            [_popBgView.layer addAnimation:transition forKey:@"fadeIn"];
            if (selectedCate == kSelectedCate1ToCate2) {
                UIImageView* bgView = (UIImageView*)[_popBgView viewWithTag:kProCate1ToCate2BgView];
                [bgView setFrame:CGRectMake(46, 50, 360, 346)];
                // 分割线
                UIView* sepLine = [[UIView alloc]initWithFrame:CGRectMake(186, 25, 1, 295)];
                [sepLine setBackgroundColor:[UIColor lightGrayColor]];
                [sepLine setAlpha:0.3];
                [bgView addSubview:sepLine];
                [sepLine release];
            }
            
            self.cate2Table = [[[UITableView alloc]initWithFrame:CGRectMake(246, 60, 140, 322)]autorelease];
            if (selectedCate == kSelectedCate2) {
                [cate2Table setFrame:CGRectMake(165, 60, 160, 322)];
            }
            [cate2Table setDataSource:self];
            [cate2Table setDelegate:self];
            [cate2Table setShowsHorizontalScrollIndicator:NO];
            [cate2Table setShowsVerticalScrollIndicator:NO];
            [cate2Table setBackgroundColor:[UIColor clearColor]];
            [cate2Table setTag:kProCate2TableViewTag];
            [_popBgView addSubview:cate2Table];
        }
    }
    if (_popBgView.superview == nil) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionFade;
        [rootViewController.view.layer addAnimation:transition forKey:@"fadeIn"];
        [rootViewController.view addSubview:_popBgView];
    }
}
-(void)cateAll:(id)sender{
    cateid=nil;
    
    if (!cateTableViewBgView) {
        
        self.cateTableViewBgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"catetable_bg.png"]]autorelease];
        cateTableViewBgView.userInteractionEnabled=YES;
        [cateTableViewBgView setFrame:CGRectMake(0-kCateTableWidth, 95,kCateTableWidth, 660)];
        [rootViewController.view addSubview:cateTableViewBgView];
        
        self.cateTableView=[[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kCateTableWidth-10, 649) style:UITableViewStylePlain]autorelease];
        cateTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        cateTableView.tag = kProCateTableViewTag;
        cateTableView.delegate=self;
        cateTableView.dataSource=self;
        cateTableView.showsVerticalScrollIndicator=NO;
        cateTableView.backgroundColor=[UIColor clearColor];
        [cateTableViewBgView addSubview:cateTableView];
        
    }
    CGRect rect=cateTableViewBgView.frame;
    if (rect.origin.x==0) {
        
        rect.origin.x-=kCateTableWidth;
    }else {
        rect.origin.x+=kCateTableWidth;
    }
    [UIView animateWithDuration:kShowRootCateDuration
                     animations:^{
                         
                         cateTableViewBgView.frame = rect;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)cate1:(UIButton *)sender{
    UIButton* btn = (UIButton*)sender;
    btn.selected = YES;
    self.selectedCate = kSelectedCate1;
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService1:) toTarget:self withObject:cate1.nid];
    [self showCateView];
    
    
}
-(void)cate2:(UIButton *)sender{
    UIButton* btn = (UIButton*)sender;
    btn.selected = YES;
    self.selectedCate = kSelectedCate2;
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService1:) toTarget:self withObject:cate2.nid];
    [self showCateView];
    
}
-(void)cate3:(UIButton *)sender{
    
    [self cateSelected:cate3.nid];
    
}
-(void)cateSelected:(NSNumber *)acateid{
    self.cateid= acateid;
    NSLog(@"self.cateid==%@",self.cateid);
    [self openProductListController];
    [MobClick event:@"show_category"];
}
-(void)openProductListController{
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; //@"cube";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [rootViewController.navigationController.view.layer addAnimation:transition forKey:nil];
    ProductListViewController *myController =
    [[ProductListViewController alloc]initWithNibName:nil bundle:nil] ;
    myController.cateid=cateid;
    myController.keyword=@"";
    myController.cate1=cate1;
    myController.cate2=cate2;
    myController.cate3=cate3;
    
    // myController.listData=[[NSArray alloc] initWithArray:listData copyItems:YES];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: listData]];
    myController.listData =array;
    //                                 myController.listData=[[NSArray alloc] initWithArray:listData];
    [rootViewController.navigationController pushViewController:myController animated:NO];
    [myController release];
}
#pragma mark -
#pragma mark service
-(void)getRootCateService1:(NSNumber *)rootCategoryId
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    Page *page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader  mcsiteId:[NSNumber numberWithInt:1] rootCategoryId:rootCategoryId currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
    
    if (page.objList) {
        if (selectedCate == kSelectedCate1) {
            self.cate1Array = page.objList;
            [cate1Table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }else {
            self.cate2Array = page.objList;
            [cate2Table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }
    // tracking 统计
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    [pool drain];
}
-(void)getRootCateService:(NSNumber *)rootCategoryId
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    Page *page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader  mcsiteId:[NSNumber numberWithInt:1] rootCategoryId:rootCategoryId currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
    
    [self performSelectorOnMainThread:@selector(handleCate:) withObject:page.objList waitUntilDone:YES];
    
    // tracking 统计
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    
    [pool drain];
    
}
-(void)getCate2AndCate3ServicwByRootCategoryId:(NSNumber *)rootCategoryId{
    {
        NSArray* arr = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader
                                                                             mcsiteId:[NSNumber numberWithInt:1]
                                                                       rootCategoryId:rootCategoryId];
        // tracking 统计
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
        [DoTracking doJsTrackingWithParma:prama];
        
        if (arr != nil) {
            [self performSelectorOnMainThread:@selector(handleCate:) withObject:arr waitUntilDone:YES];
        }
    }
}
-(void)getCate3Service:(NSNumber *)rootCategoryId
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    Page *page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader  mcsiteId:[NSNumber numberWithInt:1] rootCategoryId:rootCategoryId currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
    NSArray *array=nil;
    if (page.objList) {
        array=[NSArray arrayWithObjects:rootCategoryId, page.objList, nil];
        
    }else {
        array=[NSArray arrayWithObjects:rootCategoryId, [NSArray array], nil];
    }
    
    [self performSelectorOnMainThread:@selector(handleCate3:) withObject:array waitUntilDone:YES];
    
    // tracking 统计
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    
    [pool drain];
}


-(void)handleCate:(NSArray *)array
{
    [categories removeAllObjects];
    categories=nil;
    self.categories=[NSMutableArray arrayWithArray: array];
    if (cateDetailView) {
        UITableView *cateTableView2=[[UITableView alloc]initWithFrame:CGRectMake(0, 60,cateDetailView.frame.size.width, kCateTable2Height) style:UITableViewStylePlain];
        cateTableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
        cateTableView2.tag=kProCateTableView2Tag;
        cateTableView2.delegate=self;
        cateTableView2.dataSource=self;
        [cateDetailView addSubview:cateTableView2];
        [cateTableView2 release];
    }
//    for (CategoryVO *cate in categories) {
//        [self otsDetatchMemorySafeNewThreadSelector:@selector(getCate3Service:) toTarget:self withObject:cate.nid];
//    }
    
    
}
-(void)handleCate3:(NSArray *)array
{
    //NSLog(@"handleCate3 finished---%@",array);
    
    [cate2Dic setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
    if (cateDetailView) {
        UITableView *cateTableView2=(UITableView *)[cateDetailView viewWithTag:kProCateTableView2Tag];
        [cateTableView2 reloadData];
    }
    
    
}
#pragma mark -
#pragma mark table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==kProCateTableViewTag) {
        return 66;
    }
    if (tableView.tag==kProCateTableView2Tag) {
        Cate2Cell *cell=(Cate2Cell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
        return cell.height;
    }
    if (tableView.tag == kProCate1TableViewTag || tableView.tag == kProCate2TableViewTag) {
        return 46;
    }
    return 46;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==kProCateTableViewTag) {
        return self.listData.count;
    }
    if (tableView.tag==kProCateTableView2Tag) {
        return [self.categories  count];
    }
    if (tableView.tag == kProCate1TableViewTag) {
        return cate1Array.count;
    }
    if (tableView.tag == kProCate2TableViewTag) {
        return cate2Array.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==kProCateTableViewTag) {
        static NSString *CustomCellIdentifier = @"ProCateCellIdentifier ";
        
        CateCell *cell=[CateCell alloc];
        NSUInteger row = [indexPath row];
        [cell setCate:[self.listData   objectAtIndex:row]];
        [cell setCellDelegate:self];
        
        [[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier]autorelease];
        if (row%2==0) {
            cell.contentView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        }else {
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        
        //类别名
        cell.cateNameLabel.text=cell.cate.categoryName;
        
        UIImageView *cateImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat: @"cate_%i.png",row]]];
        [cateImage setFrame:CGRectMake(25.0, 17, 25,25)];
        [cell addSubview:cateImage];
        
        [cateImage release];
        return cell;
        
    }
    if (tableView.tag==kProCateTableView2Tag) {
        static NSString *CustomCellIdentifier = @"ProCate2CellIdentifier ";
        
        Cate2Cell *cell=[Cate2Cell alloc];
        NSUInteger row = [indexPath row];
        
        cell.cate2= [self.categories   objectAtIndex:row];
        //cell.cate3Array=[cate2Dic objectForKey:cell.cate2.nid];
        cell.cate3Array = [cell.cate2 childCategoryVOList];
        cell.cellDelegate=self;
        [[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier]autorelease];
        
        int x=190;
        int y=30;
        if (cell.cate3Array) {
            int i=0;
            for (CategoryVO *catevo3 in cell.cate3Array) {
                UIButton *catevo3But=[UIButton buttonWithType:UIButtonTypeCustom];
                catevo3But.layer.cornerRadius = 8;
                catevo3But.layer.masksToBounds = YES;
                catevo3But.tag=i;
                [catevo3But setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [catevo3But setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [catevo3But setTitle:catevo3.categoryName forState:UIControlStateNormal];
                [catevo3But setBackgroundImage:[UIImage imageNamed:@"cate_butbg.png"] forState:UIControlStateHighlighted];
                [catevo3But addTarget:cell action:@selector(cate3Click:) forControlEvents:UIControlEventTouchUpInside];
                
                UIFont *font=[UIFont fontWithName:kCellButFontname size:kCellButFontsize];
                CGSize size =[catevo3.categoryName sizeWithFont:font constrainedToSize:CGSizeMake(260, 30)];
                catevo3But.titleLabel.font=font;
                if (x+size.width>870) {
                    x=190;
                    y+=40;
                }
                [catevo3But setFrame:CGRectMake(x, y, size.width+4, 30.0)];//
                [cell addSubview:catevo3But];
                x+=size.width+20;
                i++;
            }
        }else {
//            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activityView.frame = CGRectMake(440.f, 27.0f, 25.0f, 25.0f);
//            [cell insertSubview:activityView atIndex:1];
//            [activityView startAnimating];
//            [activityView release];
            
        }
        UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(175, 30, 1, y)];
        lineView.image=[UIImage imageNamed:@"cate_line.png"];
        [cell insertSubview:lineView atIndex:1];
        [lineView release];
        UIImageView *kuangView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_kuang1.png"]];
        [kuangView1 setFrame:CGRectMake(25.0, 20, 873,25)];
        [cell addSubview:kuangView1];
        [kuangView1 release];
        
        UIImageView *kuangView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_kuang2.png"]];
        [kuangView2 setFrame:CGRectMake(25.0, 45, 873,y-1)];
        [cell addSubview:kuangView2];
        [kuangView2 release];
        
        UIImageView *kuangView3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_kuang3.png"]];
        [kuangView3 setFrame:CGRectMake(25.0, 44+y, 873,1)];
        [cell addSubview:kuangView3];
        [kuangView3 release];
        
        
        [cell sendSubviewToBack:kuangView1];
        [cell sendSubviewToBack:kuangView2];
        [cell sendSubviewToBack:kuangView3];
        cell.height=45+y;
        
        return cell;
        
    }
    if (tableView.tag == kProCate1TableViewTag || tableView.tag == kProCate2TableViewTag) {
        UITableViewCell* cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        CategoryVO* tempVo;
        if (tableView.tag == kProCate1TableViewTag) {
            tempVo = [cate1Array objectAtIndex:[indexPath row]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else{
            tempVo = [cate2Array objectAtIndex:[indexPath row]];
        }
        cell.textLabel.text = tempVo.categoryName;
        if (selectedCate2Index == [indexPath row] && tableView.tag == kProCate1TableViewTag) {
            cell.textLabel.textColor = [UIColor colorWithRed:213.0/255 green:0 blue:17.0/255 alpha:1];
        }else{
            cell.textLabel.textColor = CateTableViewTextColor;
        }
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        return cell;
    }
    
    UITableViewCell *  cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(tableView.tag==kProCate1TableViewTag||tableView.tag==kProCate2TableViewTag)){
        return;
    }
    UITableViewCell* cell;
    for (int i=0; i<[tableView numberOfRowsInSection:0]; i++) {
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.textLabel.textColor = CateTableViewTextColor;
    }
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:213.0/255 green:0 blue:17.0/255 alpha:1];
    selectedCate2Index = [indexPath row];
    
    if (tableView.tag==kProCate1TableViewTag) {
        self.selectedCate = kSelectedCate1ToCate2;
        [self showCateView];
        CategoryVO* cateVo = [cate1Array objectAtIndex:[indexPath row]];
        self.currentCate2=cateVo;
        [self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService1:) toTarget:self withObject:cateVo.nid];
        
    }
    if (tableView.tag==kProCate2TableViewTag) {
        CategoryVO* cateVo = [cate2Array objectAtIndex:[indexPath row]];
        self.cate3=cateVo;
        if (selectedCate == kSelectedCate1ToCate2) {
            self.cate2=currentCate2;
        }
        [self cateSelected:cate3.nid];
        [self ClosePopview];
    }
    
}

#pragma mark -
#pragma mark cellDelegate

- (void)openCateView:(CategoryVO *)cate{
    
    self.cateView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, dataHandler.screenWidth, dataHandler.screenWidth==768?1024:768)]autorelease];
    //cateView.tag=kCateViewTag;
    cateView.backgroundColor=[UIColor clearColor];
    CGRect rect=cateView.frame;
    UIView *cateBg=[[UIView alloc]initWithFrame:rect];
    cateBg.backgroundColor=[UIColor grayColor];
    cateBg.alpha=0.4;
    [cateView addSubview:cateBg];
    [cateBg release];
    [rootViewController.view addSubview:cateView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCateView)];
    [cateBg addGestureRecognizer:tapGes];
    [tapGes release];
    
    
    rect.size.width-=kCateDetailViewX;
    rect.origin.x+=dataHandler.screenWidth;
    self.cateDetailView=[[[UIView alloc]initWithFrame:rect]autorelease];
    cateDetailView.backgroundColor=[UIColor whiteColor];
    [cateView addSubview:cateDetailView];
    
    // 滑动关闭
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeCateView)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [cateView addGestureRecognizer:recognizer];
    [recognizer release];
    
    UIView *cateTop=[[UIView alloc]initWithFrame:CGRectMake(0, 16, rect.size.width, 45)];
    cateTop.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cate_topbg.png"]];
    [cateDetailView addSubview:cateTop];
    [cateTop release];
    //NSLog(@"rect=%f=%f=%f=%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    UIButton *closeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateNormal];
    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateHighlighted];
    [closeBut addTarget:self action:@selector(closeCateView) forControlEvents:UIControlEventTouchUpInside];
    [closeBut setFrame:CGRectMake(rect.size.width-46, 7, 30, 30)];//
    [cateTop addSubview:closeBut];
    
    UILabel *cateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 3, 270.0, 39.0) ];
    cateNameLabel.textColor =[UIColor whiteColor];
    cateNameLabel.text=[cate.categoryName stringByAppendingString:@"〉"];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    cateNameLabel.font=font;
    cateNameLabel.backgroundColor=[UIColor clearColor];
    [cateTop addSubview:cateNameLabel];
    [cateNameLabel release];
    
//    UIButton *moreBut=[UIButton buttonWithType:UIButtonTypeCustom];
//    [moreBut setImage:[UIImage imageNamed:@"cate_more1.png"] forState:UIControlStateNormal];
//    [moreBut setImage:[UIImage imageNamed:@"cate_more2.png"] forState:UIControlStateHighlighted];
//    [moreBut addTarget:self action:@selector(closeCateView) forControlEvents:UIControlEventTouchUpInside];
//    [moreBut setFrame:CGRectMake(25, 670, 112, 43)];//
//    [cateDetailView addSubview:moreBut];
    
    
    cate1 =cate;
    
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService:) toTarget:self withObject:cate1.nid];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getCate2AndCate3ServicwByRootCategoryId:) toTarget:self withObject:cate1.nid];
    
    [self moveToLeftSide:cateDetailView];
}
#pragma mark -
#pragma mark UI操作
- (void)closeCateView{
    
    [self moveToRightSide:cateDetailView];
    
}
// move view to left side
- (void)moveToLeftSide:(UIView *)view{
    
    [self animateViewToSide:CGRectMake(kCateDetailViewX, view.frame.origin.y, view.frame.size.width, view.frame.size.height) view:view];
}


// move view to right side
- (void)moveToRightSide:(UIView *)view {
    
    [self animateViewToSide:CGRectMake(dataHandler.screenWidth,view.frame.origin.y, view.frame.size.width, view.frame.size.height) view:view];
}

// animate home view to side rect
- (void)animateViewToSide:(CGRect)newViewRect view:(UIView *)view{
    [UIView animateWithDuration:kShowCateDetailDuration
                     animations:^{
                         view.frame = newViewRect;
                     }
                     completion:^(BOOL finished){
                         
                         //UIView *cateView=[self.view viewWithTag:kCateViewTag];
                         if (view.frame.origin.x==dataHandler.screenWidth) {
                             if (cateView) {
                                 [cateView removeFromSuperview];
                                 cateDetailView=nil;
                             }
                             
                             if (cateid) {
                                 [self openProductListController];
                                 cateid=nil;
                             }
                         }
                     }];
}
#pragma mark -
#pragma mark cell2Delegate

- (void)openProductList:(CategoryVO *)catevo2 cate3:(CategoryVO *)catevo3{
    self.cate2=catevo2;
    self.cate3=catevo3;
    if (cate3) {
        self.cateid=cate3.nid;
    }else {
        self.cateid=cate2.nid;
    }
    [self closeCateView];
    for (UIView *subview  in self.cateBtnBgView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self fitTheUI];
    CGRect rect=cateTableViewBgView.frame;
    rect.origin.x-=kCateTableWidth;
    [UIView animateWithDuration:kShowRootCateDuration
                     animations:^{
                         
                         cateTableViewBgView.frame = rect;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}

- (void)dealloc
{
    self.rootViewController=nil;//assign类型
    OTS_SAFE_RELEASE(cate1);
    OTS_SAFE_RELEASE(cate2);
    OTS_SAFE_RELEASE(cate3);
    OTS_SAFE_RELEASE(currentCate2);
    OTS_SAFE_RELEASE(cateid);
    OTS_SAFE_RELEASE(listData);
    OTS_SAFE_RELEASE(cateTableViewBgView);
    OTS_SAFE_RELEASE(cateTableView);
    OTS_SAFE_RELEASE(cateDetailView);
    OTS_SAFE_RELEASE(cateView);
    OTS_SAFE_RELEASE(categories);
    OTS_SAFE_RELEASE(cate2Dic);
    OTS_SAFE_RELEASE(cate1Array);
    OTS_SAFE_RELEASE(cate2Array);
    OTS_SAFE_RELEASE(cate1Table);
    OTS_SAFE_RELEASE(cate2Table);
    OTS_SAFE_RELEASE(_popBgView);
    OTS_SAFE_RELEASE(searchLabel);
    OTS_SAFE_RELEASE(activityTitle);
    OTS_SAFE_RELEASE(cateBtnBgView);
    OTS_SAFE_RELEASE(cate1But);
    OTS_SAFE_RELEASE(cate2But);
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
