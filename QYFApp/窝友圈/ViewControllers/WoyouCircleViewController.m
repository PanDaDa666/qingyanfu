//
//  WoyouCircleViewController.m
//  QingYanFuYanWo
//

#import "WoyouCircleViewController.h"
#import "WoyouCircleCollectionViewCell.h"
#import "WordsModel+NetWork.h"
#import "WordDbManager.h"
#import "EGORefreshTableHeaderView.h"

@interface WoyouCircleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UMSocialDataDelegate,UMSocialUIDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    EGORefreshTableHeaderView* _PullLeftRefreshView;
    BOOL _reloading;
    UICollectionView *_collectionView;
}
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong) Reachability *reach;
@end

@implementation WoyouCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Gray_COLOR;
    [self setNavigationTitle:@"窝友圈"];
    [self initWithShareBarButton];
    [self initWithBackBarButton];
    [self createCollectionView];
    if (self.reach.currentReachabilityStatus != NotReachable) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //读取数组
            WordDbManager *dbManager = [WordDbManager sharedWordDbManager];
            [dbManager getAllModels:^(NSArray *modelsArray) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!modelsArray.count) {
                        [self loadOnceData];
                    }else{
                        //刷新UI界面的操作要在主线程
                        [self.dataSource removeAllObjects];
                        [self.dataSource addObjectsFromArray:modelsArray];
                        [_collectionView reloadData];
                    }
                });
            }];
        });

    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //读取数组
            WordDbManager *dbManager = [WordDbManager sharedWordDbManager];
            [dbManager getAllModels:^(NSArray *modelsArray) {
                dispatch_async(dispatch_get_main_queue(), ^{
                        //刷新UI界面的操作要在主线程
                        [self.dataSource removeAllObjects];
                        [self.dataSource addObjectsFromArray:modelsArray];
                        [_collectionView reloadData];

                });
            }];
        });

        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"o(╯□╰)o 姐姐没网络啊" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
        [alert show];
    }


}

- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response{
    
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight-64);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.pagingEnabled= YES;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"WoyouCircleCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WoyouCircleCollectionViewCell"];
    [self.view addSubview:_collectionView];
    _PullLeftRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:_collectionView orientation:EGOPullOrientationRight];
    CGSize size =_collectionView.frame.size;
    size.width +=1;
    _collectionView.contentSize = size;
    _PullLeftRefreshView.delegate = self;
    [_PullLeftRefreshView adjustPosition];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        [_PullLeftRefreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_PullLeftRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self loadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}


- (void)loadData{
    [WordsModel requestWithPageNumber:30 andRequestBlock:^(NSArray *array, NSError *error) {
        _collectionView.pagingEnabled= YES;
         _reloading = NO;
        [_PullLeftRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
                [_collectionView reloadData];
            });
        }else{

                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"o(╯□╰)o 加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
                [alert show];
                NSLog(@"错误");
           
        }
    }];
}

- (void)loadOnceData{
    [self.hud show:YES];
    [WordsModel requestWithPageNumber:30 andRequestBlock:^(NSArray *array, NSError *error) {
        _collectionView.pagingEnabled= YES;
        [self.hud hide:YES];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
                [_collectionView reloadData];
            });
        }else{
            
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"o(╯□╰)o 加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0f];
            [alert show];
            NSLog(@"错误");
            
        }
    }];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WoyouCircleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WoyouCircleCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        _hud.labelText = @" >_< 正在努力加载中...";
        _hud.delegate = self;
    }
    return _hud;
}

-(Reachability *)reach{
    if (_reach == nil) {
        //创建一个判断网络状态的对象
        _reach = [Reachability   reachabilityForInternetConnection];
    }
    return _reach;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
