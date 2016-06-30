//
//  KnowledgeScrollView.m
//  QingYanFuYanWo
//


#import "KnowledgeScrollView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "PreviewImageView.h"

@interface KnowledgeScrollView()
{

}
@end

@implementation KnowledgeScrollView

- (instancetype)initWithFrame:(CGRect)frame AndScrollFrame:(KnowledgeScrollFrame *)scrollFrame{
    if (self = [super initWithFrame:frame]) {
        self.contentSize = CGSizeMake(0, scrollFrame.scrollHeight);
        NSLog(@"%lf",scrollFrame.scrollHeight);
        [self configUIWithScrollFrame:scrollFrame];
    }
    return self;
}

- (void)configUIWithScrollFrame:(KnowledgeScrollFrame *)scrollFrame{
    UILabel *titleLabel  = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = scrollFrame.knowledgeModel.textTitle;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width).offset(-20);
        make.height.equalTo(@(scrollFrame.textTitleHeight));
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = [UIColor grayColor];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [df stringFromDate:scrollFrame.knowledgeModel.createAt];
    [self addSubview:dateLabel];
    dateLabel.text = [NSString stringWithFormat:@"%@   阅读 %@",dateString,scrollFrame.knowledgeModel.upvotes];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo (titleLabel.mas_left);
        make.width.equalTo(@(250));
        make.height.equalTo(@(20));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.text = @"saber青青";
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(5);
        make.left.equalTo (dateLabel.mas_left);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
    
    for ( NSInteger i =0; i<[scrollFrame.textHeightArray count];i++ ) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.tag = kKnowledgeSrollView_TextLabelTag+i;
        textLabel.text = [scrollFrame.knowledgeModel.knowledgeObject objectForKey:[NSString stringWithFormat:@"text0%ld",i+1]];
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        pictureImageView.tag = kKnowledgeSrollView_PictureImageViewTag+i;
        pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
        pictureImageView.userInteractionEnabled = YES;
        [self createTapGesture:pictureImageView];
        AVFile *currentImage = [scrollFrame.knowledgeModel.knowledgeObject objectForKey:[NSString stringWithFormat:@"image0%ld",i+1]];
        AVFile *beforeImage = [scrollFrame.knowledgeModel.knowledgeObject objectForKey:[NSString stringWithFormat:@"image0%ld",(long)i]];
        if (i==0) {
            [self addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(nameLabel.mas_bottom).offset(10);
                make.centerX.equalTo(self.mas_centerX);
                make.width.equalTo(self.mas_width).offset(-20);
                make.height.equalTo(scrollFrame.textHeightArray[0]);
            }];
        }else{
            if (beforeImage) {
                [self addSubview:textLabel];
                UIImageView *imageView = (UIImageView *)[self viewWithTag:kKnowledgeSrollView_PictureImageViewTag+i-1];
                [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(imageView.mas_bottom).offset(10);
                    make.centerX.equalTo(self.mas_centerX);
                    make.width.equalTo(self.mas_width).offset(-20);
                    make.height.equalTo(scrollFrame.textHeightArray[i]);
                }];
            }else{
                [self addSubview:textLabel];
                UILabel *label = (UILabel *)[self viewWithTag:kKnowledgeSrollView_TextLabelTag+i-1];
                [textLabel mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.equalTo(label.mas_bottom).offset(10);
                    make.centerX.equalTo(self.mas_centerX);
                    make.width.equalTo(self.mas_width).offset(-20);
                    make.height.equalTo(scrollFrame.textHeightArray[i]);
                }];
            }
        }
        if (currentImage) {
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:currentImage.url] placeholderImage:[UIImage imageNamed:@"empty_list_search_2.jpg"]];
            [self addSubview:pictureImageView];
            UILabel *label = (UILabel *)[self viewWithTag:kKnowledgeSrollView_TextLabelTag+i];
            [pictureImageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(label.mas_bottom).offset(10);
                make.centerX.equalTo(self.mas_centerX);
                make.width.equalTo(self.mas_width).offset(-20);
                make.height.equalTo(@(kScreenWidth-40));
            }];
        }
    }
    
}

- (void)createTapGesture:(UIImageView *)imageView{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [imageView addGestureRecognizer:tapGR];
}


- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [imageView convertRect:imageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:imageView.image startImageFrame:startRect inView:windows viewFrame:kScreenBounds];
}

@end
