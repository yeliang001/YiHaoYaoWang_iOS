//
//  OTSShare.h
//  TheStoreApp
//
//  Created by jiming huang on 12-11-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductVO;
@class ProductInfo;
@interface OTSShare : NSObject<MFMessageComposeViewControllerDelegate> {
    ProductVO *m_ProductVO;
}

+(OTSShare *)sharedInstance;
-(void)shareToBlogWithProduct:(ProductInfo *)productVO delegate:(id)delegate;
-(void)shareToBlogWithString:(NSString *)string delegate:(id)delegate;
-(void)shareToJiePangWithProduct:(ProductVO *)productVO delegate:(id)delegate;
-(void)shareToMessageWithProduct:(ProductInfo *)productVO delegate:(id)delegate;
@end
