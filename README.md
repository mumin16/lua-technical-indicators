# lua-technical-indicators
in c/c++ example


	std::vector<double> price = { 1,2,3,4,5,6,7,8,9,10 };
  
	/* initialize Lua */
	lua_State*	L = lua_open();
	/* load Lua base libraries */
	luaL_openlibs(L);
	/* load the script */
	luaL_dofile(L, "roc.lua");

	/* push functions and arguments */
	lua_getglobal(L, "ROC");  /* function to be called */
							  
	//push 1st argument source-type table-vector-array
	lua_newtable(L);              
	for (int i = 0; i<price.size(); i++) {
		lua_pushnumber(L, i + 1);   
		lua_pushnumber(L, price[i]); 
		lua_settable(L, -3);         
	}

	/* push 2nd argument */
	lua_pushnumber(L, 9);   
	if (lua_pcall(L, 2, 1, 0) != 0) {std::cout << lua_tostring(L, -1);}
	if (lua_isnil(L, -1)) {
		std::cout << "nil returned!";
	}

	std::vector<double> result;
  
	lua_pushnil(L);
	while (lua_next(L, -2)) {
		result.push_back((int)lua_tonumber(L, -1));
		lua_pop(L, 1);
	}

	lua_close(L);
