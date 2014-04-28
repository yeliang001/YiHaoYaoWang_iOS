//
//  UseHelp.h
//  TheStoreApp
//
//  Created by lix on 11-3-1.
//  Copyright 2011 vsc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UseHelp : OTSBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView* containerView;                                          // 加载下面文字view的容器view
	//以下label承载了使用帮助的各项文字
	IBOutlet UILabel *selectOrder;//                                //选择订单;
	IBOutlet UILabel *modifyOrder;//                                //修改订单
	IBOutlet UILabel *cancelOrder;//                                //取消订单	
	IBOutlet UILabel *orderToken;//                                 //订单拆分	
	IBOutlet UILabel *postageCalculate;//                           //邮费计算		
	IBOutlet UILabel *PhoneBuyProduct;//                            //电话订购
	IBOutlet UILabel *NoRecProduct;//                               //没收到货物怎么办
	IBOutlet UITextView *HowReturnProduct;//                        //怎样退货
	IBOutlet UILabel *HowRecAndRejectProduct;//                     //怎样拒收与签收货物
	IBOutlet UIView* showView;//                                    //展示视图
	NSArray *UserHelpList;                                          //使用帮助列表
	IBOutlet UIButton *returnBtnInMainView;//                       //使用帮助主页的返回按钮
	IBOutlet UIButton *moreBtnInShowView;//                         //使用帮助个分页的更多按钮
	IBOutlet UIButton *frontBtnInShowView;//                        //使用帮助各分页的上一页按钮
    IBOutlet UITableView * table;
}
-(void)returnFront:(id)sender;                                      //返回使用帮助主页
-(void)returnMoreMainpage:(id)sender;                               //返回更多主页

@end
