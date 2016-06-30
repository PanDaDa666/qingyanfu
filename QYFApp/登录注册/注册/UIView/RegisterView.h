//
//  RegisterView.h
//  QingYanFuYanWo
//


#import <UIKit/UIKit.h>

@protocol RegisterViewDelegate  <NSObject>

- (void)RegisterViewWithOnClick:(UIButton *)btn;
- (void)RegisterViewWithTextFiled:(UITextField*)textField;
@end

@interface RegisterView : UIView
@property (nonatomic,assign)id<RegisterViewDelegate> delegate;
@property (nonatomic,strong)UIButton *pictureButton;
@end
