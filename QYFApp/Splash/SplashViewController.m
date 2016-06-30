//
//  SplashViewController.m
//  QingYanFuYanWo
//



#import "SplashViewController.h"
#import "ZWIntroductionViewController.h"
#import "AppDelegate.h"
#import "CenterViewController.h"
#import "LeftViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"
#import "JVFloatingDrawerViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isFisrtStarApp]) {
        [self showGuide];
    }else{
        [self forward];
    }
}

#pragma mark 展示用户引导界面
- (void)showGuide{
    self.view.userInteractionEnabled = YES;
    NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    NSArray *backgroundImageNames = @[@"img_index_04bg.jpg", @"img_index_05bg.jpg", @"img_index_06bg.jpg"];
    ZWIntroductionViewController *introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController=introductionView;
    introductionView.didSelectedEnter=^{
        [self forward];
    };
}

#pragma mark 前往登录界面
- (void)forward{
    LeftViewController *left = [[LeftViewController alloc] init];
    CenterViewController *center = [[CenterViewController alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:center];
    JVFloatingDrawerViewController *drawer = [[JVFloatingDrawerViewController alloc]init];
    drawer.leftViewController = left;
    drawer.leftDrawerWidth= 2*kScreenWidth/3;
    drawer.centerViewController = na;
    JVFloatingDrawerSpringAnimator *animator = [[JVFloatingDrawerSpringAnimator alloc]init];
    //设置动画效果的
    drawer.animator = animator;
    //设置背景图片
    drawer.backgroundImage = [UIImage imageNamed:@"DBE`HF[M~LSL50PT)NAC6GL.jpg"];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController=drawer;
}


#pragma mark 判断是否第一次启动程序
-(BOOL)isFisrtStarApp{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [userDefaults objectForKey:kAppFirstLoadKey];
    if (number!=nil) {
        NSInteger starNumer = [number integerValue];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)++starNumer];
        [userDefaults setObject:str forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return NO;
    }else{
        NSLog(@"用户是第一次启动");
        [userDefaults setObject:@"1" forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return YES;
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
