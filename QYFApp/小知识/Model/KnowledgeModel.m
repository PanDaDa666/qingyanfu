//
//  KnowledgeModel.m
//  QingYanFuYanWo
//

#import "KnowledgeModel.h"

@implementation KnowledgeModel

- (void)setKnowledgeObject:(AVObject *)knowledgeObject{
    _knowledgeObject = knowledgeObject;
    _titleImage = [knowledgeObject objectForKey:@"titleImage"];
    _textTitle = [knowledgeObject objectForKey:@"textTitle"];
    _titleDescribe = [knowledgeObject objectForKey:@"titleDescribe"];
    _text01 = [knowledgeObject objectForKey:@"text01"];
    _image01 = [knowledgeObject objectForKey:@"image01"];
    _text02 = [knowledgeObject objectForKey:@"text02"];
    _image02 = [knowledgeObject objectForKey:@"image02"];
    _text03 = [knowledgeObject objectForKey:@"text03"];
    _image03 = [knowledgeObject objectForKey:@"image03"];
    _text04 = [knowledgeObject objectForKey:@"text04"];
    _image04 = [knowledgeObject objectForKey:@"image04"];
    _text05 = [knowledgeObject objectForKey:@"text05"];
    _image05 = [knowledgeObject objectForKey:@"image05"];
    _text06 = [knowledgeObject objectForKey:@"text06"];
    _upvotes = [knowledgeObject objectForKey:@"upvotes"];
    _createAt = knowledgeObject.createdAt;
    _objectID = knowledgeObject.objectId;
}

@end
