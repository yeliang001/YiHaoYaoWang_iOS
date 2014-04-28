//
//  OTSPopViewController.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum {
    PopSortType,
    PopCategoryType
} PopViewControllerType;

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol OTSPopViewControllerDelegate <NSObject>
/*@required
-(void)itemSelectedWithData:(id)data type:(PopViewControllerType)type;*/
@end

@interface OTSPopViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
    PopViewControllerType m_Type;
    UITableView *m_TableView;
    NSArray *m_DataArray;
    id<OTSPopViewControllerDelegate> m_Delegate;
    int m_CurrentSelectedIndex;
}
@property(nonatomic,assign) id<OTSPopViewControllerDelegate> delegate;
@property(nonatomic,retain) NSArray *dataArray;
@property(nonatomic,assign) int currentIndex;

-(id)initWithType:(PopViewControllerType)type;
@end
