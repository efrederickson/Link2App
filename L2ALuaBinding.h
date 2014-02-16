#import "lua/lua.h"

@interface L2ALuaBinding : NSObject
{
    lua_State *L;
    int funcIndex;
}
-(id) init;
-(NSString*) modify:(NSString*)input;
-(void) disposeOfLua;
-(void) createNewLua;
@end