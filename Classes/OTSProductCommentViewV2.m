//
//  OTSProductCommentViewV3.m
//  TheStoreApp
//
//  Created by towne on 13-4-2.
//
//

#import "OTSProductCommentViewV2.h"
#import "OTSTabView.h"
#import "OTSProductCommentTopCellV2.h"
#import "OTSProductCommentTableCellV2.h"
#import "OTSUtility.h"
#import "UITableView+LoadingMore.h"
#import "OTSNaviAnimation.h"

@interface OTSProductCommentViewV2 ()
@property(nonatomic, strong) OTSTabView *TabViewV2; //TAB页面
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic,assign) id<OTSProductCommentTopCellDelegate> TopCellDelegate;
@property(nonatomic, strong) NSMutableArray *commentsArray; //由网络获取的评论数据
@property(nonatomic, strong) OTSProductCommentTopCellV2 *commentopcell;
@property(nonatomic,retain)  ProductVO *productVO;//传入参数，当前商品
@end

@implementation OTSProductCommentViewV2

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
	// Do any additional setup after loading the view.
    //ui初始化
    [self initTitleBar];
    [self initMainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  功能:初始化标题栏
 */
- (void)initTitleBar
{
    [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [imageView setImage:[UIImage imageNamed:@"title_bg.png"]];
    [self.view addSubview:imageView];
    [imageView release];
    
    UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 44)];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(returnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [returnBtn release];
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"商品评价"];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setShadowOffset:CGSizeMake(1, -1)];
    [self.view addSubview:title];
    [title release];
}

/**
 *  功能:初始化主视图
 */
- (void)initMainView
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1.0];
    //table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width,self.view.frame.size.height-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self requestAsync];
}

-(void)requestAsync{
    
    if (!isLoadingMore) {
        [self showLoading];
    }
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        //        NSNumber * pagesize = [NSNumber numberWithInt:5];
        //        NSNumber * currentpage = [NSNumber numberWithInt:currentPageIndex];
        self.commentsArray =[[[NSMutableArray alloc] init] autorelease];
        sleep(3);
        if (isLoadingMore) {
            for (ProductExperienceVO *experience in self.productVO.rating.top5Experience)
            {
                [self.commentsArray addObject:experience];
            }
        }else {
            [self.commentsArray removeAllObjects];
            
            for (ProductExperienceVO *experience in self.productVO.rating.top5Experience)
            {
                [self.commentsArray addObject:experience];
            }
        }
        totalCount += 5;
        [pool drain];
    } completionInMainBlock:^(){
        
        [self hideLoading];
        
        if(!isLoadingMore)
        {
            
        }
        
        [self.tableView reloadData];
        [self hideLoadingMore];
    }];
}

-(void)hideLoadingMore
{
    [self.tableView setTableFooterView:nil];
    isLoadingMore=NO;
}

//加载更多
-(void)getMore
{
    currentPageIndex++;
    isLoadingMore=YES;
    [self requestAsync];
}


#pragma mark tableView相关delegate和dataSource
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==[self.commentsArray count]-1 && [self.commentsArray count]<totalCount) {
        if (!isLoadingMore) {
            [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40) target:self selector:@selector(getMore) type:UITableViewLoadingMoreForeIphone];
            isLoadingMore=YES;
        }
    }
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        //tab切换
        NSArray *titles =[NSArray arrayWithObjects:@"全部\r(1000)", @"好评\r(900)", @"中评\r(60)",@"差评\r(40)", nil];
        NSArray *img_font_tabs =[NSArray arrayWithObjects:@"comment_sel@2x.png",@"black",@"comment_unsel@2x.png",@"black",nil];
        //_TabViewV2 只创建一次，reload不刷新
        if (_TabViewV2 == nil) {
            self.TabViewV2=[[[OTSTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 44.0) titles:titles imgtabs:img_font_tabs delegate:self] autorelease];
        }
        return _TabViewV2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    } else {
        return 44.0;
    }
}

//cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        int objCount=[self.commentsArray count];//实际的数目
        return objCount ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //_commentopcell 只创建一次，reload不刷新
        if (_commentopcell == nil) {
            self.commentopcell = [[[OTSProductCommentTopCellV2 alloc] initWithProductVO:_productVO] autorelease];
            self.TopCellDelegate = _commentopcell;
        }
        return _commentopcell;
    } else {
        OTSProductCommentTableCellV2 *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (cell == nil) {
            cell = [[OTSProductCommentTableCellV2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        ProductExperienceVO  *experience = [OTSUtility safeObjectAtIndex:indexPath.row inArray:self.commentsArray];
        [cell updateWithProductExperienceVO:experience];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 87.0;
    } else {
        ProductExperienceVO  *experienceVO = [OTSUtility safeObjectAtIndex:indexPath.row inArray:self.commentsArray];
        CGSize size = [experienceVO.content sizeWithFont:[UIFont systemFontOfSize:12.0]];
        int count = size.width/300.0;
        if (size.width/300.0 > count) {
            count ++;
        }
        return size.height*count+76;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//返回按钮
-(void)returnBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - OTSTabView相关delegate
-(void)tabClickedAtIndex:(NSNumber *)index
{
    DebugLog(@">>>>>>>>>index %d",[index intValue]);
    [self requestAsync];
    [self.TopCellDelegate iCommentRefreshgRPercentValueLabel:index];
}

- (void)dealloc
{
    OTS_SAFE_RELEASE(_TabViewV2);
    OTS_SAFE_RELEASE(_tableView);
    OTS_SAFE_RELEASE(_commentsArray);
    OTS_SAFE_RELEASE(_commentopcell);
    OTS_SAFE_RELEASE(_productVO);
    
    [super dealloc];
}

@end