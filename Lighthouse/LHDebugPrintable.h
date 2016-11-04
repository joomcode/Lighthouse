//
//  LHDebugPrintable.h
//  Lighthouse
//
//  Created by Makarov Yury on 04/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LHDebugPrintable <NSObject>

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent;

@end

NS_ASSUME_NONNULL_END
