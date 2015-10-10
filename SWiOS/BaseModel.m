//
//  BaseModel.m

//

#import "BaseModel.h"

/**
 *  (1) 建立JSON和model映射关系，通过Dic
 *  (2) 通过Dic，value，生成SEL
 *  (3) setter方法生成OK，
 */

@implementation BaseModel

- (NSMutableDictionary *)_builtRelationship:(NSDictionary *)json
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *key in json) {
        
        if ([key isEqualToString:@"id"]) {
            
            // 将类名转换成字符串
            NSString *cls = NSStringFromClass([self class]); // @"NewsModelID"
            // 拼接字符串
            NSString *propertyName = [cls stringByAppendingFormat:@"%@", [key uppercaseString]];
            //NSLog(@"propertyName : %@", propertyName);
            
            [dict setObject:propertyName forKey:key];
            
        }else {
            
            // model 和 JSON 关系一一对应
            [dict setObject:key forKey:key];
        }
    }
    
    return dict;
}

- (SEL)_pendingSetterMethod:(NSString *)keyName
{
    // 取出首字母
    NSString *first = [[keyName substringToIndex:1] uppercaseString];
    // 取出剩余字符
    NSString *end = [keyName substringFromIndex:1];
    // 拼接成setter方法字符串
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", first, end];
    
    // 生成SEL方法
    return NSSelectorFromString(setter);
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    // 1 将凡是ID，类名+ID，比如，newsModel =》 NewsModelID (建立映射关系)
    // Model == JSON
    // key : JSON key , value model 属性
    NSDictionary *results = [self _builtRelationship:keyedValues];
    
    // 2 生成方法
    for (NSString *keyName in results) {
    
        // 取出属性值
        NSString *modelValue = results[keyName]; // setNewsModelID:
        
        // 3 生成SEL方法
        SEL sel = [self _pendingSetterMethod:modelValue];
        
        // 4 获取JSON Value
        NSString *jsonValue = keyedValues[keyName];
        
        // 5 设置model属性 setter方法
        if ([self respondsToSelector:sel]) {
            
            [self performSelector:sel withObject:jsonValue];
        }
    }
}

@end
