local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 81) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local FlatIdent_76979 = 0;
				local b;
				while true do
					if (FlatIdent_76979 == 1) then
						return b;
					end
					if (FlatIdent_76979 == 0) then
						b = Rep(a, repeatNext);
						repeatNext = nil;
						FlatIdent_76979 = 1;
					end
				end
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local FlatIdent_24A02 = 0;
		local Left;
		local Right;
		local IsNormal;
		local Mantissa;
		local Exponent;
		local Sign;
		while true do
			if (FlatIdent_24A02 == 3) then
				if (Exponent == 0) then
					if (Mantissa == 0) then
						return Sign * 0;
					else
						Exponent = 1;
						IsNormal = 0;
					end
				elseif (Exponent == 2047) then
					return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
				end
				return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
			end
			if (FlatIdent_24A02 == 0) then
				Left = gBits32();
				Right = gBits32();
				FlatIdent_24A02 = 1;
			end
			if (FlatIdent_24A02 == 2) then
				Exponent = gBit(Right, 21, 31);
				Sign = ((gBit(Right, 32) == 1) and -1) or 1;
				FlatIdent_24A02 = 3;
			end
			if (FlatIdent_24A02 == 1) then
				IsNormal = 1;
				Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
				FlatIdent_24A02 = 2;
			end
		end
	end
	local function gString(Len)
		local FlatIdent_63487 = 0;
		local Str;
		local FStr;
		while true do
			if (FlatIdent_63487 == 3) then
				return Concat(FStr);
			end
			if (FlatIdent_63487 == 2) then
				FStr = {};
				for Idx = 1, #Str do
					FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
				end
				FlatIdent_63487 = 3;
			end
			if (FlatIdent_63487 == 0) then
				Str = nil;
				if not Len then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
				end
				FlatIdent_63487 = 1;
			end
			if (FlatIdent_63487 == 1) then
				Str = Sub(ByteString, DIP, (DIP + Len) - 1);
				DIP = DIP + Len;
				FlatIdent_63487 = 2;
			end
		end
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local Type = gBits8();
			local Cons;
			if (Type == 1) then
				Cons = gBits8() ~= 0;
			elseif (Type == 2) then
				Cons = gFloat();
			elseif (Type == 3) then
				Cons = gString();
			end
			Consts[Idx] = Cons;
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local FlatIdent_8F047 = 0;
				local Type;
				local Mask;
				local Inst;
				while true do
					if (2 == FlatIdent_8F047) then
						if (gBit(Mask, 1, 1) == 1) then
							Inst[2] = Consts[Inst[2]];
						end
						if (gBit(Mask, 2, 2) == 1) then
							Inst[3] = Consts[Inst[3]];
						end
						FlatIdent_8F047 = 3;
					end
					if (FlatIdent_8F047 == 1) then
						Inst = {gBits16(),gBits16(),nil,nil};
						if (Type == 0) then
							Inst[3] = gBits16();
							Inst[4] = gBits16();
						elseif (Type == 1) then
							Inst[3] = gBits32();
						elseif (Type == 2) then
							Inst[3] = gBits32() - (2 ^ 16);
						elseif (Type == 3) then
							local FlatIdent_7F35E = 0;
							while true do
								if (FlatIdent_7F35E == 0) then
									Inst[3] = gBits32() - (2 ^ 16);
									Inst[4] = gBits16();
									break;
								end
							end
						end
						FlatIdent_8F047 = 2;
					end
					if (FlatIdent_8F047 == 3) then
						if (gBit(Mask, 3, 3) == 1) then
							Inst[4] = Consts[Inst[4]];
						end
						Instrs[Idx] = Inst;
						break;
					end
					if (FlatIdent_8F047 == 0) then
						Type = gBit(Descriptor, 2, 3);
						Mask = gBit(Descriptor, 4, 6);
						FlatIdent_8F047 = 1;
					end
				end
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 109) then
					if (Enum <= 54) then
						if (Enum <= 26) then
							if (Enum <= 12) then
								if (Enum <= 5) then
									if (Enum <= 2) then
										if (Enum <= 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										elseif (Enum == 1) then
											local FlatIdent_40CF = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_40CF == 5) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_40CF == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40CF = 3;
												end
												if (FlatIdent_40CF == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_40CF = 1;
												end
												if (FlatIdent_40CF == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_40CF = 2;
												end
												if (FlatIdent_40CF == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													FlatIdent_40CF = 4;
												end
												if (FlatIdent_40CF == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													FlatIdent_40CF = 5;
												end
											end
										else
											local FlatIdent_25DF3 = 0;
											while true do
												if (FlatIdent_25DF3 == 4) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 5;
												end
												if (FlatIdent_25DF3 == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 3;
												end
												if (FlatIdent_25DF3 == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 1;
												end
												if (FlatIdent_25DF3 == 9) then
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_25DF3 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 4;
												end
												if (FlatIdent_25DF3 == 8) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 9;
												end
												if (FlatIdent_25DF3 == 6) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 7;
												end
												if (FlatIdent_25DF3 == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 2;
												end
												if (FlatIdent_25DF3 == 7) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 8;
												end
												if (FlatIdent_25DF3 == 5) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_25DF3 = 6;
												end
											end
										end
									elseif (Enum <= 3) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									elseif (Enum == 4) then
										local FlatIdent_75B50 = 0;
										local B;
										local T;
										local A;
										while true do
											if (0 == FlatIdent_75B50) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_75B50 = 1;
											end
											if (FlatIdent_75B50 == 5) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B50 = 6;
											end
											if (FlatIdent_75B50 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B50 = 5;
											end
											if (FlatIdent_75B50 == 7) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_75B50 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B50 = 3;
											end
											if (FlatIdent_75B50 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B50 = 2;
											end
											if (FlatIdent_75B50 == 6) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_75B50 = 7;
											end
											if (3 == FlatIdent_75B50) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B50 = 4;
											end
										end
									else
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 8) then
									if (Enum <= 6) then
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									elseif (Enum == 7) then
										local FlatIdent_206F8 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_206F8 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_206F8 = 2;
											end
											if (5 == FlatIdent_206F8) then
												B = Inst[3];
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_206F8 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = Inst[3];
												FlatIdent_206F8 = 1;
											end
											if (FlatIdent_206F8 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_206F8 = 3;
											end
											if (FlatIdent_206F8 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												FlatIdent_206F8 = 4;
											end
											if (4 == FlatIdent_206F8) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												FlatIdent_206F8 = 5;
											end
										end
									else
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 10) then
									if (Enum > 9) then
										Stk[Inst[2]] = #Stk[Inst[3]];
									else
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum > 11) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local FlatIdent_882F4 = 0;
									while true do
										if (FlatIdent_882F4 == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 8;
										end
										if (FlatIdent_882F4 == 5) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 6;
										end
										if (FlatIdent_882F4 == 4) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 5;
										end
										if (FlatIdent_882F4 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 1;
										end
										if (FlatIdent_882F4 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 3;
										end
										if (FlatIdent_882F4 == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 7;
										end
										if (FlatIdent_882F4 == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 9;
										end
										if (FlatIdent_882F4 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 4;
										end
										if (FlatIdent_882F4 == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_882F4 == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_882F4 = 2;
										end
									end
								end
							elseif (Enum <= 19) then
								if (Enum <= 15) then
									if (Enum <= 13) then
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									elseif (Enum > 14) then
										local FlatIdent_77172 = 0;
										while true do
											if (FlatIdent_77172 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_77172 = 1;
											end
											if (FlatIdent_77172 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_77172 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_77172 = 2;
											end
											if (FlatIdent_77172 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_77172 = 6;
											end
											if (FlatIdent_77172 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_77172 = 3;
											end
											if (FlatIdent_77172 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_77172 = 4;
											end
											if (FlatIdent_77172 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_77172 = 5;
											end
										end
									else
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 17) then
									if (Enum > 16) then
										local FlatIdent_44265 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_44265 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_44265 == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_44265 = 2;
											end
											if (FlatIdent_44265 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_44265 = 1;
											end
											if (FlatIdent_44265 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_44265 = 7;
											end
											if (FlatIdent_44265 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_44265 = 3;
											end
											if (7 == FlatIdent_44265) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_44265 = 8;
											end
											if (FlatIdent_44265 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_44265 = 6;
											end
											if (FlatIdent_44265 == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_44265 = 5;
											end
											if (FlatIdent_44265 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_44265 = 4;
											end
										end
									else
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum == 18) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 22) then
								if (Enum <= 20) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum == 21) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								end
							elseif (Enum <= 24) then
								if (Enum > 23) then
									local FlatIdent_2593F = 0;
									local A;
									while true do
										if (FlatIdent_2593F == 0) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											break;
										end
									end
								else
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum == 25) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 40) then
							if (Enum <= 33) then
								if (Enum <= 29) then
									if (Enum <= 27) then
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									elseif (Enum == 28) then
										Stk[Inst[2]] = Env[Inst[3]];
									else
										local FlatIdent_3B08E = 0;
										while true do
											if (FlatIdent_3B08E == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_3B08E = 5;
											end
											if (FlatIdent_3B08E == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_3B08E = 2;
											end
											if (FlatIdent_3B08E == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B08E = 3;
											end
											if (FlatIdent_3B08E == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B08E = 6;
											end
											if (FlatIdent_3B08E == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (3 == FlatIdent_3B08E) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_3B08E = 4;
											end
											if (FlatIdent_3B08E == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_3B08E = 1;
											end
										end
									end
								elseif (Enum <= 31) then
									if (Enum > 30) then
										local FlatIdent_43BEE = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_43BEE == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_43BEE = 4;
											end
											if (FlatIdent_43BEE == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_43BEE = 8;
											end
											if (FlatIdent_43BEE == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_43BEE = 2;
											end
											if (FlatIdent_43BEE == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_43BEE = 5;
											end
											if (FlatIdent_43BEE == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_43BEE = 3;
											end
											if (5 == FlatIdent_43BEE) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_43BEE = 6;
											end
											if (FlatIdent_43BEE == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_43BEE = 1;
											end
											if (FlatIdent_43BEE == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_43BEE == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_43BEE = 7;
											end
										end
									else
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum == 32) then
									local FlatIdent_86E18 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_86E18 == 9) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_86E18 == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 8;
										end
										if (2 == FlatIdent_86E18) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 3;
										end
										if (FlatIdent_86E18 == 5) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 6;
										end
										if (FlatIdent_86E18 == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 7;
										end
										if (FlatIdent_86E18 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 4;
										end
										if (FlatIdent_86E18 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_86E18 = 1;
										end
										if (FlatIdent_86E18 == 8) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_86E18 = 9;
										end
										if (1 == FlatIdent_86E18) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 2;
										end
										if (FlatIdent_86E18 == 4) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_86E18 = 5;
										end
									end
								else
									local FlatIdent_7699F = 0;
									local A;
									while true do
										if (FlatIdent_7699F == 0) then
											A = Inst[2];
											do
												return Stk[A](Unpack(Stk, A + 1, Inst[3]));
											end
											break;
										end
									end
								end
							elseif (Enum <= 36) then
								if (Enum <= 34) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								elseif (Enum > 35) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local FlatIdent_8B7B0 = 0;
									local B;
									local T;
									local A;
									while true do
										if (1 == FlatIdent_8B7B0) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_8B7B0 = 2;
										end
										if (4 == FlatIdent_8B7B0) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_8B7B0 = 5;
										end
										if (FlatIdent_8B7B0 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8B7B0 = 3;
										end
										if (FlatIdent_8B7B0 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_8B7B0 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_8B7B0 = 6;
										end
										if (0 == FlatIdent_8B7B0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_8B7B0 = 1;
										end
										if (3 == FlatIdent_8B7B0) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_8B7B0 = 4;
										end
									end
								end
							elseif (Enum <= 38) then
								if (Enum > 37) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								else
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = #Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Index = Stk[A];
									Step = Stk[A + 2];
									if (Step > 0) then
										if (Index > Stk[A + 1]) then
											VIP = Inst[3];
										else
											Stk[A + 3] = Index;
										end
									elseif (Index < Stk[A + 1]) then
										VIP = Inst[3];
									else
										Stk[A + 3] = Index;
									end
								end
							elseif (Enum > 39) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 47) then
							if (Enum <= 43) then
								if (Enum <= 41) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 42) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local FlatIdent_3831 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_3831 == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3831 = 2;
										end
										if (FlatIdent_3831 == 5) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3831 = 6;
										end
										if (6 == FlatIdent_3831) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_3831 = 7;
										end
										if (7 == FlatIdent_3831) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_3831 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3831 = 4;
										end
										if (FlatIdent_3831 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_3831 = 1;
										end
										if (FlatIdent_3831 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3831 = 5;
										end
										if (2 == FlatIdent_3831) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3831 = 3;
										end
									end
								end
							elseif (Enum <= 45) then
								if (Enum > 44) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								else
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum == 46) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local B;
								local T;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 50) then
							if (Enum <= 48) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 49) then
								local FlatIdent_4D11E = 0;
								while true do
									if (FlatIdent_4D11E == 7) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 8;
									end
									if (FlatIdent_4D11E == 4) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 5;
									end
									if (1 == FlatIdent_4D11E) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 2;
									end
									if (0 == FlatIdent_4D11E) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 1;
									end
									if (FlatIdent_4D11E == 5) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 6;
									end
									if (FlatIdent_4D11E == 8) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 9;
									end
									if (FlatIdent_4D11E == 6) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 7;
									end
									if (FlatIdent_4D11E == 9) then
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_4D11E == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 3;
									end
									if (FlatIdent_4D11E == 3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4D11E = 4;
									end
								end
							else
								local FlatIdent_87441 = 0;
								local A;
								while true do
									if (21 == FlatIdent_87441) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 22;
									end
									if (27 == FlatIdent_87441) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_87441 = 28;
									end
									if (FlatIdent_87441 == 29) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_87441 = 30;
									end
									if (FlatIdent_87441 == 24) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_87441 = 25;
									end
									if (FlatIdent_87441 == 5) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_87441 = 6;
									end
									if (FlatIdent_87441 == 13) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 14;
									end
									if (FlatIdent_87441 == 3) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_87441 = 4;
									end
									if (FlatIdent_87441 == 4) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_87441 = 5;
									end
									if (FlatIdent_87441 == 14) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_87441 = 15;
									end
									if (FlatIdent_87441 == 6) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_87441 = 7;
									end
									if (FlatIdent_87441 == 10) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_87441 = 11;
									end
									if (FlatIdent_87441 == 17) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 18;
									end
									if (FlatIdent_87441 == 11) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 12;
									end
									if (FlatIdent_87441 == 16) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_87441 = 17;
									end
									if (FlatIdent_87441 == 9) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_87441 = 10;
									end
									if (FlatIdent_87441 == 15) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 16;
									end
									if (FlatIdent_87441 == 31) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										break;
									end
									if (FlatIdent_87441 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_87441 = 2;
									end
									if (0 == FlatIdent_87441) then
										A = nil;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 1;
									end
									if (FlatIdent_87441 == 22) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_87441 = 23;
									end
									if (FlatIdent_87441 == 12) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_87441 = 13;
									end
									if (FlatIdent_87441 == 23) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_87441 = 24;
									end
									if (FlatIdent_87441 == 19) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 20;
									end
									if (28 == FlatIdent_87441) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_87441 = 29;
									end
									if (FlatIdent_87441 == 30) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 31;
									end
									if (FlatIdent_87441 == 25) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_87441 = 26;
									end
									if (FlatIdent_87441 == 7) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_87441 = 8;
									end
									if (FlatIdent_87441 == 8) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_87441 = 9;
									end
									if (FlatIdent_87441 == 20) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_87441 = 21;
									end
									if (FlatIdent_87441 == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_87441 = 3;
									end
									if (FlatIdent_87441 == 26) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_87441 = 27;
									end
									if (FlatIdent_87441 == 18) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_87441 = 19;
									end
								end
							end
						elseif (Enum <= 52) then
							if (Enum == 51) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum > 53) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						else
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 81) then
						if (Enum <= 67) then
							if (Enum <= 60) then
								if (Enum <= 57) then
									if (Enum <= 55) then
										local FlatIdent_202CC = 0;
										local A;
										local Step;
										local Index;
										while true do
											if (FlatIdent_202CC == 1) then
												Index = Stk[A] + Step;
												Stk[A] = Index;
												FlatIdent_202CC = 2;
											end
											if (FlatIdent_202CC == 0) then
												A = Inst[2];
												Step = Stk[A + 2];
												FlatIdent_202CC = 1;
											end
											if (FlatIdent_202CC == 2) then
												if (Step > 0) then
													if (Index <= Stk[A + 1]) then
														local FlatIdent_13951 = 0;
														while true do
															if (FlatIdent_13951 == 0) then
																VIP = Inst[3];
																Stk[A + 3] = Index;
																break;
															end
														end
													end
												elseif (Index >= Stk[A + 1]) then
													VIP = Inst[3];
													Stk[A + 3] = Index;
												end
												break;
											end
										end
									elseif (Enum == 56) then
										local A;
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									else
										local FlatIdent_8DAB1 = 0;
										while true do
											if (FlatIdent_8DAB1 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 4;
											end
											if (FlatIdent_8DAB1 == 9) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_8DAB1 == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 5;
											end
											if (FlatIdent_8DAB1 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 3;
											end
											if (FlatIdent_8DAB1 == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 9;
											end
											if (FlatIdent_8DAB1 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 2;
											end
											if (0 == FlatIdent_8DAB1) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 1;
											end
											if (FlatIdent_8DAB1 == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 6;
											end
											if (FlatIdent_8DAB1 == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 7;
											end
											if (7 == FlatIdent_8DAB1) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8DAB1 = 8;
											end
										end
									end
								elseif (Enum <= 58) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								elseif (Enum > 59) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								end
							elseif (Enum <= 63) then
								if (Enum <= 61) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								elseif (Enum == 62) then
									local FlatIdent_5C19E = 0;
									local A;
									local Results;
									local Limit;
									local Edx;
									while true do
										if (FlatIdent_5C19E == 0) then
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
											FlatIdent_5C19E = 1;
										end
										if (FlatIdent_5C19E == 2) then
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											break;
										end
										if (FlatIdent_5C19E == 1) then
											Top = (Limit + A) - 1;
											Edx = 0;
											FlatIdent_5C19E = 2;
										end
									end
								else
									local FlatIdent_68E5B = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_68E5B == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_68E5B = 2;
										end
										if (FlatIdent_68E5B == 5) then
											B = Inst[3];
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (3 == FlatIdent_68E5B) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											FlatIdent_68E5B = 4;
										end
										if (FlatIdent_68E5B == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											FlatIdent_68E5B = 5;
										end
										if (0 == FlatIdent_68E5B) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = Inst[3];
											FlatIdent_68E5B = 1;
										end
										if (FlatIdent_68E5B == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_68E5B = 3;
										end
									end
								end
							elseif (Enum <= 65) then
								if (Enum > 64) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								else
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum > 66) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							else
								local Edx;
								local Results, Limit;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									local FlatIdent_727DA = 0;
									while true do
										if (0 == FlatIdent_727DA) then
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
											break;
										end
									end
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = #Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = #Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									local FlatIdent_6FF03 = 0;
									while true do
										if (FlatIdent_6FF03 == 0) then
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
											break;
										end
									end
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									local FlatIdent_6BDA4 = 0;
									while true do
										if (FlatIdent_6BDA4 == 0) then
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
											break;
										end
									end
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 74) then
							if (Enum <= 70) then
								if (Enum <= 68) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 69) then
									local FlatIdent_5C97A = 0;
									while true do
										if (FlatIdent_5C97A == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_5C97A = 5;
										end
										if (FlatIdent_5C97A == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_5C97A == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_5C97A = 4;
										end
										if (FlatIdent_5C97A == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_5C97A = 2;
										end
										if (FlatIdent_5C97A == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5C97A = 6;
										end
										if (0 == FlatIdent_5C97A) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_5C97A = 1;
										end
										if (FlatIdent_5C97A == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5C97A = 3;
										end
									end
								else
									local FlatIdent_2EB74 = 0;
									while true do
										if (FlatIdent_2EB74 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_2EB74 = 1;
										end
										if (4 == FlatIdent_2EB74) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_2EB74 = 5;
										end
										if (FlatIdent_2EB74 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_2EB74 = 2;
										end
										if (FlatIdent_2EB74 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2EB74 = 3;
										end
										if (FlatIdent_2EB74 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_2EB74 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2EB74 = 6;
										end
										if (FlatIdent_2EB74 == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_2EB74 = 4;
										end
									end
								end
							elseif (Enum <= 72) then
								if (Enum > 71) then
									local FlatIdent_28DC7 = 0;
									local A;
									while true do
										if (FlatIdent_28DC7 == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 8;
										end
										if (22 == FlatIdent_28DC7) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_28DC7 = 23;
										end
										if (FlatIdent_28DC7 == 3) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_28DC7 = 4;
										end
										if (FlatIdent_28DC7 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_28DC7 = 3;
										end
										if (FlatIdent_28DC7 == 6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_28DC7 = 7;
										end
										if (8 == FlatIdent_28DC7) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 9;
										end
										if (FlatIdent_28DC7 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_28DC7 = 5;
										end
										if (FlatIdent_28DC7 == 17) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_28DC7 = 18;
										end
										if (11 == FlatIdent_28DC7) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_28DC7 = 12;
										end
										if (FlatIdent_28DC7 == 24) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_28DC7 = 25;
										end
										if (FlatIdent_28DC7 == 14) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 15;
										end
										if (FlatIdent_28DC7 == 10) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_28DC7 = 11;
										end
										if (9 == FlatIdent_28DC7) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_28DC7 = 10;
										end
										if (18 == FlatIdent_28DC7) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_28DC7 = 19;
										end
										if (FlatIdent_28DC7 == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_28DC7 = 13;
										end
										if (FlatIdent_28DC7 == 16) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_28DC7 = 17;
										end
										if (FlatIdent_28DC7 == 15) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_28DC7 = 16;
										end
										if (FlatIdent_28DC7 == 13) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 14;
										end
										if (FlatIdent_28DC7 == 21) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_28DC7 = 22;
										end
										if (FlatIdent_28DC7 == 1) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 2;
										end
										if (FlatIdent_28DC7 == 19) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 20;
										end
										if (25 == FlatIdent_28DC7) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (0 == FlatIdent_28DC7) then
											A = nil;
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 1;
										end
										if (FlatIdent_28DC7 == 20) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_28DC7 = 21;
										end
										if (FlatIdent_28DC7 == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_28DC7 = 6;
										end
										if (FlatIdent_28DC7 == 23) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_28DC7 = 24;
										end
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum > 73) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							else
								local FlatIdent_53D9 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_53D9 == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_53D9 = 7;
									end
									if (FlatIdent_53D9 == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_53D9 = 8;
									end
									if (FlatIdent_53D9 == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_53D9 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_53D9 = 5;
									end
									if (FlatIdent_53D9 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_53D9 = 4;
									end
									if (FlatIdent_53D9 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_53D9 = 1;
									end
									if (FlatIdent_53D9 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_53D9 = 2;
									end
									if (FlatIdent_53D9 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_53D9 = 3;
									end
									if (FlatIdent_53D9 == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_53D9 = 6;
									end
								end
							end
						elseif (Enum <= 77) then
							if (Enum <= 75) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							elseif (Enum > 76) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 79) then
							if (Enum == 78) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								VIP = Inst[3];
							end
						elseif (Enum > 80) then
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						elseif not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 95) then
						if (Enum <= 88) then
							if (Enum <= 84) then
								if (Enum <= 82) then
									Stk[Inst[2]] = Stk[Inst[3]];
								elseif (Enum == 83) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 86) then
								if (Enum == 85) then
									local FlatIdent_3423 = 0;
									while true do
										if (0 == FlatIdent_3423) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 1;
										end
										if (FlatIdent_3423 == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_3423 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 3;
										end
										if (5 == FlatIdent_3423) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 6;
										end
										if (1 == FlatIdent_3423) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 2;
										end
										if (FlatIdent_3423 == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 9;
										end
										if (4 == FlatIdent_3423) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 5;
										end
										if (7 == FlatIdent_3423) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 8;
										end
										if (FlatIdent_3423 == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 7;
										end
										if (FlatIdent_3423 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3423 = 4;
										end
									end
								else
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum == 87) then
								local NewProto = Proto[Inst[3]];
								local NewUvals;
								local Indexes = {};
								NewUvals = Setmetatable({}, {__index=function(_, Key)
									local Val = Indexes[Key];
									return Val[1][Val[2]];
								end,__newindex=function(_, Key, Value)
									local Val = Indexes[Key];
									Val[1][Val[2]] = Value;
								end});
								for Idx = 1, Inst[4] do
									local FlatIdent_60AAB = 0;
									local Mvm;
									while true do
										if (FlatIdent_60AAB == 1) then
											if (Mvm[1] == 82) then
												Indexes[Idx - 1] = {Stk,Mvm[3]};
											else
												Indexes[Idx - 1] = {Upvalues,Mvm[3]};
											end
											Lupvals[#Lupvals + 1] = Indexes;
											break;
										end
										if (FlatIdent_60AAB == 0) then
											VIP = VIP + 1;
											Mvm = Instr[VIP];
											FlatIdent_60AAB = 1;
										end
									end
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							else
								local B;
								local T;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 91) then
							if (Enum <= 89) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum > 90) then
								local A = Inst[2];
								local Index = Stk[A];
								local Step = Stk[A + 2];
								if (Step > 0) then
									if (Index > Stk[A + 1]) then
										VIP = Inst[3];
									else
										Stk[A + 3] = Index;
									end
								elseif (Index < Stk[A + 1]) then
									VIP = Inst[3];
								else
									Stk[A + 3] = Index;
								end
							else
								local FlatIdent_37906 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_37906 == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_37906 = 8;
									end
									if (FlatIdent_37906 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_37906 = 5;
									end
									if (FlatIdent_37906 == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_37906 = 7;
									end
									if (FlatIdent_37906 == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_37906 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_37906 = 4;
									end
									if (FlatIdent_37906 == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_37906 = 6;
									end
									if (FlatIdent_37906 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_37906 = 3;
									end
									if (FlatIdent_37906 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_37906 = 2;
									end
									if (FlatIdent_37906 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_37906 = 1;
									end
								end
							end
						elseif (Enum <= 93) then
							if (Enum == 92) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local FlatIdent_3397E = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_3397E == 7) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_3397E == 6) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_3397E = 7;
									end
									if (FlatIdent_3397E == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3397E = 2;
									end
									if (FlatIdent_3397E == 5) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3397E = 6;
									end
									if (FlatIdent_3397E == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3397E = 5;
									end
									if (FlatIdent_3397E == 3) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3397E = 4;
									end
									if (FlatIdent_3397E == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_3397E = 1;
									end
									if (FlatIdent_3397E == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3397E = 3;
									end
								end
							end
						elseif (Enum == 94) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 102) then
						if (Enum <= 98) then
							if (Enum <= 96) then
								do
									return;
								end
							elseif (Enum > 97) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								local FlatIdent_1B638 = 0;
								while true do
									if (FlatIdent_1B638 == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_1B638 = 1;
									end
									if (FlatIdent_1B638 == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1B638 = 3;
									end
									if (FlatIdent_1B638 == 5) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1B638 = 6;
									end
									if (FlatIdent_1B638 == 6) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (1 == FlatIdent_1B638) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										FlatIdent_1B638 = 2;
									end
									if (FlatIdent_1B638 == 3) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_1B638 = 4;
									end
									if (FlatIdent_1B638 == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_1B638 = 5;
									end
								end
							end
						elseif (Enum <= 100) then
							if (Enum > 99) then
								local FlatIdent_413A0 = 0;
								local B;
								local T;
								local A;
								while true do
									if (5 == FlatIdent_413A0) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_413A0 = 6;
									end
									if (6 == FlatIdent_413A0) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_413A0 = 7;
									end
									if (FlatIdent_413A0 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_413A0 = 3;
									end
									if (FlatIdent_413A0 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_413A0 = 5;
									end
									if (FlatIdent_413A0 == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_413A0 == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_413A0 = 8;
									end
									if (FlatIdent_413A0 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_413A0 = 1;
									end
									if (FlatIdent_413A0 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_413A0 = 2;
									end
									if (FlatIdent_413A0 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_413A0 = 4;
									end
								end
							else
								local FlatIdent_104FA = 0;
								while true do
									if (FlatIdent_104FA == 8) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 9;
									end
									if (FlatIdent_104FA == 4) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 5;
									end
									if (FlatIdent_104FA == 7) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 8;
									end
									if (FlatIdent_104FA == 9) then
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_104FA == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 1;
									end
									if (FlatIdent_104FA == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 2;
									end
									if (FlatIdent_104FA == 3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 4;
									end
									if (FlatIdent_104FA == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 3;
									end
									if (FlatIdent_104FA == 5) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 6;
									end
									if (FlatIdent_104FA == 6) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_104FA = 7;
									end
								end
							end
						elseif (Enum > 101) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						end
					elseif (Enum <= 105) then
						if (Enum <= 103) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Enum == 104) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						else
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 107) then
						if (Enum > 106) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						else
							local FlatIdent_9874B = 0;
							local B;
							local T;
							local A;
							while true do
								if (7 == FlatIdent_9874B) then
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									FlatIdent_9874B = 8;
								end
								if (FlatIdent_9874B == 6) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9874B = 7;
								end
								if (FlatIdent_9874B == 0) then
									B = nil;
									T = nil;
									A = nil;
									FlatIdent_9874B = 1;
								end
								if (FlatIdent_9874B == 2) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9874B = 3;
								end
								if (8 == FlatIdent_9874B) then
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
									break;
								end
								if (5 == FlatIdent_9874B) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9874B = 6;
								end
								if (FlatIdent_9874B == 4) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9874B = 5;
								end
								if (FlatIdent_9874B == 3) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9874B = 4;
								end
								if (FlatIdent_9874B == 1) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9874B = 2;
								end
							end
						end
					elseif (Enum > 108) then
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
					else
						local B;
						local T;
						local A;
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						T = Stk[A];
						B = Inst[3];
						for Idx = 1, B do
							T[Idx] = Stk[A + Idx];
						end
					end
				elseif (Enum <= 164) then
					if (Enum <= 136) then
						if (Enum <= 122) then
							if (Enum <= 115) then
								if (Enum <= 112) then
									if (Enum <= 110) then
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									elseif (Enum == 111) then
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									else
										local B;
										local T;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 113) then
									local FlatIdent_2A75 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_2A75 == 5) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2A75 = 6;
										end
										if (FlatIdent_2A75 == 8) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_2A75 == 4) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2A75 = 5;
										end
										if (FlatIdent_2A75 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_2A75 = 1;
										end
										if (FlatIdent_2A75 == 1) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2A75 = 2;
										end
										if (3 == FlatIdent_2A75) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2A75 = 4;
										end
										if (FlatIdent_2A75 == 7) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_2A75 = 8;
										end
										if (FlatIdent_2A75 == 6) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2A75 = 7;
										end
										if (FlatIdent_2A75 == 2) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2A75 = 3;
										end
									end
								elseif (Enum > 114) then
									local FlatIdent_14BE1 = 0;
									local A;
									while true do
										if (FlatIdent_14BE1 == 23) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 24;
										end
										if (3 == FlatIdent_14BE1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 4;
										end
										if (18 == FlatIdent_14BE1) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 19;
										end
										if (27 == FlatIdent_14BE1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_14BE1 == 15) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_14BE1 = 16;
										end
										if (FlatIdent_14BE1 == 11) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_14BE1 = 12;
										end
										if (FlatIdent_14BE1 == 25) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 26;
										end
										if (FlatIdent_14BE1 == 20) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_14BE1 = 21;
										end
										if (FlatIdent_14BE1 == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_14BE1 = 8;
										end
										if (14 == FlatIdent_14BE1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_14BE1 = 15;
										end
										if (FlatIdent_14BE1 == 13) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_14BE1 = 14;
										end
										if (FlatIdent_14BE1 == 1) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_14BE1 = 2;
										end
										if (FlatIdent_14BE1 == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 13;
										end
										if (FlatIdent_14BE1 == 2) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_14BE1 = 3;
										end
										if (FlatIdent_14BE1 == 21) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_14BE1 = 22;
										end
										if (FlatIdent_14BE1 == 9) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 10;
										end
										if (FlatIdent_14BE1 == 8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_14BE1 = 9;
										end
										if (FlatIdent_14BE1 == 0) then
											A = nil;
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 1;
										end
										if (17 == FlatIdent_14BE1) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 18;
										end
										if (FlatIdent_14BE1 == 19) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 20;
										end
										if (FlatIdent_14BE1 == 5) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 6;
										end
										if (24 == FlatIdent_14BE1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 25;
										end
										if (FlatIdent_14BE1 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 5;
										end
										if (FlatIdent_14BE1 == 22) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 23;
										end
										if (FlatIdent_14BE1 == 26) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_14BE1 = 27;
										end
										if (6 == FlatIdent_14BE1) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_14BE1 = 7;
										end
										if (FlatIdent_14BE1 == 10) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 11;
										end
										if (FlatIdent_14BE1 == 16) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_14BE1 = 17;
										end
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 118) then
								if (Enum <= 116) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum == 117) then
									local FlatIdent_41403 = 0;
									local B;
									local T;
									local A;
									while true do
										if (3 == FlatIdent_41403) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_41403 = 4;
										end
										if (FlatIdent_41403 == 2) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_41403 = 3;
										end
										if (FlatIdent_41403 == 1) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_41403 = 2;
										end
										if (FlatIdent_41403 == 4) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_41403 = 5;
										end
										if (FlatIdent_41403 == 8) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_41403 == 6) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_41403 = 7;
										end
										if (FlatIdent_41403 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_41403 = 1;
										end
										if (FlatIdent_41403 == 5) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_41403 = 6;
										end
										if (FlatIdent_41403 == 7) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_41403 = 8;
										end
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 120) then
								if (Enum > 119) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum == 121) then
								local FlatIdent_706CB = 0;
								local A;
								while true do
									if (FlatIdent_706CB == 18) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_706CB = 19;
									end
									if (FlatIdent_706CB == 14) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 15;
									end
									if (3 == FlatIdent_706CB) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_706CB = 4;
									end
									if (FlatIdent_706CB == 24) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_706CB = 25;
									end
									if (16 == FlatIdent_706CB) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_706CB = 17;
									end
									if (FlatIdent_706CB == 13) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_706CB = 14;
									end
									if (FlatIdent_706CB == 20) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 21;
									end
									if (FlatIdent_706CB == 19) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_706CB = 20;
									end
									if (FlatIdent_706CB == 5) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_706CB = 6;
									end
									if (FlatIdent_706CB == 7) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_706CB = 8;
									end
									if (FlatIdent_706CB == 4) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_706CB = 5;
									end
									if (FlatIdent_706CB == 15) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 16;
									end
									if (FlatIdent_706CB == 2) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 3;
									end
									if (FlatIdent_706CB == 17) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_706CB = 18;
									end
									if (FlatIdent_706CB == 23) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_706CB = 24;
									end
									if (FlatIdent_706CB == 22) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_706CB = 23;
									end
									if (FlatIdent_706CB == 8) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 9;
									end
									if (FlatIdent_706CB == 25) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										break;
									end
									if (FlatIdent_706CB == 10) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_706CB = 11;
									end
									if (1 == FlatIdent_706CB) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 2;
									end
									if (FlatIdent_706CB == 6) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_706CB = 7;
									end
									if (9 == FlatIdent_706CB) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 10;
									end
									if (FlatIdent_706CB == 12) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_706CB = 13;
									end
									if (FlatIdent_706CB == 0) then
										A = nil;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_706CB = 1;
									end
									if (FlatIdent_706CB == 21) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_706CB = 22;
									end
									if (FlatIdent_706CB == 11) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_706CB = 12;
									end
								end
							else
								local FlatIdent_41631 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_41631 == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_41631 = 8;
									end
									if (FlatIdent_41631 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_41631 = 5;
									end
									if (6 == FlatIdent_41631) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_41631 = 7;
									end
									if (5 == FlatIdent_41631) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_41631 = 6;
									end
									if (FlatIdent_41631 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_41631 = 4;
									end
									if (FlatIdent_41631 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_41631 = 3;
									end
									if (FlatIdent_41631 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_41631 = 2;
									end
									if (0 == FlatIdent_41631) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_41631 = 1;
									end
									if (FlatIdent_41631 == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
								end
							end
						elseif (Enum <= 129) then
							if (Enum <= 125) then
								if (Enum <= 123) then
									local FlatIdent_8EAFE = 0;
									while true do
										if (FlatIdent_8EAFE == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (1 == FlatIdent_8EAFE) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 2;
										end
										if (FlatIdent_8EAFE == 4) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 5;
										end
										if (FlatIdent_8EAFE == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 4;
										end
										if (FlatIdent_8EAFE == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 9;
										end
										if (FlatIdent_8EAFE == 2) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 3;
										end
										if (0 == FlatIdent_8EAFE) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 1;
										end
										if (FlatIdent_8EAFE == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 7;
										end
										if (FlatIdent_8EAFE == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 8;
										end
										if (FlatIdent_8EAFE == 5) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EAFE = 6;
										end
									end
								elseif (Enum > 124) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 127) then
								if (Enum == 126) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								else
									local FlatIdent_3B02 = 0;
									local A;
									while true do
										if (0 == FlatIdent_3B02) then
											A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
											end
											break;
										end
									end
								end
							elseif (Enum == 128) then
								local FlatIdent_3FB17 = 0;
								while true do
									if (FlatIdent_3FB17 == 3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 4;
									end
									if (FlatIdent_3FB17 == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 1;
									end
									if (6 == FlatIdent_3FB17) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 7;
									end
									if (FlatIdent_3FB17 == 7) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 8;
									end
									if (FlatIdent_3FB17 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 2;
									end
									if (8 == FlatIdent_3FB17) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 9;
									end
									if (FlatIdent_3FB17 == 5) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 6;
									end
									if (4 == FlatIdent_3FB17) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 5;
									end
									if (FlatIdent_3FB17 == 9) then
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (2 == FlatIdent_3FB17) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3FB17 = 3;
									end
								end
							else
								local FlatIdent_EF32 = 0;
								local A;
								while true do
									if (FlatIdent_EF32 == 28) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 29;
									end
									if (FlatIdent_EF32 == 24) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 25;
									end
									if (FlatIdent_EF32 == 19) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 20;
									end
									if (FlatIdent_EF32 == 12) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 13;
									end
									if (FlatIdent_EF32 == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 2;
									end
									if (FlatIdent_EF32 == 27) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 28;
									end
									if (FlatIdent_EF32 == 8) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 9;
									end
									if (FlatIdent_EF32 == 13) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 14;
									end
									if (25 == FlatIdent_EF32) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 26;
									end
									if (FlatIdent_EF32 == 31) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										break;
									end
									if (FlatIdent_EF32 == 29) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 30;
									end
									if (FlatIdent_EF32 == 3) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 4;
									end
									if (FlatIdent_EF32 == 23) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 24;
									end
									if (FlatIdent_EF32 == 30) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 31;
									end
									if (FlatIdent_EF32 == 10) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 11;
									end
									if (FlatIdent_EF32 == 5) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 6;
									end
									if (9 == FlatIdent_EF32) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 10;
									end
									if (FlatIdent_EF32 == 4) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 5;
									end
									if (2 == FlatIdent_EF32) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 3;
									end
									if (6 == FlatIdent_EF32) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 7;
									end
									if (FlatIdent_EF32 == 14) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 15;
									end
									if (FlatIdent_EF32 == 0) then
										A = nil;
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 1;
									end
									if (FlatIdent_EF32 == 16) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 17;
									end
									if (FlatIdent_EF32 == 11) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 12;
									end
									if (FlatIdent_EF32 == 18) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 19;
									end
									if (FlatIdent_EF32 == 7) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 8;
									end
									if (21 == FlatIdent_EF32) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 22;
									end
									if (26 == FlatIdent_EF32) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 27;
									end
									if (22 == FlatIdent_EF32) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 23;
									end
									if (FlatIdent_EF32 == 20) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_EF32 = 21;
									end
									if (FlatIdent_EF32 == 17) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 18;
									end
									if (FlatIdent_EF32 == 15) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_EF32 = 16;
									end
								end
							end
						elseif (Enum <= 132) then
							if (Enum <= 130) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 131) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								local FlatIdent_96497 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_96497 == 7) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_96497 == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_96497 = 3;
									end
									if (FlatIdent_96497 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_96497 = 5;
									end
									if (3 == FlatIdent_96497) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_96497 = 4;
									end
									if (FlatIdent_96497 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_96497 = 2;
									end
									if (FlatIdent_96497 == 5) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_96497 = 6;
									end
									if (FlatIdent_96497 == 6) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_96497 = 7;
									end
									if (FlatIdent_96497 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_96497 = 1;
									end
								end
							end
						elseif (Enum <= 134) then
							if (Enum == 133) then
								local A;
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum == 135) then
							if (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 150) then
						if (Enum <= 143) then
							if (Enum <= 139) then
								if (Enum <= 137) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										local FlatIdent_190B2 = 0;
										while true do
											if (FlatIdent_190B2 == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
								elseif (Enum > 138) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 141) then
								if (Enum > 140) then
									local B;
									local T;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								else
									local A = Inst[2];
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum > 142) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 146) then
							if (Enum <= 144) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							elseif (Enum > 145) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local FlatIdent_783E8 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_783E8 == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_783E8 = 6;
									end
									if (7 == FlatIdent_783E8) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_783E8 = 8;
									end
									if (FlatIdent_783E8 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_783E8 = 1;
									end
									if (FlatIdent_783E8 == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_783E8 = 7;
									end
									if (FlatIdent_783E8 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_783E8 = 5;
									end
									if (8 == FlatIdent_783E8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_783E8 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_783E8 = 3;
									end
									if (FlatIdent_783E8 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_783E8 = 2;
									end
									if (FlatIdent_783E8 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_783E8 = 4;
									end
								end
							end
						elseif (Enum <= 148) then
							if (Enum == 147) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
							end
						elseif (Enum == 149) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 157) then
						if (Enum <= 153) then
							if (Enum <= 151) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 152) then
								local FlatIdent_4A8B1 = 0;
								while true do
									if (FlatIdent_4A8B1 == 4) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 5;
									end
									if (FlatIdent_4A8B1 == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 1;
									end
									if (FlatIdent_4A8B1 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 2;
									end
									if (FlatIdent_4A8B1 == 9) then
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_4A8B1 == 7) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 8;
									end
									if (FlatIdent_4A8B1 == 8) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 9;
									end
									if (3 == FlatIdent_4A8B1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 4;
									end
									if (FlatIdent_4A8B1 == 5) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 6;
									end
									if (6 == FlatIdent_4A8B1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 7;
									end
									if (FlatIdent_4A8B1 == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_4A8B1 = 3;
									end
								end
							else
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 155) then
							if (Enum == 154) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum > 156) then
							local FlatIdent_9715A = 0;
							local B;
							local T;
							local A;
							while true do
								if (FlatIdent_9715A == 6) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9715A = 7;
								end
								if (FlatIdent_9715A == 1) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9715A = 2;
								end
								if (0 == FlatIdent_9715A) then
									B = nil;
									T = nil;
									A = nil;
									FlatIdent_9715A = 1;
								end
								if (5 == FlatIdent_9715A) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9715A = 6;
								end
								if (FlatIdent_9715A == 8) then
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
									break;
								end
								if (FlatIdent_9715A == 2) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9715A = 3;
								end
								if (FlatIdent_9715A == 3) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9715A = 4;
								end
								if (4 == FlatIdent_9715A) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_9715A = 5;
								end
								if (FlatIdent_9715A == 7) then
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									FlatIdent_9715A = 8;
								end
							end
						else
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 160) then
						if (Enum <= 158) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Enum == 159) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							local FlatIdent_866A5 = 0;
							local A;
							while true do
								if (FlatIdent_866A5 == 8) then
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 9;
								end
								if (FlatIdent_866A5 == 18) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_866A5 = 19;
								end
								if (FlatIdent_866A5 == 13) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									FlatIdent_866A5 = 14;
								end
								if (FlatIdent_866A5 == 7) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									FlatIdent_866A5 = 8;
								end
								if (FlatIdent_866A5 == 6) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									FlatIdent_866A5 = 7;
								end
								if (17 == FlatIdent_866A5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_866A5 = 18;
								end
								if (FlatIdent_866A5 == 15) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 16;
								end
								if (2 == FlatIdent_866A5) then
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 3;
								end
								if (FlatIdent_866A5 == 4) then
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									FlatIdent_866A5 = 5;
								end
								if (3 == FlatIdent_866A5) then
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_866A5 = 4;
								end
								if (FlatIdent_866A5 == 1) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 2;
								end
								if (12 == FlatIdent_866A5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_866A5 = 13;
								end
								if (FlatIdent_866A5 == 25) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									break;
								end
								if (FlatIdent_866A5 == 23) then
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									FlatIdent_866A5 = 24;
								end
								if (FlatIdent_866A5 == 5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									FlatIdent_866A5 = 6;
								end
								if (FlatIdent_866A5 == 10) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_866A5 = 11;
								end
								if (FlatIdent_866A5 == 22) then
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_866A5 = 23;
								end
								if (FlatIdent_866A5 == 9) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 10;
								end
								if (FlatIdent_866A5 == 19) then
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_866A5 = 20;
								end
								if (FlatIdent_866A5 == 24) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									FlatIdent_866A5 = 25;
								end
								if (FlatIdent_866A5 == 0) then
									A = nil;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_866A5 = 1;
								end
								if (FlatIdent_866A5 == 21) then
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 22;
								end
								if (11 == FlatIdent_866A5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									FlatIdent_866A5 = 12;
								end
								if (FlatIdent_866A5 == 20) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 21;
								end
								if (16 == FlatIdent_866A5) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_866A5 = 17;
								end
								if (14 == FlatIdent_866A5) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_866A5 = 15;
								end
							end
						end
					elseif (Enum <= 162) then
						if (Enum == 161) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						else
							local FlatIdent_3E49C = 0;
							while true do
								if (8 == FlatIdent_3E49C) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 9;
								end
								if (FlatIdent_3E49C == 3) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 4;
								end
								if (FlatIdent_3E49C == 6) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 7;
								end
								if (FlatIdent_3E49C == 4) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 5;
								end
								if (0 == FlatIdent_3E49C) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 1;
								end
								if (FlatIdent_3E49C == 1) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 2;
								end
								if (FlatIdent_3E49C == 5) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 6;
								end
								if (FlatIdent_3E49C == 9) then
									Stk[Inst[2]] = Inst[3];
									break;
								end
								if (FlatIdent_3E49C == 2) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 3;
								end
								if (7 == FlatIdent_3E49C) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3E49C = 8;
								end
							end
						end
					elseif (Enum > 163) then
						local FlatIdent_14474 = 0;
						local B;
						local T;
						local A;
						while true do
							if (FlatIdent_14474 == 0) then
								B = nil;
								T = nil;
								A = nil;
								Stk[Inst[2]] = Inst[3];
								FlatIdent_14474 = 1;
							end
							if (FlatIdent_14474 == 4) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								FlatIdent_14474 = 5;
							end
							if (2 == FlatIdent_14474) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_14474 = 3;
							end
							if (FlatIdent_14474 == 1) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								FlatIdent_14474 = 2;
							end
							if (FlatIdent_14474 == 5) then
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
								break;
							end
							if (FlatIdent_14474 == 3) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								FlatIdent_14474 = 4;
							end
						end
					else
						local A = Inst[2];
						do
							return Unpack(Stk, A, Top);
						end
					end
				elseif (Enum <= 192) then
					if (Enum <= 178) then
						if (Enum <= 171) then
							if (Enum <= 167) then
								if (Enum <= 165) then
									local FlatIdent_2BC4F = 0;
									local A;
									local Results;
									local Limit;
									local Edx;
									while true do
										if (0 == FlatIdent_2BC4F) then
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
											FlatIdent_2BC4F = 1;
										end
										if (FlatIdent_2BC4F == 1) then
											Top = (Limit + A) - 1;
											Edx = 0;
											FlatIdent_2BC4F = 2;
										end
										if (FlatIdent_2BC4F == 2) then
											for Idx = A, Top do
												local FlatIdent_5525C = 0;
												while true do
													if (FlatIdent_5525C == 0) then
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
														break;
													end
												end
											end
											break;
										end
									end
								elseif (Enum == 166) then
									local FlatIdent_C7FE = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_C7FE == 5) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_C7FE = 6;
										end
										if (FlatIdent_C7FE == 8) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_C7FE == 7) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_C7FE = 8;
										end
										if (FlatIdent_C7FE == 1) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_C7FE = 2;
										end
										if (FlatIdent_C7FE == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_C7FE = 1;
										end
										if (FlatIdent_C7FE == 2) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_C7FE = 3;
										end
										if (FlatIdent_C7FE == 4) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_C7FE = 5;
										end
										if (FlatIdent_C7FE == 6) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_C7FE = 7;
										end
										if (FlatIdent_C7FE == 3) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_C7FE = 4;
										end
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 169) then
								if (Enum == 168) then
									local FlatIdent_4D4B8 = 0;
									while true do
										if (FlatIdent_4D4B8 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_4D4B8 = 1;
										end
										if (FlatIdent_4D4B8 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_4D4B8 = 2;
										end
										if (FlatIdent_4D4B8 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4D4B8 = 6;
										end
										if (FlatIdent_4D4B8 == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_4D4B8 = 4;
										end
										if (FlatIdent_4D4B8 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4D4B8 = 3;
										end
										if (FlatIdent_4D4B8 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_4D4B8 = 5;
										end
										if (FlatIdent_4D4B8 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum > 170) then
								local A;
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								local FlatIdent_51F18 = 0;
								local A;
								while true do
									if (FlatIdent_51F18 == 24) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_51F18 = 25;
									end
									if (FlatIdent_51F18 == 1) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 2;
									end
									if (FlatIdent_51F18 == 20) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 21;
									end
									if (FlatIdent_51F18 == 15) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_51F18 = 16;
									end
									if (FlatIdent_51F18 == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_51F18 = 5;
									end
									if (FlatIdent_51F18 == 10) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_51F18 = 11;
									end
									if (FlatIdent_51F18 == 11) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_51F18 = 12;
									end
									if (FlatIdent_51F18 == 3) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_51F18 = 4;
									end
									if (FlatIdent_51F18 == 7) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 8;
									end
									if (FlatIdent_51F18 == 21) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_51F18 = 22;
									end
									if (FlatIdent_51F18 == 19) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 20;
									end
									if (16 == FlatIdent_51F18) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_51F18 = 17;
									end
									if (FlatIdent_51F18 == 0) then
										A = nil;
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 1;
									end
									if (FlatIdent_51F18 == 9) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_51F18 = 10;
									end
									if (FlatIdent_51F18 == 17) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_51F18 = 18;
									end
									if (FlatIdent_51F18 == 25) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (12 == FlatIdent_51F18) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_51F18 = 13;
									end
									if (FlatIdent_51F18 == 23) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_51F18 = 24;
									end
									if (FlatIdent_51F18 == 2) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_51F18 = 3;
									end
									if (FlatIdent_51F18 == 5) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_51F18 = 6;
									end
									if (FlatIdent_51F18 == 13) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 14;
									end
									if (FlatIdent_51F18 == 14) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 15;
									end
									if (FlatIdent_51F18 == 22) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_51F18 = 23;
									end
									if (FlatIdent_51F18 == 6) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_51F18 = 7;
									end
									if (FlatIdent_51F18 == 8) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_51F18 = 9;
									end
									if (FlatIdent_51F18 == 18) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_51F18 = 19;
									end
								end
							end
						elseif (Enum <= 174) then
							if (Enum <= 172) then
								local FlatIdent_2D9C = 0;
								while true do
									if (FlatIdent_2D9C == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_2D9C = 5;
									end
									if (FlatIdent_2D9C == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_2D9C = 1;
									end
									if (FlatIdent_2D9C == 6) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_2D9C == 3) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_2D9C = 4;
									end
									if (FlatIdent_2D9C == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										FlatIdent_2D9C = 2;
									end
									if (5 == FlatIdent_2D9C) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_2D9C = 6;
									end
									if (FlatIdent_2D9C == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_2D9C = 3;
									end
								end
							elseif (Enum == 173) then
								do
									return Stk[Inst[2]];
								end
							else
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 176) then
							if (Enum == 175) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							else
								local FlatIdent_86928 = 0;
								local A;
								while true do
									if (FlatIdent_86928 == 19) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 20;
									end
									if (FlatIdent_86928 == 15) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 16;
									end
									if (FlatIdent_86928 == 18) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_86928 = 19;
									end
									if (13 == FlatIdent_86928) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 14;
									end
									if (FlatIdent_86928 == 10) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_86928 = 11;
									end
									if (FlatIdent_86928 == 5) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_86928 = 6;
									end
									if (FlatIdent_86928 == 3) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_86928 = 4;
									end
									if (FlatIdent_86928 == 14) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_86928 = 15;
									end
									if (FlatIdent_86928 == 29) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_86928 = 30;
									end
									if (FlatIdent_86928 == 27) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_86928 = 28;
									end
									if (FlatIdent_86928 == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 3;
									end
									if (17 == FlatIdent_86928) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 18;
									end
									if (FlatIdent_86928 == 11) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 12;
									end
									if (FlatIdent_86928 == 9) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_86928 = 10;
									end
									if (FlatIdent_86928 == 8) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_86928 = 9;
									end
									if (FlatIdent_86928 == 12) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_86928 = 13;
									end
									if (FlatIdent_86928 == 16) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_86928 = 17;
									end
									if (FlatIdent_86928 == 22) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_86928 = 23;
									end
									if (FlatIdent_86928 == 4) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_86928 = 5;
									end
									if (FlatIdent_86928 == 30) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 31;
									end
									if (FlatIdent_86928 == 6) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_86928 = 7;
									end
									if (FlatIdent_86928 == 21) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 22;
									end
									if (FlatIdent_86928 == 0) then
										A = nil;
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86928 = 1;
									end
									if (7 == FlatIdent_86928) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_86928 = 8;
									end
									if (FlatIdent_86928 == 23) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_86928 = 24;
									end
									if (FlatIdent_86928 == 28) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_86928 = 29;
									end
									if (FlatIdent_86928 == 26) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_86928 = 27;
									end
									if (24 == FlatIdent_86928) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_86928 = 25;
									end
									if (FlatIdent_86928 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_86928 = 2;
									end
									if (FlatIdent_86928 == 31) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										break;
									end
									if (FlatIdent_86928 == 25) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_86928 = 26;
									end
									if (FlatIdent_86928 == 20) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_86928 = 21;
									end
								end
							end
						elseif (Enum == 177) then
							local FlatIdent_83FD4 = 0;
							while true do
								if (FlatIdent_83FD4 == 6) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 7;
								end
								if (FlatIdent_83FD4 == 2) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 3;
								end
								if (FlatIdent_83FD4 == 4) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 5;
								end
								if (FlatIdent_83FD4 == 8) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 9;
								end
								if (FlatIdent_83FD4 == 5) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 6;
								end
								if (FlatIdent_83FD4 == 9) then
									Stk[Inst[2]] = Inst[3];
									break;
								end
								if (FlatIdent_83FD4 == 7) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 8;
								end
								if (FlatIdent_83FD4 == 0) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 1;
								end
								if (FlatIdent_83FD4 == 3) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 4;
								end
								if (FlatIdent_83FD4 == 1) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_83FD4 = 2;
								end
							end
						else
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 185) then
						if (Enum <= 181) then
							if (Enum <= 179) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							elseif (Enum > 180) then
								local FlatIdent_5B0A9 = 0;
								local B;
								local T;
								local A;
								while true do
									if (5 == FlatIdent_5B0A9) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5B0A9 = 6;
									end
									if (FlatIdent_5B0A9 == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_5B0A9 == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_5B0A9 = 8;
									end
									if (FlatIdent_5B0A9 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_5B0A9 = 1;
									end
									if (FlatIdent_5B0A9 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5B0A9 = 2;
									end
									if (FlatIdent_5B0A9 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5B0A9 = 4;
									end
									if (FlatIdent_5B0A9 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5B0A9 = 5;
									end
									if (FlatIdent_5B0A9 == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5B0A9 = 7;
									end
									if (FlatIdent_5B0A9 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5B0A9 = 3;
									end
								end
							else
								local B;
								local T;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 183) then
							if (Enum > 182) then
								local FlatIdent_8504E = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_8504E == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_8504E = 1;
									end
									if (FlatIdent_8504E == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_8504E = 4;
									end
									if (FlatIdent_8504E == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_8504E = 7;
									end
									if (FlatIdent_8504E == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_8504E == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_8504E = 6;
									end
									if (FlatIdent_8504E == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_8504E = 3;
									end
									if (FlatIdent_8504E == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_8504E = 5;
									end
									if (FlatIdent_8504E == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_8504E = 2;
									end
									if (FlatIdent_8504E == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_8504E = 8;
									end
								end
							else
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum == 184) then
							Stk[Inst[2]] = {};
						else
							local FlatIdent_3151F = 0;
							local B;
							local T;
							local A;
							while true do
								if (FlatIdent_3151F == 6) then
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									FlatIdent_3151F = 7;
								end
								if (FlatIdent_3151F == 5) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3151F = 6;
								end
								if (FlatIdent_3151F == 1) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3151F = 2;
								end
								if (FlatIdent_3151F == 2) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3151F = 3;
								end
								if (3 == FlatIdent_3151F) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3151F = 4;
								end
								if (0 == FlatIdent_3151F) then
									B = nil;
									T = nil;
									A = nil;
									FlatIdent_3151F = 1;
								end
								if (FlatIdent_3151F == 7) then
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
									break;
								end
								if (FlatIdent_3151F == 4) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_3151F = 5;
								end
							end
						end
					elseif (Enum <= 188) then
						if (Enum <= 186) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 187) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							local FlatIdent_71CE3 = 0;
							local A;
							while true do
								if (FlatIdent_71CE3 == 4) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									FlatIdent_71CE3 = 5;
								end
								if (FlatIdent_71CE3 == 1) then
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 2;
								end
								if (FlatIdent_71CE3 == 16) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_71CE3 = 17;
								end
								if (FlatIdent_71CE3 == 8) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 9;
								end
								if (FlatIdent_71CE3 == 20) then
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 21;
								end
								if (FlatIdent_71CE3 == 11) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_71CE3 = 12;
								end
								if (FlatIdent_71CE3 == 14) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 15;
								end
								if (FlatIdent_71CE3 == 9) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_71CE3 = 10;
								end
								if (FlatIdent_71CE3 == 19) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 20;
								end
								if (FlatIdent_71CE3 == 22) then
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									FlatIdent_71CE3 = 23;
								end
								if (FlatIdent_71CE3 == 21) then
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_71CE3 = 22;
								end
								if (0 == FlatIdent_71CE3) then
									A = nil;
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 1;
								end
								if (FlatIdent_71CE3 == 18) then
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_71CE3 = 19;
								end
								if (25 == FlatIdent_71CE3) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									break;
								end
								if (FlatIdent_71CE3 == 23) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									FlatIdent_71CE3 = 24;
								end
								if (FlatIdent_71CE3 == 15) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_71CE3 = 16;
								end
								if (FlatIdent_71CE3 == 13) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 14;
								end
								if (24 == FlatIdent_71CE3) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									FlatIdent_71CE3 = 25;
								end
								if (FlatIdent_71CE3 == 10) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									FlatIdent_71CE3 = 11;
								end
								if (2 == FlatIdent_71CE3) then
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_71CE3 = 3;
								end
								if (FlatIdent_71CE3 == 5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									FlatIdent_71CE3 = 6;
								end
								if (FlatIdent_71CE3 == 12) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									FlatIdent_71CE3 = 13;
								end
								if (FlatIdent_71CE3 == 17) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_71CE3 = 18;
								end
								if (FlatIdent_71CE3 == 7) then
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_71CE3 = 8;
								end
								if (FlatIdent_71CE3 == 3) then
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									FlatIdent_71CE3 = 4;
								end
								if (6 == FlatIdent_71CE3) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									FlatIdent_71CE3 = 7;
								end
							end
						end
					elseif (Enum <= 190) then
						if (Enum > 189) then
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						else
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum == 191) then
						local FlatIdent_1B64D = 0;
						local A;
						while true do
							if (FlatIdent_1B64D == 13) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								FlatIdent_1B64D = 14;
							end
							if (FlatIdent_1B64D == 17) then
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								FlatIdent_1B64D = 18;
							end
							if (FlatIdent_1B64D == 6) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								FlatIdent_1B64D = 7;
							end
							if (FlatIdent_1B64D == 21) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 22;
							end
							if (FlatIdent_1B64D == 19) then
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_1B64D = 20;
							end
							if (FlatIdent_1B64D == 23) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								FlatIdent_1B64D = 24;
							end
							if (FlatIdent_1B64D == 26) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_1B64D = 27;
							end
							if (FlatIdent_1B64D == 27) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 28;
							end
							if (1 == FlatIdent_1B64D) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_1B64D = 2;
							end
							if (FlatIdent_1B64D == 3) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 4;
							end
							if (FlatIdent_1B64D == 25) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								FlatIdent_1B64D = 26;
							end
							if (12 == FlatIdent_1B64D) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								FlatIdent_1B64D = 13;
							end
							if (FlatIdent_1B64D == 2) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 3;
							end
							if (FlatIdent_1B64D == 10) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								FlatIdent_1B64D = 11;
							end
							if (FlatIdent_1B64D == 4) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								FlatIdent_1B64D = 5;
							end
							if (FlatIdent_1B64D == 7) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_1B64D = 8;
							end
							if (FlatIdent_1B64D == 16) then
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 17;
							end
							if (FlatIdent_1B64D == 9) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 10;
							end
							if (5 == FlatIdent_1B64D) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								FlatIdent_1B64D = 6;
							end
							if (FlatIdent_1B64D == 15) then
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 16;
							end
							if (FlatIdent_1B64D == 22) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 23;
							end
							if (8 == FlatIdent_1B64D) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1B64D = 9;
							end
							if (FlatIdent_1B64D == 20) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_1B64D = 21;
							end
							if (11 == FlatIdent_1B64D) then
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								FlatIdent_1B64D = 12;
							end
							if (FlatIdent_1B64D == 24) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								FlatIdent_1B64D = 25;
							end
							if (FlatIdent_1B64D == 28) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								break;
							end
							if (18 == FlatIdent_1B64D) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								FlatIdent_1B64D = 19;
							end
							if (FlatIdent_1B64D == 0) then
								A = nil;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_1B64D = 1;
							end
							if (FlatIdent_1B64D == 14) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								FlatIdent_1B64D = 15;
							end
						end
					else
						local FlatIdent_274AE = 0;
						local B;
						local T;
						local A;
						while true do
							if (FlatIdent_274AE == 3) then
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_274AE = 4;
							end
							if (FlatIdent_274AE == 5) then
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								FlatIdent_274AE = 6;
							end
							if (0 == FlatIdent_274AE) then
								B = nil;
								T = nil;
								A = nil;
								Stk[Inst[2]] = {};
								FlatIdent_274AE = 1;
							end
							if (FlatIdent_274AE == 6) then
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
								break;
							end
							if (FlatIdent_274AE == 4) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								FlatIdent_274AE = 5;
							end
							if (FlatIdent_274AE == 1) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								FlatIdent_274AE = 2;
							end
							if (2 == FlatIdent_274AE) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_274AE = 3;
							end
						end
					end
				elseif (Enum <= 206) then
					if (Enum <= 199) then
						if (Enum <= 195) then
							if (Enum <= 193) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 194) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							end
						elseif (Enum <= 197) then
							if (Enum > 196) then
								local B;
								local T;
								local A;
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								local FlatIdent_578E6 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_578E6 == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_578E6 = 1;
									end
									if (FlatIdent_578E6 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_578E6 = 2;
									end
									if (3 == FlatIdent_578E6) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_578E6 = 4;
									end
									if (FlatIdent_578E6 == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_578E6 = 3;
									end
									if (FlatIdent_578E6 == 7) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_578E6 == 6) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_578E6 = 7;
									end
									if (FlatIdent_578E6 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_578E6 = 5;
									end
									if (FlatIdent_578E6 == 5) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_578E6 = 6;
									end
								end
							end
						elseif (Enum > 198) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 202) then
						if (Enum <= 200) then
							local FlatIdent_150B7 = 0;
							while true do
								if (FlatIdent_150B7 == 3) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									FlatIdent_150B7 = 4;
								end
								if (FlatIdent_150B7 == 6) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									break;
								end
								if (FlatIdent_150B7 == 5) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_150B7 = 6;
								end
								if (2 == FlatIdent_150B7) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_150B7 = 3;
								end
								if (FlatIdent_150B7 == 1) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									FlatIdent_150B7 = 2;
								end
								if (4 == FlatIdent_150B7) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_150B7 = 5;
								end
								if (0 == FlatIdent_150B7) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_150B7 = 1;
								end
							end
						elseif (Enum > 201) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						else
							local B;
							local T;
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 204) then
						if (Enum == 203) then
							local B;
							local T;
							local A;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						else
							local B;
							local T;
							local A;
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum > 205) then
						local FlatIdent_1113E = 0;
						local B;
						local T;
						local A;
						while true do
							if (FlatIdent_1113E == 0) then
								B = nil;
								T = nil;
								A = nil;
								FlatIdent_1113E = 1;
							end
							if (3 == FlatIdent_1113E) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1113E = 4;
							end
							if (FlatIdent_1113E == 6) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1113E = 7;
							end
							if (1 == FlatIdent_1113E) then
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1113E = 2;
							end
							if (7 == FlatIdent_1113E) then
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								FlatIdent_1113E = 8;
							end
							if (FlatIdent_1113E == 8) then
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
								break;
							end
							if (FlatIdent_1113E == 5) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1113E = 6;
							end
							if (FlatIdent_1113E == 4) then
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1113E = 5;
							end
							if (FlatIdent_1113E == 2) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_1113E = 3;
							end
						end
					else
						local FlatIdent_67504 = 0;
						local B;
						local T;
						local A;
						while true do
							if (0 == FlatIdent_67504) then
								B = nil;
								T = nil;
								A = nil;
								Stk[Inst[2]] = Inst[3];
								FlatIdent_67504 = 1;
							end
							if (FlatIdent_67504 == 3) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								FlatIdent_67504 = 4;
							end
							if (FlatIdent_67504 == 4) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								FlatIdent_67504 = 5;
							end
							if (FlatIdent_67504 == 2) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_67504 = 3;
							end
							if (FlatIdent_67504 == 5) then
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
								break;
							end
							if (FlatIdent_67504 == 1) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								FlatIdent_67504 = 2;
							end
						end
					end
				elseif (Enum <= 213) then
					if (Enum <= 209) then
						if (Enum <= 207) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						elseif (Enum == 208) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
						else
							local FlatIdent_11039 = 0;
							local B;
							local T;
							local A;
							while true do
								if (FlatIdent_11039 == 5) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_11039 = 6;
								end
								if (FlatIdent_11039 == 0) then
									B = nil;
									T = nil;
									A = nil;
									FlatIdent_11039 = 1;
								end
								if (FlatIdent_11039 == 6) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_11039 = 7;
								end
								if (FlatIdent_11039 == 8) then
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
									break;
								end
								if (FlatIdent_11039 == 4) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_11039 = 5;
								end
								if (FlatIdent_11039 == 7) then
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									FlatIdent_11039 = 8;
								end
								if (FlatIdent_11039 == 1) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_11039 = 2;
								end
								if (FlatIdent_11039 == 2) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_11039 = 3;
								end
								if (FlatIdent_11039 == 3) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_11039 = 4;
								end
							end
						end
					elseif (Enum <= 211) then
						if (Enum == 210) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						else
							local FlatIdent_1EA70 = 0;
							while true do
								if (FlatIdent_1EA70 == 3) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 4;
								end
								if (FlatIdent_1EA70 == 2) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 3;
								end
								if (FlatIdent_1EA70 == 6) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 7;
								end
								if (FlatIdent_1EA70 == 9) then
									Stk[Inst[2]] = Inst[3];
									break;
								end
								if (FlatIdent_1EA70 == 8) then
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 9;
								end
								if (FlatIdent_1EA70 == 7) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 8;
								end
								if (1 == FlatIdent_1EA70) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 2;
								end
								if (FlatIdent_1EA70 == 4) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 5;
								end
								if (0 == FlatIdent_1EA70) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 1;
								end
								if (FlatIdent_1EA70 == 5) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_1EA70 = 6;
								end
							end
						end
					elseif (Enum > 212) then
						local B;
						local T;
						local A;
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						T = Stk[A];
						B = Inst[3];
						for Idx = 1, B do
							T[Idx] = Stk[A + Idx];
						end
					else
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					end
				elseif (Enum <= 216) then
					if (Enum <= 214) then
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					elseif (Enum > 215) then
						local FlatIdent_2D31C = 0;
						local B;
						local T;
						local A;
						while true do
							if (FlatIdent_2D31C == 3) then
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_2D31C = 4;
							end
							if (FlatIdent_2D31C == 2) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_2D31C = 3;
							end
							if (FlatIdent_2D31C == 1) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								FlatIdent_2D31C = 2;
							end
							if (FlatIdent_2D31C == 4) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								FlatIdent_2D31C = 5;
							end
							if (FlatIdent_2D31C == 5) then
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								FlatIdent_2D31C = 6;
							end
							if (FlatIdent_2D31C == 0) then
								B = nil;
								T = nil;
								A = nil;
								Stk[Inst[2]] = {};
								FlatIdent_2D31C = 1;
							end
							if (FlatIdent_2D31C == 6) then
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
								break;
							end
						end
					else
						local A;
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					end
				elseif (Enum <= 218) then
					if (Enum == 217) then
						local A;
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					else
						local B;
						local T;
						local A;
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = {};
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						T = Stk[A];
						B = Inst[3];
						for Idx = 1, B do
							T[Idx] = Stk[A + Idx];
						end
					end
				elseif (Enum == 219) then
					local FlatIdent_8A411 = 0;
					while true do
						if (FlatIdent_8A411 == 5) then
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_8A411 = 6;
						end
						if (FlatIdent_8A411 == 2) then
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_8A411 = 3;
						end
						if (FlatIdent_8A411 == 6) then
							Stk[Inst[2]] = {};
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							break;
						end
						if (FlatIdent_8A411 == 0) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							FlatIdent_8A411 = 1;
						end
						if (1 == FlatIdent_8A411) then
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							FlatIdent_8A411 = 2;
						end
						if (FlatIdent_8A411 == 3) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							FlatIdent_8A411 = 4;
						end
						if (FlatIdent_8A411 == 4) then
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							FlatIdent_8A411 = 5;
						end
					end
				else
					local A;
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!C8052Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E73657274025Q00C0814003043Q000BE748A403053Q005B598626CF025Q00B8814003243Q007AE296D6262CEF92C92E2CB997C9267BBEC4C92F28E891C92F7AEDC7D2717CBE94DD217903053Q00174ADBA2E4025Q00B0814003043Q00BC3A28BA03043Q00D5E45F46025Q00A8814003803Q00A81FBB2B9968A818BB2E996EAD1EBE2B996AA81EBB2F9969A81BBB299969A81BBB2B996BA812BE29996BA81EBB2D996DA81EBB2C996EAD18BB2C996DAD19BB29996CA81DBE2B996DA81EBB299968A812BB2A9C6DA819BE2C9967AD19BB2D9969A812BB22996DA81DBE289C6CA81CBE299C6DA813BB23996DA81ABB28996AA81803063Q005E9B2A881AAA025Q00A0814003063Q00F55243D3D45C03043Q00B2A63D2F025Q0098814003093Q00D0A6E033394EAEE7AD03073Q00C195DE85504C3A025Q0090814003133Q0098E469EFDEE967E5DFE160E8D8E567EED1E46403043Q00DCE8D051025Q0080814003043Q001D50F32303043Q00484F319D025Q0078814003403Q0050ADE06409088E02FCB7382Q5D8A5CF3B4645C0FD806F3B03E00088C07AFB76B095C8505F3E264085B8C05FDE16C5E0F8F57AAB33A0D59D951ADEB6F5B0A8D0003073Q00BD64CBD25C3869025Q007081402Q033Q00DA1C8803053Q003D9B4BD877025Q0068814003093Q00C62E09E8DBA734F12503073Q005B83566C8BAED3025Q0060814003133Q00F7EA761E5DB0EF76195FBFEF721A58BFE5731803053Q006E87DD442E025Q0050814003043Q0039DBD62303073Q00166BBAB84824CC025Q0048814003403Q006D7E2FA0CF86D582392F7CA79CD4D2D56B2D7FA0CA87D5D8662F28F0CB8281D26B2E2CA39880D0D53C2D2FA690D7D6856B7378F49ED6D0D6687E2BA6CAD0808503083Q00E05F4B1A96A9B5B4025Q004081402Q033Q0099113903063Q00B2D846696A40025Q0038814003093Q00DF5BA50C0A6176F4E903083Q00869A23C06F7F1519025Q0030814003133Q00BB74F8F5D9F0A1F377F2FFDAF0A1F372FDF4DB03073Q0098CB43CAC7EDC7025Q0020814003043Q0098E90EAD03083Q0039CA8860C64F992B025Q0018814003803Q0016BA645E13BB615F16BA645A13BE615E13BC645A13BF615913BD645A13B1645B13BE645913BC645416BD645A13B1615813BE645416BF645A13BF645E16BF645A16B8615A13B0645816BC645816BB615E13BF645813BE615913BB645D13B0645A16BC615913B1615913BF645416BB645C16BC615D13BB645E13B0645F13B1645503043Q006C208957025Q0010814003063Q0046F78044A9AD03073Q00BC1598EC25DBCC025Q0008814003403Q00A6DFB976531BF2D4E027531AF582E4245619F0D1E727554DA3D3E7235610A2D1E0760518F2D6E42F5611AA84E3715249A082B72F014BA0DEE4225049A5D7E52703063Q002893E7811760026Q00814003023Q00299D03073Q00B667C57AB94FD1025Q00F8804003093Q007BFDF87BF5F251F7EE03063Q00863E859D1880025Q00F0804003133Q0094289B55D529945CD722965BD22D905CD3239603043Q006DE41AA2025Q00E0804003043Q0076F6ECC503063Q008D249782AE62025Q00D8804003803Q006BE851596BEC515F6EE9545C6BE7545B6BEF2Q516BE8515A6BE7515C6BE8515D6BE8515A6BEE51586BEC545C6BEA515A6BEF515D6EED545C6BEC545D6EEC515F6BEF51586EEC54596BEF545E6EE9515C6BED545D6EEB515D6EEE51596BEB54596BE651586BEE545A6BE9545B6EEB51596EEE515E6EE9515E6BEA545C6EE9515E03043Q006858DF62025Q00D0804003063Q00314551DB050603083Q008E622A3DBA776762025Q00C8804003093Q0004F9A1335F35EEB62303053Q002A4181C450025Q00C0804003133Q0012FFDE857A8C54FEDF837A8357FFDF86798A5103063Q00BB62CAE6B248025Q00B0804003043Q00B458FB8C03083Q00ACE63995E71C5AE1025Q00A8804003803Q000B8EB990F8BB60AC0B87BC96FDBF65AD0B8EB997F8BA65AE0E8EB993FDB965A80E8DBC96F8BA60AC0B8EB996F8BA65AD0E8DBC92FDBA65A80B8EB993F8B865A90E89B990FDB065AD0B8CBC95F8BC60AB0B8EBC95FDB165AB0B8CBC96FDB965AD0E89B990FDB160AF0B89B993FDBF60AB0B87B999F8B860A80B8CB997FDBC65A203083Q009A38BF8AA0CE8956025Q00A0804003063Q00C1553437E05B03043Q0056923A58025Q0098804003093Q0095591ED4DCE5E0EDA303083Q009FD0217BB7A9918F025Q0090804003143Q00B8D27AD72C2027F0D07FD0222C24FED371D7272C03073Q0011C8E348E21418025Q002Q804003043Q00C5E9D7A403043Q00CF9788B9025Q0078804003403Q0048F9A28447F6F4344AFAF3D747FDF1644DFAA78513FCF4614BABF7D014A5A0664EF8F585432QA1321EFFA68342A1F4324CADF38442A7A0304EF1F38415F2A36103083Q00567BC9C4B426C4C2025Q007080402Q033Q00D7954103073Q00D596C21192D67F025Q0068804003093Q00E50EC6F84DFC28F7D303083Q0085A076A39B388847025Q0060804003133Q0060A9534F1225AF55421527A651431126AF564103053Q0024109E6276025Q0050804003044Q0004FFF503053Q009E5265919E025Q0048804003243Q00AD439BF5F60D6D8EB8189DA3F546688FF01C81A9F15B6193AD4A9AF5F10D6FDBA3439AA303083Q00BE957AAC90C76B59025Q0040804003043Q009EF9D73403073Q007FC69CB95B6350025Q0038804003093Q00A1CD4C595A90DA5B4903053Q002FE4B5293A025Q0030804003143Q009AB2E66D4DDAB4E4634BDFB2E1624ED9B2E1664F03053Q007EEA83D655025Q0020804003043Q00861C2C8103073Q0061D47D42EA25E3025Q0018804003243Q004B420BB9F768CB4F5651BCAC68801F4A0DEAE368CF194C45B7FE67C8181D5EEAF8689B1D03073Q00AD2E7B688FCE51025Q0010804003043Q0078E1E8C203043Q00AD208486025Q0008804003093Q00F947C9B23A0FE8F3CF03083Q0081BC3FACD14F7B87026Q00804003143Q009D2DBE79DE25BB73DA2FBF7EDE25BB7EDD2CBA7B03043Q004BED1C8D025Q00E07F4003043Q00FF2EBC7603063Q0085AD4FD21D10025Q00D07F4003243Q00AE0C9C08C6AD0AC110C3FE51921093A90DC3109AAB09C0109AA85EC00BC4AE0D930494AB03053Q00A29868A53D025Q00C07F4003043Q00E2A37B4D03043Q0022BAC615025Q00B07F4003093Q005DE718466DEB12576B03043Q0025189F7D025Q00A07F4003133Q004DE2A78C11470DE7AA8E114F09E0AA8F104F0903063Q007E3DD793BD27025Q00807F4003043Q002QD2135B03073Q005380B37D3012E7025Q00707F4003603Q00BEC30C19F5B8C40410A7B8C1081FF1EB910D1AA6B9C35B11A1B6940F4BA5BBC0584DF3ECC70A1CA2B7950B4BF2E9C1041DF3EE910918A0BEC4091AA8EC9A0B4BA2BE975811A9B8965918F1BC94584AA5B9910C1DF3BF950848F3BBC70510F5EA03053Q00908FA23D29025Q00607F4003043Q00F1A20D8C03053Q00AFA6C37BE9025Q00507F4003803Q00A35E212E1382A35D24251382A65921251680A65A21261687A3552Q241681A65D24251386A35C212E1382A35B21271386A65A212E1680A3592126168BA65D24251680A35421271682A65A212F1387A35B21251382A35E21231382A35824271385A35924251684A355212F1687A35421271683A35D21271687A35A2422168AA35403063Q00B3906C121625025Q00407F4003063Q0095B95BD2B4B703043Q00B3C6D637025Q00307F4003093Q00F430D9F7C43CD3E6C203043Q0094B148BC025Q00207F4003143Q00471FB99D03270216BD9D042E0E1AB89D002B001703063Q001F372E88AB34026Q007F4003043Q00F72EF6A203073Q006BA54F98C9981D025Q00F07E4003603Q0092DD7C50F1CADF7D57AE9E8D2855F69C8C7D56A19E882C57A3CFDF2B53A2C8DB7907F6998D7D00AFC8DF7550A0CDDA7E56A4CFDF7E00F69D887403F5CE887855F29E897E52F29D8D7D50A29D8C2954F2CE897B56F5988F7E04F2C8DA7D5CA79803053Q0097ABBE4D65025Q00E07E4003043Q006FDF077F03073Q00AD38BE711A71A2025Q00D07E4003093Q00A7135F28971F55399103043Q004BE26B3A025Q00C07E4003133Q00C2EA95126478AD80E194116772AE8BE393166403073Q0099B2D3A0265441025Q00A07E4003043Q00F4F8F75D03063Q0010A62Q993644025Q00907E4003243Q009197D4E3FF929586FAAC9491D5FAFE94C683FAF6909786FAF72Q9582E1A993C6D1EEF99603053Q00CFA5A3E7D7025Q00807E4003043Q00C6770BD003043Q00BF9E1265025Q00707E4003403Q008B49A7FE881AA4F48E1EF7FAD949F3FB8D19F1FF8A1DF3F4DE1CF6FBDA13A3FC8C4AA7A9894EF5FFD91DA4A88948F3A9DD12F2FE8313A4AF8D12F2A8891CA2AE03043Q00CDBB2BC1025Q00607E4003083Q003F38B52D560D2FBC03053Q00216C5DD944025Q00507E4003093Q005CEC1D0001331C6BE703073Q0073199478637447025Q00407E4003133Q000DF0DAFF742E49F0DFFC712E45FCD2F37A204D03063Q00197DC9EACB43025Q00207E4003043Q00CFE0585303053Q00659D813638025Q00107E4003243Q00FF76631D4538B263B77D65474674E665FF287945163AE179A27E6241113FE131AC77621703083Q00549A4E54242759D7026Q007E4003043Q00168EED0903043Q00664EEB83025Q00F07D4003093Q005DB546A76DB94CB66B03043Q00C418CD23025Q00E07D4003143Q0017992751E054992358E057992251E8529A2358E003053Q00D867A81568025Q00C07D4003043Q00EAE9F24603063Q00D1B8889C2D21025Q00B07D4003803Q005DB675B27C93692A5DB470B179906C2D58B970B679956C2D58B975B57C966C2E5DB370B07992692E58B575B47C916C2758B570BE79956C2C58B175B67C91692C58B275B5799D6C2758B375B47996692D58B675B679916C295DB570B479926C285DB475B579966C2C58B170BF7996692A5DB270BF7C97692D58B670BE79926C2E03083Q001F6B8043874AA55F025Q00A07D4003063Q0017B4C2B436BA03043Q00D544DBAE025Q00907D4003093Q00F56352EDAAC47445FD03053Q00DFB01B378E025Q00807D4003143Q00A1022E8D2D6DE70628812868E8042B812A63E20503063Q005AD1331CB519025Q00607D4003043Q0080D9D47E03083Q0059D2B8BA15785DAF025Q00507D4003243Q00A91D0BD7A81A0ED6BD190EDEA3020BD6F5491786F41C09CAA81F0C82A6490C82A6160CD403043Q00E7902F3A025Q00407D4003043Q001D2FA24E03073Q00C5454ACC212F1F025Q00307D4003093Q00C0F54319EEF1E2540903053Q009B858D267A025Q00207D4003143Q00E74BF59140AF911BA249F49247AA9A1AA642F49703083Q002E977AC4A6749CA9026Q007D4003043Q007E1FD4AB03053Q00D02C7EBAC0025Q00F07C4003603Q0020466800C3632B40335099642B476907986474103406C26176123555C23226456552956470426252C53170446457903576176605943270463200C46124106857C0317617650699352245340395662B4E6802C26F2145690596622A456306C76103063Q005712765031A1025Q00E07C4003043Q0067EBEECD03053Q0021308A98A8025Q00D07C4003403Q005D742FE0F3101A6B09247DE3FD401D6F5D2079E2F44C443958722AB1F217496A5A212CE7A44D4A6C087471B5A0141F3D5A217AE5A6431D6D0B767FB5A6421A3A03083Q00583C104986C5757C025Q00C07C4003053Q00F7E60E511E03083Q0076B98F663E70D151025Q00B07C4003243Q00834DB301E8D14DE148B3831DE148BAD649B248B2D74FE548B3D71AB353EDD149E05CBDD403053Q008BE72CD665025Q00A07C4003043Q008D2BBA7203053Q00E4D54ED41D025Q00907C40034A3Q00B1A3B995D9EAA8F7BFC5DCBBB4EBEF91DEB4E0F1F791DBE8B0F2BB8A8BEEE6F5EA91C5EFB3F6BB93DDA1B5A4BB918EE8A8A7E9C38DB4B7EBEE9F8EBAB7A4F7C2DFB9E1F5BC8AD9EEB7F003063Q008C85C6DAA7E8025Q00807C4003053Q00C809D0E42203073Q00AD9B7EB9825642025Q00707C4003403Q00FD63F7B1E7BEAF67A7EFBCEAAE31F2B6E5BFAC67A4E5B4ECAD33F5E2B3EDA964A0B4B0E9AA65A7E7B5B9AE36F2E7B7BEAB36A7EEB3BBAD64F22QE5B9A836A1B603063Q00DA9E5796D784025Q00607C4003023Q007FB403043Q001331ECC8025Q00507C4003093Q00A0FBEADA16B28AF1FC03063Q00C6E5838FB963025Q00407C4003133Q009D1FD6BE22E3D511DCBA28E4DE1CD0B829E0DC03063Q00D6ED28E48910025Q00207C4003043Q00B92FBB2B03073Q008FEB4ED5405B62025Q00107C4003243Q00DC8ED8FEA412FE73C58DD9FEA55BF7728DDD90F4F346A56ED02Q8BA9F710F026DE828BFF03083Q0043E8BBBDCCC176C6026Q007C4003043Q00F9F08B1A03073Q00B2A195E57584DE025Q00F07B4003093Q0018082BFBC92B32023D03063Q005F5D704E98BC025Q00E07B4003143Q00D75F074897580247925B024B9157064F9356024903043Q007EA76E35025Q00C07B4003043Q002BE94CBB03053Q005A798822D0025Q00B07B4003603Q00F4AF757441ACFB717317F7A175261AA6AA702710A0AC227640F3F9237310A7AB267114A1AA247415A3AA727A10F0AA212710A7AF742745F7A87F721AF4AC707647A1FC2Q7045A0F9717345A5AF737642A3FC2Q7212F6AB7E7110A5FD777546F103053Q002395984742025Q00A07B4003043Q0020329F0D03043Q00687753E9025Q00907B4003243Q007FFF2EFDD374AB7EE58128AC79E5867CAF7AE58E7FF92FE58F7DFC79FED17BAF2AF1817E03053Q00B74DCA1CC8025Q00807B4003043Q00F05C4B7503063Q001BA839251A85025Q00707B4003403Q00097FF95453592DAC53520A2AF654575D2BAF51555D7CF95406072BAB52055A7EF65600067FA851045E7EAF5257097FF951040771AB54500C2EFD53540C2EF75003053Q00363F48CE64025Q00607B4003053Q0030C8A8EBB303063Q00127EA1C084DD025Q00507B4003093Q005FFEE03B455B1B68F503073Q00741A868558302F025Q00407B4003143Q00C7B9F27E8EBBF07C82BCF17A8FBBF67486BEF27C03043Q004CB788C2025Q00207B4003043Q00BF19144603043Q002DED787A025Q00107B4003243Q00718C707989F42787397ED4A47A992578D4F56ED6717F88BB7B84222C87F075D1227087A503063Q009643B41449B1026Q007B4003043Q00C5CEA3ED03063Q00949DABCD82C9025Q00F07A4003093Q0055B2A5E96C64A5B2F903053Q001910CAC08A025Q00E07A4003133Q0053134D665E0BF61B1848625B0FFA1A1D4B6D5803073Q00CF232B7B556B3C025Q00C07A4003043Q0013DCB47903053Q006F41BDDA12025Q00B07A4003243Q0059ED46880DBB128B10B946DB05A115DB58E809880AE810C705BC128F0BEA128F0BB512D903043Q00EA3D8C24025Q00A07A4003043Q0072DF18DD03073Q00DE2ABA76B2B761025Q00907A4003093Q00C9392D056E99F63EFF03083Q004C8C4148661BED99025Q00807A4003133Q0013897AF5DF568974FEDA558376F7DB508572F003053Q00E863B042C6025Q00607A4003043Q001223E3AE03083Q008940428DC599E88E025Q00507A4003243Q00724FDC79787A1F25558A297075007249DB2E657A1921499372787548751E882F7E7A1B7003073Q002D4378BE4A4843025Q00407A4003043Q00C88EA41803063Q00D590EBCA77CC025Q00307A4003093Q003E947C370E9876260803043Q00547BEC19025Q00207A4003133Q00EC5D0929B8AC500C29BEAE5A0D2FB8AF50082B03053Q00889C693F1B026Q007A4003043Q0095B6C7D703043Q00BCC7D7A9025Q00F0794003243Q007EADD817C07FABDC5BC77EF8D85B907FF9895B987CA98B5B997EAA8F40C778F9DC4F977D03053Q00A14E9CEA76025Q00E0794003043Q00B82BB14403073Q00BDE04EDF2BB78B025Q00D0794003803Q006AAAB0978FF66E6FA9B5928DF56D6FADB0908AF06E69ACB3978DF56E6AADB5908FF46E68ACB3978EF56C6FADB5968FF26B6EACB7928EF06A6FAFB09D8AF06E6FACBA978EF06C6AAEB5908FF26E69ACB0978FF56A6FA9B09D8FF66B65ACBA978BF0616AACB5968FF16E6FACBA928AF06E6FA6B5908AF06E6AACBB978BF02Q6AAE03073Q00585C9F83A4BCC3025Q00C0794003063Q0089ED16E7F7BB03053Q0085DA827A86025Q00B0794003093Q00FB937A3C3732D1996C03063Q0046BEEB1F5F42025Q00A0794003133Q00ADBD6BF299EAB86FF991ECB26AF399E9BF6AF803053Q00A9DD8B5FC0025Q0080794003043Q00D4FE84A803053Q00B1869FEAC3025Q0070794003803Q00BBF4D12E46E6006DBEF5D42B43E2056EBEF1D42A43E1006CBBF3D42E43E3056EBEF3D42E43E7006EBEFDD42846E7006DBEF0D42343E7006FBBF1D42D46E2056EBBF3D12D43E1006FBEF5D42C43E3006BBEF4D12F43E00069BEF3D42D46E10568BEF2D42243EB006DBEF1D42843E70568BEF1D12A43E1006EBEF5D42A43E4056803083Q005C8DC5E71B70D333025Q0060794003063Q00B0FFA68ACFB703063Q00D6E390CAEBBD025Q0050794003093Q0080E84DC7B0E447D6B603043Q00A4C59028025Q0040794003143Q00074D9C0E9888EE4E4F960A9888EC4748980F9B8F03073Q00DA777CAF3EA8B9025Q0020794003043Q00281C301303073Q00447A7D5E785591025Q0010794003243Q0045F4AA4C6F43F2AB556E14FAAA556A44A7F9556317A7FD556345F4FA4E3D43A7A9416D4603053Q005B75C29F78026Q00794003043Q002Q225C2Q03083Q008E7A47326C4D8D7B025Q00F0784003093Q006FE6A741643545ECB103063Q00412A9EC22211025Q00E0784003133Q00D723ABAF1C9F2CAAA81994212QAE129E21ACA103053Q002AA7149A98025Q00C0784003043Q00BF48E44303043Q0028ED298A025Q00B0784003243Q00D2F3E6C229B2D7A5AA9F20E18EEBB6967CB19BA7E19278FA8EF6B1C22FB180A3B19E2FE403063Q00D7B6C687A719025Q00A0784003043Q001C0AAC4803043Q0027446FC2025Q0090784003803Q009F6AE9A69A6AE9A39F6DE9A59F66E9A49F6BE9A29F67E9A19F66ECA69F6DECA99A6BE9A29F66ECA29F6EE9A39A6BECA69A6DE9A59A6DECA59A6BE9A19F6EECA19A6FECA89F6EE9A49A68ECA99F66ECA19F6AECA89F6CECA69A68ECA39A6CECA69F67ECA19A6DECA89F6FE9A39F6AE9A19A6FE9A39A6CE9A69F69ECA09F67E9A503043Q0090AC5EDF025Q0080784003063Q0062A708F20E1603073Q003831C864937C77025Q0070784003093Q00A828FD2748F58222EB03063Q0081ED5098443D025Q0060784003133Q00F77BFD0D7E23B57FFD0D7622B47FFA007725B603063Q0016874CC83846025Q0040784003043Q001AA0CA7703083Q004248C1A41C7E4351025Q0030784003803Q006B66B0A9BFBE80E26B68B0A82QBA80E56E6BB0AABFBE85E36E6BB5A82QBA80E16B68B0A9BFB880E66B6EB5ACBAB885E46B6FB5A8BAB280E56E6CB0ADBFB980E06B68B5AC2QBF80E46B6FB0A3BAB285E06B6AB0A3BAB285E56E6DB0A2BABC80E26E6AB5A8BAB880E76B67B0AFBABC80E62Q6BB0AFBFB980E36B6FB5AEBFB880E603083Q00D1585E839A898AB3025Q0020784003063Q00683DA041EF5A03053Q009D3B52CC20025Q0010784003093Q009DA0193FADAC132EAB03043Q005C2QD87C026Q00784003133Q005D4878B81C4879BE1B4878BF1E457AB615467803043Q008F2D714C025Q00E0774003043Q00FECC8C7A03053Q0026ACADE211025Q00D0774003803Q00A573434A4948A576434F4C4FA07243484C48A574434D4C4FA574434A494AA572464E4943A575434A494DA070464E4943A07F434E4C48A072434F4C49A07F434D4942A073434D494EA071462Q4C4DA07F434C494BA573464E4C49A075434D4942A07E434B494FA573464C2Q49A07E432Q4C48A576464E494EA072434E494DA07303063Q007B9347707F7A025Q00C0774003063Q00F7C24B3DE00F03073Q0095A4AD275C926E025Q00B0774003093Q0059C2DD5E4227DD6EC903073Q00B21CBAB83D3753025Q00A0774003143Q0040DA6D2600DE6A2E00DC672E01D3682301D9682F03043Q001730EB5E025Q0080774003043Q00F188CA8A03063Q00B5A3E9A42QE1025Q0070774003243Q00D19673B4A64CBA18C8C474E0A253EE1180C36AE3FC4FEA0DDD9571E4F218E945D39C71B203083Q0020E5A54781C47EDF025Q0060774003043Q00160BF5F903043Q00964E6E9B025Q0050774003093Q009B68DFC416A18C03AD03083Q0071DE10BAA763D5E3025Q0040774003133Q00D35E1B831327709B571180162870925211811F03073Q0044A36623B2271E025Q0020774003043Q001ADA538903063Q001F48BB3DE22E025Q0010774003403Q00932DB24404932BB44353902BB547579A2CB01606C129B54500C225E34754957FE316579B2BB31001902BBE4B009B2FE34607C678B1170F9A2FB24355C57EB31303053Q0036A31C8772026Q0077402Q033Q00D60D7D03073Q00D9975A2DB9481B025Q00F0764003093Q0096CEC8C2DCB54AA1C503073Q0025D3B6ADA1A9C1025Q00E0764003143Q00AA2E83220E48EC2D8B250D4BEC268A2B0C4EE32A03063Q007ADA1FB3133E025Q00C0764003043Q001D1F2Q2103063Q00674F7E4F4A61025Q00B0764003803Q00D79702AB9A0BD79502A69F0ED29E07A69A0CD79307A19F0AD29702A79F0AD79407A79A0FD79202A29F09D29502A79F0DD29402A29F0ED29E02A09A04D79502A09F0ED79207A79A0CD29307A69F0FD29F07A79A0DD79707A19F0AD29207A19A0CD29502A79F09D29102A49A05D79202A79A0ED79502A39F0ED79002A59F0ED29203063Q003CE1A63192A9025Q00A0764003063Q00CC3C050B20F903063Q00989F53696A52025Q0090764003093Q008FA9E8E462FA48B8A203073Q0027CAD18D87178E025Q0080764003133Q0004DEDD62700E47D8D164730D40D8D26F74094103063Q003974EDE55747025Q0060764003043Q00650D305403073Q0042376C5E3F12B4025Q0050764003803Q00DD8866BFD54B6351D88D66B2D541635FD88263B2D5416357D88C66B6D5426655DD8B66B7D0476653D88966B2D5416351DD8E66B5D0476655DD8E66B2D5436353D88963B3D0406352D88F63B2D54A6355D88963B7D546635ED88866B1D0416352D88963B3D5426654D88E66BED0466652DD8B66B2D0476650D88366B5D042665003083Q0066EBBA5586E67350025Q0040764003063Q002DEF79CBF88A03083Q00B67E8015AA8AEB79025Q0030764003093Q00711E82B5B0A48B461503073Q00E43466E7D6C5D0025Q0020764003133Q00081BB49B5505134F1ABA9B5F06184017B59E5603073Q002B782383AA6636026Q00764003043Q003041E3F803043Q009362208D025Q00F0754003803Q0003AF50E90C2FAF2C03AE50EA092EAF2C03A855EB0C26AF2C03AE55EC0C2DAF2E03AE55EB0C2CAA2F03A950EE0929AA2B03AF55EF0C2FAA2D06AD55EF0C26AA2C03AF50EA0C28AA2A03AB50EC0C26AA2F03AC50EE092BAA2903AA55EA092CAF2B06AC50EE092CAA2203A055EF0C2FAF2C03A855E6092CAA2806A855E80C2AAA2E03083Q001A309966DF3F1F99025Q00E0754003063Q00CCEFBEB81A3F03063Q005E9F80D2D968025Q00D0754003093Q006922E6AD1C5835F1BD03053Q00692C5A83CE025Q00C0754003133Q00C59CA5F6F3A52CEC8D9AA2FBF7AF24E78C99AF03083Q00DFB5AB96CFC3961C025Q00A0754003043Q002EFA04E903043Q00827C9B6A025Q0090754003803Q00104DE9FF5421104DECF551261047E9F7512A104DE9F15122104FE9F65427154AE9FF5422104EECF65121154AECF45120104DECF254221047ECF654261048E9FF5124104FE9F554261048ECF65422104AECF451261046ECF55426104BECF251241549ECF55425154CECF154261549ECF15426104AE9F25427104DECF65127154D03063Q0013237FDAC762025Q0080754003063Q000B3D1F822A3303043Q00E3585273025Q0070754003093Q00AF071CA5C99E100BB503053Q00BCEA7F79C6025Q0060754003133Q00E1731DBF8DA0741CB688A3741DBE8DA67D19BE03053Q00B991452D8F025Q0040754003043Q002A7F2D4003053Q00CB781E432B025Q0030754003803Q00D50483450E68D50283420B6ED00E83430B6CD00083410E6FD00186400E6CD00686410B6AD00F83470B6DD50383460E6AD50383400E6CD00683430B69D50483430E6AD50183470B6AD00283410E67D00683410E66D00483410B6ED50283470E69D006834C0B6BD00486470B69D00E83460E69D00486400B69D00F834D0B6CD50103063Q005FE337B0753D025Q0020754003063Q0001EC843C2Q5B03063Q003A5283E85D29025Q0010754003093Q00DCCF0FA0ABC65BBAEA03083Q00C899B76AC3DEB234026Q00754003133Q001D01606977AB540D6F6877AE590E6E6F75AF5C03063Q00986D39575E45025Q00E0744003043Q0078B612DE03073Q00C32AD77CB521EC025Q00D0744003403Q00D1B82A52D2EC2B0487BC770683ED780280EF7F5ED7E97A54D0EF2E0287BF7D04D5EC2D5E87BD2A06D1E17E01D5B8295582EC2C0682BC7756D5B82D0686E97F5303043Q0067B3D94F025Q00C0744003083Q00E387B5FA14E2C6D503073Q00B4B0E2D9936383025Q00B0744003803Q001592A5BF2FBF1599A0BF2FBF159FA5BB2ABA1598A0B92ABD159FA0B02FBE1599A0BF2FBE109AA5BC2FBB1592A5BF2AB91598A0BF2FBC159CA5BA2FBC1099A5BA2FBF159EA0B12ABA109AA0BE2ABB159BA5BC2FB6159EA0BE2FBF1099A0B82ABB1598A5BB2AB9109EA0BC2FBC109AA0B02FBF1099A0BD2FB7159CA0B82FBD159F03063Q008F26AB93891C025Q00A0744003063Q00152429BEF32703053Q0081464B45DF025Q0090744003093Q00C65DB3B508A1EC57A503063Q00D583252QD67D025Q0080744003143Q00AF676DD2E8A0B7EB646ED4E1A6B4EC666AD0E2A003073Q0083DF565DE3D094025Q0060744003043Q0079C21AE603063Q00C82BA3748D4F025Q0050744003803Q005FAAAED9225AA1A4DB275FA2AEDC2255A1AEDE225FA1AEDC2259A4AFDB285FA5AEDC275FA4A9DE255AA3ABDB275FA1ABDB255AA7ABDB2759A4ACDE205FA6ABDB225FA4A9DB245FA3ABDC2759A1AADE225FA3AEDF2259A4AEDB285FA4AEDC2759A1ACDB285FA0AEDF2259A4ACDB275AA1ABDE2758A1A8DE205AA7ABDE2254A4AC03053Q00116C929DE8025Q0040744003063Q004B85C242BD5303083Q003118EAAE23CF325D025Q0030744003093Q003BA8030B0DFC11A21503063Q00887ED0666878025Q0020744003133Q00E1B66974F5A8B0687AF0A2B06371F1A0B6687603053Q00C491835043026Q00744003043Q00D4052F3203073Q001A866441592C67025Q00F0734003243Q0079BFEA627CECEA6F60E2B86A7BF6BF6B28BEA3622FBFBB7775EBB83F7BBDB83F7BE2B86903043Q005A4DDB8E025Q00E0734003043Q002DF3FE1603063Q0026759690796B025Q00D0734003603Q00D5A6D5EC3ED4A287E969D8A281EB6AD9F184E96FDAF183E9648EA2D4ED6BDAA484B66588F4D6EC6888A887BD6EDAA981BA64DDF481BF69DCA1D3EA64D9A5D0BB3BD9F4D3B83EDAF1D5ED3C8CA1D1B76888A880BD6589A986BE3CD9F4D3B938DA03053Q005DED90E58F025Q00C0734003043Q00640A627603053Q005A336B1413025Q00B0734003093Q00E623E811ED22CC29FE03063Q0056A35B8D7298025Q00A0734003133Q0015D04246821E0A54DD454386180651DB46438303073Q003F65E97074B42F025Q0080734003043Q003DAEA01803083Q00B16FCFCE739F888C025Q0070734003243Q007BDB9CFFB68914216F8F95F1E6C1462027DD88FFB0DE433C7A8F93A3B18A412Q748693F503083Q001142BFA5C687EC77025Q00607340030F3Q00A28BDAD27887A8FD826CC899ECCC7B03053Q0014E8C189A2025Q0050734003243Q0023B86B2DD73078DB37EC622387782ADA7FBE7F2DD1672FC622EC6471D0332D8E2CE5642703083Q00EB1ADC5214E6551B025Q0040734003043Q00C6A6C77803053Q00349EC3A917025Q0030734003093Q009027E22541940DA72C03073Q0062D55F874634E0025Q0020734003133Q00C781146A838117698081106A868A17678E811603043Q005FB7B827026Q00734003043Q00CA2E302303083Q0024984F5E48B52562025Q00F0724003603Q00EFB1F14B8BAAA6EEE2F74FDCF6A8EFB0F44CD9A2A3E8E5FF48DDF7A9EFE3F74CD0F0A0BCE2A448DDF0F2E0B7F21EDCF1A9B8E0F74BDE2QF1E0B1A44CD1F0A8EEB5A21E8DA3A0E9B0A11ADDF6A0E9E0F34A8AAAA6E0B2A64BD8A7A2BDB2FE4C8903073Q0090D9D3C77FE893025Q00E0724003043Q003788FFBB03043Q00DE60E989025Q00D0724003093Q00C51B272QEAD0EF113103063Q00A4806342899F025Q00C0724003133Q00A1EA597FAF8EF8E6EA5A78A68CF8E5E75B75AE03073Q00C0D1D26E4D97BA025Q00A0724003043Q00CB3E16EF03043Q0084995F78025Q0090724003403Q00D98DF581808FDEF48285838DA1D385DFDAA1D08ADE87FB81D2DB8FA1D6D2DB8EA782D1838BFBDFD18C8EA782D08D8BF0D5D78D8FF3D2878CD9F281868ED9A0D103053Q00B3BABFC3E7025Q008072402Q033Q0099EA4603083Q0046D8BD1662D23418025Q0070724003243Q00EA99D1691DB89A807216BD9AD5721EE8CBD47217E199D27217E998D56949EFCB866619EA03053Q002FD9AEB05F025Q0060724003043Q0015E925D503073Q00E24D8C4BBA68BC025Q0050724003803Q00BB7BFF1B24E992E9BB7BFF1A24E992EBBB7EFA1F21EE92EDBB7AFA1E21E897EDBE79FA1F24EE97EEBB7AFF1C21EF97EEBB7CFF1E21ED92EBBE79FA1D21EA92EABB7BFA1E24E897EABB7BFA1C21EF97EABE7BFA1C21EE92ECBE7CFA1E21E892E8BB79FA1721EE92EFBB74FF1D24ED92EFBB74FA1921E492EDBE78FA1B24ED92E003083Q00D8884DC92F12DCA1025Q0040724003063Q0041E7C8A2194203073Q00191288A4C36B23025Q0030724003093Q000B533BD64405F33C5803073Q009C4E2B5EB53171025Q0020724003133Q00B3F3989B6B72DD2QF2FF9F996E73DAFBFAFF9903083Q00CBC3C6AFAA5D47ED026Q00724003043Q003A3D144B03073Q009D685C7A20646D025Q00F0714003403Q00D47028F4B6D4AA4282252DA2E38DAF418F737DF1B3DEAF4487737DFAB7DBA846857479F2BED8F54ED7247AF7B1D8F814852C28A6B0DDFD14D4252FF3E6DAF54603083Q0076B61549C387ECCC025Q00E071402Q033Q0081743503043Q008EC02365025Q00D0714003603Q0001C606AD1266F40C9554A21762AF5E9404FB4236A5019156A31765F25BC40FFC1165F1089652AA4260A5099203A31765A7019156AC1266A20A9306FF1632F20DC307AA4562A40CC703FE146BA15E9554AA1A64A00F9403FE4231AF0EC055AA4703073Q009738A5379A2353025Q00C0714003043Q00D9BCEE8603063Q00B98EDD98E322025Q00B0714003803Q00EEBF77F5940DEEB077F3940FEEB672F49405EEB777F2910FEBB677FF910EEEBE77F39108EEB177F2940AEBB372F29408EEB777F2940BEBB372F0940CEEB377F0940FEEBF77F1940EEEB577F6940CEEB077F6940EEBB477F7910FEEB672F29405EEBF77F4940AEEB172F5910FEEB377FE940FEBB172F5940BEBB377F79409EEBE03063Q003CDD8744C6A7025Q00A0714003063Q00D6B25B31DD3503063Q005485DD3750AF025Q0090714003093Q00A9C013DAAD4483CA0503063Q0030ECB876B9D8025Q0080714003133Q00EC04AE06022FAE03AA030623A503AC0D0B22AC03063Q001A9C379D3533025Q0060714003043Q001C821E4D03063Q00BA4EE3702649025Q0050714003803Q007FF863607AFD636F7AF8636A7FF8636A7AF963607FFD63687AFC63607FF9666C7FFE63607AFD636F7FF9636D7AF4666A7AFF63697AFB666C7FFA666A7AF8636E7FF9636C7AF9636A7AFD636B7AFA63697FF866697FF8666E7AFD63607FF8636D7AFB666E7AF4636D7AFD666B7AFA666E7AFB666D7FF8666D7AFF636E7FFE666C03043Q005849CC50025Q0040714003063Q000FD2CF12273D03053Q00555CBDA373025Q0030714003093Q007BD9AE25DA4ACEB93503053Q00AF3EA1CB46025Q0020714003133Q003C20B7007D2EB20B7C20B1097429B70F7C29B603043Q00384C1984026Q00714003043Q001829AF4803053Q00164A48C123025Q00F0704003803Q00B9E477B2166CBCE777B6136EBCE077B21669B9E677B4136AB9E777B7166EB9ED77B1136CBCE077BA1367B9E277BB1366B9E277B1136CBCE472B1136CB9E472B01369BCE477B71369BCE777B4136AB9EC77B61368B9E777BA166DB9E172B5136EBCE677B6166DB9E172B2166EB9E377B01369B9E677B4136BBCE077B7136CB9E503063Q005F8AD5448320025Q00E0704003063Q00795784E3585903043Q00822A38E8025Q00D0704003093Q002Q91D52D29B93AA69A03073Q0055D4E9B04E5CCD025Q00C0704003143Q009406AF0CD306AA03D507A60AD700A70FDD0FAF0B03043Q003AE4379E025Q00A0704003043Q0023A7A3A503063Q007371C6CDCE56025Q0090704003803Q00A918B4A924AD1FB6AA22AC19B4A821AB1FB2AF25AC19B1AB21AB1FB2AF2FAC18B1A524AF1FB5AF25AC1DB1AA21AB1FB6AA24A91DB1AF24A91FB2AA23AC1EB1A824A81FBAAA21A91BB1A824A31AB0AA25A91CB1A821AE1AB0AF2EA91FB1A924AB1AB0AF24A919B1A524A31FB2AF25A91FB1AC24AE1AB4AA21AC18B4AF21AE1FBA03053Q00179A2C829C025Q0080704003063Q009E255F4DA4AC03053Q00D6CD4A332C025Q002Q704003093Q009F9E7CF04ADA2BA89503073Q0044DAE619933FAE025Q0060704003143Q003C010DE09BFF72750604EA91F92Q740509E197FD03073Q00424C303CD8A3CB025Q0040704003043Q00722QA9E803053Q007020C8C783025Q0030704003803Q00AE7656455A71AE7256435A78AE74564B5A71AB7053445A78AE7E53445A74AE7353415F72AE7556465F73AE7656475F74AE7353445A74AE7353415A71AB7253465A76AE7053415A77AE7556445A71AE7753465F76AB7356435A75AB7456465A74AB7356415F73AB7053475F76AE7653435A74AE7753465A75AB7056415A70AE7103063Q00409D46657269025Q0020704003063Q00750CE52D411703063Q00762663894C33025Q0010704003093Q0086ABE7C2D3177F6AB003083Q0018C3D382A1A66310026Q00704003133Q00FB9CE2B69DBC93E7B09DBA9CE4B096BD97E5B703053Q00AE8BA5D181025Q00C06F4003043Q001E08E80703043Q006C4C6986025Q00A06F4003803Q00BBAD5BA1AB86BEA95EA5AB8FBEA75EA0AB82BEA95BA1AE85BBAF5BA2AB80BBAA5BA0AB84BBAF5EA7AB80BBAD5BA6AB86BEAE5BA0AB80BBAB5EAAAB8FBEAE5EA6AB8EBEAB5BA5AE84BEAD5BA1AB81BEAA5BA0AB83BBAF5EA3AB83BBAB5EA1AB84BEAA5EA3AE86BEAC5EA1AE82BEAF5EA2AB81BEA65BA2AB86BEAF5EA7AE86BEAB03063Q00B78D9E6D9398025Q00806F4003063Q009CC4CDCFBDCA03043Q00AECFABA1025Q00606F4003093Q008C10DB822ABD07CC9203053Q005FC968BEE1025Q00406F4003133Q0019FA64255EFB6D275CFC6E2150F96F265DFD6403043Q001369CD5D026Q006F4003043Q006FB4AC8C03043Q00E73DD5C2025Q00E06E4003243Q005C82A51708D3A2144685A61D5BCAF5150E81E91D5FD1FC0953D7F2415D81F2415DDEF21703043Q00246BE7C4025Q00C06E4003043Q00305C075003043Q003F683969025Q00A06E4003803Q0066DB2D0B81FEE78C66D5280B84FBE78B63D9280784FDE28A66DD2D0A81FAE78C66DD2D0A84FBE28A66D4280781FFE78C66D4280981F9E28C66DA280681FDE78966D42D0984FDE78F66D82D0D81F6E78066DC2D0E84FEE78966D4280A84F9E78166DA280881F7E78D66DF2D0B81F7E78E63DF280E84FEE78166DA2D0A81FDE78903083Q00B855ED1B3FB2CFD4025Q00806E4003063Q0097EF41B2F60103063Q0060C4802DD384025Q00606E4003093Q00DC0CC3FF99B5FF27EA03083Q00559974A69CECC190025Q00406E4003143Q003D65F48923FB80D17B67F38F2FF680D37467F28D03083Q00E64D54C5BC16CFB7026Q006E4003043Q00978B0BC503063Q0016C5EA65AE19025Q00E06D4003803Q007A80954EA193BE197F84954DA196BE127F86904FA195BE1E7F82954EA490BE197F839543A191BE1D7A82954AA199BB1C7A839049A198BB1C7A879548A497BE1B7F80904CA193BE1B7F819049A191BE137F859548A195BE1F7F859542A190BE1F7F83954FA198BE1F7F809048A196BB1E7A829049A492BB187A85954BA193BB1E03083Q002A4CB1A67A92A18D025Q00C06D4003063Q008458C91C33BF03063Q00DED737A57D41025Q00A06D4003093Q0050A95E49C361BE495903053Q00B615D13B2A025Q00806D4003143Q000A1371F66B1ABC5E4B1473FB6E1AB558421174F303083Q006E7A2243C35F2985025Q00406D4003043Q0036EEAAC803063Q003A648FC4A351025Q00206D4003803Q006F148FE6A92B5E65168BE2AC2B5B6F108FE4AC2C5E69168FE7AC2B596F138FE0A9255B6A1688E7AE2E586A178FE4A92A5E68138FE2A92E5D6A108FEDA9295E6E168BE2A92E5E6A168AE5A9255B6A168FE7AA2E5D6A178FE3A92F5E6C168BE2AB2B5C6F108FEDA92C5E6A138EE2A82B5B6F128AE0A92E5E69138AE7AC2B586F1603073Q006D5C25BCD49A1D026Q006D4003063Q00EDAB574D56DD03073Q0028BEC43B2C24BC025Q00E06C4003093Q0018CCBFDE625A28402E03083Q00325DB4DABD172E47025Q00C06C4003133Q009BD164EFBAD32DDAD263EBBED225D8D561E9B903073Q001DEBE455DB8EEB025Q00806C4003043Q0042CE878203063Q007610AF2QE9DF025Q00606C4003803Q00A2BE7FE773A4B97BE574A2B87FE273A5BC7AE576A2BC7AE273A3BC78E572A2B27FE076A8B97EE073A2B27AE473A4B97DE57DA2BD7FEF76A4B97AE57DA2BA7FE276A3B97BE071A2BF7AE773A0B978E572A2BC7FE276A2BC7EE571A2B87FE176A9BC79E076A2B97AE576A4B979E575A2BE7FE276A0BC7EE070A2B37AE273A7BC7F03053Q0045918A4CD6025Q00406C4003063Q00E98653031EEC03063Q008DBAE93F626C025Q00206C4003093Q00D3EE7C0293C8F9E46A03063Q00BC2Q961961E6026Q006C4003133Q00D66AEE64E9519469ED6EE05A936AE861E9509303063Q0062A658D956D9025Q00C06B4003043Q00F975CB3C03073Q0079AB14A5573243025Q00A06B4003803Q009589D08B7DB9958ED08C7DBC958ED08778BE9088D58D7DBA9580D58A7DBD908FD08B78B9958FD58C7DB8958FD08B7DB3958AD08A7DB29581D08C78BB958DD58A78B9958BD58C7DB8958DD58F7DBB9581D58A78B8958BD08A78B8958AD58B78BC908DD58D7DB2958BD58C7DB39581D08A7DBE9588D58D7DBD958AD58878B9958B03063Q008AA6B9E3BE4E025Q00806B4003063Q00F7202D251DC503053Q006FA44F4144025Q00606B4003093Q00716C03305B4077466703073Q0018341466532E34025Q00406B4003143Q00F76BBA25B169BF27B16FB226B06EBC21B36BBE2403043Q0010875A8B026Q006B4003043Q0021AD885703043Q003C73CCE6025Q00E06A4003803Q0067E570B367E570B467E670BE62E275B567E375B762E470B662E475B762E175B062E575B762E670B762E275B767E470B062E375B067E075B062E270B267E170B562E270BE67E275B362E370B562E470B267E875B767E175B267E975B467E870B567E575B567E970BE62E470B062E670BE67E570B367E975B567E370B462E475B703043Q008654D043025Q00C06A4003063Q00B1DEAD8CAB8503063Q00E4E2B1C1EDD9025Q00A06A4003093Q002647C6F8164BCCE91003043Q009B633FA3025Q00806A4003133Q002Q6BEC18E08822F42964EF10E38A25F7296BE603083Q00C51B5CDF20D1BB11025Q00406A4003043Q00FA5B002603083Q00E3A83A6E4D79B8CF025Q00206A4003243Q0003DEF40605D2F5074DDFF55156CAF3010581EF0804D3A61D58D7F4555681F45556DEF42Q03043Q003060E7C2026Q006A4003043Q003C404A2503053Q00A96425244A025Q00E0694003803Q00B68C5B6070B08A5D6072B38A5B6475B18F5B6073B38C5B6070B08A5D6076B38F5E6575BD8A5B607EB68E5B6775B78A5E6071B68B5B6175BC8A5E6573B6815E6175B68F5D6074B38A5B6B75B38A5A6572B38C5B6675B48A5F6075B38B5B6775BC8A516076B38A5B6475BC8F5B6077B68E5B6A75BC8A586073B38B5E6275B78A5803053Q004685B96853025Q00C0694003063Q007B7EB8FFD74903053Q00A52811D49E025Q00A0694003093Q001CBEB02A9F2DB8D22A03083Q00A059C6D549EA59D7025Q0080694003133Q003F4B0417A4D75E78400A18A7D7527F450A18A103073Q006B4F72322E97E7025Q0040694003043Q000B72774A03053Q00AE59131921025Q0020694003403Q0089405923AFAD89160371A8AD891E5622FDFF89475421A9A88A1F5320A9FFD9175975AAF98D165922F9AEDA1E0327AAFB80100520FDF88B145124FAF88147582503063Q00CBB8266013CB026Q0069402Q033Q00827BB103063Q006FC32CE17CDC025Q00E0684003803Q001906275D1C02225B1C022758190322591900225C1C0D275E1C0C275A1903275C1907225C1C03275F1C0D225A1C01275C1907275B1C00275F1C00275A190427581C00275A1907275D1C0D275A1C06225D1906275E1C0D275B1C07275F1C0D27581900225E1C01225D1C04225B1C03275C1904225E1903275C190727581906275903043Q00682F3514025Q00C0684003063Q00EE29FA42A7DC03053Q00D5BD469623025Q00A0684003093Q00D0A60F1862ECFAAC1903063Q009895DE6A7B17025Q0080684003143Q00962C7F448B9881D52C754E809983D42D78408E9A03073Q00B2E61D4D77B8AC025Q0040684003043Q009CEEB3B703043Q00DCCE8FDD025Q0020684003803Q00AC2007E3658EAAAC2203E56E88ADAC2607E1658BAFAE2207E06788ADA92702E7608AAFA62206E5638DA9AC2207E6658BAFA72202E06788AFA92502E7608BAFA92203E56688A9AC2002E0658AAFAB2706E5678DABA92302E5608FAAAE2705E56F8DABAC2202E3658CAFA92705E064882QA92302E3608FAFAE2201E5658DADAC2103073Q009C9F1134D656BE026Q00684003063Q002Q3E397C1F7F03063Q001E6D51551D6D025Q00E0674003093Q0073B7391D06F7FC44BC03073Q009336CF5C7E7383025Q00C0674003133Q00470E578D000C528F00085588060E51870E085003043Q00BE373864025Q0080674003043Q00D9C2EED203053Q00218BA380B9025Q0060674003403Q0059AC23B25AD75FFF76B30FD20DAC25E00ADB0FF576B60AD759FA76B45AD00FAE71B55E8157AF29B70ED45BAF73BD53D40FFF72E25CD50DFF75B308D45BFC75E103063Q00E26ECD10846B025Q004067402Q033Q0005219C03073Q00B74476CC815190025Q0020674003403Q000E51DB52755843A85F538B0A700A13FF0855DF0E700A48A90252890E7D5B40FA0C54DB5C245A15AF5F06D55F770913FE0953DE097C5744F303028E0F735F10F803083Q00CB3B60ED6B456F71026Q00674003083Q00054CFF1964CF244C03063Q00AE5629937013025Q00E0664003803Q00D778F0978B05E1DD7BF2978E00E6D77CF5968E07E4D07BF4928E05E3D27BF5918B05E4D77BFF928D00E7D77CF5928B0AE1D17EF5928C00E2D778F0908E01E1D07EF0928000E6D77BF5908B07E1D67BF4978D05E1D77BF0948B01E4D77BFF928B00E3D770F0978E07E1D77BF3928F00E6D77DF0958B0BE1D17BF4928005E0D27A03073Q00D2E448C6A1B833025Q00C0664003063Q00ECE8A2D9E1DE03053Q0093BF87CEB8025Q00A0664003093Q0004595507E2482C335203073Q004341213064973C025Q0080664003143Q00C2D48D73D7FF0283D28477D2FA0C87D78975DEFF03073Q0034B2E5BC43E7C9025Q0040664003043Q0099C2454D03083Q002DCBA32B26232A5B025Q0020664003803Q006FFE1F4093B5586AFE194B94B15F6AF91F4193B65D6FFB1E4B92B45B6FFA1A4D93B5586BFE1E4B90B45C6AF01F4896B65D6CFE1A4B95B1586FFC1A4E93B3586AFB144B95B1576FFE1F4F93B15D69FB144E96B15B6AF11A4C93B15D69FE194E94B1586AFC1F4C96B05D6EFE1D4E92B15F6AFE1A4C93B5586BFE1F4E94B15B6AFA03073Q006E59C82C78A082026Q00664003063Q00231B3EF4C4AF03073Q00C270745295B6CE025Q00E0654003093Q00C00150800A19204CF603083Q003E857935E37F6D4F025Q00C0654003133Q0092160809E59109DA1E0B06E69B07DB180D08E503073Q003EE22E2Q3FD0A9025Q0080654003043Q008A74ECFE03053Q00EDD8158295025Q0060654003403Q00F5077A13870A4F2FA2077012810C4075A2552D14830E4F70A6527146D65A4A77A2022D15810A4B24A0517D48D00A4974A2537D11D40B1E26AA517F468108192703083Q001693634970E23878025Q0040654003063Q004FF8253721A503063Q00C41C97495653025Q0020654003093Q0026DE724F16D2785E1003043Q002C63A617026Q00654003133Q00FEA4F468BFA4F264BBA6F369B7A3FB62BFA6F603043Q00508E97C2025Q00C0644003043Q0028B4860603043Q006D7AD5E8025Q00A0644003803Q0089B821BDD8908CBE24BDDD9489BE21BED89189BF24BCD89589BC24BEDD918CBA24BDD89F89BD24BFD89489B324BED89689B224B0DD968CBF21BDDD9389B224BDDD918CBF24B8D89E89B324BBD8968CB924B1DD918CB824BBD89689BE21BDD8948CB824BAD89E89BF24BFD8908CBF24BED89089B324B1DD918CB924BAD8978CBF03063Q00A7BA8B1788EB025Q0080644003063Q00EDA8C9DC61F003083Q006EBEC7A5BD13913D025Q0060644003093Q0067F65C8357FA56925103043Q00E0228E39025Q0040644003133Q0090A8D72464BEE545D5AEDA2F61B0E542D3AADA03083Q0076E09CE2165088D6026Q00644003043Q00744DCFA803063Q00A8262CA1C396025Q00E0634003803Q00D1A75777F4D2A75375F1D1A65770F4D3A75475FBD4A65275F4D3A75675F4D1A15277F1D1A75175F3D4A55270F1D3A75275FAD4A25774F4D4A75070F3D4A6577EF1D3A75270F4D4AD5273F1D7A75C70F7D4A15772F4D5A25775F5D4AC5770F1D7A25775FBD1A25777F4D1A25570F6D1A5577FF4D2A75075FAD4AC577EF1D1A75D03053Q00C2E7946446025Q00C0634003063Q00DFA70FC54EED03053Q003C8CC863A4025Q00A0634003093Q001506851B542411920B03053Q0021507EE078025Q0080634003143Q0040F0A776137D09F8A171157E03F6AC74177802F703063Q004E30C1954324025Q0040634003043Q00341E5CCC03073Q00EB667F32A7CC12025Q0020634003803Q00532B512D1D5ADC512055291D5DDF53245127185ED9582556291A58D956205128185CDC5220572C1A5DDF5622512B1D5DD950255629195DDE5625512E1856DC54205B291E58DC53205126185EDC522053291E58DC53205429185AD95520522C195DD95622512E1857D95325532C1B5DDC5620542B1856D9532057291F5DDE532303073Q00EA6013621F2B6E026Q00634003063Q00971600BB57A903083Q0050C4796CDA25C8D5025Q00E0624003093Q00A92441E14616832E5703063Q0062EC5C248233025Q00C0624003133Q003B4A7E06D8D4947B4A7F00DDDE9678407D0DDC03073Q00A24B724835EBE7025Q0080624003043Q00E480F14203053Q00BFB6E19F29025Q0060624003803Q00A5BB0B8F7601A5BC0B857302A0BF0E827305A0BD0B8F7303A0BA0E807602A0BD0E827601A5BE0B807603A5BB0E857602A0BD0B847302A0BB0E847300A5BB0B847601A0B60E857604A0BE0B817603A0BC0B8F7305A0BE0B857605A5BD0E82760FA5BA0B8F7601A5BE0E857607A5BC0E807600A0BD0E847303A0B60E877300A0BD03063Q0036938F38B645025Q0040624003063Q006B182B474A1603043Q0026387747025Q0020624003093Q006362510D265275461D03053Q0053261A346E026Q00624003133Q00EBF6E57FAFF8E47DA3FCE479ABFCE67BADFFE703043Q00489BCED2025Q00C0614003043Q008152C47B03083Q00A1D333AA107A5D35025Q00A0614003603Q006D570BBC395F5BB43D005BBC3A075FBA3E5E5BBD60545BEE68000BB9690558B83D5E55B4395554EE39555CB96C030BEE695708B4685E0FB568040EBF6B5F54BD6F5F58EE3E545CBA685409B86F055BEF3C025ABD6F535CEF695E5BE96C515FBC03043Q008D58666D025Q0080614003043Q00032716C503053Q0095544660A0025Q0060614003093Q00F3B8082CD6C2AF1F3C03053Q00A3B6C06D4F025Q0040614003143Q004E92A7B17A920A97A4B77D900E91A7B17A920E9A03063Q00A03EA395854C026Q00614003043Q008B0D8D2A03073Q00CCD96CE3416255025Q00E0604003803Q00515FF105EBB544F05458F406EEBD41F8545FF403EEB644F9515BF103EEB541FA515EF404EBB644F05150F102EEB644F1515AF407EEB444F0515CF40EEEB244F8545DF104EEB544FB545DF406EBB244F9515DF406EBB044FC545AF404EBB044F1515BF100EEB441FB2Q51F403EEB241FD545CF40EEEB444FC515EF405EEB444F803083Q00C96269C736DD8477025Q00C0604003063Q003CA9217EF5E903063Q00886FC64D1F87025Q00A0604003093Q00D669F30F055EFC63E503063Q002A9311966C70025Q0080604003143Q000BBCD407BE65694CBFD408BE2Q6E4CB4D007BC6E03073Q00597B8DE6318D5D025Q0040604003043Q00FC7FBC0803053Q00E5AE1ED263025Q0020604003803Q00D7150B76D7120E78D7130B79D2140B7ED7110E7AD7130B7BD7120E7AD7180B79D7130B76D7130B7BD7130B7BD7110E7CD7130B7CD7150B7FD2100E7AD7140B78D2120E7AD7100B7DD7100E7AD2140E78D7120E7DD2130E7BD7170B7AD2170B7FD2150B7FD7120E7DD7150E7FD7120B76D7150E7DD7100B7FD7180B7FD7100B7C03043Q004EE42138026Q00604003063Q001EC153EA54CE03073Q00E04DAE3F8B26AF025Q00C05F4003403Q008A85765F76038C847B087656DF847F0A7A52DE80790F2D04DD837E0D2A528380285D29018F89770F7A078F80790D2C028386780F79048B857B0477058F842C0E03063Q0037BBB14E3C4F025Q00805F4003083Q00B7C40CB02830DA8103073Q00A8E4A160D95F51025Q00405F4003093Q00E8FF18F80FD9E80FE803053Q007AAD877D9B026Q005F4003133Q0021548AE2A089E4685582ECA181ED625284E4A803073Q00DD5161B2D498B0025Q00805E4003043Q002021367703063Q00147240581CDC025Q00405E4003803Q00924B5BA45122EF90415AA65523E092425EA75120EF97445CA65723EE92445BA65421EA97445BA35726EA92415EA25122EA90445BA65023EB97445EAC5127EA964458A35426EF92405BA15129EA98445BA65B23E892425EA25126EA984159A35623EA92445EA35424EA91415AA35123EC924B5BA15423EA95445FA35423EB924603073Q00D9A1726D956210026Q005E4003063Q006E797F1D61AA03073Q002D3D16137C13CB025Q00C05D4003093Q00164A57F5EC275D40E503053Q0099532Q3296025Q00805D4003143Q00AEA5521DDBEBA45713D1E8A65213D3EAA2561CD103053Q00E3DE946325026Q005D4003043Q00F6CA1DCF03073Q00C8A4AB73A43D96025Q00C05C4003243Q0041AD666C2746FC60797743A960792743F833797714A966792E42AB30627044F8636D204103053Q0016729D5554025Q00805C4003043Q00CCA8B8DB03073Q003994CDD6B4C836025Q00405C4003803Q00E5E1B085E5EDB585E0E7B084E5E2B583E0E4B588E5E6B580E5E0B588E5E2B085E5EDB585E5ECB084E5E6B587E0E3B081E0E4B587E5E3B580E5E2B585E0E7B580E0E4B5812QE0B589E5E7B580E0E7B582E5E4B584E5E6B086E5E1B081E5E1B082E0E3B588E5E1B085E0E6B587E0E6B082E0E3B5872QE0B085E5EDB081E0E1B58903043Q00B0D6D586026Q005C4003063Q008982A4D3A88C03043Q00B2DAEDC8025Q00C05B4003093Q009C3BAE77AAAB4AA6AA03083Q00D4D943CB142QDF25025Q00805B4003143Q005E41662D1F4260231B45612A1940612B1941672303043Q001A2E7057026Q005B4003043Q00764BC07E03053Q0050242AAE15025Q00C05A4003243Q00B471B2092D21C4E66FB55A2F748BB373E25E3673C5B427AA042B27C3B424B1592D2890B103073Q00A68242873C1B11025Q00805A4003043Q002BD08CF403063Q00A773B5E29B8A025Q00405A4003803Q0067D32FEE62D22FEB62D62FE962D32FEC62D02AEE62D12FEE67D42FEA67D02FE862DA2AEA67D12AE862D12FEC62D22FEB67D02FE967D32FED67D72AED62DA2FE862D42FED62D02FEE62D42AE867D12FEF67D32FE467D72AE967D12AE862D52AEE62D32FEC67D12FEE62D62AEF67D12FEA62D62FE462D32FE567D02FE967D32FE403043Q00DC51E21C026Q005A4003063Q006F0ACCAE30D903063Q00B83C65A0CF42025Q00C0594003093Q00E79913FD2CFA57D09203073Q0038A2E1769E598E025Q0080594003133Q0025E3D8A38C65ECDFAA8C60E4D3A68361ECDDAA03053Q00BA55D4EB92026Q00594003043Q00CFCC1ADE03063Q00D79DAD74B52E025Q00C0584003803Q006D6CAFA56D6CAAA5686AAAA56D6CAAA06D6AAFA76D6EAAA96D6EAFA56D6AAAA66D6EAAA46D6CAAA3686AAFA4686CAFA06D66AFA5686AAFA3686CAAA46D69AAA06D6FAAA66D69AAA76D69AFA02Q6DAAA66D68AAA96D6EAAA5686CAFA52Q6DAAA36D6AAFA26D6EAAA16D6CAAA26D67AAA9686DAFA26D67AFA76869AFA36D6EAAA903043Q00915E5F99025Q0080584003063Q00DB0255FFC9E303083Q004E886D399EBB82E2025Q0040584003093Q00E45A37D510D54D20C503053Q0065A12252B6026Q00584003143Q0095E361591A1BDFD6EB60521916DADDEA655F1B1603073Q00E9E5D2536B282E025Q0080574003043Q00D3C93CF103083Q002281A8529A8F509C025Q0040574003803Q00E4B42AA5BF9DE4BD2FA3BF9DE1B12AA2BA98E4B62FA6BA93E4B62FA4BA9BE4B32AA7BA93E4B22FA6BA92E4B22AA4BF9EE1B12FA6BA92E4B72AA4BA98E1B32FA1BA9DE4B42AA1BA98E4B02AA4BA92E4BC2AA6BF9DE4BC2FA1BA9EE1B32FA3BA99E4B52FA3BF9AE1B32FA7BA9EE1B72AA1BA9FE1B02AA0BF9AE1B32FA6BA9FE4BD03063Q00ABD785199589026Q00574003063Q0016DE565BA12403053Q00D345B12Q3A025Q00C0564003243Q007E2F850E797B8C0A672F83087A63840A2F2B9859732B8116727E835E7C28835E7C77830803043Q003B4A4EB5025Q0080564003043Q00B4F8423D03073Q001AEC9D2C52722C025Q0040564003093Q00D2EB39D1E2E733C0E403043Q00B297935C026Q00564003133Q0090F094AB0EA6D3FE93A303AFD2F193AC07A9D103063Q009FE0C7A79B37025Q0080554003043Q00C670FBA603073Q00E7941195CD454D025Q0040554003803Q009D247205AE669B98247D07AB659D98257702AB659B9E247D02AC659D9821770CAB659B98217707A9609A982F7200AE669B99247607AE609198207700AE679E9A247107A560909D247206AE642Q9E217202AB659B98247207AB629B9E247C02A9659A98207700AB609B99217207A4659B98207702AE619E9A247507AF609E9D2403073Q00A8AB1744349D53026Q00554003063Q00D40DF6C8F52Q03043Q00A987629A025Q00C0544003093Q001243DA2A954251254803073Q003E573BBF49E036025Q0080544003143Q00B5FB714740519202F0FA734B44519505F5F8764B03083Q0031C5CA437E7364A7026Q00544003043Q009E2FA54003083Q0069CC4ECB2BA7377E025Q00C0534003243Q005062526B04003657775F563654770C503700770504330377055164036C5B573750630B5203053Q003D6152665A025Q0080534003043Q00DC74724603073Q008084111C29BB2F025Q0040534003803Q0071ED949871E895EC05E395EA029CE29A009B96EF089C99EE069B92E20399949A059997ED71E8E59D04EA94EC0698929F72EAE3EB079F94EB079B939E07ED91EE089B90E800ECE59E76EDE39905EAE0E900992QE27199E0EE74EFE59A719BE0EE039F969E08EF94E8749CE4E806EA96EA73EB94EC712QE3E2089BE5E2769B94EB03043Q00DB30DAA1026Q00534003093Q0041587984EE9877014D03063Q00EB122117E59E025Q00C0524003603Q007BDB35F8FEED342A8D36FCF9EF6529DC69FCFBBF6679D534FBFEE4677DD532F5F8EB612F8F64FBFAEE6E79D433F5F8B9667FD532A8AABB6072D565ADFFEA332EDA61FEF8BB30298962A8F0ED372E8A32A9FAEA602EDE33F9F1B8307F8D36AEF103073Q00564BEC50CCC9DD025Q0080524003043Q00791627AD03083Q003A2E7751C891D025025Q0040524003803Q00E901E517E902E518E907E516E901E516E907E014EC02E013E905E513E906E517E905E517EC02E515E901E517E904E015EC06E517E90CE013EC02E014EC05E014E906E516EC05E511E900E518E906E511EC06E014E90CE515E902E516E907E515E90DE016E905E512EC00E516E904E518EC00E014EC06E016E902E510E906E01403043Q0020DA34D6026Q00524003063Q007D88EF2C5C8603043Q004D2EE783025Q00C0514003093Q0096300AFFC54FBC3A1C03063Q003BD3486F9CB0025Q0080514003144Q0007D1DAD176F9A84007D5DDD379FDA5490FD1D903083Q00907036E3EBE64ECD026Q00514003043Q00692FBA5D03053Q002D3B4ED436025Q00C0504003803Q00694FA2E36942A7E76C45A7E66940A7E76940A7E26947A2E46940A2E46C45A2E16942A7E06947A7E76C45A2E16943A7E16C43A7E76946A2E66947A7E3694EA7E66C40A7E66946A2E06946A7E76C45A7ED6C42A7ED6944A7E76942A7ED6947A2E76940A7E06940A7E76940A7ED6C44A7E16940A7EC6941A2E76C44A7EC6945A2E603043Q00D55A7694025Q0080504003063Q00B122A94BCE4103073Q0071E24DC52ABC20025Q0040504003093Q005D9F2B146D9321056B03043Q007718E74E026Q00504003133Q00CF4DA0456F8F46A54D6A8E4BA64F69884FA64803053Q005ABF7F947C026Q004F4003043Q00CFB25E4E03063Q00BF9DD330251C025Q00804E4003803Q006F645AEE4ABF72626A655AED4ABC77616A605AED4AB977636A605FE84ABD77636F645AE24FB877666F695AE34ABC72626F615AE94FBF77666F635FE94AB877666F655FED4FB977636F685AEB4AB972636A625FEF4ABD72676A625AEA4FBD77666A635AEE4ABE72666F695AE94ABB72676A675FED4ABD72676F625FEA4FBD776603083Q00555C5169DB798B41026Q004E4003063Q0011573BD9CC1503073Q0086423857B8BE74025Q00804D4003093Q008FD008C8D0B7D8F3B903083Q0081CAA86DABA5C3B7026Q004D4003133Q00A87A2D4C71A3BFED722D4870A8BFE1772F4E7003073Q008FD8421E7E449B026Q004C4003043Q007CAADE7903083Q00C42ECBB0124FA32D025Q00804B4003803Q00FD0565687965F80D60697C68FD0465697964FD08606F7C69FD0F656E7C67F808606D7C62FD0F606D7C68F80E606B7962FD05656A7962FD0B60697C63FD0A656E7C67FD0C60627965FD09656A7C66FD0E656F7C67F808606F7C64F808606B7962FD0A606E7C61FD04606F7967FD0560687962FD0C606C7C67FD0A606C7960FD0803063Q0051CE3C535B4F026Q004B4003063Q0032E8445E610003053Q00136187283F025Q00804A4003093Q0098C1254FA8CD2F5EAE03043Q002CDDB940026Q004A4003133Q005B8AE9184A2E188BEB1D432B1A81E018432A1E03063Q001D2BB3D82C7B026Q00494003043Q000EAE8F4703073Q00185CCFE12C8319025Q0080484003803Q0088DC47A4EF8F9C88D843A6ED8F9E88DD42A2EF88998FDD42A6EC8A9988DC42A1EA889C8EDD43A6EF8A9E88DB42A1EF8F9C8DD846A6E08F9E8DDD47A0EF899C8ED845A6E88A9988D342A6EA899C88D847A6EB8F9E88D342A5EA889C89DD47A6EF8F9A88D842ACEA899C8AD847A6E98F9688D242A7EF8D9989DD45A6EC8F9B8DD903073Q00AFBBEB7195D9BC026Q00484003063Q006A5947FC678703083Q006B39362B9D15E6E7025Q0080474003603Q00099BB70F5CABD95999B00503A6D4029BB30E5CF183029AE4525EF0D50B90B60402A4D208CDE7520FA186039BB7550CA4D70F9DE10E0BF7D90FCEB50F0DA0D10B90BD555CF0810ECAE65559F7D459CCB00E59A6D5589AB7050AA7D003C9E3550803073Q00E03AA885363A92026Q00474003043Q006F2165F903063Q00203840139C3A025Q0080464003093Q00C0567509F05A7F18F603043Q006A852E10026Q00464003143Q00AEA3939A6896E12CEFA69296639FE028E6A5939103083Q001EDE92A1A25AAED2026Q00454003043Q00D4C4C33603043Q005D86A5AD025Q0080444003803Q00FB2BEAD260FF2EEBD660FE20EFD165FB2BE9D366FE2EEAD660F82BEFD36BFE2BEAD260FD2BE0D36AFE29EFD360F52EECD36BFE2DEAD865F92BECD366FB29EAD465FF2EE8D36BFB29EFD465FC2BEED665FB2EEAD565F92EE8D365FE2CEFD265F92BEED665FB2EEAD560FB2BE8D360FE2EEAD765F82BE1D361FE2CEAD860FF2EEC03053Q0053CD18D9E0026Q00444003063Q0074C339DD164603053Q006427AC55BC025Q0080434003093Q0089B11447A3FFC0BEBA03073Q00AFCCC97124D68B026Q00434003133Q009C520914B715B7DF550E11B116B7DB5C0610BD03073Q0080EC653F268421026Q00424003043Q00E61E09D803073Q00E6B47F67B3D61C025Q0080414003243Q0023D5BB1C538A10426887E91C02C540412082F214518B435D7DD4E949528E471573DDE91F03083Q007045E4DF2C64E871026Q00414003043Q0095D81EFF03063Q0096CDBD709018025Q00802Q4003603Q004CB8EFE7FFB9A34FBBBEE2F9B8F64EBBBDB3ADE5F243EEB9E5A8EDA64DB4BDE8A8EFF443BAEAE2AAEAA21FB9BBE5FEE8A34CB8B9E7AFE9A61FBFBAE3FCBEF71FBEEAE8AAECF24FB8E1B6AFBEF518ECEBE4FCBFF618B4E1E7F4ECA41BE8E1E6FC03073Q00C77A8DD8D0CCDD026Q002Q4003043Q00B62DDB1703053Q0087E14CAD72026Q003F4003803Q004763E46C1D6F7F4563EB6E18647A4263E16A18637A4363E66E1C64714263E46C1D637F4466E36E1F647B4765E46D18647F4763E66E18647E4765E16F18667F4366E06E1B617F4269E16E1D677F4363E56E1F617D4766E46918647F4763E36B16617F4260E46C1D637F4566E06E1C617D4765E16C18657A4563E06B1B647D426603073Q00497150D2582E57026Q003E4003063Q00F0008EF6D8C203053Q00AAA36FE297026Q003D4003093Q001D1687C5BF2C0190D503053Q00CA586EE2A6026Q003C4003133Q00C2BF62E4F5AA5D82B761E0F1AE5982B568E7F003073Q006BB28651D2C69E026Q003A4003043Q008AE8D5CF03043Q00A4D889BB026Q00394003803Q000E0C567A71B9410008507A70BE440E0F567A74BC410908517F75BE450B0F537B74B9440A0D5C7A73BB440B08562Q71BC440E08537A73BE402Q0B567974BE442Q0D5D7A7EBB430B0A567B71B9440E0D527F74BE4A0B0F567071BC440E08567A77BB410E0F567D74BC440D08537A72BE450B0A537F74BE440B08567F74BE410B0703073Q0072383E6549478D026Q00384003063Q00E7CBE25DC6C503043Q003CB4A48E026Q00374003093Q0073305A3B304AF7443B03073Q009836483F58453E026Q00364003133Q0017B8FC9754BBF1975EB8FD9F5FBDF49D55BFF203043Q00AE678EC5026Q00344003043Q00FA2F2E8B03073Q009CA84E40E0D479026Q00334003243Q009F077243E848C4553D42EA1DC6192145BC188A0C7643BB539F042611EF189151264DEF4D03063Q007EA7341074D9026Q00324003043Q003F13B72403043Q004B6776D9026Q00314003803Q00D8A1610FABFFDDA1610EABF7DDA6610FABFED8A3610CABF2D8A2610CABFFDDA16408AEF1D8A1610AABF0D8A3610DABF7DDA6640FAEF1D8A7640EABFED8A06409AEF2D8A8610AAEF4D8A96109ABFED8A6610EABF5D8A46408ABFED8A8640EABF3DDA36408AEF6D8A56409AEF3DDA5610EABF3D8A4610AABF3D8A7610CABF3D8A103063Q00C7EB90523D98026Q00304003063Q0085E626CA0AAF03083Q00A7D6894AAB78CE53026Q002E4003093Q0029D65B716B63FCF51F03083Q00876CAE3E121E1793026Q002C4003133Q00AB8D100C4CEB89160F4BE98B16084EE88B1B0B03053Q007EDBB9223D026Q002A402Q033Q0013EE1A03043Q00E849A14C026Q00284003043Q00F93D29ED03063Q00CAAB5C4786BE026Q00264003243Q0051EE89658057B9DB7ADC52E9887A8853BF8A7AD854EDD97A8152EC8E61DF54BFDD6E8F5103053Q00B962DAEB57026Q00244003043Q0084C6D90503063Q004BDCA3B76A62026Q00224003403Q004A400670481003241C1153761C415923181304271E17587C11415326101A06751915577D1B46577D481457724A17017C1B1550211C1555261147067D1D43587603043Q0045292260026Q0020402Q033Q0077FE9003073Q00DB36A9C05A3050026Q001C4003803Q00F58BDB7DA3EA8988DD0DD6E6F0FCAE7DD49BF58AD879A49D83FEAE7DA29CF0FCAC7DD39AF78BD978A4EB898AAF78D8E8F588DC0DD6E9F28BDE7BA5E8F7F9D809D99DF5FBA90AD2EFF48AD40FA59C8788D80ED99C828CDB7BD2E6F2FBDB09D69981FEAC7EA39DF287DE7CD1EC8088D90AD29A82FEA87BD2ED84FDD97CD89B878E03063Q00DFB1BFED4CE1026Q00184003093Q0047E3D2350367FF9C0E03053Q0073149ABC54026Q00144003603Q00F2D242F82A280FF6D346FB7C7D03F58014AD2D7A52F5D01AF0257A06FEDC46F1782400FED545AC242C53A58716F17E2C55F28340FB2E7E03A18316F9282A02F6D214FA252F02F28317AE2C2B52F68417FB7B7F53F28113F9787E55F3D41AFE2803073Q0037C7E523C81D1C026Q00104003043Q00CB416EE003073Q00569C2018851D26026Q00084003803Q0025F0EDA8156120F4EDAE106520F1EDAD106525F3EDA1156125F3E8AD156125F4E8AB106420F1E8AC106420F5EDA0156125F3EDAD106520F6E8AC156F25F4EDAF106025F0E8AD156020F5EDAF156E20FCE8AB156320F6EDAB106720FCEDAD156120F1E8AD156520F0E8AE156F20F3EDA9106420FDEDAA106225F7E8A9106220FD03063Q005613C5DE9826027Q004003063Q00E5F4A72500D703053Q0072B69BCB44026Q00F03F03093Q000336FB5303A8293CED03063Q00DC464E9E3076028Q0003133Q00D5871661E41D7894851161E61C7F978A1466E103073Q004AA5B32654D72903013Q005A03013Q005303013Q00410072123Q007D7Q00122Q000100013Q00202Q00010001000200122Q000200013Q00202Q00020002000300122Q000300013Q00202Q00030003000400122Q000400053Q00062Q0004000B0001000100044F3Q000B000100121C000400063Q0020AF00050004000700121C000600083Q0020AF00060006000900121C000700083Q0020AF00070007000A00065700083Q000100062Q00523Q00074Q00523Q00014Q00523Q00054Q00523Q00024Q00523Q00034Q00523Q00064Q0081000900083Q00122Q000A000C3Q00122Q000B000D6Q0009000B000200104Q000B00094Q000900083Q00122Q000A000F3Q00122Q000B00106Q0009000B000200104Q000E00094Q000900083Q00122Q000A00123Q00122Q000B00136Q0009000B000200104Q001100094Q000900083Q00122Q000A00153Q00122Q000B00166Q0009000B000200104Q001400094Q000900083Q00122Q000A00183Q00122Q000B00196Q0009000B000200104Q001700094Q000900083Q00122Q000A001B3Q00122Q000B001C6Q0009000B000200104Q001A00094Q000900083Q00122Q000A001E3Q00122Q000B001F6Q0009000B000200104Q001D00094Q000900083Q00122Q000A00213Q00122Q000B00226Q0009000B000200104Q002000094Q000900083Q00122Q000A00243Q00122Q000B00256Q0009000B000200104Q002300094Q000900083Q00122Q000A00273Q00122Q000B00286Q0009000B000200104Q002600094Q000900083Q00122Q000A002A3Q00122Q000B002B6Q0009000B000200104Q002900094Q000900083Q00122Q000A002D3Q00122Q000B002E6Q0009000B000200104Q002C00094Q000900083Q00122Q000A00303Q00122Q000B00316Q0009000B000200104Q002F00094Q000900083Q00122Q000A00333Q00122Q000B00346Q0009000B000200104Q003200094Q000900083Q00122Q000A00363Q00122Q000B00376Q0009000B000200104Q003500094Q000900083Q00122Q000A00393Q00122Q000B003A6Q0009000B000200104Q003800092Q0081000900083Q00122Q000A003C3Q00122Q000B003D6Q0009000B000200104Q003B00094Q000900083Q00122Q000A003F3Q00122Q000B00406Q0009000B000200104Q003E00094Q000900083Q00122Q000A00423Q00122Q000B00436Q0009000B000200104Q004100094Q000900083Q00122Q000A00453Q00122Q000B00466Q0009000B000200104Q004400094Q000900083Q00122Q000A00483Q00122Q000B00496Q0009000B000200104Q004700094Q000900083Q00122Q000A004B3Q00122Q000B004C6Q0009000B000200104Q004A00094Q000900083Q00122Q000A004E3Q00122Q000B004F6Q0009000B000200104Q004D00094Q000900083Q00122Q000A00513Q00122Q000B00526Q0009000B000200104Q005000094Q000900083Q00122Q000A00543Q00122Q000B00556Q0009000B000200104Q005300094Q000900083Q00122Q000A00573Q00122Q000B00586Q0009000B000200104Q005600094Q000900083Q00122Q000A005A3Q00122Q000B005B6Q0009000B000200104Q005900094Q000900083Q00122Q000A005D3Q00122Q000B005E6Q0009000B000200104Q005C00094Q000900083Q00122Q000A00603Q00122Q000B00616Q0009000B000200104Q005F00094Q000900083Q00122Q000A00633Q00122Q000B00646Q0009000B000200104Q006200094Q000900083Q00122Q000A00663Q00122Q000B00676Q0009000B000200104Q006500094Q000900083Q00122Q000A00693Q00122Q000B006A6Q0009000B000200104Q006800092Q0081000900083Q00122Q000A006C3Q00122Q000B006D6Q0009000B000200104Q006B00094Q000900083Q00122Q000A006F3Q00122Q000B00706Q0009000B000200104Q006E00094Q000900083Q00122Q000A00723Q00122Q000B00736Q0009000B000200104Q007100094Q000900083Q00122Q000A00753Q00122Q000B00766Q0009000B000200104Q007400094Q000900083Q00122Q000A00783Q00122Q000B00796Q0009000B000200104Q007700094Q000900083Q00122Q000A007B3Q00122Q000B007C6Q0009000B000200104Q007A00094Q000900083Q00122Q000A007E3Q00122Q000B007F6Q0009000B000200104Q007D00094Q000900083Q00122Q000A00813Q00122Q000B00826Q0009000B000200104Q008000094Q000900083Q00122Q000A00843Q00122Q000B00856Q0009000B000200104Q008300094Q000900083Q00122Q000A00873Q00122Q000B00886Q0009000B000200104Q008600094Q000900083Q00122Q000A008A3Q00122Q000B008B6Q0009000B000200104Q008900094Q000900083Q00122Q000A008D3Q00122Q000B008E6Q0009000B000200104Q008C00094Q000900083Q00122Q000A00903Q00122Q000B00916Q0009000B000200104Q008F00094Q000900083Q00122Q000A00933Q00122Q000B00946Q0009000B000200104Q009200094Q000900083Q00122Q000A00963Q00122Q000B00976Q0009000B000200104Q009500094Q000900083Q00122Q000A00993Q00122Q000B009A6Q0009000B000200104Q009800092Q0081000900083Q00122Q000A009C3Q00122Q000B009D6Q0009000B000200104Q009B00094Q000900083Q00122Q000A009F3Q00122Q000B00A06Q0009000B000200104Q009E00094Q000900083Q00122Q000A00A23Q00122Q000B00A36Q0009000B000200104Q00A100094Q000900083Q00122Q000A00A53Q00122Q000B00A66Q0009000B000200104Q00A400094Q000900083Q00122Q000A00A83Q00122Q000B00A96Q0009000B000200104Q00A700094Q000900083Q00122Q000A00AB3Q00122Q000B00AC6Q0009000B000200104Q00AA00094Q000900083Q00122Q000A00AE3Q00122Q000B00AF6Q0009000B000200104Q00AD00094Q000900083Q00122Q000A00B13Q00122Q000B00B26Q0009000B000200104Q00B000094Q000900083Q00122Q000A00B43Q00122Q000B00B56Q0009000B000200104Q00B300094Q000900083Q00122Q000A00B73Q00122Q000B00B86Q0009000B000200104Q00B600094Q000900083Q00122Q000A00BA3Q00122Q000B00BB6Q0009000B000200104Q00B900094Q000900083Q00122Q000A00BD3Q00122Q000B00BE6Q0009000B000200104Q00BC00094Q000900083Q00122Q000A00C03Q00122Q000B00C16Q0009000B000200104Q00BF00094Q000900083Q00122Q000A00C33Q00122Q000B00C46Q0009000B000200104Q00C200094Q000900083Q00122Q000A00C63Q00122Q000B00C76Q0009000B000200104Q00C500094Q000900083Q00122Q000A00C93Q00122Q000B00CA6Q0009000B000200104Q00C800092Q0081000900083Q00122Q000A00CC3Q00122Q000B00CD6Q0009000B000200104Q00CB00094Q000900083Q00122Q000A00CF3Q00122Q000B00D06Q0009000B000200104Q00CE00094Q000900083Q00122Q000A00D23Q00122Q000B00D36Q0009000B000200104Q00D100094Q000900083Q00122Q000A00D53Q00122Q000B00D66Q0009000B000200104Q00D400094Q000900083Q00122Q000A00D83Q00122Q000B00D96Q0009000B000200104Q00D700094Q000900083Q00122Q000A00DB3Q00122Q000B00DC6Q0009000B000200104Q00DA00094Q000900083Q00122Q000A00DE3Q00122Q000B00DF6Q0009000B000200104Q00DD00094Q000900083Q00122Q000A00E13Q00122Q000B00E26Q0009000B000200104Q00E000094Q000900083Q00122Q000A00E43Q00122Q000B00E56Q0009000B000200104Q00E300094Q000900083Q00122Q000A00E73Q00122Q000B00E86Q0009000B000200104Q00E600094Q000900083Q00122Q000A00EA3Q00122Q000B00EB6Q0009000B000200104Q00E900094Q000900083Q00122Q000A00ED3Q00122Q000B00EE6Q0009000B000200104Q00EC00094Q000900083Q00122Q000A00F03Q00122Q000B00F16Q0009000B000200104Q00EF00094Q000900083Q00122Q000A00F33Q00122Q000B00F46Q0009000B000200104Q00F200094Q000900083Q00122Q000A00F63Q00122Q000B00F76Q0009000B000200104Q00F500094Q000900083Q00122Q000A00F93Q00122Q000B00FA6Q0009000B000200104Q00F800092Q002D000900083Q00122Q000A00FC3Q00122Q000B00FD6Q0009000B000200104Q00FB00092Q0012000900083Q00122Q000A00FF3Q00122Q000B2Q00015Q0009000B000200104Q00FE000900122Q0009002Q015Q000A00083Q00122Q000B0002012Q00122Q000C0003015Q000A000C00026Q0009000A00122Q00090004015Q000A00083Q00122Q000B0005012Q00122Q000C0006015Q000A000C00026Q0009000A00122Q00090007015Q000A00083Q00122Q000B0008012Q00122Q000C0009015Q000A000C00026Q0009000A00122Q0009000A015Q000A00083Q00122Q000B000B012Q00122Q000C000C015Q000A000C00026Q0009000A00122Q0009000D015Q000A00083Q00122Q000B000E012Q00122Q000C000F015Q000A000C00026Q0009000A00122Q00090010015Q000A00083Q00122Q000B0011012Q00122Q000C0012015Q000A000C00026Q0009000A00122Q00090013015Q000A00083Q00122Q000B0014012Q00122Q000C0015015Q000A000C00026Q0009000A00122Q00090016015Q000A00083Q00122Q000B0017012Q00122Q000C0018015Q000A000C00026Q0009000A00122Q00090019015Q000A00083Q00122Q000B001A012Q00122Q000C001B015Q000A000C00026Q0009000A00122Q0009001C015Q000A00083Q00122Q000B001D012Q00122Q000C001E015Q000A000C00026Q0009000A00122Q0009001F015Q000A00083Q00122Q000B0020012Q00122Q000C0021015Q000A000C00026Q0009000A00122Q00090022015Q000A00083Q00122Q000B0023012Q00122Q000C0024015Q000A000C00026Q0009000A00122Q00090025015Q000A00083Q00122Q000B0026012Q001210000C0027013Q00BF000A000C00026Q0009000A00122Q00090028015Q000A00083Q00122Q000B0029012Q00122Q000C002A015Q000A000C00026Q0009000A00122Q0009002B015Q000A00083Q00122Q000B002C012Q00122Q000C002D015Q000A000C00026Q0009000A00122Q0009002E015Q000A00083Q00122Q000B002F012Q00122Q000C0030015Q000A000C00026Q0009000A00122Q00090031015Q000A00083Q00122Q000B0032012Q00122Q000C0033015Q000A000C00026Q0009000A00122Q00090034015Q000A00083Q00122Q000B0035012Q00122Q000C0036015Q000A000C00026Q0009000A00122Q00090037015Q000A00083Q00122Q000B0038012Q00122Q000C0039015Q000A000C00026Q0009000A00122Q0009003A015Q000A00083Q00122Q000B003B012Q00122Q000C003C015Q000A000C00026Q0009000A00122Q0009003D015Q000A00083Q00122Q000B003E012Q00122Q000C003F015Q000A000C00026Q0009000A00122Q00090040015Q000A00083Q00122Q000B0041012Q00122Q000C0042015Q000A000C00026Q0009000A00122Q00090043015Q000A00083Q00122Q000B0044012Q00122Q000C0045015Q000A000C00026Q0009000A00122Q00090046015Q000A00083Q00122Q000B0047012Q00122Q000C0048015Q000A000C00026Q0009000A00122Q00090049015Q000A00083Q00122Q000B004A012Q00122Q000C004B015Q000A000C00026Q0009000A00122Q0009004C015Q000A00083Q00122Q000B004D012Q00122Q000C004E015Q000A000C00026Q0009000A0012100009004F013Q00D7000A00083Q00122Q000B0050012Q00122Q000C0051015Q000A000C00026Q0009000A00122Q00090052015Q000A00083Q00122Q000B0053012Q00122Q000C0054015Q000A000C00026Q0009000A00122Q00090055015Q000A00083Q00122Q000B0056012Q00122Q000C0057015Q000A000C00026Q0009000A00122Q00090058015Q000A00083Q00122Q000B0059012Q00122Q000C005A015Q000A000C00026Q0009000A00122Q0009005B015Q000A00083Q00122Q000B005C012Q00122Q000C005D015Q000A000C00026Q0009000A00122Q0009005E015Q000A00083Q00122Q000B005F012Q00122Q000C0060015Q000A000C00026Q0009000A00122Q00090061015Q000A00083Q00122Q000B0062012Q00122Q000C0063015Q000A000C00026Q0009000A00122Q00090064015Q000A00083Q00122Q000B0065012Q00122Q000C0066015Q000A000C00026Q0009000A00122Q00090067015Q000A00083Q00122Q000B0068012Q00122Q000C0069015Q000A000C00026Q0009000A00122Q0009006A015Q000A00083Q00122Q000B006B012Q00122Q000C006C015Q000A000C00026Q0009000A00122Q0009006D015Q000A00083Q00122Q000B006E012Q00122Q000C006F015Q000A000C00026Q0009000A00122Q00090070015Q000A00083Q00122Q000B0071012Q00122Q000C0072015Q000A000C00026Q0009000A00122Q00090073015Q000A00083Q00122Q000B0074012Q00122Q000C0075015Q000A000C00026Q0009000A00122Q00090076015Q000A00083Q00122Q000B0077012Q001210000C0078013Q00BF000A000C00026Q0009000A00122Q00090079015Q000A00083Q00122Q000B007A012Q00122Q000C007B015Q000A000C00026Q0009000A00122Q0009007C015Q000A00083Q00122Q000B007D012Q00122Q000C007E015Q000A000C00026Q0009000A00122Q0009007F015Q000A00083Q00122Q000B0080012Q00122Q000C0081015Q000A000C00026Q0009000A00122Q00090082015Q000A00083Q00122Q000B0083012Q00122Q000C0084015Q000A000C00026Q0009000A00122Q00090085015Q000A00083Q00122Q000B0086012Q00122Q000C0087015Q000A000C00026Q0009000A00122Q00090088015Q000A00083Q00122Q000B0089012Q00122Q000C008A015Q000A000C00026Q0009000A00122Q0009008B015Q000A00083Q00122Q000B008C012Q00122Q000C008D015Q000A000C00026Q0009000A00122Q0009008E015Q000A00083Q00122Q000B008F012Q00122Q000C0090015Q000A000C00026Q0009000A00122Q00090091015Q000A00083Q00122Q000B0092012Q00122Q000C0093015Q000A000C00026Q0009000A00122Q00090094015Q000A00083Q00122Q000B0095012Q00122Q000C0096015Q000A000C00026Q0009000A00122Q00090097015Q000A00083Q00122Q000B0098012Q00122Q000C0099015Q000A000C00026Q0009000A00122Q0009009A015Q000A00083Q00122Q000B009B012Q00122Q000C009C015Q000A000C00026Q0009000A00122Q0009009D015Q000A00083Q00122Q000B009E012Q00122Q000C009F015Q000A000C00026Q0009000A001210000900A0013Q00D7000A00083Q00122Q000B00A1012Q00122Q000C00A2015Q000A000C00026Q0009000A00122Q000900A3015Q000A00083Q00122Q000B00A4012Q00122Q000C00A5015Q000A000C00026Q0009000A00122Q000900A6015Q000A00083Q00122Q000B00A7012Q00122Q000C00A8015Q000A000C00026Q0009000A00122Q000900A9015Q000A00083Q00122Q000B00AA012Q00122Q000C00AB015Q000A000C00026Q0009000A00122Q000900AC015Q000A00083Q00122Q000B00AD012Q00122Q000C00AE015Q000A000C00026Q0009000A00122Q000900AF015Q000A00083Q00122Q000B00B0012Q00122Q000C00B1015Q000A000C00026Q0009000A00122Q000900B2015Q000A00083Q00122Q000B00B3012Q00122Q000C00B4015Q000A000C00026Q0009000A00122Q000900B5015Q000A00083Q00122Q000B00B6012Q00122Q000C00B7015Q000A000C00026Q0009000A00122Q000900B8015Q000A00083Q00122Q000B00B9012Q00122Q000C00BA015Q000A000C00026Q0009000A00122Q000900BB015Q000A00083Q00122Q000B00BC012Q00122Q000C00BD015Q000A000C00026Q0009000A00122Q000900BE015Q000A00083Q00122Q000B00BF012Q00122Q000C00C0015Q000A000C00026Q0009000A00122Q000900C1015Q000A00083Q00122Q000B00C2012Q00122Q000C00C3015Q000A000C00026Q0009000A00122Q000900C4015Q000A00083Q00122Q000B00C5012Q00122Q000C00C6015Q000A000C00026Q0009000A00122Q000900C7015Q000A00083Q00122Q000B00C8012Q001210000C00C9013Q00BF000A000C00026Q0009000A00122Q000900CA015Q000A00083Q00122Q000B00CB012Q00122Q000C00CC015Q000A000C00026Q0009000A00122Q000900CD015Q000A00083Q00122Q000B00CE012Q00122Q000C00CF015Q000A000C00026Q0009000A00122Q000900D0015Q000A00083Q00122Q000B00D1012Q00122Q000C00D2015Q000A000C00026Q0009000A00122Q000900D3015Q000A00083Q00122Q000B00D4012Q00122Q000C00D5015Q000A000C00026Q0009000A00122Q000900D6015Q000A00083Q00122Q000B00D7012Q00122Q000C00D8015Q000A000C00026Q0009000A00122Q000900D9015Q000A00083Q00122Q000B00DA012Q00122Q000C00DB015Q000A000C00026Q0009000A00122Q000900DC015Q000A00083Q00122Q000B00DD012Q00122Q000C00DE015Q000A000C00026Q0009000A00122Q000900DF015Q000A00083Q00122Q000B00E0012Q00122Q000C00E1015Q000A000C00026Q0009000A00122Q000900E2015Q000A00083Q00122Q000B00E3012Q00122Q000C00E4015Q000A000C00026Q0009000A00122Q000900E5015Q000A00083Q00122Q000B00E6012Q00122Q000C00E7015Q000A000C00026Q0009000A00122Q000900E8015Q000A00083Q00122Q000B00E9012Q00122Q000C00EA015Q000A000C00026Q0009000A00122Q000900EB015Q000A00083Q00122Q000B00EC012Q00122Q000C00ED015Q000A000C00026Q0009000A00122Q000900EE015Q000A00083Q00122Q000B00EF012Q00122Q000C00F0015Q000A000C00026Q0009000A001210000900F1013Q00D7000A00083Q00122Q000B00F2012Q00122Q000C00F3015Q000A000C00026Q0009000A00122Q000900F4015Q000A00083Q00122Q000B00F5012Q00122Q000C00F6015Q000A000C00026Q0009000A00122Q000900F7015Q000A00083Q00122Q000B00F8012Q00122Q000C00F9015Q000A000C00026Q0009000A00122Q000900FA015Q000A00083Q00122Q000B00FB012Q00122Q000C00FC015Q000A000C00026Q0009000A00122Q000900FD015Q000A00083Q00122Q000B00FE012Q00122Q000C00FF015Q000A000C00026Q0009000A00122Q00092Q00025Q000A00083Q00122Q000B0001022Q00122Q000C002Q025Q000A000C00026Q0009000A00122Q00090003025Q000A00083Q00122Q000B0004022Q00122Q000C0005025Q000A000C00026Q0009000A00122Q00090006025Q000A00083Q00122Q000B0007022Q00122Q000C0008025Q000A000C00026Q0009000A00122Q00090009025Q000A00083Q00122Q000B000A022Q00122Q000C000B025Q000A000C00026Q0009000A00122Q0009000C025Q000A00083Q00122Q000B000D022Q00122Q000C000E025Q000A000C00026Q0009000A00122Q0009000F025Q000A00083Q00122Q000B0010022Q00122Q000C0011025Q000A000C00026Q0009000A00122Q00090012025Q000A00083Q00122Q000B0013022Q00122Q000C0014025Q000A000C00026Q0009000A00122Q00090015025Q000A00083Q00122Q000B0016022Q00122Q000C0017025Q000A000C00026Q0009000A00122Q00090018025Q000A00083Q00122Q000B0019022Q001210000C001A023Q00BF000A000C00026Q0009000A00122Q0009001B025Q000A00083Q00122Q000B001C022Q00122Q000C001D025Q000A000C00026Q0009000A00122Q0009001E025Q000A00083Q00122Q000B001F022Q00122Q000C0020025Q000A000C00026Q0009000A00122Q00090021025Q000A00083Q00122Q000B0022022Q00122Q000C0023025Q000A000C00026Q0009000A00122Q00090024025Q000A00083Q00122Q000B0025022Q00122Q000C0026025Q000A000C00026Q0009000A00122Q00090027025Q000A00083Q00122Q000B0028022Q00122Q000C0029025Q000A000C00026Q0009000A00122Q0009002A025Q000A00083Q00122Q000B002B022Q00122Q000C002C025Q000A000C00026Q0009000A00122Q0009002D025Q000A00083Q00122Q000B002E022Q00122Q000C002F025Q000A000C00026Q0009000A00122Q00090030025Q000A00083Q00122Q000B0031022Q00122Q000C0032025Q000A000C00026Q0009000A00122Q00090033025Q000A00083Q00122Q000B0034022Q00122Q000C0035025Q000A000C00026Q0009000A00122Q00090036025Q000A00083Q00122Q000B0037022Q00122Q000C0038025Q000A000C00026Q0009000A00122Q00090039025Q000A00083Q00122Q000B003A022Q00122Q000C003B025Q000A000C00026Q0009000A00122Q0009003C025Q000A00083Q00122Q000B003D022Q00122Q000C003E025Q000A000C00026Q0009000A00122Q0009003F025Q000A00083Q00122Q000B0040022Q00122Q000C0041025Q000A000C00026Q0009000A00121000090042023Q00D7000A00083Q00122Q000B0043022Q00122Q000C0044025Q000A000C00026Q0009000A00122Q00090045025Q000A00083Q00122Q000B0046022Q00122Q000C0047025Q000A000C00026Q0009000A00122Q00090048025Q000A00083Q00122Q000B0049022Q00122Q000C004A025Q000A000C00026Q0009000A00122Q0009004B025Q000A00083Q00122Q000B004C022Q00122Q000C004D025Q000A000C00026Q0009000A00122Q0009004E025Q000A00083Q00122Q000B004F022Q00122Q000C0050025Q000A000C00026Q0009000A00122Q00090051025Q000A00083Q00122Q000B0052022Q00122Q000C0053025Q000A000C00026Q0009000A00122Q00090054025Q000A00083Q00122Q000B0055022Q00122Q000C0056025Q000A000C00026Q0009000A00122Q00090057025Q000A00083Q00122Q000B0058022Q00122Q000C0059025Q000A000C00026Q0009000A00122Q0009005A025Q000A00083Q00122Q000B005B022Q00122Q000C005C025Q000A000C00026Q0009000A00122Q0009005D025Q000A00083Q00122Q000B005E022Q00122Q000C005F025Q000A000C00026Q0009000A00122Q00090060025Q000A00083Q00122Q000B0061022Q00122Q000C0062025Q000A000C00026Q0009000A00122Q00090063025Q000A00083Q00122Q000B0064022Q00122Q000C0065025Q000A000C00026Q0009000A00122Q00090066025Q000A00083Q00122Q000B0067022Q00122Q000C0068025Q000A000C00026Q0009000A00122Q00090069025Q000A00083Q00122Q000B006A022Q001210000C006B023Q00BF000A000C00026Q0009000A00122Q0009006C025Q000A00083Q00122Q000B006D022Q00122Q000C006E025Q000A000C00026Q0009000A00122Q0009006F025Q000A00083Q00122Q000B0070022Q00122Q000C0071025Q000A000C00026Q0009000A00122Q00090072025Q000A00083Q00122Q000B0073022Q00122Q000C0074025Q000A000C00026Q0009000A00122Q00090075025Q000A00083Q00122Q000B0076022Q00122Q000C0077025Q000A000C00026Q0009000A00122Q00090078025Q000A00083Q00122Q000B0079022Q00122Q000C007A025Q000A000C00026Q0009000A00122Q0009007B025Q000A00083Q00122Q000B007C022Q00122Q000C007D025Q000A000C00026Q0009000A00122Q0009007E025Q000A00083Q00122Q000B007F022Q00122Q000C0080025Q000A000C00026Q0009000A00122Q00090081025Q000A00083Q00122Q000B0082022Q00122Q000C0083025Q000A000C00026Q0009000A00122Q00090084025Q000A00083Q00122Q000B0085022Q00122Q000C0086025Q000A000C00026Q0009000A00122Q00090087025Q000A00083Q00122Q000B0088022Q00122Q000C0089025Q000A000C00026Q0009000A00122Q0009008A025Q000A00083Q00122Q000B008B022Q00122Q000C008C025Q000A000C00026Q0009000A00122Q0009008D025Q000A00083Q00122Q000B008E022Q00122Q000C008F025Q000A000C00026Q0009000A00122Q00090090025Q000A00083Q00122Q000B0091022Q00122Q000C0092025Q000A000C00026Q0009000A00121000090093023Q00D7000A00083Q00122Q000B0094022Q00122Q000C0095025Q000A000C00026Q0009000A00122Q00090096025Q000A00083Q00122Q000B0097022Q00122Q000C0098025Q000A000C00026Q0009000A00122Q00090099025Q000A00083Q00122Q000B009A022Q00122Q000C009B025Q000A000C00026Q0009000A00122Q0009009C025Q000A00083Q00122Q000B009D022Q00122Q000C009E025Q000A000C00026Q0009000A00122Q0009009F025Q000A00083Q00122Q000B00A0022Q00122Q000C00A1025Q000A000C00026Q0009000A00122Q000900A2025Q000A00083Q00122Q000B00A3022Q00122Q000C00A4025Q000A000C00026Q0009000A00122Q000900A5025Q000A00083Q00122Q000B00A6022Q00122Q000C00A7025Q000A000C00026Q0009000A00122Q000900A8025Q000A00083Q00122Q000B00A9022Q00122Q000C00AA025Q000A000C00026Q0009000A00122Q000900AB025Q000A00083Q00122Q000B00AC022Q00122Q000C00AD025Q000A000C00026Q0009000A00122Q000900AE025Q000A00083Q00122Q000B00AF022Q00122Q000C00B0025Q000A000C00026Q0009000A00122Q000900B1025Q000A00083Q00122Q000B00B2022Q00122Q000C00B3025Q000A000C00026Q0009000A00122Q000900B4025Q000A00083Q00122Q000B00B5022Q00122Q000C00B6025Q000A000C00026Q0009000A00122Q000900B7025Q000A00083Q00122Q000B00B8022Q00122Q000C00B9025Q000A000C00026Q0009000A00122Q000900BA025Q000A00083Q00122Q000B00BB022Q001210000C00BC023Q00BF000A000C00026Q0009000A00122Q000900BD025Q000A00083Q00122Q000B00BE022Q00122Q000C00BF025Q000A000C00026Q0009000A00122Q000900C0025Q000A00083Q00122Q000B00C1022Q00122Q000C00C2025Q000A000C00026Q0009000A00122Q000900C3025Q000A00083Q00122Q000B00C4022Q00122Q000C00C5025Q000A000C00026Q0009000A00122Q000900C6025Q000A00083Q00122Q000B00C7022Q00122Q000C00C8025Q000A000C00026Q0009000A00122Q000900C9025Q000A00083Q00122Q000B00CA022Q00122Q000C00CB025Q000A000C00026Q0009000A00122Q000900CC025Q000A00083Q00122Q000B00CD022Q00122Q000C00CE025Q000A000C00026Q0009000A00122Q000900CF025Q000A00083Q00122Q000B00D0022Q00122Q000C00D1025Q000A000C00026Q0009000A00122Q000900D2025Q000A00083Q00122Q000B00D3022Q00122Q000C00D4025Q000A000C00026Q0009000A00122Q000900D5025Q000A00083Q00122Q000B00D6022Q00122Q000C00D7025Q000A000C00026Q0009000A00122Q000900D8025Q000A00083Q00122Q000B00D9022Q00122Q000C00DA025Q000A000C00026Q0009000A00122Q000900DB025Q000A00083Q00122Q000B00DC022Q00122Q000C00DD025Q000A000C00026Q0009000A00122Q000900DE025Q000A00083Q00122Q000B00DF022Q00122Q000C00E0025Q000A000C00026Q0009000A00122Q000900E1025Q000A00083Q00122Q000B00E2022Q00122Q000C00E3025Q000A000C00026Q0009000A001210000900E4023Q00D7000A00083Q00122Q000B00E5022Q00122Q000C00E6025Q000A000C00026Q0009000A00122Q000900E7025Q000A00083Q00122Q000B00E8022Q00122Q000C00E9025Q000A000C00026Q0009000A00122Q000900EA025Q000A00083Q00122Q000B00EB022Q00122Q000C00EC025Q000A000C00026Q0009000A00122Q000900ED025Q000A00083Q00122Q000B00EE022Q00122Q000C00EF025Q000A000C00026Q0009000A00122Q000900F0025Q000A00083Q00122Q000B00F1022Q00122Q000C00F2025Q000A000C00026Q0009000A00122Q000900F3025Q000A00083Q00122Q000B00F4022Q00122Q000C00F5025Q000A000C00026Q0009000A00122Q000900F6025Q000A00083Q00122Q000B00F7022Q00122Q000C00F8025Q000A000C00026Q0009000A00122Q000900F9025Q000A00083Q00122Q000B00FA022Q00122Q000C00FB025Q000A000C00026Q0009000A00122Q000900FC025Q000A00083Q00122Q000B00FD022Q00122Q000C00FE025Q000A000C00026Q0009000A00122Q000900FF025Q000A00083Q00122Q000B2Q00032Q00122Q000C0001035Q000A000C00026Q0009000A00122Q00090002035Q000A00083Q00122Q000B002Q032Q00122Q000C0004035Q000A000C00026Q0009000A00122Q00090005035Q000A00083Q00122Q000B0006032Q00122Q000C0007035Q000A000C00026Q0009000A00122Q00090008035Q000A00083Q00122Q000B0009032Q00122Q000C000A035Q000A000C00026Q0009000A00122Q0009000B035Q000A00083Q00122Q000B000C032Q001210000C000D033Q00BF000A000C00026Q0009000A00122Q0009000E035Q000A00083Q00122Q000B000F032Q00122Q000C0010035Q000A000C00026Q0009000A00122Q00090011035Q000A00083Q00122Q000B0012032Q00122Q000C0013035Q000A000C00026Q0009000A00122Q00090014035Q000A00083Q00122Q000B0015032Q00122Q000C0016035Q000A000C00026Q0009000A00122Q00090017035Q000A00083Q00122Q000B0018032Q00122Q000C0019035Q000A000C00026Q0009000A00122Q0009001A035Q000A00083Q00122Q000B001B032Q00122Q000C001C035Q000A000C00026Q0009000A00122Q0009001D035Q000A00083Q00122Q000B001E032Q00122Q000C001F035Q000A000C00026Q0009000A00122Q00090020035Q000A00083Q00122Q000B0021032Q00122Q000C0022035Q000A000C00026Q0009000A00122Q00090023035Q000A00083Q00122Q000B0024032Q00122Q000C0025035Q000A000C00026Q0009000A00122Q00090026035Q000A00083Q00122Q000B0027032Q00122Q000C0028035Q000A000C00026Q0009000A00122Q00090029035Q000A00083Q00122Q000B002A032Q00122Q000C002B035Q000A000C00026Q0009000A00122Q0009002C035Q000A00083Q00122Q000B002D032Q00122Q000C002E035Q000A000C00026Q0009000A00122Q0009002F035Q000A00083Q00122Q000B0030032Q00122Q000C0031035Q000A000C00026Q0009000A00122Q00090032035Q000A00083Q00122Q000B0033032Q00122Q000C0034035Q000A000C00026Q0009000A00121000090035033Q00D7000A00083Q00122Q000B0036032Q00122Q000C0037035Q000A000C00026Q0009000A00122Q00090038035Q000A00083Q00122Q000B0039032Q00122Q000C003A035Q000A000C00026Q0009000A00122Q0009003B035Q000A00083Q00122Q000B003C032Q00122Q000C003D035Q000A000C00026Q0009000A00122Q0009003E035Q000A00083Q00122Q000B003F032Q00122Q000C0040035Q000A000C00026Q0009000A00122Q00090041035Q000A00083Q00122Q000B0042032Q00122Q000C0043035Q000A000C00026Q0009000A00122Q00090044035Q000A00083Q00122Q000B0045032Q00122Q000C0046035Q000A000C00026Q0009000A00122Q00090047035Q000A00083Q00122Q000B0048032Q00122Q000C0049035Q000A000C00026Q0009000A00122Q0009004A035Q000A00083Q00122Q000B004B032Q00122Q000C004C035Q000A000C00026Q0009000A00122Q0009004D035Q000A00083Q00122Q000B004E032Q00122Q000C004F035Q000A000C00026Q0009000A00122Q00090050035Q000A00083Q00122Q000B0051032Q00122Q000C0052035Q000A000C00026Q0009000A00122Q00090053035Q000A00083Q00122Q000B0054032Q00122Q000C0055035Q000A000C00026Q0009000A00122Q00090056035Q000A00083Q00122Q000B0057032Q00122Q000C0058035Q000A000C00026Q0009000A00122Q00090059035Q000A00083Q00122Q000B005A032Q00122Q000C005B035Q000A000C00026Q0009000A00122Q0009005C035Q000A00083Q00122Q000B005D032Q001210000C005E033Q00BF000A000C00026Q0009000A00122Q0009005F035Q000A00083Q00122Q000B0060032Q00122Q000C0061035Q000A000C00026Q0009000A00122Q00090062035Q000A00083Q00122Q000B0063032Q00122Q000C0064035Q000A000C00026Q0009000A00122Q00090065035Q000A00083Q00122Q000B0066032Q00122Q000C0067035Q000A000C00026Q0009000A00122Q00090068035Q000A00083Q00122Q000B0069032Q00122Q000C006A035Q000A000C00026Q0009000A00122Q0009006B035Q000A00083Q00122Q000B006C032Q00122Q000C006D035Q000A000C00026Q0009000A00122Q0009006E035Q000A00083Q00122Q000B006F032Q00122Q000C0070035Q000A000C00026Q0009000A00122Q00090071035Q000A00083Q00122Q000B0072032Q00122Q000C0073035Q000A000C00026Q0009000A00122Q00090074035Q000A00083Q00122Q000B0075032Q00122Q000C0076035Q000A000C00026Q0009000A00122Q00090077035Q000A00083Q00122Q000B0078032Q00122Q000C0079035Q000A000C00026Q0009000A00122Q0009007A035Q000A00083Q00122Q000B007B032Q00122Q000C007C035Q000A000C00026Q0009000A00122Q0009007D035Q000A00083Q00122Q000B007E032Q00122Q000C007F035Q000A000C00026Q0009000A00122Q00090080035Q000A00083Q00122Q000B0081032Q00122Q000C0082035Q000A000C00026Q0009000A00122Q00090083035Q000A00083Q00122Q000B0084032Q00122Q000C0085035Q000A000C00026Q0009000A00121000090086033Q00D7000A00083Q00122Q000B0087032Q00122Q000C0088035Q000A000C00026Q0009000A00122Q00090089035Q000A00083Q00122Q000B008A032Q00122Q000C008B035Q000A000C00026Q0009000A00122Q0009008C035Q000A00083Q00122Q000B008D032Q00122Q000C008E035Q000A000C00026Q0009000A00122Q0009008F035Q000A00083Q00122Q000B0090032Q00122Q000C0091035Q000A000C00026Q0009000A00122Q00090092035Q000A00083Q00122Q000B0093032Q00122Q000C0094035Q000A000C00026Q0009000A00122Q00090095035Q000A00083Q00122Q000B0096032Q00122Q000C0097035Q000A000C00026Q0009000A00122Q00090098035Q000A00083Q00122Q000B0099032Q00122Q000C009A035Q000A000C00026Q0009000A00122Q0009009B035Q000A00083Q00122Q000B009C032Q00122Q000C009D035Q000A000C00026Q0009000A00122Q0009009E035Q000A00083Q00122Q000B009F032Q00122Q000C00A0035Q000A000C00026Q0009000A00122Q000900A1035Q000A00083Q00122Q000B00A2032Q00122Q000C00A3035Q000A000C00026Q0009000A00122Q000900A4035Q000A00083Q00122Q000B00A5032Q00122Q000C00A6035Q000A000C00026Q0009000A00122Q000900A7035Q000A00083Q00122Q000B00A8032Q00122Q000C00A9035Q000A000C00026Q0009000A00122Q000900AA035Q000A00083Q00122Q000B00AB032Q00122Q000C00AC035Q000A000C00026Q0009000A00122Q000900AD035Q000A00083Q00122Q000B00AE032Q001210000C00AF033Q00BF000A000C00026Q0009000A00122Q000900B0035Q000A00083Q00122Q000B00B1032Q00122Q000C00B2035Q000A000C00026Q0009000A00122Q000900B3035Q000A00083Q00122Q000B00B4032Q00122Q000C00B5035Q000A000C00026Q0009000A00122Q000900B6035Q000A00083Q00122Q000B00B7032Q00122Q000C00B8035Q000A000C00026Q0009000A00122Q000900B9035Q000A00083Q00122Q000B00BA032Q00122Q000C00BB035Q000A000C00026Q0009000A00122Q000900BC035Q000A00083Q00122Q000B00BD032Q00122Q000C00BE035Q000A000C00026Q0009000A00122Q000900BF035Q000A00083Q00122Q000B00C0032Q00122Q000C00C1035Q000A000C00026Q0009000A00122Q000900C2035Q000A00083Q00122Q000B00C3032Q00122Q000C00C4035Q000A000C00026Q0009000A00122Q000900C5035Q000A00083Q00122Q000B00C6032Q00122Q000C00C7035Q000A000C00026Q0009000A00122Q000900C8035Q000A00083Q00122Q000B00C9032Q00122Q000C00CA035Q000A000C00026Q0009000A00122Q000900CB035Q000A00083Q00122Q000B00CC032Q00122Q000C00CD035Q000A000C00026Q0009000A00122Q000900CE035Q000A00083Q00122Q000B00CF032Q00122Q000C00D0035Q000A000C00026Q0009000A00122Q000900D1035Q000A00083Q00122Q000B00D2032Q00122Q000C00D3035Q000A000C00026Q0009000A00122Q000900D4035Q000A00083Q00122Q000B00D5032Q00122Q000C00D6035Q000A000C00026Q0009000A001210000900D7033Q00D7000A00083Q00122Q000B00D8032Q00122Q000C00D9035Q000A000C00026Q0009000A00122Q000900DA035Q000A00083Q00122Q000B00DB032Q00122Q000C00DC035Q000A000C00026Q0009000A00122Q000900DD035Q000A00083Q00122Q000B00DE032Q00122Q000C00DF035Q000A000C00026Q0009000A00122Q000900E0035Q000A00083Q00122Q000B00E1032Q00122Q000C00E2035Q000A000C00026Q0009000A00122Q000900E3035Q000A00083Q00122Q000B00E4032Q00122Q000C00E5035Q000A000C00026Q0009000A00122Q000900E6035Q000A00083Q00122Q000B00E7032Q00122Q000C00E8035Q000A000C00026Q0009000A00122Q000900E9035Q000A00083Q00122Q000B00EA032Q00122Q000C00EB035Q000A000C00026Q0009000A00122Q000900EC035Q000A00083Q00122Q000B00ED032Q00122Q000C00EE035Q000A000C00026Q0009000A00122Q000900EF035Q000A00083Q00122Q000B00F0032Q00122Q000C00F1035Q000A000C00026Q0009000A00122Q000900F2035Q000A00083Q00122Q000B00F3032Q00122Q000C00F4035Q000A000C00026Q0009000A00122Q000900F5035Q000A00083Q00122Q000B00F6032Q00122Q000C00F7035Q000A000C00026Q0009000A00122Q000900F8035Q000A00083Q00122Q000B00F9032Q00122Q000C00FA035Q000A000C00026Q0009000A00122Q000900FB035Q000A00083Q00122Q000B00FC032Q00122Q000C00FD035Q000A000C00026Q0009000A00122Q000900FE035Q000A00083Q00122Q000B00FF032Q001210000C2Q00043Q00BF000A000C00026Q0009000A00122Q00090001045Q000A00083Q00122Q000B0002042Q00122Q000C0003045Q000A000C00026Q0009000A00122Q0009002Q045Q000A00083Q00122Q000B0005042Q00122Q000C0006045Q000A000C00026Q0009000A00122Q00090007045Q000A00083Q00122Q000B0008042Q00122Q000C0009045Q000A000C00026Q0009000A00122Q0009000A045Q000A00083Q00122Q000B000B042Q00122Q000C000C045Q000A000C00026Q0009000A00122Q0009000D045Q000A00083Q00122Q000B000E042Q00122Q000C000F045Q000A000C00026Q0009000A00122Q00090010045Q000A00083Q00122Q000B0011042Q00122Q000C0012045Q000A000C00026Q0009000A00122Q00090013045Q000A00083Q00122Q000B0014042Q00122Q000C0015045Q000A000C00026Q0009000A00122Q00090016045Q000A00083Q00122Q000B0017042Q00122Q000C0018045Q000A000C00026Q0009000A00122Q00090019045Q000A00083Q00122Q000B001A042Q00122Q000C001B045Q000A000C00026Q0009000A00122Q0009001C045Q000A00083Q00122Q000B001D042Q00122Q000C001E045Q000A000C00026Q0009000A00122Q0009001F045Q000A00083Q00122Q000B0020042Q00122Q000C0021045Q000A000C00026Q0009000A00122Q00090022045Q000A00083Q00122Q000B0023042Q00122Q000C0024045Q000A000C00026Q0009000A00122Q00090025045Q000A00083Q00122Q000B0026042Q00122Q000C0027045Q000A000C00026Q0009000A00121000090028043Q00D7000A00083Q00122Q000B0029042Q00122Q000C002A045Q000A000C00026Q0009000A00122Q0009002B045Q000A00083Q00122Q000B002C042Q00122Q000C002D045Q000A000C00026Q0009000A00122Q0009002E045Q000A00083Q00122Q000B002F042Q00122Q000C0030045Q000A000C00026Q0009000A00122Q00090031045Q000A00083Q00122Q000B0032042Q00122Q000C0033045Q000A000C00026Q0009000A00122Q00090034045Q000A00083Q00122Q000B0035042Q00122Q000C0036045Q000A000C00026Q0009000A00122Q00090037045Q000A00083Q00122Q000B0038042Q00122Q000C0039045Q000A000C00026Q0009000A00122Q0009003A045Q000A00083Q00122Q000B003B042Q00122Q000C003C045Q000A000C00026Q0009000A00122Q0009003D045Q000A00083Q00122Q000B003E042Q00122Q000C003F045Q000A000C00026Q0009000A00122Q00090040045Q000A00083Q00122Q000B0041042Q00122Q000C0042045Q000A000C00026Q0009000A00122Q00090043045Q000A00083Q00122Q000B0044042Q00122Q000C0045045Q000A000C00026Q0009000A00122Q00090046045Q000A00083Q00122Q000B0047042Q00122Q000C0048045Q000A000C00026Q0009000A00122Q00090049045Q000A00083Q00122Q000B004A042Q00122Q000C004B045Q000A000C00026Q0009000A00122Q0009004C045Q000A00083Q00122Q000B004D042Q00122Q000C004E045Q000A000C00026Q0009000A00122Q0009004F045Q000A00083Q00122Q000B0050042Q001210000C0051043Q00BF000A000C00026Q0009000A00122Q00090052045Q000A00083Q00122Q000B0053042Q00122Q000C0054045Q000A000C00026Q0009000A00122Q00090055045Q000A00083Q00122Q000B0056042Q00122Q000C0057045Q000A000C00026Q0009000A00122Q00090058045Q000A00083Q00122Q000B0059042Q00122Q000C005A045Q000A000C00026Q0009000A00122Q0009005B045Q000A00083Q00122Q000B005C042Q00122Q000C005D045Q000A000C00026Q0009000A00122Q0009005E045Q000A00083Q00122Q000B005F042Q00122Q000C0060045Q000A000C00026Q0009000A00122Q00090061045Q000A00083Q00122Q000B0062042Q00122Q000C0063045Q000A000C00026Q0009000A00122Q00090064045Q000A00083Q00122Q000B0065042Q00122Q000C0066045Q000A000C00026Q0009000A00122Q00090067045Q000A00083Q00122Q000B0068042Q00122Q000C0069045Q000A000C00026Q0009000A00122Q0009006A045Q000A00083Q00122Q000B006B042Q00122Q000C006C045Q000A000C00026Q0009000A00122Q0009006D045Q000A00083Q00122Q000B006E042Q00122Q000C006F045Q000A000C00026Q0009000A00122Q00090070045Q000A00083Q00122Q000B0071042Q00122Q000C0072045Q000A000C00026Q0009000A00122Q00090073045Q000A00083Q00122Q000B0074042Q00122Q000C0075045Q000A000C00026Q0009000A00122Q00090076045Q000A00083Q00122Q000B0077042Q00122Q000C0078045Q000A000C00026Q0009000A00121000090079043Q00D7000A00083Q00122Q000B007A042Q00122Q000C007B045Q000A000C00026Q0009000A00122Q0009007C045Q000A00083Q00122Q000B007D042Q00122Q000C007E045Q000A000C00026Q0009000A00122Q0009007F045Q000A00083Q00122Q000B0080042Q00122Q000C0081045Q000A000C00026Q0009000A00122Q00090082045Q000A00083Q00122Q000B0083042Q00122Q000C0084045Q000A000C00026Q0009000A00122Q00090085045Q000A00083Q00122Q000B0086042Q00122Q000C0087045Q000A000C00026Q0009000A00122Q00090088045Q000A00083Q00122Q000B0089042Q00122Q000C008A045Q000A000C00026Q0009000A00122Q0009008B045Q000A00083Q00122Q000B008C042Q00122Q000C008D045Q000A000C00026Q0009000A00122Q0009008E045Q000A00083Q00122Q000B008F042Q00122Q000C0090045Q000A000C00026Q0009000A00122Q00090091045Q000A00083Q00122Q000B0092042Q00122Q000C0093045Q000A000C00026Q0009000A00122Q00090094045Q000A00083Q00122Q000B0095042Q00122Q000C0096045Q000A000C00026Q0009000A00122Q00090097045Q000A00083Q00122Q000B0098042Q00122Q000C0099045Q000A000C00026Q0009000A00122Q0009009A045Q000A00083Q00122Q000B009B042Q00122Q000C009C045Q000A000C00026Q0009000A00122Q0009009D045Q000A00083Q00122Q000B009E042Q00122Q000C009F045Q000A000C00026Q0009000A00122Q000900A0045Q000A00083Q00122Q000B00A1042Q001210000C00A2043Q00BF000A000C00026Q0009000A00122Q000900A3045Q000A00083Q00122Q000B00A4042Q00122Q000C00A5045Q000A000C00026Q0009000A00122Q000900A6045Q000A00083Q00122Q000B00A7042Q00122Q000C00A8045Q000A000C00026Q0009000A00122Q000900A9045Q000A00083Q00122Q000B00AA042Q00122Q000C00AB045Q000A000C00026Q0009000A00122Q000900AC045Q000A00083Q00122Q000B00AD042Q00122Q000C00AE045Q000A000C00026Q0009000A00122Q000900AF045Q000A00083Q00122Q000B00B0042Q00122Q000C00B1045Q000A000C00026Q0009000A00122Q000900B2045Q000A00083Q00122Q000B00B3042Q00122Q000C00B4045Q000A000C00026Q0009000A00122Q000900B5045Q000A00083Q00122Q000B00B6042Q00122Q000C00B7045Q000A000C00026Q0009000A00122Q000900B8045Q000A00083Q00122Q000B00B9042Q00122Q000C00BA045Q000A000C00026Q0009000A00122Q000900BB045Q000A00083Q00122Q000B00BC042Q00122Q000C00BD045Q000A000C00026Q0009000A00122Q000900BE045Q000A00083Q00122Q000B00BF042Q00122Q000C00C0045Q000A000C00026Q0009000A00122Q000900C1045Q000A00083Q00122Q000B00C2042Q00122Q000C00C3045Q000A000C00026Q0009000A00122Q000900C4045Q000A00083Q00122Q000B00C5042Q00122Q000C00C6045Q000A000C00026Q0009000A00122Q000900C7045Q000A00083Q00122Q000B00C8042Q00122Q000C00C9045Q000A000C00026Q0009000A001210000900CA043Q00D7000A00083Q00122Q000B00CB042Q00122Q000C00CC045Q000A000C00026Q0009000A00122Q000900CD045Q000A00083Q00122Q000B00CE042Q00122Q000C00CF045Q000A000C00026Q0009000A00122Q000900D0045Q000A00083Q00122Q000B00D1042Q00122Q000C00D2045Q000A000C00026Q0009000A00122Q000900D3045Q000A00083Q00122Q000B00D4042Q00122Q000C00D5045Q000A000C00026Q0009000A00122Q000900D6045Q000A00083Q00122Q000B00D7042Q00122Q000C00D8045Q000A000C00026Q0009000A00122Q000900D9045Q000A00083Q00122Q000B00DA042Q00122Q000C00DB045Q000A000C00026Q0009000A00122Q000900DC045Q000A00083Q00122Q000B00DD042Q00122Q000C00DE045Q000A000C00026Q0009000A00122Q000900DF045Q000A00083Q00122Q000B00E0042Q00122Q000C00E1045Q000A000C00026Q0009000A00122Q000900E2045Q000A00083Q00122Q000B00E3042Q00122Q000C00E4045Q000A000C00026Q0009000A00122Q000900E5045Q000A00083Q00122Q000B00E6042Q00122Q000C00E7045Q000A000C00026Q0009000A00122Q000900E8045Q000A00083Q00122Q000B00E9042Q00122Q000C00EA045Q000A000C00026Q0009000A00122Q000900EB045Q000A00083Q00122Q000B00EC042Q00122Q000C00ED045Q000A000C00026Q0009000A00122Q000900EE045Q000A00083Q00122Q000B00EF042Q00122Q000C00F0045Q000A000C00026Q0009000A00122Q000900F1045Q000A00083Q00122Q000B00F2042Q001210000C00F3043Q00BF000A000C00026Q0009000A00122Q000900F4045Q000A00083Q00122Q000B00F5042Q00122Q000C00F6045Q000A000C00026Q0009000A00122Q000900F7045Q000A00083Q00122Q000B00F8042Q00122Q000C00F9045Q000A000C00026Q0009000A00122Q000900FA045Q000A00083Q00122Q000B00FB042Q00122Q000C00FC045Q000A000C00026Q0009000A00122Q000900FD045Q000A00083Q00122Q000B00FE042Q00122Q000C00FF045Q000A000C00026Q0009000A00122Q00092Q00055Q000A00083Q00122Q000B0001052Q00122Q000C0002055Q000A000C00026Q0009000A00122Q00090003055Q000A00083Q00122Q000B0004052Q00122Q000C002Q055Q000A000C00026Q0009000A00122Q00090006055Q000A00083Q00122Q000B0007052Q00122Q000C0008055Q000A000C00026Q0009000A00122Q00090009055Q000A00083Q00122Q000B000A052Q00122Q000C000B055Q000A000C00026Q0009000A00122Q0009000C055Q000A00083Q00122Q000B000D052Q00122Q000C000E055Q000A000C00026Q0009000A00122Q0009000F055Q000A00083Q00122Q000B0010052Q00122Q000C0011055Q000A000C00026Q0009000A00122Q00090012055Q000A00083Q00122Q000B0013052Q00122Q000C0014055Q000A000C00026Q0009000A00122Q00090015055Q000A00083Q00122Q000B0016052Q00122Q000C0017055Q000A000C00026Q0009000A00122Q00090018055Q000A00083Q00122Q000B0019052Q00122Q000C001A055Q000A000C00026Q0009000A0012100009001B053Q00D7000A00083Q00122Q000B001C052Q00122Q000C001D055Q000A000C00026Q0009000A00122Q0009001E055Q000A00083Q00122Q000B001F052Q00122Q000C0020055Q000A000C00026Q0009000A00122Q00090021055Q000A00083Q00122Q000B0022052Q00122Q000C0023055Q000A000C00026Q0009000A00122Q00090024055Q000A00083Q00122Q000B0025052Q00122Q000C0026055Q000A000C00026Q0009000A00122Q00090027055Q000A00083Q00122Q000B0028052Q00122Q000C0029055Q000A000C00026Q0009000A00122Q0009002A055Q000A00083Q00122Q000B002B052Q00122Q000C002C055Q000A000C00026Q0009000A00122Q0009002D055Q000A00083Q00122Q000B002E052Q00122Q000C002F055Q000A000C00026Q0009000A00122Q00090030055Q000A00083Q00122Q000B0031052Q00122Q000C0032055Q000A000C00026Q0009000A00122Q00090033055Q000A00083Q00122Q000B0034052Q00122Q000C0035055Q000A000C00026Q0009000A00122Q00090036055Q000A00083Q00122Q000B0037052Q00122Q000C0038055Q000A000C00026Q0009000A00122Q00090039055Q000A00083Q00122Q000B003A052Q00122Q000C003B055Q000A000C00026Q0009000A00122Q0009003C055Q000A00083Q00122Q000B003D052Q00122Q000C003E055Q000A000C00026Q0009000A00122Q0009003F055Q000A00083Q00122Q000B0040052Q00122Q000C0041055Q000A000C00026Q0009000A00122Q00090042055Q000A00083Q00122Q000B0043052Q001210000C0044053Q00BF000A000C00026Q0009000A00122Q00090045055Q000A00083Q00122Q000B0046052Q00122Q000C0047055Q000A000C00026Q0009000A00122Q00090048055Q000A00083Q00122Q000B0049052Q00122Q000C004A055Q000A000C00026Q0009000A00122Q0009004B055Q000A00083Q00122Q000B004C052Q00122Q000C004D055Q000A000C00026Q0009000A00122Q0009004E055Q000A00083Q00122Q000B004F052Q00122Q000C0050055Q000A000C00026Q0009000A00122Q00090051055Q000A00083Q00122Q000B0052052Q00122Q000C0053055Q000A000C00026Q0009000A00122Q00090054055Q000A00083Q00122Q000B0055052Q00122Q000C0056055Q000A000C00026Q0009000A00122Q00090057055Q000A00083Q00122Q000B0058052Q00122Q000C0059055Q000A000C00026Q0009000A00122Q0009005A055Q000A00083Q00122Q000B005B052Q00122Q000C005C055Q000A000C00026Q0009000A00122Q0009005D055Q000A00083Q00122Q000B005E052Q00122Q000C005F055Q000A000C00026Q0009000A00122Q00090060055Q000A00083Q00122Q000B0061052Q00122Q000C0062055Q000A000C00026Q0009000A00122Q00090063055Q000A00083Q00122Q000B0064052Q00122Q000C0065055Q000A000C00026Q0009000A00122Q00090066055Q000A00083Q00122Q000B0067052Q00122Q000C0068055Q000A000C00026Q0009000A00122Q00090069055Q000A00083Q00122Q000B006A052Q00122Q000C006B055Q000A000C00026Q0009000A0012100009006C053Q00D7000A00083Q00122Q000B006D052Q00122Q000C006E055Q000A000C00026Q0009000A00122Q0009006F055Q000A00083Q00122Q000B0070052Q00122Q000C0071055Q000A000C00026Q0009000A00122Q00090072055Q000A00083Q00122Q000B0073052Q00122Q000C0074055Q000A000C00026Q0009000A00122Q00090075055Q000A00083Q00122Q000B0076052Q00122Q000C0077055Q000A000C00026Q0009000A00122Q00090078055Q000A00083Q00122Q000B0079052Q00122Q000C007A055Q000A000C00026Q0009000A00122Q0009007B055Q000A00083Q00122Q000B007C052Q00122Q000C007D055Q000A000C00026Q0009000A00122Q0009007E055Q000A00083Q00122Q000B007F052Q00122Q000C0080055Q000A000C00026Q0009000A00122Q00090081055Q000A00083Q00122Q000B0082052Q00122Q000C0083055Q000A000C00026Q0009000A00122Q00090084055Q000A00083Q00122Q000B0085052Q00122Q000C0086055Q000A000C00026Q0009000A00122Q00090087055Q000A00083Q00122Q000B0088052Q00122Q000C0089055Q000A000C00026Q0009000A00122Q0009008A055Q000A00083Q00122Q000B008B052Q00122Q000C008C055Q000A000C00026Q0009000A00122Q0009008D055Q000A00083Q00122Q000B008E052Q00122Q000C008F055Q000A000C00026Q0009000A00122Q00090090055Q000A00083Q00122Q000B0091052Q00122Q000C0092055Q000A000C00026Q0009000A00122Q00090093055Q000A00083Q00122Q000B0094052Q001210000C0095053Q00BF000A000C00026Q0009000A00122Q00090096055Q000A00083Q00122Q000B0097052Q00122Q000C0098055Q000A000C00026Q0009000A00122Q00090099055Q000A00083Q00122Q000B009A052Q00122Q000C009B055Q000A000C00026Q0009000A00122Q0009009C055Q000A00083Q00122Q000B009D052Q00122Q000C009E055Q000A000C00026Q0009000A00122Q0009009F055Q000A00083Q00122Q000B00A0052Q00122Q000C00A1055Q000A000C00026Q0009000A00122Q000900A2055Q000A00083Q00122Q000B00A3052Q00122Q000C00A4055Q000A000C00026Q0009000A00122Q000900A5055Q000A00083Q00122Q000B00A6052Q00122Q000C00A7055Q000A000C00026Q0009000A00122Q000900A8055Q000A00083Q00122Q000B00A9052Q00122Q000C00AA055Q000A000C00026Q0009000A00122Q000900AB055Q000A00083Q00122Q000B00AC052Q00122Q000C00AD055Q000A000C00026Q0009000A00122Q000900AE055Q000A00083Q00122Q000B00AF052Q00122Q000C00B0055Q000A000C00026Q0009000A00122Q000900B1055Q000A00083Q00122Q000B00B2052Q00122Q000C00B3055Q000A000C00026Q0009000A00122Q000900B4055Q000A00083Q00122Q000B00B5052Q00122Q000C00B6055Q000A000C00026Q0009000A00122Q000900B7055Q000A00083Q00122Q000B00B8052Q00122Q000C00B9055Q000A000C00026Q0009000A00122Q000900BA055Q000A00083Q00122Q000B00BB052Q00122Q000C00BC055Q000A000C00026Q0009000A001210000900BD053Q0052000A00083Q001210000B00BE052Q001210000C00BF053Q0033000A000C00022Q00D23Q0009000A001210000900C0053Q0052000A00083Q001210000B00C1052Q001210000C00C2053Q0033000A000C00022Q00853Q0009000A00122Q000900C3055Q000A00083Q00122Q000B00C4052Q00122Q000C00C5055Q000A000C00026Q0009000A00122Q000900C3055Q000A000A3Q001210000B00C3052Q0006870009003D0B01000B00044F3Q003D0B01001210000B00C3052Q001210000C00C3052Q000687000B00410B01000C00044F3Q00410B012Q00B8000C3Q002300127B000D00C3055Q000D3Q000D4Q000E3Q000200122Q000F00C0055Q000F3Q000F4Q00103Q000500122Q001100BD055Q00113Q00114Q001200013Q00122Q001300BA053Q005900133Q00132Q008C0012000100012Q00D200100011001200125D001100B7055Q00113Q00114Q001200013Q00122Q001300B4055Q00133Q00134Q0012000100012Q00D200100011001200125D001100B1055Q00113Q00114Q001200013Q00122Q001300AE055Q00133Q00134Q0012000100012Q00D200100011001200125D001100AB055Q00113Q00114Q001200013Q00122Q001300A8055Q00133Q00134Q0012000100012Q00D200100011001200125D001100A5055Q00113Q00114Q001200013Q00122Q001300A2055Q00133Q00134Q0012000100012Q00D20010001100122Q0094000E000F001000122Q000F009F055Q000F3Q000F00122Q0010009C055Q00103Q00104Q000E000F00104Q000C000D000E00122Q000D0099055Q000D3Q000D4Q000E3Q0002001210000F0096053Q0020000F3Q000F4Q00103Q000200122Q00110093055Q00113Q00114Q001200013Q00122Q00130090055Q00133Q00134Q0012000100012Q00D200100011001200125D0011008D055Q00113Q00114Q001200013Q00122Q0013008A055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0087055Q000F3Q000F00122Q001000C6055Q000E000F00104Q000C000D000E00122Q000D0084055Q000D3Q000D4Q000E3Q000200122Q000F0081053Q0020000F3Q000F4Q00103Q000100122Q0011007E055Q00113Q00114Q001200013Q00122Q0013007B055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0078055Q000F3Q000F00122Q001000C6055Q000E000F00104Q000C000D000E00122Q000D0075055Q000D3Q000D4Q000E3Q000200122Q000F0072053Q0020000F3Q000F4Q00103Q000300122Q0011006F055Q00113Q00114Q001200013Q00122Q0013006C055Q00133Q00134Q0012000100012Q00D200100011001200125D00110069055Q00113Q00114Q001200013Q00122Q00130066055Q00133Q00134Q0012000100012Q00D200100011001200125D00110063055Q00113Q00114Q001200013Q00122Q00130060055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F005D055Q000F3Q000F00122Q001000C6055Q000E000F00104Q000C000D000E00122Q000D005A055Q000D3Q000D4Q000E3Q000200122Q000F0057053Q0020000F3Q000F4Q00103Q000100122Q00110054055Q00113Q00114Q001200013Q00122Q00130051055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F004E055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D004B055Q000D3Q000D4Q000E3Q000200122Q000F0048053Q0020000F3Q000F4Q00103Q000200122Q00110045055Q00113Q00114Q001200013Q00122Q00130042055Q00133Q00134Q0012000100012Q00D200100011001200125D0011003F055Q00113Q00114Q001200013Q00122Q0013003C055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0039055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0036055Q000D3Q000D4Q000E3Q000200122Q000F0033053Q0020000F3Q000F4Q00103Q000100122Q00110030055Q00113Q00114Q001200013Q00122Q0013002D055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F002A055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0027055Q000D3Q000D4Q000E3Q000200122Q000F0024053Q0020000F3Q000F4Q00103Q000100122Q00110021055Q00113Q00114Q001200013Q00122Q0013001E055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F001B055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0018055Q000D3Q000D4Q000E3Q000200122Q000F0015053Q0020000F3Q000F4Q00103Q000100122Q00110012055Q00113Q00114Q001200013Q00122Q0013000F055Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F000C055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0009055Q000D3Q000D4Q000E3Q000200122Q000F0006053Q0020000F3Q000F4Q00103Q000400122Q00110003055Q00113Q00114Q001200013Q00122Q00132Q00055Q00133Q00134Q0012000100012Q00D200100011001200125D001100FD045Q00113Q00114Q001200013Q00122Q001300FA045Q00133Q00134Q0012000100012Q00D200100011001200125D001100F7045Q00113Q00114Q001200013Q00122Q001300F4045Q00133Q00134Q0012000100012Q00D200100011001200125D001100F1045Q00113Q00114Q001200013Q00122Q001300EE045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00EB045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00E8045Q000D3Q000D4Q000E3Q000200122Q000F00E5043Q0020000F3Q000F4Q00103Q000100122Q001100E2045Q00113Q00114Q001200013Q00122Q001300DF045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00DC045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00D9045Q000D3Q000D4Q000E3Q000200122Q000F00D6043Q0020000F3Q000F4Q00103Q000200122Q001100D3045Q00113Q00114Q001200013Q00122Q001300D0045Q00133Q00134Q0012000100012Q00D200100011001200125D001100CD045Q00113Q00114Q001200013Q00122Q001300CA045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00C7045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00C4045Q000D3Q000D4Q000E3Q000200122Q000F00C1043Q0020000F3Q000F4Q00103Q000100122Q001100BE045Q00113Q00114Q001200013Q00122Q001300BB045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00B8045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00B5045Q000D3Q000D4Q000E3Q000200122Q000F00B2043Q0020000F3Q000F4Q00103Q000200122Q001100AF045Q00113Q00114Q001200013Q00122Q001300AC045Q00133Q00134Q0012000100012Q00D200100011001200125D001100A9045Q00113Q00114Q001200013Q00122Q001300A6045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00A3045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00A0045Q000D3Q000D4Q000E3Q000200122Q000F009D043Q0020000F3Q000F4Q00103Q000200122Q0011009A045Q00113Q00114Q001200013Q00122Q00130097045Q00133Q00134Q0012000100012Q00D200100011001200125D00110094045Q00113Q00114Q001200013Q00122Q00130091045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F008E045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D008B045Q000D3Q000D4Q000E3Q000200122Q000F0088043Q0020000F3Q000F4Q00103Q000100122Q00110085045Q00113Q00114Q001200013Q00122Q00130082045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F007F045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D007C045Q000D3Q000D4Q000E3Q000200122Q000F0079043Q0020000F3Q000F4Q00103Q000200122Q00110076045Q00113Q00114Q001200013Q00122Q00130073045Q00133Q00134Q0012000100012Q00D200100011001200125D00110070045Q00113Q00114Q001200013Q00122Q0013006D045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F006A045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0067045Q000D3Q000D4Q000E3Q000200122Q000F0064043Q0020000F3Q000F4Q00103Q000100122Q00110061045Q00113Q00114Q001200013Q00122Q0013005E045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F005B045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0058045Q000D3Q000D4Q000E3Q000200122Q000F0055043Q0020000F3Q000F4Q00103Q000100122Q00110052045Q00113Q00114Q001200013Q00122Q0013004F045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F004C045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0049045Q000D3Q000D4Q000E3Q000200122Q000F0046043Q0020000F3Q000F4Q00103Q000100122Q00110043045Q00113Q00114Q001200013Q00122Q00130040045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F003D045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003A045Q000D3Q000D4Q000E3Q000200122Q000F0037043Q0020000F3Q000F4Q00103Q000100122Q00110034045Q00113Q00114Q001200013Q00122Q00130031045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F002E045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002B045Q000D3Q000D4Q000E3Q000200122Q000F0028043Q0020000F3Q000F4Q00103Q000100122Q00110025045Q00113Q00114Q001200013Q00122Q00130022045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F001F045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D001C045Q000D3Q000D4Q000E3Q000200122Q000F0019043Q0020000F3Q000F4Q00103Q000100122Q00110016045Q00113Q00114Q001200013Q00122Q00130013045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0010045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D000D045Q000D3Q000D4Q000E3Q000200122Q000F000A043Q0020000F3Q000F4Q00103Q000100122Q00110007045Q00113Q00114Q001200013Q00122Q0013002Q045Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0001045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00FE035Q000D3Q000D4Q000E3Q000200122Q000F00FB033Q0020000F3Q000F4Q00103Q000100122Q001100F8035Q00113Q00114Q001200013Q00122Q001300F5035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00F2035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00EF035Q000D3Q000D4Q000E3Q000200122Q000F00EC033Q0020000F3Q000F4Q00103Q000300122Q001100E9035Q00113Q00114Q001200013Q00122Q001300E6035Q00133Q00134Q0012000100012Q00D200100011001200125D001100E3035Q00113Q00114Q001200013Q00122Q001300E0035Q00133Q00134Q0012000100012Q00D200100011001200125D001100DD035Q00113Q00114Q001200013Q00122Q001300DA035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00D7035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00D4035Q000D3Q000D4Q000E3Q000200122Q000F00D1033Q0020000F3Q000F4Q00103Q000100122Q001100CE035Q00113Q00114Q001200013Q00122Q001300CB035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00C8035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00C5035Q000D3Q000D4Q000E3Q000200122Q000F00C2033Q0020000F3Q000F4Q00103Q000200122Q001100BF035Q00113Q00114Q001200013Q00122Q001300BC035Q00133Q00134Q0012000100012Q00D200100011001200125D001100B9035Q00113Q00114Q001200013Q00122Q001300B6035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00B3035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00B0035Q000D3Q000D4Q000E3Q000200122Q000F00AD033Q0020000F3Q000F4Q00103Q000200122Q001100AA035Q00113Q00114Q001200013Q00122Q001300A7035Q00133Q00134Q0012000100012Q00D200100011001200125D001100A4035Q00113Q00114Q001200013Q00122Q001300A1035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F009E035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D009B035Q000D3Q000D4Q000E3Q000200122Q000F0098033Q0020000F3Q000F4Q00103Q000100122Q00110095035Q00113Q00114Q001200013Q00122Q00130092035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F008F035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D008C035Q000D3Q000D4Q000E3Q000200122Q000F0089033Q0020000F3Q000F4Q00103Q000100122Q00110086035Q00113Q00114Q001200013Q00122Q00130083035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0080035Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D007D035Q000D3Q000D4Q000E3Q000200122Q000F007A033Q0020000F3Q000F4Q00103Q000100122Q00110077035Q00113Q00114Q001200013Q00122Q00130074035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0071035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D006E035Q000D3Q000D4Q000E3Q000200122Q000F006B033Q0020000F3Q000F4Q00103Q000100122Q00110068035Q00113Q00114Q001200013Q00122Q00130065035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0062035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D005F035Q000D3Q000D4Q000E3Q000200122Q000F005C033Q0020000F3Q000F4Q00103Q000100122Q00110059035Q00113Q00114Q001200013Q00122Q00130056035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0053035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0050035Q000D3Q000D4Q000E3Q000200122Q000F004D033Q0020000F3Q000F4Q00103Q000200122Q0011004A035Q00113Q00114Q001200013Q00122Q00130047035Q00133Q00134Q0012000100012Q00D200100011001200125D00110044035Q00113Q00114Q001200013Q00122Q00130041035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F003E035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003B035Q000D3Q000D4Q000E3Q000200122Q000F0038033Q0020000F3Q000F4Q00103Q000100122Q00110035035Q00113Q00114Q001200013Q00122Q00130032035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F002F035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002C035Q000D3Q000D4Q000E3Q000200122Q000F0029033Q0020000F3Q000F4Q00103Q000100122Q00110026035Q00113Q00114Q001200013Q00122Q00130023035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0020035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D001D035Q000D3Q000D4Q000E3Q000200122Q000F001A033Q0020000F3Q000F4Q00103Q000100122Q00110017035Q00113Q00114Q001200013Q00122Q00130014035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0011035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D000E035Q000D3Q000D4Q000E3Q000200122Q000F000B033Q0020000F3Q000F4Q00103Q000100122Q00110008035Q00113Q00114Q001200013Q00122Q00130005035Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0002035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00FF025Q000D3Q000D4Q000E3Q000200122Q000F00FC023Q0020000F3Q000F4Q00103Q000100122Q001100F9025Q00113Q00114Q001200013Q00122Q001300F6025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00F3025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00F0025Q000D3Q000D4Q000E3Q000200122Q000F00ED023Q0020000F3Q000F4Q00103Q000300122Q001100EA025Q00113Q00114Q001200013Q00122Q001300E7025Q00133Q00134Q0012000100012Q00D200100011001200125D001100E4025Q00113Q00114Q001200013Q00122Q001300E1025Q00133Q00134Q0012000100012Q00D200100011001200125D001100DE025Q00113Q00114Q001200013Q00122Q001300DB025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00D8025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00D5025Q000D3Q000D4Q000E3Q000200122Q000F00D2023Q0020000F3Q000F4Q00103Q000300122Q001100CF025Q00113Q00114Q001200013Q00122Q001300CC025Q00133Q00134Q0012000100012Q00D200100011001200125D001100C9025Q00113Q00114Q001200013Q00122Q001300C6025Q00133Q00134Q0012000100012Q00D200100011001200125D001100C3025Q00113Q00114Q001200013Q00122Q001300C0025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00BD025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00BA025Q000D3Q000D4Q000E3Q000200122Q000F00B7023Q0020000F3Q000F4Q00103Q000100122Q001100B4025Q00113Q00114Q001200013Q00122Q001300B1025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00AE025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00AB025Q000D3Q000D4Q000E3Q000200122Q000F00A8023Q0020000F3Q000F4Q00103Q000200122Q001100A5025Q00113Q00114Q001200013Q00122Q001300A2025Q00133Q00134Q0012000100012Q00D200100011001200125D0011009F025Q00113Q00114Q001200013Q00122Q0013009C025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0099025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0096025Q000D3Q000D4Q000E3Q000200122Q000F0093023Q0020000F3Q000F4Q00103Q000200122Q00110090025Q00113Q00114Q001200013Q00122Q0013008D025Q00133Q00134Q0012000100012Q00D200100011001200125D0011008A025Q00113Q00114Q001200013Q00122Q00130087025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0084025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0081025Q000D3Q000D4Q000E3Q000200122Q000F007E023Q0020000F3Q000F4Q00103Q000100122Q0011007B025Q00113Q00114Q001200013Q00122Q00130078025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0075025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0072025Q000D3Q000D4Q000E3Q000200122Q000F006F023Q0020000F3Q000F4Q00103Q000200122Q0011006C025Q00113Q00114Q001200013Q00122Q00130069025Q00133Q00134Q0012000100012Q00D200100011001200125D00110066025Q00113Q00114Q001200013Q00122Q00130063025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0060025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D005D025Q000D3Q000D4Q000E3Q000200122Q000F005A023Q0020000F3Q000F4Q00103Q000100122Q00110057025Q00113Q00114Q001200013Q00122Q00130054025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0051025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D004E025Q000D3Q000D4Q000E3Q000200122Q000F004B023Q0020000F3Q000F4Q00103Q000100122Q00110048025Q00113Q00114Q001200013Q00122Q00130045025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0042025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003F025Q000D3Q000D4Q000E3Q000200122Q000F003C023Q0020000F3Q000F4Q00103Q000100122Q00110039025Q00113Q00114Q001200013Q00122Q00130036025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0033025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0030025Q000D3Q000D4Q000E3Q000200122Q000F002D023Q0020000F3Q000F4Q00103Q000100122Q0011002A025Q00113Q00114Q001200013Q00122Q00130027025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0024025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0021025Q000D3Q000D4Q000E3Q000200122Q000F001E023Q0020000F3Q000F4Q00103Q000100122Q0011001B025Q00113Q00114Q001200013Q00122Q00130018025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0015025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0012025Q000D3Q000D4Q000E3Q000200122Q000F000F023Q0020000F3Q000F4Q00103Q000100122Q0011000C025Q00113Q00114Q001200013Q00122Q00130009025Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0006025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0003025Q000D3Q000D4Q000E3Q000200122Q000F2Q00023Q0020000F3Q000F4Q00103Q000100122Q001100FD015Q00113Q00114Q001200013Q00122Q001300FA015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00F7015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00F4015Q000D3Q000D4Q000E3Q000200122Q000F00F1013Q0020000F3Q000F4Q00103Q000100122Q001100EE015Q00113Q00114Q001200013Q00122Q001300EB015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00E8015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00E5015Q000D3Q000D4Q000E3Q000200122Q000F00E2013Q0020000F3Q000F4Q00103Q000100122Q001100DF015Q00113Q00114Q001200013Q00122Q001300DC015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00D9015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00D6015Q000D3Q000D4Q000E3Q000200122Q000F00D3013Q0020000F3Q000F4Q00103Q000200122Q001100D0015Q00113Q00114Q001200013Q00122Q001300CD015Q00133Q00134Q0012000100012Q00D200100011001200125D001100CA015Q00113Q00114Q001200013Q00122Q001300C7015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00C4015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00C1015Q000D3Q000D4Q000E3Q000200122Q000F00BE013Q0020000F3Q000F4Q00103Q000100122Q001100BB015Q00113Q00114Q001200013Q00122Q001300B8015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00B5015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00B2015Q000D3Q000D4Q000E3Q000200122Q000F00AF013Q0020000F3Q000F4Q00103Q000100122Q001100AC015Q00113Q00114Q001200013Q00122Q001300A9015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00A6015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00A3015Q000D3Q000D4Q000E3Q000200122Q000F00A0013Q0020000F3Q000F4Q00103Q000200122Q0011009D015Q00113Q00114Q001200013Q00122Q0013009A015Q00133Q00134Q0012000100012Q00D200100011001200125D00110097015Q00113Q00114Q001200013Q00122Q00130094015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0091015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D008E015Q000D3Q000D4Q000E3Q000200122Q000F008B013Q0020000F3Q000F4Q00103Q000100122Q00110088015Q00113Q00114Q001200013Q00122Q00130085015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0082015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D007F015Q000D3Q000D4Q000E3Q000200122Q000F007C013Q0020000F3Q000F4Q00103Q000100122Q00110079015Q00113Q00114Q001200013Q00122Q00130076015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0073015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0070015Q000D3Q000D4Q000E3Q000200122Q000F006D013Q0020000F3Q000F4Q00103Q000100122Q0011006A015Q00113Q00114Q001200013Q00122Q00130067015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0064015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0061015Q000D3Q000D4Q000E3Q000200122Q000F005E013Q0020000F3Q000F4Q00103Q000300122Q0011005B015Q00113Q00114Q001200013Q00122Q00130058015Q00133Q00134Q0012000100012Q00D200100011001200125D00110055015Q00113Q00114Q001200013Q00122Q00130052015Q00133Q00134Q0012000100012Q00D200100011001200125D0011004F015Q00113Q00114Q001200013Q00122Q0013004C015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0049015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0046015Q000D3Q000D4Q000E3Q000200122Q000F0043013Q0020000F3Q000F4Q00103Q000100122Q00110040015Q00113Q00114Q001200013Q00122Q0013003D015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F003A015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0037015Q000D3Q000D4Q000E3Q000200122Q000F0034013Q0020000F3Q000F4Q00103Q000500122Q00110031015Q00113Q00114Q001200013Q00122Q0013002E015Q00133Q00134Q0012000100012Q00D200100011001200125D0011002B015Q00113Q00114Q001200013Q00122Q00130028015Q00133Q00134Q0012000100012Q00D200100011001200125D00110025015Q00113Q00114Q001200013Q00122Q00130022015Q00133Q00134Q0012000100012Q00D200100011001200125D0011001F015Q00113Q00114Q001200013Q00122Q0013001C015Q00133Q00134Q0012000100012Q00D200100011001200125D00110019015Q00113Q00114Q001200013Q00122Q00130016015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0013015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0010015Q000D3Q000D4Q000E3Q000200122Q000F000D013Q0020000F3Q000F4Q00103Q000100122Q0011000A015Q00113Q00114Q001200013Q00122Q00130007015Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F0004015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002Q015Q000D3Q000D4Q000E3Q000200122Q000F00FE4Q0020000F3Q000F4Q00103Q000100122Q001100FB6Q00113Q00114Q001200013Q00122Q001300F86Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00F56Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00F26Q000D3Q000D4Q000E3Q000200122Q000F00EF4Q0020000F3Q000F4Q00103Q000100122Q001100EC6Q00113Q00114Q001200013Q00122Q001300E96Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00E66Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00E36Q000D3Q000D4Q000E3Q000200122Q000F00E04Q0020000F3Q000F4Q00103Q000200122Q001100DD6Q00113Q00114Q001200013Q00122Q001300DA6Q00133Q00134Q0012000100012Q00D200100011001200125D001100D76Q00113Q00114Q001200013Q00122Q001300D46Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00D16Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00CE6Q000D3Q000D4Q000E3Q000200122Q000F00CB4Q0020000F3Q000F4Q00103Q000100122Q001100C86Q00113Q00114Q001200013Q00122Q001300C56Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00C26Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00BF6Q000D3Q000D4Q000E3Q000200122Q000F00BC4Q0020000F3Q000F4Q00103Q000200122Q001100B96Q00113Q00114Q001200013Q00122Q001300B66Q00133Q00134Q0012000100012Q00D200100011001200125D001100B36Q00113Q00114Q001200013Q00122Q001300B06Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00AD6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00AA6Q000D3Q000D4Q000E3Q000200122Q000F00A74Q0020000F3Q000F4Q00103Q000100122Q001100A46Q00113Q00114Q001200013Q00122Q001300A16Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F009E6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D009B6Q000D3Q000D4Q000E3Q000200122Q000F00984Q0020000F3Q000F4Q00103Q000100122Q001100956Q00113Q00114Q001200013Q00122Q001300926Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F008F6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D008C6Q000D3Q000D4Q000E3Q000200122Q000F00894Q0020000F3Q000F4Q00103Q000100122Q001100866Q00113Q00114Q001200013Q00122Q001300836Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00806Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D007D6Q000D3Q000D4Q000E3Q000200122Q000F007A4Q0020000F3Q000F4Q00103Q000100122Q001100776Q00113Q00114Q001200013Q00122Q001300746Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00716Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D006E6Q000D3Q000D4Q000E3Q000200122Q000F006B4Q0020000F3Q000F4Q00103Q000100122Q001100686Q00113Q00114Q001200013Q00122Q001300656Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00626Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D005F6Q000D3Q000D4Q000E3Q000200122Q000F005C4Q0020000F3Q000F4Q00103Q000100122Q001100596Q00113Q00114Q001200013Q00122Q001300566Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00536Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00506Q000D3Q000D4Q000E3Q000200122Q000F004D4Q0020000F3Q000F4Q00103Q000200122Q0011004A6Q00113Q00114Q001200013Q00122Q001300476Q00133Q00134Q0012000100012Q00D200100011001200125D001100446Q00113Q00114Q001200013Q00122Q001300416Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F003E6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003B6Q000D3Q000D4Q000E3Q000200122Q000F00384Q0020000F3Q000F4Q00103Q000100122Q001100356Q00113Q00114Q001200013Q00122Q001300326Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F002F6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002C6Q000D3Q000D4Q000E3Q000200122Q000F00294Q0020000F3Q000F4Q00103Q000100122Q001100266Q00113Q00114Q001200013Q00122Q001300236Q00133Q00134Q0012000100012Q00D20010001100122Q004D000E000F001000122Q000F00206Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D001D6Q000D3Q000D4Q000E3Q000200122Q000F001A4Q0020000F3Q000F4Q00103Q000200122Q001100176Q00113Q00114Q001200013Q00122Q001300146Q00133Q00134Q0012000100012Q00D200100011001200125D001100116Q00113Q00114Q001200013Q00122Q0013000E6Q00133Q00134Q0012000100012Q00D20010001100122Q00BA000E000F001000122Q000F000B6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E4Q000A000C6Q000A00023Q00044Q00410B0100044F3Q003D0B012Q00603Q00013Q00013Q00023Q00026Q00F03F026Q00704002264Q002500025Q00122Q000300016Q00045Q00122Q000500013Q00042Q0003002100012Q00D000076Q0042000800026Q000900016Q000A00026Q000B00036Q000C00046Q000D8Q000E00063Q00202Q000F000600014Q000C000F6Q000B3Q00024Q000C00036Q000D00046Q000E00016Q000F00016Q000F0006000F00102Q000F0001000F4Q001000016Q00100006001000102Q00100001001000202Q0010001000014Q000D00106Q000C8Q000A3Q000200202Q000A000A00024Q0009000A6Q00073Q00010004370003000500012Q00D0000300054Q0052000400024Q0021000300044Q00A300036Q00603Q00017Q00", GetFEnv(), ...);
