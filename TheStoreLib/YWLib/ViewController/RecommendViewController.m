//
//  RecommendViewController.m
//  TheStoreApp
//
//  Created by 林盼 on 14-3-31.
//
//

#import "RecommendViewController.h"
#import "RecommendListView.h"
#import "YWConst.h"
#import "OTSProductDetail.h"
#import "OTSNaviAnimation.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _tabNameArr = @[@"当季推荐",@"热评商品",@"药师推荐",@"新品上架"];
    
    //标题栏
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [imageView setImage:[UIImage imageNamed:@"title_bg.png"]];
    [self.view addSubview:imageView];
    [imageView release];
    
    UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 44)];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [returnBtn release];
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"热门推荐"];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setShadowOffset:CGSizeMake(1, -1)];
    [self.view addSubview:title];
    [title release];
    
    //tab
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 320, 44)];
    [tabView setBackgroundColor:[UIColor colorWithString:@"B0E2FF"]];
    [self.view addSubview:tabView];
    [tabView release];
    
    int tabW = 60;
    
    _tabTitleButtons = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0 ; i < 4; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + i * (tabW+20), 0, tabW,tabView.height);
        [btn setTitle:_tabNameArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor: [UIColor redColor]/*[UIColor colorWithString:@"4876FF"] */forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(moveContentView:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        
        [tabView addSubview:btn];
        
        
        
        [_tabTitleButtons addObject:btn];
        
        if (i == 0)
        {
            btn.selected = YES;
        }
        
        
    }
    
    UIView *dynamicLine = [[UIView alloc] initWithFrame:CGRectMake(0, tabView.height-5, 80, 5)];
    [dynamicLine setBackgroundColor:[UIColor redColor]];
    [tabView addSubview:dynamicLine];
    [dynamicLine release];
    _dynamicLine = [dynamicLine retain];
    
    UIScrollView *contentSC = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabView.frame), 320, self.view.height-CGRectGetMaxY(tabView.frame))];
    [contentSC setContentSize:CGSizeMake(320 * 4, contentSC.height)];
    contentSC.pagingEnabled = YES;
    [self.view addSubview:contentSC];
    contentSC.delegate = self;
    [contentSC release];
    
    _contentSv = contentSC;
    
    
    _recommendListViews = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i = 0; i < 4; ++i)
    {
        RecommendListView *v = [[RecommendListView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, contentSC.height)];
        v.delegate = self;
        [contentSC addSubview:v];
        [v release];
        
        [_recommendListViews addObject:v];
        
        
        switch (i)
        {
            case 0:
                [v startLoadData:kRCSeason];
                break;
            case 1:
                //百分点不能同时请求，他们会出错，，，，，，只能延时执行。 我们这里数据量不大，这4个数据一起获取得了
                [v performSelector:@selector(startLoadData:) withObject:kRCComment afterDelay:1];
                break;
            case 2:
                [v performSelector:@selector(startLoadData:) withObject:kRCDoctor afterDelay:2];
                break;
            case 3:
                [v performSelector:@selector(startLoadData:) withObject:kRCNew afterDelay:3];
                break;
            default:
                break;
        }

    }
}


- (void)moveContentView:(UIButton *)sender
{
//    int dx = sender.tag * 320 -_contentSv.left;
    [_contentSv setContentOffset:CGPointMake(sender.tag * 320, 0) animated:YES];
    
    [self highTabTitleColor:sender.tag];
}



- (void)back
{
    [self popSelfAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)highTabTitleColor:(NSInteger)index
{
    for (UIButton *btn in _tabTitleButtons)
    {
        btn.selected = NO;
    }
    
    UIButton *tabBtn = _tabTitleButtons[index];
    tabBtn.selected = YES;
}


#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger selectIndex = scrollView.contentOffset.x / 320;
    
    [self highTabTitleColor:selectIndex];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int dx = scrollView.contentOffset.x / scrollView.contentSize.width * 320-_dynamicLine.left;
    _dynamicLine.frame = CGRectOffset(_dynamicLine.frame, dx, 0);
}


#pragma mark Recommend Delegate
- (void)selectedProductId:(NSString *)productId
{
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productId longLongValue] promotionId:nil fromTag:PD_FROM_CATEGORY] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];

}

@end
