/*!
 @header    DLSort
 @abstract  按拼音排序
 @author    丁磊
 @version   1.0.1 2015/04/15 Creation
 */

#import <Foundation/Foundation.h>


@interface DLSort : NSObject

+(id)instance;

/*
    @method : sort:
    @function : 按照拼音排序
    @pare   : list(需要排序的数组)
    @return : 返回排好序的数组
 */
- (NSArray *)sort:(NSArray *)objects;


/*
    @method : getLetters
    @function : 获取按照拼音排序后的索引(A，B，C，D...Z)
    @return : 索引数组
 */
- (NSMutableArray *)getLetters;

/*
    @method : getLetterKeyForValue
    @function : 获取索引对应的分组数组 (A:array1 , B:array2...)
    @return : 分组数据
 */
- (NSMutableDictionary *)getLetterKeyForValue;
@end