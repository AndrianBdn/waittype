//
//  KeyCode.h
//  WaitType
//
//  Created by Andrian Budantsov on 10/25/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//

#include <CoreFoundation/CoreFoundation.h>
#include <Carbon/Carbon.h> /* For kVK_ constants, and TIS functions. */

CGKeyCode keyCodeForChar(const char c);
const char char_tolower(const char c);
