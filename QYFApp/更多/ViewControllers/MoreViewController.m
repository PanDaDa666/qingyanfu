//
//  MoreViewController.m
//  qingyantangyanwo


#import "MoreViewController.h"
#import "LeanCloudFeedback.h"
#import "MoreSecondViewController.h"
#import "LoginViewController.h"
@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,strong)NSArray *newsArr;
@property (nonatomic,strong)AVQuery *moreInfoQuery;
@property (nonatomic,strong)AVObject *moreInfoObject;
@property (nonatomic,strong)AVQuery *newsCenterQuery;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"更多"];
    [self initWithBackBarButton];
    [self createTableView];
}

- (void)createTableView{
    _arr = @[@"消息中心",@"会员服务",@"意见反馈",@"帮助手册",@"关于我们",@"营业时间",@"联系我们",@"检查更新",@"技术支持",@"推送设置"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    const CGFloat W = 120;
    const CGFloat H = 120;
    const CGFloat Y = 100;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-W)/2, Y, W, H)];
    imageView.image = [UIImage imageNamed:@"qingyanfu"];
    imageView.contentMode = UIViewContentModeScaleAspectFit ;
    _tableView.tableHeaderView = imageView;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIDE = @"cellIDE";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDE];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDE];
    }
    cell.textLabel.text = _arr[indexPath.row];
    
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MoreSecondViewController *mose = [[MoreSecondViewController alloc] init];
            mose.newsArr = _newsArr;
            [self.navigationController pushViewController:mose animated:YES];
        }
            break;
        case 1:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"会员服务" message:[_moreInfoObject objectForKey:@"memberServe"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 2:
        {
            if([AVUser currentUser]==nil){
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"姐姐~~请先登录或注册窝友用户" delegate:self cancelButtonTitle:@"前往" otherButtonTitles:@"取消", nil];
                errorAlertView.delegate = self;
                [errorAlertView show];
            }
            else{
            LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
            [agent showConversations:self title:nil contact:[[AVUser currentUser] objectForKey:@"WoyouName"]];
            }
        }
            break;
        case 3:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"帮助手册" message:[_moreInfoObject objectForKey:@"helpHandbook"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 4:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"关于我们" message:[_moreInfoObject objectForKey:@"aboutWe"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 5:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"营业时间" message:[_moreInfoObject objectForKey:@"serveTime"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 6:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"联系我们" message:[_moreInfoObject objectForKey:@"contactWe"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 7:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"检查更新" message:@"当前版本为最新版本！"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 8:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"技术支持" message:@"如有app和服务器上的问题，15896466680，随时欢迎探讨！"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
        case 9:
        {
            UIAlertView *errorAlertView =[[UIAlertView alloc] initWithTitle:@"推送设置" message:@"若不需要推送 可自行到手机设置进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
            break;
            
            
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
}

- (void)loadInfo{
    _moreInfoQuery = [AVQuery queryWithClassName:@"MoreInfo"];
    _moreInfoQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [_moreInfoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _moreInfoObject = [objects lastObject];
        }
    }];
    _newsCenterQuery = [AVQuery queryWithClassName:@"NewsCenter"];
    [_newsCenterQuery orderByDescending:@"createdAt"];
    _newsCenterQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [_newsCenterQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _newsArr = objects;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadInfo];
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
