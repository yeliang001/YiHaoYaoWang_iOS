//
//  OrderTrackCell.h
//  yhd
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOrderDetailTableViewWidth 367
@interface OrderTrackCell : UITableViewCell{
    NSInteger height;
    NSInteger row;
    UILabel *nameLabel;
}
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger row;
@property (nonatomic,retain)UILabel *nameLabel;
@end
