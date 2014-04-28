//
//  ScanResult.h
//  TheStoreApp
//
//  Created by jiming huang on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSBaseViewController.h"
#import "mobidea4ec.h"
#import "RecommendView.h"

@interface ScanResult : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,recommendViewDelegate,mobideaRecProtocol> {
    NSMutableDictionary *m_InputDictionary;//传入参数
    NSArray *m_ProductArray;//扫描到的所有商品
    NSString *m_BarCodeString;//条码字符串
    UITableView *m_TableView;
    BOOL m_ThreadRunning;
    
    
    RecommendView *_recommendView;
    
}

@property(nonatomic,retain)NSMutableDictionary *m_InputDictionary;//传入参数

-(void)initScanResult;

@end
