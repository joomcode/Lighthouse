//
//  NSError+LHUtils.h
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 29.07.2024.
//  Copyright © 2024 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (LHUtils)

+ (instancetype)lh_nonFatalErrorWithDescription:(NSString *)description, ...;

@end

NS_ASSUME_NONNULL_END
