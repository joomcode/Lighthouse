//
//  LHAssert.h
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 29.07.2024.
//  Copyright © 2024 Pixty. All rights reserved.
//

#import "LHMacro.h"

NS_ASSUME_NONNULL_BEGIN

#if DEBUG

#if TARGET_OS_SIMULATOR

@interface LHAssertionHandler : NSObject

+ (void)handleFailureInFunction:(NSString *)functionName
                           file:(NSString *)fileName
                     lineNumber:(NSInteger)line
                    description:(nullable NSString *)format,... NS_FORMAT_FUNCTION(4,5);

@end

/// Assertion macros, such as `LHAssert`, are used to evaluate a condition, and if the condition evaluates to false, the macros pass
/// a string to an assertion handler describing the failure. When invoked, an assertion handler prints an error message that
/// includes the method and class (or function) containing the assertion.
///
/// In debug builds (`-D DEBUG=1`), `LHAssertionHandler` is used.
///
/// @note When the application is run under debugger control, `LHAssertionHandler`
/// pauses execution, but doesn't interrupt it.
///
/// In release builds, `LHAssert` is mapped to `NSCAssert`, e.g. `NSAssertionHandler` is used.
///
/// @note Unlike `LHAssertionHandler`, `NSAssertionHandler` raises `NSInternalInconsistencyException`. Thus, execution can't be continued.
#define _LHAssert(condition_, description_...) \
    do { \
        __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        if (__builtin_expect(!(condition_), 0)) { \
            NSString *__assert_fn__ = [NSString stringWithUTF8String:__PRETTY_FUNCTION__]; \
            __assert_fn__ = __assert_fn__ ? __assert_fn__ : @"<Unknown Function>"; \
            NSString *__assert_file__ = [NSString stringWithUTF8String:__FILE__]; \
            __assert_file__ = __assert_file__ ? __assert_file__ : @"<Unknown File>"; \
            [LHAssertionHandler handleFailureInFunction:__assert_fn__ \
                                                   file:__assert_file__ \
                                             lineNumber:__LINE__ \
                                            description:LH_IF_EMPTY(description_)(nil)(description_)]; \
        } \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)

//#undef NSAssert
//#undef NSCAssert

//#undef NSParameterAssert
//#undef NSCParameterAssert

//extern void NSAssert(BOOL condition, NSString *format, ...) NS_FORMAT_FUNCTION(2, 3) __attribute__((unavailable("Use `LHAssert` instead")));
//extern void NSCAssert(BOOL condition, NSString *format, ...) NS_FORMAT_FUNCTION(2, 3) __attribute__((unavailable("Use `LHAssert` instead")));

//extern void NSParameterAssert(BOOL condition) __attribute__((unavailable("Use `LHParameterAssert` instead")));
//extern void NSCParameterAssert(BOOL condition) __attribute__((unavailable("Use `LHParameterAssert` instead")));

#else // !TARGET_OS_SIMULATOR

#define _LHAssert(condition_, description_...) do {} while (0)

#endif // TARGET_OS_SIMULATOR

#define LHParameterAssert(condition_) LHAssert((condition_), @"Invalid parameter not satisfying: %@", @#condition_)

#else // !DEBUG

#define _LHAssert(condition, description_...) NSCAssert((condition_), LH_IF_EMPTY(description_)(nil)(description_))
#define LHParameterAssert(condition_) NSCParameterAssert((condition_))

#endif // DEBUG

#define LHAssert(/*condition, description, ...*/ ...) _LHAssert(__VA_ARGS__)

#define LHAssertionFailure(description_...) _LHAssert(NO, ##description_);

NS_ASSUME_NONNULL_END
