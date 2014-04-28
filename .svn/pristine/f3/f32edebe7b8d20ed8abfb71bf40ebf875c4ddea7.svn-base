//
//  OTSPhoneWeRockInventoryVC.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import <UIKit/UIKit.h>
#import "OTSPhoneWeRockBaseVC.h"


@interface OTSPhoneWeRockInventoryVC : OTSPhoneWeRockBaseVC
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    id  _quitTaget;
    SEL _quitAction;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *emptyView;

-(void)setQuitTaget:(id)aTaget action:(SEL)anAction;
-(IBAction)rockBtnClicked:(id)sender;


@end



