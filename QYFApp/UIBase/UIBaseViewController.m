//
//  UIBaseViewController.m
//  QingYanFuYanWo
//


#import "UIBaseViewController.h"



@interface UIBaseViewController ()

@end

@implementation UIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.alpha = 0.9;
    self.navigationController.navigationBar.barTintColor = BLUE_COLOR;
}


- (void)initWithBackBarButton{
    [self initWithLeftBarButton:nil AndBackImageName:@"icnav_back_light" AndTarget:self Andselector:@selector(onLeftBackClick)];
    
}

- (void)initWithShareBarButton{
    [self initWithRightBarButton:nil AndBackImageName:@"icon_share_titlebar@2x" AndTarget:self Andselector:@selector(onRightShareClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)initWithRightBarButton:(NSString *)title AndBackImageName:(NSString *)backImageName AndTarget:(id)target Andselector:(SEL)selector{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)initWithLeftBarButton:(NSString *)title AndBackImageName:(NSString *)backImageName AndTarget:(id)target Andselector:(SEL)selector{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}


-(void)setNavigationTitle:(NSString *)title{
    const CGFloat W = 83;
    const CGFloat H = 43;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    label.text=title;
    label.font = [UIFont boldSystemFontOfSize:25];
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    self.navigationItem.title = title;
}

- (void)onRightShareClick{
    UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUMAppKey shareText:@"分享文字" shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,
                                                                                                                          UMShareToTencent,
                                                                                                                          UMShareToRenren,
                                                                                                                          UMShareToDouban,
                                                                                                                                                                                                                                  UMShareToEmail,
                                                                                                                                                                                                                                                                                                     nil] delegate:nil];
}


- (void)onLeftBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dimissAlert:(UIAlertView *)alert {
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        
    }
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
