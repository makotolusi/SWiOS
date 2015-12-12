//
//  BaseModel.h

//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface BaseModel : JSONModel

- (id)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues;

@end
