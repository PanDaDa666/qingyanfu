//
//  LoginViewController.m
//  QingYanFuYanWo
//


#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginView.h"
#import "ZSXAlertLabel.h"

@interface LoginViewController ()<LoginViewDelegate,UIAlertViewDelegate>
@property (nonatomic,copy)NSString *UserName;
@property (nonatomic,copy)NSString *UserPassWord;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)ZSXAlertLabel *alertLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Gray_COLOR;
    [self initNavigationBar];
    [self configUI];
    
}

- (void)initNavigationBar{
    [self setNavigationTitle:@"登录"];
    [self initWithLeftBarButton:nil AndBackImageName:@"icnav_close_light" AndTarget:self Andselector:@selector(onLeftClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"忘记密码" style:UIBarButtonItemStyleDone target:self action:@selector(onRightClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)onLeftClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onRightClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"找回密码" message:@"请输入邮箱" delegate:self cancelButtonTitle:@"申请" otherButtonTitles:@"取消", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.view addSubview:alert];
    [alert show];
}

- (void)configUI{
    LoginView *loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

- (void)LoginViewWithOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case kLoginView_LoginButtonTag:
        {
            [self.hud show:YES];
            [AVUser logInWithUsernameInBackground:_UserName password:_UserPassWord block:^(AVUser *user, NSError *error) {
                    [self.hud hide:YES];
                if (user) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEIMAGE" object:nil userInfo:@{@"image":@"0"}];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.alertLabel show:@"亲- - ！登录失败"];
                    });
                }
            }];

        }
            break;
        case kLoginView_RegisterButtonTag:
        {
            RegisterViewController *reg = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:reg animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)LoginViewWithTextFiled:(UITextField *)textField{
    switch (textField.tag) {
        case kLoginView_UserNameTag:
        {
            _UserName = textField.text;
        }
            break;
        case kLoginView_PassWordTag:
        {
            _UserPassWord = textField.text;
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex == 0) {
        [self.hud show:YES];
        [AVUser requestPasswordResetForEmailInBackground:[alertView textFieldAtIndex:0].text block:^(BOOL succeeded, NSError *error) {
            [self.hud hide:YES];
            if (succeeded) {
                [self.alertLabel show:@"亲- -！发送邮箱成功"];
            }else{
                [self.alertLabel show:@"亲- -！发送邮箱失败"];
            }
        }];
    }
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.color=[UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.80];
        _hud.labelText = @"登录中...";
    }
    return _hud;
}

- (ZSXAlertLabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[ZSXAlertLabel alloc] initWithFrame:CGRectMake((kScreenWidth-250)/2,(kScreenHeight-30)/2, 250, 30)];
        [self.view addSubview:self.alertLabel];
    }
    return _alertLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
