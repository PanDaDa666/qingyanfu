//
//  WordsModel.h
//  QingYanFuYanWo


#import "JSONModel.h"

@interface WordsModel : JSONModel
@property (nonatomic,copy)NSString *strHpTitle;
@property (nonatomic,copy)NSString *strOriginalImgUrl;
@property (nonatomic,copy)NSString *strAuthor;
@property (nonatomic,copy)NSString *strMarketTime;
@property (nonatomic,copy)NSString *strContent;
@property (nonatomic,copy)NSString *wImgUrl;
@property (nonatomic,copy)NSString *strPn;
@property (nonatomic,copy)NSString <Optional>*zan;
@end
