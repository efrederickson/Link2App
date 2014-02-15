// Small parts based off of Cylinder code...

#import "L2ALuaBinding.h"
#import "lua/lua.h"
#import "lua/lualib.h"
#import "lua/lauxlib.h"
#import "lfs.h"

#define PLUGIN_PATH @"/Library/Link2App/Scripts/"

static const char *OS_DANGER[] = {
    "exit",
    "setlocale",
    //"date",
    //"getenv",
    //"difftime",
    "remove",
    //"time",
    //"clock",
    "tmpname",
    "rename",
    //"execute", - handled in main.lua
    NULL
};

static int l_print(lua_State *L)
{
    const char *str = lua_tostring(L, 1);
    if(str == NULL) return luaL_error(L, "invalid argument to print");
    
    NSLog(@"L2A: lua_print: %s", str);
    return 0;
}

/*static int l_dofile_override(lua_State *L)
{
    const char *file = lua_tostring(L, 1);
    
    if(file != NULL)
    file = [NSString stringWithFormat:@"/Library/Link2App/Scripts/%s", file].UTF8String;
    
    int top = lua_gettop(L);
    lua_pushvalue(L, lua_upvalueindex(1));
    lua_insert(L, 1);
    
    if(file != NULL)
    {
        lua_pushstring(L, file);
        lua_remove(L, 2);
        lua_insert(L, 2);
    }
    lua_call(L, top, 1);
    return 1;
}*/

int open_main(lua_State *L)
{
    int func = -1;
    
    //load our file and save the function we want to call
    if(luaL_loadfile(L, "/Library/Link2App/Scripts/main.lua") != LUA_OK || lua_pcall(L, 0, 1, 0) != 0)
    {
        NSLog(@"L2A: failed to load main script: %s", lua_tostring(L, -1));
    }
    else if(!lua_isfunction(L, -1))
    {
        NSLog(@"L2A: failed to load main script: return value was not a function");
    }
    else
    {
        NSLog(@"L2A: loaded main script");
        lua_pushvalue(L, -1);
        func = luaL_ref(L, LUA_REGISTRYINDEX);
    }
    
    lua_pop(L, 1);
    
    return func;
}

@implementation L2ALuaBinding
-(id) init
{
    id obj = [super init];
    
    // init Lua
    L = luaL_newstate();
    luaL_openlibs(L);
    luaopen_lfs(L);
    //disable dangerous libraries
    lua_pushnil(L);
    lua_setglobal(L, LUA_LOADLIBNAME);
    lua_pushnil(L);
    lua_setglobal(L, "require");
    
    //disable dangerous OS functions
    lua_getglobal(L, LUA_OSLIBNAME);
    for(int i = 0; OS_DANGER[i] != NULL; i++)
    {
        lua_pushstring(L, OS_DANGER[i]);
        lua_pushnil(L);
        lua_settable(L, -3);
    }
    lua_pop(L, 1);
    
    //lua_getglobal(L, "dofile");
    //lua_pushcclosure(L, l_dofile_override, 1);
    //lua_setglobal(L, "dofile");
    
    lua_pushcfunction(L, l_print);
    lua_setglobal(L, "print");
    
    funcIndex = open_main(L);
    
    return obj;
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
        NSLog(@"L2A: failed to modify url");
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