//
//  KnowLedgeViewController.m
//  QingYanFuYanWo
//


#import "KnowLedgeViewController.h"
#import "KnowledgeCellFrame.h"
#import "KnowledgeModel.h"
#import "KnowledgeCell.h"
#import "TopicItemHeader.h"
#import "KnowLedgeSecondViewController.h"
@interface KnowLedgeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchControllerDelegate,UISearchBarDelegate>
{
    NSInteger _num;
    UIImageView *_backImageView;
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UISearchController *searchController;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation KnowLedgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initNavigationBar];
    [self backgroundImageView];
    [self createCollectionView];
    [self loadInfo];
}

- (void)initNavigationBar{
    [self setNavigationTitle:@"小知识"];
    [self initWithBackBarButton];
}

- (void)backgroundImageView{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *imagePath = [bundle pathForResource:@"MainImg.jpg" ofType:nil];
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.userInteractionEnabled = YES;
    [self.view addSubview:_backImageView];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kKnowledgeCell_Weight, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 50.0;
    layout.headerReferenceSize = CGSizeMake(0, 50);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[KnowledgeCell class] forCellWithReuseIdentifier:@"KnowledgeCell"];
    [_collectionView registerClass:[TopicItemHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopicItemHeader"];
    [_backImageView addSubview:_collectionView];
    [self setupRefresh];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TopicItemHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopicItemHeader" forIndexPath:indexPath];
        header.searchController = self.searchController;
        reusableView = header;
    }
    return reusableView;
}

- (void)setupRefresh{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadInfo)];
    footer.automaticallyRefresh = NO;
    [footer setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"木有小知识啦!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    footer.stateLabel.textColor = [UIColor purpleColor];
    _collectionView.footer = footer;
}

- (void)loadInfo{
    AVQuery *query = [AVQuery queryWithClassName:@"Knowledge"];
    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    _num += 3;
    query.limit = _num;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count]>=_num) {
                [self.dataSource removeAllObjects];
                for (AVObject *object in objects) {
                    KnowledgeModel *model = [[KnowledgeModel alloc] init];
                    KnowledgeCellFrame *cellFrame = [[KnowledgeCellFrame alloc] init];
                    model.knowledgeObject = object;
                    cellFrame.knowledgeModel = model;
                    [self.dataSource addObject:cellFrame];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                });
                [_collectionView.footer endRefreshing];
            }else {
                [_collectionView.footer noticeNoMoreData];
            }
        }
        else{
            NSInteger n = 0;
            if (n==1) {
                _collectionView.footer.hidden = YES;
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"姐 是你网不行，还是我没料了" delegate:nil cancelButtonTitle:@"是姐我网不行" otherButtonTitles:@"逗！是你没料", nil];
                [errorAlertView show];
                return ;
            }
            n++;
        }
        
    }];
}

#pragma mark UISearchBarDelegate 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    AVQuery *searchQuery = [AVQuery queryWithClassName:@"Knowledge"];
    searchQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [searchQuery orderByDescending:@"createdAt"];
    [searchQuery whereKey:@"textTitle" containsString:searchBar.text];
    [_hud show:YES];
    [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [_hud hide:YES];
        if (!error) {
            [self.dataSource removeAllObjects];
            for (AVObject *object in objects) {
                KnowledgeModel *model = [[KnowledgeModel alloc] init];
                KnowledgeCellFrame *cellFrame = [[KnowledgeCellFrame alloc] init];
                model.knowledgeObject = object;
                cellFrame.knowledgeModel = model;
                [self.dataSource addObject:cellFrame];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        }else{
            [self.dataSource removeAllObjects];
        }
    }];
    [self.searchController setActive:NO];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KnowledgeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KnowledgeCell" forIndexPath:indexPath];
    cell.knowledgeCellFrame = _dataSource[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    KnowledgeCellFrame *cellframe =  _dataSource[indexPath.item];
    return CGSizeMake(kKnowledgeCell_Weight, cellframe.cellHeight);
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    KnowLedgeSecondViewController *klsVC = [[KnowLedgeSecondViewController alloc] init];
    KnowledgeCellFrame *cellFrame = _dataSource[indexPath.item];
    klsVC.knowledgeModel = cellFrame.knowledgeModel;
    [self.navigationController pushViewController:klsVC animated:YES];
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark setter 和 getter 方法
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        /*搜索相关*/
        //参数如果为nil，默认覆盖的是self；如果不为nil,那么可以是其他的控制器但是就是不能为self,self蹦
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        //searchBar自动适应大小，要写在把searchBar 赋给tableView头视图之前
        [_searchController.searchBar sizeToFit];
        
        //设置tableView的头视图
        //是否覆盖导航栏 默认为YES 覆盖导航栏
        _searchController.hidesNavigationBarDuringPresentation = NO;
        //是否显示蒙版
        _searchController.dimsBackgroundDuringPresentation = YES;
        //设置searchBar默认的提示文字
        _searchController.searchBar.placeholder = @"搜搜你喜欢的小知识";
        //设置searchBar的代理
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.color=[UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.80];
        _hud.labelText = @"搜索中";
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
