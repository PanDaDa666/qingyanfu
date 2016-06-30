//
//  KeyBordVIew.m
//  气泡
//


#define kBTNWIDTH 33
#define kBTNHEIGHT 33
#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height
#define SPACING 5

#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "UIImage+StrethImage.h"
#import "UUProgressHUD.h"

@interface KeyBordVIew()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *speakBtn;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) NSInteger playTime;
@property (nonatomic,strong) NSTimer *playTimer;
@end

@implementation KeyBordVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
    }
    
    return self;
}

-(UIButton *)buttonWith:(NSString *)noraml action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:noraml] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)initialData
{
    self.backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    //    self.backImageView.image=[UIImage strethImageWith:@"toolbar_bottom_bar.png"];
    [self addSubview:self.backImageView];
    
    self.voiceBtn=[self buttonWith:@"chat_voice_record" action:@selector(voiceBtnPress:)];
    [self.voiceBtn setFrame:CGRectMake(0,0, kBTNWIDTH, kBTNHEIGHT)];
    [self.voiceBtn setCenter:CGPointMake(SPACING+kBTNWIDTH/2, SELFHEIGHT*0.5)];
    [self addSubview:self.voiceBtn];
    
    
    self.addBtn=[self buttonWith:@"Chat_take_picture"  action:@selector(addBtnPress:)];
    [self.addBtn setFrame:CGRectMake(0, 0, kBTNWIDTH, kBTNHEIGHT)];
    [self.addBtn setCenter:CGPointMake(SELFWIDTH-SPACING-kBTNWIDTH/2, SELFHEIGHT*0.5)];
    [self addSubview:self.addBtn];
    
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH-4*SPACING-kBTNWIDTH*2, SELFHEIGHT*0.8)];
    self.textField.returnKeyType=UIReturnKeySend;
    self.textField.center=CGPointMake(SPACING*2+kBTNWIDTH+(SELFWIDTH-4*SPACING-kBTNWIDTH*2)/2, SELFHEIGHT*0.5);
    self.textField.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    self.textField.placeholder=@"  请输入...";
    self.textField.background=[UIImage imageNamed:@"chat_bottom_textfield.png"];
    self.textField.delegate=self;
    [self addSubview:self.textField];
    
    self.speakBtn=[self buttonWith:nil action:@selector(speakBtnPress:)];
    [self.speakBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.speakBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.speakBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.speakBtn setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlEventTouchDown];
    [self.speakBtn setTitle:@"正在录音" forState:(UIControlState)UIControlEventTouchDown];
    [self.speakBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self.speakBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.speakBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self.speakBtn setBackgroundColor:[UIColor whiteColor]];
    [self.speakBtn setFrame:self.textField.frame];
    self.speakBtn.hidden=YES;
    [self addSubview:self.speakBtn];
}

-(void)touchDown:(UIButton *)voice
{
    //开始录音
    
    if([self.delegate respondsToSelector:@selector(beginRecord)]){
    
        [self.delegate beginRecord];
        
    }
    _playTime = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
    NSLog(@"开始录音");
}
-(void)speakBtnPress:(UIButton *)voice
{
   //结束录音
    if (_playTimer) {
        [_playTimer invalidate];
        _playTimer = nil;
        if (_playTime<60&&_playTime>=1) {
            if([self.delegate respondsToSelector:@selector(finishRecordWithTime:)]){
                
                [self.delegate finishRecordWithTime:_playTime];
                NSLog(@"%ld",(long)_playTime);
            }
            NSLog(@"结束录音");
            [UUProgressHUD dismissWithSuccess:@"录音成功"];
        }else {
            if([self.delegate respondsToSelector:@selector(failRecord)]){
                [self.delegate failRecord];
            }
            [UUProgressHUD dismissWithSuccess:@"录音太短"];
        }
    }
    
}

- (void)cancelRecordVoice:(UIButton *)voice{
    if (_playTimer) {
        if([self.delegate respondsToSelector:@selector(failRecord)]){
            
            [self.delegate failRecord];
        }
        NSLog(@"录音失败");
        [UUProgressHUD dismissWithSuccess:@"录音失败"];
        [_playTimer invalidate];
        _playTimer = nil;
    }
    
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"松开即删除"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"划出即删除"];
}

- (void)countVoiceTime
{
    _playTime ++;
    if (_playTime>=60) {
        if([self.delegate respondsToSelector:@selector(finishRecordWithTime: )]){
            
            [self.delegate finishRecordWithTime:_playTime];
        }
    }
}


-(void)voiceBtnPress:(UIButton *)voice
{
    NSString *normal;
    if(self.speakBtn.hidden==YES){
        
        self.speakBtn.hidden=NO;
        self.textField.hidden=YES;
        normal=@"chat_ipunt_message";
        
    }else{
        
        self.speakBtn.hidden=YES;
        self.textField.hidden=NO;
        normal=@"chat_voice_record";
        
    }
    [voice setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    
}

-(void)addBtnPress:(UIButton *)image
{
     [self.delegate chooseImage];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledBegin:)]){
        
        [self.delegate KeyBordView:self textFiledBegin:textField];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]){
    
        [self.delegate KeyBordView:self textFiledReturn:textField];
    }
    return YES;
}
@end
