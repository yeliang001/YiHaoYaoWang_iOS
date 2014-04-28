//
//  OTSAddMinusTextField.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-19.
//
//

#import <UIKit/UIKit.h>

@class OTSAddMinusTextField;

@protocol OTSAddMinusTextFieldDelegate
@required
-(void)textField:(OTSAddMinusTextField*)aTextField addOrMinus:(BOOL)anAddOrMinus;
@end

@interface OTSAddMinusTextField : UIView
@property (retain, nonatomic) IBOutlet UITextField *txtFd;
@property (retain, nonatomic) IBOutlet UIButton *btnAdd;
@property (retain, nonatomic) IBOutlet UIButton *btnMinus;

@property NSUInteger    count;
@property (assign) id<OTSAddMinusTextFieldDelegate> delegate;

-(IBAction)addAction:(id)sender;
-(IBAction)minusAction:(id)sender;

@end
