//
//  GameViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-10-31.
//
//

#import <UIKit/UIKit.h>
#import "GameBaseViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "RockGameProductVO.h"
#import "RockGameVO.h"
@interface GameViewController : GameBaseViewController<ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate>{
    UIImageView*icon;
    UILabel*friendName;
    UILabel*friendPhone;
    UIImageView*statusImg;
    UIActivityIndicatorView* act;
    UILabel* emptyLab;
    NSMutableArray* presentsArray;
    NSMutableArray* giftBtnArray;
    RockGameProductVO* selectedRGPV;
    BOOL selFriend,checkOK;
    UIImageView* infoView;
    UILabel* infoLab;
}
@end
