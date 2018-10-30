#include <CoreFoundation/CoreFoundation.h>
#include <Carbon/Carbon.h> /* For kVK_ constants, and TIS functions. */
CFStringRef CreateStringForKeyCodeAndShift(CGKeyCode keyCode, Boolean shift);
