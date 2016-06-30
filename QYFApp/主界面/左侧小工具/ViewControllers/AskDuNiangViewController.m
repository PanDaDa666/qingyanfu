//
//  AskDuNiangViewController.m
//  QingYanFuYanWo


#import "AskDuNiangViewController.h"

@interface AskDuNiangViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation AskDuNiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initWebView];
    [self customToolBar];
}

- (void)initNavigationBar{
    [self initWithBackBarButton];
    [self setNavigationTitle:@"度娘"];
}

- (void)initWebView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *str = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _webView = [[UIWebView alloc ]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-100 )];
    _webView.backgroundColor = [UIColor redColor];
    _webView.scrollView.backgroundColor = BLUE_COLOR;
    [_webView  loadRequest:request];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
}

- (void)customToolBar{
    //获得导航控制器
    UINavigationController *naVc = self.navigationController;
    //Toolbar 是属于导航控制器，Toolbar 默认是隐藏的，想要显示必须设置隐藏属性为NO
    [naVc setToolbarHidden:NO];
    naVc.toolbar.barTintColor = BLUE_COLOR;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStyleDone target:self action:@selector(onClickOne)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(onClickTwo)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onClickThree)];
    item1.tintColor = [UIColor whiteColor];
    item2.tintColor = [UIColor whiteColor];
    item3.tintColor = [UIColor whiteColor];
    UIBarButtonItem *item6 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item7 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //toolbarItems 属于视图控制器，只有当当前的视图控制器放在导航控制器才有这个值
    //toolbarItems 里面装的是UIBarButtonItem或者UIBarButtonItem子类的对象
    self.toolbarItems = @[item1,item6,item3,item7,item2];
}

-(void)onClickOne{
    //如果在html页面切换的时候，我们可以返回到上一级页面
    [_webView goBack];
}
-(void)onClickTwo{
    //如果在html页面切换的时候，点击了返回之后就可以再次回到上一次加载的页面
    [_webView goForward];
}

- (void)onClickThree{
    [_webView reload];
}

- (void)onLeftBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
