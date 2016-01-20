//
//  LHUpdateHandler.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHUpdateBus;

NS_ASSUME_NONNULL_BEGIN


@protocol LHUpdateHandler <NSObject>

- (void)awakeForLighthouseUpdateHandlingWithUpdateBus:(id<LHUpdateBus>)updateBus;

@end


NS_ASSUME_NONNULL_END