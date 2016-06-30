//
//  WordsModel+NetWork.m
//  QingYanFuYanWo
//


#import "WordsModel+NetWork.h"
#import "WordDbManager.h"
@interface WordsModel ()

@end

@implementation WordsModel (NetWork)
+ (void)requestWithPageNumber:(NSInteger)dayNumber andRequestBlock:(ModelRequestBlock)requestBlock{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    for (NSInteger i=(dayNumber-30); i<dayNumber; i++) {
        NSDate * date=[NSDate date];
        NSDate *lastDay = [NSDate dateWithTimeInterval:(-24*60*60)*i sinceDate:date];
        NSString * strDate=[[NSString stringWithFormat:@"%@",lastDay] substringToIndex:10];
        NSString * urlString=kNet_Words(strDate);
            [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSError *jsonError;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError ];
                if (jsonError == nil ) {
                    NSDictionary * subDict=[dict objectForKey:@"hpEntity"];
                    WordsModel *model = [[WordsModel alloc] initWithDictionary:subDict error:nil];
                    [modelArray addObject:model];
                    
                    if (modelArray.count==30) {
                        NSArray *arr =  [modelArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            WordsModel *model01 = (WordsModel *)obj1;
                            WordsModel *model02 = (WordsModel *)obj2;
                            NSArray *arr1 = [model01.strHpTitle componentsSeparatedByString:@"."];
                            NSArray *arr2 = [model02.strHpTitle componentsSeparatedByString:@"."];
                            return [arr1[1] intValue] < [arr2[1] intValue];
                        }];
                        requestBlock(arr,nil);
                        
                        //数据请求并解析成功，则插入数据库,开辟子线程
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            WordDbManager *dbManager = [WordDbManager sharedWordDbManager];
                            //遍历插入
                            for (WordsModel *model  in arr) {
                                [dbManager insertAppModel:model];
                            }
                        });
                    }
                }else{
                    requestBlock(nil,jsonError );
                }
            }failure:^(NSURLSessionDataTask *task, NSError *error) {
                [modelArray addObject:@"1"];
                if (modelArray.count==30) {
                    requestBlock(nil,error );
                }
                
                
        }];
    }
}
@end
