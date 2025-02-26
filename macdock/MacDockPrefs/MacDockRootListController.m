#import <Foundation/Foundation.h>
#import "MacDockRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>




#define PreferencesChangedNotification "com.idd.macdockprefs.prefs"

static PSListController *parentVC;


@implementation MacDockRootListController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    parentVC = [[PSListController alloc]init];
    parentVC = self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:path atomically:YES];
   
    //notify call out
    CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
    if (notificationName) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
    }
}

@end





@interface MacDockHeaderCell : PSTableCell {
    UIImageView *MDheaderImg;
    
}
-(void)about:(id)sender;

@end

@implementation MacDockHeaderCell



- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
    if (self) {
        MDheaderImg = [[UIImageView alloc]initWithFrame:CGRectMake(-15,-50,self.frame.size.width,250)];
        
        [MDheaderImg setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MacDockPrefs.bundle/MDHeader.png"]];
        
        [self addSubview:MDheaderImg];

        MDheaderImg.contentMode = UIViewContentModeScaleAspectFit;
        MDheaderImg.translatesAutoresizingMaskIntoConstraints = NO;

        // Center the UIImageView within the UIView
        [NSLayoutConstraint activateConstraints:@[
            [MDheaderImg.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            
        ]];
        
        
        [MDheaderImg setBackgroundColor:[UIColor clearColor]];
      
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:MDheaderImg action:@selector(about:)];
        [tap setNumberOfTouchesRequired:1];
        tap.numberOfTapsRequired = 2;
        MDheaderImg.userInteractionEnabled = YES;
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self) {
        
    }
    
    [MDheaderImg setFrame:CGRectMake(-15,-50,self.frame.size.width,250)];
    MDheaderImg.contentMode = UIViewContentModeScaleAspectFit;
    MDheaderImg.translatesAutoresizingMaskIntoConstraints = NO;

    // Center the UIImageView within the UIView
    [NSLayoutConstraint activateConstraints:@[
        [MDheaderImg.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        
    ]];
    
    
    //header fix/hack - during updates content view would go black and alpha would drop making a very ugly look
    NSString * userPrefsFile = @"/User/Library/Preferences/com.apple.uikitservices.userInterfaceStyleMode.plist";
    NSMutableDictionary *devicePrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:userPrefsFile];
    int darkMode = [[devicePrefs objectForKey:@"UserInterfaceStyleMode"]intValue];
    
    if (darkMode == 1) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0]];
        
    }
    if (darkMode == 2) {
        
        
    }
    
    
    
}


- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    // Return a custom cell height.
    return 150.f;
}

-(void)about:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MacDock 1.0" message:@"A SensiSoft Product 2025" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
    }];
    
    [alert addAction:cancelAction];
   
    if (parentVC) {
        [parentVC presentViewController:alert animated:YES completion:nil];
    }
    
}


-(void)respring{
    
}

@end
