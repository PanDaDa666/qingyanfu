//
//  LeftViewController.m
//  QingYanFuYanWo
//


#import "LeftViewController.h"
#import "UIButton+WebCache.h"
#import "ButtonTableViewCell.h"
#import "BuyInfoViewController.h"
#import "ScanQRViewController.h"
#import "AskDuNiangViewController.h"
#import "MapViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_btnNameArray;
    NSArray *_btnImageArray;
    UIImageView *_backImageView;
    NSString *_userCurrentPassWord;
}
@property (nonatomic,strong)UIAlertView *alertView;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnNameArray = @[@[@"修改密码",@"订单详情",@"清理缓存",@"登出"],@[@"扫二维码",@"不懂问度娘",@"看看你在哪"]];
    _btnImageArray = @[@[@"iconfont-mima-2",@"iconfont-shangpinshoudai-17",@"iconfont-qingkongshanchu-17",@"iconfont-duocengjiegou-2"],@[@"iconfont-params-2",@"iconfont-world-2",@"iconfont-bangzhu-17"]];
    [self configUI];
}

- (void)configUI{
    [self createHeadButton];
    [self createTableView];
}


- (void)createHeadButton{
    _backImageView = [[UIImageView alloc] initWithFrame:kScreenBounds];
    _backImageView.image = [UIImage imageNamed:@"DBE`HF[M~LSL50PT)NAC6GL.jpg"];
    _backImageView.userInteractionEnabled = YES;
    [self.view addSubview:_backImageView];
    _headButton = [[UIButton alloc] init];
    _headButton.frame = CGRectMake(0, 0, kScreenWidth/6, kScreenWidth/6);
    _headButton.center = CGPointMake(kScreenWidth/3, kScreenHeight/10);
    AVFile *headImage = (AVFile *)[[AVUser currentUser]
                                   objectForKey:@"HeadImage"];
    [_headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[headImage getThumbnailURLWithScaleToFit:YES width:180 height:180]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"hd_avatar_not_login"]];
    _headButton.layer.cornerRadius =kScreenWidth/12;
    _headButton.clipsToBounds = YES;
    [_headButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_headButton];
    UILabel *label = [[UILabel alloc] init];
    label.text = [[AVUser currentUser] objectForKey:@"WoyouName"];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = 1;
    [_backImageView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headButton.mas_centerX);
        make.width.equalTo(@(kScreenWidth/3));
        make.height.equalTo(@(30));
        make.top.equalTo(_headButton.mas_bottom).offset(10);
    }];
}

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight/4, 2*kScreenWidth/3, kScreenHeight*3/4) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ButtonTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ButtonTableViewCell"];
    [_backImageView addSubview:_tableView];
    
}

- (void)onClick:(UIButton *)btn{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];;
    [self.view addSubview:actionSheet];
    [actionSheet showInView:self.view];
}



#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate =self;
    [imagePicker setAllowsEditing:YES];
    switch (buttonIndex) {
        case 0:
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:NO completion:^{
                
            }];
        }
            break;
        case 1:
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:NO completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark imagePickerControllDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSData *pictureData = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"]);
    AVFile *headImageFile = [AVFile fileWithName:@"image" data:pictureData];
    [headImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [[AVUser currentUser] setObject:headImageFile forKey:@"HeadImage"];
            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEIMAGE" object:nil userInfo:@{@"image":@"0"}];

                }else{
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"o(╯□╰)o 头像修改失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
                    [alert show];
                }
            }];
            
        }else{
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"o(╯□╰)o 上传失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
            [alert show];
        }
    }];

    [_headButton setBackgroundImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _btnNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_btnNameArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.btnNameLabel.text = _btnNameArray[indexPath.section][indexPath.row];
    cell.btnImageView.image = [UIImage imageNamed:_btnImageArray[indexPath.section][indexPath.row]];
    UIView *seView = [[UIView alloc] initWithFrame:cell.bounds];
    seView.backgroundColor = [UIColor clearColor];
    seView.alpha = 0.1;
    cell.selectedBackgroundView = seView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section){
        switch (indexPath.row) {
            case 0:
            {
                ScanQRViewController *scanVC = [[ScanQRViewController alloc]init];
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:scanVC];
                [self presentViewController:na animated:YES completion:nil];
            }
                break;
            case 1:{
                AskDuNiangViewController *ask = [[AskDuNiangViewController alloc]init];
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:ask];
                [self presentViewController:na animated:YES completion:nil];
            }
                break;
            case 2:{
                MapViewController *map = [[MapViewController alloc] init];
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:map];
                [self presentViewController:na animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            //修改密码
            case 0:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"第一步" message:@"请输入当前密码" delegate:self cancelButtonTitle:@"下一步" otherButtonTitles:@"取消", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [self.view addSubview:alert];
                alert.tag = kLeftViewController_CurrentPassWordAlertTag;
                [alert show];
            }
                break;
            case 1:{
                BuyInfoViewController *buy = [[BuyInfoViewController alloc] init];
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:buy];
                [self presentViewController:na animated:YES completion:nil];
            }
                break;
            case 2:
            {
                [AVFile clearAllCachedFiles];
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    NSLog(@"已清除");
                }];
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"#^_^# 缓存已清空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
                [alert show];
                
            }
                break;
            case 3:
            {
                [AVUser logOut];
                AppDelegate *delegate =[UIApplication sharedApplication].delegate;
                JVFloatingDrawerViewController *jvfVc =(JVFloatingDrawerViewController *) delegate.window.rootViewController;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGEIMAGE" object:nil userInfo:@{@"image":@"0"}];
                [jvfVc closeDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:^(BOOL finished) {
                    
                }];
                
            }
                break;
            default:
                break;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *array = @[@"个人",@"小工具"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2*kScreenWidth/3, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 2*kScreenWidth/3, 40)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = array[section];
    [view addSubview:label];
    return view ;
}
//返回每个分组的头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //修改密码第一步的下一步按钮
    if (alertView.tag == kLeftViewController_CurrentPassWordAlertTag) {
        if (buttonIndex == 0) {
            _userCurrentPassWord = [alertView textFieldAtIndex:0].text;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"第二步" message:@"请输入新密码" delegate:self cancelButtonTitle:@"申请" otherButtonTitles:@"取消", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = kLeftViewController_NowPassWordAlertTag;
            [self.view addSubview:alert];
            [alert show];
        }
    }
    else if(alertView.tag == kLeftViewController_NowPassWordAlertTag){
        if (buttonIndex ==0) {
            [[AVUser currentUser] updatePassword:_userCurrentPassWord newPassword:[alertView textFieldAtIndex:0].text block:^(id object, NSError *error) {
                if (!error) {
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"#^_^# 密码修改成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
                    [alert show];
                }else{
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"o(╯□╰)o 原密码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
                    [alert show];
                }
            }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AVFile *headImage = (AVFile *)[[AVUser currentUser]
                                   objectForKey:@"HeadImage"];
    [_headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[headImage getThumbnailURLWithScaleToFit:YES width:180 height:180]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"hd_avatar_not_login"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
