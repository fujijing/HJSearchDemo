//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import <sys/sysctl.h>
#import "CSPSystemInfo.h"
#import "OpenUDID.h"
#import "sys/utsname.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface CSPSystemInfo ()
+ (NSString *)deviceString;
@end

@implementation CSPSystemInfo

+ (NSString *)OSVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	NSString *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	return value;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appBuildVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	NSString *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	if (nil == value || 0 == value.length)
	{
		value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	}
	return value;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static NSString *__identifier = nil;
	if (nil == __identifier)
	{
		__identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
	}
	return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [UIDevice currentDevice].model;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceUUID
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	Class openUDID = NSClassFromString(@"OpenUDID");
	if (openUDID)
	{
		return [openUDID value];
	}
	else
	{
		return nil; // [UIDevice currentDevice].uniqueIdentifier;
	}
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char *__jb_app = NULL;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static const char *__jb_apps[] = {
			"/Application/Cydia.app", "/Application/limera1n.app", "/Application/greenpois0n.app", "/Application/blackra1n.app", "/Application/blacksn0w.app", "/Application/redsn0w.app", NULL
	};

	__jb_app = NULL;

	// method 1
	for (int i = 0; __jb_apps[i]; ++i)
	{
		if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]])
		{
			__jb_app = __jb_apps[i];
			return YES;
		}
	}

	// method 2
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"])
	{
		return YES;
	}

//    // method 3
//    if (0 == system("ls"))
//    {
//        return YES;
//    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	return NO;
}

+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE)
	if (__jb_app)
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	return @"";
}

+ (BOOL)isDevicePhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSString *deviceType = [UIDevice currentDevice].model;

	if ([deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 || [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 || [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0)
	{
		return YES;
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	return NO;
}

+ (BOOL)isDevicePad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSString *deviceType = [UIDevice currentDevice].model;

	if ([deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0)
	{
		return YES;
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

	return NO;
}

+ (BOOL)isPhone35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [CSPSystemInfo isScreenSize:CGSizeMake(320, 480)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [CSPSystemInfo isScreenSize:CGSizeMake(640, 960)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina4
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [CSPSystemInfo isScreenSize:CGSizeMake(640, 1136)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina6Plus
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	//兼容模式 或 标准模式 或 放大模式
	return [CSPSystemInfo isScreenSize:CGSizeMake(960, 1704)] || [CSPSystemInfo isScreenSize:CGSizeMake(1242, 2208)]
			|| [CSPSystemInfo isScreenSize:CGSizeMake(1125, 2001)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina6
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [CSPSystemInfo isScreenSize:CGSizeMake(750, 1334)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina4S {
	return [[self deviceString] isEqualToString:@"iPhone 4S"];
}

+ (BOOL)isPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [CSPSystemInfo isScreenSize:CGSizeMake(768, 1024)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPadRetina
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [CSPSystemInfo isScreenSize:CGSizeMake(1536, 2048)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isScreenSize:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ([UIScreen instancesRespondToSelector:@selector(currentMode)])
	{
		CGSize screenSize = [UIScreen mainScreen].currentMode.size;
		CGSize size2 = CGSizeMake(size.height, size.width);

		if (CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize))
		{
			return YES;
		}
	}

	return NO;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceString
{
//    // 需要#import "sys/utsname.h"
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//
//    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
//    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
//    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
//    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";


	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	if ([platform isEqualToString:@"iPhone1,1"])    platform= @"iPhone 2G";
	if ([platform isEqualToString:@"iPhone1,2"])    platform= @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"])    platform= @"iPhone 3GS";
	if ([platform isEqualToString:@"iPhone3,1"])    platform= @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,2"])    platform= @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,3"])    platform= @"iPhone 4 (CDMA)";
	if ([platform isEqualToString:@"iPhone4,1"])    platform= @"iPhone 4S";
	if ([platform isEqualToString:@"iPhone5,1"])    platform= @"iPhone 5";
	if ([platform isEqualToString:@"iPhone5,2"])    platform= @"iPhone 5 (GSM+CDMA)";

	if ([platform isEqualToString:@"iPod1,1"])      platform= @"iPod Touch (1 Gen)";
	if ([platform isEqualToString:@"iPod2,1"])      platform= @"iPod Touch (2 Gen)";
	if ([platform isEqualToString:@"iPod3,1"])      platform= @"iPod Touch (3 Gen)";
	if ([platform isEqualToString:@"iPod4,1"])      platform= @"iPod Touch (4 Gen)";
	if ([platform isEqualToString:@"iPod5,1"])      platform= @"iPod Touch (5 Gen)";

	if ([platform isEqualToString:@"iPad1,1"])      platform= @"iPad";
	if ([platform isEqualToString:@"iPad1,2"])      platform= @"iPad 3G";
	if ([platform isEqualToString:@"iPad2,1"])      platform= @"iPad 2 (WiFi)";
	if ([platform isEqualToString:@"iPad2,2"])      platform= @"iPad 2";
	if ([platform isEqualToString:@"iPad2,3"])      platform= @"iPad 2 (CDMA)";
	if ([platform isEqualToString:@"iPad2,4"])      platform= @"iPad 2";
	if ([platform isEqualToString:@"iPad2,5"])      platform= @"iPad Mini (WiFi)";
	if ([platform isEqualToString:@"iPad2,6"])      platform= @"iPad Mini";
	if ([platform isEqualToString:@"iPad2,7"])      platform= @"iPad Mini (GSM+CDMA)";
	if ([platform isEqualToString:@"iPad3,1"])      platform= @"iPad 3 (WiFi)";
	if ([platform isEqualToString:@"iPad3,2"])      platform= @"iPad 3 (GSM+CDMA)";
	if ([platform isEqualToString:@"iPad3,3"])      platform= @"iPad 3";
	if ([platform isEqualToString:@"iPad3,4"])      platform= @"iPad 4 (WiFi)";
	if ([platform isEqualToString:@"iPad3,5"])      platform= @"iPad 4";
	if ([platform isEqualToString:@"iPad3,6"])      platform= @"iPad 4 (GSM+CDMA)";

	if ([platform isEqualToString:@"i386"])         platform= @"Simulator";
	if ([platform isEqualToString:@"x86_64"])       platform= @"Simulator";

	return platform;
}

@end
