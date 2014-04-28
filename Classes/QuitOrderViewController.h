//
//  QuitOrderViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 13-3-11.
//
//

#import <UIKit/UIKit.h>
@interface QuitOrderViewController : OTSBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UITableView* table;
    UITableView* tbv;
    BOOL isGroup;
    NSMutableArray* photosArray;//上传照片的数组
    NSMutableArray* productArray;//修改后的商品数组
    NSMutableArray* selectedIMGArray;
    UIImagePickerController *cameraPicker;
    UIImagePickerController *imagePicker;
    UIButton* albumDone;
}
@property(nonatomic,assign)BOOL isGroup;
@end
