//
//  LoginView.m
//  QingYanFuYanWo
//



#import "Masonry.h"
#import "LoginView.h"
#import "ZSXTextField.h"

@interface LoginView ()<UITextFieldDelegate>
{
    UIImageView *_headImageView;
    UITextField *_userNameTextField;
    UITextField *_passWordTextField;
    UIButton *_loginButton;
}
@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Gray_COLOR;
        [self customView];
    }
    return self;
}

- (void)customView{
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_header"]];
    [self addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@((self.frame.size.width)*0.78/3.2));
    }];
    
    UIImageView *userNameLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ictab_me"]];
    [userNameLeftImageView sizeToFit];
    _userNameTextField = [self createTextFieldWithPlaceholder:@"在这里输入邮箱" passWord:NO leftImageView:userNameLeftImageView Font:18];
    _userNameTextField.tag = kLoginView_UserNameTag;
    _userNameTextField.delegate = self;
    _userNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIImageView *passWordLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pws_icon"]];
    [passWordLeftImageView sizeToFit];
    _passWordTextField=[self createTextFieldWithPlaceholder:@"请输入密码" passWord:YES leftImageView:passWordLeftImageView Font:18];
    _passWordTextField.tag = kLoginView_PassWordTag;
    _passWordTextField.delegate = self;
    _passWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_passWordTextField];
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTextField.mas_bottom).offset(1);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIButton *registerbutton = [self createButtonWithNormalImage:@"bg_text_field_mono_light_gray_boarder"  AndTitle:@"注册" AndTitleColor:[UIColor blackColor] AndTarget:self AndTag:kLoginView_RegisterButtonTag];
    [self addSubview:registerbutton];
    [registerbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX).offset(-60);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    _loginButton = [self createButtonWithNormalImage:@"bg_text_field"  AndTitle:@"登录" AndTitleColor:[UIColor whiteColor] AndTarget:self AndTag:kLoginView_LoginButtonTag];
    _loginButton.enabled = NO;
    [self addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX).offset(60);
        make.width.equalTo(@(100));
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
    _headImageView.image = [UIImage imageNamed:@"login_header"];
    if ([_delegate respondsToSelector:@selector(LoginViewWithOnClick:)]) {
        [_delegate LoginViewWithOnClick:btn];;
    }else{
        NSLog(@"未实现代理或者遵守协议");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_userNameTextField.text.length>=6) {
        if (_passWordTextField.text.length>=6) {
            _loginButton.enabled=YES;
        }else{
           _loginButton.enabled = NO;
        }
        
    }else{
        _loginButton.enabled=NO;
    }
    _headImageView.image = [UIImage imageNamed:@"login_header"];
    if ([_delegate respondsToSelector:@selector(LoginViewWithTextFiled:)]) {
        [_delegate LoginViewWithTextFiled:textField];;
    }else{
        NSLog(@"未实现代理或者遵守协议");
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag==kLoginView_PassWordTag) {
        _headImageView.image = [UIImage imageNamed:@"login_header_cover_eyes"];
    }else{
        _headImageView.image = [UIImage imageNamed:@"login_header"];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
    _headImageView.image = [UIImage imageNamed:@"login_header"];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case kLoginView_UserNameTag:
        {
            UITextField *passwordTextField = (id)[self viewWithTag:kLoginView_PassWordTag];
            [passwordTextField becomeFirstResponder];
        }
            break;
        case kLoginView_PassWordTag:
        {
            [textField resignFirstResponder];
        }
            break;
        default:
            break;
    }
    return YES;
}
@end
