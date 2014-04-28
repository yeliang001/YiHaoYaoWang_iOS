//
//  UserBackView.h
//  yhd
//
//  Created by dev dev on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface UserBackView : BaseView<UITextViewDelegate>
{
    IBOutlet UITextView * mTextView;
    IBOutlet UILabel * mLabel;
}
-(IBAction)SubmitClicked:(id)sender;
@end
