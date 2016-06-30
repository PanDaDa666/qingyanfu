//
//  KnowledgeCellFrame.m
//  QingYanFuYanWo
//


#import "KnowledgeCellFrame.h"

@implementation KnowledgeCellFrame

- (void)setKnowledgeModel:(KnowledgeModel *)knowledgeModel{
    _knowledgeModel = knowledgeModel;
    

    NSDictionary *textTitleAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]};
    CGFloat textTitleHeight=[knowledgeModel.textTitle boundingRectWithSize:CGSizeMake(kKnowledgeCell_Weight-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textTitleAttributes context:nil].size.height;
    self.titleLabelHeight = textTitleHeight+2;
    NSDictionary *titleDescribeAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGFloat titleDescribeHeight=[knowledgeModel.titleDescribe boundingRectWithSize:CGSizeMake(kKnowledgeCell_Weight-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDescribeAttributes context:nil].size.height;
    self.titleDescribeLabelHeight = titleDescribeHeight+5;
    self.cellHeight = titleDescribeHeight+textTitleHeight+5*10+(kKnowledgeCell_Weight-40)*0.5+20+20+10;
}
@end
