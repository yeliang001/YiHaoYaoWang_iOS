//
//  PADCartViewController.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-16.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PADCartTableView.h"
#import "PADCartTabView.h"
#import "OtsPadLoadingView.h"
#import "PADCartFloatView.h"

@interface PADCartViewController : BaseViewController<PADCartTableViewDelegate,PADCartTabViewDelegate,PADCartFloatViewDelegate,UIScrollViewDelegate> {
    UIScrollView *m_ScrollView;
    CartVO *m_CartVO;
    PADCartTableView *m_CartTableView;
    PADCartTabView *m_CartTabView;
    PADCartFloatView *m_FloatView;
    BOOL m_UpdateTableView;
    BOOL m_UpdateTabView;
    BOOL m_UpdateFloatView;
    
    OtsPadLoadingView *m_LoadingView;
    
    UIView *m_FloatingView;
    CGPoint m_FloatingStartPoint;
    UIView *m_NilView;
    UIView *m_LoginView;
    LoginViewController *m_Login;
    UIView *m_LoginRegistView;
    BOOL m_NeedPopToRootWhenQuit;
    UIView *MallCartEntrance;
    UILabel *MallCartEntranceLab;
}

@property BOOL needShowTips;
@property BOOL isExiteGiftToBeUse;
@property (nonatomic, retain)    LoginViewController *m_Login;
-(BOOL)threadRunning;
@end
