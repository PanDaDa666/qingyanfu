//
//  RegisterViewController.m
//  QingYanFuYanWo
//


#import "RegisterViewController.h"
#import "RegisterView.h"
#import "QCheckBox.h"
@interface RegisterViewController ()<RegisterViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CNPPopupControllerDelegate>
{
    RegisterView *_registerView;
    NSString *_registerName;
    NSString *_registerPassWord;
    NSString *_registerTwoPassWord;
    NSString *_registerWoyouName;
    QCheckBox *_check;
}
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)ZSXAlertLabel *alertLabel;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Gray_COLOR;
    [self initNavigationBar];
    [self configUI];
   
}

- (void)initNavigationBar{
    [self setNavigationTitle:@"注册"];
    [self initWithLeftBarButton:nil AndBackImageName:@"icnav_close_light" AndTarget:self Andselector:@selector(onLeftClick)];
   
}

- (void)configUI{
    _registerView= [[RegisterView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _registerView.delegate = self;
    [self.view addSubview:_registerView];
}

- (void)onLeftClick{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)RegisterViewWithTextFiled:(UITextField *)textField{
    switch (textField.tag) {
        case kRegisterView_UserNameTag:
            _registerName=textField.text;
            break;
        case kRegisterView_PassWordTag:
            _registerPassWord=textField.text;
            break;
        case kRegisterView_SecondPassWordTag:
            _registerTwoPassWord=textField.text;
            break;
        case kRegisterView_WoyouNameTag:
            _registerWoyouName=textField.text;
            break;
        default:
            break;
    }
}

- (void)RegisterViewWithOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case kRegisterView_ServiceButtonTag:{
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"确定" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"服务条款" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:22], NSForegroundColorAttributeName : [UIColor blackColor], NSParagraphStyleAttributeName : paragraphStyle}];
            NSAttributedString *content = [[NSAttributedString alloc] initWithString:@"尊敬的用户,欢迎阅读本协议:\n本公司依据本协议的规定提供服务,本协议具有合同效力。您必须完全同意以下所有条款并完成个人资料的填写,才能保证享受到更好的客服服务。您使用服务的行为将视为对本协议的接受,并同意接受本协议各项条款的约束。\n用户必须合法使用网络服务,不作非法用途,自觉维护本网站和/或程序的声誉,遵守所有使用网络服务的网络协议、规定、程序和惯例。\n为更好的为用户服务,用户应向本网站和/或程序提供真实、准确的个人资料,个人资料如有变更,应立即修正;如因用户提供的个人资料不实或不准确,给用户自身造成任何性质的损失,均由用户自行承担。\n尊重个人隐私是本公司的责任,本公司在未经用户授权时不得向第三方(本公司控股或关联、运营合作单位除外)公开、编辑或透露用户个人资料的内容,但由于政府要求、法律政策需要等原因除外。在用户发送信息的过程中和本网站和/或程序收到信息后,本网站和/或程序将遵守行业通用的标准来保护用户的私人信息,但是任何通过因特网发送的信息或电子版本的存储方式都无法确保100%的安全性,因此,本网站和/或程序会尽力使用商业上可接受的方式来保护用户的个人信息,但不对用户信息的安全作任何担保。\n本网站和/或程序有权在必要时修改服务条例和/或本协议内容,本网站和/或程序的服务条例和/或本协议内容一旦发生变动,将会在本网站和/或程序的重要页面上提示修改内容,用户如不同意新的修改内容,须立即停止使用本协议约定的服务,否则视为用户完全同意并接受新的修改内容。根据客观情况及经营方针的变化,本网站和/或程序有中断或停止服务的权利,用户对此表示理解并完全认同。\n本公司拥有本用户注册及隐私保护协议的所有权并有权在法律允许的范围内解释。" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName : [UIColor blackColor], NSParagraphStyleAttributeName : paragraphStyle}];
            CNPPopupController *popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[content] buttonTitles:@[buttonTitle] destructiveButtonTitle:nil];
            popupController.theme = [CNPPopupTheme defaultTheme];
            popupController.theme.popupStyle = CNPPopupStyleCentered;
            popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
            popupController.theme.dismissesOppositeDirection = YES;
            popupController.delegate = self;
            [popupController presentPopupControllerAnimated:YES];
        }
            break;
        case kRegisterView_PictureButtonTag:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];;
            [self.view addSubview:actionSheet];
            [actionSheet showInView:self.view];
        }
            break;
        case kRegisterView_RegisterButtonTag:{
            _check = (QCheckBox *)[self.view viewWithTag:kRegisterView_CheckButtonTag];
            if (!_registerName||!_registerPassWord||!_registerTwoPassWord||!_registerWoyouName) {
                [self.alertLabel show:@"亲- - ！填写完整"];
                return;
            }
            //判断密码一样
            if(_registerPassWord.intValue!=_registerTwoPassWord.intValue){
                [self.alertLabel show:@"亲- - ！两密码不一样"];
                return;
            }
            //判断密码六位以上
            if([_registerPassWord length]<6){
               [self.alertLabel show:@"亲- - ！密码6位以上"];
                return;
            }
            if (_check.selected==NO) {
                [self.alertLabel show:@"亲- - ！请遵守协议"];
                return;
            }
            [self.hud show:YES];
            NSData *pictureData = UIImagePNGRepresentation([_registerView.pictureButton backgroundImageForState:UIControlStateNormal]);
            AVFile *headImageFile = [AVFile fileWithName:@"image" data:pictureData];
            [headImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    AVUser *user = [AVUser user];
                    user.username = _registerName;
                    user.password = _registerPassWord;
                    user.email = _registerName;
                    [user setObject:_registerWoyouName forKey:@"WoyouName"];
                    [user setObject:headImageFile forKey:@"HeadImage"];
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            [AVUser logInWithUsernameInBackground:_registerName password:_registerPassWord block:^(AVUser *user, NSError *error) {
                                
                                if (user) {
                                    [self.hud hide:YES];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEIMAGE" object:nil userInfo:@{@"image":@"0"}];
                                }
                                else{
                                    //连接失败警告
                                    [self.alertLabel show:@"亲- - ！登录失败"];
                                    [self.hud hide:YES];
                                }
                            }];
                            
                            
                        }else{
                            [self.hud hide:YES];
                            [self.alertLabel show:@"亲- - ！注册失败"];
                            
                        }
                    }];
                }else{
                    [self.hud hide:YES];
                    [self.alertLabel show:@"亲- - ！头像上传失败"];
                }
            }];
        }
            break;
        default:
            break;
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate =self;
    [imagePicker setAllowsEditing:YES];
    switch (buttonIndex) {
        case 0:
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController:imagePicker animated:NO completion:^{
            }];
        }
            break;
        case 1:
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:imagePicker animated:NO completion:^{
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark 相册协议
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:^{
        [_registerView.pictureButton setBackgroundImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
    }];
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.color=[UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.80];
        _hud.labelText = @"注册中...";
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
