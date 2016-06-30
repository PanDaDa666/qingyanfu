//
//  HelpViewController.m
//  QingYanFuYanWo

#import "HelpViewController.h"
#import "ChatRoomViewController.h"
#import "LoginViewController.h"

@interface HelpViewController ()<AVIMClientDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"助理"];
    [self initWithBackBarButton];
    [self createButton];
}

- (void)createButton{
    CGFloat W = kScreenWidth;
    CGFloat H = (kScreenHeight-64)/2;
    //    CGFloat sW = self.view.frame.size.width;
    NSArray *arr = @[@"个人助理",@"窝窝之家"];
    NSArray *arr1 = @[@"assOwn@2x.jpg",@"assFamily"];
    for (int i=0; i<[arr count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64+(H)*i, W, H)];
        [button setBackgroundImage:[UIImage imageNamed:arr1[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        UILabel *label = [[UILabel alloc] init];
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
            make.height.equalTo(@(20));
            make.right.equalTo(button.mas_right).offset(-25);
            if (i==0) {
                make.top.equalTo(button.mas_top).offset(25);
            }else{
                make.bottom.equalTo(button.mas_bottom).offset(-25);
            }
            
        }];
        label.text = arr[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blueColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        button.tag = 120+i;
        button.backgroundColor = [UIColor redColor];
        
    }
}

- (void)onClick:(UIButton *)btn{
    if([AVUser currentUser]==nil){
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"亲~~请先登录或注册窝友用户" delegate:self cancelButtonTitle:@"前往" otherButtonTitles:@"取消", nil];
        errorAlertView.delegate = self;
        [errorAlertView show];
    }
    else{
        if (btn.tag==121) {
            [self.hud show:YES];
            AVIMClient *imClient = [AVIMClient defaultClient];
            imClient.delegate = self;
            [imClient openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
                [self.hud hide:YES];
                if (!error) {
                    ChatRoomViewController *chat = [[ChatRoomViewController alloc] init];
                    [self.navigationController pushViewController:chat animated:YES];
                }else{
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"因网络问题，聊天室不可用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [view show];
                }
            }];
            
        }else{
            LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
            [agent showConversations:self title:[[AVUser currentUser] objectForKey:@"WoyouName"] contact:[[AVUser currentUser] objectForKey:@"WoyouName"]];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        _hud.labelText = @"正在连接";
        _hud.delegate = self;
    }
    return _hud;
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
