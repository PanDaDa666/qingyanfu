//
//  MoreSecondViewController.m
//  qingyantangyanwo
//


#import "MoreSecondViewController.h"

@interface MoreSecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoreSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"消息中心"];
    [self createTableView];
}

- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_newsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIDE = @"cellIDE";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDE];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDE];
    }
    cell.textLabel.text = [_newsArr[indexPath.row] objectForKey:@"text"];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textColor = [UIColor blueColor];
    NSDate *creationDate =[_newsArr[indexPath.row] createdAt];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"20YY MM/dd HH:mm"];
    cell.detailTextLabel.text = [df stringFromDate:creationDate];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textAlignment = 1;
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
