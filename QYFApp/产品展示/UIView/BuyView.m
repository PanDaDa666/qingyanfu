//
//  BuyView.m
//  QingYanFuYanWo
//


#import "BuyView.h"
#import "Masonry.h"
#import "ZSXTextField.h"

@interface BuyView ()<UITextFieldDelegate>
{
    UIImageView *_headImageView;
    UITextField *_userNameTextField;
    UITextField *_addressTextField;
    UITextField *_phoneTextField;
}

@end

@implementation BuyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self configUI];
    }
    return self;
}

- (void)configUI{
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qingyanfu"]];
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(kScreenWidth/3));
        make.height.equalTo(@(kScreenWidth/3));
    }];
    
    
    
    UIImageView *userNameLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ictab_me"]];
    [userNameLeftImageView sizeToFit];
    _userNameTextField = [self createTextFieldWithPlaceholder:@":在这里输入姓名" passWord:NO leftImageView:userNameLeftImageView Font:18];
    _userNameTextField.tag = kBuyView_UserNameTag;
    _userNameTextField.delegate = self;
    _userNameTextField.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIImageView *addressLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ictab_homepage"]];
    [addressLeftImageView sizeToFit];
    _addressTextField=[self createTextFieldWithPlaceholder:@":在这里输入地址" passWord:NO leftImageView:addressLeftImageView Font:18];
    _addressTextField.tag = kBuyView_AddressTag;
    _addressTextField.delegate = self;
    _addressTextField.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_addressTextField];
    [_addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    UIImageView *phoneLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipsbar_icon_phone"]];
    [phoneLeftImageView sizeToFit];
    _phoneTextField=[self createTextFieldWithPlaceholder:@":请输入手机号" passWord:NO leftImageView:phoneLeftImageView Font:18];
    _phoneTextField.tag = kBuyView_PhoneTag;
    _phoneTextField.delegate = self;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(40));
    }];
    
    _storeInfoLabel = [[UILabel alloc] init];
    _storeInfoLabel.textColor = [UIColor redColor];
    _storeInfoLabel.backgroundColor = [UIColor clearColor];
    _storeInfoLabel.textAlignment = 1;
    _storeInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_storeInfoLabel];
    [_storeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(kScreenWidth-40));;
        make.height.equalTo(@(40));
    }];
    
    UIButton *registerbutton = [self createButtonWithNormalImage:@"bg_text_field_mono_light_gray_boarder"  AndTitle:@"确定" AndTitleColor:[UIColor blackColor] AndTarget:self AndTag:kBuyView_buttonTag];
    [self addSubview:registerbutton];
    [registerbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storeInfoLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
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
    if ([_delegate respondsToSelector:@selector(buyViewWithOnClick)]) {
        [_delegate buyViewWithOnClick];
    }else {
        NSLog(@"没有遵守协议或者代理");
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
