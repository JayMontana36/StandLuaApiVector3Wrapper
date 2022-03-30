local DummyFunctionA = function()end
local DummyFunctionB = function()return DummyFunctionA end

local V3WrapperKeyFunctionsA = setmetatable(
	{
		x = v3.getX,
		y = v3.getY,
		z = v3.getZ,
	},
	{
		__index=DummyFunctionB
	}
)
local V3WrapperKeyFunctionsB = setmetatable(
	{
		x = v3.setX,
		y = v3.setY,
		z = v3.setZ,
	},
	{
		__index=DummyFunctionB
	}
)

local V3WrapperMetaTable =
{
	__gc		=	function(Self)
						local MemPtrV3 = Self.V3
						if MemPtrV3 then
							v3.free(MemPtrV3)
						end
					end,
	__index		=	function(Self, Key, ...)
						local MemPtrV3 = Self.V3
						return V3WrapperKeyFunctionsA[Key](MemPtrV3, ...) or MemPtrV3
					end,
	__newindex	=	function(Self, Key, Value, ...)
						if (Key == "x" or Key == "y" or Key == "z") and Key ~= "V3" then
							local MemPtrV3 = Self.V3
							return V3WrapperKeyFunctionsB[Key](MemPtrV3, Value, ...)
						end
						Self[Key] = Value
					end,
}

local V3WrapperArchive = setmetatable({},{ __mode	= "kv" })

local v3_new = v3.new
local V3NewFunctions =
{
	table	=	function(V3Table)
					V3Table.V3 = v3_new(V3Table)
					V3Table.x, V3Table.y, V3Table.z = nil, nil, nil
					return V3Table
				end,
	number	=	function(x, args)
					return { V3 = v3_new(x, args[2], args[3]) }
				end,
}
local V3New = function(...)
	local args = {...}
	local arg1 = args[1]
	
	local WrappedV3 = setmetatable(V3NewFunctions[type(arg1)](arg1, args),V3WrapperMetaTable)
	
	table.insert(V3WrapperArchive, WrappedV3)
	
	return WrappedV3
end

--v3.new = V3New
return V3New