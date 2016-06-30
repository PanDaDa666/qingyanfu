//
//  ChartCellFrame.h
//  气泡
//


#import <Foundation/Foundation.h>
#import "ChartMessage.h"
@interface ChartCellFrame : NSObject
@property (nonatomic,assign) CGRect iconRect;
@property (nonatomic,assign) CGRect chartViewRect;
@property (nonatomic,strong) ChartMessage *chartMessage;
@property (nonatomic, assign) CGFloat cellHeight; //cell高度
@end
