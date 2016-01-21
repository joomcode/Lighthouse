//
//  LHDriverProviderContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHDriverFeedbackChannel;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriverProviderContext <NSObject>

@property (nonatomic, strong, readonly) id<LHDriverFeedbackChannel> feedbackChannel;

@end


NS_ASSUME_NONNULL_END