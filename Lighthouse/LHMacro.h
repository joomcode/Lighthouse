//
//  LHMacro.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Based on EXTKeyPathCoding [https://github.com/jspahrsummers/libextobjc].
//

#import <Foundation/Foundation.h>

#define let \
    const __auto_type

#define var \
    __auto_type

#define LHObjectKeyPath(OBJ, PATH)  @(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

#define LHClassKeyPath(CLS, PATH)  @(((void)(NO && ((void)[CLS new].PATH, NO)), # PATH))

#define LH_LENGTH_OF(array_) ({ sizeof((array_)) / sizeof((array_)[0]); })

#define LH_ADD_FLAGS(value_, flags_) ((value_) | (flags_))
#define LH_REMOVE_FLAGS(value_, flags_) ((value_) & ~(flags_))
#define LH_HAS_FLAGS(value_, flags_) (((value_) & (flags_)) == (flags_))

// LH_IF_EMPTY

#define LH_IF_EMPTY(...) \
    LH_IF_EQ(1, LH_ARGCOUNT(0, ##__VA_ARGS__))

// LH_CONCAT

#define LH_CONCAT(a_, b_) \
    LH_CONCAT_(a_, b_)

#define LH_CONCAT_(a_, b_) a_ ## b_

// LH_AT

#define LH_AT(N, ...) \
    LH_CONCAT(LH_AT, N)(__VA_ARGS__)

#define LH_AT0(...) LH_HEAD(__VA_ARGS__)
#define LH_AT1(_0, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT2(_0, _1, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT3(_0, _1, _2, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT4(_0, _1, _2, _3, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT5(_0, _1, _2, _3, _4, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT6(_0, _1, _2, _3, _4, _5, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT7(_0, _1, _2, _3, _4, _5, _6, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT8(_0, _1, _2, _3, _4, _5, _6, _7, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) LH_HEAD(__VA_ARGS__)
#define LH_AT20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) LH_HEAD(__VA_ARGS__)

// LH_ARGCOUNT

#define LH_ARGCOUNT(...) \
    LH_AT(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

// LH_HEAD

#define LH_HEAD(...) \
    LH_HEAD_(__VA_ARGS__, 0)

#define LH_HEAD_(first_, ...) first_

// LH_TAIL

#define LH_TAIL_(first_, ...) __VA_ARGS__

#define LH_TAIL(...) \
    LH_TAIL_(__VA_ARGS__)

// LH_DEC

#define LH_DEC(value_) \
    LH_AT(value_, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

#define LH_CONSUME_(...)
#define LH_EXPAND_(...) __VA_ARGS__

// LH_IF_EQ

#define LH_IF_EQ(a_, b_) \
    LH_CONCAT(LH_IF_EQ, a_)(b_)

#define LH_IF_EQ0(value_) \
    LH_CONCAT(LH_IF_EQ0_, value_)

#define LH_IF_EQ0_0(...) __VA_ARGS__ LH_CONSUME_
#define LH_IF_EQ0_1(...) LH_EXPAND_
#define LH_IF_EQ0_2(...) LH_EXPAND_
#define LH_IF_EQ0_3(...) LH_EXPAND_
#define LH_IF_EQ0_4(...) LH_EXPAND_
#define LH_IF_EQ0_5(...) LH_EXPAND_
#define LH_IF_EQ0_6(...) LH_EXPAND_
#define LH_IF_EQ0_7(...) LH_EXPAND_
#define LH_IF_EQ0_8(...) LH_EXPAND_
#define LH_IF_EQ0_9(...) LH_EXPAND_
#define LH_IF_EQ0_10(...) LH_EXPAND_
#define LH_IF_EQ0_11(...) LH_EXPAND_
#define LH_IF_EQ0_12(...) LH_EXPAND_
#define LH_IF_EQ0_13(...) LH_EXPAND_
#define LH_IF_EQ0_14(...) LH_EXPAND_
#define LH_IF_EQ0_15(...) LH_EXPAND_
#define LH_IF_EQ0_16(...) LH_EXPAND_
#define LH_IF_EQ0_17(...) LH_EXPAND_
#define LH_IF_EQ0_18(...) LH_EXPAND_
#define LH_IF_EQ0_19(...) LH_EXPAND_
#define LH_IF_EQ0_20(...) LH_EXPAND_

#define LH_IF_EQ1(VALUE) LH_IF_EQ0(LH_DEC(VALUE))
#define LH_IF_EQ2(VALUE) LH_IF_EQ1(LH_DEC(VALUE))
#define LH_IF_EQ3(VALUE) LH_IF_EQ2(LH_DEC(VALUE))
#define LH_IF_EQ4(VALUE) LH_IF_EQ3(LH_DEC(VALUE))
#define LH_IF_EQ5(VALUE) LH_IF_EQ4(LH_DEC(VALUE))
#define LH_IF_EQ6(VALUE) LH_IF_EQ5(LH_DEC(VALUE))
#define LH_IF_EQ7(VALUE) LH_IF_EQ6(LH_DEC(VALUE))
#define LH_IF_EQ8(VALUE) LH_IF_EQ7(LH_DEC(VALUE))
#define LH_IF_EQ9(VALUE) LH_IF_EQ8(LH_DEC(VALUE))
#define LH_IF_EQ10(VALUE) LH_IF_EQ9(LH_DEC(VALUE))
#define LH_IF_EQ11(VALUE) LH_IF_EQ10(LH_DEC(VALUE))
#define LH_IF_EQ12(VALUE) LH_IF_EQ11(LH_DEC(VALUE))
#define LH_IF_EQ13(VALUE) LH_IF_EQ12(LH_DEC(VALUE))
#define LH_IF_EQ14(VALUE) LH_IF_EQ13(LH_DEC(VALUE))
#define LH_IF_EQ15(VALUE) LH_IF_EQ14(LH_DEC(VALUE))
#define LH_IF_EQ16(VALUE) LH_IF_EQ15(LH_DEC(VALUE))
#define LH_IF_EQ17(VALUE) LH_IF_EQ16(LH_DEC(VALUE))
#define LH_IF_EQ18(VALUE) LH_IF_EQ17(LH_DEC(VALUE))
#define LH_IF_EQ19(VALUE) LH_IF_EQ18(LH_DEC(VALUE))
#define LH_IF_EQ20(VALUE) LH_IF_EQ19(LH_DEC(VALUE))
