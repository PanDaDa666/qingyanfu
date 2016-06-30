//
//  RegisterView.m
//  QingYanFuYanWo
//

#import "RegisterView.h"
#import "Masonry.h"
#import "ZSXTextField.h"
#import "QCheckBox.h"

@interface RegisterView ()<UITextFieldDelegate>

@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = Gray_COLOR;
        [self customView];
    }
    return self;
}

- (void)customView{
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamicheader.jpg"]];
    [self addSubview:headImageView];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(1);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@((self.frame.size.width)*1/3.1));
    }];
    
    
    _pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pictureButton setBackgroundImage:[UIImage imageNamed:@"avatar_default"] forState:UIControlStateNormal];
    [_pictureButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    _pictureButton.layer.cornerRadius = ((self.frame.size.width)*1/3.1 -50)/2;
    _pictureButton.clipsToBounds = YES;
    _pictureButton.tag = kRegisterView_PictureButtonTag;
    [self addSubview:_pictureButton];
    [_pictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(headImageView.mas_height).offset(-50);
        make.height.equalTo(headImageView.mas_height).offset(-50);
    }];
    
    
    UIImageView *userNameLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ictab_me"]];
    [userNameLeftImageView sizeToFit];
    UITextField *userNameTextField = [self createTextFieldWithPlaceholder:@"请输入注册邮箱" passWord:NO leftImageView:userNameLeftImageView Font:18];
    userNameTextField.tag = kRegisterView_UserNameTag;
    userNameTextField.delegate = self;
    userNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:userNameTextField];
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIImageView *passWordLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pws_icon"]];
    [passWordLeftImageView sizeToFit];
    UITextField *passWordTextField=[self createTextFieldWithPlaceholder:@"请输入密码" passWord:YES leftImageView:passWordLeftImageView Font:18];
    passWordTextField.tag = kRegisterView_PassWordTag;
    passWordTextField.delegate = self;
    passWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:passWordTextField];
    [passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIImageView *secondPassWordLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pws_icon_hover"]];
    [secondPassWordLeftImageView sizeToFit];
    UITextField *secondPassWordTextField=[self createTextFieldWithPlaceholder:@"请再次输入密码" passWord:YES leftImageView:secondPassWordLeftImageView Font:18];
    secondPassWordTextField.tag = kRegisterView_SecondPassWordTag;
    secondPassWordTextField.delegate = self;
    secondPassWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:secondPassWordTextField];
    [secondPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIImageView *woyouImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ictab_me_selected"]];
    [woyouImageView sizeToFit];
    UITextField *woyouNameTextField=[self createTextFieldWithPlaceholder:@"请输入窝友名" passWord:NO leftImageView:woyouImageView Font:18];
    woyouNameTextField.tag = kRegisterView_WoyouNameTag;
    woyouNameTextField.delegate = self;
    woyouNameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    woyouNameTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:woyouNameTextField];
    [woyouNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondPassWordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    
    UIButton *registerbutton = [self createButtonWithNormalImage:@"bg_text_field"  AndTitle:@"注册" AndTitleColor:[UIColor whiteColor] AndTarget:self AndTag:kRegisterView_RegisterButtonTag];
    [self addSubview:registerbutton];
    [registerbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(woyouNameTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    
    QCheckBox *check = [[QCheckBox alloc] initWithDelegate:self];
    [check setTitle:@"我同意并阅读" forState:UIControlStateNormal];
    [check setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    check.tag =kRegisterView_CheckButtonTag;
    [self addSubview:check];
    [check setChecked:YES];
    
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerbutton.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX).offset(-30);
        make.width.equalTo(@(98));
        make.height.equalTo(@(40));
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = kRegisterView_ServiceButtonTag;
    [button setTitle:@"服务条款" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(check.mas_top);
        make.left.equalTo(check.mas_right);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
}

-(UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder passWord:(BOOL)yesOrNo leftImageView:(UIImageView *)imageView Font:(float)font{
    UITextField *myField = [[ZSXTextField alloc]init];
    myField.textAlignment = NSTextAlignmentLeft;
    myField.secureTextEntry = yesOrNo;
    myField.borderStyle = UITextBorderStyleNone;
    myField.autocapitalizationType = NO;
    myField.clearButtonMode = YES;
    myField.adjustsFontSizeToFitWidth= YES;
    myField.leftView = imageView;
    myField.leftViewMode = UITextFieldViewModeAlways;
    myField.font = [UIFont systemFontOfSize:font];
    myField.textColor = [UIColor blackColor];
    myField.backgroundColor = [UIColor whiteColor];
    myField.placeholder = placeholder;
    return myField;
}

- (UIButton*)createButtonWithNormalImage:(NSString *)normalImageName  AndTitle:(NSString *)title AndTitleColor:(UIColor*)color AndTarget:(id)target AndTag:(NSInteger)tag{
    UIImage *image = [UIImage imageNamed:normalImageName];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.titleLabel.textAlignment =1;
    return button;
}

- (void)onClick:(UIButton *)btn{
    [self endEditing:YES];
    if ([_delegate respondsToSelector:@selector(RegisterViewWithOnClick:)]) {
        [_delegate RegisterViewWithOnClick:btn];;
    }else{
        NSLog(@"未实现代理或者遵守协议");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(RegisterViewWithTextFiled:)]) {
        [_delegate RegisterViewWithTextFiled:textField];;
    }else{
        NSLog(@"未实现代理或者遵守协议");
    }
}

#pragma mark 键盘return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case kRegisterView_UserNameTag:
        {
            UITextField *registerPassWord = (id)[self viewWithTag:kRegisterView_PassWordTag];
            [registerPassWord becomeFirstResponder];
        }
            break;
        case kRegisterView_PassWordTag:
        {
            UITextField *registerTwoPassWord = (id)[self viewWithTag:kRegisterView_SecondPassWordTag];
            [registerTwoPassWord becomeFirstResponder];
        }
            break;
        case kRegisterView_SecondPassWordTag:
        {
            UITextField *registerWoyouName = (id)[self viewWithTag:kRegisterView_WoyouNameTag];
            [registerWoyouName becomeFirstResponder];
        }
            break;
        case kRegisterView_WoyouNameTag:
        {
            [textField resignFirstResponder];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
