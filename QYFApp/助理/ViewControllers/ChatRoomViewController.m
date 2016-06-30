//
//  ChatRoomViewController.m
//  qingyantangyanwo
//




#import "ViewController.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "KeyBordVIew.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+DocumentPath.h"
#import "ChatRoomViewController.h"

static NSString *const cellIdentifier=@"QQChart";

@interface ChatRoomViewController ()<UITableViewDataSource,UITableViewDelegate,KeyBordVIewDelegate,ChartCellDelegate,AVAudioPlayerDelegate,AVIMClientDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyBordVIew *keyBordView;
@property (nonatomic,strong) NSMutableArray *cellFrames;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVIMClient *imClient;
@property (nonatomic,strong) AVIMConversation *currentConversation;
@property (nonatomic,strong) UIImageView *playAudioImageView;
@end

@implementation ChatRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"窝窝之家"];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //add UItableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStylePlain];
    [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    [self createRefresh];
    //add keyBorad
    
    self.keyBordView=[[KeyBordVIew alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.keyBordView.delegate=self;
    [self.view addSubview:self.keyBordView];
    //初始化数据
    AVIMClient *imClient = [AVIMClient defaultClient];
    imClient.delegate = self;
    
    //红外线感应监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    [self initwithData];
    
}
- (void)createRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHistoryMessages)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.tableView.header = header;
}

- (void)loadHistoryMessages{
    ChartCellFrame *firstCellFrame = self.cellFrames[0];
    AVIMMessage *firstMessage=firstCellFrame.chartMessage.message;
    [self.currentConversation queryMessagesBeforeId:nil timestamp:firstMessage.sendTimestamp limit:kPageSize callback: ^(NSArray *objects, NSError *error) {
        [self.tableView.header endRefreshing];
        if (error == nil) {
            NSInteger count = objects.count;
            if (count == 0) {
                NSLog(@"no more old message");
            } else {
                // 将更早的消息记录插入到 Tabel View 的顶部
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                       NSMakeRange(0,[objects count])];
                NSMutableArray *CellFrameArr = [[NSMutableArray alloc] init];
                for (AVIMTypedMessage *message in objects) {
                    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
                    ChartMessage *chartMessage=[[ChartMessage alloc]init];
                    chartMessage.message = message;
                    cellFrame.chartMessage = chartMessage;
                    [CellFrameArr addObject:cellFrame];
                }
                [self.cellFrames insertObjects:CellFrameArr atIndexes:indexes];
                [self.tableView reloadData];
            }
        }
    }];
    
}

-(void)initwithData
{
    
    // 新建一个针对 AVIMConversation 的查询，根据 Id 查询出对应的 AVIMConversation 实例
    AVIMConversationQuery *query = [self.imClient conversationQuery];
    [query getConversationById:kConversationId callback:^(AVIMConversation *conversation, NSError *error) {
        // 将当前所在的对话实例设置为查询出来的 conversation
        self.currentConversation=conversation;
        // 注意：如果不主动调用 joinWithCallback 方法，则不会收到聊天室的消息通知
        [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
            NSLog(@"成功加入聊天室，开始接收消息。");
        }];
        // 初始化消息发送面板（消息输入框，发送按钮）
        //        [self initMessageToolBar];
        // 查询最近的 10 条聊天记录
        [conversation queryMessagesWithLimit:kPageSize callback:^(NSArray *objects, NSError *error) {
            // 刷新 Tabel 控件，为其添加数据源
            self.cellFrames=[NSMutableArray array];
            for (AVIMTypedMessage *message in objects) {
                ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
                ChartMessage *chartMessage=[[ChartMessage alloc]init];
                chartMessage.message = message;
                cellFrame.chartMessage = chartMessage;
                [self.cellFrames addObject:cellFrame];
            }
            [_tableView reloadData];
        }];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    cell.cellFrame=self.cellFrames[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellFrames[indexPath.row] cellHeight];
}
-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content
{
   
    if(chartCell.cellFrame.chartMessage.messageMediaType==kAVIMMessageMediaTypeAudio){
        if(self.player.isPlaying){
            [self.player stop];
        }
        if (self.playAudioImageView.isAnimating) {
            [self.playAudioImageView stopAnimating];
        }
         self.playAudioImageView = chartCell.chartView.playAudioImageView;
        //播放
        if (chartCell.cellFrame.chartMessage.content) {
            [self.playAudioImageView  startAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *filePath=[NSString documentPathWith:chartCell.cellFrame.chartMessage.content];
                NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
                [self initPlayer];
                NSError *error;
                self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:&error];
                [self.player setVolume:1];
                [self.player prepareToPlay];
                [self.player setDelegate:self];
                [self.player play];
                [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            });
            
        }else{
            [chartCell.cellFrame.chartMessage.messageImageAVFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    [self.playAudioImageView  startAnimating];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self initPlayer];
                        NSError *error;
                        self.player=[[AVAudioPlayer alloc]initWithData:data error:&error];
                        [self.player setVolume:1];
                        [self.player prepareToPlay];
                        [self.player setDelegate:self];
                        [self.player play];
                        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
                    });
                    
                    
                }
            }];
        }
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[UIDevice currentDevice]setProximityMonitoringEnabled:NO];
    [self.playAudioImageView  stopAnimating];
    self.playAudioImageView=nil;
    [self.player stop];
    self.player=nil;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"halo");
}


-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:textFiled.text attributes:nil];
    [self.currentConversation sendMessage:textMessage callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            // 出错了，可能是网络问题无法连接 LeanCloud 云端，请检查网络之后重试。
            // 此时聊天服务不可用。
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"聊天不可用！" message:@"发送失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [view show];
        }
        else{
            ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
            ChartMessage *chartMessage=[[ChartMessage alloc]init];
            
            chartMessage.icon=[AVUser currentUser].objectId;
            chartMessage.messageType=YES;
            chartMessage.content=textFiled.text;
            chartMessage.messageMediaType = kAVIMMessageMediaTypeText;
            cellFrame.chartMessage=chartMessage;
            
            [self.cellFrames addObject:cellFrame];
            [self.tableView reloadData];
            
            //滚动到当前行
            
            [self tableViewScrollCurrentIndexPath];
            textFiled.text=@"";
            //    [self.view endEditing:YES];
        }
    }];
    
}



- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    if ([message.conversationId isEqualToString:self.currentConversation.conversationId]) {
        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
        ChartMessage *chartMessage=[[ChartMessage alloc]init];
        chartMessage.message = message;
        cellFrame.chartMessage = chartMessage;
        [self.cellFrames addObject:cellFrame];
        [self.tableView reloadData];
        [self tableViewScrollCurrentIndexPath];
    }
}



-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled
{
    [self tableViewScrollCurrentIndexPath];
    
}
-(void)beginRecord
{
    if(self.recording)return;
    
    self.recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"rec_%@.wav",[dateFormater stringFromDate:now]];
    self.fileName=fileName;
    NSString *filePath=[NSString documentPathWith:fileName];
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSError *error;
    self.recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder peakPowerForChannel:0];
    [self.recorder record];
    
    
}
-(void)finishRecordWithTime:(NSInteger)playTime
{
    self.recording=NO;
    [self.recorder stop];
    self.recorder=nil;
    
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
    chartMessage.icon=[AVUser currentUser].objectId;
    chartMessage.messageType=YES;
    chartMessage.messageMediaType = kAVIMMessageMediaTypeAudio;
    chartMessage.content=self.fileName;
    chartMessage.playTime = playTime;
    cellFrame.chartMessage=chartMessage;
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    [self tableViewScrollCurrentIndexPath];
    NSDictionary *dic = @{@"playTime":@(playTime)};
    AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:nil attachedFilePath:[NSString documentPathWith:self.fileName] attributes:dic];
    [self.currentConversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"成功");
        }
    }];
    
    
}

- (void)failRecord{
    self.recording=NO;
    [self.recorder stop];
     self.recorder = nil;
    [self.recorder deleteRecording];
   
}
-(void)tableViewScrollCurrentIndexPath
{
    if (self.cellFrames.count!=0) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
-(void)initPlayer{

    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidFinishPlaying:successfully:) name:UIApplicationWillResignActiveNotification object:app];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}


- (AVIMClient*)imClient{
    if (_imClient ==nil) {
        _imClient = [AVIMClient defaultClient];
    }
    return _imClient;
}

- (void)chooseImage{
    if ([[[UIDevice currentDevice] systemVersion] integerValue]<7.2) {
        [self.view endEditing:YES];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];;
    [self.view addSubview:actionSheet];
    [actionSheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate =self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [imagePicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imagePicker animated:NO completion:^{
            }];
        }
            break;
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate =self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [imagePicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imagePicker animated:NO completion:^{
            }];
        }
            break;
            
            
        default:
            break;
    }
}


// 如果在允许编辑时点击choose触发这个方法，不再编辑时点击照片触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
    chartMessage.icon=[AVUser currentUser].objectId;
    chartMessage.messageType=YES;
    chartMessage.messageMediaType = kAVIMMessageMediaTypeImage;
    chartMessage.messageImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    cellFrame.chartMessage=chartMessage;
    
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    [self tableViewScrollCurrentIndexPath];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tmp.jpg"];
        NSData* photoData=UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"]);
        
        [photoData writeToFile:filePath atomically:YES];
        AVIMImageMessage *message = [AVIMImageMessage messageWithText:nil attachedFilePath:filePath attributes:nil];
        [self.currentConversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        }];
        
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
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
