//
//  ChartCellFrame.m
//  气泡
//

#define kIconMarginX 5
#define kIconMarginY 5

#import "ChartCellFrame.h"

@implementation ChartCellFrame

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    _chartMessage=chartMessage;
    
    CGSize winSize=[UIScreen mainScreen].bounds.size;
    CGFloat iconX=kIconMarginX;//5
    CGFloat iconY=kIconMarginY;//5
    CGFloat iconWidth=40;
    CGFloat iconHeight=40;
    
    if(!chartMessage.messageType){
      
    }else if (chartMessage.messageType){
        iconX=winSize.width-kIconMarginX-iconWidth;
    }
    self.iconRect=CGRectMake(iconX, iconY, iconWidth, iconHeight);
    
    if (chartMessage.messageMediaType == kAVIMMessageMediaTypeText) {
        CGFloat contentX=CGRectGetMaxX(self.iconRect)+kIconMarginX;
        CGFloat contentY=iconY;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
        CGSize contentSize=[chartMessage.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        if(chartMessage.messageType){
            
            contentX=iconX-kIconMarginX-contentSize.width-iconWidth;
        }
        self.chartViewRect=CGRectMake(contentX, contentY, contentSize.width+35, contentSize.height+30);
        
        self.cellHeight=MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect))+kIconMarginX;
    }else if(chartMessage.messageMediaType ==kAVIMMessageMediaTypeImage){
        CGFloat contentX=CGRectGetMaxX(self.iconRect)+kIconMarginX;
        CGFloat contentY=iconY;
        CGSize contentSize = CGSizeMake(200, 200);
        if(chartMessage.messageType){
            contentX=iconX-kIconMarginX-contentSize.width-iconWidth;
        }
        self.chartViewRect=CGRectMake(contentX, contentY, contentSize.width+35, contentSize.height+30);
        
        self.cellHeight=MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect))+kIconMarginX;
    }else if(chartMessage.messageMediaType ==kAVIMMessageMediaTypeAudio){
        CGFloat contentX=CGRectGetMaxX(self.iconRect)+kIconMarginX;
        CGFloat contentY=iconY;
        CGFloat W = 90+2*chartMessage.playTime;
        CGSize contentSize = CGSizeMake(W, 20);
        if(chartMessage.messageType){
            contentX=iconX-kIconMarginX-contentSize.width-iconWidth;
        }
        self.chartViewRect=CGRectMake(contentX, contentY, contentSize.width+35, contentSize.height+25);
        
        self.cellHeight=MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect))+kIconMarginX;
    }
    
    
    
}
@end
