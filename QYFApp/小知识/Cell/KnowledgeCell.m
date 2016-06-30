//
//  KnowledgeCell.m
//  QingYanFuYanWo


#import "KnowledgeCell.h"

@interface KnowledgeCell ()
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *titleDescribeLabel;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic,strong)UILabel *readLabel;
@end

@implementation KnowledgeCell

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}


- (void)configUI{
    UIImage *image = [UIImage imageNamed:@"appdetail_background"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.backgroundView = imageView;
    [self.contentView addSubview:self.titlelabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.titleImageView];
    [self.contentView addSubview:self.titleDescribeLabel];
    [self.contentView addSubview:self.lineLabel];
    [self.contentView addSubview:self.readLabel];
}


- (void)setKnowledgeCellFrame:(KnowledgeCellFrame *)knowledgeCellFrame{
    
    
    _knowledgeCellFrame = knowledgeCellFrame;
    self.titlelabel.text = knowledgeCellFrame.knowledgeModel.textTitle;
    [self.titlelabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width).offset(-20);
        make.height.equalTo(@(knowledgeCellFrame.titleLabelHeight));
    }];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd HH:mm"];
    self.dateLabel.text = [df stringFromDate:knowledgeCellFrame.knowledgeModel.createAt];
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlelabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.titlelabel.mas_width);
        make.height.equalTo(@(20));
    }];

    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:[knowledgeCellFrame.knowledgeModel.titleImage getThumbnailURLWithScaleToFit:YES width:800 height:800]] placeholderImage:[UIImage imageNamed:@"empty_list_search_2.jpg"]];
    
    [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.dateLabel.mas_width);
        make.height.equalTo(@((kKnowledgeCell_Weight-40)*0.5));
    }];
    

    self.titleDescribeLabel.text =[NSString stringWithFormat:@"      %@",knowledgeCellFrame.knowledgeModel.titleDescribe];
    [self.titleDescribeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.dateLabel.mas_width);
        make.height.equalTo(@(knowledgeCellFrame.titleDescribeLabelHeight));
    }];
    
    [self.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleDescribeLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.dateLabel.mas_width);
        make.height.equalTo(@(0.5));
    }];
    
    [self.readLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLabel.mas_bottom).offset(5);
        make.left.equalTo(self.lineLabel.mas_left);
        make.width.equalTo(@(80));
        make.height.equalTo(@(20));
    }];
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.backgroundColor = [UIColor clearColor];
        _titlelabel.textColor = [UIColor blackColor];
        _titlelabel.font = [UIFont boldSystemFontOfSize:18];
        _titlelabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titlelabel.numberOfLines = 0;
    }
    return _titlelabel;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {

        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}
- (UILabel *)titleDescribeLabel{
    if (!_titleDescribeLabel) {
        _titleDescribeLabel = [[UILabel alloc] init];
        _titleDescribeLabel.backgroundColor = [UIColor clearColor];
        _titleDescribeLabel.textColor = [UIColor blackColor];
        _titleDescribeLabel.font = [UIFont systemFontOfSize:13];
        _titleDescribeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleDescribeLabel.numberOfLines = 0;
    }
    return _titleDescribeLabel;
}
- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _titleImageView.clipsToBounds = YES;
    }
    return _titleImageView;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineLabel;
}

- (UILabel *)readLabel{
    if (!_readLabel) {
        _readLabel = [[UILabel alloc] init];
        _readLabel.text = @"阅读全文";
        _readLabel.textColor = [UIColor lightGrayColor];
        _readLabel.font = [UIFont systemFontOfSize:13];
    }
    return _readLabel;
}

@end
