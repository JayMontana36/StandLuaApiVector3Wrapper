--[[ Main - Internal Logic Stuff ]]
local v3 <const> = v3
local setmetatable <const> = setmetatable

local V3WrapperMetaTable
do
	local DummyFunction
	do
		local _DummyFunction <const> = function()end
		DummyFunction = function()return _DummyFunction end
	end

	local V3WrapperKeyFunctionsMetaTable <const> = {__index=DummyFunction}
	
	local V3WrapperKeyFunctionsB
	do
		local v3_setX <const>, v3_setY <const>, v3_setZ <const> = v3.setX, v3.setY, v3.setZ
		V3WrapperKeyFunctionsB = setmetatable(
			{
				x = v3_setX,
				y = v3_setY,
				z = v3_setZ,
			},
			V3WrapperKeyFunctionsMetaTable
		)
	end
	
	local V3WrapperKeyFunctionsA
	do
		local v3_getX <const>, v3_getY <const>, v3_getZ <const> = v3.getX, v3.getY, v3.getZ
		V3WrapperKeyFunctionsA = setmetatable(
			{
				x = v3_getX,
				y = v3_getY,
				z = v3_getZ,
			},
			V3WrapperKeyFunctionsMetaTable
		)
	end
	
	local rawset <const> = rawset
	local v3_free <const> = v3.free
	V3WrapperMetaTable =
	{
		__gc		=	function(Self)
							local MemPtrV3 <const> = Self.V3
							if MemPtrV3 then
								v3_free(MemPtrV3)
							end
						end,
		__index		=	function(Self, Key)
							local MemPtrV3 <const> = Self.V3
							return V3WrapperKeyFunctionsA[Key](MemPtrV3) or MemPtrV3
						end,
		__newindex	=	function(Self, Key, Value)
							local Key <const> = Key
							if Key ~= "V3" then
								if (Key == "x" or Key == "y" or Key == "z") then
									local MemPtrV3 <const> = Self.V3
									return V3WrapperKeyFunctionsB[Key](MemPtrV3, Value)
								end
								rawset(Self, Key, Value)
							end
						end,
	}
end



--[[ v3 Functions Overrides ]]
do
	local V3New
	do
		local setmetatable <const> = setmetatable
		
		local V3NewFunctions
		do
			local v3_new <const> = v3.new
			V3NewFunctions =
			{
				table	=	function(V3Table)
								local V3 <const> = not V3Table.V3
								if V3 then
									V3Table.V3 = v3_new(V3Table)
									V3Table.x, V3Table.y, V3Table.z = nil, nil, nil
								end
								return V3Table, V3
							end,
				number	=	function(x, args)
								return { V3 = v3_new(x, args[2], args[3]) }, true
							end,
			}
		end
		
		V3New = function(...)
			local args <const> = {...}
			local arg1 <const> = args[1]
			
			local WrappedV3 <const>, IsNew <const> = V3NewFunctions[type(arg1)](arg1, args)
			if IsNew then
				setmetatable(WrappedV3, V3WrapperMetaTable)
			end
			
			return WrappedV3
		end
	end
	
	do
		local setmetatable <const> = setmetatable
		local WrapNewInstance <const> = function(Instance)
			return setmetatable({ V3 = Instance }, V3WrapperMetaTable)
		end
		local Functions =
		{
			new			=	function()
								return V3New
							end,
			free		=	function()
								local setmetatable <const> = setmetatable
								local v3_free <const> = v3.free
								return function(WrappedV3)
									v3_free(WrappedV3.V3)
									setmetatable(WrappedV3,nil)
									WrappedV3.V3 = nil
								end
							end,
			get			=	function()
								local v3_get <const> = v3.get
								return function(WrappedV3)
									return v3_get(WrappedV3.V3)
								end
							end,
			getX		=	function()
								local v3_getX <const> = v3.getX
								return function(WrappedV3)
									return v3_getX(WrappedV3.V3)
								end
							end,
			getY		=	function()
								local v3_getY <const> = v3.getY
								return function(WrappedV3)
									return v3_getY(WrappedV3.V3)
								end
							end,
			getZ		=	function()
								local v3_getZ <const> = v3.getZ
								return function(WrappedV3)
									return v3_getZ(WrappedV3.V3)
								end
							end,
			getHeading	=	function()
								local v3_getHeading <const> = v3.getHeading
								return function(WrappedV3)
									return v3_getHeading(WrappedV3.V3)
								end
							end,
			set			=	function() -- Make similar to new so that tables can be supplied?
								local v3_set <const> = v3.set
								return function(WrappedV3, x, y, z)
									v3_set(WrappedV3.V3, x, y, z)
								end
							end,
			setX		=	function()
								local v3_setX <const> = v3.setX
								return function(WrappedV3, x)
									v3_setX(WrappedV3.V3, x)
								end
							end,
			setY		=	function()
								local v3_setY <const> = v3.setY
								return function(WrappedV3, y)
									v3_setY(WrappedV3.V3, y)
								end
							end,
			setZ		=	function()
								local v3_setZ <const> = v3.setZ
								return function(WrappedV3, z)
									return v3_setZ(WrappedV3.V3, z)
								end
							end,
			reset		=	function()
								local v3_reset <const> = v3.reset
								return function(WrappedV3)
									v3_reset(WrappedV3.V3)
								end
							end,
			add			=	function()
								local v3_add <const> = v3.add
								return function(WrappedV3A, WrappedV3B)
									v3_add(WrappedV3A.V3, WrappedV3B.V3)
								end
							end,
			sub			=	function()
								local v3_sub <const> = v3.sub
								return function(WrappedV3A, WrappedV3B)
									v3_sub(WrappedV3A.V3, WrappedV3B.V3)
								end
							end,
			mul			=	function()
								local v3_mul <const> = v3.mul
								return function(WrappedV3A, number)
									v3_mul(WrappedV3A.V3, number)
								end
							end,
			div			=	function()
								local v3_div <const> = v3.div
								return function(WrappedV3A, number)
									v3_div(WrappedV3A.V3, number)
								end
							end,
			eq			=	function()
								local v3_eq <const> = v3.eq
								return function(WrappedV3A, WrappedV3B)
									return v3_eq(WrappedV3A.V3, WrappedV3B.V3)
								end
							end,
			magnitude	=	function()
								local v3_magnitude <const> = v3.magnitude
								return function(WrappedV3)
									return v3_magnitude(WrappedV3.V3)
								end
							end,
			distance	=	function()
								local v3_distance <const> = v3.distance
								return function(WrappedV3A, WrappedV3B)
									return v3_distance(WrappedV3A.V3, WrappedV3B.V3)
								end
							end,
			abs			=	function()
								local v3_abs <const> = v3.abs
								return function(WrappedV3)
									v3_abs(WrappedV3.V3)
								end
							end,
			sum			=	function()
								local v3_sum <const> = v3.sum
								return function(WrappedV3)
									v3_sum(WrappedV3.V3)
								end
							end,
			min			=	function()
								local v3_min <const> = v3.min
								return function(WrappedV3)
									return v3_min(WrappedV3.V3)
								end
							end,
			max			=	function()
								local v3_max <const> = v3.max
								return function(WrappedV3)
									return v3_max(WrappedV3.V3)
								end
							end,
			dot			=	function()
								local v3_dot <const> = v3.dot
								return function(WrappedV3A, WrappedV3B)
									return v3_dot(WrappedV3A.V3, WrappedV3B.V3)
								end
							end,
			normalise	=	function()
								local v3_normalise <const> = v3.normalise
								return function(WrappedV3)
									v3_normalise(WrappedV3.V3)
								end
							end,
			crossProduct=	function()
								local v3_crossProduct <const> = v3.crossProduct
								return function(WrappedV3A, WrappedV3B)
									return WrapNewInstance(v3_crossProduct(WrappedV3A.V3, WrappedV3B.V3))
								end
							end,
			toRot		=	function()
								local v3_toRot <const> = v3.toRot
								return function(WrappedV3)
									return WrapNewInstance(v3_toRot(WrappedV3.V3))
								end
							end,
			lookAt		=	function()
								local v3_lookAt <const> = v3.lookAt
								return function(WrappedV3A, WrappedV3B)
									return WrapNewInstance(v3_lookAt(WrappedV3A.V3, WrappedV3B.V3))
								end
							end,
			toDir		=	function()
								local v3_toDir <const> = v3.toDir
								return function(WrappedV3)
									return WrapNewInstance(v3_toDir(WrappedV3.V3))
								end
							end,
			toString	=	function()
								local v3_toString <const> = v3.toString
								return function(WrappedV3)
									return WrapNewInstance(v3_toString(WrappedV3.V3))
								end
							end,
		}
		local pairs <const> = pairs
		for Key, NewReplacementFunction in pairs(Functions) do
			v3[Key] = NewReplacementFunction()
		end
	end
	
	local function OverrideFunctionV3Output(Function)
		local Function <const> = Function
		return function(...)
			return V3New(Function(...))
		end
	end
	v3.V3WrapperOverrideFunctionOutput = OverrideFunctionV3Output
	
	native_invoker.get_return_value_vector3 = OverrideFunctionV3Output(native_invoker.get_return_value_vector3)
	memory.read_vector3 = OverrideFunctionV3Output(memory.read_vector3)
end



return v3