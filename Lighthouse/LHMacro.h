//
//  LHMacro.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Based on EXTKeyPathCoding [https://github.com/jspahrsummers/libextobjc].
//

#import <Foundation/Foundation.h>

#define LHObjectKeyPath(OBJ, PATH)  @(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

#define LHClassKeyPath(CLS, PATH)  @(((void)(NO && ((void)[CLS new].PATH, NO)), # PATH))