//
//  LHDebugDescription.h
//  Lighthouse
//
//  Created by Makarov Yury on 04/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDebugPrintable.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LHDebugDescriptionBlock)(NSMutableString *buffer, NSString *indentString, NSUInteger indent);


@interface NSObject (LHDebugDescription)

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent block:(LHDebugDescriptionBlock)block;

@end


@interface NSMapTable (LHDebugDescription) <LHDebugPrintable>

@end


@interface NSSet (LHDebugDescription) <LHDebugPrintable>

@end


@interface NSOrderedSet (LHDebugDescription) <LHDebugPrintable>

@end

NS_ASSUME_NONNULL_END
