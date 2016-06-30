//
//  LoginView.h
//  QingYanFuYanWo
//


#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

- (void)LoginViewWithOnClick:(UIButton *)btn;
- (void)LoginViewWithTextFiled:(UITextField*)textField;
@end

@interface LoginView : UIView

@property (nonatomic,assign)id<LoginViewDelegate> delegate;

@end
