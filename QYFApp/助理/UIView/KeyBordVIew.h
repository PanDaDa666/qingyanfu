//
//  KeyBordVIew.h
//  气泡
//


#import <UIKit/UIKit.h>

@class KeyBordVIew;

@protocol KeyBordVIewDelegate <NSObject>

-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled;
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled;
-(void)beginRecord;
-(void)finishRecordWithTime:(NSInteger)playTime;
-(void)failRecord;
- (void)chooseImage;
@end

@interface KeyBordVIew : UIView
@property (nonatomic,assign) id<KeyBordVIewDelegate>delegate;
@end
