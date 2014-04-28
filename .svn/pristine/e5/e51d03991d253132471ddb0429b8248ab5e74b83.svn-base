//
//  PADTableViewCell.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import "PADTableViewCell.h"

@implementation PADTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<PADTableViewCellDelegate>)delegate
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        m_Delegate=delegate;
        m_ColumnCellArray=[[NSMutableArray alloc] initWithCapacity:0];
        m_ColumnCount=[m_Delegate tableViewCellNumberOfColumns:self];
        int i;
        for (i=0; i<m_ColumnCount; i++) {
            PADTableViewColumnCell *cell=[m_Delegate tableViewCell:self columnCellAtIndex:i];
            CGFloat width=cell.frame.size.width;
            CGFloat height=cell.frame.size.height;
            [cell setFrame:CGRectMake(width*i, 0, width, height)];
            [self addSubview:cell];
            
            [m_ColumnCellArray addObject:cell];
        }
    }
    return self;
}

-(void)updateWithArray:(NSArray *)array index:(NSInteger)index
{
    m_IndexInTable=index;
    int i;
    for (i=0; i<m_ColumnCount; i++) {
        PADTableViewColumnCell *cell=[m_ColumnCellArray objectAtIndex:i];
        if (m_ColumnCount*m_IndexInTable+i<[array count]) {
            [cell setHidden:NO];
        } else {
            [cell setHidden:YES];
        }
        [cell updateWithArray:array index:m_ColumnCount*m_IndexInTable+i];
    }
}

-(void)dealloc
{
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_ColumnCellArray);
    [super dealloc];
}

@end
