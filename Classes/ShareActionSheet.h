//
//  ShareActionSheet.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiePang.h"
#import <MessageUI/MessageUI.h>

@interface ShareActionSheet : OTSBaseViewController<MFMessageComposeViewControllerDelegate, UIActionSheetDelegate> {
    NSString *m_ProductName;
    NSNumber *m_ProductPrice;
    NSNumber *m_ProductId;
    NSNumber *m_ProvinceId;
    BOOL m_IsExclusive;
    JiePang *m_JiePang;
}
-(void)shareProduct:(NSString *)productName price:(NSNumber *)productPrice productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId isExclusive:(BOOL)isExclusive;
@end
