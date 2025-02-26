//Created by @ter4m (Toneschi) FreeAppl3 Feb 2025
//enabling the ipad dock on iphone

#import <SpringBoard/SpringBoard.h>

//seperate headers for structure if you decide to build
#import "MacDock.h"//no headers used at this point
#import "Settings.h"


//MD PrefsFile
#define PreferencesFilePath [NSHomeDirectory() stringByAppendingPathComponent:@"/User/Library/Preferences/com.idd.macdockprefs.plist"]

//Preference CallBacks for live updates on settings if possible
#define PreferencesChangedNotification "com.idd.macdock.prefs"



%hook SBFloatingDockController

+ (BOOL)isFloatingDockSupported {
    if(MDEnabled){
        return YES;
    }
    return %orig;
}

%end


%hook SBFloatingDockDefaults

- (BOOL)recentsEnabled {
    if(MDEnabled){
        return YES;
    }
    return %orig;
}

- (BOOL)appLibraryEnabled {
    if(MDEnabled){
        return EnableAppLibrary;
    }
    return %orig;
}

%end

%hook SBFloatingDockSuggestionsModel

// iOS 13-15
- (id)initWithMaximumNumberOfSuggestions:(unsigned long long)arg1 iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 analyticsClient:(id)arg8 applicationController:(id)arg9 {
    
    if(MDEnabled){
        return %orig(MDRecentValue, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
    }
    return %orig;
}

// iOS 16
- (id)initWithMaximumNumberOfSuggestions:(unsigned long long)arg1 iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 applicationController:(id)arg8 {
    
    if(MDEnabled){
        return %orig(MDRecentValue, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
    }
    return %orig;
}

%end



static void loadPrefs() {
    
    static NSString * file = @"/User/Library/Preferences/com.idd.macdockprefs.plist";
    preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    NSLog(@"MacDock Preferences: %@",preferences);
    
    //general settings prefs
    MDEnabled = [[preferences objectForKey:@"EnableMD"]boolValue];
    MDRecentValue = [[preferences objectForKey:@"MDRecentValue"]integerValue];
    EnableAppLibrary = [[preferences objectForKey:@"EnableAppLibrary"]boolValue];
    MDActiveLight = [[preferences objectForKey:@"MDActiveLight"]boolValue];
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSLog(@"MacDock PreferencesChangedCallback CFStringRef:%@",name);
    loadPrefs();
}

__attribute__((constructor)) static void macDock_init() {
    
    %init;
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR(PreferencesChangedNotification), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
}
