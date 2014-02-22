/*
 Stolen, with shame, and modified from Cylinder, therefore it's probably under the GPL
 */

#import "L2AScriptController.h"
#import "L2ATableViewCell.h"
#import "L2AScript.h"
#include <objc/runtime.h>
#import <notify.h>

void writeSettings(NSMutableArray *array)
{
	NSString *str = @"";
	for (L2AScript *s in array)
		str = [NSString stringWithFormat:@"%@%@%@",str,s.name,@".lua\n"];

	//you shouldn't be writing to /Library
	//try /User/Library instead
    //NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Link2App/"];
 
	//make our DIR in /User/Library/ if it doesn't exist
    //this should be ignored (no errors) if the DIR already exists
    //[[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];

	//this is an array, why wouldn't you just use the pref bundle 
	//to write the array to the pref plist file in NSHomeDirectory() Library/Preferences/
	//then read from there?
	NSString* selectedScripts = @"/Library/Link2App/selected_scripts";
	[str writeToFile:selectedScripts atomically:YES encoding:NSUTF8StringEncoding error:nil];
	notify_post("com.efrederickson.link2app/reloadScripts");

}

NSMutableArray* loadSettings()
{
	//NSString* file = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Link2App/selected_scripts"];
    NSString *file = @"/Library/Link2App/selected_scripts";
	NSString* fileContents = [NSString stringWithContentsOfFile:file
	                                                   encoding:NSUTF8StringEncoding
	                                                      error:nil];
	NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableArray *ret = [NSMutableArray array];
	for (NSString *line in lines)
	{
	    NSArray *ext = [line.lastPathComponent componentsSeparatedByString: @"."];
	    NSMutableString *name = [NSMutableString string];
	    for(int i = 0; i < ext.count - 1; i++)
	    {
	        [name appendString:[ext objectAtIndex:i]];
	        if(i != ext.count - 2) [name appendString:@"."];
	    }
	    [ret addObject:name];
	}
	return ret;
}

static L2AScriptController *sharedController = nil;

@implementation UIDevice (OSVersion)
- (BOOL)iOSVersionIsAtLeast:(NSString*)version
    {
        NSComparisonResult result = [[self systemVersion] compare:version options:NSNumericSearch];
        return (result == NSOrderedDescending || result == NSOrderedSame);
    }
    @end

@interface UITableView (Private)
- (NSArray *) indexPathsForSelectedRows;
    @property(nonatomic) BOOL allowsMultipleSelectionDuringEditing;
    @end

@interface PSViewController(Private)
-(void)viewWillAppear:(BOOL)animated;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
    @end


@implementation L2AScriptController
    @synthesize scripts = _scripts, selectedScripts=_selectedScripts;
    
- (id)initForContentSize:(CGSize)size
    {
        if ((self = [super initForContentSize:size]))
        {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
            [_tableView setDataSource:self];
            [_tableView setDelegate:self];
            [_tableView setEditing:NO];
            [_tableView setAllowsSelection:YES];
            [_tableView setAllowsMultipleSelection:NO];
            [_tableView setAllowsSelectionDuringEditing:YES];
            [_tableView setAllowsMultipleSelectionDuringEditing:YES];
            
            if ([self respondsToSelector:@selector(setView:)])
			    [self performSelectorOnMainThread:@selector(setView:) withObject:_tableView waitUntilDone:YES];
        }
        sharedController = self;
        return self;
    }
    
- (void)addScriptsFromDirectory:(NSString *)directory
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *directoryContents = [manager contentsOfDirectoryAtPath:directory error:nil];
        
        for (NSString *script in directoryContents)
        {
            L2AScript *sc = [L2AScript scriptWithPath:[directory stringByAppendingPathComponent:script]];
            if(sc)
                [self.scripts addObject:sc];
        }
        
        NSMutableArray *oldSettings = loadSettings();
        for (NSString *str in oldSettings)
        {
            L2AScript *scr = [self scriptWithName:str]; // haha confusing names o_O
            scr.selected = true;
            if (scr)
            {
                [self.selectedScripts addObject:scr];
            }
        }
    }
    
-(L2AScript*)scriptWithName:(NSString*)name
    {
        if(!name) return nil;
        
        for(L2AScript *script in self.scripts)
        {
            if([script.name isEqualToString:name])
            {
                return script;
            }
        }
        return nil;
    }
    
- (void)refreshList
    {
        self.scripts = [NSMutableArray array];
        self.selectedScripts = [NSMutableArray array];
        [self addScriptsFromDirectory:@"/Library/Link2App/Scripts/"];
    }
    
- (void)viewWillAppear:(BOOL)animated
    {
        if(!_initialized)
        {
            [self refreshList];
            _initialized = true;
        }
        [super viewWillAppear:animated];
    }
    
- (void)dealloc
    {
        sharedController = nil;
        self.selectedScripts = nil;
        self.scripts = nil;
        [super dealloc];
    }
    
- (NSString*)navigationTitle
    {
        return @"Scripts";
    }
    
- (id)view
    {
        return _tableView;
    }
    
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 1;
    }
    
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        if(section == self.scripts.count) return 1;
        
        return [self.scripts count];
    }
    
    
-(L2AScript *)scriptAtIndexPath:(NSIndexPath *)indexPath
    {
        L2AScript *script = [self.scripts objectAtIndex:indexPath.row];
        return script;
    }
    
-(id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        L2ATableViewCell *cell = (L2ATableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"scriptCell"];
        if (!cell)
            cell = [L2ATableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scriptCell"].autorelease;
        
        L2AScript *script = [self scriptAtIndexPath:indexPath];
        cell.script.cell = nil;
        script.cell.script = nil;
        script.cell = cell;
        cell.script = script;
        
        cell.textLabel.text = script.name;
        cell.selected = false;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.orderLabel.text = script.selected ? [NSString stringWithFormat:@"%d", (int)([self.selectedScripts indexOfObject:script] + 1)] : @"";
        
        return cell;
    }
    
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if (!tableView.isEditing)
        {
            // deselect old one
            [tableView deselectRowAtIndexPath:indexPath animated:true];
            
            L2AScript *script = [self scriptAtIndexPath:indexPath];
            script.selected = !script.selected;
            
            if(script.selected)
            {
                [self.selectedScripts addObject:script];
            }
            else
            {
                script.cell.orderLabel.text = @"";
                [self.selectedScripts removeObject:script];
            }
            
            for(int i = 0; i < self.selectedScripts.count; i++)
            {
                L2AScript *e = [self.selectedScripts objectAtIndex:i];
                L2ATableViewCell *cell = (L2ATableViewCell *)e.cell;
                cell.orderLabel.text = [NSString stringWithFormat:@"%d", (i + 1)];
            }
            
            writeSettings(self.selectedScripts);
        }
    }
    
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
    {
        return (UITableViewCellEditingStyle)3;
    }
    
    @end


// borrowed from winterboard
#define WBSAddMethod(_class, _sel, _imp, _type) \
if (![[_class class] instancesRespondToSelector:@selector(_sel)]) \
class_addMethod([_class class], @selector(_sel), (IMP)_imp, _type)

void $PSViewController$hideNavigationBarButtons(PSRootController *self, SEL _cmd) {
}

id $PSViewController$initForContentSize$(PSRootController *self, SEL _cmd, CGRect contentSize) {
    return [self init];
}static __attribute__((constructor)) void __wbsInit() {
    WBSAddMethod(PSViewController, hideNavigationBarButtons, $PSViewController$hideNavigationBarButtons, "v@:");
    WBSAddMethod(PSViewController, initForContentSize:, $PSViewController$initForContentSize$, "@@:{ff}");
}
