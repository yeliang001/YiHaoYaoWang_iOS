//
//  PADTableViewCell.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import <UIKit/UIKit.h>
#import "PADTableViewColumnCell.h"

@class PADTableViewCell;

@protocol PADTableViewCellDelegate

@required
-(NSInteger)tableViewCellNumberOfColumns:(PADTableViewCell *)cell;
-(PADTableViewColumnCell *)tableViewCell:(PADTableViewCell *)cell columnCellAtIndex:(NSInteger)index;

@end

@interface PADTableViewCell : UITableViewCell {
    NSMutableArray *m_ColumnCellArray;
    int m_ColumnCount;
    int m_IndexInTable;
    id m_Delegate;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PADTableViewCellDelegate>)delegate;
-(void)updateWithArray:(NSArray *)array index:(NSInteger)index;
@end
