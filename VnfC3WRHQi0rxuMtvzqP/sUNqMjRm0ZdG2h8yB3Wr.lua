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
			local FlatIdent_95CAC = 0;
			while true do
				if (FlatIdent_95CAC == 0) then
					repeatNext = StrToNumber(Sub(byte, 1, 1));
					return "";
				end
			end
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local b = Rep(a, repeatNext);
				repeatNext = nil;
				return b;
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local FlatIdent_76979 = 0;
			local Res;
			while true do
				if (FlatIdent_76979 == 0) then
					Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
					return Res - (Res % 1);
				end
			end
		else
			local FlatIdent_69270 = 0;
			local Plc;
			while true do
				if (FlatIdent_69270 == 0) then
					Plc = 2 ^ (Start - 1);
					return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
				end
			end
		end
	end
	local function gBits8()
		local FlatIdent_6D4CB = 0;
		local a;
		while true do
			if (FlatIdent_6D4CB == 1) then
				return a;
			end
			if (FlatIdent_6D4CB == 0) then
				a = Byte(ByteString, DIP, DIP);
				DIP = DIP + 1;
				FlatIdent_6D4CB = 1;
			end
		end
	end
	local function gBits16()
		local FlatIdent_12703 = 0;
		local a;
		local b;
		while true do
			if (FlatIdent_12703 == 0) then
				a, b = Byte(ByteString, DIP, DIP + 2);
				DIP = DIP + 2;
				FlatIdent_12703 = 1;
			end
			if (FlatIdent_12703 == 1) then
				return (b * 256) + a;
			end
		end
	end
	local function gBits32()
		local FlatIdent_475BC = 0;
		local a;
		local b;
		local c;
		local d;
		while true do
			if (FlatIdent_475BC == 0) then
				a, b, c, d = Byte(ByteString, DIP, DIP + 3);
				DIP = DIP + 4;
				FlatIdent_475BC = 1;
			end
			if (FlatIdent_475BC == 1) then
				return (d * 16777216) + (c * 65536) + (b * 256) + a;
			end
		end
	end
	local function gFloat()
		local FlatIdent_43862 = 0;
		local Left;
		local Right;
		local IsNormal;
		local Mantissa;
		local Exponent;
		local Sign;
		while true do
			if (FlatIdent_43862 == 1) then
				IsNormal = 1;
				Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
				FlatIdent_43862 = 2;
			end
			if (FlatIdent_43862 == 3) then
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
			if (0 == FlatIdent_43862) then
				Left = gBits32();
				Right = gBits32();
				FlatIdent_43862 = 1;
			end
			if (FlatIdent_43862 == 2) then
				Exponent = gBit(Right, 21, 31);
				Sign = ((gBit(Right, 32) == 1) and -1) or 1;
				FlatIdent_43862 = 3;
			end
		end
	end
	local function gString(Len)
		local Str;
		if not Len then
			Len = gBits32();
			if (Len == 0) then
				return "";
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
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
			local FlatIdent_A36C = 0;
			local Type;
			local Cons;
			while true do
				if (FlatIdent_A36C == 0) then
					Type = gBits8();
					Cons = nil;
					FlatIdent_A36C = 1;
				end
				if (FlatIdent_A36C == 1) then
					if (Type == 1) then
						Cons = gBits8() ~= 0;
					elseif (Type == 2) then
						Cons = gFloat();
					elseif (Type == 3) then
						Cons = gString();
					end
					Consts[Idx] = Cons;
					break;
				end
			end
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local FlatIdent_7FAC9 = 0;
				local Type;
				local Mask;
				local Inst;
				while true do
					if (0 == FlatIdent_7FAC9) then
						Type = gBit(Descriptor, 2, 3);
						Mask = gBit(Descriptor, 4, 6);
						FlatIdent_7FAC9 = 1;
					end
					if (FlatIdent_7FAC9 == 3) then
						if (gBit(Mask, 3, 3) == 1) then
							Inst[4] = Consts[Inst[4]];
						end
						Instrs[Idx] = Inst;
						break;
					end
					if (FlatIdent_7FAC9 == 2) then
						if (gBit(Mask, 1, 1) == 1) then
							Inst[2] = Consts[Inst[2]];
						end
						if (gBit(Mask, 2, 2) == 1) then
							Inst[3] = Consts[Inst[3]];
						end
						FlatIdent_7FAC9 = 3;
					end
					if (FlatIdent_7FAC9 == 1) then
						Inst = {gBits16(),gBits16(),nil,nil};
						if (Type == 0) then
							local FlatIdent_99389 = 0;
							while true do
								if (FlatIdent_99389 == 0) then
									Inst[3] = gBits16();
									Inst[4] = gBits16();
									break;
								end
							end
						elseif (Type == 1) then
							Inst[3] = gBits32();
						elseif (Type == 2) then
							Inst[3] = gBits32() - (2 ^ 16);
						elseif (Type == 3) then
							local FlatIdent_8CEDF = 0;
							while true do
								if (FlatIdent_8CEDF == 0) then
									Inst[3] = gBits32() - (2 ^ 16);
									Inst[4] = gBits16();
									break;
								end
							end
						end
						FlatIdent_7FAC9 = 2;
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
				local FlatIdent_33EA4 = 0;
				while true do
					if (FlatIdent_33EA4 == 1) then
						if (Enum <= 108) then
							if (Enum <= 53) then
								if (Enum <= 26) then
									if (Enum <= 12) then
										if (Enum <= 5) then
											if (Enum <= 2) then
												if (Enum <= 0) then
													local FlatIdent_380E8 = 0;
													while true do
														if (6 == FlatIdent_380E8) then
															Stk[Inst[2]] = {};
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															break;
														end
														if (FlatIdent_380E8 == 0) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															FlatIdent_380E8 = 1;
														end
														if (FlatIdent_380E8 == 3) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															FlatIdent_380E8 = 4;
														end
														if (FlatIdent_380E8 == 5) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_380E8 = 6;
														end
														if (FlatIdent_380E8 == 1) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															FlatIdent_380E8 = 2;
														end
														if (FlatIdent_380E8 == 2) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_380E8 = 3;
														end
														if (4 == FlatIdent_380E8) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															FlatIdent_380E8 = 5;
														end
													end
												elseif (Enum > 1) then
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
													local FlatIdent_287B5 = 0;
													while true do
														if (6 == FlatIdent_287B5) then
															Stk[Inst[2]] = {};
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															break;
														end
														if (FlatIdent_287B5 == 1) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															FlatIdent_287B5 = 2;
														end
														if (FlatIdent_287B5 == 5) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_287B5 = 6;
														end
														if (2 == FlatIdent_287B5) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_287B5 = 3;
														end
														if (FlatIdent_287B5 == 4) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															FlatIdent_287B5 = 5;
														end
														if (3 == FlatIdent_287B5) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															FlatIdent_287B5 = 4;
														end
														if (FlatIdent_287B5 == 0) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															FlatIdent_287B5 = 1;
														end
													end
												end
											elseif (Enum <= 3) then
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
											elseif (Enum > 4) then
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
												local FlatIdent_6C033 = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_6C033 == 7) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (6 == FlatIdent_6C033) then
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_6C033 = 7;
													end
													if (4 == FlatIdent_6C033) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_6C033 = 5;
													end
													if (FlatIdent_6C033 == 3) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_6C033 = 4;
													end
													if (FlatIdent_6C033 == 2) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_6C033 = 3;
													end
													if (FlatIdent_6C033 == 0) then
														B = nil;
														T = nil;
														A = nil;
														FlatIdent_6C033 = 1;
													end
													if (FlatIdent_6C033 == 1) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_6C033 = 2;
													end
													if (FlatIdent_6C033 == 5) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_6C033 = 6;
													end
												end
											end
										elseif (Enum <= 8) then
											if (Enum <= 6) then
												local FlatIdent_2BE02 = 0;
												while true do
													if (FlatIdent_2BE02 == 2) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 3;
													end
													if (FlatIdent_2BE02 == 7) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 8;
													end
													if (0 == FlatIdent_2BE02) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 1;
													end
													if (FlatIdent_2BE02 == 4) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 5;
													end
													if (FlatIdent_2BE02 == 9) then
														Stk[Inst[2]] = Inst[3];
														break;
													end
													if (FlatIdent_2BE02 == 8) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 9;
													end
													if (FlatIdent_2BE02 == 1) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 2;
													end
													if (FlatIdent_2BE02 == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 4;
													end
													if (FlatIdent_2BE02 == 6) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 7;
													end
													if (FlatIdent_2BE02 == 5) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2BE02 = 6;
													end
												end
											elseif (Enum == 7) then
												VIP = Inst[3];
											else
												local A = Inst[2];
												local T = Stk[A];
												local B = Inst[3];
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
											end
										elseif (Enum <= 10) then
											if (Enum == 9) then
												Stk[Inst[2]] = #Stk[Inst[3]];
											else
												local FlatIdent_67517 = 0;
												while true do
													if (3 == FlatIdent_67517) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_67517 = 4;
													end
													if (FlatIdent_67517 == 0) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_67517 = 1;
													end
													if (5 == FlatIdent_67517) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_67517 = 6;
													end
													if (FlatIdent_67517 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_67517 = 3;
													end
													if (FlatIdent_67517 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_67517 = 2;
													end
													if (FlatIdent_67517 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_67517 = 5;
													end
													if (FlatIdent_67517 == 6) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														break;
													end
												end
											end
										elseif (Enum > 11) then
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
									elseif (Enum <= 19) then
										if (Enum <= 15) then
											if (Enum <= 13) then
												local FlatIdent_5E109 = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_5E109 == 0) then
														B = nil;
														T = nil;
														A = nil;
														Stk[Inst[2]] = Inst[3];
														FlatIdent_5E109 = 1;
													end
													if (FlatIdent_5E109 == 5) then
														B = Inst[3];
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (1 == FlatIdent_5E109) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_5E109 = 2;
													end
													if (FlatIdent_5E109 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														T = Stk[A];
														FlatIdent_5E109 = 5;
													end
													if (FlatIdent_5E109 == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														FlatIdent_5E109 = 4;
													end
													if (FlatIdent_5E109 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_5E109 = 3;
													end
												end
											elseif (Enum == 14) then
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
												local FlatIdent_854BA = 0;
												while true do
													if (FlatIdent_854BA == 0) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_854BA = 1;
													end
													if (1 == FlatIdent_854BA) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_854BA = 2;
													end
													if (3 == FlatIdent_854BA) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_854BA = 4;
													end
													if (FlatIdent_854BA == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_854BA = 5;
													end
													if (FlatIdent_854BA == 6) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														break;
													end
													if (FlatIdent_854BA == 5) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_854BA = 6;
													end
													if (FlatIdent_854BA == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_854BA = 3;
													end
												end
											end
										elseif (Enum <= 17) then
											if (Enum == 16) then
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
												local FlatIdent_3CDED = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_3CDED == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_3CDED = 2;
													end
													if (6 == FlatIdent_3CDED) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (FlatIdent_3CDED == 5) then
														Inst = Instr[VIP];
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_3CDED = 6;
													end
													if (FlatIdent_3CDED == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CDED = 3;
													end
													if (4 == FlatIdent_3CDED) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_3CDED = 5;
													end
													if (0 == FlatIdent_3CDED) then
														B = nil;
														T = nil;
														A = nil;
														Stk[Inst[2]] = {};
														FlatIdent_3CDED = 1;
													end
													if (FlatIdent_3CDED == 3) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_3CDED = 4;
													end
												end
											end
										elseif (Enum == 18) then
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
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
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
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
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
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Top));
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
										elseif (Enum > 21) then
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
									elseif (Enum <= 24) then
										if (Enum > 23) then
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
										end
									elseif (Enum == 25) then
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
										local FlatIdent_6C967 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_6C967 == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_6C967 = 8;
											end
											if (FlatIdent_6C967 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_6C967 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_6C967 = 1;
											end
											if (FlatIdent_6C967 == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6C967 = 5;
											end
											if (2 == FlatIdent_6C967) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6C967 = 3;
											end
											if (1 == FlatIdent_6C967) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6C967 = 2;
											end
											if (6 == FlatIdent_6C967) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6C967 = 7;
											end
											if (FlatIdent_6C967 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6C967 = 6;
											end
											if (FlatIdent_6C967 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6C967 = 4;
											end
										end
									end
								elseif (Enum <= 39) then
									if (Enum <= 32) then
										if (Enum <= 29) then
											if (Enum <= 27) then
												local FlatIdent_C595 = 0;
												local A;
												while true do
													if (FlatIdent_C595 == 18) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 19;
													end
													if (FlatIdent_C595 == 23) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 24;
													end
													if (FlatIdent_C595 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 3;
													end
													if (FlatIdent_C595 == 10) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 11;
													end
													if (28 == FlatIdent_C595) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 29;
													end
													if (FlatIdent_C595 == 22) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 23;
													end
													if (FlatIdent_C595 == 25) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 26;
													end
													if (FlatIdent_C595 == 16) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 17;
													end
													if (FlatIdent_C595 == 6) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 7;
													end
													if (FlatIdent_C595 == 30) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 31;
													end
													if (FlatIdent_C595 == 27) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 28;
													end
													if (FlatIdent_C595 == 24) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 25;
													end
													if (FlatIdent_C595 == 29) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 30;
													end
													if (FlatIdent_C595 == 19) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 20;
													end
													if (FlatIdent_C595 == 12) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 13;
													end
													if (FlatIdent_C595 == 8) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 9;
													end
													if (FlatIdent_C595 == 14) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 15;
													end
													if (FlatIdent_C595 == 11) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 12;
													end
													if (FlatIdent_C595 == 31) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														break;
													end
													if (FlatIdent_C595 == 9) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 10;
													end
													if (FlatIdent_C595 == 1) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 2;
													end
													if (FlatIdent_C595 == 5) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 6;
													end
													if (20 == FlatIdent_C595) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 21;
													end
													if (13 == FlatIdent_C595) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 14;
													end
													if (FlatIdent_C595 == 15) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 16;
													end
													if (FlatIdent_C595 == 3) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 4;
													end
													if (FlatIdent_C595 == 17) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 18;
													end
													if (FlatIdent_C595 == 7) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 8;
													end
													if (0 == FlatIdent_C595) then
														A = nil;
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 1;
													end
													if (FlatIdent_C595 == 21) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_C595 = 22;
													end
													if (FlatIdent_C595 == 26) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 27;
													end
													if (FlatIdent_C595 == 4) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_C595 = 5;
													end
												end
											elseif (Enum == 28) then
												local A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
										elseif (Enum <= 30) then
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
										elseif (Enum > 31) then
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										else
											local FlatIdent_9851B = 0;
											while true do
												if (FlatIdent_9851B == 8) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 9;
												end
												if (FlatIdent_9851B == 7) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 8;
												end
												if (FlatIdent_9851B == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 3;
												end
												if (FlatIdent_9851B == 5) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 6;
												end
												if (FlatIdent_9851B == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 4;
												end
												if (FlatIdent_9851B == 9) then
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (6 == FlatIdent_9851B) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 7;
												end
												if (FlatIdent_9851B == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 1;
												end
												if (FlatIdent_9851B == 4) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 5;
												end
												if (1 == FlatIdent_9851B) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_9851B = 2;
												end
											end
										end
									elseif (Enum <= 35) then
										if (Enum <= 33) then
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
										elseif (Enum == 34) then
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
									elseif (Enum <= 37) then
										if (Enum == 36) then
											local A = Inst[2];
											do
												return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									elseif (Enum > 38) then
										do
											return Stk[Inst[2]];
										end
									else
										local FlatIdent_12E4E = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_12E4E == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_12E4E = 6;
											end
											if (FlatIdent_12E4E == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_12E4E = 1;
											end
											if (FlatIdent_12E4E == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_12E4E = 3;
											end
											if (FlatIdent_12E4E == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_12E4E == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_12E4E = 5;
											end
											if (FlatIdent_12E4E == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_12E4E = 2;
											end
											if (FlatIdent_12E4E == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_12E4E = 4;
											end
										end
									end
								elseif (Enum <= 46) then
									if (Enum <= 42) then
										if (Enum <= 40) then
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
										elseif (Enum > 41) then
											local FlatIdent_4D69A = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_4D69A == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 4;
												end
												if (7 == FlatIdent_4D69A) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 8;
												end
												if (FlatIdent_4D69A == 2) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 3;
												end
												if (FlatIdent_4D69A == 9) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_4D69A == 1) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 2;
												end
												if (FlatIdent_4D69A == 4) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 5;
												end
												if (FlatIdent_4D69A == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_4D69A = 1;
												end
												if (FlatIdent_4D69A == 6) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 7;
												end
												if (5 == FlatIdent_4D69A) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4D69A = 6;
												end
												if (FlatIdent_4D69A == 8) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_4D69A = 9;
												end
											end
										else
											local FlatIdent_80652 = 0;
											while true do
												if (1 == FlatIdent_80652) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_80652 = 2;
												end
												if (FlatIdent_80652 == 6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_80652 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_80652 = 3;
												end
												if (FlatIdent_80652 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_80652 = 5;
												end
												if (FlatIdent_80652 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_80652 = 6;
												end
												if (FlatIdent_80652 == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_80652 = 1;
												end
												if (3 == FlatIdent_80652) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_80652 = 4;
												end
											end
										end
									elseif (Enum <= 44) then
										if (Enum > 43) then
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
											local FlatIdent_202CC = 0;
											local B;
											local T;
											local A;
											while true do
												if (2 == FlatIdent_202CC) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_202CC = 3;
												end
												if (7 == FlatIdent_202CC) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_202CC = 8;
												end
												if (FlatIdent_202CC == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_202CC = 1;
												end
												if (FlatIdent_202CC == 5) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_202CC = 6;
												end
												if (FlatIdent_202CC == 1) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_202CC = 2;
												end
												if (FlatIdent_202CC == 6) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_202CC = 7;
												end
												if (FlatIdent_202CC == 8) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (3 == FlatIdent_202CC) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_202CC = 4;
												end
												if (FlatIdent_202CC == 4) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_202CC = 5;
												end
											end
										end
									elseif (Enum > 45) then
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
								elseif (Enum <= 49) then
									if (Enum <= 47) then
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
									elseif (Enum > 48) then
										Stk[Inst[2]] = Env[Inst[3]];
									else
										local FlatIdent_904EC = 0;
										while true do
											if (FlatIdent_904EC == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 2;
											end
											if (FlatIdent_904EC == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 8;
											end
											if (FlatIdent_904EC == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 1;
											end
											if (FlatIdent_904EC == 9) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_904EC == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 4;
											end
											if (FlatIdent_904EC == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 9;
											end
											if (FlatIdent_904EC == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 7;
											end
											if (FlatIdent_904EC == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 6;
											end
											if (FlatIdent_904EC == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 5;
											end
											if (FlatIdent_904EC == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_904EC = 3;
											end
										end
									end
								elseif (Enum <= 51) then
									if (Enum > 50) then
										local FlatIdent_5E6B6 = 0;
										while true do
											if (FlatIdent_5E6B6 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 5;
											end
											if (FlatIdent_5E6B6 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5E6B6 = 4;
											end
											if (FlatIdent_5E6B6 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5E6B6 = 1;
											end
											if (FlatIdent_5E6B6 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_5E6B6 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 2;
											end
											if (FlatIdent_5E6B6 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 6;
											end
											if (FlatIdent_5E6B6 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 3;
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
								elseif (Enum == 52) then
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
									local FlatIdent_6BDA4 = 0;
									while true do
										if (2 == FlatIdent_6BDA4) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6BDA4 = 3;
										end
										if (0 == FlatIdent_6BDA4) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6BDA4 = 1;
										end
										if (FlatIdent_6BDA4 == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_6BDA4 = 4;
										end
										if (FlatIdent_6BDA4 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_6BDA4 = 2;
										end
										if (FlatIdent_6BDA4 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6BDA4 = 5;
										end
										if (FlatIdent_6BDA4 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6BDA4 = 6;
										end
										if (FlatIdent_6BDA4 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
									end
								end
							elseif (Enum <= 80) then
								if (Enum <= 66) then
									if (Enum <= 59) then
										if (Enum <= 56) then
											if (Enum <= 54) then
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
											elseif (Enum == 55) then
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
												local FlatIdent_35F25 = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_35F25 == 1) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_35F25 = 2;
													end
													if (FlatIdent_35F25 == 3) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_35F25 = 4;
													end
													if (0 == FlatIdent_35F25) then
														B = nil;
														T = nil;
														A = nil;
														FlatIdent_35F25 = 1;
													end
													if (FlatIdent_35F25 == 5) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_35F25 = 6;
													end
													if (FlatIdent_35F25 == 2) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_35F25 = 3;
													end
													if (6 == FlatIdent_35F25) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_35F25 = 7;
													end
													if (FlatIdent_35F25 == 8) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (FlatIdent_35F25 == 7) then
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_35F25 = 8;
													end
													if (FlatIdent_35F25 == 4) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_35F25 = 5;
													end
												end
											end
										elseif (Enum <= 57) then
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
										elseif (Enum == 58) then
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
											Stk[Inst[2]] = {};
										end
									elseif (Enum <= 62) then
										if (Enum <= 60) then
											local FlatIdent_30E68 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_30E68 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													FlatIdent_30E68 = 5;
												end
												if (FlatIdent_30E68 == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_30E68 = 1;
												end
												if (FlatIdent_30E68 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													FlatIdent_30E68 = 4;
												end
												if (FlatIdent_30E68 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_30E68 = 3;
												end
												if (FlatIdent_30E68 == 5) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_30E68 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_30E68 = 2;
												end
											end
										elseif (Enum > 61) then
											local FlatIdent_8DBF2 = 0;
											local A;
											while true do
												if (FlatIdent_8DBF2 == 31) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (19 == FlatIdent_8DBF2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_8DBF2 = 20;
												end
												if (FlatIdent_8DBF2 == 26) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 27;
												end
												if (FlatIdent_8DBF2 == 30) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 31;
												end
												if (FlatIdent_8DBF2 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 4;
												end
												if (18 == FlatIdent_8DBF2) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 19;
												end
												if (FlatIdent_8DBF2 == 15) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 16;
												end
												if (FlatIdent_8DBF2 == 29) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_8DBF2 = 30;
												end
												if (FlatIdent_8DBF2 == 10) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_8DBF2 = 11;
												end
												if (FlatIdent_8DBF2 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_8DBF2 = 5;
												end
												if (25 == FlatIdent_8DBF2) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_8DBF2 = 26;
												end
												if (0 == FlatIdent_8DBF2) then
													A = nil;
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_8DBF2 = 1;
												end
												if (FlatIdent_8DBF2 == 27) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_8DBF2 = 28;
												end
												if (FlatIdent_8DBF2 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 2;
												end
												if (11 == FlatIdent_8DBF2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 12;
												end
												if (FlatIdent_8DBF2 == 9) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 10;
												end
												if (FlatIdent_8DBF2 == 17) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_8DBF2 = 18;
												end
												if (FlatIdent_8DBF2 == 21) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_8DBF2 = 22;
												end
												if (FlatIdent_8DBF2 == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 6;
												end
												if (FlatIdent_8DBF2 == 12) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 13;
												end
												if (FlatIdent_8DBF2 == 28) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 29;
												end
												if (FlatIdent_8DBF2 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_8DBF2 = 3;
												end
												if (FlatIdent_8DBF2 == 8) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_8DBF2 = 9;
												end
												if (14 == FlatIdent_8DBF2) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 15;
												end
												if (FlatIdent_8DBF2 == 23) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_8DBF2 = 24;
												end
												if (FlatIdent_8DBF2 == 24) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 25;
												end
												if (7 == FlatIdent_8DBF2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 8;
												end
												if (16 == FlatIdent_8DBF2) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 17;
												end
												if (FlatIdent_8DBF2 == 6) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_8DBF2 = 7;
												end
												if (FlatIdent_8DBF2 == 20) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 21;
												end
												if (FlatIdent_8DBF2 == 13) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8DBF2 = 14;
												end
												if (22 == FlatIdent_8DBF2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_8DBF2 = 23;
												end
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]];
										end
									elseif (Enum <= 64) then
										if (Enum > 63) then
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
									elseif (Enum == 65) then
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
										local FlatIdent_186F = 0;
										while true do
											if (FlatIdent_186F == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 4;
											end
											if (5 == FlatIdent_186F) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 6;
											end
											if (FlatIdent_186F == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 1;
											end
											if (FlatIdent_186F == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 2;
											end
											if (FlatIdent_186F == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 9;
											end
											if (FlatIdent_186F == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 3;
											end
											if (FlatIdent_186F == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 5;
											end
											if (FlatIdent_186F == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 8;
											end
											if (FlatIdent_186F == 9) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_186F == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_186F = 7;
											end
										end
									end
								elseif (Enum <= 73) then
									if (Enum <= 69) then
										if (Enum <= 67) then
											local FlatIdent_772BD = 0;
											local A;
											while true do
												if (FlatIdent_772BD == 11) then
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
													FlatIdent_772BD = 12;
												end
												if (FlatIdent_772BD == 13) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_772BD = 14;
												end
												if (FlatIdent_772BD == 19) then
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
													FlatIdent_772BD = 20;
												end
												if (FlatIdent_772BD == 0) then
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_772BD = 1;
												end
												if (FlatIdent_772BD == 1) then
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
													FlatIdent_772BD = 2;
												end
												if (FlatIdent_772BD == 2) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_772BD = 3;
												end
												if (FlatIdent_772BD == 25) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													break;
												end
												if (FlatIdent_772BD == 8) then
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
													FlatIdent_772BD = 9;
												end
												if (FlatIdent_772BD == 24) then
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
													FlatIdent_772BD = 25;
												end
												if (FlatIdent_772BD == 15) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_772BD = 16;
												end
												if (FlatIdent_772BD == 14) then
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
													FlatIdent_772BD = 15;
												end
												if (FlatIdent_772BD == 6) then
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
													FlatIdent_772BD = 7;
												end
												if (FlatIdent_772BD == 18) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_772BD = 19;
												end
												if (16 == FlatIdent_772BD) then
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
													FlatIdent_772BD = 17;
												end
												if (FlatIdent_772BD == 3) then
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
													FlatIdent_772BD = 4;
												end
												if (FlatIdent_772BD == 10) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_772BD = 11;
												end
												if (FlatIdent_772BD == 21) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_772BD = 22;
												end
												if (FlatIdent_772BD == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_772BD = 6;
												end
												if (FlatIdent_772BD == 7) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_772BD = 8;
												end
												if (FlatIdent_772BD == 4) then
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
													FlatIdent_772BD = 5;
												end
												if (22 == FlatIdent_772BD) then
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
													FlatIdent_772BD = 23;
												end
												if (9 == FlatIdent_772BD) then
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
													FlatIdent_772BD = 10;
												end
												if (FlatIdent_772BD == 23) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_772BD = 24;
												end
												if (FlatIdent_772BD == 20) then
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
													FlatIdent_772BD = 21;
												end
												if (FlatIdent_772BD == 17) then
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
													FlatIdent_772BD = 18;
												end
												if (FlatIdent_772BD == 12) then
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
													FlatIdent_772BD = 13;
												end
											end
										elseif (Enum == 68) then
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
									elseif (Enum <= 71) then
										if (Enum == 70) then
											do
												return;
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
									elseif (Enum == 72) then
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
										local FlatIdent_384E6 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_384E6 == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_384E6 = 6;
											end
											if (FlatIdent_384E6 == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (2 == FlatIdent_384E6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_384E6 = 3;
											end
											if (FlatIdent_384E6 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_384E6 = 5;
											end
											if (3 == FlatIdent_384E6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_384E6 = 4;
											end
											if (FlatIdent_384E6 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_384E6 = 2;
											end
											if (FlatIdent_384E6 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_384E6 = 1;
											end
										end
									end
								elseif (Enum <= 76) then
									if (Enum <= 74) then
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									elseif (Enum > 75) then
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
										local FlatIdent_104FA = 0;
										local A;
										while true do
											if (FlatIdent_104FA == 13) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 14;
											end
											if (FlatIdent_104FA == 20) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 21;
											end
											if (FlatIdent_104FA == 18) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 19;
											end
											if (FlatIdent_104FA == 22) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 23;
											end
											if (FlatIdent_104FA == 3) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 4;
											end
											if (FlatIdent_104FA == 9) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 10;
											end
											if (FlatIdent_104FA == 15) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 16;
											end
											if (FlatIdent_104FA == 1) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 2;
											end
											if (FlatIdent_104FA == 0) then
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 1;
											end
											if (FlatIdent_104FA == 10) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 11;
											end
											if (FlatIdent_104FA == 28) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 29;
											end
											if (FlatIdent_104FA == 27) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 28;
											end
											if (FlatIdent_104FA == 31) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_104FA == 8) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 9;
											end
											if (FlatIdent_104FA == 14) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 15;
											end
											if (FlatIdent_104FA == 17) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 18;
											end
											if (21 == FlatIdent_104FA) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 22;
											end
											if (FlatIdent_104FA == 25) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 26;
											end
											if (FlatIdent_104FA == 26) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 27;
											end
											if (FlatIdent_104FA == 16) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 17;
											end
											if (24 == FlatIdent_104FA) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 25;
											end
											if (FlatIdent_104FA == 4) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 5;
											end
											if (FlatIdent_104FA == 5) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 6;
											end
											if (FlatIdent_104FA == 11) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 12;
											end
											if (23 == FlatIdent_104FA) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 24;
											end
											if (FlatIdent_104FA == 12) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 13;
											end
											if (FlatIdent_104FA == 30) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 31;
											end
											if (29 == FlatIdent_104FA) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 30;
											end
											if (FlatIdent_104FA == 6) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 7;
											end
											if (FlatIdent_104FA == 2) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_104FA = 3;
											end
											if (FlatIdent_104FA == 7) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 8;
											end
											if (FlatIdent_104FA == 19) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_104FA = 20;
											end
										end
									end
								elseif (Enum <= 78) then
									if (Enum > 77) then
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
								elseif (Enum == 79) then
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
							elseif (Enum <= 94) then
								if (Enum <= 87) then
									if (Enum <= 83) then
										if (Enum <= 81) then
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
										elseif (Enum == 82) then
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
									elseif (Enum <= 85) then
										if (Enum > 84) then
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
									elseif (Enum == 86) then
										local FlatIdent_91F32 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_91F32 == 5) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_91F32 = 6;
											end
											if (FlatIdent_91F32 == 7) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_91F32 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_91F32 = 1;
											end
											if (2 == FlatIdent_91F32) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_91F32 = 3;
											end
											if (FlatIdent_91F32 == 6) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_91F32 = 7;
											end
											if (FlatIdent_91F32 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_91F32 = 5;
											end
											if (FlatIdent_91F32 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_91F32 = 4;
											end
											if (FlatIdent_91F32 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_91F32 = 2;
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
								elseif (Enum <= 90) then
									if (Enum <= 88) then
										local FlatIdent_11006 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_11006 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_11006 = 4;
											end
											if (FlatIdent_11006 == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_11006 = 5;
											end
											if (FlatIdent_11006 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_11006 = 6;
											end
											if (1 == FlatIdent_11006) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_11006 = 2;
											end
											if (7 == FlatIdent_11006) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_11006 = 8;
											end
											if (0 == FlatIdent_11006) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_11006 = 1;
											end
											if (FlatIdent_11006 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_11006 = 7;
											end
											if (FlatIdent_11006 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_11006 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_11006 = 3;
											end
										end
									elseif (Enum > 89) then
										local FlatIdent_1D124 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_1D124 == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1D124 = 5;
											end
											if (FlatIdent_1D124 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_1D124 = 1;
											end
											if (FlatIdent_1D124 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1D124 = 7;
											end
											if (FlatIdent_1D124 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1D124 = 6;
											end
											if (FlatIdent_1D124 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_1D124 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1D124 = 3;
											end
											if (FlatIdent_1D124 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1D124 = 4;
											end
											if (FlatIdent_1D124 == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_1D124 = 8;
											end
											if (1 == FlatIdent_1D124) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1D124 = 2;
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
								elseif (Enum <= 92) then
									if (Enum > 91) then
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
										local FlatIdent_2E949 = 0;
										while true do
											if (FlatIdent_2E949 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_2E949 = 4;
											end
											if (FlatIdent_2E949 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2E949 = 3;
											end
											if (FlatIdent_2E949 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_2E949 = 2;
											end
											if (FlatIdent_2E949 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_2E949 = 5;
											end
											if (FlatIdent_2E949 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2E949 = 6;
											end
											if (FlatIdent_2E949 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (0 == FlatIdent_2E949) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_2E949 = 1;
											end
										end
									end
								elseif (Enum > 93) then
									local FlatIdent_706CB = 0;
									while true do
										if (FlatIdent_706CB == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_706CB = 1;
										end
										if (1 == FlatIdent_706CB) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_706CB = 2;
										end
										if (FlatIdent_706CB == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_706CB = 3;
										end
										if (FlatIdent_706CB == 6) then
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_706CB == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_706CB = 5;
										end
										if (3 == FlatIdent_706CB) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_706CB = 4;
										end
										if (FlatIdent_706CB == 5) then
											Inst = Instr[VIP];
											do
												return Stk[Inst[2]];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_706CB = 6;
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
							elseif (Enum <= 101) then
								if (Enum <= 97) then
									if (Enum <= 95) then
										local FlatIdent_27E8B = 0;
										local A;
										while true do
											if (FlatIdent_27E8B == 0) then
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Top));
												break;
											end
										end
									elseif (Enum > 96) then
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
								elseif (Enum <= 99) then
									if (Enum > 98) then
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
								elseif (Enum == 100) then
									local FlatIdent_19471 = 0;
									while true do
										if (FlatIdent_19471 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_19471 = 6;
										end
										if (2 == FlatIdent_19471) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_19471 = 3;
										end
										if (FlatIdent_19471 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_19471 = 2;
										end
										if (FlatIdent_19471 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_19471 = 1;
										end
										if (FlatIdent_19471 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_19471 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_19471 = 5;
										end
										if (3 == FlatIdent_19471) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_19471 = 4;
										end
									end
								else
									local FlatIdent_2E52D = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_2E52D == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_2E52D = 5;
										end
										if (FlatIdent_2E52D == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_2E52D = 4;
										end
										if (FlatIdent_2E52D == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2E52D = 3;
										end
										if (6 == FlatIdent_2E52D) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_2E52D == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_2E52D = 1;
										end
										if (1 == FlatIdent_2E52D) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_2E52D = 2;
										end
										if (FlatIdent_2E52D == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_2E52D = 6;
										end
									end
								end
							elseif (Enum <= 104) then
								if (Enum <= 102) then
									local FlatIdent_849C1 = 0;
									while true do
										if (FlatIdent_849C1 == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 2;
										end
										if (FlatIdent_849C1 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 3;
										end
										if (FlatIdent_849C1 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 4;
										end
										if (FlatIdent_849C1 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 1;
										end
										if (FlatIdent_849C1 == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (6 == FlatIdent_849C1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 7;
										end
										if (FlatIdent_849C1 == 4) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 5;
										end
										if (7 == FlatIdent_849C1) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 8;
										end
										if (FlatIdent_849C1 == 5) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 6;
										end
										if (FlatIdent_849C1 == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_849C1 = 9;
										end
									end
								elseif (Enum == 103) then
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
							elseif (Enum <= 106) then
								if (Enum > 105) then
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum > 107) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
						elseif (Enum <= 162) then
							if (Enum <= 135) then
								if (Enum <= 121) then
									if (Enum <= 114) then
										if (Enum <= 111) then
											if (Enum <= 109) then
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
											elseif (Enum > 110) then
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
										elseif (Enum <= 112) then
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
										elseif (Enum == 113) then
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
											local FlatIdent_6C782 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_6C782 == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6C782 = 2;
												end
												if (FlatIdent_6C782 == 6) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_6C782 = 7;
												end
												if (FlatIdent_6C782 == 5) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6C782 = 6;
												end
												if (FlatIdent_6C782 == 7) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_6C782 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6C782 = 5;
												end
												if (2 == FlatIdent_6C782) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6C782 = 3;
												end
												if (3 == FlatIdent_6C782) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6C782 = 4;
												end
												if (FlatIdent_6C782 == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_6C782 = 1;
												end
											end
										end
									elseif (Enum <= 117) then
										if (Enum <= 115) then
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
										elseif (Enum > 116) then
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
									elseif (Enum <= 119) then
										if (Enum == 118) then
											for Idx = Inst[2], Inst[3] do
												Stk[Idx] = nil;
											end
										else
											local FlatIdent_50BBA = 0;
											while true do
												if (4 == FlatIdent_50BBA) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_50BBA = 5;
												end
												if (1 == FlatIdent_50BBA) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_50BBA = 2;
												end
												if (FlatIdent_50BBA == 6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_50BBA == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_50BBA = 3;
												end
												if (FlatIdent_50BBA == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_50BBA = 6;
												end
												if (FlatIdent_50BBA == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_50BBA = 1;
												end
												if (FlatIdent_50BBA == 3) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_50BBA = 4;
												end
											end
										end
									elseif (Enum > 120) then
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
								elseif (Enum <= 128) then
									if (Enum <= 124) then
										if (Enum <= 122) then
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
										elseif (Enum == 123) then
											local FlatIdent_3383B = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_3383B == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3383B = 4;
												end
												if (FlatIdent_3383B == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = {};
													FlatIdent_3383B = 1;
												end
												if (FlatIdent_3383B == 6) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (4 == FlatIdent_3383B) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_3383B = 5;
												end
												if (FlatIdent_3383B == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3383B = 2;
												end
												if (FlatIdent_3383B == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3383B = 3;
												end
												if (FlatIdent_3383B == 5) then
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_3383B = 6;
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
									elseif (Enum <= 126) then
										if (Enum == 125) then
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
									elseif (Enum > 127) then
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
								elseif (Enum <= 131) then
									if (Enum <= 129) then
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
									elseif (Enum == 130) then
										local FlatIdent_EF32 = 0;
										while true do
											if (2 == FlatIdent_EF32) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 3;
											end
											if (FlatIdent_EF32 == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 6;
											end
											if (FlatIdent_EF32 == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 5;
											end
											if (FlatIdent_EF32 == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 8;
											end
											if (9 == FlatIdent_EF32) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_EF32 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 4;
											end
											if (FlatIdent_EF32 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 2;
											end
											if (FlatIdent_EF32 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 1;
											end
											if (6 == FlatIdent_EF32) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 7;
											end
											if (FlatIdent_EF32 == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_EF32 = 9;
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
								elseif (Enum <= 133) then
									if (Enum == 132) then
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
								elseif (Enum == 134) then
									local FlatIdent_91BD6 = 0;
									local A;
									while true do
										if (6 == FlatIdent_91BD6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_91BD6 = 7;
										end
										if (FlatIdent_91BD6 == 19) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 20;
										end
										if (5 == FlatIdent_91BD6) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_91BD6 = 6;
										end
										if (25 == FlatIdent_91BD6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_91BD6 == 16) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_91BD6 = 17;
										end
										if (FlatIdent_91BD6 == 1) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 2;
										end
										if (FlatIdent_91BD6 == 15) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_91BD6 = 16;
										end
										if (10 == FlatIdent_91BD6) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_91BD6 = 11;
										end
										if (FlatIdent_91BD6 == 20) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 21;
										end
										if (FlatIdent_91BD6 == 3) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_91BD6 = 4;
										end
										if (FlatIdent_91BD6 == 14) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 15;
										end
										if (FlatIdent_91BD6 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_91BD6 = 5;
										end
										if (FlatIdent_91BD6 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_91BD6 = 3;
										end
										if (FlatIdent_91BD6 == 21) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_91BD6 = 22;
										end
										if (FlatIdent_91BD6 == 11) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_91BD6 = 12;
										end
										if (9 == FlatIdent_91BD6) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_91BD6 = 10;
										end
										if (FlatIdent_91BD6 == 18) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_91BD6 = 19;
										end
										if (FlatIdent_91BD6 == 24) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_91BD6 = 25;
										end
										if (FlatIdent_91BD6 == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 8;
										end
										if (FlatIdent_91BD6 == 0) then
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
											FlatIdent_91BD6 = 1;
										end
										if (FlatIdent_91BD6 == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_91BD6 = 13;
										end
										if (FlatIdent_91BD6 == 23) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_91BD6 = 24;
										end
										if (FlatIdent_91BD6 == 17) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_91BD6 = 18;
										end
										if (FlatIdent_91BD6 == 13) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 14;
										end
										if (FlatIdent_91BD6 == 22) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_91BD6 = 23;
										end
										if (FlatIdent_91BD6 == 8) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_91BD6 = 9;
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
							elseif (Enum <= 148) then
								if (Enum <= 141) then
									if (Enum <= 138) then
										if (Enum <= 136) then
											local FlatIdent_969E6 = 0;
											while true do
												if (FlatIdent_969E6 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_969E6 = 2;
												end
												if (FlatIdent_969E6 == 3) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_969E6 = 4;
												end
												if (FlatIdent_969E6 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_969E6 = 3;
												end
												if (4 == FlatIdent_969E6) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_969E6 = 5;
												end
												if (6 == FlatIdent_969E6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_969E6 == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_969E6 = 1;
												end
												if (FlatIdent_969E6 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_969E6 = 6;
												end
											end
										elseif (Enum == 137) then
											local FlatIdent_7D2DA = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_7D2DA == 2) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7D2DA = 3;
												end
												if (FlatIdent_7D2DA == 5) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7D2DA = 6;
												end
												if (FlatIdent_7D2DA == 4) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7D2DA = 5;
												end
												if (FlatIdent_7D2DA == 6) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7D2DA = 7;
												end
												if (FlatIdent_7D2DA == 1) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7D2DA = 2;
												end
												if (FlatIdent_7D2DA == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_7D2DA = 1;
												end
												if (FlatIdent_7D2DA == 8) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_7D2DA == 3) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7D2DA = 4;
												end
												if (FlatIdent_7D2DA == 7) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_7D2DA = 8;
												end
											end
										else
											local FlatIdent_3265F = 0;
											local A;
											while true do
												if (FlatIdent_3265F == 9) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 10;
												end
												if (10 == FlatIdent_3265F) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3265F = 11;
												end
												if (13 == FlatIdent_3265F) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_3265F = 14;
												end
												if (FlatIdent_3265F == 17) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3265F = 18;
												end
												if (FlatIdent_3265F == 23) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_3265F = 24;
												end
												if (FlatIdent_3265F == 12) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3265F = 13;
												end
												if (FlatIdent_3265F == 11) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_3265F = 12;
												end
												if (FlatIdent_3265F == 6) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_3265F = 7;
												end
												if (FlatIdent_3265F == 8) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 9;
												end
												if (FlatIdent_3265F == 20) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 21;
												end
												if (FlatIdent_3265F == 24) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_3265F = 25;
												end
												if (FlatIdent_3265F == 21) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 22;
												end
												if (FlatIdent_3265F == 19) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3265F = 20;
												end
												if (FlatIdent_3265F == 2) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 3;
												end
												if (5 == FlatIdent_3265F) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_3265F = 6;
												end
												if (FlatIdent_3265F == 3) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_3265F = 4;
												end
												if (0 == FlatIdent_3265F) then
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
													FlatIdent_3265F = 1;
												end
												if (FlatIdent_3265F == 15) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 16;
												end
												if (16 == FlatIdent_3265F) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3265F = 17;
												end
												if (FlatIdent_3265F == 14) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 15;
												end
												if (FlatIdent_3265F == 4) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_3265F = 5;
												end
												if (FlatIdent_3265F == 1) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3265F = 2;
												end
												if (FlatIdent_3265F == 25) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													break;
												end
												if (FlatIdent_3265F == 7) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_3265F = 8;
												end
												if (FlatIdent_3265F == 18) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3265F = 19;
												end
												if (FlatIdent_3265F == 22) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_3265F = 23;
												end
											end
										end
									elseif (Enum <= 139) then
										local FlatIdent_3E900 = 0;
										local A;
										local Index;
										local Step;
										while true do
											if (FlatIdent_3E900 == 0) then
												A = Inst[2];
												Index = Stk[A];
												FlatIdent_3E900 = 1;
											end
											if (FlatIdent_3E900 == 1) then
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
												break;
											end
										end
									elseif (Enum == 140) then
										local FlatIdent_78AED = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_78AED == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_78AED = 1;
											end
											if (FlatIdent_78AED == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_78AED = 4;
											end
											if (FlatIdent_78AED == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_78AED = 5;
											end
											if (FlatIdent_78AED == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_78AED == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_78AED = 6;
											end
											if (FlatIdent_78AED == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_78AED = 3;
											end
											if (FlatIdent_78AED == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_78AED = 2;
											end
										end
									else
										local FlatIdent_85D76 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_85D76 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												FlatIdent_85D76 = 5;
											end
											if (FlatIdent_85D76 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												FlatIdent_85D76 = 4;
											end
											if (0 == FlatIdent_85D76) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = Inst[3];
												FlatIdent_85D76 = 1;
											end
											if (1 == FlatIdent_85D76) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_85D76 = 2;
											end
											if (FlatIdent_85D76 == 5) then
												B = Inst[3];
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_85D76 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_85D76 = 3;
											end
										end
									end
								elseif (Enum <= 144) then
									if (Enum <= 142) then
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
									elseif (Enum > 143) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum <= 146) then
									if (Enum == 145) then
										local FlatIdent_6226C = 0;
										while true do
											if (FlatIdent_6226C == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 6;
											end
											if (FlatIdent_6226C == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 9;
											end
											if (2 == FlatIdent_6226C) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 3;
											end
											if (FlatIdent_6226C == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 4;
											end
											if (FlatIdent_6226C == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 7;
											end
											if (FlatIdent_6226C == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 8;
											end
											if (FlatIdent_6226C == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 2;
											end
											if (FlatIdent_6226C == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 5;
											end
											if (FlatIdent_6226C == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6226C = 1;
											end
											if (9 == FlatIdent_6226C) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
										end
									else
										local FlatIdent_14E8C = 0;
										while true do
											if (FlatIdent_14E8C == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 2;
											end
											if (FlatIdent_14E8C == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 4;
											end
											if (4 == FlatIdent_14E8C) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 5;
											end
											if (FlatIdent_14E8C == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 9;
											end
											if (FlatIdent_14E8C == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 1;
											end
											if (FlatIdent_14E8C == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 6;
											end
											if (FlatIdent_14E8C == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 8;
											end
											if (FlatIdent_14E8C == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 3;
											end
											if (FlatIdent_14E8C == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_14E8C = 7;
											end
											if (9 == FlatIdent_14E8C) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
										end
									end
								elseif (Enum > 147) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								else
									local FlatIdent_56BE5 = 0;
									while true do
										if (FlatIdent_56BE5 == 4) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 5;
										end
										if (0 == FlatIdent_56BE5) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 1;
										end
										if (FlatIdent_56BE5 == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 2;
										end
										if (FlatIdent_56BE5 == 5) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 6;
										end
										if (FlatIdent_56BE5 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 4;
										end
										if (FlatIdent_56BE5 == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 7;
										end
										if (FlatIdent_56BE5 == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 8;
										end
										if (FlatIdent_56BE5 == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_56BE5 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 3;
										end
										if (FlatIdent_56BE5 == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_56BE5 = 9;
										end
									end
								end
							elseif (Enum <= 155) then
								if (Enum <= 151) then
									if (Enum <= 149) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									elseif (Enum > 150) then
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
								elseif (Enum <= 153) then
									if (Enum > 152) then
										local FlatIdent_28724 = 0;
										local A;
										while true do
											if (FlatIdent_28724 == 16) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_28724 = 17;
											end
											if (FlatIdent_28724 == 1) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 2;
											end
											if (FlatIdent_28724 == 5) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_28724 = 6;
											end
											if (FlatIdent_28724 == 12) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_28724 = 13;
											end
											if (FlatIdent_28724 == 24) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_28724 = 25;
											end
											if (FlatIdent_28724 == 6) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_28724 = 7;
											end
											if (FlatIdent_28724 == 23) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_28724 = 24;
											end
											if (FlatIdent_28724 == 18) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_28724 = 19;
											end
											if (10 == FlatIdent_28724) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_28724 = 11;
											end
											if (FlatIdent_28724 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_28724 = 4;
											end
											if (FlatIdent_28724 == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_28724 = 18;
											end
											if (FlatIdent_28724 == 7) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_28724 = 8;
											end
											if (FlatIdent_28724 == 20) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 21;
											end
											if (FlatIdent_28724 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_28724 = 12;
											end
											if (25 == FlatIdent_28724) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												break;
											end
											if (FlatIdent_28724 == 22) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_28724 = 23;
											end
											if (FlatIdent_28724 == 13) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_28724 = 14;
											end
											if (4 == FlatIdent_28724) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_28724 = 5;
											end
											if (FlatIdent_28724 == 0) then
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
												FlatIdent_28724 = 1;
											end
											if (FlatIdent_28724 == 15) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 16;
											end
											if (FlatIdent_28724 == 9) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 10;
											end
											if (FlatIdent_28724 == 21) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 22;
											end
											if (FlatIdent_28724 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 9;
											end
											if (FlatIdent_28724 == 2) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 3;
											end
											if (FlatIdent_28724 == 19) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_28724 = 20;
											end
											if (FlatIdent_28724 == 14) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_28724 = 15;
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
								elseif (Enum > 154) then
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
									local FlatIdent_6AFD8 = 0;
									local A;
									while true do
										if (FlatIdent_6AFD8 == 27) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 28;
										end
										if (FlatIdent_6AFD8 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6AFD8 = 2;
										end
										if (FlatIdent_6AFD8 == 28) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											break;
										end
										if (FlatIdent_6AFD8 == 6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_6AFD8 = 7;
										end
										if (FlatIdent_6AFD8 == 2) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 3;
										end
										if (FlatIdent_6AFD8 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 5;
										end
										if (FlatIdent_6AFD8 == 25) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_6AFD8 = 26;
										end
										if (FlatIdent_6AFD8 == 16) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 17;
										end
										if (FlatIdent_6AFD8 == 13) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_6AFD8 = 14;
										end
										if (21 == FlatIdent_6AFD8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 22;
										end
										if (FlatIdent_6AFD8 == 0) then
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6AFD8 = 1;
										end
										if (24 == FlatIdent_6AFD8) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 25;
										end
										if (FlatIdent_6AFD8 == 17) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 18;
										end
										if (FlatIdent_6AFD8 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 4;
										end
										if (22 == FlatIdent_6AFD8) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 23;
										end
										if (FlatIdent_6AFD8 == 8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 9;
										end
										if (FlatIdent_6AFD8 == 11) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 12;
										end
										if (FlatIdent_6AFD8 == 7) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6AFD8 = 8;
										end
										if (FlatIdent_6AFD8 == 14) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_6AFD8 = 15;
										end
										if (FlatIdent_6AFD8 == 26) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6AFD8 = 27;
										end
										if (5 == FlatIdent_6AFD8) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 6;
										end
										if (9 == FlatIdent_6AFD8) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 10;
										end
										if (23 == FlatIdent_6AFD8) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 24;
										end
										if (20 == FlatIdent_6AFD8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6AFD8 = 21;
										end
										if (FlatIdent_6AFD8 == 19) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_6AFD8 = 20;
										end
										if (FlatIdent_6AFD8 == 15) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6AFD8 = 16;
										end
										if (FlatIdent_6AFD8 == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_6AFD8 = 13;
										end
										if (FlatIdent_6AFD8 == 10) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 11;
										end
										if (18 == FlatIdent_6AFD8) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6AFD8 = 19;
										end
									end
								end
							elseif (Enum <= 158) then
								if (Enum <= 156) then
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								elseif (Enum == 157) then
									local FlatIdent_95C9A = 0;
									local A;
									while true do
										if (FlatIdent_95C9A == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_95C9A = 13;
										end
										if (FlatIdent_95C9A == 11) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_95C9A = 12;
										end
										if (FlatIdent_95C9A == 25) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_95C9A = 26;
										end
										if (4 == FlatIdent_95C9A) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_95C9A = 5;
										end
										if (FlatIdent_95C9A == 8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 9;
										end
										if (FlatIdent_95C9A == 6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_95C9A = 7;
										end
										if (FlatIdent_95C9A == 0) then
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_95C9A = 1;
										end
										if (FlatIdent_95C9A == 20) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_95C9A = 21;
										end
										if (FlatIdent_95C9A == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_95C9A = 2;
										end
										if (FlatIdent_95C9A == 26) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_95C9A = 27;
										end
										if (FlatIdent_95C9A == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 4;
										end
										if (13 == FlatIdent_95C9A) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_95C9A = 14;
										end
										if (FlatIdent_95C9A == 19) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_95C9A = 20;
										end
										if (FlatIdent_95C9A == 17) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_95C9A = 18;
										end
										if (16 == FlatIdent_95C9A) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 17;
										end
										if (FlatIdent_95C9A == 10) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_95C9A = 11;
										end
										if (FlatIdent_95C9A == 24) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_95C9A = 25;
										end
										if (FlatIdent_95C9A == 7) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_95C9A = 8;
										end
										if (FlatIdent_95C9A == 2) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 3;
										end
										if (FlatIdent_95C9A == 14) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_95C9A = 15;
										end
										if (21 == FlatIdent_95C9A) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 22;
										end
										if (FlatIdent_95C9A == 23) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_95C9A = 24;
										end
										if (FlatIdent_95C9A == 22) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 23;
										end
										if (FlatIdent_95C9A == 9) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 10;
										end
										if (FlatIdent_95C9A == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_95C9A = 6;
										end
										if (FlatIdent_95C9A == 28) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											break;
										end
										if (27 == FlatIdent_95C9A) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 28;
										end
										if (FlatIdent_95C9A == 15) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_95C9A = 16;
										end
										if (FlatIdent_95C9A == 18) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_95C9A = 19;
										end
									end
								else
									local FlatIdent_584F8 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_584F8 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_584F8 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_584F8 = 4;
										end
										if (FlatIdent_584F8 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_584F8 = 5;
										end
										if (FlatIdent_584F8 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_584F8 = 1;
										end
										if (FlatIdent_584F8 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_584F8 = 6;
										end
										if (FlatIdent_584F8 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_584F8 = 2;
										end
										if (FlatIdent_584F8 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_584F8 = 3;
										end
									end
								end
							elseif (Enum <= 160) then
								if (Enum > 159) then
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
							elseif (Enum == 161) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
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
						elseif (Enum <= 189) then
							if (Enum <= 175) then
								if (Enum <= 168) then
									if (Enum <= 165) then
										if (Enum <= 163) then
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
										elseif (Enum == 164) then
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
									elseif (Enum <= 166) then
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
									elseif (Enum > 167) then
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum <= 171) then
									if (Enum <= 169) then
										local FlatIdent_59C91 = 0;
										local A;
										while true do
											if (FlatIdent_59C91 == 0) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
												break;
											end
										end
									elseif (Enum > 170) then
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
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
								elseif (Enum <= 173) then
									if (Enum > 172) then
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
										do
											return Unpack(Stk, A, A + Inst[3]);
										end
									end
								elseif (Enum == 174) then
									local FlatIdent_50BC3 = 0;
									local A;
									local T;
									while true do
										if (FlatIdent_50BC3 == 1) then
											for Idx = A + 1, Inst[3] do
												Insert(T, Stk[Idx]);
											end
											break;
										end
										if (FlatIdent_50BC3 == 0) then
											A = Inst[2];
											T = Stk[A];
											FlatIdent_50BC3 = 1;
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
							elseif (Enum <= 182) then
								if (Enum <= 178) then
									if (Enum <= 176) then
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
									elseif (Enum > 177) then
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
								elseif (Enum <= 180) then
									if (Enum > 179) then
										local FlatIdent_87628 = 0;
										while true do
											if (FlatIdent_87628 == 0) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 1;
											end
											if (FlatIdent_87628 == 7) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 8;
											end
											if (FlatIdent_87628 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 7;
											end
											if (FlatIdent_87628 == 1) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 2;
											end
											if (FlatIdent_87628 == 4) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 5;
											end
											if (FlatIdent_87628 == 3) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 4;
											end
											if (FlatIdent_87628 == 8) then
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_87628 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 3;
											end
											if (FlatIdent_87628 == 5) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_87628 = 6;
											end
										end
									else
										local FlatIdent_5BFA7 = 0;
										local A;
										while true do
											if (FlatIdent_5BFA7 == 27) then
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
											if (FlatIdent_5BFA7 == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 7;
											end
											if (FlatIdent_5BFA7 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 5;
											end
											if (FlatIdent_5BFA7 == 20) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5BFA7 = 21;
											end
											if (FlatIdent_5BFA7 == 8) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5BFA7 = 9;
											end
											if (FlatIdent_5BFA7 == 14) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_5BFA7 = 15;
											end
											if (FlatIdent_5BFA7 == 16) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 17;
											end
											if (FlatIdent_5BFA7 == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 10;
											end
											if (1 == FlatIdent_5BFA7) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5BFA7 = 2;
											end
											if (FlatIdent_5BFA7 == 24) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 25;
											end
											if (FlatIdent_5BFA7 == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 1;
											end
											if (FlatIdent_5BFA7 == 26) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5BFA7 = 27;
											end
											if (11 == FlatIdent_5BFA7) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 12;
											end
											if (FlatIdent_5BFA7 == 21) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5BFA7 = 22;
											end
											if (17 == FlatIdent_5BFA7) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 18;
											end
											if (FlatIdent_5BFA7 == 19) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 20;
											end
											if (FlatIdent_5BFA7 == 12) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 13;
											end
											if (FlatIdent_5BFA7 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 4;
											end
											if (FlatIdent_5BFA7 == 18) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 19;
											end
											if (FlatIdent_5BFA7 == 22) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 23;
											end
											if (FlatIdent_5BFA7 == 10) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 11;
											end
											if (FlatIdent_5BFA7 == 2) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5BFA7 = 3;
											end
											if (FlatIdent_5BFA7 == 25) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 26;
											end
											if (FlatIdent_5BFA7 == 23) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5BFA7 = 24;
											end
											if (13 == FlatIdent_5BFA7) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_5BFA7 = 14;
											end
											if (FlatIdent_5BFA7 == 7) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5BFA7 = 8;
											end
											if (FlatIdent_5BFA7 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_5BFA7 = 6;
											end
											if (FlatIdent_5BFA7 == 15) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_5BFA7 = 16;
											end
										end
									end
								elseif (Enum == 181) then
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
							elseif (Enum <= 185) then
								if (Enum <= 183) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								elseif (Enum > 184) then
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local FlatIdent_97270 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_97270 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_97270 = 1;
										end
										if (5 == FlatIdent_97270) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_97270 = 6;
										end
										if (FlatIdent_97270 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_97270 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_97270 = 5;
										end
										if (FlatIdent_97270 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_97270 = 3;
										end
										if (FlatIdent_97270 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_97270 = 4;
										end
										if (FlatIdent_97270 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_97270 = 2;
										end
									end
								end
							elseif (Enum <= 187) then
								if (Enum == 186) then
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
							elseif (Enum == 188) then
								local FlatIdent_729F7 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_729F7 == 6) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (0 == FlatIdent_729F7) then
										B = nil;
										T = nil;
										A = nil;
										Stk[Inst[2]] = {};
										FlatIdent_729F7 = 1;
									end
									if (FlatIdent_729F7 == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_729F7 = 3;
									end
									if (FlatIdent_729F7 == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_729F7 = 2;
									end
									if (FlatIdent_729F7 == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										FlatIdent_729F7 = 5;
									end
									if (FlatIdent_729F7 == 5) then
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_729F7 = 6;
									end
									if (FlatIdent_729F7 == 3) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_729F7 = 4;
									end
								end
							else
								local FlatIdent_5FAF3 = 0;
								local A;
								while true do
									if (FlatIdent_5FAF3 == 15) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_5FAF3 = 16;
									end
									if (FlatIdent_5FAF3 == 25) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 26;
									end
									if (FlatIdent_5FAF3 == 26) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_5FAF3 = 27;
									end
									if (FlatIdent_5FAF3 == 27) then
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
									if (FlatIdent_5FAF3 == 7) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_5FAF3 = 8;
									end
									if (FlatIdent_5FAF3 == 22) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 23;
									end
									if (FlatIdent_5FAF3 == 1) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_5FAF3 = 2;
									end
									if (FlatIdent_5FAF3 == 21) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_5FAF3 = 22;
									end
									if (FlatIdent_5FAF3 == 17) then
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 18;
									end
									if (24 == FlatIdent_5FAF3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 25;
									end
									if (14 == FlatIdent_5FAF3) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										FlatIdent_5FAF3 = 15;
									end
									if (3 == FlatIdent_5FAF3) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 4;
									end
									if (FlatIdent_5FAF3 == 13) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_5FAF3 = 14;
									end
									if (FlatIdent_5FAF3 == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 6;
									end
									if (FlatIdent_5FAF3 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 5;
									end
									if (FlatIdent_5FAF3 == 16) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 17;
									end
									if (FlatIdent_5FAF3 == 18) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 19;
									end
									if (FlatIdent_5FAF3 == 8) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_5FAF3 = 9;
									end
									if (FlatIdent_5FAF3 == 10) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 11;
									end
									if (FlatIdent_5FAF3 == 0) then
										A = nil;
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 1;
									end
									if (FlatIdent_5FAF3 == 11) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 12;
									end
									if (FlatIdent_5FAF3 == 12) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 13;
									end
									if (FlatIdent_5FAF3 == 23) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 24;
									end
									if (FlatIdent_5FAF3 == 20) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_5FAF3 = 21;
									end
									if (FlatIdent_5FAF3 == 2) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_5FAF3 = 3;
									end
									if (FlatIdent_5FAF3 == 19) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 20;
									end
									if (FlatIdent_5FAF3 == 6) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_5FAF3 = 7;
									end
									if (FlatIdent_5FAF3 == 9) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5FAF3 = 10;
									end
								end
							end
						elseif (Enum <= 203) then
							if (Enum <= 196) then
								if (Enum <= 192) then
									if (Enum <= 190) then
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
									elseif (Enum == 191) then
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
											local FlatIdent_2CA5F = 0;
											local Mvm;
											while true do
												if (FlatIdent_2CA5F == 0) then
													VIP = VIP + 1;
													Mvm = Instr[VIP];
													FlatIdent_2CA5F = 1;
												end
												if (FlatIdent_2CA5F == 1) then
													if (Mvm[1] == 61) then
														Indexes[Idx - 1] = {Stk,Mvm[3]};
													else
														Indexes[Idx - 1] = {Upvalues,Mvm[3]};
													end
													Lupvals[#Lupvals + 1] = Indexes;
													break;
												end
											end
										end
										Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
									else
										local FlatIdent_71845 = 0;
										local A;
										local Step;
										local Index;
										while true do
											if (FlatIdent_71845 == 0) then
												A = Inst[2];
												Step = Stk[A + 2];
												FlatIdent_71845 = 1;
											end
											if (FlatIdent_71845 == 1) then
												Index = Stk[A] + Step;
												Stk[A] = Index;
												FlatIdent_71845 = 2;
											end
											if (FlatIdent_71845 == 2) then
												if (Step > 0) then
													if (Index <= Stk[A + 1]) then
														local FlatIdent_7B2B7 = 0;
														while true do
															if (0 == FlatIdent_7B2B7) then
																VIP = Inst[3];
																Stk[A + 3] = Index;
																break;
															end
														end
													end
												elseif (Index >= Stk[A + 1]) then
													local FlatIdent_33E6D = 0;
													while true do
														if (FlatIdent_33E6D == 0) then
															VIP = Inst[3];
															Stk[A + 3] = Index;
															break;
														end
													end
												end
												break;
											end
										end
									end
								elseif (Enum <= 194) then
									if (Enum == 193) then
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
										local FlatIdent_8F54 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_8F54 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8F54 = 4;
											end
											if (FlatIdent_8F54 == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8F54 = 2;
											end
											if (FlatIdent_8F54 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8F54 = 6;
											end
											if (FlatIdent_8F54 == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_8F54 = 8;
											end
											if (FlatIdent_8F54 == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8F54 = 5;
											end
											if (FlatIdent_8F54 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8F54 = 3;
											end
											if (FlatIdent_8F54 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8F54 = 7;
											end
											if (FlatIdent_8F54 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_8F54 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_8F54 = 1;
											end
										end
									end
								elseif (Enum > 195) then
									local FlatIdent_88E94 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_88E94 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = Inst[3];
											FlatIdent_88E94 = 1;
										end
										if (FlatIdent_88E94 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											FlatIdent_88E94 = 4;
										end
										if (FlatIdent_88E94 == 5) then
											B = Inst[3];
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_88E94 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_88E94 = 2;
										end
										if (FlatIdent_88E94 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											FlatIdent_88E94 = 5;
										end
										if (2 == FlatIdent_88E94) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_88E94 = 3;
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
							elseif (Enum <= 199) then
								if (Enum <= 197) then
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
								elseif (Enum > 198) then
									local FlatIdent_67504 = 0;
									local A;
									while true do
										if (FlatIdent_67504 == 18) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_67504 = 19;
										end
										if (FlatIdent_67504 == 14) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_67504 = 15;
										end
										if (FlatIdent_67504 == 6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_67504 = 7;
										end
										if (FlatIdent_67504 == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_67504 = 8;
										end
										if (FlatIdent_67504 == 23) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_67504 = 24;
										end
										if (FlatIdent_67504 == 1) then
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
											FlatIdent_67504 = 2;
										end
										if (FlatIdent_67504 == 17) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_67504 = 18;
										end
										if (FlatIdent_67504 == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_67504 = 13;
										end
										if (FlatIdent_67504 == 15) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_67504 = 16;
										end
										if (FlatIdent_67504 == 10) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_67504 = 11;
										end
										if (FlatIdent_67504 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_67504 = 3;
										end
										if (FlatIdent_67504 == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_67504 = 6;
										end
										if (0 == FlatIdent_67504) then
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
											FlatIdent_67504 = 1;
										end
										if (FlatIdent_67504 == 9) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_67504 = 10;
										end
										if (FlatIdent_67504 == 19) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_67504 = 20;
										end
										if (FlatIdent_67504 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_67504 = 5;
										end
										if (FlatIdent_67504 == 3) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_67504 = 4;
										end
										if (FlatIdent_67504 == 16) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_67504 = 17;
										end
										if (21 == FlatIdent_67504) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_67504 = 22;
										end
										if (FlatIdent_67504 == 20) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_67504 = 21;
										end
										if (FlatIdent_67504 == 25) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_67504 == 13) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_67504 = 14;
										end
										if (FlatIdent_67504 == 11) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_67504 = 12;
										end
										if (24 == FlatIdent_67504) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_67504 = 25;
										end
										if (FlatIdent_67504 == 8) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_67504 = 9;
										end
										if (FlatIdent_67504 == 22) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_67504 = 23;
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
							elseif (Enum <= 201) then
								if (Enum > 200) then
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
							elseif (Enum == 202) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 210) then
							if (Enum <= 206) then
								if (Enum <= 204) then
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
								elseif (Enum == 205) then
									local FlatIdent_98FDA = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_98FDA == 6) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_98FDA = 7;
										end
										if (FlatIdent_98FDA == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_98FDA = 5;
										end
										if (5 == FlatIdent_98FDA) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_98FDA = 6;
										end
										if (FlatIdent_98FDA == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_98FDA = 4;
										end
										if (FlatIdent_98FDA == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_98FDA = 3;
										end
										if (FlatIdent_98FDA == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_98FDA = 2;
										end
										if (FlatIdent_98FDA == 7) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_98FDA == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_98FDA = 1;
										end
									end
								else
									local FlatIdent_7E634 = 0;
									while true do
										if (FlatIdent_7E634 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_7E634 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_7E634 = 3;
										end
										if (FlatIdent_7E634 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_7E634 = 6;
										end
										if (FlatIdent_7E634 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_7E634 = 5;
										end
										if (FlatIdent_7E634 == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_7E634 = 4;
										end
										if (0 == FlatIdent_7E634) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_7E634 = 1;
										end
										if (FlatIdent_7E634 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_7E634 = 2;
										end
									end
								end
							elseif (Enum <= 208) then
								if (Enum > 207) then
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
							elseif (Enum == 209) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							else
								local FlatIdent_57E65 = 0;
								local A;
								local Results;
								local Limit;
								local Edx;
								while true do
									if (FlatIdent_57E65 == 2) then
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										break;
									end
									if (FlatIdent_57E65 == 0) then
										A = Inst[2];
										Results, Limit = _R(Stk[A](Stk[A + 1]));
										FlatIdent_57E65 = 1;
									end
									if (FlatIdent_57E65 == 1) then
										Top = (Limit + A) - 1;
										Edx = 0;
										FlatIdent_57E65 = 2;
									end
								end
							end
						elseif (Enum <= 213) then
							if (Enum <= 211) then
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
							elseif (Enum == 212) then
								local FlatIdent_46A1E = 0;
								while true do
									if (FlatIdent_46A1E == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_46A1E = 3;
									end
									if (FlatIdent_46A1E == 6) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_46A1E == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_46A1E = 1;
									end
									if (FlatIdent_46A1E == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_46A1E = 5;
									end
									if (FlatIdent_46A1E == 3) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										FlatIdent_46A1E = 4;
									end
									if (FlatIdent_46A1E == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										FlatIdent_46A1E = 2;
									end
									if (5 == FlatIdent_46A1E) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_46A1E = 6;
									end
								end
							else
								local FlatIdent_59338 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_59338 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59338 = 2;
									end
									if (0 == FlatIdent_59338) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_59338 = 1;
									end
									if (FlatIdent_59338 == 7) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_59338 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59338 = 5;
									end
									if (FlatIdent_59338 == 6) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_59338 = 7;
									end
									if (3 == FlatIdent_59338) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59338 = 4;
									end
									if (FlatIdent_59338 == 5) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59338 = 6;
									end
									if (FlatIdent_59338 == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59338 = 3;
									end
								end
							end
						elseif (Enum <= 215) then
							if (Enum > 214) then
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
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum > 216) then
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
						VIP = VIP + 1;
						break;
					end
					if (FlatIdent_33EA4 == 0) then
						Inst = Instr[VIP];
						Enum = Inst[1];
						FlatIdent_33EA4 = 1;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!56052Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E73657274025Q0060804003043Q0042FF0C1D03053Q0024109E6276025Q0058804003403Q006155F7AEFF6053F3AFAD6506F0A7AD6053A2FDAF675DA7A9AE3056F5ACFF3055A42QAF6300F4FDFA3753F3A9FA3753F5A9FA6555F5FDFC34502QA9AE6153F0A903053Q009E5265919E025Q005080402Q033Q00D42DFC03083Q00BE957AAC90C76B59025Q0048804003093Q0083E4DC38162410B4EF03073Q007FC69CB95B6350025Q0040804003133Q009482180319D1841E0E1ED38D1A0F1AD2841D0D03053Q002FE4B5293A025Q0030804003043Q00B8E2B83E03053Q007EEA83D655025Q0028804003243Q00EC44758F148555E45020DB16D14CE54C278C08DA57E4456FD215D504E21B748F13DA57E703073Q0061D47D42EA25E3025Q0020804003043Q00761E06E003073Q00AD2E7B688FCE51025Q0018804003093Q0065FCE3CE55F0E9DF5303043Q00AD208486025Q0010804003143Q00CC0E9CE97C4BB0B38A0A99E0784CB7B28D089FE003083Q0081BC3FACD14F7B87026Q00804003043Q00BF7DE32003043Q004BED1C8D025Q00F07F4003243Q00C876B12B29BCCB2EFF2423E79462E32C75E08076B02A27A8957FE47826E39B2AE42426B603063Q0085AD4FD21D10025Q00E07F4003043Q00C00DCB5203053Q00A29868A53D025Q00D07F4003093Q00FFBE7041CFB27A50C903043Q0022BAC615025Q00C07F4003143Q0068AE4E172BA64B1D2FAC4F102BA64B1028AF4A1503043Q0025189F7D025Q00A07F4003043Q006FB6FDD603063Q007E3DD793BD27025Q00907F4003243Q00B6D7440576D231E49E1C562BD07EB18218563FDF60E1D6500822D136B6D54B5524DE65B303073Q005380B37D3012E7025Q00807F4003043Q00D7C7534603053Q00908FA23D29025Q00707F4003093Q00E3BB1E8ADAD2AC099A03053Q00AFA6C37BE9025Q00607F4003133Q00E0592627138AA05C2B251382A45B2B241282A403063Q00B3906C121625025Q00407F4003043Q0094B759D803043Q00B3C6D637025Q00307F4003803Q00827A8FAC87798FA5877B8AA5877D8FA7827B8AA282788FA082718AA6827A8AA5877B8AA182788FAC87798FA382798AA1877E8FAC827B8FA182788FAC87798AA7827B8FAC82798FA5877E8FAD877C8FA3827B8AA5827A8FA187798FA087798AA2827D8AA7827F8FAD82718FA082708FA582788FA582798FA0827E8AA082718FAC03043Q0094B148BC025Q00207F4003063Q006441E4CA467E03063Q001F372E88AB34025Q00107F4003093Q00E037FDAAED6904D73C03073Q006BA54F98C9981D026Q007F4003143Q00DB8F7C53A0938B7550A19B8F7451A79D8A7952AE03053Q0097ABBE4D65025Q00E07E4003043Q006ADF1F7103073Q00AD38BE711A71A2025Q00D07E4003603Q00DB080B7E840A5B7BD0520F78872Q5B7CD05B097DD75D5B79D60F5B2DD45E592ED6095B79D15B5F73810A027ED50D5E78D1585E2AD10E5B7DD4525C29875D0F7B875E0D78D50E0C78D25E0F7DD00F0B2E875C0C7880580B78830E592FD2520A7803043Q004BE26B3A025Q00C07E4003043Q00E5B2D64303073Q0099B2D3A0265441025Q00B07E4003093Q00E3E1FC553164C9EBEA03063Q0010A62Q993644025Q00A07E4003133Q00D59AD2E3FF9C97D5E5FB9290D4E0F69590D7E703053Q00CFA5A3E7D7025Q00807E4003043Q00CC730BD403043Q00BF9E1265025Q00707E4003243Q008F1FF2F98B1CF7AC9648F0FF8906F0FCDE4FECF48E1FA0E0831BF7A88D4DF7A88D12F7FE03043Q00CDBB2BC1025Q00607E4003043Q003438B72B03053Q00216C5DD944025Q00507E4003403Q0029F61E5047761620A14D554325112BA24E514475422FA6410643704578AC1A524326157DA61D574625457CF14A0046231520A74B5B4C22112FAD4B064670107A03073Q0073199478637447025Q00407E4003083Q002EAC86A234780FAC03063Q00197DC9EACB43025Q00307E4003093Q00D8F9535B10E9EE444B03053Q00659D813638025Q00207E4003133Q00EA77642Q106EE36DAF7966131F6CEF6CA3776403083Q00549A4E54242759D7026Q007E4003043Q001C8AED0D03043Q00664EEB83025Q00F07D4003243Q007DF514FD7AAC46F335FE12A779E012F57DAB0EA529AE15E920FD15A12EAB15A12EF415F703043Q00C418CD23025Q00E07D4003043Q003FCD7B0703053Q00D867A81568025Q00D07D4003093Q00FDF0F94E54A5D7FAEF03063Q00D1B8889C2D21025Q00C07D4003143Q001BB171BE72966E295BB873B67D9C6F2A59B673BF03083Q001F6B8043874AA55F025Q00A07D4003043Q0016BAC0BE03043Q00D544DBAE025Q00907D4003803Q00862D01BBE9862D02B8EB832D04BBEC82280EBDEE832B04BCEC892D05B8EC832A01BDEC872800B8EE832E01BDE984280FBDEA832204BEEC832806B8EE862F01BDEC822D05BDE7832304BDE9832804B8ED832D01BFEC842801B8EA832804B9EC872D03B8ED832804BDEC81280FBDEC862E01BCEC882D05B8ED832D04B7EC87280603053Q00DFB01B378E025Q00807D4003063Q00825C70D46B3B03063Q005AD1331CB519025Q00707D4003093Q0097C0DF760D29C02BA103083Q0059D2B8BA15785DAF025Q00607D4003143Q00E01E08DFA4180CD2A41B0BD5A9180DD3A31609D103043Q00E7902F3A025Q00407D4003043Q00172BA24A03073Q00C5454ACC212F1F025Q00307D4003243Q00BCBF174AA3B0B91757ADB1B41557AAB4E84057FAE1BE1557A3B5BB434CFDB3E81043ADB603053Q009B858D267A025Q00207D4003043Q00CF1FAAC903083Q002E977AC4A6749CA9025Q00107D4003093Q006906DFA3A55811C8B303053Q00D02C7EBAC0026Q007D4003143Q006247610695642A436502916321406305906F224703063Q005712765031A1025Q00E07C4003043Q0062EBF6C303053Q0021308A98A8025Q00D07C4003403Q005D742FE0F3101A6B09247DE3FD401D6F5D2079E2F44C443958722AB1F217496A5A212CE7A44D4A6C087471B5A0141F3D5A217AE5A6431D6D0B767FB5A6421A3A03083Q00583C104986C5757C025Q00C07C4003053Q00F7E60E511E03083Q0076B98F663E70D151025Q00B07C4003243Q00834DB301E8D14DE148B3831DE148BAD649B248B2D74FE548B3D71AB353EDD149E05CBDD403053Q008BE72CD665025Q00A07C4003043Q008D2BBA7203053Q00E4D54ED41D025Q00907C40034A3Q00B1A3B995D9EAA8F7BFC5DCBBB4EBEF91DEB4E0F1F791DBE8B0F2BB8A8BEEE6F5EA91C5EFB3F6BB93DDA1B5A4BB918EE8A8A7E9C38DB4B7EBEE9F8EBAB7A4F7C2DFB9E1F5BC8AD9EEB7F003063Q008C85C6DAA7E8025Q00807C4003053Q00C809D0E42203073Q00AD9B7EB9825642025Q00707C4003403Q00FD63F7B1E7BEAF67A7EFBCEAAE31F2B6E5BFAC67A4E5B4ECAD33F5E2B3EDA964A0B4B0E9AA65A7E7B5B9AE36F2E7B7BEAB36A7EEB3BBAD64F22QE5B9A836A1B603063Q00DA9E5796D784025Q00607C4003023Q007FB403043Q001331ECC8025Q00507C4003093Q00A0FBEADA16B28AF1FC03063Q00C6E5838FB963025Q00407C4003133Q009D1FD6BE22E3D511DCBA28E4DE1CD0B829E0DC03063Q00D6ED28E48910025Q00207C4003043Q00B92FBB2B03073Q008FEB4ED5405B62025Q00107C4003243Q00DC8ED8FEA412FE73C58DD9FEA55BF7728DDD90F4F346A56ED02Q8BA9F710F026DE828BFF03083Q0043E8BBBDCCC176C6026Q007C4003043Q00F9F08B1A03073Q00B2A195E57584DE025Q00F07B4003093Q0018082BFBC92B32023D03063Q005F5D704E98BC025Q00E07B4003143Q00D75F074897580247925B024B9157064F9356024903043Q007EA76E35025Q00C07B4003043Q002BE94CBB03053Q005A798822D0025Q00B07B4003243Q00A7AD757747ACF9256F15F0FE226F12A4FD216F1AA7AB746F1BA5AE227445A3FD717B15A603053Q002395984742025Q00A07B4003043Q002F36870703043Q00687753E9025Q00907B4003403Q007BFD2BF8D22BAF7EFFD378A824F8D62FA97DFDD42FFE2BF88775A979FE8428FC24FA8174FD7AFD852CFC7DFED67BFD2BFD8575F379F8D17EAC2FFFD57EAC25FC03053Q00B74DCA1CC8025Q00807B4003053Q00E6504D75EB03063Q001BA839251A85025Q00707B4003093Q007A30AB07434B27BC1703053Q00363F48CE64025Q00607B4003143Q000E90F0B6E4214C91F5B0EE244692F4BCEC244E9103063Q00127EA1C084DD025Q00407B4003043Q0048E7EB3303073Q00741A868558302F025Q00307B4003243Q0085B0A67C8FEAA67F9ABFA77E8EA5F37DD2EBEF2ED2BEFB618FB8F42981EEF42981B1F47F03043Q004CB788C2025Q00207B4003043Q00B51D144203043Q002DED787A025Q00107B4003093Q0006CC712AC4E22CC66703063Q009643B41449B1026Q007B4003133Q00ED93FBB1FCA3A493FEB1FEA4AE9EF4B4F9ACAE03063Q00949DABCD82C9025Q00E07A4003043Q0042ABAEE103053Q001910CAC08A025Q00D07A4003243Q00474A19375B0BF942064E375A04E2121A1E31465EF8471F566D5B0AAA152Q4D305D05F91003073Q00CF232B7B556B3C025Q00C07A4003043Q0019D8B47D03053Q006F41BDDA12025Q00B07A4003093Q0078F4418948F84B984E03043Q00EA3D8C24025Q00A07A4003133Q005A834E818054E71C82442Q8455EF198943828103073Q00DE2ABA76B2B761025Q00807A4003043Q00DE20260D03083Q004C8C4148661BED99025Q00707A4003243Q00528720F5D85A8224EBDC008874EBD952D526EBD157D273EBD0538627F08E55D574FFDE5003053Q00E863B042C6025Q00607A4003043Q001827E3AA03083Q008940428DC599E88E025Q00507A4003093Q000600DB293D3742310B03073Q002D4378BE4A4843025Q00407A4003133Q00E0DFFC45FCE5A9D8F841FEE6A2DFFA44F5E2A003063Q00D590EBCA77CC025Q00207A4003043Q00298D773F03043Q00547BEC19025Q00107A4003243Q00AC580D7AE9AD5E0936EEAC2Q0D36B9AD0C5C36B1AE5C5E36B0AC5F5A2DEEAA0C0922BEAF03053Q00889C693F1B026Q007A4003043Q009FB2C7D303043Q00BCC7D7A9025Q00F0794003803Q0078A9D945927BAAD9409778ADDC43927CAFDE409278A9D946927FAADC409378A8D941977AAFDA459378A8D944977CAFDB45937DA8DC44927CAFDA459878AFDC459277AFD8459578ADDC42927FAADF45927DAFDC449278AFD345947DA5D94F9279AFD3409278AED944977DAFD340977DAAD94F977AAAD940977DA4D941927CAADB03053Q00A14E9CEA76025Q00E0794003063Q00B321B34AC5EA03073Q00BDE04EDF2BB78B025Q00D0794003093Q0019E7E6C7C9B7372EEC03073Q00585C9F83A4BCC3025Q00C0794003133Q00AAB44EB4B5EDB14ABFBDEBBB4F2QB5EEB64FBE03053Q0085DA827A86025Q00A0794003043Q00EC8A713403063Q0046BEEB1F5F42025Q0090794003803Q00EBBA69F59FE8B86EF399EEBB6CF19FEFB86BF398EEB96CF09FEBB86AF399EBB96CF69AE8B86BF39BEEB36CF39FE9B86EF39CEEB36CF49AEEBD6BF39FEBBA69F29FEBBD69F39BEEB86CF09AEAB86FF39EEEBA69F49AEEB86AF39FEEBD69F29FE9B868F390EEB36CF19AE9B86CF39DEBBF6CF49FECB86DF39BEEBB6CF19AEABD6B03053Q00A9DD8B5FC0025Q0080794003063Q00D5F086A2C3E703053Q00B1869FEAC3025Q0070794003093Q00C8BD827805A75C2EFE03083Q005C8DC5E71B70D333025Q0060794003143Q0093A1F9DB8DE7D7A9F9D289E6D2A6FADF8AE7D0A603063Q00D6E390CAEBBD025Q0040794003043Q0097F146CF03043Q00A4C59028025Q0030794003243Q00474A9A0A9C8FEA43519A5F908CF7464DCA588581B8121E8206988FBF411A995B9E80EC4403073Q00DA777CAF3EA8B9025Q0020794003043Q002218301703073Q00447A7D5E785591025Q0010794003093Q0030BAFA1B2E01ADED0B03053Q005B75C29F78026Q00794003133Q000A70035B7BB543BE4A74015979BB43B74F710B03083Q008E7A47326C4D8D7B025Q00E0784003043Q0078FFAC4903063Q00412A9EC22211025Q00D0784003243Q00C321FBFD1AC275F9B5129E22A2B51B9671FCB54BC121FBB5129722FFAE4C9171ACA11C9403053Q002AA7149A98025Q00C0784003043Q00B54CE44703043Q0028ED298A025Q00B0784003803Q0085F2B1912FE380F5B4942FE285FEB1932AE280F4B49E2FE685FEB4912AE485FFB1922FE585FEB4952AE780F5B1922AE180F5B1922FE485F3B1922FE685F6B4962FE685FEB4972FE380F0B49E2AEF85F7B4932AEF85F4B4912FE185F5B1952AE185FFB4962FE485FEB4962FE485F2B1962FE680F5B1952FE185F1B4972AEE80F303063Q00D7B6C687A719025Q00A0784003063Q001700AE46360E03043Q0027446FC2025Q0090784003093Q00E926BAF3D92AB0E2DF03043Q0090AC5EDF025Q0080784003133Q0041FF51A644420A02FD51A348440B03F055A04D03073Q003831C864937C77025Q0060784003043Q00BF31F62F03063Q0081ED5098443D025Q0050784003803Q00B474FB0B7022B47FFB0E7524B47CFB0C7023B47CFE0C7024B179FE0A7526B47CFB0E7525B17EFB0F7526B17AFB0A7023B47DFE0A752EB478FE0A7521B17FFB097520B17AFE0D7523B47DFB01752EB17DFB0C752FB474FE0C7025B474FB0E7525B178FE0A7524B47AFB017523B47AFB0F7523B479FE0B7524B47DFE0C7024B47B03063Q0016874CC83846025Q0040784003063Q001BAEC87D0C2203083Q004248C1A41C7E4351025Q0030784003093Q001D26E6F9FCFEDCA32B03083Q00D1585E839A898AB3025Q0020784003133Q004B6BF817AC0267FD16A40F62FF14AB026AFB1403053Q009D3B52CC20026Q00784003043Q008AB9123703043Q005C2QD87C025Q00F0774003803Q001B457FBA1E427ABE1E417ABB1E447FB81B427ABC1E437ABB1B427FBA1E407ABA1B407FB71B437FBA1E477FB81B407FB71E497FBE1B427FBA1E417ABD1E497FBD1E487FBB1E437FBA1E477ABC1B477FB71E427FBF1B457ABE1B437FBD1E437FB61E487FBB1E457ABB1B427FBD1E487FBC1B427ABE1B407FBA1E447FBE1E477FBB03043Q008F2D714C025Q00E0774003063Q00FFC28E7054CD03053Q0026ACADE211025Q00D0774003093Q00D63F151C2Q0FFC352Q03063Q007B9347707F7A025Q00C0774003143Q00D49C146DA25BA12Q9D1065AB5FAD9299166EA45603073Q0095A4AD275C926E025Q00A0774003043Q004EDBD65603073Q00B21CBAB83D3753025Q0090774003403Q00528E6E2651DB692405D8672709D26E7208DE3B2208DD3A2755D83D20068D382E55D93B2106D86F7100DE6673538A6B2E03D36D74038E6C2101DA6A2604DA382E03043Q001730EB5E025Q008077402Q033Q00E2BEF403063Q00B5A3E9A42QE1025Q0070774003243Q00D19673B4A64CBA18C8C474E0A253EE1180C36AE3FC4FEA0DDD9571E4F218E945D39C71B203083Q0020E5A54781C47EDF025Q0060774003043Q00160BF5F903043Q00964E6E9B025Q0050774003093Q009B68DFC416A18C03AD03083Q0071DE10BAA763D5E3025Q0040774003133Q00D35E1B831327709B571180162870925211811F03073Q0044A36623B2271E025Q0020774003043Q001ADA538903063Q001F48BB3DE22E025Q0010774003403Q00932DB24404932BB44353902BB547579A2CB01606C129B54500C225E34754957FE316579B2BB31001902BBE4B009B2FE34607C678B1170F9A2FB24355C57EB31303053Q0036A31C8772026Q0077402Q033Q00D60D7D03073Q00D9975A2DB9481B025Q00F0764003093Q0096CEC8C2DCB54AA1C503073Q0025D3B6ADA1A9C1025Q00E0764003143Q00AA2E83220E48EC2D8B250D4BEC268A2B0C4EE32A03063Q007ADA1FB3133E025Q00C0764003043Q001D1F2Q2103063Q00674F7E4F4A61025Q00B0764003803Q00D79702AB9A0BD79502A69F0ED29E07A69A0CD79307A19F0AD29702A79F0AD79407A79A0FD79202A29F09D29502A79F0DD29402A29F0ED29E02A09A04D79502A09F0ED79207A79A0CD29307A69F0FD29F07A79A0DD79707A19F0AD29207A19A0CD29502A79F09D29102A49A05D79202A79A0ED79502A39F0ED79002A59F0ED29203063Q003CE1A63192A9025Q00A0764003063Q00CC3C050B20F903063Q00989F53696A52025Q0090764003093Q008FA9E8E462FA48B8A203073Q0027CAD18D87178E025Q0080764003133Q0004DEDD62700E47D8D164730D40D8D26F74094103063Q003974EDE55747025Q0060764003043Q00650D305403073Q0042376C5E3F12B4025Q0050764003803Q00D88D63B5D0426351D88863B3D5446350D88D63B2D54A6354D88F63B3D5436655D88F63B2D54A6357DD8E66B6D0456351D88A63B3D5406354D88866B1D0406657D88866B5D0466356DD8C66BFD0426352D88B66B3D5406355D88B66BFD54B6351DD8966B1D0456652D88A66B6D0416350DD8866B0D0466357DD8966B0D546635103083Q0066EBBA5586E67350025Q0040764003063Q002DEF79CBF88A03083Q00B67E8015AA8AEB79025Q0030764003093Q00711E82B5B0A48B461503073Q00E43466E7D6C5D0025Q0020764003133Q00081BB49B5505134F1ABA9B5F06184017B59E5603073Q002B782383AA6636026Q00764003043Q003041E3F803043Q009362208D025Q00F0754003803Q0003AF50E90C2FAF2C03AE50EA092EAF2C03A855EB0C26AF2C03AE55EC0C2DAF2E03AE55EB0C2CAA2F03A950EE0929AA2B03AF55EF0C2FAA2D06AD55EF0C26AA2C03AF50EA0C28AA2A03AB50EC0C26AA2F03AC50EE092BAA2903AA55EA092CAF2B06AC50EE092CAA2203A055EF0C2FAF2C03A855E6092CAA2806A855E80C2AAA2E03083Q001A309966DF3F1F99025Q00E0754003063Q00CCEFBEB81A3F03063Q005E9F80D2D968025Q00D0754003093Q006922E6AD1C5835F1BD03053Q00692C5A83CE025Q00C0754003133Q00C59CA5F6F3A52CEC8D9AA2FBF7AF24E78C99AF03083Q00DFB5AB96CFC3961C025Q00A0754003043Q002EFA04E903043Q00827C9B6A025Q0090754003803Q00104DE9FF5421104DECF551261047E9F7512A104DE9F15122104FE9F65427154AE9FF5422104EECF65121154AECF45120104DECF254221047ECF654261048E9FF5124104FE9F554261048ECF65422104AECF451261046ECF55426104BECF251241549ECF55425154CECF154261549ECF15426104AE9F25427104DECF65127154D03063Q0013237FDAC762025Q0080754003063Q000B3D1F822A3303043Q00E3585273025Q0070754003093Q00AF071CA5C99E100BB503053Q00BCEA7F79C6025Q0060754003133Q00E1731DBF8DA0741CB688A3741DBE8DA67D19BE03053Q00B991452D8F025Q0040754003043Q002A7F2D4003053Q00CB781E432B025Q0030754003803Q00D50483450E68D50283420B6ED00E83430B6CD00083410E6FD00186400E6CD00686410B6AD00F83470B6DD50383460E6AD50383400E6CD00683430B69D50483430E6AD50183470B6AD00283410E67D00683410E66D00483410B6ED50283470E69D006834C0B6BD00486470B69D00E83460E69D00486400B69D00F834D0B6CD50103063Q005FE337B0753D025Q0020754003063Q0001EC843C2Q5B03063Q003A5283E85D29025Q0010754003093Q00DCCF0FA0ABC65BBAEA03083Q00C899B76AC3DEB234026Q00754003133Q001D01606977AB540D6F6877AE590E6E6F75AF5C03063Q00986D39575E45025Q00E0744003043Q0078B612DE03073Q00C32AD77CB521EC025Q00D0744003403Q00D1B82A52D2EC2B0487BC770683ED780280EF7F5ED7E97A54D0EF2E0287BF7D04D5EC2D5E87BD2A06D1E17E01D5B8295582EC2C0682BC7756D5B82D0686E97F5303043Q0067B3D94F025Q00C0744003083Q00E387B5FA14E2C6D503073Q00B4B0E2D9936383025Q00B0744003803Q001592A5BF2FBF1599A0BF2FBF159FA5BB2ABA1598A0B92ABD159FA0B02FBE1599A0BF2FBE109AA5BC2FBB1592A5BF2AB91598A0BF2FBC159CA5BA2FBC1099A5BA2FBF159EA0B12ABA109AA0BE2ABB159BA5BC2FB6159EA0BE2FBF1099A0B82ABB1598A5BB2AB9109EA0BC2FBC109AA0B02FBF1099A0BD2FB7159CA0B82FBD159F03063Q008F26AB93891C025Q00A0744003063Q00152429BEF32703053Q0081464B45DF025Q0090744003093Q00C65DB3B508A1EC57A503063Q00D583252QD67D025Q0080744003143Q00AF676DD2E8A0B7EB646ED4E1A6B4EC666AD0E2A003073Q0083DF565DE3D094025Q0060744003043Q0079C21AE603063Q00C82BA3748D4F025Q0050744003803Q005FAAAED9225AA1A4DB275FA2AEDC2255A1AEDE225FA1AEDC2259A4AFDB285FA5AEDC275FA4A9DE255AA3ABDB275FA1ABDB255AA7ABDB2759A4ACDE205FA6ABDB225FA4A9DB245FA3ABDC2759A1AADE225FA3AEDF2259A4AEDB285FA4AEDC2759A1ACDB285FA0AEDF2259A4ACDB275AA1ABDE2758A1A8DE205AA7ABDE2254A4AC03053Q00116C929DE8025Q0040744003063Q004B85C242BD5303083Q003118EAAE23CF325D025Q0030744003093Q003BA8030B0DFC11A21503063Q00887ED0666878025Q0020744003133Q00E1B66974F5A8B0687AF0A2B06371F1A0B6687603053Q00C491835043026Q00744003043Q00D4052F3203073Q001A866441592C67025Q00F0734003243Q0079BFEA627CECEA6F60E2B86A7BF6BF6B28BEA3622FBFBB7775EBB83F7BBDB83F7BE2B86903043Q005A4DDB8E025Q00E0734003043Q002DF3FE1603063Q0026759690796B025Q00D0734003603Q00D5A6D5EC3ED4A287E969D8A281EB6AD9F184E96FDAF183E9648EA2D4ED6BDAA484B66588F4D6EC6888A887BD6EDAA981BA64DDF481BF69DCA1D3EA64D9A5D0BB3BD9F4D3B83EDAF1D5ED3C8CA1D1B76888A880BD6589A986BE3CD9F4D3B938DA03053Q005DED90E58F025Q00C0734003043Q00640A627603053Q005A336B1413025Q00B0734003093Q00E623E811ED22CC29FE03063Q0056A35B8D7298025Q00A0734003133Q0015D04246821E0A54DD454386180651DB46438303073Q003F65E97074B42F025Q0080734003043Q003DAEA01803083Q00B16FCFCE739F888C025Q0070734003243Q007BDB9CFFB68914216F8F95F1E6C1462027DD88FFB0DE433C7A8F93A3B18A412Q748693F503083Q001142BFA5C687EC77025Q00607340030F3Q00A28BDAD27887A8FD826CC899ECCC7B03053Q0014E8C189A2025Q0050734003243Q0023B86B2DD73078DB37EC622387782ADA7FBE7F2DD1672FC622EC6471D0332D8E2CE5642703083Q00EB1ADC5214E6551B025Q0040734003043Q00C6A6C77803053Q00349EC3A917025Q0030734003093Q009027E22541940DA72C03073Q0062D55F874634E0025Q0020734003133Q00C781146A838117698081106A868A17678E811603043Q005FB7B827026Q00734003043Q00CA2E302303083Q0024984F5E48B52562025Q00F0724003603Q00EFB1F14B8BAAA6EEE2F74FDCF6A8EFB0F44CD9A2A3E8E5FF48DDF7A9EFE3F74CD0F0A0BCE2A448DDF0F2E0B7F21EDCF1A9B8E0F74BDE2QF1E0B1A44CD1F0A8EEB5A21E8DA3A0E9B0A11ADDF6A0E9E0F34A8AAAA6E0B2A64BD8A7A2BDB2FE4C8903073Q0090D9D3C77FE893025Q00E0724003043Q003788FFBB03043Q00DE60E989025Q00D0724003093Q00C51B272QEAD0EF113103063Q00A4806342899F025Q00C0724003133Q00A1EA597FAF8EF8E6EA5A78A68CF8E5E75B75AE03073Q00C0D1D26E4D97BA025Q00A0724003043Q00CB3E16EF03043Q0084995F78025Q0090724003403Q00D98DF581808FDEF48285838DA1D385DFDAA1D08ADE87FB81D2DB8FA1D6D2DB8EA782D1838BFBDFD18C8EA782D08D8BF0D5D78D8FF3D2878CD9F281868ED9A0D103053Q00B3BABFC3E7025Q008072402Q033Q0099EA4603083Q0046D8BD1662D23418025Q0070724003243Q00EA99D1691DB89A807216BD9AD5721EE8CBD47217E199D27217E998D56949EFCB866619EA03053Q002FD9AEB05F025Q0060724003043Q0015E925D503073Q00E24D8C4BBA68BC025Q0050724003803Q00BB7BFF1B24E992E9BB7BFF1A24E992EBBB7EFA1F21EE92EDBB7AFA1E21E897EDBE79FA1F24EE97EEBB7AFF1C21EF97EEBB7CFF1E21ED92EBBE79FA1D21EA92EABB7BFA1E24E897EABB7BFA1C21EF97EABE7BFA1C21EE92ECBE7CFA1E21E892E8BB79FA1721EE92EFBB74FF1D24ED92EFBB74FA1921E492EDBE78FA1B24ED92E003083Q00D8884DC92F12DCA1025Q0040724003063Q0041E7C8A2194203073Q00191288A4C36B23025Q0030724003093Q000B533BD64405F33C5803073Q009C4E2B5EB53171025Q0020724003133Q00B3F3989B6B72DD2QF2FF9F996E73DAFBFAFF9903083Q00CBC3C6AFAA5D47ED026Q00724003043Q003A3D144B03073Q009D685C7A20646D025Q00F0714003403Q00D47028F4B6D4AA4282252DA2E38DAF418F737DF1B3DEAF4487737DFAB7DBA846857479F2BED8F54ED7247AF7B1D8F814852C28A6B0DDFD14D4252FF3E6DAF54603083Q0076B61549C387ECCC025Q00E071402Q033Q0081743503043Q008EC02365025Q00D0714003603Q0001C606AD1266F40C9554A21762AF5E9404FB4236A5019156A31765F25BC40FFC1165F1089652AA4260A5099203A31765A7019156AC1266A20A9306FF1632F20DC307AA4562A40CC703FE146BA15E9554AA1A64A00F9403FE4231AF0EC055AA4703073Q009738A5379A2353025Q00C0714003043Q00D9BCEE8603063Q00B98EDD98E322025Q00B0714003803Q00EEBF77F5940DEEB077F3940FEEB672F49405EEB777F2910FEBB677FF910EEEBE77F39108EEB177F2940AEBB372F29408EEB777F2940BEBB372F0940CEEB377F0940FEEBF77F1940EEEB577F6940CEEB077F6940EEBB477F7910FEEB672F29405EEBF77F4940AEEB172F5910FEEB377FE940FEBB172F5940BEBB377F79409EEBE03063Q003CDD8744C6A7025Q00A0714003063Q00D6B25B31DD3503063Q005485DD3750AF025Q0090714003093Q00A9C013DAAD4483CA0503063Q0030ECB876B9D8025Q0080714003133Q00EC04AE06022FAE03AA030623A503AC0D0B22AC03063Q001A9C379D3533025Q0060714003043Q001C821E4D03063Q00BA4EE3702649025Q0050714003803Q007FF863607AFD636F7AF8636A7FF8636A7AF963607FFD63687AFC63607FF9666C7FFE63607AFD636F7FF9636D7AF4666A7AFF63697AFB666C7FFA666A7AF8636E7FF9636C7AF9636A7AFD636B7AFA63697FF866697FF8666E7AFD63607FF8636D7AFB666E7AF4636D7AFD666B7AFA666E7AFB666D7FF8666D7AFF636E7FFE666C03043Q005849CC50025Q0040714003063Q000FD2CF12273D03053Q00555CBDA373025Q0030714003093Q007BD9AE25DA4ACEB93503053Q00AF3EA1CB46025Q0020714003133Q003C20B7007D2EB20B7C20B1097429B70F7C29B603043Q00384C1984026Q00714003043Q001829AF4803053Q00164A48C123025Q00F0704003803Q00B9E477B2166CBCE777B6136EBCE077B21669B9E677B4136AB9E777B7166EB9ED77B1136CBCE077BA1367B9E277BB1366B9E277B1136CBCE472B1136CB9E472B01369BCE477B71369BCE777B4136AB9EC77B61368B9E777BA166DB9E172B5136EBCE677B6166DB9E172B2166EB9E377B01369B9E677B4136BBCE077B7136CB9E503063Q005F8AD5448320025Q00E0704003063Q00795784E3585903043Q00822A38E8025Q00D0704003093Q002Q91D52D29B93AA69A03073Q0055D4E9B04E5CCD025Q00C0704003143Q009406AF0CD306AA03D507A60AD700A70FDD0FAF0B03043Q003AE4379E025Q00A0704003043Q0023A7A3A503063Q007371C6CDCE56025Q0090704003803Q00A918B4A924AD1FB6AA22AC19B4A821AB1FB2AF25AC19B1AB21AB1FB2AF2FAC18B1A524AF1FB5AF25AC1DB1AA21AB1FB6AA24A91DB1AF24A91FB2AA23AC1EB1A824A81FBAAA21A91BB1A824A31AB0AA25A91CB1A821AE1AB0AF2EA91FB1A924AB1AB0AF24A919B1A524A31FB2AF25A91FB1AC24AE1AB4AA21AC18B4AF21AE1FBA03053Q00179A2C829C025Q0080704003063Q009E255F4DA4AC03053Q00D6CD4A332C025Q002Q704003093Q009F9E7CF04ADA2BA89503073Q0044DAE619933FAE025Q0060704003143Q003C010DE09BFF72750604EA91F92Q740509E197FD03073Q00424C303CD8A3CB025Q0040704003043Q00722QA9E803053Q007020C8C783025Q0030704003803Q00AE7656455A71AE7256435A78AE74564B5A71AB7053445A78AE7E53445A74AE7353415F72AE7556465F73AE7656475F74AE7353445A74AE7353415A71AB7253465A76AE7053415A77AE7556445A71AE7753465F76AB7356435A75AB7456465A74AB7356415F73AB7053475F76AE7653435A74AE7753465A75AB7056415A70AE7103063Q00409D46657269025Q0020704003063Q00750CE52D411703063Q00762663894C33025Q0010704003093Q0086ABE7C2D3177F6AB003083Q0018C3D382A1A66310026Q00704003133Q00FB9CE2B69DBC93E7B09DBA9CE4B096BD97E5B703053Q00AE8BA5D181025Q00C06F4003043Q001E08E80703043Q006C4C6986025Q00A06F4003803Q00BBAD5BA1AB86BEA95EA5AB8FBEA75EA0AB82BEA95BA1AE85BBAF5BA2AB80BBAA5BA0AB84BBAF5EA7AB80BBAD5BA6AB86BEAE5BA0AB80BBAB5EAAAB8FBEAE5EA6AB8EBEAB5BA5AE84BEAD5BA1AB81BEAA5BA0AB83BBAF5EA3AB83BBAB5EA1AB84BEAA5EA3AE86BEAC5EA1AE82BEAF5EA2AB81BEA65BA2AB86BEAF5EA7AE86BEAB03063Q00B78D9E6D9398025Q00806F4003063Q009CC4CDCFBDCA03043Q00AECFABA1025Q00606F4003093Q008C10DB822ABD07CC9203053Q005FC968BEE1025Q00406F4003133Q0019FA64255EFB6D275CFC6E2150F96F265DFD6403043Q001369CD5D026Q006F4003043Q006FB4AC8C03043Q00E73DD5C2025Q00E06E4003243Q005C82A51708D3A2144685A61D5BCAF5150E81E91D5FD1FC0953D7F2415D81F2415DDEF21703043Q00246BE7C4025Q00C06E4003043Q00305C075003043Q003F683969025Q00A06E4003803Q0066DB2D0B81FEE78C66D5280B84FBE78B63D9280784FDE28A66DD2D0A81FAE78C66DD2D0A84FBE28A66D4280781FFE78C66D4280981F9E28C66DA280681FDE78966D42D0984FDE78F66D82D0D81F6E78066DC2D0E84FEE78966D4280A84F9E78166DA280881F7E78D66DF2D0B81F7E78E63DF280E84FEE78166DA2D0A81FDE78903083Q00B855ED1B3FB2CFD4025Q00806E4003063Q0097EF41B2F60103063Q0060C4802DD384025Q00606E4003093Q00DC0CC3FF99B5FF27EA03083Q00559974A69CECC190025Q00406E4003143Q003D65F48923FB80D17B67F38F2FF680D37467F28D03083Q00E64D54C5BC16CFB7026Q006E4003043Q00978B0BC503063Q0016C5EA65AE19025Q00E06D4003803Q007A80954EA193BE197F84954DA196BE127F86904FA195BE1E7F82954EA490BE197F839543A191BE1D7A82954AA199BB1C7A839049A198BB1C7A879548A497BE1B7F80904CA193BE1B7F819049A191BE137F859548A195BE1F7F859542A190BE1F7F83954FA198BE1F7F809048A196BB1E7A829049A492BB187A85954BA193BB1E03083Q002A4CB1A67A92A18D025Q00C06D4003063Q008458C91C33BF03063Q00DED737A57D41025Q00A06D4003093Q0050A95E49C361BE495903053Q00B615D13B2A025Q00806D4003143Q000A1371F66B1ABC5E4B1473FB6E1AB558421174F303083Q006E7A2243C35F2985025Q00406D4003043Q0036EEAAC803063Q003A648FC4A351025Q00206D4003803Q006F148FE6A92B5E65168BE2AC2B5B6F108FE4AC2C5E69168FE7AC2B596F138FE0A9255B6A1688E7AE2E586A178FE4A92A5E68138FE2A92E5D6A108FEDA9295E6E168BE2A92E5E6A168AE5A9255B6A168FE7AA2E5D6A178FE3A92F5E6C168BE2AB2B5C6F108FEDA92C5E6A138EE2A82B5B6F128AE0A92E5E69138AE7AC2B586F1603073Q006D5C25BCD49A1D026Q006D4003063Q00EDAB574D56DD03073Q0028BEC43B2C24BC025Q00E06C4003093Q0018CCBFDE625A28402E03083Q00325DB4DABD172E47025Q00C06C4003133Q009BD164EFBAD32DDAD263EBBED225D8D561E9B903073Q001DEBE455DB8EEB025Q00806C4003043Q0042CE878203063Q007610AF2QE9DF025Q00606C4003803Q00A2BE7FE773A4B97BE574A2B87FE273A5BC7AE576A2BC7AE273A3BC78E572A2B27FE076A8B97EE073A2B27AE473A4B97DE57DA2BD7FEF76A4B97AE57DA2BA7FE276A3B97BE071A2BF7AE773A0B978E572A2BC7FE276A2BC7EE571A2B87FE176A9BC79E076A2B97AE576A4B979E575A2BE7FE276A0BC7EE070A2B37AE273A7BC7F03053Q0045918A4CD6025Q00406C4003063Q00E98653031EEC03063Q008DBAE93F626C025Q00206C4003093Q00D3EE7C0293C8F9E46A03063Q00BC2Q961961E6026Q006C4003133Q00D66AEE64E9519469ED6EE05A936AE861E9509303063Q0062A658D956D9025Q00C06B4003043Q00F975CB3C03073Q0079AB14A5573243025Q00A06B4003803Q00908AD58D7DBF908DD58A7DB2958AD58C78BF9588D58B78BC958DD58C7DBB958BD08F78BB958CD58A7DB9908DD58D78B8908BD58D7DBD9088D58C7DBB9581D5887DBA9581D08E78BB958BD08C78BE908FD08C7DBA908CD08678BE908AD5887DB9908DD08D7DB2958BD08678BB908DD08C7DBF908BD08778BF958CD08778BC908B03063Q008AA6B9E3BE4E025Q00806B4003063Q00F7202D251DC503053Q006FA44F4144025Q00606B4003093Q00716C03305B4077466703073Q0018341466532E34025Q00406B4003143Q00F76BBA25B169BF27B16FB226B06EBC21B36BBE2403043Q0010875A8B026Q006B4003043Q0021AD885703043Q003C73CCE6025Q00E06A4003803Q0067E570B367E570B467E670BE62E275B567E375B762E470B662E475B762E175B062E575B762E670B762E275B767E470B062E375B067E075B062E270B267E170B562E270BE67E275B362E370B562E470B267E875B767E175B267E975B467E870B567E575B567E970BE62E470B062E670BE67E570B367E975B567E370B462E475B703043Q008654D043025Q00C06A4003063Q00B1DEAD8CAB8503063Q00E4E2B1C1EDD9025Q00A06A4003093Q002647C6F8164BCCE91003043Q009B633FA3025Q00806A4003133Q002Q6BEC18E08822F42964EF10E38A25F7296BE603083Q00C51B5CDF20D1BB11025Q00406A4003043Q00FA5B002603083Q00E3A83A6E4D79B8CF025Q00206A4003243Q0003DEF40605D2F5074DDFF55156CAF3010581EF0804D3A61D58D7F4555681F45556DEF42Q03043Q003060E7C2026Q006A4003043Q003C404A2503053Q00A96425244A025Q00E0694003803Q00B68C5B6070B08A5D6072B38A5B6475B18F5B6073B38C5B6070B08A5D6076B38F5E6575BD8A5B607EB68E5B6775B78A5E6071B68B5B6175BC8A5E6573B6815E6175B68F5D6074B38A5B6B75B38A5A6572B38C5B6675B48A5F6075B38B5B6775BC8A516076B38A5B6475BC8F5B6077B68E5B6A75BC8A586073B38B5E6275B78A5803053Q004685B96853025Q00C0694003063Q007B7EB8FFD74903053Q00A52811D49E025Q00A0694003093Q001CBEB02A9F2DB8D22A03083Q00A059C6D549EA59D7025Q0080694003133Q003F4B0417A4D75E78400A18A7D7527F450A18A103073Q006B4F72322E97E7025Q0040694003043Q000B72774A03053Q00AE59131921025Q0020694003403Q0089405923AFAD89160371A8AD891E5622FDFF89475421A9A88A1F5320A9FFD9175975AAF98D165922F9AEDA1E0327AAFB80100520FDF88B145124FAF88147582503063Q00CBB8266013CB026Q0069402Q033Q00827BB103063Q006FC32CE17CDC025Q00E0684003803Q001906275D1C02225B1C022758190322591900225C1C0D275E1C0C275A1903275C1907225C1C03275F1C0D225A1C01275C1907275B1C00275F1C00275A190427581C00275A1907275D1C0D275A1C06225D1906275E1C0D275B1C07275F1C0D27581900225E1C01225D1C04225B1C03275C1904225E1903275C190727581906275903043Q00682F3514025Q00C0684003063Q00EE29FA42A7DC03053Q00D5BD469623025Q00A0684003093Q00D0A60F1862ECFAAC1903063Q009895DE6A7B17025Q0080684003143Q00962C7F448B9881D52C754E809983D42D78408E9A03073Q00B2E61D4D77B8AC025Q0040684003043Q009CEEB3B703043Q00DCCE8FDD025Q0020684003803Q00AC2007E3658EAAAC2203E56E88ADAC2607E1658BAFAE2207E06788ADA92702E7608AAFA62206E5638DA9AC2207E6658BAFA72202E06788AFA92502E7608BAFA92203E56688A9AC2002E0658AAFAB2706E5678DABA92302E5608FAAAE2705E56F8DABAC2202E3658CAFA92705E064882QA92302E3608FAFAE2201E5658DADAC2103073Q009C9F1134D656BE026Q00684003063Q002Q3E397C1F7F03063Q001E6D51551D6D025Q00E0674003093Q0073B7391D06F7FC44BC03073Q009336CF5C7E7383025Q00C0674003133Q00470E578D000C528F00085588060E51870E085003043Q00BE373864025Q0080674003043Q00D9C2EED203053Q00218BA380B9025Q0060674003403Q0059AC23B25AD75FFF76B30FD20DAC25E00ADB0FF576B60AD759FA76B45AD00FAE71B55E8157AF29B70ED45BAF73BD53D40FFF72E25CD50DFF75B308D45BFC75E103063Q00E26ECD10846B025Q004067402Q033Q0005219C03073Q00B74476CC815190025Q0020674003403Q000E51DB52755843A85F538B0A700A13FF0855DF0E700A48A90252890E7D5B40FA0C54DB5C245A15AF5F06D55F770913FE0953DE097C5744F303028E0F735F10F803083Q00CB3B60ED6B456F71026Q00674003083Q00054CFF1964CF244C03063Q00AE5629937013025Q00E0664003803Q00D778F0978B05E1DD7BF2978E00E6D77CF5968E07E4D07BF4928E05E3D27BF5918B05E4D77BFF928D00E7D77CF5928B0AE1D17EF5928C00E2D778F0908E01E1D07EF0928000E6D77BF5908B07E1D67BF4978D05E1D77BF0948B01E4D77BFF928B00E3D770F0978E07E1D77BF3928F00E6D77DF0958B0BE1D17BF4928005E0D27A03073Q00D2E448C6A1B833025Q00C0664003063Q00ECE8A2D9E1DE03053Q0093BF87CEB8025Q00A0664003093Q0004595507E2482C335203073Q004341213064973C025Q0080664003143Q00C2D48D73D7FF0283D28477D2FA0C87D78975DEFF03073Q0034B2E5BC43E7C9025Q0040664003043Q0099C2454D03083Q002DCBA32B26232A5B025Q0020664003803Q006FFE1F4093B5586AFE194B94B15F6AF91F4193B65D6FFB1E4B92B45B6FFA1A4D93B5586BFE1E4B90B45C6AF01F4896B65D6CFE1A4B95B1586FFC1A4E93B3586AFB144B95B1576FFE1F4F93B15D69FB144E96B15B6AF11A4C93B15D69FE194E94B1586AFC1F4C96B05D6EFE1D4E92B15F6AFE1A4C93B5586BFE1F4E94B15B6AFA03073Q006E59C82C78A082026Q00664003063Q00231B3EF4C4AF03073Q00C270745295B6CE025Q00E0654003093Q00C00150800A19204CF603083Q003E857935E37F6D4F025Q00C0654003133Q0092160809E59109DA1E0B06E69B07DB180D08E503073Q003EE22E2Q3FD0A9025Q0080654003043Q008A74ECFE03053Q00EDD8158295025Q0060654003403Q00F5077A13870A4F2FA2077012810C4075A2552D14830E4F70A6527146D65A4A77A2022D15810A4B24A0517D48D00A4974A2537D11D40B1E26AA517F468108192703083Q001693634970E23878025Q0040654003063Q004FF8253721A503063Q00C41C97495653025Q0020654003093Q0026DE724F16D2785E1003043Q002C63A617026Q00654003133Q00FEA4F468BFA4F264BBA6F369B7A3FB62BFA6F603043Q00508E97C2025Q00C0644003043Q0028B4860603043Q006D7AD5E8025Q00A0644003803Q0089B821BDD8908CBE24BDDD9489BE21BED89189BF24BCD89589BC24BEDD918CBA24BDD89F89BD24BFD89489B324BED89689B224B0DD968CBF21BDDD9389B224BDDD918CBF24B8D89E89B324BBD8968CB924B1DD918CB824BBD89689BE21BDD8948CB824BAD89E89BF24BFD8908CBF24BED89089B324B1DD918CB924BAD8978CBF03063Q00A7BA8B1788EB025Q0080644003063Q00EDA8C9DC61F003083Q006EBEC7A5BD13913D025Q0060644003093Q0067F65C8357FA56925103043Q00E0228E39025Q0040644003133Q0090A8D72464BEE545D5AEDA2F61B0E542D3AADA03083Q0076E09CE2165088D6026Q00644003043Q00744DCFA803063Q00A8262CA1C396025Q00E0634003803Q00D1A75777F4D2A75375F1D1A65770F4D3A75475FBD4A65275F4D3A75675F4D1A15277F1D1A75175F3D4A55270F1D3A75275FAD4A25774F4D4A75070F3D4A6577EF1D3A75270F4D4AD5273F1D7A75C70F7D4A15772F4D5A25775F5D4AC5770F1D7A25775FBD1A25777F4D1A25570F6D1A5577FF4D2A75075FAD4AC577EF1D1A75D03053Q00C2E7946446025Q00C0634003063Q00DFA70FC54EED03053Q003C8CC863A4025Q00A0634003093Q001506851B542411920B03053Q0021507EE078025Q0080634003143Q0040F0A776137D09F8A171157E03F6AC74177802F703063Q004E30C1954324025Q0040634003043Q00341E5CCC03073Q00EB667F32A7CC12025Q0020634003803Q00532B512D1D5ADC512055291D5DDF53245127185ED9582556291A58D956205128185CDC5220572C1A5DDF5622512B1D5DD950255629195DDE5625512E1856DC54205B291E58DC53205126185EDC522053291E58DC53205429185AD95520522C195DD95622512E1857D95325532C1B5DDC5620542B1856D9532057291F5DDE532303073Q00EA6013621F2B6E026Q00634003063Q00971600BB57A903083Q0050C4796CDA25C8D5025Q00E0624003093Q00A92441E14616832E5703063Q0062EC5C248233025Q00C0624003133Q003B4A7E06D8D4947B4A7F00DDDE9678407D0DDC03073Q00A24B724835EBE7025Q0080624003043Q00E480F14203053Q00BFB6E19F29025Q0060624003803Q00A5BB0B8F7601A5BC0B857302A0BF0E827305A0BD0B8F7303A0BA0E807602A0BD0E827601A5BE0B807603A5BB0E857602A0BD0B847302A0BB0E847300A5BB0B847601A0B60E857604A0BE0B817603A0BC0B8F7305A0BE0B857605A5BD0E82760FA5BA0B8F7601A5BE0E857607A5BC0E807600A0BD0E847303A0B60E877300A0BD03063Q0036938F38B645025Q0040624003063Q006B182B474A1603043Q0026387747025Q0020624003093Q006362510D265275461D03053Q0053261A346E026Q00624003133Q00EBF6E57FAFF8E47DA3FCE479ABFCE67BADFFE703043Q00489BCED2025Q00C0614003043Q008152C47B03083Q00A1D333AA107A5D35025Q00A0614003603Q006D570BBC395F5BB43D005BBC3A075FBA3E5E5BBD60545BEE68000BB9690558B83D5E55B4395554EE39555CB96C030BEE695708B4685E0FB568040EBF6B5F54BD6F5F58EE3E545CBA685409B86F055BEF3C025ABD6F535CEF695E5BE96C515FBC03043Q008D58666D025Q0080614003043Q00032716C503053Q0095544660A0025Q0060614003093Q00F3B8082CD6C2AF1F3C03053Q00A3B6C06D4F025Q0040614003143Q004E92A7B17A920A97A4B77D900E91A7B17A920E9A03063Q00A03EA395854C026Q00614003043Q008B0D8D2A03073Q00CCD96CE3416255025Q00E0604003803Q00515FF105EBB544F05458F406EEBD41F8545FF403EEB644F9515BF103EEB541FA515EF404EBB644F05150F102EEB644F1515AF407EEB444F0515CF40EEEB244F8545DF104EEB544FB545DF406EBB244F9515DF406EBB044FC545AF404EBB044F1515BF100EEB441FB2Q51F403EEB241FD545CF40EEEB444FC515EF405EEB444F803083Q00C96269C736DD8477025Q00C0604003063Q003CA9217EF5E903063Q00886FC64D1F87025Q00A0604003093Q00D669F30F055EFC63E503063Q002A9311966C70025Q0080604003143Q000BBCD407BE65694CBFD408BE2Q6E4CB4D007BC6E03073Q00597B8DE6318D5D025Q0040604003043Q00FC7FBC0803053Q00E5AE1ED263025Q0020604003803Q00D7150B76D7120E78D7130B79D2140B7ED7110E7AD7130B7BD7120E7AD7180B79D7130B76D7130B7BD7130B7BD7110E7CD7130B7CD7150B7FD2100E7AD7140B78D2120E7AD7100B7DD7100E7AD2140E78D7120E7DD2130E7BD7170B7AD2170B7FD2150B7FD7120E7DD7150E7FD7120B76D7150E7DD7100B7FD7180B7FD7100B7C03043Q004EE42138026Q00604003063Q001EC153EA54CE03073Q00E04DAE3F8B26AF025Q00C05F4003403Q008A85765F76038C847B087656DF847F0A7A52DE80790F2D04DD837E0D2A528380285D29018F89770F7A078F80790D2C028386780F79048B857B0477058F842C0E03063Q0037BBB14E3C4F025Q00805F4003083Q00B7C40CB02830DA8103073Q00A8E4A160D95F51025Q00405F4003093Q00E8FF18F80FD9E80FE803053Q007AAD877D9B026Q005F4003133Q0021548AE2A089E4685582ECA181ED625284E4A803073Q00DD5161B2D498B0025Q00805E4003043Q002021367703063Q00147240581CDC025Q00405E4003803Q00924B5BA45122EF90415AA65523E092425EA75120EF97445CA65723EE92445BA65421EA97445BA35726EA92415EA25122EA90445BA65023EB97445EAC5127EA964458A35426EF92405BA15129EA98445BA65B23E892425EA25126EA984159A35623EA92445EA35424EA91415AA35123EC924B5BA15423EA95445FA35423EB924603073Q00D9A1726D956210026Q005E4003063Q006E797F1D61AA03073Q002D3D16137C13CB025Q00C05D4003093Q00164A57F5EC275D40E503053Q0099532Q3296025Q00805D4003143Q00AEA5521DDBEBA45713D1E8A65213D3EAA2561CD103053Q00E3DE946325026Q005D4003043Q00F6CA1DCF03073Q00C8A4AB73A43D96025Q00C05C4003243Q0041AD666C2746FC60797743A960792743F833797714A966792E42AB30627044F8636D204103053Q0016729D5554025Q00805C4003043Q00CCA8B8DB03073Q003994CDD6B4C836025Q00405C4003803Q00E5E1B085E5EDB585E0E7B084E5E2B583E0E4B588E5E6B580E5E0B588E5E2B085E5EDB585E5ECB084E5E6B587E0E3B081E0E4B587E5E3B580E5E2B585E0E7B580E0E4B5812QE0B589E5E7B580E0E7B582E5E4B584E5E6B086E5E1B081E5E1B082E0E3B588E5E1B085E0E6B587E0E6B082E0E3B5872QE0B085E5EDB081E0E1B58903043Q00B0D6D586026Q005C4003063Q008982A4D3A88C03043Q00B2DAEDC8025Q00C05B4003093Q009C3BAE77AAAB4AA6AA03083Q00D4D943CB142QDF25025Q00805B4003143Q005E41662D1F4260231B45612A1940612B1941672303043Q001A2E7057026Q005B4003043Q00764BC07E03053Q0050242AAE15025Q00C05A4003243Q00B471B2092D21C4E66FB55A2F748BB373E25E3673C5B427AA042B27C3B424B1592D2890B103073Q00A68242873C1B11025Q00805A4003043Q002BD08CF403063Q00A773B5E29B8A025Q00405A4003803Q0067D32FEE62D22FEB62D62FE962D32FEC62D02AEE62D12FEE67D42FEA67D02FE862DA2AEA67D12AE862D12FEC62D22FEB67D02FE967D32FED67D72AED62DA2FE862D42FED62D02FEE62D42AE867D12FEF67D32FE467D72AE967D12AE862D52AEE62D32FEC67D12FEE62D62AEF67D12FEA62D62FE462D32FE567D02FE967D32FE403043Q00DC51E21C026Q005A4003063Q006F0ACCAE30D903063Q00B83C65A0CF42025Q00C0594003093Q00E79913FD2CFA57D09203073Q0038A2E1769E598E025Q0080594003133Q0025E3D8A38C65ECDFAA8C60E4D3A68361ECDDAA03053Q00BA55D4EB92026Q00594003043Q00CFCC1ADE03063Q00D79DAD74B52E025Q00C0584003803Q006D6CAFA56D6CAAA5686AAAA56D6CAAA06D6AAFA76D6EAAA96D6EAFA56D6AAAA66D6EAAA46D6CAAA3686AAFA4686CAFA06D66AFA5686AAFA3686CAAA46D69AAA06D6FAAA66D69AAA76D69AFA02Q6DAAA66D68AAA96D6EAAA5686CAFA52Q6DAAA36D6AAFA26D6EAAA16D6CAAA26D67AAA9686DAFA26D67AFA76869AFA36D6EAAA903043Q00915E5F99025Q0080584003063Q00DB0255FFC9E303083Q004E886D399EBB82E2025Q0040584003093Q00E45A37D510D54D20C503053Q0065A12252B6026Q00584003143Q0095E361591A1BDFD6EB60521916DADDEA655F1B1603073Q00E9E5D2536B282E025Q0080574003043Q00D3C93CF103083Q002281A8529A8F509C025Q0040574003803Q00E4B42AA5BF9DE4BD2FA3BF9DE1B12AA2BA98E4B62FA6BA93E4B62FA4BA9BE4B32AA7BA93E4B22FA6BA92E4B22AA4BF9EE1B12FA6BA92E4B72AA4BA98E1B32FA1BA9DE4B42AA1BA98E4B02AA4BA92E4BC2AA6BF9DE4BC2FA1BA9EE1B32FA3BA99E4B52FA3BF9AE1B32FA7BA9EE1B72AA1BA9FE1B02AA0BF9AE1B32FA6BA9FE4BD03063Q00ABD785199589026Q00574003063Q0016DE565BA12403053Q00D345B12Q3A025Q00C0564003243Q007E2F850E797B8C0A672F83087A63840A2F2B9859732B8116727E835E7C28835E7C77830803043Q003B4A4EB5025Q0080564003043Q00B4F8423D03073Q001AEC9D2C52722C025Q0040564003093Q00D2EB39D1E2E733C0E403043Q00B297935C026Q00564003133Q0090F094AB0EA6D3FE93A303AFD2F193AC07A9D103063Q009FE0C7A79B37025Q0080554003043Q00C670FBA603073Q00E7941195CD454D025Q0040554003803Q009D247205AE669B98247D07AB659D98257702AB659B9E247D02AC659D9821770CAB659B98217707A9609A982F7200AE669B99247607AE609198207700AE679E9A247107A560909D247206AE642Q9E217202AB659B98247207AB629B9E247C02A9659A98207700AB609B99217207A4659B98207702AE619E9A247507AF609E9D2403073Q00A8AB1744349D53026Q00554003063Q00D40DF6C8F52Q03043Q00A987629A025Q00C0544003093Q001243DA2A954251254803073Q003E573BBF49E036025Q0080544003143Q00B5FB714740519202F0FA734B44519505F5F8764B03083Q0031C5CA437E7364A7026Q00544003043Q009E2FA54003083Q0069CC4ECB2BA7377E025Q00C0534003243Q005062526B04003657775F563654770C503700770504330377055164036C5B573750630B5203053Q003D6152665A025Q0080534003043Q00DC74724603073Q008084111C29BB2F025Q0040534003803Q0071ED949871E895EC05E395EA029CE29A009B96EF089C99EE069B92E20399949A059997ED71E8E59D04EA94EC0698929F72EAE3EB079F94EB079B939E07ED91EE089B90E800ECE59E76EDE39905EAE0E900992QE27199E0EE74EFE59A719BE0EE039F969E08EF94E8749CE4E806EA96EA73EB94EC712QE3E2089BE5E2769B94EB03043Q00DB30DAA1026Q00534003093Q0041587984EE9877014D03063Q00EB122117E59E025Q00C0524003603Q0078DE33FFA8E9657BDD64A8FAED6478DB67A8F0BF6273DE66FDAFB8667FDA67FEAAE53378D863FDF0ED617ADE66AFACEB617ADD36F8FABF332EDB36F9A8BE307ADE62A8F9EE62288E33AFFEE96373DF64AAFAE53078DB36F5FDED64798D68A8FA03073Q00564BEC50CCC9DD025Q0080524003043Q00791627AD03083Q003A2E7751C891D025025Q0040524003803Q00E901E517E902E518E907E516E901E516E907E014EC02E013E905E513E906E517E905E517EC02E515E901E517E904E015EC06E517E90CE013EC02E014EC05E014E906E516EC05E511E900E518E906E511EC06E014E90CE515E902E516E907E515E90DE016E905E512EC00E516E904E518EC00E014EC06E016E902E510E906E01403043Q0020DA34D6026Q00524003063Q007D88EF2C5C8603043Q004D2EE783025Q00C0514003093Q0096300AFFC54FBC3A1C03063Q003BD3486F9CB0025Q0080514003144Q0007D1DAD176F9A84007D5DDD379FDA5490FD1D903083Q00907036E3EBE64ECD026Q00514003043Q00692FBA5D03053Q002D3B4ED436025Q00C0504003803Q00694FA2E36942A7E76C45A7E66940A7E76940A7E26947A2E46940A2E46C45A2E16942A7E06947A7E76C45A2E16943A7E16C43A7E76946A2E66947A7E3694EA7E66C40A7E66946A2E06946A7E76C45A7ED6C42A7ED6944A7E76942A7ED6947A2E76940A7E06940A7E76940A7ED6C44A7E16940A7EC6941A2E76C44A7EC6945A2E603043Q00D55A7694025Q0080504003063Q00B122A94BCE4103073Q0071E24DC52ABC20025Q0040504003093Q005D9F2B146D9321056B03043Q007718E74E026Q00504003133Q00CF4DA0456F8F46A54D6A8E4BA64F69884FA64803053Q005ABF7F947C026Q004F4003043Q00CFB25E4E03063Q00BF9DD330251C025Q00804E4003803Q006F645AEE4ABF72626A655AED4ABC77616A605AED4AB977636A605FE84ABD77636F645AE24FB877666F695AE34ABC72626F615AE94FBF77666F635FE94AB877666F655FED4FB977636F685AEB4AB972636A625FEF4ABD72676A625AEA4FBD77666A635AEE4ABE72666F695AE94ABB72676A675FED4ABD72676F625FEA4FBD776603083Q00555C5169DB798B41026Q004E4003063Q0011573BD9CC1503073Q0086423857B8BE74025Q00804D4003093Q008FD008C8D0B7D8F3B903083Q0081CAA86DABA5C3B7026Q004D4003133Q00A87A2D4C71A3BFED722D4870A8BFE1772F4E7003073Q008FD8421E7E449B026Q004C4003043Q007CAADE7903083Q00C42ECBB0124FA32D025Q00804B4003803Q00FD0565687965F80D60697C68FD0465697964FD08606F7C69FD0F656E7C67F808606D7C62FD0F606D7C68F80E606B7962FD05656A7962FD0B60697C63FD0A656E7C67FD0C60627965FD09656A7C66FD0E656F7C67F808606F7C64F808606B7962FD0A606E7C61FD04606F7967FD0560687962FD0C606C7C67FD0A606C7960FD0803063Q0051CE3C535B4F026Q004B4003063Q0032E8445E610003053Q00136187283F025Q00804A4003093Q0098C1254FA8CD2F5EAE03043Q002CDDB940026Q004A4003133Q005B8AE9184A2E188BEB1D432B1A81E018432A1E03063Q001D2BB3D82C7B026Q00494003043Q000EAE8F4703073Q00185CCFE12C8319025Q0080484003803Q0088DC47A4EF8F9C88D843A6ED8F9E88DD42A2EF88998FDD42A6EC8A9988DC42A1EA889C8EDD43A6EF8A9E88DB42A1EF8F9C8DD846A6E08F9E8DDD47A0EF899C8ED845A6E88A9988D342A6EA899C88D847A6EB8F9E88D342A5EA889C89DD47A6EF8F9A88D842ACEA899C8AD847A6E98F9688D242A7EF8D9989DD45A6EC8F9B8DD903073Q00AFBBEB7195D9BC026Q00484003063Q006A5947FC678703083Q006B39362B9D15E6E7025Q0080474003603Q00099BB70F5CABD95999B00503A6D4029BB30E5CF183029AE4525EF0D50B90B60402A4D208CDE7520FA186039BB7550CA4D70F9DE10E0BF7D90FCEB50F0DA0D10B90BD555CF0810ECAE65559F7D459CCB00E59A6D5589AB7050AA7D003C9E3550803073Q00E03AA885363A92026Q00474003043Q006F2165F903063Q00203840139C3A025Q0080464003093Q00C0567509F05A7F18F603043Q006A852E10026Q00464003143Q00AEA3939A6896E12CEFA69296639FE028E6A5939103083Q001EDE92A1A25AAED2026Q00454003043Q00D4C4C33603043Q005D86A5AD025Q0080444003803Q00FB2BEAD260FF2EEBD660FE20EFD165FB2BE9D366FE2EEAD660F82BEFD36BFE2BEAD260FD2BE0D36AFE29EFD360F52EECD36BFE2DEAD865F92BECD366FB29EAD465FF2EE8D36BFB29EFD465FC2BEED665FB2EEAD565F92EE8D365FE2CEFD265F92BEED665FB2EEAD560FB2BE8D360FE2EEAD765F82BE1D361FE2CEAD860FF2EEC03053Q0053CD18D9E0026Q00444003063Q0074C339DD164603053Q006427AC55BC025Q0080434003093Q0089B11447A3FFC0BEBA03073Q00AFCCC97124D68B026Q00434003133Q009C520914B715B7DF550E11B116B7DB5C0610BD03073Q0080EC653F268421026Q00424003043Q00E61E09D803073Q00E6B47F67B3D61C025Q0080414003243Q0023D5BB1C538A10426887E91C02C540412082F214518B435D7DD4E949528E471573DDE91F03083Q007045E4DF2C64E871026Q00414003043Q0095D81EFF03063Q0096CDBD709018025Q00802Q4003603Q004CB8EFE7FFB9A34FBBBEE2F9B8F64EBBBDB3ADE5F243EEB9E5A8EDA64DB4BDE8A8EFF443BAEAE2AAEAA21FB9BBE5FEE8A34CB8B9E7AFE9A61FBFBAE3FCBEF71FBEEAE8AAECF24FB8E1B6AFBEF518ECEBE4FCBFF618B4E1E7F4ECA41BE8E1E6FC03073Q00C77A8DD8D0CCDD026Q002Q4003043Q00B62DDB1703053Q0087E14CAD72026Q003F4003803Q004763E46C1D6F7F4563EB6E18647A4263E16A18637A4363E66E1C64714263E46C1D637F4466E36E1F647B4765E46D18647F4763E66E18647E4765E16F18667F4366E06E1B617F4269E16E1D677F4363E56E1F617D4766E46918647F4763E36B16617F4260E46C1D637F4566E06E1C617D4765E16C18657A4563E06B1B647D426603073Q00497150D2582E57026Q003E4003063Q00F0008EF6D8C203053Q00AAA36FE297026Q003D4003093Q001D1687C5BF2C0190D503053Q00CA586EE2A6026Q003C4003133Q00C2BF62E4F5AA5D82B761E0F1AE5982B568E7F003073Q006BB28651D2C69E026Q003A4003043Q008AE8D5CF03043Q00A4D889BB026Q00394003803Q000E0C567A71B9410008507A70BE440E0F567A74BC410908517F75BE450B0F537B74B9440A0D5C7A73BB440B08562Q71BC440E08537A73BE402Q0B567974BE442Q0D5D7A7EBB430B0A567B71B9440E0D527F74BE4A0B0F567071BC440E08567A77BB410E0F567D74BC440D08537A72BE450B0A537F74BE440B08567F74BE410B0703073Q0072383E6549478D026Q00384003063Q00E7CBE25DC6C503043Q003CB4A48E026Q00374003093Q0073305A3B304AF7443B03073Q009836483F58453E026Q00364003133Q0017B8FC9754BBF1975EB8FD9F5FBDF49D55BFF203043Q00AE678EC5026Q00344003043Q00FA2F2E8B03073Q009CA84E40E0D479026Q00334003243Q009F077243E848C4553D42EA1DC6192145BC188A0C7643BB539F042611EF189151264DEF4D03063Q007EA7341074D9026Q00324003043Q003F13B72403043Q004B6776D9026Q00314003803Q00D8A1610FABFFDDA1610EABF7DDA6610FABFED8A3610CABF2D8A2610CABFFDDA16408AEF1D8A1610AABF0D8A3610DABF7DDA6640FAEF1D8A7640EABFED8A06409AEF2D8A8610AAEF4D8A96109ABFED8A6610EABF5D8A46408ABFED8A8640EABF3DDA36408AEF6D8A56409AEF3DDA5610EABF3D8A4610AABF3D8A7610CABF3D8A103063Q00C7EB90523D98026Q00304003063Q0085E626CA0AAF03083Q00A7D6894AAB78CE53026Q002E4003093Q0029D65B716B63FCF51F03083Q00876CAE3E121E1793026Q002C4003133Q00AB8D100C4CEB89160F4BE98B16084EE88B1B0B03053Q007EDBB9223D026Q002A402Q033Q0013EE1A03043Q00E849A14C026Q00284003043Q00F93D29ED03063Q00CAAB5C4786BE026Q00264003243Q0051EE89658057B9DB7ADC52E9887A8853BF8A7AD854EDD97A8152EC8E61DF54BFDD6E8F5103053Q00B962DAEB57026Q00244003043Q0084C6D90503063Q004BDCA3B76A62026Q00224003403Q004A400670481003241C1153761C415923181304271E17587C11415326101A06751915577D1B46577D481457724A17017C1B1550211C1555261147067D1D43587603043Q0045292260026Q0020402Q033Q0077FE9003073Q00DB36A9C05A3050026Q001C4003803Q00F58BDB7DA3EA8988DD0DD6E6F0FCAE7DD49BF58AD879A49D83FEAE7DA29CF0FCAC7DD39AF78BD978A4EB898AAF78D8E8F588DC0DD6E9F28BDE7BA5E8F7F9D809D99DF5FBA90AD2EFF48AD40FA59C8788D80ED99C828CDB7BD2E6F2FBDB09D69981FEAC7EA39DF287DE7CD1EC8088D90AD29A82FEA87BD2ED84FDD97CD89B878E03063Q00DFB1BFED4CE1026Q00184003093Q0047E3D2350367FF9C0E03053Q0073149ABC54026Q00144003603Q00F2D242F82A280FF6D346FB7C7D03F58014AD2D7A52F5D01AF0257A06FEDC46F1782400FED545AC242C53A58716F17E2C55F28340FB2E7E03A18316F9282A02F6D214FA252F02F28317AE2C2B52F68417FB7B7F53F28113F9787E55F3D41AFE2803073Q0037C7E523C81D1C026Q00104003043Q00CB416EE003073Q00569C2018851D26026Q00084003803Q0025F0EDA8156120F4EDAE106520F1EDAD106525F3EDA1156125F3E8AD156125F4E8AB106420F1E8AC106420F5EDA0156125F3EDAD106520F6E8AC156F25F4EDAF106025F0E8AD156020F5EDAF156E20FCE8AB156320F6EDAB106720FCEDAD156120F1E8AD156520F0E8AE156F20F3EDA9106420FDEDAA106225F7E8A9106220FD03063Q005613C5DE9826027Q004003063Q00E5F4A72500D703053Q0072B69BCB44026Q00F03F03093Q000336FB5303A8293CED03063Q00DC464E9E3076028Q0003133Q00D5871661E41D7894851161E61C7F978A1466E103073Q004AA5B32654D72903013Q005A03013Q005303013Q00412Q00113Q00B47Q00122Q000100013Q00202Q00010001000200122Q000200013Q00202Q00020002000300122Q000300013Q00202Q00030003000400122Q000400053Q00062Q0004000B000100010004073Q000B0001001231000400063Q002094000500040007001231000600083Q002094000600060009001231000700083Q00209400070007000A0006BF00083Q000100062Q003D3Q00074Q003D3Q00014Q003D3Q00054Q003D3Q00024Q003D3Q00034Q003D3Q00064Q0017000900083Q00122Q000A000C3Q00122Q000B000D6Q0009000B000200104Q000B00094Q000900083Q00122Q000A000F3Q00122Q000B00106Q0009000B000200104Q000E00094Q000900083Q00122Q000A00123Q00122Q000B00136Q0009000B000200104Q001100094Q000900083Q00122Q000A00153Q00122Q000B00166Q0009000B000200104Q001400094Q000900083Q00122Q000A00183Q00122Q000B00196Q0009000B000200104Q001700094Q000900083Q00122Q000A001B3Q00122Q000B001C6Q0009000B000200104Q001A00094Q000900083Q00122Q000A001E3Q00122Q000B001F6Q0009000B000200104Q001D00094Q000900083Q00122Q000A00213Q00122Q000B00226Q0009000B000200104Q002000094Q000900083Q00122Q000A00243Q00122Q000B00256Q0009000B000200104Q002300094Q000900083Q00122Q000A00273Q00122Q000B00286Q0009000B000200104Q002600094Q000900083Q00122Q000A002A3Q00122Q000B002B6Q0009000B000200104Q002900094Q000900083Q00122Q000A002D3Q00122Q000B002E6Q0009000B000200104Q002C00094Q000900083Q00122Q000A00303Q00122Q000B00316Q0009000B000200104Q002F00094Q000900083Q00122Q000A00333Q00122Q000B00346Q0009000B000200104Q003200094Q000900083Q00122Q000A00363Q00122Q000B00376Q0009000B000200104Q003500094Q000900083Q00122Q000A00393Q00122Q000B003A6Q0009000B000200104Q003800092Q0017000900083Q00122Q000A003C3Q00122Q000B003D6Q0009000B000200104Q003B00094Q000900083Q00122Q000A003F3Q00122Q000B00406Q0009000B000200104Q003E00094Q000900083Q00122Q000A00423Q00122Q000B00436Q0009000B000200104Q004100094Q000900083Q00122Q000A00453Q00122Q000B00466Q0009000B000200104Q004400094Q000900083Q00122Q000A00483Q00122Q000B00496Q0009000B000200104Q004700094Q000900083Q00122Q000A004B3Q00122Q000B004C6Q0009000B000200104Q004A00094Q000900083Q00122Q000A004E3Q00122Q000B004F6Q0009000B000200104Q004D00094Q000900083Q00122Q000A00513Q00122Q000B00526Q0009000B000200104Q005000094Q000900083Q00122Q000A00543Q00122Q000B00556Q0009000B000200104Q005300094Q000900083Q00122Q000A00573Q00122Q000B00586Q0009000B000200104Q005600094Q000900083Q00122Q000A005A3Q00122Q000B005B6Q0009000B000200104Q005900094Q000900083Q00122Q000A005D3Q00122Q000B005E6Q0009000B000200104Q005C00094Q000900083Q00122Q000A00603Q00122Q000B00616Q0009000B000200104Q005F00094Q000900083Q00122Q000A00633Q00122Q000B00646Q0009000B000200104Q006200094Q000900083Q00122Q000A00663Q00122Q000B00676Q0009000B000200104Q006500094Q000900083Q00122Q000A00693Q00122Q000B006A6Q0009000B000200104Q006800092Q0017000900083Q00122Q000A006C3Q00122Q000B006D6Q0009000B000200104Q006B00094Q000900083Q00122Q000A006F3Q00122Q000B00706Q0009000B000200104Q006E00094Q000900083Q00122Q000A00723Q00122Q000B00736Q0009000B000200104Q007100094Q000900083Q00122Q000A00753Q00122Q000B00766Q0009000B000200104Q007400094Q000900083Q00122Q000A00783Q00122Q000B00796Q0009000B000200104Q007700094Q000900083Q00122Q000A007B3Q00122Q000B007C6Q0009000B000200104Q007A00094Q000900083Q00122Q000A007E3Q00122Q000B007F6Q0009000B000200104Q007D00094Q000900083Q00122Q000A00813Q00122Q000B00826Q0009000B000200104Q008000094Q000900083Q00122Q000A00843Q00122Q000B00856Q0009000B000200104Q008300094Q000900083Q00122Q000A00873Q00122Q000B00886Q0009000B000200104Q008600094Q000900083Q00122Q000A008A3Q00122Q000B008B6Q0009000B000200104Q008900094Q000900083Q00122Q000A008D3Q00122Q000B008E6Q0009000B000200104Q008C00094Q000900083Q00122Q000A00903Q00122Q000B00916Q0009000B000200104Q008F00094Q000900083Q00122Q000A00933Q00122Q000B00946Q0009000B000200104Q009200094Q000900083Q00122Q000A00963Q00122Q000B00976Q0009000B000200104Q009500094Q000900083Q00122Q000A00993Q00122Q000B009A6Q0009000B000200104Q009800092Q0017000900083Q00122Q000A009C3Q00122Q000B009D6Q0009000B000200104Q009B00094Q000900083Q00122Q000A009F3Q00122Q000B00A06Q0009000B000200104Q009E00094Q000900083Q00122Q000A00A23Q00122Q000B00A36Q0009000B000200104Q00A100094Q000900083Q00122Q000A00A53Q00122Q000B00A66Q0009000B000200104Q00A400094Q000900083Q00122Q000A00A83Q00122Q000B00A96Q0009000B000200104Q00A700094Q000900083Q00122Q000A00AB3Q00122Q000B00AC6Q0009000B000200104Q00AA00094Q000900083Q00122Q000A00AE3Q00122Q000B00AF6Q0009000B000200104Q00AD00094Q000900083Q00122Q000A00B13Q00122Q000B00B26Q0009000B000200104Q00B000094Q000900083Q00122Q000A00B43Q00122Q000B00B56Q0009000B000200104Q00B300094Q000900083Q00122Q000A00B73Q00122Q000B00B86Q0009000B000200104Q00B600094Q000900083Q00122Q000A00BA3Q00122Q000B00BB6Q0009000B000200104Q00B900094Q000900083Q00122Q000A00BD3Q00122Q000B00BE6Q0009000B000200104Q00BC00094Q000900083Q00122Q000A00C03Q00122Q000B00C16Q0009000B000200104Q00BF00094Q000900083Q00122Q000A00C33Q00122Q000B00C46Q0009000B000200104Q00C200094Q000900083Q00122Q000A00C63Q00122Q000B00C76Q0009000B000200104Q00C500094Q000900083Q00122Q000A00C93Q00122Q000B00CA6Q0009000B000200104Q00C800092Q0017000900083Q00122Q000A00CC3Q00122Q000B00CD6Q0009000B000200104Q00CB00094Q000900083Q00122Q000A00CF3Q00122Q000B00D06Q0009000B000200104Q00CE00094Q000900083Q00122Q000A00D23Q00122Q000B00D36Q0009000B000200104Q00D100094Q000900083Q00122Q000A00D53Q00122Q000B00D66Q0009000B000200104Q00D400094Q000900083Q00122Q000A00D83Q00122Q000B00D96Q0009000B000200104Q00D700094Q000900083Q00122Q000A00DB3Q00122Q000B00DC6Q0009000B000200104Q00DA00094Q000900083Q00122Q000A00DE3Q00122Q000B00DF6Q0009000B000200104Q00DD00094Q000900083Q00122Q000A00E13Q00122Q000B00E26Q0009000B000200104Q00E000094Q000900083Q00122Q000A00E43Q00122Q000B00E56Q0009000B000200104Q00E300094Q000900083Q00122Q000A00E73Q00122Q000B00E86Q0009000B000200104Q00E600094Q000900083Q00122Q000A00EA3Q00122Q000B00EB6Q0009000B000200104Q00E900094Q000900083Q00122Q000A00ED3Q00122Q000B00EE6Q0009000B000200104Q00EC00094Q000900083Q00122Q000A00F03Q00122Q000B00F16Q0009000B000200104Q00EF00094Q000900083Q00122Q000A00F33Q00122Q000B00F46Q0009000B000200104Q00F200094Q000900083Q00122Q000A00F63Q00122Q000B00F76Q0009000B000200104Q00F500094Q000900083Q00122Q000A00F93Q00122Q000B00FA6Q0009000B000200104Q00F800092Q0040000900083Q00122Q000A00FC3Q00122Q000B00FD6Q0009000B000200104Q00FB00092Q00C7000900083Q00122Q000A00FF3Q00122Q000B2Q00015Q0009000B000200104Q00FE000900122Q0009002Q015Q000A00083Q00122Q000B0002012Q00122Q000C0003015Q000A000C00026Q0009000A00122Q00090004015Q000A00083Q00122Q000B0005012Q00122Q000C0006015Q000A000C00026Q0009000A00122Q00090007015Q000A00083Q00122Q000B0008012Q00122Q000C0009015Q000A000C00026Q0009000A00122Q0009000A015Q000A00083Q00122Q000B000B012Q00122Q000C000C015Q000A000C00026Q0009000A00122Q0009000D015Q000A00083Q00122Q000B000E012Q00122Q000C000F015Q000A000C00026Q0009000A00122Q00090010015Q000A00083Q00122Q000B0011012Q00122Q000C0012015Q000A000C00026Q0009000A00122Q00090013015Q000A00083Q00122Q000B0014012Q00122Q000C0015015Q000A000C00026Q0009000A00122Q00090016015Q000A00083Q00122Q000B0017012Q00122Q000C0018015Q000A000C00026Q0009000A00122Q00090019015Q000A00083Q00122Q000B001A012Q00122Q000C001B015Q000A000C00026Q0009000A00122Q0009001C015Q000A00083Q00122Q000B001D012Q00122Q000C001E015Q000A000C00026Q0009000A00122Q0009001F015Q000A00083Q00122Q000B0020012Q00122Q000C0021015Q000A000C00026Q0009000A00122Q00090022015Q000A00083Q00122Q000B0023012Q00122Q000C0024015Q000A000C00026Q0009000A00122Q00090025015Q000A00083Q00122Q000B0026012Q001269000C0027013Q009A000A000C00026Q0009000A00122Q00090028015Q000A00083Q00122Q000B0029012Q00122Q000C002A015Q000A000C00026Q0009000A00122Q0009002B015Q000A00083Q00122Q000B002C012Q00122Q000C002D015Q000A000C00026Q0009000A00122Q0009002E015Q000A00083Q00122Q000B002F012Q00122Q000C0030015Q000A000C00026Q0009000A00122Q00090031015Q000A00083Q00122Q000B0032012Q00122Q000C0033015Q000A000C00026Q0009000A00122Q00090034015Q000A00083Q00122Q000B0035012Q00122Q000C0036015Q000A000C00026Q0009000A00122Q00090037015Q000A00083Q00122Q000B0038012Q00122Q000C0039015Q000A000C00026Q0009000A00122Q0009003A015Q000A00083Q00122Q000B003B012Q00122Q000C003C015Q000A000C00026Q0009000A00122Q0009003D015Q000A00083Q00122Q000B003E012Q00122Q000C003F015Q000A000C00026Q0009000A00122Q00090040015Q000A00083Q00122Q000B0041012Q00122Q000C0042015Q000A000C00026Q0009000A00122Q00090043015Q000A00083Q00122Q000B0044012Q00122Q000C0045015Q000A000C00026Q0009000A00122Q00090046015Q000A00083Q00122Q000B0047012Q00122Q000C0048015Q000A000C00026Q0009000A00122Q00090049015Q000A00083Q00122Q000B004A012Q00122Q000C004B015Q000A000C00026Q0009000A00122Q0009004C015Q000A00083Q00122Q000B004D012Q00122Q000C004E015Q000A000C00026Q0009000A0012690009004F013Q0062000A00083Q00122Q000B0050012Q00122Q000C0051015Q000A000C00026Q0009000A00122Q00090052015Q000A00083Q00122Q000B0053012Q00122Q000C0054015Q000A000C00026Q0009000A00122Q00090055015Q000A00083Q00122Q000B0056012Q00122Q000C0057015Q000A000C00026Q0009000A00122Q00090058015Q000A00083Q00122Q000B0059012Q00122Q000C005A015Q000A000C00026Q0009000A00122Q0009005B015Q000A00083Q00122Q000B005C012Q00122Q000C005D015Q000A000C00026Q0009000A00122Q0009005E015Q000A00083Q00122Q000B005F012Q00122Q000C0060015Q000A000C00026Q0009000A00122Q00090061015Q000A00083Q00122Q000B0062012Q00122Q000C0063015Q000A000C00026Q0009000A00122Q00090064015Q000A00083Q00122Q000B0065012Q00122Q000C0066015Q000A000C00026Q0009000A00122Q00090067015Q000A00083Q00122Q000B0068012Q00122Q000C0069015Q000A000C00026Q0009000A00122Q0009006A015Q000A00083Q00122Q000B006B012Q00122Q000C006C015Q000A000C00026Q0009000A00122Q0009006D015Q000A00083Q00122Q000B006E012Q00122Q000C006F015Q000A000C00026Q0009000A00122Q00090070015Q000A00083Q00122Q000B0071012Q00122Q000C0072015Q000A000C00026Q0009000A00122Q00090073015Q000A00083Q00122Q000B0074012Q00122Q000C0075015Q000A000C00026Q0009000A00122Q00090076015Q000A00083Q00122Q000B0077012Q001269000C0078013Q009A000A000C00026Q0009000A00122Q00090079015Q000A00083Q00122Q000B007A012Q00122Q000C007B015Q000A000C00026Q0009000A00122Q0009007C015Q000A00083Q00122Q000B007D012Q00122Q000C007E015Q000A000C00026Q0009000A00122Q0009007F015Q000A00083Q00122Q000B0080012Q00122Q000C0081015Q000A000C00026Q0009000A00122Q00090082015Q000A00083Q00122Q000B0083012Q00122Q000C0084015Q000A000C00026Q0009000A00122Q00090085015Q000A00083Q00122Q000B0086012Q00122Q000C0087015Q000A000C00026Q0009000A00122Q00090088015Q000A00083Q00122Q000B0089012Q00122Q000C008A015Q000A000C00026Q0009000A00122Q0009008B015Q000A00083Q00122Q000B008C012Q00122Q000C008D015Q000A000C00026Q0009000A00122Q0009008E015Q000A00083Q00122Q000B008F012Q00122Q000C0090015Q000A000C00026Q0009000A00122Q00090091015Q000A00083Q00122Q000B0092012Q00122Q000C0093015Q000A000C00026Q0009000A00122Q00090094015Q000A00083Q00122Q000B0095012Q00122Q000C0096015Q000A000C00026Q0009000A00122Q00090097015Q000A00083Q00122Q000B0098012Q00122Q000C0099015Q000A000C00026Q0009000A00122Q0009009A015Q000A00083Q00122Q000B009B012Q00122Q000C009C015Q000A000C00026Q0009000A00122Q0009009D015Q000A00083Q00122Q000B009E012Q00122Q000C009F015Q000A000C00026Q0009000A001269000900A0013Q0062000A00083Q00122Q000B00A1012Q00122Q000C00A2015Q000A000C00026Q0009000A00122Q000900A3015Q000A00083Q00122Q000B00A4012Q00122Q000C00A5015Q000A000C00026Q0009000A00122Q000900A6015Q000A00083Q00122Q000B00A7012Q00122Q000C00A8015Q000A000C00026Q0009000A00122Q000900A9015Q000A00083Q00122Q000B00AA012Q00122Q000C00AB015Q000A000C00026Q0009000A00122Q000900AC015Q000A00083Q00122Q000B00AD012Q00122Q000C00AE015Q000A000C00026Q0009000A00122Q000900AF015Q000A00083Q00122Q000B00B0012Q00122Q000C00B1015Q000A000C00026Q0009000A00122Q000900B2015Q000A00083Q00122Q000B00B3012Q00122Q000C00B4015Q000A000C00026Q0009000A00122Q000900B5015Q000A00083Q00122Q000B00B6012Q00122Q000C00B7015Q000A000C00026Q0009000A00122Q000900B8015Q000A00083Q00122Q000B00B9012Q00122Q000C00BA015Q000A000C00026Q0009000A00122Q000900BB015Q000A00083Q00122Q000B00BC012Q00122Q000C00BD015Q000A000C00026Q0009000A00122Q000900BE015Q000A00083Q00122Q000B00BF012Q00122Q000C00C0015Q000A000C00026Q0009000A00122Q000900C1015Q000A00083Q00122Q000B00C2012Q00122Q000C00C3015Q000A000C00026Q0009000A00122Q000900C4015Q000A00083Q00122Q000B00C5012Q00122Q000C00C6015Q000A000C00026Q0009000A00122Q000900C7015Q000A00083Q00122Q000B00C8012Q001269000C00C9013Q009A000A000C00026Q0009000A00122Q000900CA015Q000A00083Q00122Q000B00CB012Q00122Q000C00CC015Q000A000C00026Q0009000A00122Q000900CD015Q000A00083Q00122Q000B00CE012Q00122Q000C00CF015Q000A000C00026Q0009000A00122Q000900D0015Q000A00083Q00122Q000B00D1012Q00122Q000C00D2015Q000A000C00026Q0009000A00122Q000900D3015Q000A00083Q00122Q000B00D4012Q00122Q000C00D5015Q000A000C00026Q0009000A00122Q000900D6015Q000A00083Q00122Q000B00D7012Q00122Q000C00D8015Q000A000C00026Q0009000A00122Q000900D9015Q000A00083Q00122Q000B00DA012Q00122Q000C00DB015Q000A000C00026Q0009000A00122Q000900DC015Q000A00083Q00122Q000B00DD012Q00122Q000C00DE015Q000A000C00026Q0009000A00122Q000900DF015Q000A00083Q00122Q000B00E0012Q00122Q000C00E1015Q000A000C00026Q0009000A00122Q000900E2015Q000A00083Q00122Q000B00E3012Q00122Q000C00E4015Q000A000C00026Q0009000A00122Q000900E5015Q000A00083Q00122Q000B00E6012Q00122Q000C00E7015Q000A000C00026Q0009000A00122Q000900E8015Q000A00083Q00122Q000B00E9012Q00122Q000C00EA015Q000A000C00026Q0009000A00122Q000900EB015Q000A00083Q00122Q000B00EC012Q00122Q000C00ED015Q000A000C00026Q0009000A00122Q000900EE015Q000A00083Q00122Q000B00EF012Q00122Q000C00F0015Q000A000C00026Q0009000A001269000900F1013Q0062000A00083Q00122Q000B00F2012Q00122Q000C00F3015Q000A000C00026Q0009000A00122Q000900F4015Q000A00083Q00122Q000B00F5012Q00122Q000C00F6015Q000A000C00026Q0009000A00122Q000900F7015Q000A00083Q00122Q000B00F8012Q00122Q000C00F9015Q000A000C00026Q0009000A00122Q000900FA015Q000A00083Q00122Q000B00FB012Q00122Q000C00FC015Q000A000C00026Q0009000A00122Q000900FD015Q000A00083Q00122Q000B00FE012Q00122Q000C00FF015Q000A000C00026Q0009000A00122Q00092Q00025Q000A00083Q00122Q000B0001022Q00122Q000C002Q025Q000A000C00026Q0009000A00122Q00090003025Q000A00083Q00122Q000B0004022Q00122Q000C0005025Q000A000C00026Q0009000A00122Q00090006025Q000A00083Q00122Q000B0007022Q00122Q000C0008025Q000A000C00026Q0009000A00122Q00090009025Q000A00083Q00122Q000B000A022Q00122Q000C000B025Q000A000C00026Q0009000A00122Q0009000C025Q000A00083Q00122Q000B000D022Q00122Q000C000E025Q000A000C00026Q0009000A00122Q0009000F025Q000A00083Q00122Q000B0010022Q00122Q000C0011025Q000A000C00026Q0009000A00122Q00090012025Q000A00083Q00122Q000B0013022Q00122Q000C0014025Q000A000C00026Q0009000A00122Q00090015025Q000A00083Q00122Q000B0016022Q00122Q000C0017025Q000A000C00026Q0009000A00122Q00090018025Q000A00083Q00122Q000B0019022Q001269000C001A023Q009A000A000C00026Q0009000A00122Q0009001B025Q000A00083Q00122Q000B001C022Q00122Q000C001D025Q000A000C00026Q0009000A00122Q0009001E025Q000A00083Q00122Q000B001F022Q00122Q000C0020025Q000A000C00026Q0009000A00122Q00090021025Q000A00083Q00122Q000B0022022Q00122Q000C0023025Q000A000C00026Q0009000A00122Q00090024025Q000A00083Q00122Q000B0025022Q00122Q000C0026025Q000A000C00026Q0009000A00122Q00090027025Q000A00083Q00122Q000B0028022Q00122Q000C0029025Q000A000C00026Q0009000A00122Q0009002A025Q000A00083Q00122Q000B002B022Q00122Q000C002C025Q000A000C00026Q0009000A00122Q0009002D025Q000A00083Q00122Q000B002E022Q00122Q000C002F025Q000A000C00026Q0009000A00122Q00090030025Q000A00083Q00122Q000B0031022Q00122Q000C0032025Q000A000C00026Q0009000A00122Q00090033025Q000A00083Q00122Q000B0034022Q00122Q000C0035025Q000A000C00026Q0009000A00122Q00090036025Q000A00083Q00122Q000B0037022Q00122Q000C0038025Q000A000C00026Q0009000A00122Q00090039025Q000A00083Q00122Q000B003A022Q00122Q000C003B025Q000A000C00026Q0009000A00122Q0009003C025Q000A00083Q00122Q000B003D022Q00122Q000C003E025Q000A000C00026Q0009000A00122Q0009003F025Q000A00083Q00122Q000B0040022Q00122Q000C0041025Q000A000C00026Q0009000A00126900090042023Q0062000A00083Q00122Q000B0043022Q00122Q000C0044025Q000A000C00026Q0009000A00122Q00090045025Q000A00083Q00122Q000B0046022Q00122Q000C0047025Q000A000C00026Q0009000A00122Q00090048025Q000A00083Q00122Q000B0049022Q00122Q000C004A025Q000A000C00026Q0009000A00122Q0009004B025Q000A00083Q00122Q000B004C022Q00122Q000C004D025Q000A000C00026Q0009000A00122Q0009004E025Q000A00083Q00122Q000B004F022Q00122Q000C0050025Q000A000C00026Q0009000A00122Q00090051025Q000A00083Q00122Q000B0052022Q00122Q000C0053025Q000A000C00026Q0009000A00122Q00090054025Q000A00083Q00122Q000B0055022Q00122Q000C0056025Q000A000C00026Q0009000A00122Q00090057025Q000A00083Q00122Q000B0058022Q00122Q000C0059025Q000A000C00026Q0009000A00122Q0009005A025Q000A00083Q00122Q000B005B022Q00122Q000C005C025Q000A000C00026Q0009000A00122Q0009005D025Q000A00083Q00122Q000B005E022Q00122Q000C005F025Q000A000C00026Q0009000A00122Q00090060025Q000A00083Q00122Q000B0061022Q00122Q000C0062025Q000A000C00026Q0009000A00122Q00090063025Q000A00083Q00122Q000B0064022Q00122Q000C0065025Q000A000C00026Q0009000A00122Q00090066025Q000A00083Q00122Q000B0067022Q00122Q000C0068025Q000A000C00026Q0009000A00122Q00090069025Q000A00083Q00122Q000B006A022Q001269000C006B023Q009A000A000C00026Q0009000A00122Q0009006C025Q000A00083Q00122Q000B006D022Q00122Q000C006E025Q000A000C00026Q0009000A00122Q0009006F025Q000A00083Q00122Q000B0070022Q00122Q000C0071025Q000A000C00026Q0009000A00122Q00090072025Q000A00083Q00122Q000B0073022Q00122Q000C0074025Q000A000C00026Q0009000A00122Q00090075025Q000A00083Q00122Q000B0076022Q00122Q000C0077025Q000A000C00026Q0009000A00122Q00090078025Q000A00083Q00122Q000B0079022Q00122Q000C007A025Q000A000C00026Q0009000A00122Q0009007B025Q000A00083Q00122Q000B007C022Q00122Q000C007D025Q000A000C00026Q0009000A00122Q0009007E025Q000A00083Q00122Q000B007F022Q00122Q000C0080025Q000A000C00026Q0009000A00122Q00090081025Q000A00083Q00122Q000B0082022Q00122Q000C0083025Q000A000C00026Q0009000A00122Q00090084025Q000A00083Q00122Q000B0085022Q00122Q000C0086025Q000A000C00026Q0009000A00122Q00090087025Q000A00083Q00122Q000B0088022Q00122Q000C0089025Q000A000C00026Q0009000A00122Q0009008A025Q000A00083Q00122Q000B008B022Q00122Q000C008C025Q000A000C00026Q0009000A00122Q0009008D025Q000A00083Q00122Q000B008E022Q00122Q000C008F025Q000A000C00026Q0009000A00122Q00090090025Q000A00083Q00122Q000B0091022Q00122Q000C0092025Q000A000C00026Q0009000A00126900090093023Q0062000A00083Q00122Q000B0094022Q00122Q000C0095025Q000A000C00026Q0009000A00122Q00090096025Q000A00083Q00122Q000B0097022Q00122Q000C0098025Q000A000C00026Q0009000A00122Q00090099025Q000A00083Q00122Q000B009A022Q00122Q000C009B025Q000A000C00026Q0009000A00122Q0009009C025Q000A00083Q00122Q000B009D022Q00122Q000C009E025Q000A000C00026Q0009000A00122Q0009009F025Q000A00083Q00122Q000B00A0022Q00122Q000C00A1025Q000A000C00026Q0009000A00122Q000900A2025Q000A00083Q00122Q000B00A3022Q00122Q000C00A4025Q000A000C00026Q0009000A00122Q000900A5025Q000A00083Q00122Q000B00A6022Q00122Q000C00A7025Q000A000C00026Q0009000A00122Q000900A8025Q000A00083Q00122Q000B00A9022Q00122Q000C00AA025Q000A000C00026Q0009000A00122Q000900AB025Q000A00083Q00122Q000B00AC022Q00122Q000C00AD025Q000A000C00026Q0009000A00122Q000900AE025Q000A00083Q00122Q000B00AF022Q00122Q000C00B0025Q000A000C00026Q0009000A00122Q000900B1025Q000A00083Q00122Q000B00B2022Q00122Q000C00B3025Q000A000C00026Q0009000A00122Q000900B4025Q000A00083Q00122Q000B00B5022Q00122Q000C00B6025Q000A000C00026Q0009000A00122Q000900B7025Q000A00083Q00122Q000B00B8022Q00122Q000C00B9025Q000A000C00026Q0009000A00122Q000900BA025Q000A00083Q00122Q000B00BB022Q001269000C00BC023Q009A000A000C00026Q0009000A00122Q000900BD025Q000A00083Q00122Q000B00BE022Q00122Q000C00BF025Q000A000C00026Q0009000A00122Q000900C0025Q000A00083Q00122Q000B00C1022Q00122Q000C00C2025Q000A000C00026Q0009000A00122Q000900C3025Q000A00083Q00122Q000B00C4022Q00122Q000C00C5025Q000A000C00026Q0009000A00122Q000900C6025Q000A00083Q00122Q000B00C7022Q00122Q000C00C8025Q000A000C00026Q0009000A00122Q000900C9025Q000A00083Q00122Q000B00CA022Q00122Q000C00CB025Q000A000C00026Q0009000A00122Q000900CC025Q000A00083Q00122Q000B00CD022Q00122Q000C00CE025Q000A000C00026Q0009000A00122Q000900CF025Q000A00083Q00122Q000B00D0022Q00122Q000C00D1025Q000A000C00026Q0009000A00122Q000900D2025Q000A00083Q00122Q000B00D3022Q00122Q000C00D4025Q000A000C00026Q0009000A00122Q000900D5025Q000A00083Q00122Q000B00D6022Q00122Q000C00D7025Q000A000C00026Q0009000A00122Q000900D8025Q000A00083Q00122Q000B00D9022Q00122Q000C00DA025Q000A000C00026Q0009000A00122Q000900DB025Q000A00083Q00122Q000B00DC022Q00122Q000C00DD025Q000A000C00026Q0009000A00122Q000900DE025Q000A00083Q00122Q000B00DF022Q00122Q000C00E0025Q000A000C00026Q0009000A00122Q000900E1025Q000A00083Q00122Q000B00E2022Q00122Q000C00E3025Q000A000C00026Q0009000A001269000900E4023Q0062000A00083Q00122Q000B00E5022Q00122Q000C00E6025Q000A000C00026Q0009000A00122Q000900E7025Q000A00083Q00122Q000B00E8022Q00122Q000C00E9025Q000A000C00026Q0009000A00122Q000900EA025Q000A00083Q00122Q000B00EB022Q00122Q000C00EC025Q000A000C00026Q0009000A00122Q000900ED025Q000A00083Q00122Q000B00EE022Q00122Q000C00EF025Q000A000C00026Q0009000A00122Q000900F0025Q000A00083Q00122Q000B00F1022Q00122Q000C00F2025Q000A000C00026Q0009000A00122Q000900F3025Q000A00083Q00122Q000B00F4022Q00122Q000C00F5025Q000A000C00026Q0009000A00122Q000900F6025Q000A00083Q00122Q000B00F7022Q00122Q000C00F8025Q000A000C00026Q0009000A00122Q000900F9025Q000A00083Q00122Q000B00FA022Q00122Q000C00FB025Q000A000C00026Q0009000A00122Q000900FC025Q000A00083Q00122Q000B00FD022Q00122Q000C00FE025Q000A000C00026Q0009000A00122Q000900FF025Q000A00083Q00122Q000B2Q00032Q00122Q000C0001035Q000A000C00026Q0009000A00122Q00090002035Q000A00083Q00122Q000B002Q032Q00122Q000C0004035Q000A000C00026Q0009000A00122Q00090005035Q000A00083Q00122Q000B0006032Q00122Q000C0007035Q000A000C00026Q0009000A00122Q00090008035Q000A00083Q00122Q000B0009032Q00122Q000C000A035Q000A000C00026Q0009000A00122Q0009000B035Q000A00083Q00122Q000B000C032Q001269000C000D033Q009A000A000C00026Q0009000A00122Q0009000E035Q000A00083Q00122Q000B000F032Q00122Q000C0010035Q000A000C00026Q0009000A00122Q00090011035Q000A00083Q00122Q000B0012032Q00122Q000C0013035Q000A000C00026Q0009000A00122Q00090014035Q000A00083Q00122Q000B0015032Q00122Q000C0016035Q000A000C00026Q0009000A00122Q00090017035Q000A00083Q00122Q000B0018032Q00122Q000C0019035Q000A000C00026Q0009000A00122Q0009001A035Q000A00083Q00122Q000B001B032Q00122Q000C001C035Q000A000C00026Q0009000A00122Q0009001D035Q000A00083Q00122Q000B001E032Q00122Q000C001F035Q000A000C00026Q0009000A00122Q00090020035Q000A00083Q00122Q000B0021032Q00122Q000C0022035Q000A000C00026Q0009000A00122Q00090023035Q000A00083Q00122Q000B0024032Q00122Q000C0025035Q000A000C00026Q0009000A00122Q00090026035Q000A00083Q00122Q000B0027032Q00122Q000C0028035Q000A000C00026Q0009000A00122Q00090029035Q000A00083Q00122Q000B002A032Q00122Q000C002B035Q000A000C00026Q0009000A00122Q0009002C035Q000A00083Q00122Q000B002D032Q00122Q000C002E035Q000A000C00026Q0009000A00122Q0009002F035Q000A00083Q00122Q000B0030032Q00122Q000C0031035Q000A000C00026Q0009000A00122Q00090032035Q000A00083Q00122Q000B0033032Q00122Q000C0034035Q000A000C00026Q0009000A00126900090035033Q0062000A00083Q00122Q000B0036032Q00122Q000C0037035Q000A000C00026Q0009000A00122Q00090038035Q000A00083Q00122Q000B0039032Q00122Q000C003A035Q000A000C00026Q0009000A00122Q0009003B035Q000A00083Q00122Q000B003C032Q00122Q000C003D035Q000A000C00026Q0009000A00122Q0009003E035Q000A00083Q00122Q000B003F032Q00122Q000C0040035Q000A000C00026Q0009000A00122Q00090041035Q000A00083Q00122Q000B0042032Q00122Q000C0043035Q000A000C00026Q0009000A00122Q00090044035Q000A00083Q00122Q000B0045032Q00122Q000C0046035Q000A000C00026Q0009000A00122Q00090047035Q000A00083Q00122Q000B0048032Q00122Q000C0049035Q000A000C00026Q0009000A00122Q0009004A035Q000A00083Q00122Q000B004B032Q00122Q000C004C035Q000A000C00026Q0009000A00122Q0009004D035Q000A00083Q00122Q000B004E032Q00122Q000C004F035Q000A000C00026Q0009000A00122Q00090050035Q000A00083Q00122Q000B0051032Q00122Q000C0052035Q000A000C00026Q0009000A00122Q00090053035Q000A00083Q00122Q000B0054032Q00122Q000C0055035Q000A000C00026Q0009000A00122Q00090056035Q000A00083Q00122Q000B0057032Q00122Q000C0058035Q000A000C00026Q0009000A00122Q00090059035Q000A00083Q00122Q000B005A032Q00122Q000C005B035Q000A000C00026Q0009000A00122Q0009005C035Q000A00083Q00122Q000B005D032Q001269000C005E033Q009A000A000C00026Q0009000A00122Q0009005F035Q000A00083Q00122Q000B0060032Q00122Q000C0061035Q000A000C00026Q0009000A00122Q00090062035Q000A00083Q00122Q000B0063032Q00122Q000C0064035Q000A000C00026Q0009000A00122Q00090065035Q000A00083Q00122Q000B0066032Q00122Q000C0067035Q000A000C00026Q0009000A00122Q00090068035Q000A00083Q00122Q000B0069032Q00122Q000C006A035Q000A000C00026Q0009000A00122Q0009006B035Q000A00083Q00122Q000B006C032Q00122Q000C006D035Q000A000C00026Q0009000A00122Q0009006E035Q000A00083Q00122Q000B006F032Q00122Q000C0070035Q000A000C00026Q0009000A00122Q00090071035Q000A00083Q00122Q000B0072032Q00122Q000C0073035Q000A000C00026Q0009000A00122Q00090074035Q000A00083Q00122Q000B0075032Q00122Q000C0076035Q000A000C00026Q0009000A00122Q00090077035Q000A00083Q00122Q000B0078032Q00122Q000C0079035Q000A000C00026Q0009000A00122Q0009007A035Q000A00083Q00122Q000B007B032Q00122Q000C007C035Q000A000C00026Q0009000A00122Q0009007D035Q000A00083Q00122Q000B007E032Q00122Q000C007F035Q000A000C00026Q0009000A00122Q00090080035Q000A00083Q00122Q000B0081032Q00122Q000C0082035Q000A000C00026Q0009000A00122Q00090083035Q000A00083Q00122Q000B0084032Q00122Q000C0085035Q000A000C00026Q0009000A00126900090086033Q0062000A00083Q00122Q000B0087032Q00122Q000C0088035Q000A000C00026Q0009000A00122Q00090089035Q000A00083Q00122Q000B008A032Q00122Q000C008B035Q000A000C00026Q0009000A00122Q0009008C035Q000A00083Q00122Q000B008D032Q00122Q000C008E035Q000A000C00026Q0009000A00122Q0009008F035Q000A00083Q00122Q000B0090032Q00122Q000C0091035Q000A000C00026Q0009000A00122Q00090092035Q000A00083Q00122Q000B0093032Q00122Q000C0094035Q000A000C00026Q0009000A00122Q00090095035Q000A00083Q00122Q000B0096032Q00122Q000C0097035Q000A000C00026Q0009000A00122Q00090098035Q000A00083Q00122Q000B0099032Q00122Q000C009A035Q000A000C00026Q0009000A00122Q0009009B035Q000A00083Q00122Q000B009C032Q00122Q000C009D035Q000A000C00026Q0009000A00122Q0009009E035Q000A00083Q00122Q000B009F032Q00122Q000C00A0035Q000A000C00026Q0009000A00122Q000900A1035Q000A00083Q00122Q000B00A2032Q00122Q000C00A3035Q000A000C00026Q0009000A00122Q000900A4035Q000A00083Q00122Q000B00A5032Q00122Q000C00A6035Q000A000C00026Q0009000A00122Q000900A7035Q000A00083Q00122Q000B00A8032Q00122Q000C00A9035Q000A000C00026Q0009000A00122Q000900AA035Q000A00083Q00122Q000B00AB032Q00122Q000C00AC035Q000A000C00026Q0009000A00122Q000900AD035Q000A00083Q00122Q000B00AE032Q001269000C00AF033Q009A000A000C00026Q0009000A00122Q000900B0035Q000A00083Q00122Q000B00B1032Q00122Q000C00B2035Q000A000C00026Q0009000A00122Q000900B3035Q000A00083Q00122Q000B00B4032Q00122Q000C00B5035Q000A000C00026Q0009000A00122Q000900B6035Q000A00083Q00122Q000B00B7032Q00122Q000C00B8035Q000A000C00026Q0009000A00122Q000900B9035Q000A00083Q00122Q000B00BA032Q00122Q000C00BB035Q000A000C00026Q0009000A00122Q000900BC035Q000A00083Q00122Q000B00BD032Q00122Q000C00BE035Q000A000C00026Q0009000A00122Q000900BF035Q000A00083Q00122Q000B00C0032Q00122Q000C00C1035Q000A000C00026Q0009000A00122Q000900C2035Q000A00083Q00122Q000B00C3032Q00122Q000C00C4035Q000A000C00026Q0009000A00122Q000900C5035Q000A00083Q00122Q000B00C6032Q00122Q000C00C7035Q000A000C00026Q0009000A00122Q000900C8035Q000A00083Q00122Q000B00C9032Q00122Q000C00CA035Q000A000C00026Q0009000A00122Q000900CB035Q000A00083Q00122Q000B00CC032Q00122Q000C00CD035Q000A000C00026Q0009000A00122Q000900CE035Q000A00083Q00122Q000B00CF032Q00122Q000C00D0035Q000A000C00026Q0009000A00122Q000900D1035Q000A00083Q00122Q000B00D2032Q00122Q000C00D3035Q000A000C00026Q0009000A00122Q000900D4035Q000A00083Q00122Q000B00D5032Q00122Q000C00D6035Q000A000C00026Q0009000A001269000900D7033Q0062000A00083Q00122Q000B00D8032Q00122Q000C00D9035Q000A000C00026Q0009000A00122Q000900DA035Q000A00083Q00122Q000B00DB032Q00122Q000C00DC035Q000A000C00026Q0009000A00122Q000900DD035Q000A00083Q00122Q000B00DE032Q00122Q000C00DF035Q000A000C00026Q0009000A00122Q000900E0035Q000A00083Q00122Q000B00E1032Q00122Q000C00E2035Q000A000C00026Q0009000A00122Q000900E3035Q000A00083Q00122Q000B00E4032Q00122Q000C00E5035Q000A000C00026Q0009000A00122Q000900E6035Q000A00083Q00122Q000B00E7032Q00122Q000C00E8035Q000A000C00026Q0009000A00122Q000900E9035Q000A00083Q00122Q000B00EA032Q00122Q000C00EB035Q000A000C00026Q0009000A00122Q000900EC035Q000A00083Q00122Q000B00ED032Q00122Q000C00EE035Q000A000C00026Q0009000A00122Q000900EF035Q000A00083Q00122Q000B00F0032Q00122Q000C00F1035Q000A000C00026Q0009000A00122Q000900F2035Q000A00083Q00122Q000B00F3032Q00122Q000C00F4035Q000A000C00026Q0009000A00122Q000900F5035Q000A00083Q00122Q000B00F6032Q00122Q000C00F7035Q000A000C00026Q0009000A00122Q000900F8035Q000A00083Q00122Q000B00F9032Q00122Q000C00FA035Q000A000C00026Q0009000A00122Q000900FB035Q000A00083Q00122Q000B00FC032Q00122Q000C00FD035Q000A000C00026Q0009000A00122Q000900FE035Q000A00083Q00122Q000B00FF032Q001269000C2Q00043Q009A000A000C00026Q0009000A00122Q00090001045Q000A00083Q00122Q000B0002042Q00122Q000C0003045Q000A000C00026Q0009000A00122Q0009002Q045Q000A00083Q00122Q000B0005042Q00122Q000C0006045Q000A000C00026Q0009000A00122Q00090007045Q000A00083Q00122Q000B0008042Q00122Q000C0009045Q000A000C00026Q0009000A00122Q0009000A045Q000A00083Q00122Q000B000B042Q00122Q000C000C045Q000A000C00026Q0009000A00122Q0009000D045Q000A00083Q00122Q000B000E042Q00122Q000C000F045Q000A000C00026Q0009000A00122Q00090010045Q000A00083Q00122Q000B0011042Q00122Q000C0012045Q000A000C00026Q0009000A00122Q00090013045Q000A00083Q00122Q000B0014042Q00122Q000C0015045Q000A000C00026Q0009000A00122Q00090016045Q000A00083Q00122Q000B0017042Q00122Q000C0018045Q000A000C00026Q0009000A00122Q00090019045Q000A00083Q00122Q000B001A042Q00122Q000C001B045Q000A000C00026Q0009000A00122Q0009001C045Q000A00083Q00122Q000B001D042Q00122Q000C001E045Q000A000C00026Q0009000A00122Q0009001F045Q000A00083Q00122Q000B0020042Q00122Q000C0021045Q000A000C00026Q0009000A00122Q00090022045Q000A00083Q00122Q000B0023042Q00122Q000C0024045Q000A000C00026Q0009000A00122Q00090025045Q000A00083Q00122Q000B0026042Q00122Q000C0027045Q000A000C00026Q0009000A00126900090028043Q0062000A00083Q00122Q000B0029042Q00122Q000C002A045Q000A000C00026Q0009000A00122Q0009002B045Q000A00083Q00122Q000B002C042Q00122Q000C002D045Q000A000C00026Q0009000A00122Q0009002E045Q000A00083Q00122Q000B002F042Q00122Q000C0030045Q000A000C00026Q0009000A00122Q00090031045Q000A00083Q00122Q000B0032042Q00122Q000C0033045Q000A000C00026Q0009000A00122Q00090034045Q000A00083Q00122Q000B0035042Q00122Q000C0036045Q000A000C00026Q0009000A00122Q00090037045Q000A00083Q00122Q000B0038042Q00122Q000C0039045Q000A000C00026Q0009000A00122Q0009003A045Q000A00083Q00122Q000B003B042Q00122Q000C003C045Q000A000C00026Q0009000A00122Q0009003D045Q000A00083Q00122Q000B003E042Q00122Q000C003F045Q000A000C00026Q0009000A00122Q00090040045Q000A00083Q00122Q000B0041042Q00122Q000C0042045Q000A000C00026Q0009000A00122Q00090043045Q000A00083Q00122Q000B0044042Q00122Q000C0045045Q000A000C00026Q0009000A00122Q00090046045Q000A00083Q00122Q000B0047042Q00122Q000C0048045Q000A000C00026Q0009000A00122Q00090049045Q000A00083Q00122Q000B004A042Q00122Q000C004B045Q000A000C00026Q0009000A00122Q0009004C045Q000A00083Q00122Q000B004D042Q00122Q000C004E045Q000A000C00026Q0009000A00122Q0009004F045Q000A00083Q00122Q000B0050042Q001269000C0051043Q009A000A000C00026Q0009000A00122Q00090052045Q000A00083Q00122Q000B0053042Q00122Q000C0054045Q000A000C00026Q0009000A00122Q00090055045Q000A00083Q00122Q000B0056042Q00122Q000C0057045Q000A000C00026Q0009000A00122Q00090058045Q000A00083Q00122Q000B0059042Q00122Q000C005A045Q000A000C00026Q0009000A00122Q0009005B045Q000A00083Q00122Q000B005C042Q00122Q000C005D045Q000A000C00026Q0009000A00122Q0009005E045Q000A00083Q00122Q000B005F042Q00122Q000C0060045Q000A000C00026Q0009000A00122Q00090061045Q000A00083Q00122Q000B0062042Q00122Q000C0063045Q000A000C00026Q0009000A00122Q00090064045Q000A00083Q00122Q000B0065042Q00122Q000C0066045Q000A000C00026Q0009000A00122Q00090067045Q000A00083Q00122Q000B0068042Q00122Q000C0069045Q000A000C00026Q0009000A00122Q0009006A045Q000A00083Q00122Q000B006B042Q00122Q000C006C045Q000A000C00026Q0009000A00122Q0009006D045Q000A00083Q00122Q000B006E042Q00122Q000C006F045Q000A000C00026Q0009000A00122Q00090070045Q000A00083Q00122Q000B0071042Q00122Q000C0072045Q000A000C00026Q0009000A00122Q00090073045Q000A00083Q00122Q000B0074042Q00122Q000C0075045Q000A000C00026Q0009000A00122Q00090076045Q000A00083Q00122Q000B0077042Q00122Q000C0078045Q000A000C00026Q0009000A00126900090079043Q0062000A00083Q00122Q000B007A042Q00122Q000C007B045Q000A000C00026Q0009000A00122Q0009007C045Q000A00083Q00122Q000B007D042Q00122Q000C007E045Q000A000C00026Q0009000A00122Q0009007F045Q000A00083Q00122Q000B0080042Q00122Q000C0081045Q000A000C00026Q0009000A00122Q00090082045Q000A00083Q00122Q000B0083042Q00122Q000C0084045Q000A000C00026Q0009000A00122Q00090085045Q000A00083Q00122Q000B0086042Q00122Q000C0087045Q000A000C00026Q0009000A00122Q00090088045Q000A00083Q00122Q000B0089042Q00122Q000C008A045Q000A000C00026Q0009000A00122Q0009008B045Q000A00083Q00122Q000B008C042Q00122Q000C008D045Q000A000C00026Q0009000A00122Q0009008E045Q000A00083Q00122Q000B008F042Q00122Q000C0090045Q000A000C00026Q0009000A00122Q00090091045Q000A00083Q00122Q000B0092042Q00122Q000C0093045Q000A000C00026Q0009000A00122Q00090094045Q000A00083Q00122Q000B0095042Q00122Q000C0096045Q000A000C00026Q0009000A00122Q00090097045Q000A00083Q00122Q000B0098042Q00122Q000C0099045Q000A000C00026Q0009000A00122Q0009009A045Q000A00083Q00122Q000B009B042Q00122Q000C009C045Q000A000C00026Q0009000A00122Q0009009D045Q000A00083Q00122Q000B009E042Q00122Q000C009F045Q000A000C00026Q0009000A00122Q000900A0045Q000A00083Q00122Q000B00A1042Q001269000C00A2043Q009A000A000C00026Q0009000A00122Q000900A3045Q000A00083Q00122Q000B00A4042Q00122Q000C00A5045Q000A000C00026Q0009000A00122Q000900A6045Q000A00083Q00122Q000B00A7042Q00122Q000C00A8045Q000A000C00026Q0009000A00122Q000900A9045Q000A00083Q00122Q000B00AA042Q00122Q000C00AB045Q000A000C00026Q0009000A00122Q000900AC045Q000A00083Q00122Q000B00AD042Q00122Q000C00AE045Q000A000C00026Q0009000A00122Q000900AF045Q000A00083Q00122Q000B00B0042Q00122Q000C00B1045Q000A000C00026Q0009000A00122Q000900B2045Q000A00083Q00122Q000B00B3042Q00122Q000C00B4045Q000A000C00026Q0009000A00122Q000900B5045Q000A00083Q00122Q000B00B6042Q00122Q000C00B7045Q000A000C00026Q0009000A00122Q000900B8045Q000A00083Q00122Q000B00B9042Q00122Q000C00BA045Q000A000C00026Q0009000A00122Q000900BB045Q000A00083Q00122Q000B00BC042Q00122Q000C00BD045Q000A000C00026Q0009000A00122Q000900BE045Q000A00083Q00122Q000B00BF042Q00122Q000C00C0045Q000A000C00026Q0009000A00122Q000900C1045Q000A00083Q00122Q000B00C2042Q00122Q000C00C3045Q000A000C00026Q0009000A00122Q000900C4045Q000A00083Q00122Q000B00C5042Q00122Q000C00C6045Q000A000C00026Q0009000A00122Q000900C7045Q000A00083Q00122Q000B00C8042Q00122Q000C00C9045Q000A000C00026Q0009000A001269000900CA043Q0062000A00083Q00122Q000B00CB042Q00122Q000C00CC045Q000A000C00026Q0009000A00122Q000900CD045Q000A00083Q00122Q000B00CE042Q00122Q000C00CF045Q000A000C00026Q0009000A00122Q000900D0045Q000A00083Q00122Q000B00D1042Q00122Q000C00D2045Q000A000C00026Q0009000A00122Q000900D3045Q000A00083Q00122Q000B00D4042Q00122Q000C00D5045Q000A000C00026Q0009000A00122Q000900D6045Q000A00083Q00122Q000B00D7042Q00122Q000C00D8045Q000A000C00026Q0009000A00122Q000900D9045Q000A00083Q00122Q000B00DA042Q00122Q000C00DB045Q000A000C00026Q0009000A00122Q000900DC045Q000A00083Q00122Q000B00DD042Q00122Q000C00DE045Q000A000C00026Q0009000A00122Q000900DF045Q000A00083Q00122Q000B00E0042Q00122Q000C00E1045Q000A000C00026Q0009000A00122Q000900E2045Q000A00083Q00122Q000B00E3042Q00122Q000C00E4045Q000A000C00026Q0009000A00122Q000900E5045Q000A00083Q00122Q000B00E6042Q00122Q000C00E7045Q000A000C00026Q0009000A00122Q000900E8045Q000A00083Q00122Q000B00E9042Q00122Q000C00EA045Q000A000C00026Q0009000A00122Q000900EB045Q000A00083Q00122Q000B00EC042Q00122Q000C00ED045Q000A000C00026Q0009000A00122Q000900EE045Q000A00083Q00122Q000B00EF042Q00122Q000C00F0045Q000A000C00026Q0009000A00122Q000900F1045Q000A00083Q00122Q000B00F2042Q001269000C00F3043Q009A000A000C00026Q0009000A00122Q000900F4045Q000A00083Q00122Q000B00F5042Q00122Q000C00F6045Q000A000C00026Q0009000A00122Q000900F7045Q000A00083Q00122Q000B00F8042Q00122Q000C00F9045Q000A000C00026Q0009000A00122Q000900FA045Q000A00083Q00122Q000B00FB042Q00122Q000C00FC045Q000A000C00026Q0009000A00122Q000900FD045Q000A00083Q00122Q000B00FE042Q00122Q000C00FF045Q000A000C00026Q0009000A00122Q00092Q00055Q000A00083Q00122Q000B0001052Q00122Q000C0002055Q000A000C00026Q0009000A00122Q00090003055Q000A00083Q00122Q000B0004052Q00122Q000C002Q055Q000A000C00026Q0009000A00122Q00090006055Q000A00083Q00122Q000B0007052Q00122Q000C0008055Q000A000C00026Q0009000A00122Q00090009055Q000A00083Q00122Q000B000A052Q00122Q000C000B055Q000A000C00026Q0009000A00122Q0009000C055Q000A00083Q00122Q000B000D052Q00122Q000C000E055Q000A000C00026Q0009000A00122Q0009000F055Q000A00083Q00122Q000B0010052Q00122Q000C0011055Q000A000C00026Q0009000A00122Q00090012055Q000A00083Q00122Q000B0013052Q00122Q000C0014055Q000A000C00026Q0009000A00122Q00090015055Q000A00083Q00122Q000B0016052Q00122Q000C0017055Q000A000C00026Q0009000A00122Q00090018055Q000A00083Q00122Q000B0019052Q00122Q000C001A055Q000A000C00026Q0009000A0012690009001B053Q0062000A00083Q00122Q000B001C052Q00122Q000C001D055Q000A000C00026Q0009000A00122Q0009001E055Q000A00083Q00122Q000B001F052Q00122Q000C0020055Q000A000C00026Q0009000A00122Q00090021055Q000A00083Q00122Q000B0022052Q00122Q000C0023055Q000A000C00026Q0009000A00122Q00090024055Q000A00083Q00122Q000B0025052Q00122Q000C0026055Q000A000C00026Q0009000A00122Q00090027055Q000A00083Q00122Q000B0028052Q00122Q000C0029055Q000A000C00026Q0009000A00122Q0009002A055Q000A00083Q00122Q000B002B052Q00122Q000C002C055Q000A000C00026Q0009000A00122Q0009002D055Q000A00083Q00122Q000B002E052Q00122Q000C002F055Q000A000C00026Q0009000A00122Q00090030055Q000A00083Q00122Q000B0031052Q00122Q000C0032055Q000A000C00026Q0009000A00122Q00090033055Q000A00083Q00122Q000B0034052Q00122Q000C0035055Q000A000C00026Q0009000A00122Q00090036055Q000A00083Q00122Q000B0037052Q00122Q000C0038055Q000A000C00026Q0009000A00122Q00090039055Q000A00083Q00122Q000B003A052Q00122Q000C003B055Q000A000C00026Q0009000A00122Q0009003C055Q000A00083Q00122Q000B003D052Q00122Q000C003E055Q000A000C00026Q0009000A00122Q0009003F055Q000A00083Q00122Q000B0040052Q00122Q000C0041055Q000A000C00026Q0009000A00122Q00090042055Q000A00083Q00122Q000B0043052Q0012B9000C0044055Q000A000C00026Q0009000A00122Q00090045055Q000A00083Q00122Q000B0046052Q00122Q000C0047055Q000A000C00026Q0009000A00122Q00090048053Q0018000A00083Q00122Q000B0049052Q00122Q000C004A055Q000A000C00026Q0009000A00122Q0009004B055Q000A00083Q00122Q000B004C052Q00122Q000C004D055Q000A000C00022Q00953Q0009000A0012690009004E053Q0018000A00083Q00122Q000B004F052Q00122Q000C0050055Q000A000C00026Q0009000A00122Q00090051055Q000A00083Q00122Q000B0052052Q00122Q000C0053055Q000A000C00022Q00953Q0009000A00126900090051053Q0076000A000A3Q001269000B0051052Q00064E000900590A01000B0004073Q00590A01001269000B0051052Q001269000C0051052Q00064E000B005D0A01000C0004073Q005D0A012Q003B000C3Q0022002Q12000D0051055Q000D3Q000D4Q000E3Q000200122Q000F004E055Q000F3Q000F4Q00103Q000500122Q0011004B055Q00113Q00114Q001200013Q00122Q00130048053Q009000133Q00132Q00080012000100012Q009500100011001200125600110045055Q00113Q00114Q001200013Q00122Q00130042055Q00133Q00134Q0012000100012Q00950010001100120012560011003F055Q00113Q00114Q001200013Q00122Q0013003C055Q00133Q00134Q0012000100012Q009500100011001200125600110039055Q00113Q00114Q001200013Q00122Q00130036055Q00133Q00134Q0012000100012Q009500100011001200125600110033055Q00113Q00114Q001200013Q00122Q00130030055Q00133Q00134Q0012000100012Q00950010001100122Q0085000E000F001000122Q000F002D055Q000F3Q000F00122Q0010002A055Q00103Q00104Q000E000F00104Q000C000D000E00122Q000D0027055Q000D3Q000D4Q000E3Q0002001269000F0024053Q002A000F3Q000F4Q00103Q000200122Q00110021055Q00113Q00114Q001200013Q00122Q0013001E055Q00133Q00134Q0012000100012Q00950010001100120012560011001B055Q00113Q00114Q001200013Q00122Q00130018055Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0015055Q000F3Q000F00122Q00100054055Q000E000F00104Q000C000D000E00122Q000D0012055Q000D3Q000D4Q000E3Q000200122Q000F000F053Q002A000F3Q000F4Q00103Q000100122Q0011000C055Q00113Q00114Q001200013Q00122Q00130009055Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0006055Q000F3Q000F00122Q00100054055Q000E000F00104Q000C000D000E00122Q000D0003055Q000D3Q000D4Q000E3Q000200122Q000F2Q00053Q002A000F3Q000F4Q00103Q000300122Q001100FD045Q00113Q00114Q001200013Q00122Q001300FA045Q00133Q00134Q0012000100012Q0095001000110012001256001100F7045Q00113Q00114Q001200013Q00122Q001300F4045Q00133Q00134Q0012000100012Q0095001000110012001256001100F1045Q00113Q00114Q001200013Q00122Q001300EE045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00EB045Q000F3Q000F00122Q00100054055Q000E000F00104Q000C000D000E00122Q000D00E8045Q000D3Q000D4Q000E3Q000200122Q000F00E5043Q002A000F3Q000F4Q00103Q000100122Q001100E2045Q00113Q00114Q001200013Q00122Q001300DF045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00DC045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00D9045Q000D3Q000D4Q000E3Q000200122Q000F00D6043Q002A000F3Q000F4Q00103Q000200122Q001100D3045Q00113Q00114Q001200013Q00122Q001300D0045Q00133Q00134Q0012000100012Q0095001000110012001256001100CD045Q00113Q00114Q001200013Q00122Q001300CA045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00C7045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00C4045Q000D3Q000D4Q000E3Q000200122Q000F00C1043Q002A000F3Q000F4Q00103Q000100122Q001100BE045Q00113Q00114Q001200013Q00122Q001300BB045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00B8045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00B5045Q000D3Q000D4Q000E3Q000200122Q000F00B2043Q002A000F3Q000F4Q00103Q000100122Q001100AF045Q00113Q00114Q001200013Q00122Q001300AC045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00A9045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00A6045Q000D3Q000D4Q000E3Q000200122Q000F00A3043Q002A000F3Q000F4Q00103Q000100122Q001100A0045Q00113Q00114Q001200013Q00122Q0013009D045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F009A045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D0097045Q000D3Q000D4Q000E3Q000200122Q000F0094043Q002A000F3Q000F4Q00103Q000400122Q00110091045Q00113Q00114Q001200013Q00122Q0013008E045Q00133Q00134Q0012000100012Q00950010001100120012560011008B045Q00113Q00114Q001200013Q00122Q00130088045Q00133Q00134Q0012000100012Q009500100011001200125600110085045Q00113Q00114Q001200013Q00122Q00130082045Q00133Q00134Q0012000100012Q00950010001100120012560011007F045Q00113Q00114Q001200013Q00122Q0013007C045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0079045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D0076045Q000D3Q000D4Q000E3Q000200122Q000F0073043Q002A000F3Q000F4Q00103Q000100122Q00110070045Q00113Q00114Q001200013Q00122Q0013006D045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F006A045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D0067045Q000D3Q000D4Q000E3Q000200122Q000F0064043Q002A000F3Q000F4Q00103Q000200122Q00110061045Q00113Q00114Q001200013Q00122Q0013005E045Q00133Q00134Q0012000100012Q00950010001100120012560011005B045Q00113Q00114Q001200013Q00122Q00130058045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0055045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D0052045Q000D3Q000D4Q000E3Q000200122Q000F004F043Q002A000F3Q000F4Q00103Q000100122Q0011004C045Q00113Q00114Q001200013Q00122Q00130049045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0046045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D0043045Q000D3Q000D4Q000E3Q000200122Q000F0040043Q002A000F3Q000F4Q00103Q000200122Q0011003D045Q00113Q00114Q001200013Q00122Q0013003A045Q00133Q00134Q0012000100012Q009500100011001200125600110037045Q00113Q00114Q001200013Q00122Q00130034045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0031045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D002E045Q000D3Q000D4Q000E3Q000200122Q000F002B043Q002A000F3Q000F4Q00103Q000200122Q00110028045Q00113Q00114Q001200013Q00122Q00130025045Q00133Q00134Q0012000100012Q009500100011001200125600110022045Q00113Q00114Q001200013Q00122Q0013001F045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F001C045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D0019045Q000D3Q000D4Q000E3Q000200122Q000F0016043Q002A000F3Q000F4Q00103Q000100122Q00110013045Q00113Q00114Q001200013Q00122Q00130010045Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F000D045Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D000A045Q000D3Q000D4Q000E3Q000200122Q000F0007043Q002A000F3Q000F4Q00103Q000200122Q0011002Q045Q00113Q00114Q001200013Q00122Q00130001045Q00133Q00134Q0012000100012Q0095001000110012001256001100FE035Q00113Q00114Q001200013Q00122Q001300FB035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00F8035Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00F5035Q000D3Q000D4Q000E3Q000200122Q000F00F2033Q002A000F3Q000F4Q00103Q000100122Q001100EF035Q00113Q00114Q001200013Q00122Q001300EC035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00E9035Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00E6035Q000D3Q000D4Q000E3Q000200122Q000F00E3033Q002A000F3Q000F4Q00103Q000100122Q001100E0035Q00113Q00114Q001200013Q00122Q001300DD035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00DA035Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D00D7035Q000D3Q000D4Q000E3Q000200122Q000F00D4033Q002A000F3Q000F4Q00103Q000100122Q001100D1035Q00113Q00114Q001200013Q00122Q001300CE035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00CB035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00C8035Q000D3Q000D4Q000E3Q000200122Q000F00C5033Q002A000F3Q000F4Q00103Q000100122Q001100C2035Q00113Q00114Q001200013Q00122Q001300BF035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00BC035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00B9035Q000D3Q000D4Q000E3Q000200122Q000F00B6033Q002A000F3Q000F4Q00103Q000100122Q001100B3035Q00113Q00114Q001200013Q00122Q001300B0035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00AD035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00AA035Q000D3Q000D4Q000E3Q000200122Q000F00A7033Q002A000F3Q000F4Q00103Q000100122Q001100A4035Q00113Q00114Q001200013Q00122Q001300A1035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F009E035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D009B035Q000D3Q000D4Q000E3Q000200122Q000F0098033Q002A000F3Q000F4Q00103Q000100122Q00110095035Q00113Q00114Q001200013Q00122Q00130092035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F008F035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D008C035Q000D3Q000D4Q000E3Q000200122Q000F0089033Q002A000F3Q000F4Q00103Q000100122Q00110086035Q00113Q00114Q001200013Q00122Q00130083035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0080035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D007D035Q000D3Q000D4Q000E3Q000200122Q000F007A033Q002A000F3Q000F4Q00103Q000300122Q00110077035Q00113Q00114Q001200013Q00122Q00130074035Q00133Q00134Q0012000100012Q009500100011001200125600110071035Q00113Q00114Q001200013Q00122Q0013006E035Q00133Q00134Q0012000100012Q00950010001100120012560011006B035Q00113Q00114Q001200013Q00122Q00130068035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0065035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0062035Q000D3Q000D4Q000E3Q000200122Q000F005F033Q002A000F3Q000F4Q00103Q000100122Q0011005C035Q00113Q00114Q001200013Q00122Q00130059035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0056035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0053035Q000D3Q000D4Q000E3Q000200122Q000F0050033Q002A000F3Q000F4Q00103Q000200122Q0011004D035Q00113Q00114Q001200013Q00122Q0013004A035Q00133Q00134Q0012000100012Q009500100011001200125600110047035Q00113Q00114Q001200013Q00122Q00130044035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0041035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D003E035Q000D3Q000D4Q000E3Q000200122Q000F003B033Q002A000F3Q000F4Q00103Q000200122Q00110038035Q00113Q00114Q001200013Q00122Q00130035035Q00133Q00134Q0012000100012Q009500100011001200125600110032035Q00113Q00114Q001200013Q00122Q0013002F035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F002C035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0029035Q000D3Q000D4Q000E3Q000200122Q000F0026033Q002A000F3Q000F4Q00103Q000100122Q00110023035Q00113Q00114Q001200013Q00122Q00130020035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F001D035Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D001A035Q000D3Q000D4Q000E3Q000200122Q000F0017033Q002A000F3Q000F4Q00103Q000100122Q00110014035Q00113Q00114Q001200013Q00122Q00130011035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F000E035Q000F3Q000F00122Q00100055055Q000E000F00104Q000C000D000E00122Q000D000B035Q000D3Q000D4Q000E3Q000200122Q000F0008033Q002A000F3Q000F4Q00103Q000100122Q00110005035Q00113Q00114Q001200013Q00122Q00130002035Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00FF025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00FC025Q000D3Q000D4Q000E3Q000200122Q000F00F9023Q002A000F3Q000F4Q00103Q000100122Q001100F6025Q00113Q00114Q001200013Q00122Q001300F3025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00F0025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00ED025Q000D3Q000D4Q000E3Q000200122Q000F00EA023Q002A000F3Q000F4Q00103Q000100122Q001100E7025Q00113Q00114Q001200013Q00122Q001300E4025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00E1025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00DE025Q000D3Q000D4Q000E3Q000200122Q000F00DB023Q002A000F3Q000F4Q00103Q000200122Q001100D8025Q00113Q00114Q001200013Q00122Q001300D5025Q00133Q00134Q0012000100012Q0095001000110012001256001100D2025Q00113Q00114Q001200013Q00122Q001300CF025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00CC025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00C9025Q000D3Q000D4Q000E3Q000200122Q000F00C6023Q002A000F3Q000F4Q00103Q000100122Q001100C3025Q00113Q00114Q001200013Q00122Q001300C0025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00BD025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00BA025Q000D3Q000D4Q000E3Q000200122Q000F00B7023Q002A000F3Q000F4Q00103Q000100122Q001100B4025Q00113Q00114Q001200013Q00122Q001300B1025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00AE025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00AB025Q000D3Q000D4Q000E3Q000200122Q000F00A8023Q002A000F3Q000F4Q00103Q000100122Q001100A5025Q00113Q00114Q001200013Q00122Q001300A2025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F009F025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D009C025Q000D3Q000D4Q000E3Q000200122Q000F0099023Q002A000F3Q000F4Q00103Q000100122Q00110096025Q00113Q00114Q001200013Q00122Q00130093025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0090025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D008D025Q000D3Q000D4Q000E3Q000200122Q000F008A023Q002A000F3Q000F4Q00103Q000100122Q00110087025Q00113Q00114Q001200013Q00122Q00130084025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0081025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D007E025Q000D3Q000D4Q000E3Q000200122Q000F007B023Q002A000F3Q000F4Q00103Q000300122Q00110078025Q00113Q00114Q001200013Q00122Q00130075025Q00133Q00134Q0012000100012Q009500100011001200125600110072025Q00113Q00114Q001200013Q00122Q0013006F025Q00133Q00134Q0012000100012Q00950010001100120012560011006C025Q00113Q00114Q001200013Q00122Q00130069025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0066025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0063025Q000D3Q000D4Q000E3Q000200122Q000F0060023Q002A000F3Q000F4Q00103Q000300122Q0011005D025Q00113Q00114Q001200013Q00122Q0013005A025Q00133Q00134Q0012000100012Q009500100011001200125600110057025Q00113Q00114Q001200013Q00122Q00130054025Q00133Q00134Q0012000100012Q009500100011001200125600110051025Q00113Q00114Q001200013Q00122Q0013004E025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F004B025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0048025Q000D3Q000D4Q000E3Q000200122Q000F0045023Q002A000F3Q000F4Q00103Q000100122Q00110042025Q00113Q00114Q001200013Q00122Q0013003F025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F003C025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0039025Q000D3Q000D4Q000E3Q000200122Q000F0036023Q002A000F3Q000F4Q00103Q000200122Q00110033025Q00113Q00114Q001200013Q00122Q00130030025Q00133Q00134Q0012000100012Q00950010001100120012560011002D025Q00113Q00114Q001200013Q00122Q0013002A025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0027025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0024025Q000D3Q000D4Q000E3Q000200122Q000F0021023Q002A000F3Q000F4Q00103Q000200122Q0011001E025Q00113Q00114Q001200013Q00122Q0013001B025Q00133Q00134Q0012000100012Q009500100011001200125600110018025Q00113Q00114Q001200013Q00122Q00130015025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0012025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D000F025Q000D3Q000D4Q000E3Q000200122Q000F000C023Q002A000F3Q000F4Q00103Q000100122Q00110009025Q00113Q00114Q001200013Q00122Q00130006025Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0003025Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D2Q00025Q000D3Q000D4Q000E3Q000200122Q000F00FD013Q002A000F3Q000F4Q00103Q000200122Q001100FA015Q00113Q00114Q001200013Q00122Q001300F7015Q00133Q00134Q0012000100012Q0095001000110012001256001100F4015Q00113Q00114Q001200013Q00122Q001300F1015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00EE015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00EB015Q000D3Q000D4Q000E3Q000200122Q000F00E8013Q002A000F3Q000F4Q00103Q000100122Q001100E5015Q00113Q00114Q001200013Q00122Q001300E2015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00DF015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00DC015Q000D3Q000D4Q000E3Q000200122Q000F00D9013Q002A000F3Q000F4Q00103Q000100122Q001100D6015Q00113Q00114Q001200013Q00122Q001300D3015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00D0015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00CD015Q000D3Q000D4Q000E3Q000200122Q000F00CA013Q002A000F3Q000F4Q00103Q000100122Q001100C7015Q00113Q00114Q001200013Q00122Q001300C4015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00C1015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00BE015Q000D3Q000D4Q000E3Q000200122Q000F00BB013Q002A000F3Q000F4Q00103Q000100122Q001100B8015Q00113Q00114Q001200013Q00122Q001300B5015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00B2015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00AF015Q000D3Q000D4Q000E3Q000200122Q000F00AC013Q002A000F3Q000F4Q00103Q000100122Q001100A9015Q00113Q00114Q001200013Q00122Q001300A6015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00A3015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00A0015Q000D3Q000D4Q000E3Q000200122Q000F009D013Q002A000F3Q000F4Q00103Q000100122Q0011009A015Q00113Q00114Q001200013Q00122Q00130097015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0094015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0091015Q000D3Q000D4Q000E3Q000200122Q000F008E013Q002A000F3Q000F4Q00103Q000200122Q0011008B015Q00113Q00114Q001200013Q00122Q00130088015Q00133Q00134Q0012000100012Q009500100011001200125600110085015Q00113Q00114Q001200013Q00122Q00130082015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F007F015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D007C015Q000D3Q000D4Q000E3Q000200122Q000F0079013Q002A000F3Q000F4Q00103Q000100122Q00110076015Q00113Q00114Q001200013Q00122Q00130073015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0070015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D006D015Q000D3Q000D4Q000E3Q000200122Q000F006A013Q002A000F3Q000F4Q00103Q000100122Q00110067015Q00113Q00114Q001200013Q00122Q00130064015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0061015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D005E015Q000D3Q000D4Q000E3Q000200122Q000F005B013Q002A000F3Q000F4Q00103Q000200122Q00110058015Q00113Q00114Q001200013Q00122Q00130055015Q00133Q00134Q0012000100012Q009500100011001200125600110052015Q00113Q00114Q001200013Q00122Q0013004F015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F004C015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0049015Q000D3Q000D4Q000E3Q000200122Q000F0046013Q002A000F3Q000F4Q00103Q000100122Q00110043015Q00113Q00114Q001200013Q00122Q00130040015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F003D015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D003A015Q000D3Q000D4Q000E3Q000200122Q000F0037013Q002A000F3Q000F4Q00103Q000100122Q00110034015Q00113Q00114Q001200013Q00122Q00130031015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F002E015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D002B015Q000D3Q000D4Q000E3Q000200122Q000F0028013Q002A000F3Q000F4Q00103Q000200122Q00110025015Q00113Q00114Q001200013Q00122Q00130022015Q00133Q00134Q0012000100012Q00950010001100120012560011001F015Q00113Q00114Q001200013Q00122Q0013001C015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F0019015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0016015Q000D3Q000D4Q000E3Q000200122Q000F0013013Q002A000F3Q000F4Q00103Q000100122Q00110010015Q00113Q00114Q001200013Q00122Q0013000D015Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F000A015Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D0007015Q000D3Q000D4Q000E3Q000200122Q000F0004013Q002A000F3Q000F4Q00103Q000100122Q0011002Q015Q00113Q00114Q001200013Q00122Q001300FE6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00FB6Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00F86Q000D3Q000D4Q000E3Q000200122Q000F00F54Q002A000F3Q000F4Q00103Q000100122Q001100F26Q00113Q00114Q001200013Q00122Q001300EF6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00EC6Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00E96Q000D3Q000D4Q000E3Q000200122Q000F00E64Q002A000F3Q000F4Q00103Q000200122Q001100E36Q00113Q00114Q001200013Q00122Q001300E06Q00133Q00134Q0012000100012Q0095001000110012001256001100DD6Q00113Q00114Q001200013Q00122Q001300DA6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00D76Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00D46Q000D3Q000D4Q000E3Q000200122Q000F00D14Q002A000F3Q000F4Q00103Q000100122Q001100CE6Q00113Q00114Q001200013Q00122Q001300CB6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00C86Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00C56Q000D3Q000D4Q000E3Q000200122Q000F00C24Q002A000F3Q000F4Q00103Q000400122Q001100BF6Q00113Q00114Q001200013Q00122Q001300BC6Q00133Q00134Q0012000100012Q0095001000110012001256001100B96Q00113Q00114Q001200013Q00122Q001300B66Q00133Q00134Q0012000100012Q0095001000110012001256001100B36Q00113Q00114Q001200013Q00122Q001300B06Q00133Q00134Q0012000100012Q0095001000110012001256001100AD6Q00113Q00114Q001200013Q00122Q001300AA6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00A76Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00A46Q000D3Q000D4Q000E3Q000200122Q000F00A14Q002A000F3Q000F4Q00103Q000100122Q0011009E6Q00113Q00114Q001200013Q00122Q0013009B6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00986Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00956Q000D3Q000D4Q000E3Q000200122Q000F00924Q002A000F3Q000F4Q00103Q000100122Q0011008F6Q00113Q00114Q001200013Q00122Q0013008C6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00896Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00866Q000D3Q000D4Q000E3Q000200122Q000F00834Q002A000F3Q000F4Q00103Q000100122Q001100806Q00113Q00114Q001200013Q00122Q0013007D6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F007A6Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00776Q000D3Q000D4Q000E3Q000200122Q000F00744Q002A000F3Q000F4Q00103Q000200122Q001100716Q00113Q00114Q001200013Q00122Q0013006E6Q00133Q00134Q0012000100012Q00950010001100120012560011006B6Q00113Q00114Q001200013Q00122Q001300686Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00656Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00626Q000D3Q000D4Q000E3Q000200122Q000F005F4Q002A000F3Q000F4Q00103Q000100122Q0011005C6Q00113Q00114Q001200013Q00122Q001300596Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00566Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00536Q000D3Q000D4Q000E3Q000200122Q000F00504Q002A000F3Q000F4Q00103Q000100122Q0011004D6Q00113Q00114Q001200013Q00122Q0013004A6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00476Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00446Q000D3Q000D4Q000E3Q000200122Q000F00414Q002A000F3Q000F4Q00103Q000100122Q0011003E6Q00113Q00114Q001200013Q00122Q0013003B6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00386Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00356Q000D3Q000D4Q000E3Q000200122Q000F00324Q002A000F3Q000F4Q00103Q000100122Q0011002F6Q00113Q00114Q001200013Q00122Q0013002C6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F00296Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00266Q000D3Q000D4Q000E3Q000200122Q000F00234Q002A000F3Q000F4Q00103Q000100122Q001100206Q00113Q00114Q001200013Q00122Q0013001D6Q00133Q00134Q0012000100012Q00950010001100122Q00D9000E000F001000122Q000F001A6Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E00122Q000D00176Q000D3Q000D4Q000E3Q000200122Q000F00144Q002A000F3Q000F4Q00103Q000100122Q001100116Q00113Q00114Q001200013Q00122Q0013000E6Q00133Q00134Q0012000100012Q00950010001100122Q005E000E000F001000122Q000F000B6Q000F3Q000F00122Q00100056055Q000E000F00104Q000C000D000E4Q000A000C6Q000A00023Q00044Q005D0A010004073Q00590A012Q00463Q00013Q00013Q00023Q00026Q00F03F026Q00704002264Q00CF00025Q00122Q000300016Q00045Q00122Q000500013Q00042Q0003002100012Q00CB00076Q0013000800026Q000900016Q000A00026Q000B00036Q000C00046Q000D8Q000E00063Q00202Q000F000600014Q000C000F6Q000B3Q00024Q000C00036Q000D00046Q000E00016Q000F00016Q000F0006000F00102Q000F0001000F4Q001000016Q00100006001000102Q00100001001000202Q0010001000014Q000D00106Q000C8Q000A3Q000200202Q000A000A00024Q0009000A6Q00073Q00010004C00003000500012Q00CB000300054Q003D000400024Q0024000300044Q00D100036Q00463Q00017Q00", GetFEnv(), ...);
