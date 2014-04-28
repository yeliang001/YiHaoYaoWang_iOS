//
//  PADTableViewColumnCell.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import <UIKit/UIKit.h>
@class PADTableViewColumnCell;

@protocol PADTableViewColumnCellDelegate

@optional
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell didSelectAtIndex:(NSInteger)index;
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell handelLongPress:(UILongPressGestureRecognizer*)aGesture;
@end

@interface PADTableViewColumnCell : UIView {
    id m_Delegate;
    NSArray *m_Array;
    NSInteger m_Index;
    UIImageView *m_BackgroundImage;
}
@property(nonatomic,readonly) UIImageView *backgroundImage;

-(id)initWithFrame:(CGRect)frame delegate:(id<PADTableViewColumnCellDelegate>)delegate;
-(void)updateWithArray:(NSArray *)array index:(NSInteger)index;
@end
