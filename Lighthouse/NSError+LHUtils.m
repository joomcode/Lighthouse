//
//  NSError+LHUtils.m
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 29.07.2024.
//  Copyright © 2024 Pixty. All rights reserved.
//

#import "NSError+LHUtils.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSError (LHUtils)

+ (instancetype)lh_nonFatalErrorWithDescription:(NSString *)description, ... {
    va_list args;
    va_start(args, description);

    description = [[NSString alloc] initWithFormat:description arguments:args];

    va_end(args);

    return [NSError errorWithDomain:@"Lighthouse" code:-1 userInfo:@{
        NSLocalizedDescriptionKey: description,
    }];
}

@end

NS_ASSUME_NONNULL_END
