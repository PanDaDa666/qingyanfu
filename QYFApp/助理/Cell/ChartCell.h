//
//  ChartCell.h
//  气泡


#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ChartContentView.h"
@class ChartCell;

@protocol ChartCellDelegate <NSObject>

-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content;

@end

#import "ChartCellFrame.h"
@interface ChartCell : UITableViewCell
@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) ChartCellFrame *cellFrame;
@property (nonatomic,assign) id<ChartCellDelegate> delegate;
@end
