//
//  ChartContentView.h
//  气泡


#import <UIKit/UIKit.h>
@class ChartContentView,ChartMessage;

@protocol ChartContentViewDelegate <NSObject>

-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content;
-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content;

@end

@interface ChartContentView : UIView
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) ChartMessage *chartMessage;
@property (nonatomic,assign) id <ChartContentViewDelegate> delegate;
@property (nonatomic,strong) UIImageView *playAudioImageView;
@property (nonatomic,strong) UILabel *playTimeLabel;
@end
