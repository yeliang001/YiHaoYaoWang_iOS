//
//  GroupService.m
//  TheStoreApp
//
//  Created by LinPan on 13-12-23.
//
//

#import "GroupService.h"
#import "ResultInfo.h"
#import "ResponseInfo.h"
#import "ProductInfo.h"
@implementation GroupService


- (ResultInfo *)getGroupList:(NSDictionary *)dic
{
    ResponseInfo *response = [self startRequestWithMethod:@"group.purchase" param:dic];
    NSDictionary *dataDic = response.data;
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    ResultInfo *result = [[ResultInfo alloc] init];
    result.responseCode = response.statusCode;
    result.resultCode = [dataDic[@"result"] intValue];
    result.bRequestStatus = response.isSuccessful;
    result.recordCount = [dataDic[@"recordcount"] intValue];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSMutableArray *groupList = dataDic[@"btocg_product"];
        
        if ([groupList isKindOfClass:[NSMutableArray class]] &&  groupList != nil && groupList.count >0)
        {
            for (NSDictionary *dic in groupList)
            {
                ProductInfo *product = [[ProductInfo alloc] init];
                product.soldAmmont = [dic[@"amount_sold"] intValue];
                product.startTime = dic[@"start_timeStr"];
                product.endTime = dic[@"end_timeStr"];
                product.groupStatus = [dic[@"group_status"] intValue];
                product.groupTitle = dic[@"groupgift"];
                product.productId = [NSString stringWithFormat:@"%d",[dic[@"product_id"] intValue]];
                product.priceGroup = [dic[@"price_group"] floatValue];
                product.priceOriginal = [dic[@"price_original"] floatValue];
                
                [resultList addObject:product];
            }
            result.resultObject = resultList;
        }
        
        
    }
    return result;
}

@end
