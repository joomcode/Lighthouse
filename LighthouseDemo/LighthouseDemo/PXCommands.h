//
//  PXCommands.h
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Lighthouse.h>

@interface PXPresentRed : NSObject <LHCommand>

@end


@interface PXPresentGreen : NSObject <LHCommand>

@end


@interface PXPresentBlue : NSObject <LHCommand>

@end


@interface PXPresentBlueThroughGreen : NSObject <LHCommand>

@end


@interface PXPresentModal : NSObject <LHCommand>

@end


@interface PXDismissModal : NSObject <LHCommand>

@end


@interface PXPresentAnotherModal : NSObject <LHCommand>

@end
