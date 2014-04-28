//
//  OTSProductNNPiecesTopView.m
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import "OTSNNPiecesTopView.h"
#import "CartService.h"
#import "GlobalValue.h"
#import "SDImageView+SDWebCache.h"
#import "OTSUtility.h"
#import "StrikeThroughLabel.h"
#import "OTSImageView.h"
#import "MobilePromotionDetailVO.h"
#import "ProductVO.h"
#import "CartService.h"
#import "TheStoreAppAppDelegate.h"

@interface OTSNNPiecesTopView()
@property(nonatomic,assign) id mDelegate;
@property(nonatomic,retain) NSMutableArray *mArray;
@end

@implementation OTSNNPiecesTopView
@synthesize mDelegate;
@synthesize mArray;
@synthesize opHight;

-(id)initWithFrame:(CGRect)frame MobilePromotionDetailVO:(MobilePromotionDetailVO *)mpproductVO TopViewproducts:(NSMutableArray*)tpproductsArray isExistOptionalInCart:(NormResult *) existOptional MainView:(UIView*)mainView delegate:(id<OTSNNPiecesTopProductsDelegate>)delegate;
{
    self=[super initWithFrame:frame];
    
    if (self!=nil) {
        self.mDelegate = delegate;
        self.mArray = tpproductsArray;
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:frame];
        [scrollView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:scrollView];
        [scrollView release];
        CGFloat xValue=10.0;
        int i;
 
        for (i=0; i<[self.mArray count]; i++) {
            ProductVO *vo= (ProductVO*)[OTSUtility safeObjectAtIndex:i inArray:self.mArray];
            //placeholder  ~  NNPplaceholder@2x.png
            OTSImageView *NNPplaceholder=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 15, 45, 45)];
            [NNPplaceholder setImage:[UIImage imageNamed:@"NNPplaceholder@2x.png"]];
            //商品图片
            OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 40, 40)];
            [imageView setTag:200+i];
            [imageView.layer setBorderColor:[[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0] CGColor]];
            [imageView loadImgUrl:vo.miniDefaultProductUrl];
            [imageView setUserInteractionEnabled:YES];
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
            [imageView addGestureRecognizer:tap];
            [tap release];
            
            //关闭按钮
            UIButton *b=[[UIButton alloc] initWithFrame:CGRectMake(xValue-9, 9, 18, 18)];
            b.tag=200+i;
            [b setBackgroundImage:[UIImage imageNamed:@"NNPdeleteproduct@2x.png"] forState:UIControlStateNormal];
            b.layer.cornerRadius = 5;
            b.layer.shadowOffset =  CGSizeMake(1, 3);
            b.layer.shadowOpacity = 0.8;
            b.layer.shadowColor =  [UIColor blackColor].CGColor;
            [b addTarget:self action:@selector(bClick:) forControlEvents:UIControlEventTouchUpInside];
            [NNPplaceholder addSubview:imageView];
            [scrollView addSubview:NNPplaceholder];
            [scrollView addSubview:b];
            [NNPplaceholder release];
            [imageView release];
            [b release];
            xValue+=70.0;
        }
    
        [scrollView setContentSize:CGSizeMake(70.0*[mpproductVO.conditionValue intValue], 45.0)];
        int mOff = i*70/250;
        float mWight= 250.0*mOff;
        DebugLog(@">>>> %d > %f",mOff,mWight);
//        [scrollView setContentOffset:CGPointMake(mWight, 0) animated:YES];
        
        for (int i = [self.mArray count]; i<[mpproductVO.conditionValue intValue]; i++) {
            //placeholder  ~  NNPplaceholder@2x.png
            OTSImageView *NNPplaceholder=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 15, 45, 45)];
            [NNPplaceholder setImage:[UIImage imageNamed:@"NNPplaceholder@2x.png"]];
            UILabel *numberLable = [[UILabel alloc] initWithFrame:CGRectMake(xValue+17,30,25,15)];
            numberLable.backgroundColor=[UIColor clearColor];
            numberLable.textColor = [UIColor whiteColor];
            [numberLable setText:[NSString stringWithFormat:@"%d",(i+1)]];
            [scrollView addSubview:NNPplaceholder];
            [scrollView addSubview:numberLable];
            [NNPplaceholder release];
            [numberLable release];
            xValue+=70.0;
        }
        
        for (UIView *view in [mainView subviews]) {
            [view removeFromSuperview];
        }
        
        self.opHight = [NSNumber numberWithFloat:0.0];
        //添加商品到列表,判断当前top数组小于条件值
        if ([self.mArray count] == [[mpproductVO conditionValue] intValue]) {
            
            if ([self.mDelegate iNNPiecesShowCart]) {
                //查看购物车
                UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(95, 70, 136, 39)];
                [button setTitle:@"查看购物车" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0]];
                [button setBackgroundImage:[UIImage imageNamed:@"sec_val_send_btn_disabled@2x.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(enterNNPiecesCart) forControlEvents:UIControlEventTouchUpInside];
                [mainView addSubview:button];
                [button release];
            }
            else if (existOptional && [existOptional.resultCode intValue]==1) {
                //替换购物车 lab
                UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 60, 200, 39)];
                [lb1 setText:@"购物车内已有该活动商品"];
                [lb1 setFont:[UIFont systemFontOfSize:15.0]];
                [lb1 setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
                [lb1 setBackgroundColor:[UIColor clearColor]];
                [mainView addSubview:lb1];
                [lb1 release];
                
                UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(35, 75, 200, 39)];
                [lb2 setText:@"(单笔消费仅享受1次)"];
                [lb2 setFont:[UIFont systemFontOfSize:13.0]];
                [lb2 setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
                [lb2 setBackgroundColor:[UIColor clearColor]];
                [mainView addSubview:lb2];
                [lb2 release];
                
                //替换购物车 btn
                UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(210, 70, 70, 39)];
                [button setTitle:@"替换" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:17.0]];
                [button setBackgroundImage:[UIImage imageNamed:@"short_orange_btn@2x.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(updateNNPieces) forControlEvents:UIControlEventTouchUpInside];
                [mainView addSubview:button];
                [button release];
            }
            else
            {
                //加入购物车
                UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(95, 70, 136, 39)];
                [button setTitle:@"加入购物车" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:17.0]];
                [button setBackgroundImage:[UIImage imageNamed:@"orange_btn.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addNNPieces) forControlEvents:UIControlEventTouchUpInside];
                [mainView addSubview:button];
                [button release];
            }
            self.opHight = [NSNumber numberWithFloat:45.0];
        }
        if ([self.mDelegate respondsToSelector:@selector(iNNPiecesProductIsInOperation:)]) {
            [self.mDelegate performSelector:@selector(iNNPiecesProductIsInOperation:) withObject:self.opHight];
        }
    }
    return self;
}


-(void)enterNNPiecesCart
{
    if ([self.mDelegate respondsToSelector:@selector(iNNPiecesSetShowCart)]) {
        [self.mDelegate performSelector:@selector(iNNPiecesSetShowCart)];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterCart" object:nil];
}

-(void)addNNPieces
{
    if ([self.mDelegate respondsToSelector:@selector(iNNPiecesAddToCart)]) {
        [self.mDelegate performSelector:@selector(iNNPiecesAddToCart)];
    }
}

-(void)updateNNPieces
{
    if ([self.mDelegate respondsToSelector:@selector(iNNPiecesUpdateToCart)]) {
        [self.mDelegate performSelector:@selector(iNNPiecesUpdateToCart)];
    }
}


-(void)showInfo:(NSString *)info
{
    UIAlertView *alerView=[[UIAlertView  alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alerView show];
    [alerView release];
}

-(void)bClick:(UIButton*)btn{
    int index=btn.tag-200;
    if ([self.mDelegate respondsToSelector:@selector(iNNPiecesProductClicked:)]) {
        [self.mDelegate performSelector:@selector(iNNPiecesProductClicked:) withObject:[NSNumber numberWithInt:index]];
    }
}

-(void)clickTap:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    OTSImageView *iv = (OTSImageView *)recognizer.view;
    int index=iv.tag-200;
    if ([self.mDelegate respondsToSelector:@selector(iNNPiecesProductClicked:)]) {
            [self.mDelegate performSelector:@selector(iNNPiecesProductClicked:) withObject:[NSNumber numberWithInt:index]];
    }
}


-(void)dealloc
{
    self.mArray = nil;
    self.opHight = nil;
    self.mDelegate = nil;
    [super dealloc];
}
@end
