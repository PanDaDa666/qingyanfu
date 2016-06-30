//
//  KnowledgeScrollFrame.m
//  QingYanFuYanWo


#import "KnowledgeScrollFrame.h"

@implementation KnowledgeScrollFrame

- (void)setKnowledgeModel:(KnowledgeModel *)knowledgeModel{
    _knowledgeModel = knowledgeModel;
    
    CGFloat textTitleHeight=[knowledgeModel.textTitle boundingRectWithSize:CGSizeMake(kScreenWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]} context:nil].size.height;
    _textTitleHeight = textTitleHeight+5;
    [self.textHeightArray removeAllObjects];
    CGFloat H = 0;
    NSInteger imagenum = 0;
    for (NSInteger i =1; i<7; i++) {
        NSString *str = [NSString stringWithFormat:@"text0%ld",(long)i];
        if ([knowledgeModel.knowledgeObject objectForKey:str]) {
            CGFloat textHeight=[[knowledgeModel.knowledgeObject objectForKey:str] boundingRectWithSize:CGSizeMake(kScreenWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size.height;
            if (textHeight!=0) {
                H+=textHeight+5;
            }
            [self.textHeightArray addObject:@(textHeight+5)];
        }
        NSString *str2 = [NSString stringWithFormat:@"image0%ld",(long)i];
        if ([knowledgeModel.knowledgeObject objectForKey:str2]) {
            H+= kScreenWidth-40;
            imagenum +=1;
        }
    }
    _scrollHeight = _textTitleHeight+H+20*2+3*5+[self.textHeightArray count]*10+imagenum*10+20;
     

}

- (NSMutableArray*)textHeightArray{
    if (!_textHeightArray) {
        _textHeightArray = [[NSMutableArray alloc] init];
    }
    return _textHeightArray;
}

@end
