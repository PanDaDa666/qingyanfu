//
//  WordDbManager.m
//  QingYanFuYanWo


#import "WordDbManager.h"
#import "FMDB.h"

@interface WordDbManager ()
{
    FMDatabaseQueue *_dataBasQueue;
    
}
@end

@implementation WordDbManager
SYNTHESIZE_SINGLETON_FOR_CLASS(WordDbManager);
-(id)init{
    if (self = [super init]) {
        [self createDataBase];
    }
    return self;
}

//创建数据库
-(void)createDataBase{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS Word (strHpTitle  text  , strOriginalImgUrl text, strAuthor text, strMarketTime text, strContent text, strPn text, wImgUrl text)";
    NSString *docPath  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"word.db"];
    
    //因为多线程时同时操作数据库是不安全的，FMDB帮我们提供了FMDatabaseQueue ，它能保证FMDataBase 执行完一条sql语句后，另一条sql语句才能被执行。（sql语句排队执行）
    //当前的数据库地址有这个数据库就打开，没有这个数据库就帮我们创建
    _dataBasQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [_dataBasQueue inDatabase:^(FMDatabase *db) {
        
        BOOL isSueccess = [db executeUpdate:sql];
        if (isSueccess) {
            NSLog(@"%@",@"创建表格成功");
        }else{
            NSLog(@"%@",@"创建表格失败");
        }
    }];
    
}

//获得所有的数据
-(void)getAllModels:(GetAllModelsBlock )complectionBlok{
    
    [_dataBasQueue inDatabase:^(FMDatabase *db) {
        //创建可变数组存储modle
        NSMutableArray *modelArray = [[NSMutableArray alloc]init];
        NSString *sql = @"select * from Word order by strHpTitle DESC LIMIT 30";

        //执行查询sql语句
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WordsModel  *model = [[WordsModel alloc] init];
            
            model.strHpTitle = [rs stringForColumn:@"strHpTitle"];
            model.strOriginalImgUrl = [rs stringForColumn:@"strOriginalImgUrl"];
            model.strAuthor = [rs stringForColumn:@"strAuthor"];
            model.strMarketTime = [rs stringForColumn:@"strMarketTime"];
            model.strContent = [rs stringForColumn:@"strContent"];
            model.strPn = [rs stringForColumn:@"strPn"];
            model.wImgUrl = [rs stringForColumn:@"wImgUrl"];
            [modelArray addObject:model];
        }
        //获取model之后，传值回去
        complectionBlok(modelArray);
        
    }];
    
}


//插入一个模型对象
-(void)insertAppModel:(WordsModel *)model{
    
    [_dataBasQueue inDatabase:^(FMDatabase *db) {
        
        NSString *selectSql = @"select * from Word where strHpTitle = ?";
        FMResultSet *rs = [db executeQuery:selectSql,model.strHpTitle];
        BOOL isEs  = NO;//判断当前插入的数据是否存在
        while ([rs next]) {
            isEs = YES;//如果进来，当前存在一条这样的语句
        }
        if (isEs == NO) {
            NSString *insertSQL =  @"INSERT INTO Word(strHpTitle, strOriginalImgUrl, strAuthor, strMarketTime, strContent , strPn, wImgUrl) VALUES(?, ?, ?, ?, ?, ?, ?)";
            BOOL isSucess =  [db executeUpdate:insertSQL,model.strHpTitle,model.strOriginalImgUrl,
                              model.strAuthor,
                              model.strMarketTime,
                              model.strContent,
                              model.strPn,
                              model.wImgUrl
                              ];
            if (isSucess) {
                NSLog(@"插入数据%@",@"成功");
            }
            else{
                NSLog(@"%@",@"插入数据失败");
            }
        }
        
        
    }];
    
}

@end
