//
//  OTSAnimationTableView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSAnimationTableView.h"
#import "ProductService.h"
#import "GlobalValue.h"
#import "OTSAnimationTableCell.h"
#import "MobilePromotionVO.h"
#import "OTSUtility.h"
#import "SDImageView+SDWebCache.h"
#import "StrikeThroughLabel.h"
#import "CouponCell.h"
#import "OTSServiceHelper.h"
#import "CategoryVO.h"

@interface OTSAnimationTableView ()
@property(nonatomic,retain) MobilePromotion *mobilePromotion;
@end

@implementation OTSAnimationTableView
@synthesize mobilePromotion = _mobilePromotion;


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style productVO:(ProductVO *)productVO delegate:(id<OTSAnimationTableViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self performInThreadBlock:^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            ProductService *pServ = [[[ProductService alloc] init] autorelease];
            NSMutableArray *merchantIds = [[[NSMutableArray alloc] init] autorelease];
            [merchantIds addObject:[productVO merchantId]];
            NSMutableArray *productIds = [[[NSMutableArray alloc] init] autorelease];
            [productIds addObject:[productVO productId]];
            MobilePromotion *tempMobilePromotion = nil;
            @try {
                tempMobilePromotion = [pServ getMobilePromotion:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId merchantIds:merchantIds productIds:productIds];
            }
            @catch (NSException *exception) {
            }
            @finally {
                if (tempMobilePromotion!=nil && ![tempMobilePromotion isKindOfClass:[NSNull class]]) {
                    self.mobilePromotion = tempMobilePromotion;
                    //促销判断
                    if ([productVO.hasGift intValue]==1) {
                        m_Array = [self.mobilePromotion promotionGiftList];
                    }
                    if(productVO.hasCash && productVO.hasCash.length>0 )
                    {
                        mjArray = [self.mobilePromotion cashPromotionList];
                    }
                    if (productVO.offerName.length > 0) {
                        m_NNArray = self.mobilePromotion.offerPromotionList;
                    }
                } else {
                    self.mobilePromotion = nil;
                    m_Array = nil;
                    mjArray = nil;
                    m_NNArray = nil;
                }
            }
            [pool drain];
        }completionInMainBlock:^{
            if (self.mobilePromotion != nil) {
                m_Delegate = delegate;
                //默认展开第一条
                m_UnFoldIndexForGift = -1;
                CGFloat cashTableHeight = 44.0*[mjArray count];
                CGFloat giftTableHeight = 44.0*[m_Array count];
                CGFloat offerTableHeight = 44.0*[m_NNArray count];
                CGFloat totalHeight = cashTableHeight + giftTableHeight + offerTableHeight;
                
                if (totalHeight) {
                    totalHeight += 35;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 20)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setText:@"促销详情"];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [self addSubview:label];
                    [label release];
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 150, 20)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setText:@"可在购物车中领取或换购"];
                    [label setTextColor:[UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0]];
                    [label setFont:[UIFont systemFontOfSize:13.0]];
                    [self addSubview:label];
                    [label release];
                }
                
                //self的frame
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 10+totalHeight)];
                
                m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, totalHeight) style:style];
                [m_TableView setBackgroundColor:[UIColor clearColor]];
                [m_TableView setBackgroundView:nil];
                [m_TableView setScrollEnabled:NO];
                [m_TableView setTableHeaderView:nil];
                [m_TableView setTableFooterView:nil];
                [m_TableView setDelegate:self];
                [m_TableView setDataSource:self];
                [self addSubview:m_TableView];
                
                if ([m_Delegate respondsToSelector:@selector(promotionTableSizeChanged:)]) {
                    [m_Delegate performSelector:@selector(promotionTableSizeChanged:) withObject:self];
                }
            }
        }];
    }
    return self;
}

#pragma mark - UITableView相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [mjArray count];
    } else if (section == 1) {
        return [m_NNArray count];
    } else {
        return [m_Array count];
    }
}

-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {//满减
        MobilePromotionVO *mobilePromotionVO = [OTSUtility safeObjectAtIndex:indexPath.row inArray:mjArray];
        if ([m_Delegate respondsToSelector:@selector(enterCashList:)]) {
            [m_Delegate enterCashList:mobilePromotionVO];
        }
    } else if (indexPath.section == 1) {//N元n件
        MobilePromotionVO *mobilePromotionVO = [OTSUtility safeObjectAtIndex:indexPath.row inArray:m_NNArray];
        if ([m_Delegate respondsToSelector:@selector(enterNNList:)]) {
            [m_Delegate enterNNList:mobilePromotionVO];
        }
    } else {//赠品
        if (indexPath.row == m_UnFoldIndexForGift) {
            m_UnFoldIndexForGift = -1;
        } else {
            m_UnFoldIndexForGift = indexPath.row;
        }
        
        //动画
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        
        //tableview的frame
        CGFloat cashTableHeight = 44.0*[mjArray count];
        CGFloat giftTableHeight = 44.0*[m_Array count];
        CGFloat offerTableHeight = 44.0*[m_NNArray count];
        CGFloat totalHeight = cashTableHeight + giftTableHeight + offerTableHeight + 35;
        
        CGRect frame = [tableView frame];
        if (m_UnFoldIndexForGift != -1) {
            MobilePromotionVO *giftVO = [OTSUtility safeObjectAtIndex:m_UnFoldIndexForGift inArray:m_Array];
            totalHeight += 90.0*[giftVO.productVOList count];
        }
        frame.size.height = totalHeight;
        [tableView setFrame:frame];
        
        //self的frame
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 10+totalHeight)];
        
        if ([m_Delegate respondsToSelector:@selector(promotionTableSizeChanged:)]) {
            [m_Delegate performSelector:@selector(promotionTableSizeChanged:) withObject:self];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//满减
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        MobilePromotionVO *mobilePromotionVO = [OTSUtility safeObjectAtIndex:indexPath.row inArray:mjArray];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 16, 16)];
        [imageView setImage:[UIImage imageNamed:@"manjian.png"]];
        [cell addSubview:imageView];
        [imageView release];
        
        //标题
        UILabel *label;
        label = [[UILabel alloc] initWithFrame:CGRectMake(40, 11, 180, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[mobilePromotionVO title]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        //查看商品
        [cell.detailTextLabel setText:@"活动商品"];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {//N元n件
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        MobilePromotionVO *mobilePromotionVO = [OTSUtility safeObjectAtIndex:indexPath.row inArray:m_NNArray];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 16, 16)];
        [imageView setImage:[UIImage imageNamed:@"hui"]];
        [cell addSubview:imageView];
        [imageView release];
        
        //标题
        UILabel *label;
        label = [[UILabel alloc] initWithFrame:CGRectMake(40, 11, 180, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[mobilePromotionVO title]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        //查看商品
        [cell.detailTextLabel setText:@"活动商品"];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    } else {//赠品
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        MobilePromotionVO *vo = [OTSUtility safeObjectAtIndex:indexPath.row inArray:m_Array];
        //赠
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 16, 16)];
        [imageView setImage:[UIImage imageNamed:@"zengpin.png"]];
        [cell addSubview:imageView];
        [imageView release];
        //标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 240, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:vo.title];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        if (indexPath.row == m_UnFoldIndexForGift) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(286, 17.5, 13, 9)];
            [imageView setImage:[UIImage imageNamed:@"cell_arrow_up.png"]];
            [cell addSubview:imageView];
            [imageView release];
            
            CGFloat yValue = 44.0;
            int i;
            for (i=0; i<[vo.productVOList count]; i++) {
                ProductVO *productVO = [OTSUtility safeObjectAtIndex:i inArray:vo.productVOList];
                //灰色背景
                UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(10, yValue, 300, 89)];
                [grayView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
                if (indexPath.row==[m_Array count]-1 && i==[vo.productVOList count]-1) {
                    [grayView.layer setCornerRadius:10.0];
                    UIView *subGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
                    [subGrayView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
                    [grayView addSubview:subGrayView];
                    [subGrayView release];
                }
                [cell addSubview:grayView];
                [grayView release];
                //分割线
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 1)];
                [line setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]];
                [grayView addSubview:line];
                [line release];
                
                //图片
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
                [imageView.layer setBorderWidth:1.0];
                [imageView.layer setBorderColor:[[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0] CGColor]];
                [imageView setImageWithURL:[NSURL URLWithString:productVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"img_default.png"]];
                [grayView addSubview:imageView];
                [imageView release];
                
                //名称
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 210, 40)];
                [name setBackgroundColor:[UIColor clearColor]];
                [name setNumberOfLines:2];
                [name setText:productVO.cnName];
                [name setFont:[UIFont systemFontOfSize:15.0]];
                [name setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
                [grayView addSubview:name];
                [name release];
                
                //市场价格
//                StrikeThroughLabel *marketPrice = [[StrikeThroughLabel alloc] initWithFrame:CGRectMake(80, 60, 60, 20)];
//                [marketPrice setBackgroundColor:[UIColor clearColor]];
//                [marketPrice setText:[NSString stringWithFormat:@"￥%.2f",[productVO.maketPrice floatValue]]];
//                [marketPrice setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//                [marketPrice setFont:[UIFont systemFontOfSize:14.0]];
//                [grayView addSubview:marketPrice];
//                [marketPrice release];
                
                //限量
                if (productVO.totalQuantityLimit != nil) {
                    UILabel *quantity = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 110, 20)];
                    [quantity setBackgroundColor:[UIColor clearColor]];
                    [quantity setText:[NSString stringWithFormat:@"%@",productVO.totalQuantityLimit]];
                    [quantity setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
                    [quantity setFont:[UIFont systemFontOfSize:14.0]];
                    [quantity setTextAlignment:NSTextAlignmentRight];
                    [grayView addSubview:quantity];
                    [quantity release];
                }
                
                //已领完
                if ([productVO.isSoldOut intValue] == 1) {
                    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(240, 0, 60, 60)];
                    [imageView setImage:[UIImage imageNamed:@"gift_nil.png"]];
                    [grayView addSubview:imageView];
                    [imageView release];
                    
                    [name setFrame:CGRectMake(80, 15, 170, 40)];
                }
                
                yValue+=89.0;
            }
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(286, 17.5, 13, 9)];
            [imageView setImage:[UIImage imageNamed:@"cell_arrow_down.png"]];
            [cell addSubview:imageView];
            [imageView release];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44.0;
    } else if (indexPath.section==1) {
        return 44.0;
    } else {
        MobilePromotionVO *vo=[OTSUtility safeObjectAtIndex:indexPath.row inArray:m_Array];
        if (indexPath.row==m_UnFoldIndexForGift) {
            return 44.0+90.0*[vo.productVOList count];
        } else {
            return 44.0;
        }
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_TableView);
    OTS_SAFE_RELEASE(_mobilePromotion);
    [super dealloc];
}
@end
