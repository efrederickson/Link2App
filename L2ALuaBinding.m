#import "L2ALuaBinding.h"
#import "lua/lua.h"
#import "lua/lualib.h"
#import "lua/lauxlib.h"
#import "lua/lfs.h"

#define PLUGIN_PATH @"/Library/Link2App/Scripts/"

static int l_print(lua_State *L)
{
    const char *str = lua_tostring(L, 1);
    if(str == NULL) return luaL_error(L, "invalid argument to print");
    
    NSLog(@"L2A.lua_print: %s", str);
    return 0;
}

@implementation L2ALuaBinding
-(id) init
{
    id obj = [super init];
    [self createNewLua];
    return obj;
}
    
-(void) disposeOfLua
{
    if (L)
        lua_close(L);
    L = NULL;
}
    
-(void) createNewLua
{
    // init Lua
    L = luaL_newstate();
    luaL_openlibs(L);
    luaopen_lfs(L);
    
    // Change print function so output can be debugged via NSLog
    lua_pushcfunction(L, l_print);
    lua_setglobal(L, "print");
    
    // load main Lua script
    if(luaL_loadfile(L, "/Library/Link2App/main.lua") != LUA_OK || lua_pcall(L, 0, 1, 0) != 0)
    {
        NSLog(@"L2A: failed to load main script: %s", lua_tostring(L, -1));
    }
    else if(!lua_isfunction(L, -1))
    {
        NSLog(@"L2A: failed to load main script: return value was not a function");
    }
    else
    {
        //NSLog(@"L2A: loaded main script");
        lua_pushvalue(L, -1);
        funcIndex = luaL_ref(L, LUA_REGISTRYINDEX);
    }
    
    lua_pop(L, 1);
}
    
-(NSString*) modify:(NSString*)input
{
    //NSLog(@"L2A: modify %@", input);
    lua_rawgeti(L, LUA_REGISTRYINDEX, funcIndex);
    //NSLog(@"L2A: got func");
    NSString *temp = [[NSString alloc] initWithFormat:@"%@", input];
    const char *str = [temp UTF8String];
    //NSLog(@"L2A: cstr: %s", str);
    lua_pushstring(L, str);
    //NSLog(@"L2A: pushed input");
    if (lua_pcall(L, 1, 1, 0) != 0)
    {
        // log error
        NSLog(@"L2A: failed to modify url %s", lua_tostring(L, -1));
        [temp release];
        return input;
    }
    else
    {
        [temp release];
        const char *result = lua_tostring(L, -1);
        //NSLog(@"L2A: modified url %@ -> %s", input, result);
        return [[NSString stringWithUTF8String:result] retain];
    }
}
@end