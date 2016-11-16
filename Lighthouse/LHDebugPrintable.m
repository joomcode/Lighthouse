//
//  LHDebugDescription.m
//  Lighthouse
//
//  Created by Makarov Yury on 04/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDebugPrintable.h"
#import <objc/runtime.h>

@interface NSObject (LHDebugDescription) <LHDebugPrintable>

- (NSString *)lh_description;

@end


@implementation NSString (LHDebugDescription)

+ (NSString *)lh_paddingForIndentLevel:(NSUInteger)indent {
    return indent > 0 ? [[NSString string] stringByPaddingToLength:indent * 4 withString:@" " startingAtIndex:0] : @"";
}

@end


typedef void(^LHDebugDescriptionBlock)(NSMutableString *buffer, NSString *indentString, NSUInteger indent);

static NSString *LHDescriptionWithTitleAndBraces(NSString *title, NSInteger indent, LHDebugDescriptionBlock block) {
    NSMutableString *description = [NSMutableString string];
    
    [description appendFormat:@"%@ {\n", title];
    block(description, [NSString lh_paddingForIndentLevel:indent + 1], indent + 1);
    [description appendFormat:@"%@}", [NSString lh_paddingForIndentLevel:indent]];
    
    return description;
}

static NSString *LHContainerDescription(id<NSFastEnumeration> container, NSString *title, NSUInteger indent) {
    return LHDescriptionWithTitleAndBraces(title, indent, ^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        BOOL isFirstItem = YES;
        
        for (id value in container) {
            if (!isFirstItem) {
                [buffer appendString:@"\n"];
            }
            NSString *valueDescription = [value lh_descriptionWithIndent:indent];
            [buffer appendFormat:@"%@%@", indentString, valueDescription];
            
            isFirstItem = NO;
        }
    });
}

static NSString *LHKeyValueContainerDescription(id<NSFastEnumeration, NSObject> container, NSString *title, NSUInteger indent) {
    return LHDescriptionWithTitleAndBraces(title, indent, ^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        BOOL isFirstItem = YES;
        
        for (id key in container) {
            if (!isFirstItem) {
                [buffer appendString:@"\n"];
            }
            NSString *keyDescription = [key lh_descriptionWithIndent:indent];
            [buffer appendFormat:@"%@key = %@", indentString, keyDescription];
            
            NSCAssert([container respondsToSelector:@selector(objectForKey:)], nil);
            id value = [(id)container objectForKey:key];
            
            NSString *valueDescription = [value lh_descriptionWithIndent:indent];
            [buffer appendFormat:@"%@value = %@", indentString, valueDescription];
            
            isFirstItem = NO;
        }
    });
}


static void LHSwizzleDescriptionForClasses(NSArray<NSString *> *classes, Class sourceClazz) {
    for (NSString *name in classes) {
        Class clazz = NSClassFromString(name);
        if (clazz == nil) {
            return;
        }
        
        Method m1 = class_getInstanceMethod(clazz, @selector(description));
        Method m2 = class_getInstanceMethod(sourceClazz, @selector(lh_description));
        method_setImplementation(m1, method_getImplementation(m2));
    }
}


@implementation NSObject (LHDebugDescription)

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    NSDictionary<NSString *, id> *props = [self lh_debugProperties];
    if (!props) {
        return [self description];
    }
    NSString *title = [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
    
    NSString *objectDescription = LHDescriptionWithTitleAndBraces(title, indent, ^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        for (NSString *name in props) {
            id value = props[name];
            [buffer appendFormat:@"%@%@ = %@\n", indentString, name, [value lh_descriptionWithIndent:indent]];
        }
    });
    return [NSString stringWithFormat:@"%@\n", objectDescription];
}

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return nil;
}

- (NSString *)lh_description {
    return [self description];
}

@end


@implementation NSArray (LHDebugDescription)

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    NSString *title = [NSString stringWithFormat:@"<NSArray: %p>", self];
    return LHContainerDescription(self, title, indent);
}

- (NSString *)lh_description {
    return [self lh_descriptionWithIndent:0];
}

#if DEBUG
+ (void)load {
    LHSwizzleDescriptionForClasses(@[ @"__NSArrayI", @"__NSArrayM", @"__NSSingleObjectArrayI" ], self);
}
#endif

@end


@implementation NSMapTable (LHDebugDescription)

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    NSString *title = [NSString stringWithFormat:@"<NSMapTable: %p>", self];
    return LHKeyValueContainerDescription(self, title, indent);
}

- (NSString *)lh_description {
    return [self lh_descriptionWithIndent:0];
}

#if DEBUG
+ (void)load {
    LHSwizzleDescriptionForClasses(@[ @"NSConcreteMapTable" ], self);
}
#endif

@end


@implementation NSSet (LHDebugDescription)

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    NSString *title = [NSString stringWithFormat:@"<NSSet: %p>", self];
    return LHContainerDescription(self, title, indent);
}

- (NSString *)lh_description {
    return [self lh_descriptionWithIndent:0];
}

#if DEBUG
+ (void)load {
    LHSwizzleDescriptionForClasses(@[ @"__NSSetI", @"__NSSetM", @"__NSSingleObjectSetI" ], self);
}
#endif

@end


@implementation NSOrderedSet (LHDebugDescription)

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    NSString *title = [NSString stringWithFormat:@"<NSOrderedSet: %p>", self];
    return LHContainerDescription(self, title, indent);
}

- (NSString *)lh_description {
    return [self lh_descriptionWithIndent:0];
}

#if DEBUG
+ (void)load {
    LHSwizzleDescriptionForClasses(@[ @"__NSOrderedSetI", @"__NSOrderedSetM" ], self);
}
#endif

@end
