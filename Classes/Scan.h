//
//  Scan.h
//  TheStoreApp
//
//  Created by jiming huang on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderViewController.h"

@interface Scan : OTSBaseViewController<ZBarReaderDelegate>
{
    ZBarReaderViewController *closedCamer;					//取消条码扫描的视图控制器
    UIButton* cancelBtnInBarcode;
    BOOL barcodeRuning;
    NSArray* resultBarcodeAry;
    NSString *barcodeStr;									//条码结果字符串
    UIImageView *m_RedLine;
    OTSLoadingView *m_LoadingView;
}
@property(retain,nonatomic)NSString* celebrateWebUrl;
-(void)enterScan;
@end
