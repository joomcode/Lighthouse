//
//  LHAssert.m
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 29.07.2024.
//  Copyright © 2024 Pixty. All rights reserved.
//

#import "LHAssert.h"
#import <sys/sysctl.h>

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_SIMULATOR

static BOOL LHAssertIsDebuggerAttached(void) {
    // See http://developer.apple.com/library/mac/#qa/qa1361/_index.html
    int mib[] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid() };
    struct kinfo_proc info;
    size_t size = sizeof(info);
    return sysctl(mib, LH_LENGTH_OF(mib), &info, &size, NULL, 0) == 0 ? LH_HAS_FLAGS(info.kp_proc.p_flag, P_TRACED) : NO;
}

// LHAssertDebugBreak is same as __builtin_trap, but allows resuming
// execution after the break.
#if __i386__ || __x86_64__
#define LHAssertDebugBreak() asm("int3")
#elif __arm__
#define LHAssertDebugBreak()                              \
  asm("mov r0, %0    \n" /* PID                        */ \
      "mov r1, 0x11  \n" /* SIGSTOP                    */ \
      "mov r12, 0x25 \n" /* syscall kill               */ \
      "svc 0x80      \n" /* software interrupt         */ \
      "mov r0, r0    \n" /* nop to pause debugger here */ \
      ::"r"(getpid())                                     \
      : "r0", "r1", "r12", "memory")
#elif __arm64__
#define LHAssertDebugBreak()                    \
  asm("mov x0, %x0   \n" /* PID                        */ \
      "mov x1, 0x11  \n" /* SIGSTOP                    */ \
      "mov x16, 0x25 \n" /* syscall kill               */ \
      "svc 0x80      \n" /* software interrupt         */ \
      "mov x0, x0    \n" /* nop to pause debugger here */ \
      ::"r"(getpid())                                     \
      : "x0", "x1", "x16", "memory")
#else
#error "Unsupported architecture."
#endif  // __i386__ || __x86_64__

@implementation LHAssertionHandler

+ (void)handleFailureInFunction:(NSString *)functionName
                           file:(NSString *)fileName
                     lineNumber:(NSInteger)line
                    description:(nullable NSString *)format,... NS_FORMAT_FUNCTION(4,5) {
    let message = [NSMutableString stringWithFormat:@"*** Assertion failure in %@, %@:%lu", functionName, fileName, (unsigned long)line];

    if (format) {
        va_list args;
        va_start(args, format);

        [message appendString:@", reason: '"];
        [message appendString:[[NSString alloc] initWithFormat:format arguments:args]];
        [message appendString:@"'"];

        va_end(args);
    }

    [LHSharedLogger() logMessageWithLevel:LHLogLevelError format:@"%@", message];

    if (LHAssertIsDebuggerAttached()) {
        LHAssertDebugBreak();
    } else {
        // Do nothing. We don't want to crash when the debugger is not attached.
    }
}

@end

#endif

NS_ASSUME_NONNULL_END
