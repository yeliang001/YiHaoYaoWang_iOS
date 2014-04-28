//
//  PADCartBuyRecordColumnCell.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//
#define CELL_WIDTH  256
#define CELL_HEIGHT 271
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]

#import "PADCartBuyRecordColumnCell.h"
#import "OrderV2.h"
#import "SDImageView+SDWebCache.h"

@implementation PADCartBuyRecordColumnCell
@synthesize orderV2=m_OrderV2,backGroundImage=m_BackGroundImage;

-(id)initWithFrame:(CGRect)frame delegate:(id<PADTableViewColumnCellDelegate>)delegate
{
    self = [super initWithFrame:frame delegate:delegate];
    if (self) {
        // Initialization code
        m_BackGroundImage=[[UIImageView alloc] initWithFrame:CGRectMake((CELL_WIDTH-195)/2, 20, 195, 195)];
        [m_BackGroundImage setImage:[UIImage imageNamed:@"buyRecord_bg.png"]];
        [self addSubview:m_BackGroundImage];
        
        m_FirstImage=[[UIImageView alloc] initWithFrame:CGRectMake(23, 21, 72, 72)];
        [m_BackGroundImage addSubview:m_FirstImage];
        
        m_SecondImage=[[UIImageView alloc] initWithFrame:CGRectMake(102, 21, 72, 72)];
        [m_BackGroundImage addSubview:m_SecondImage];
        
        m_ThiredImage=[[UIImageView alloc] initWithFrame:CGRectMake(23, 100, 72, 72)];
        [m_BackGroundImage addSubview:m_ThiredImage];
        
        m_FourthImage=[[UIImageView alloc] initWithFrame:CGRectMake(102, 100, 72, 72)];
        [m_BackGroundImage addSubview:m_FourthImage];
        
        m_Time=[[UILabel alloc] initWithFrame:CGRectMake((CELL_WIDTH-195)/2, 220, 195, 25)];
        [m_Time setTextColor:DEFAULT_COLOR];
        [m_Time setFont:[m_Time.font fontWithSize:17.0]];
        [self addSubview:m_Time];
        
        m_Price=[[UILabel alloc] initWithFrame:CGRectMake((CELL_WIDTH-195)/2, 245, 195, 25)];
        [m_Price setTextColor:DEFAULT_COLOR];
        [m_Price setFont:[m_Price.font fontWithSize:17.0]];
        [self addSubview:m_Price];
    }
    return self;
}

-(void)updateWithArray:(NSArray *)array index:(NSInteger)index
{
    [super updateWithArray:array index:index];
    if (m_OrderV2!=nil) {
        [m_OrderV2 release];
    }
    if (index<[array count]) {
        m_OrderV2=[[array objectAtIndex:index] retain];
        
        //商品图片
        ProductVO *firstProductVO=[[OTSUtility safeObjectAtIndex:0 inArray:m_OrderV2.orderItemList] product];
        if (firstProductVO.midleDefaultProductUrl!=nil) {
            [m_FirstImage setImageWithURL:[NSURL URLWithString:firstProductVO.midleDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
        } else {
            [m_FirstImage setImageWithURL:[NSURL URLWithString:firstProductVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
        }
        
        ProductVO *secondProductVO=[[OTSUtility safeObjectAtIndex:1 inArray:m_OrderV2.orderItemList] product];
        if (secondProductVO.midleDefaultProductUrl!=nil) {
            [m_SecondImage setImageWithURL:[NSURL URLWithString:secondProductVO.midleDefaultProductUrl] refreshCache:NO placeholderImage:nil];
        } else {
            [m_SecondImage setImageWithURL:[NSURL URLWithString:secondProductVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:nil];
        }
        
        ProductVO *thirdProductVO=[[OTSUtility safeObjectAtIndex:2 inArray:m_OrderV2.orderItemList] product];
        if (thirdProductVO.midleDefaultProductUrl) {
            [m_ThiredImage setImageWithURL:[NSURL URLWithString:thirdProductVO.midleDefaultProductUrl] refreshCache:NO placeholderImage:nil];
        } else {
            [m_ThiredImage setImageWithURL:[NSURL URLWithString:thirdProductVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:nil];
        }
        
        ProductVO *fourthProductVO=[[OTSUtility safeObjectAtIndex:3 inArray:m_OrderV2.orderItemList] product];
        if (fourthProductVO.midleDefaultProductUrl) {
            [m_FourthImage setImageWithURL:[NSURL URLWithString:fourthProductVO.midleDefaultProductUrl] refreshCache:NO placeholderImage:nil];
        } else {
            [m_FourthImage setImageWithURL:[NSURL URLWithString:fourthProductVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:nil];
        }
        
        //下单时间
        NSString *orderTime=[m_OrderV2 createOrderLocalTime];
        if ([orderTime length]>10) {
            orderTime=[orderTime substringWithRange:NSMakeRange(0, 10)];
        }
        [m_Time setText:[NSString stringWithFormat:@"下单时间：%@",orderTime]];
        
        //订单金额
        [m_Price setText:[NSString stringWithFormat:@"订单金额：￥%.2f",[m_OrderV2.orderAmount doubleValue]]];
    } else {
        m_OrderV2=nil;
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_BackGroundImage);
    OTS_SAFE_RELEASE(m_FirstImage);
    OTS_SAFE_RELEASE(m_SecondImage);
    OTS_SAFE_RELEASE(m_ThiredImage);
    OTS_SAFE_RELEASE(m_FourthImage);
    OTS_SAFE_RELEASE(m_Time);
    OTS_SAFE_RELEASE(m_Price);
    OTS_SAFE_RELEASE(m_OrderV2);
    [super dealloc];
}

@end
