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
				local FlatIdent_7126A = 0;
				local b;
				while true do
					if (FlatIdent_7126A == 1) then
						return b;
					end
					if (FlatIdent_7126A == 0) then
						b = Rep(a, repeatNext);
						repeatNext = nil;
						FlatIdent_7126A = 1;
					end
				end
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local FlatIdent_2661B = 0;
			local Res;
			while true do
				if (FlatIdent_2661B == 0) then
					Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
					return Res - (Res % 1);
				end
			end
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local FlatIdent_475BC = 0;
		local a;
		while true do
			if (FlatIdent_475BC == 0) then
				a = Byte(ByteString, DIP, DIP);
				DIP = DIP + 1;
				FlatIdent_475BC = 1;
			end
			if (FlatIdent_475BC == 1) then
				return a;
			end
		end
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local FlatIdent_21DEA = 0;
		local a;
		local b;
		local c;
		local d;
		while true do
			if (FlatIdent_21DEA == 0) then
				a, b, c, d = Byte(ByteString, DIP, DIP + 3);
				DIP = DIP + 4;
				FlatIdent_21DEA = 1;
			end
			if (FlatIdent_21DEA == 1) then
				return (d * 16777216) + (c * 65536) + (b * 256) + a;
			end
		end
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
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
	local function gString(Len)
		local Str;
		if not Len then
			local FlatIdent_43862 = 0;
			while true do
				if (0 == FlatIdent_43862) then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
					break;
				end
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
		local FlatIdent_8F047 = 0;
		local Instrs;
		local Functions;
		local Lines;
		local Chunk;
		local ConstCount;
		local Consts;
		while true do
			if (2 == FlatIdent_8F047) then
				for Idx = 1, gBits32() do
					local Descriptor = gBits8();
					if (gBit(Descriptor, 1, 1) == 0) then
						local FlatIdent_61B23 = 0;
						local Type;
						local Mask;
						local Inst;
						while true do
							if (2 == FlatIdent_61B23) then
								if (gBit(Mask, 1, 1) == 1) then
									Inst[2] = Consts[Inst[2]];
								end
								if (gBit(Mask, 2, 2) == 1) then
									Inst[3] = Consts[Inst[3]];
								end
								FlatIdent_61B23 = 3;
							end
							if (FlatIdent_61B23 == 3) then
								if (gBit(Mask, 3, 3) == 1) then
									Inst[4] = Consts[Inst[4]];
								end
								Instrs[Idx] = Inst;
								break;
							end
							if (FlatIdent_61B23 == 0) then
								Type = gBit(Descriptor, 2, 3);
								Mask = gBit(Descriptor, 4, 6);
								FlatIdent_61B23 = 1;
							end
							if (FlatIdent_61B23 == 1) then
								Inst = {gBits16(),gBits16(),nil,nil};
								if (Type == 0) then
									local FlatIdent_2984D = 0;
									while true do
										if (FlatIdent_2984D == 0) then
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
									Inst[3] = gBits32() - (2 ^ 16);
									Inst[4] = gBits16();
								end
								FlatIdent_61B23 = 2;
							end
						end
					end
				end
				for Idx = 1, gBits32() do
					Functions[Idx - 1] = Deserialize();
				end
				return Chunk;
			end
			if (FlatIdent_8F047 == 0) then
				Instrs = {};
				Functions = {};
				Lines = {};
				Chunk = {Instrs,Functions,nil,Lines};
				FlatIdent_8F047 = 1;
			end
			if (FlatIdent_8F047 == 1) then
				ConstCount = gBits32();
				Consts = {};
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
				FlatIdent_8F047 = 2;
			end
		end
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
				local FlatIdent_23853 = 0;
				while true do
					if (FlatIdent_23853 == 1) then
						if (Enum <= 109) then
							if (Enum <= 54) then
								if (Enum <= 26) then
									if (Enum <= 12) then
										if (Enum <= 5) then
											if (Enum <= 2) then
												if (Enum <= 0) then
													VIP = Inst[3];
												elseif (Enum == 1) then
													local FlatIdent_79536 = 0;
													while true do
														if (FlatIdent_79536 == 0) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															FlatIdent_79536 = 1;
														end
														if (FlatIdent_79536 == 6) then
															Stk[Inst[2]] = {};
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															break;
														end
														if (FlatIdent_79536 == 4) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															FlatIdent_79536 = 5;
														end
														if (FlatIdent_79536 == 5) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_79536 = 6;
														end
														if (FlatIdent_79536 == 1) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															FlatIdent_79536 = 2;
														end
														if (FlatIdent_79536 == 3) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															FlatIdent_79536 = 4;
														end
														if (FlatIdent_79536 == 2) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_79536 = 3;
														end
													end
												else
													local FlatIdent_39EBF = 0;
													while true do
														if (FlatIdent_39EBF == 9) then
															Stk[Inst[2]] = Inst[3];
															break;
														end
														if (FlatIdent_39EBF == 5) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 6;
														end
														if (FlatIdent_39EBF == 8) then
															Stk[Inst[2]] = {};
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 9;
														end
														if (FlatIdent_39EBF == 4) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 5;
														end
														if (FlatIdent_39EBF == 2) then
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 3;
														end
														if (FlatIdent_39EBF == 3) then
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 4;
														end
														if (FlatIdent_39EBF == 6) then
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 7;
														end
														if (FlatIdent_39EBF == 1) then
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 2;
														end
														if (FlatIdent_39EBF == 0) then
															Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 1;
														end
														if (FlatIdent_39EBF == 7) then
															Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_39EBF = 8;
														end
													end
												end
											elseif (Enum <= 3) then
												local FlatIdent_7693 = 0;
												local A;
												while true do
													if (FlatIdent_7693 == 0) then
														A = nil;
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 1;
													end
													if (FlatIdent_7693 == 22) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_7693 = 23;
													end
													if (FlatIdent_7693 == 17) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 18;
													end
													if (FlatIdent_7693 == 18) then
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7693 = 19;
													end
													if (14 == FlatIdent_7693) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_7693 = 15;
													end
													if (FlatIdent_7693 == 15) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 16;
													end
													if (FlatIdent_7693 == 12) then
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7693 = 13;
													end
													if (FlatIdent_7693 == 31) then
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														break;
													end
													if (FlatIdent_7693 == 13) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 14;
													end
													if (FlatIdent_7693 == 20) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7693 = 21;
													end
													if (3 == FlatIdent_7693) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_7693 = 4;
													end
													if (4 == FlatIdent_7693) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_7693 = 5;
													end
													if (24 == FlatIdent_7693) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7693 = 25;
													end
													if (FlatIdent_7693 == 28) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_7693 = 29;
													end
													if (FlatIdent_7693 == 25) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7693 = 26;
													end
													if (FlatIdent_7693 == 21) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 22;
													end
													if (FlatIdent_7693 == 23) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_7693 = 24;
													end
													if (FlatIdent_7693 == 19) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 20;
													end
													if (26 == FlatIdent_7693) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_7693 = 27;
													end
													if (FlatIdent_7693 == 1) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7693 = 2;
													end
													if (FlatIdent_7693 == 11) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 12;
													end
													if (FlatIdent_7693 == 10) then
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														FlatIdent_7693 = 11;
													end
													if (FlatIdent_7693 == 7) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_7693 = 8;
													end
													if (29 == FlatIdent_7693) then
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														FlatIdent_7693 = 30;
													end
													if (FlatIdent_7693 == 5) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7693 = 6;
													end
													if (FlatIdent_7693 == 6) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7693 = 7;
													end
													if (FlatIdent_7693 == 27) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7693 = 28;
													end
													if (FlatIdent_7693 == 16) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														FlatIdent_7693 = 17;
													end
													if (FlatIdent_7693 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 3;
													end
													if (8 == FlatIdent_7693) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7693 = 9;
													end
													if (30 == FlatIdent_7693) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7693 = 31;
													end
													if (FlatIdent_7693 == 9) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_7693 = 10;
													end
												end
											elseif (Enum == 4) then
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
											elseif (Enum > 7) then
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
												local FlatIdent_61EE = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_61EE == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_61EE = 3;
													end
													if (FlatIdent_61EE == 5) then
														B = Inst[3];
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (FlatIdent_61EE == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														T = Stk[A];
														FlatIdent_61EE = 5;
													end
													if (FlatIdent_61EE == 0) then
														B = nil;
														T = nil;
														A = nil;
														Stk[Inst[2]] = Inst[3];
														FlatIdent_61EE = 1;
													end
													if (FlatIdent_61EE == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_61EE = 2;
													end
													if (3 == FlatIdent_61EE) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														FlatIdent_61EE = 4;
													end
												end
											end
										elseif (Enum <= 10) then
											if (Enum == 9) then
												do
													return Stk[Inst[2]];
												end
											else
												local FlatIdent_3CF36 = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_3CF36 == 1) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CF36 = 2;
													end
													if (2 == FlatIdent_3CF36) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CF36 = 3;
													end
													if (FlatIdent_3CF36 == 7) then
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_3CF36 = 8;
													end
													if (FlatIdent_3CF36 == 0) then
														B = nil;
														T = nil;
														A = nil;
														FlatIdent_3CF36 = 1;
													end
													if (FlatIdent_3CF36 == 6) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CF36 = 7;
													end
													if (FlatIdent_3CF36 == 8) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (FlatIdent_3CF36 == 5) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CF36 = 6;
													end
													if (FlatIdent_3CF36 == 4) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CF36 = 5;
													end
													if (3 == FlatIdent_3CF36) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3CF36 = 4;
													end
												end
											end
										elseif (Enum > 11) then
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
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
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
									elseif (Enum <= 19) then
										if (Enum <= 15) then
											if (Enum <= 13) then
												local FlatIdent_25A9F = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_25A9F == 6) then
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_25A9F = 7;
													end
													if (FlatIdent_25A9F == 0) then
														B = nil;
														T = nil;
														A = nil;
														FlatIdent_25A9F = 1;
													end
													if (FlatIdent_25A9F == 1) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_25A9F = 2;
													end
													if (7 == FlatIdent_25A9F) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (FlatIdent_25A9F == 2) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_25A9F = 3;
													end
													if (FlatIdent_25A9F == 3) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_25A9F = 4;
													end
													if (FlatIdent_25A9F == 5) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_25A9F = 6;
													end
													if (FlatIdent_25A9F == 4) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_25A9F = 5;
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
												local FlatIdent_51545 = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_51545 == 0) then
														B = nil;
														T = nil;
														A = nil;
														Stk[Inst[2]] = {};
														FlatIdent_51545 = 1;
													end
													if (FlatIdent_51545 == 3) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_51545 = 4;
													end
													if (FlatIdent_51545 == 5) then
														Inst = Instr[VIP];
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_51545 = 6;
													end
													if (FlatIdent_51545 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_51545 = 5;
													end
													if (6 == FlatIdent_51545) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (2 == FlatIdent_51545) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_51545 = 3;
													end
													if (FlatIdent_51545 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_51545 = 2;
													end
												end
											end
										elseif (Enum <= 17) then
											if (Enum > 16) then
												local FlatIdent_930C2 = 0;
												while true do
													if (FlatIdent_930C2 == 0) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_930C2 = 1;
													end
													if (4 == FlatIdent_930C2) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_930C2 = 5;
													end
													if (FlatIdent_930C2 == 5) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_930C2 = 6;
													end
													if (FlatIdent_930C2 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_930C2 = 3;
													end
													if (FlatIdent_930C2 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_930C2 = 2;
													end
													if (FlatIdent_930C2 == 3) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_930C2 = 4;
													end
													if (FlatIdent_930C2 == 6) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														break;
													end
												end
											else
												local FlatIdent_7E707 = 0;
												local Step;
												local Index;
												local A;
												while true do
													if (FlatIdent_7E707 == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_7E707 = 4;
													end
													if (0 == FlatIdent_7E707) then
														Step = nil;
														Index = nil;
														A = nil;
														Stk[Inst[2]] = {};
														FlatIdent_7E707 = 1;
													end
													if (FlatIdent_7E707 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7E707 = 2;
													end
													if (FlatIdent_7E707 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = #Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7E707 = 3;
													end
													if (FlatIdent_7E707 == 4) then
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
														break;
													end
												end
											end
										elseif (Enum == 18) then
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
											local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
											Top = (Limit + A) - 1;
											local Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
										end
									elseif (Enum <= 22) then
										if (Enum <= 20) then
											local FlatIdent_6D1B7 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_6D1B7 == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_6D1B7 = 4;
												end
												if (FlatIdent_6D1B7 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6D1B7 = 3;
												end
												if (FlatIdent_6D1B7 == 5) then
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_6D1B7 = 6;
												end
												if (FlatIdent_6D1B7 == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = {};
													FlatIdent_6D1B7 = 1;
												end
												if (4 == FlatIdent_6D1B7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_6D1B7 = 5;
												end
												if (FlatIdent_6D1B7 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_6D1B7 = 2;
												end
												if (FlatIdent_6D1B7 == 6) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
											end
										elseif (Enum > 21) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										end
									elseif (Enum <= 24) then
										if (Enum == 23) then
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
									elseif (Enum == 25) then
										local FlatIdent_14BDB = 0;
										local A;
										while true do
											if (FlatIdent_14BDB == 0) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												break;
											end
										end
									else
										local FlatIdent_2DA99 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_2DA99 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_2DA99 = 1;
											end
											if (FlatIdent_2DA99 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2DA99 = 3;
											end
											if (FlatIdent_2DA99 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_2DA99 = 4;
											end
											if (FlatIdent_2DA99 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_2DA99 = 2;
											end
											if (FlatIdent_2DA99 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_2DA99 = 5;
											end
											if (FlatIdent_2DA99 == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_2DA99 = 6;
											end
											if (6 == FlatIdent_2DA99) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
										end
									end
								elseif (Enum <= 40) then
									if (Enum <= 33) then
										if (Enum <= 29) then
											if (Enum <= 27) then
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
											elseif (Enum > 28) then
												local FlatIdent_43626 = 0;
												local A;
												while true do
													if (FlatIdent_43626 == 7) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_43626 = 8;
													end
													if (14 == FlatIdent_43626) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														FlatIdent_43626 = 15;
													end
													if (FlatIdent_43626 == 5) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_43626 = 6;
													end
													if (FlatIdent_43626 == 15) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_43626 = 16;
													end
													if (12 == FlatIdent_43626) then
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_43626 = 13;
													end
													if (FlatIdent_43626 == 24) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_43626 = 25;
													end
													if (FlatIdent_43626 == 22) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 23;
													end
													if (FlatIdent_43626 == 23) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 24;
													end
													if (FlatIdent_43626 == 6) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_43626 = 7;
													end
													if (FlatIdent_43626 == 17) then
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 18;
													end
													if (FlatIdent_43626 == 25) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_43626 = 26;
													end
													if (FlatIdent_43626 == 13) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														FlatIdent_43626 = 14;
													end
													if (FlatIdent_43626 == 20) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_43626 = 21;
													end
													if (8 == FlatIdent_43626) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_43626 = 9;
													end
													if (FlatIdent_43626 == 19) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_43626 = 20;
													end
													if (FlatIdent_43626 == 16) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 17;
													end
													if (FlatIdent_43626 == 3) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 4;
													end
													if (FlatIdent_43626 == 1) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_43626 = 2;
													end
													if (FlatIdent_43626 == 10) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 11;
													end
													if (0 == FlatIdent_43626) then
														A = nil;
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_43626 = 1;
													end
													if (FlatIdent_43626 == 2) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_43626 = 3;
													end
													if (FlatIdent_43626 == 11) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_43626 = 12;
													end
													if (FlatIdent_43626 == 26) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_43626 = 27;
													end
													if (FlatIdent_43626 == 4) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 5;
													end
													if (21 == FlatIdent_43626) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_43626 = 22;
													end
													if (FlatIdent_43626 == 27) then
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
													if (FlatIdent_43626 == 9) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_43626 = 10;
													end
													if (FlatIdent_43626 == 18) then
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_43626 = 19;
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
										elseif (Enum <= 31) then
											if (Enum == 30) then
												local FlatIdent_13B77 = 0;
												local B;
												local T;
												local A;
												while true do
													if (4 == FlatIdent_13B77) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														T = Stk[A];
														FlatIdent_13B77 = 5;
													end
													if (FlatIdent_13B77 == 5) then
														B = Inst[3];
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
													end
													if (FlatIdent_13B77 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_13B77 = 3;
													end
													if (FlatIdent_13B77 == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														FlatIdent_13B77 = 4;
													end
													if (FlatIdent_13B77 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_13B77 = 2;
													end
													if (FlatIdent_13B77 == 0) then
														B = nil;
														T = nil;
														A = nil;
														Stk[Inst[2]] = Inst[3];
														FlatIdent_13B77 = 1;
													end
												end
											else
												for Idx = Inst[2], Inst[3] do
													Stk[Idx] = nil;
												end
											end
										elseif (Enum > 32) then
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
											local FlatIdent_7AA3 = 0;
											while true do
												if (FlatIdent_7AA3 == 6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_7AA3 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_7AA3 = 5;
												end
												if (FlatIdent_7AA3 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7AA3 = 6;
												end
												if (FlatIdent_7AA3 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7AA3 = 3;
												end
												if (1 == FlatIdent_7AA3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_7AA3 = 2;
												end
												if (FlatIdent_7AA3 == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_7AA3 = 1;
												end
												if (FlatIdent_7AA3 == 3) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_7AA3 = 4;
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
									elseif (Enum <= 38) then
										if (Enum > 37) then
											local FlatIdent_2F298 = 0;
											local B;
											local T;
											local A;
											while true do
												if (0 == FlatIdent_2F298) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_2F298 = 1;
												end
												if (FlatIdent_2F298 == 1) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2F298 = 2;
												end
												if (FlatIdent_2F298 == 3) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2F298 = 4;
												end
												if (FlatIdent_2F298 == 6) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2F298 = 7;
												end
												if (FlatIdent_2F298 == 2) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2F298 = 3;
												end
												if (FlatIdent_2F298 == 8) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_2F298 == 5) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2F298 = 6;
												end
												if (FlatIdent_2F298 == 4) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2F298 = 5;
												end
												if (FlatIdent_2F298 == 7) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_2F298 = 8;
												end
											end
										else
											Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										end
									elseif (Enum > 39) then
										local FlatIdent_70003 = 0;
										while true do
											if (FlatIdent_70003 == 6) then
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_70003 == 0) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												FlatIdent_70003 = 1;
											end
											if (FlatIdent_70003 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_70003 = 5;
											end
											if (5 == FlatIdent_70003) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_70003 = 6;
											end
											if (FlatIdent_70003 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												FlatIdent_70003 = 4;
											end
											if (FlatIdent_70003 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_70003 = 3;
											end
											if (FlatIdent_70003 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_70003 = 2;
											end
										end
									else
										local FlatIdent_974E = 0;
										while true do
											if (9 == FlatIdent_974E) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_974E == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 8;
											end
											if (FlatIdent_974E == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 7;
											end
											if (FlatIdent_974E == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 2;
											end
											if (FlatIdent_974E == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 6;
											end
											if (FlatIdent_974E == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 1;
											end
											if (FlatIdent_974E == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 3;
											end
											if (8 == FlatIdent_974E) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 9;
											end
											if (FlatIdent_974E == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 5;
											end
											if (3 == FlatIdent_974E) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_974E = 4;
											end
										end
									end
								elseif (Enum <= 47) then
									if (Enum <= 43) then
										if (Enum <= 41) then
											Stk[Inst[2]] = Stk[Inst[3]];
										elseif (Enum == 42) then
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
									elseif (Enum <= 45) then
										if (Enum == 44) then
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
											local FlatIdent_59521 = 0;
											local B;
											local T;
											local A;
											while true do
												if (2 == FlatIdent_59521) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_59521 = 3;
												end
												if (FlatIdent_59521 == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_59521 = 2;
												end
												if (FlatIdent_59521 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_59521 = 5;
												end
												if (FlatIdent_59521 == 6) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_59521 = 7;
												end
												if (FlatIdent_59521 == 5) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_59521 = 6;
												end
												if (FlatIdent_59521 == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_59521 = 1;
												end
												if (FlatIdent_59521 == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_59521 = 4;
												end
												if (FlatIdent_59521 == 7) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
											end
										end
									elseif (Enum == 46) then
										Stk[Inst[2]] = Upvalues[Inst[3]];
									else
										local FlatIdent_1E844 = 0;
										local A;
										while true do
											if (FlatIdent_1E844 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_1E844 = 2;
											end
											if (FlatIdent_1E844 == 18) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_1E844 = 19;
											end
											if (FlatIdent_1E844 == 22) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_1E844 = 23;
											end
											if (FlatIdent_1E844 == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 27;
											end
											if (FlatIdent_1E844 == 19) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1E844 = 20;
											end
											if (14 == FlatIdent_1E844) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_1E844 = 15;
											end
											if (FlatIdent_1E844 == 6) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1E844 = 7;
											end
											if (FlatIdent_1E844 == 24) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 25;
											end
											if (FlatIdent_1E844 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 29;
											end
											if (FlatIdent_1E844 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 12;
											end
											if (FlatIdent_1E844 == 29) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_1E844 = 30;
											end
											if (10 == FlatIdent_1E844) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_1E844 = 11;
											end
											if (FlatIdent_1E844 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 8;
											end
											if (FlatIdent_1E844 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1E844 = 22;
											end
											if (8 == FlatIdent_1E844) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_1E844 = 9;
											end
											if (FlatIdent_1E844 == 27) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_1E844 = 28;
											end
											if (FlatIdent_1E844 == 13) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 14;
											end
											if (FlatIdent_1E844 == 31) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_1E844 == 12) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_1E844 = 13;
											end
											if (FlatIdent_1E844 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_1E844 = 4;
											end
											if (FlatIdent_1E844 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_1E844 = 5;
											end
											if (FlatIdent_1E844 == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1E844 = 1;
											end
											if (FlatIdent_1E844 == 23) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_1E844 = 24;
											end
											if (FlatIdent_1E844 == 25) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1E844 = 26;
											end
											if (FlatIdent_1E844 == 17) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_1E844 = 18;
											end
											if (FlatIdent_1E844 == 16) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_1E844 = 17;
											end
											if (FlatIdent_1E844 == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 10;
											end
											if (FlatIdent_1E844 == 15) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 16;
											end
											if (FlatIdent_1E844 == 20) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_1E844 = 21;
											end
											if (FlatIdent_1E844 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1E844 = 3;
											end
											if (5 == FlatIdent_1E844) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 6;
											end
											if (FlatIdent_1E844 == 30) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1E844 = 31;
											end
										end
									end
								elseif (Enum <= 50) then
									if (Enum <= 48) then
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
									elseif (Enum > 49) then
										local FlatIdent_5E6B6 = 0;
										local A;
										while true do
											if (FlatIdent_5E6B6 == 25) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 26;
											end
											if (FlatIdent_5E6B6 == 2) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5E6B6 = 3;
											end
											if (FlatIdent_5E6B6 == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 7;
											end
											if (FlatIdent_5E6B6 == 15) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_5E6B6 = 16;
											end
											if (FlatIdent_5E6B6 == 10) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 11;
											end
											if (FlatIdent_5E6B6 == 20) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5E6B6 = 21;
											end
											if (FlatIdent_5E6B6 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 6;
											end
											if (FlatIdent_5E6B6 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 5;
											end
											if (23 == FlatIdent_5E6B6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 24;
											end
											if (FlatIdent_5E6B6 == 22) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 23;
											end
											if (FlatIdent_5E6B6 == 16) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 17;
											end
											if (19 == FlatIdent_5E6B6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 20;
											end
											if (FlatIdent_5E6B6 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 4;
											end
											if (FlatIdent_5E6B6 == 1) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5E6B6 = 2;
											end
											if (FlatIdent_5E6B6 == 18) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 19;
											end
											if (FlatIdent_5E6B6 == 27) then
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
											if (FlatIdent_5E6B6 == 12) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 13;
											end
											if (FlatIdent_5E6B6 == 11) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 12;
											end
											if (FlatIdent_5E6B6 == 17) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 18;
											end
											if (FlatIdent_5E6B6 == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5E6B6 = 10;
											end
											if (FlatIdent_5E6B6 == 26) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5E6B6 = 27;
											end
											if (7 == FlatIdent_5E6B6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5E6B6 = 8;
											end
											if (FlatIdent_5E6B6 == 8) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5E6B6 = 9;
											end
											if (FlatIdent_5E6B6 == 14) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_5E6B6 = 15;
											end
											if (FlatIdent_5E6B6 == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 1;
											end
											if (FlatIdent_5E6B6 == 24) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_5E6B6 = 25;
											end
											if (FlatIdent_5E6B6 == 13) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_5E6B6 = 14;
											end
											if (FlatIdent_5E6B6 == 21) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5E6B6 = 22;
											end
										end
									else
										local FlatIdent_580B8 = 0;
										while true do
											if (FlatIdent_580B8 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 4;
											end
											if (FlatIdent_580B8 == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 9;
											end
											if (FlatIdent_580B8 == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 8;
											end
											if (FlatIdent_580B8 == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 7;
											end
											if (FlatIdent_580B8 == 9) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_580B8 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 1;
											end
											if (FlatIdent_580B8 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 2;
											end
											if (FlatIdent_580B8 == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 5;
											end
											if (FlatIdent_580B8 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 3;
											end
											if (FlatIdent_580B8 == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_580B8 = 6;
											end
										end
									end
								elseif (Enum <= 52) then
									if (Enum > 51) then
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
										local FlatIdent_24177 = 0;
										local A;
										while true do
											if (FlatIdent_24177 == 22) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_24177 = 23;
											end
											if (FlatIdent_24177 == 2) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 3;
											end
											if (FlatIdent_24177 == 23) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_24177 = 24;
											end
											if (FlatIdent_24177 == 16) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_24177 = 17;
											end
											if (FlatIdent_24177 == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_24177 = 18;
											end
											if (FlatIdent_24177 == 7) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_24177 = 8;
											end
											if (FlatIdent_24177 == 24) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_24177 = 25;
											end
											if (0 == FlatIdent_24177) then
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
												FlatIdent_24177 = 1;
											end
											if (FlatIdent_24177 == 18) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_24177 = 19;
											end
											if (19 == FlatIdent_24177) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_24177 = 20;
											end
											if (FlatIdent_24177 == 15) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 16;
											end
											if (FlatIdent_24177 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_24177 = 4;
											end
											if (FlatIdent_24177 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 9;
											end
											if (5 == FlatIdent_24177) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_24177 = 6;
											end
											if (FlatIdent_24177 == 9) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 10;
											end
											if (FlatIdent_24177 == 25) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												break;
											end
											if (FlatIdent_24177 == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_24177 = 5;
											end
											if (FlatIdent_24177 == 21) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 22;
											end
											if (FlatIdent_24177 == 13) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_24177 = 14;
											end
											if (FlatIdent_24177 == 12) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_24177 = 13;
											end
											if (6 == FlatIdent_24177) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_24177 = 7;
											end
											if (FlatIdent_24177 == 14) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 15;
											end
											if (10 == FlatIdent_24177) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_24177 = 11;
											end
											if (FlatIdent_24177 == 1) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 2;
											end
											if (FlatIdent_24177 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_24177 = 12;
											end
											if (FlatIdent_24177 == 20) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_24177 = 21;
											end
										end
									end
								elseif (Enum == 53) then
									local FlatIdent_174A5 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_174A5 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_174A5 = 2;
										end
										if (6 == FlatIdent_174A5) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_174A5 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_174A5 = 5;
										end
										if (FlatIdent_174A5 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_174A5 = 6;
										end
										if (FlatIdent_174A5 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_174A5 = 4;
										end
										if (FlatIdent_174A5 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_174A5 = 3;
										end
										if (FlatIdent_174A5 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_174A5 = 1;
										end
									end
								else
									local FlatIdent_6DAAA = 0;
									while true do
										if (4 == FlatIdent_6DAAA) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 5;
										end
										if (FlatIdent_6DAAA == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 2;
										end
										if (FlatIdent_6DAAA == 5) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 6;
										end
										if (FlatIdent_6DAAA == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 3;
										end
										if (0 == FlatIdent_6DAAA) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 1;
										end
										if (FlatIdent_6DAAA == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 7;
										end
										if (3 == FlatIdent_6DAAA) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 4;
										end
										if (FlatIdent_6DAAA == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_6DAAA == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 9;
										end
										if (FlatIdent_6DAAA == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6DAAA = 8;
										end
									end
								end
							elseif (Enum <= 81) then
								if (Enum <= 67) then
									if (Enum <= 60) then
										if (Enum <= 57) then
											if (Enum <= 55) then
												local FlatIdent_7FA00 = 0;
												while true do
													if (FlatIdent_7FA00 == 6) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 7;
													end
													if (FlatIdent_7FA00 == 7) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 8;
													end
													if (FlatIdent_7FA00 == 8) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 9;
													end
													if (FlatIdent_7FA00 == 4) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 5;
													end
													if (FlatIdent_7FA00 == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 4;
													end
													if (0 == FlatIdent_7FA00) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 1;
													end
													if (FlatIdent_7FA00 == 1) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 2;
													end
													if (FlatIdent_7FA00 == 9) then
														Stk[Inst[2]] = Inst[3];
														break;
													end
													if (FlatIdent_7FA00 == 5) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 6;
													end
													if (FlatIdent_7FA00 == 2) then
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7FA00 = 3;
													end
												end
											elseif (Enum == 56) then
												local FlatIdent_3374E = 0;
												while true do
													if (FlatIdent_3374E == 6) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														break;
													end
													if (FlatIdent_3374E == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_3374E = 5;
													end
													if (FlatIdent_3374E == 0) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_3374E = 1;
													end
													if (FlatIdent_3374E == 3) then
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
														FlatIdent_3374E = 4;
													end
													if (FlatIdent_3374E == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3374E = 3;
													end
													if (FlatIdent_3374E == 5) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3374E = 6;
													end
													if (FlatIdent_3374E == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_3374E = 2;
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
										elseif (Enum <= 58) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										elseif (Enum == 59) then
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
											local FlatIdent_6E5C = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_6E5C == 5) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_6E5C == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_6E5C = 2;
												end
												if (0 == FlatIdent_6E5C) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_6E5C = 1;
												end
												if (FlatIdent_6E5C == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													FlatIdent_6E5C = 5;
												end
												if (2 == FlatIdent_6E5C) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6E5C = 3;
												end
												if (FlatIdent_6E5C == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													FlatIdent_6E5C = 4;
												end
											end
										end
									elseif (Enum <= 63) then
										if (Enum <= 61) then
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
										elseif (Enum > 62) then
											local FlatIdent_1306 = 0;
											while true do
												if (FlatIdent_1306 == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 1;
												end
												if (7 == FlatIdent_1306) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 8;
												end
												if (6 == FlatIdent_1306) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 7;
												end
												if (FlatIdent_1306 == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 3;
												end
												if (FlatIdent_1306 == 9) then
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_1306 == 5) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 6;
												end
												if (FlatIdent_1306 == 8) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 9;
												end
												if (FlatIdent_1306 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 4;
												end
												if (4 == FlatIdent_1306) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 5;
												end
												if (FlatIdent_1306 == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_1306 = 2;
												end
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										end
									elseif (Enum <= 65) then
										if (Enum == 64) then
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
										else
											local FlatIdent_3423 = 0;
											local B;
											local T;
											local A;
											while true do
												if (0 == FlatIdent_3423) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_3423 = 1;
												end
												if (FlatIdent_3423 == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3423 = 4;
												end
												if (FlatIdent_3423 == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3423 = 3;
												end
												if (FlatIdent_3423 == 6) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_3423 = 7;
												end
												if (1 == FlatIdent_3423) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3423 = 2;
												end
												if (5 == FlatIdent_3423) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3423 = 6;
												end
												if (4 == FlatIdent_3423) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3423 = 5;
												end
												if (7 == FlatIdent_3423) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
											end
										end
									elseif (Enum > 66) then
										local FlatIdent_23FFF = 0;
										while true do
											if (FlatIdent_23FFF == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_23FFF = 2;
											end
											if (FlatIdent_23FFF == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_23FFF = 1;
											end
											if (FlatIdent_23FFF == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_23FFF = 6;
											end
											if (FlatIdent_23FFF == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_23FFF = 3;
											end
											if (FlatIdent_23FFF == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_23FFF == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_23FFF = 4;
											end
											if (FlatIdent_23FFF == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_23FFF = 5;
											end
										end
									else
										local FlatIdent_6F428 = 0;
										local A;
										while true do
											if (FlatIdent_6F428 == 20) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_6F428 = 21;
											end
											if (FlatIdent_6F428 == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 18;
											end
											if (FlatIdent_6F428 == 0) then
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 1;
											end
											if (FlatIdent_6F428 == 19) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 20;
											end
											if (FlatIdent_6F428 == 30) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 31;
											end
											if (FlatIdent_6F428 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_6F428 = 2;
											end
											if (FlatIdent_6F428 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 3;
											end
											if (FlatIdent_6F428 == 13) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 14;
											end
											if (FlatIdent_6F428 == 27) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_6F428 = 28;
											end
											if (FlatIdent_6F428 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_6F428 = 29;
											end
											if (FlatIdent_6F428 == 16) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_6F428 = 17;
											end
											if (15 == FlatIdent_6F428) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 16;
											end
											if (FlatIdent_6F428 == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_6F428 = 7;
											end
											if (FlatIdent_6F428 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_6F428 = 9;
											end
											if (FlatIdent_6F428 == 22) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_6F428 = 23;
											end
											if (FlatIdent_6F428 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_6F428 = 4;
											end
											if (FlatIdent_6F428 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 12;
											end
											if (FlatIdent_6F428 == 10) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_6F428 = 11;
											end
											if (29 == FlatIdent_6F428) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_6F428 = 30;
											end
											if (FlatIdent_6F428 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_6F428 = 8;
											end
											if (FlatIdent_6F428 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_6F428 = 5;
											end
											if (FlatIdent_6F428 == 23) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_6F428 = 24;
											end
											if (FlatIdent_6F428 == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_6F428 = 10;
											end
											if (FlatIdent_6F428 == 24) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_6F428 = 25;
											end
											if (FlatIdent_6F428 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6F428 = 22;
											end
											if (18 == FlatIdent_6F428) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_6F428 = 19;
											end
											if (FlatIdent_6F428 == 31) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												break;
											end
											if (FlatIdent_6F428 == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_6F428 = 15;
											end
											if (FlatIdent_6F428 == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_6F428 = 27;
											end
											if (FlatIdent_6F428 == 5) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_6F428 = 6;
											end
											if (FlatIdent_6F428 == 25) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_6F428 = 26;
											end
											if (FlatIdent_6F428 == 12) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_6F428 = 13;
											end
										end
									end
								elseif (Enum <= 74) then
									if (Enum <= 70) then
										if (Enum <= 68) then
											local FlatIdent_6426D = 0;
											local B;
											local T;
											local A;
											while true do
												if (8 == FlatIdent_6426D) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_6426D == 7) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_6426D = 8;
												end
												if (4 == FlatIdent_6426D) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6426D = 5;
												end
												if (FlatIdent_6426D == 1) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6426D = 2;
												end
												if (FlatIdent_6426D == 5) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6426D = 6;
												end
												if (FlatIdent_6426D == 6) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6426D = 7;
												end
												if (FlatIdent_6426D == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_6426D = 1;
												end
												if (FlatIdent_6426D == 2) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6426D = 3;
												end
												if (FlatIdent_6426D == 3) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6426D = 4;
												end
											end
										elseif (Enum > 69) then
											local FlatIdent_47F4B = 0;
											while true do
												if (FlatIdent_47F4B == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 4;
												end
												if (FlatIdent_47F4B == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 2;
												end
												if (FlatIdent_47F4B == 8) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 9;
												end
												if (FlatIdent_47F4B == 5) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 6;
												end
												if (FlatIdent_47F4B == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 1;
												end
												if (FlatIdent_47F4B == 7) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 8;
												end
												if (FlatIdent_47F4B == 6) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 7;
												end
												if (FlatIdent_47F4B == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 3;
												end
												if (FlatIdent_47F4B == 4) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_47F4B = 5;
												end
												if (FlatIdent_47F4B == 9) then
													Stk[Inst[2]] = Inst[3];
													break;
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
									elseif (Enum <= 72) then
										if (Enum == 71) then
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										else
											local FlatIdent_2DA38 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_2DA38 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_2DA38 = 2;
												end
												if (FlatIdent_2DA38 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2DA38 = 3;
												end
												if (FlatIdent_2DA38 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													FlatIdent_2DA38 = 5;
												end
												if (FlatIdent_2DA38 == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2DA38 = 1;
												end
												if (FlatIdent_2DA38 == 5) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_2DA38 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													FlatIdent_2DA38 = 4;
												end
											end
										end
									elseif (Enum > 73) then
										local FlatIdent_39BEC = 0;
										local B;
										local T;
										local A;
										while true do
											if (6 == FlatIdent_39BEC) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_39BEC = 7;
											end
											if (FlatIdent_39BEC == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_39BEC = 2;
											end
											if (FlatIdent_39BEC == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_39BEC == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_39BEC = 1;
											end
											if (7 == FlatIdent_39BEC) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_39BEC = 8;
											end
											if (FlatIdent_39BEC == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_39BEC = 5;
											end
											if (FlatIdent_39BEC == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_39BEC = 6;
											end
											if (FlatIdent_39BEC == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_39BEC = 4;
											end
											if (FlatIdent_39BEC == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_39BEC = 3;
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
								elseif (Enum <= 77) then
									if (Enum <= 75) then
										local FlatIdent_84C91 = 0;
										local B;
										local T;
										local A;
										while true do
											if (4 == FlatIdent_84C91) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												FlatIdent_84C91 = 5;
											end
											if (FlatIdent_84C91 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												FlatIdent_84C91 = 4;
											end
											if (FlatIdent_84C91 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_84C91 = 3;
											end
											if (1 == FlatIdent_84C91) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_84C91 = 2;
											end
											if (FlatIdent_84C91 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = Inst[3];
												FlatIdent_84C91 = 1;
											end
											if (FlatIdent_84C91 == 5) then
												B = Inst[3];
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
										end
									elseif (Enum > 76) then
										local FlatIdent_58975 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_58975 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_58975 = 4;
											end
											if (FlatIdent_58975 == 6) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_58975 = 7;
											end
											if (FlatIdent_58975 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_58975 = 3;
											end
											if (FlatIdent_58975 == 7) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_58975 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_58975 = 1;
											end
											if (FlatIdent_58975 == 5) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_58975 = 6;
											end
											if (FlatIdent_58975 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_58975 = 5;
											end
											if (FlatIdent_58975 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_58975 = 2;
											end
										end
									else
										local FlatIdent_39691 = 0;
										local A;
										local Results;
										local Limit;
										local Edx;
										while true do
											if (FlatIdent_39691 == 2) then
												for Idx = A, Top do
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
												end
												break;
											end
											if (FlatIdent_39691 == 1) then
												Top = (Limit + A) - 1;
												Edx = 0;
												FlatIdent_39691 = 2;
											end
											if (FlatIdent_39691 == 0) then
												A = Inst[2];
												Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
												FlatIdent_39691 = 1;
											end
										end
									end
								elseif (Enum <= 79) then
									if (Enum == 78) then
										local FlatIdent_7CC7D = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_7CC7D == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7CC7D = 4;
											end
											if (FlatIdent_7CC7D == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7CC7D = 5;
											end
											if (FlatIdent_7CC7D == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7CC7D = 6;
											end
											if (FlatIdent_7CC7D == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_7CC7D = 8;
											end
											if (FlatIdent_7CC7D == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7CC7D = 2;
											end
											if (FlatIdent_7CC7D == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7CC7D = 3;
											end
											if (0 == FlatIdent_7CC7D) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_7CC7D = 1;
											end
											if (FlatIdent_7CC7D == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_7CC7D == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7CC7D = 7;
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
								elseif (Enum > 80) then
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
									local FlatIdent_2D301 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_2D301 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_2D301 = 2;
										end
										if (FlatIdent_2D301 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_2D301 = 6;
										end
										if (FlatIdent_2D301 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_2D301 = 5;
										end
										if (FlatIdent_2D301 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2D301 = 3;
										end
										if (FlatIdent_2D301 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_2D301 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_2D301 = 1;
										end
										if (FlatIdent_2D301 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_2D301 = 4;
										end
									end
								end
							elseif (Enum <= 95) then
								if (Enum <= 88) then
									if (Enum <= 84) then
										if (Enum <= 82) then
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 83) then
											local FlatIdent_F232 = 0;
											local A;
											while true do
												if (FlatIdent_F232 == 24) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_F232 = 25;
												end
												if (FlatIdent_F232 == 15) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 16;
												end
												if (17 == FlatIdent_F232) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 18;
												end
												if (FlatIdent_F232 == 7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_F232 = 8;
												end
												if (29 == FlatIdent_F232) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_F232 = 30;
												end
												if (FlatIdent_F232 == 23) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_F232 = 24;
												end
												if (FlatIdent_F232 == 30) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 31;
												end
												if (FlatIdent_F232 == 18) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_F232 = 19;
												end
												if (FlatIdent_F232 == 8) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_F232 = 9;
												end
												if (FlatIdent_F232 == 9) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_F232 = 10;
												end
												if (FlatIdent_F232 == 12) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_F232 = 13;
												end
												if (FlatIdent_F232 == 22) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_F232 = 23;
												end
												if (FlatIdent_F232 == 31) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													break;
												end
												if (FlatIdent_F232 == 26) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_F232 = 27;
												end
												if (FlatIdent_F232 == 16) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_F232 = 17;
												end
												if (FlatIdent_F232 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_F232 = 5;
												end
												if (FlatIdent_F232 == 20) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_F232 = 21;
												end
												if (FlatIdent_F232 == 10) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_F232 = 11;
												end
												if (FlatIdent_F232 == 27) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_F232 = 28;
												end
												if (28 == FlatIdent_F232) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_F232 = 29;
												end
												if (25 == FlatIdent_F232) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_F232 = 26;
												end
												if (FlatIdent_F232 == 6) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_F232 = 7;
												end
												if (FlatIdent_F232 == 5) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_F232 = 6;
												end
												if (14 == FlatIdent_F232) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_F232 = 15;
												end
												if (FlatIdent_F232 == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_F232 = 2;
												end
												if (FlatIdent_F232 == 21) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 22;
												end
												if (FlatIdent_F232 == 13) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 14;
												end
												if (FlatIdent_F232 == 0) then
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 1;
												end
												if (FlatIdent_F232 == 19) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 20;
												end
												if (FlatIdent_F232 == 11) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 12;
												end
												if (FlatIdent_F232 == 3) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_F232 = 4;
												end
												if (FlatIdent_F232 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_F232 = 3;
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
									elseif (Enum <= 86) then
										if (Enum > 85) then
											local A = Inst[2];
											local T = Stk[A];
											local B = Inst[3];
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
									elseif (Enum == 87) then
										Stk[Inst[2]] = Env[Inst[3]];
									else
										local FlatIdent_21FB8 = 0;
										while true do
											if (FlatIdent_21FB8 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (0 == FlatIdent_21FB8) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_21FB8 = 1;
											end
											if (FlatIdent_21FB8 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_21FB8 = 2;
											end
											if (FlatIdent_21FB8 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_21FB8 = 5;
											end
											if (FlatIdent_21FB8 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_21FB8 = 6;
											end
											if (FlatIdent_21FB8 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_21FB8 = 4;
											end
											if (FlatIdent_21FB8 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_21FB8 = 3;
											end
										end
									end
								elseif (Enum <= 91) then
									if (Enum <= 89) then
										local FlatIdent_7FF98 = 0;
										local A;
										while true do
											if (FlatIdent_7FF98 == 10) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_7FF98 = 11;
											end
											if (FlatIdent_7FF98 == 15) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 16;
											end
											if (FlatIdent_7FF98 == 16) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_7FF98 = 17;
											end
											if (FlatIdent_7FF98 == 30) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 31;
											end
											if (FlatIdent_7FF98 == 5) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 6;
											end
											if (FlatIdent_7FF98 == 20) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 21;
											end
											if (FlatIdent_7FF98 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 4;
											end
											if (17 == FlatIdent_7FF98) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 18;
											end
											if (FlatIdent_7FF98 == 22) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 23;
											end
											if (FlatIdent_7FF98 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 22;
											end
											if (FlatIdent_7FF98 == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_7FF98 = 7;
											end
											if (FlatIdent_7FF98 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_7FF98 = 9;
											end
											if (FlatIdent_7FF98 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_7FF98 = 5;
											end
											if (FlatIdent_7FF98 == 29) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_7FF98 = 30;
											end
											if (2 == FlatIdent_7FF98) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 3;
											end
											if (FlatIdent_7FF98 == 12) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_7FF98 = 13;
											end
											if (FlatIdent_7FF98 == 25) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_7FF98 = 26;
											end
											if (FlatIdent_7FF98 == 19) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 20;
											end
											if (FlatIdent_7FF98 == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 27;
											end
											if (24 == FlatIdent_7FF98) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 25;
											end
											if (FlatIdent_7FF98 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_7FF98 = 29;
											end
											if (1 == FlatIdent_7FF98) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 2;
											end
											if (FlatIdent_7FF98 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 8;
											end
											if (FlatIdent_7FF98 == 31) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												break;
											end
											if (FlatIdent_7FF98 == 13) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 14;
											end
											if (FlatIdent_7FF98 == 0) then
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 1;
											end
											if (FlatIdent_7FF98 == 23) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_7FF98 = 24;
											end
											if (11 == FlatIdent_7FF98) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7FF98 = 12;
											end
											if (FlatIdent_7FF98 == 27) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_7FF98 = 28;
											end
											if (FlatIdent_7FF98 == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_7FF98 = 15;
											end
											if (FlatIdent_7FF98 == 18) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_7FF98 = 19;
											end
											if (9 == FlatIdent_7FF98) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_7FF98 = 10;
											end
										end
									elseif (Enum == 90) then
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
										local FlatIdent_30A09 = 0;
										local A;
										while true do
											if (FlatIdent_30A09 == 0) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
												break;
											end
										end
									end
								elseif (Enum <= 93) then
									if (Enum > 92) then
										local FlatIdent_61D0C = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_61D0C == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_61D0C = 1;
											end
											if (FlatIdent_61D0C == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_61D0C = 5;
											end
											if (6 == FlatIdent_61D0C) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_61D0C == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_61D0C = 6;
											end
											if (3 == FlatIdent_61D0C) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_61D0C = 4;
											end
											if (2 == FlatIdent_61D0C) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_61D0C = 3;
											end
											if (FlatIdent_61D0C == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_61D0C = 2;
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
								elseif (Enum == 94) then
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								else
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										local FlatIdent_4F368 = 0;
										while true do
											if (FlatIdent_4F368 == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
								end
							elseif (Enum <= 102) then
								if (Enum <= 98) then
									if (Enum <= 96) then
										local FlatIdent_8EAFE = 0;
										while true do
											if (FlatIdent_8EAFE == 9) then
												Stk[Inst[2]] = {};
												break;
											end
											if (1 == FlatIdent_8EAFE) then
												Stk[Inst[2]] = Inst[3];
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
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8EAFE = 9;
											end
											if (FlatIdent_8EAFE == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8EAFE = 3;
											end
											if (0 == FlatIdent_8EAFE) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8EAFE = 1;
											end
											if (FlatIdent_8EAFE == 6) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8EAFE = 7;
											end
											if (FlatIdent_8EAFE == 7) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8EAFE = 8;
											end
											if (FlatIdent_8EAFE == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8EAFE = 6;
											end
										end
									elseif (Enum == 97) then
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
										local FlatIdent_E396 = 0;
										while true do
											if (FlatIdent_E396 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_E396 = 6;
											end
											if (FlatIdent_E396 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_E396 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_E396 = 5;
											end
											if (FlatIdent_E396 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_E396 = 3;
											end
											if (FlatIdent_E396 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_E396 = 4;
											end
											if (FlatIdent_E396 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_E396 = 1;
											end
											if (1 == FlatIdent_E396) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_E396 = 2;
											end
										end
									end
								elseif (Enum <= 100) then
									if (Enum > 99) then
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
										local FlatIdent_3B02 = 0;
										while true do
											if (6 == FlatIdent_3B02) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 7;
											end
											if (8 == FlatIdent_3B02) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 9;
											end
											if (FlatIdent_3B02 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 4;
											end
											if (FlatIdent_3B02 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 3;
											end
											if (FlatIdent_3B02 == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 6;
											end
											if (FlatIdent_3B02 == 9) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (4 == FlatIdent_3B02) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 5;
											end
											if (FlatIdent_3B02 == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 8;
											end
											if (FlatIdent_3B02 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 1;
											end
											if (FlatIdent_3B02 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3B02 = 2;
											end
										end
									end
								elseif (Enum == 101) then
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
							elseif (Enum <= 105) then
								if (Enum <= 103) then
									local FlatIdent_52D0 = 0;
									while true do
										if (FlatIdent_52D0 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 1;
										end
										if (FlatIdent_52D0 == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 9;
										end
										if (FlatIdent_52D0 == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 2;
										end
										if (FlatIdent_52D0 == 4) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 5;
										end
										if (FlatIdent_52D0 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 4;
										end
										if (FlatIdent_52D0 == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 8;
										end
										if (FlatIdent_52D0 == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 7;
										end
										if (FlatIdent_52D0 == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_52D0 == 5) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 6;
										end
										if (FlatIdent_52D0 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_52D0 = 3;
										end
									end
								elseif (Enum > 104) then
									local FlatIdent_39CE7 = 0;
									while true do
										if (FlatIdent_39CE7 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_39CE7 = 1;
										end
										if (FlatIdent_39CE7 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_39CE7 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_39CE7 = 6;
										end
										if (4 == FlatIdent_39CE7) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_39CE7 = 5;
										end
										if (FlatIdent_39CE7 == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_39CE7 = 4;
										end
										if (FlatIdent_39CE7 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_39CE7 = 3;
										end
										if (FlatIdent_39CE7 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_39CE7 = 2;
										end
									end
								else
									local FlatIdent_357A9 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_357A9 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_357A9 = 4;
										end
										if (1 == FlatIdent_357A9) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_357A9 = 2;
										end
										if (FlatIdent_357A9 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_357A9 = 5;
										end
										if (FlatIdent_357A9 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_357A9 = 3;
										end
										if (0 == FlatIdent_357A9) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_357A9 = 1;
										end
										if (FlatIdent_357A9 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_357A9 = 6;
										end
										if (FlatIdent_357A9 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
									end
								end
							elseif (Enum <= 107) then
								if (Enum == 106) then
									local FlatIdent_138C9 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_138C9 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_138C9 = 3;
										end
										if (FlatIdent_138C9 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											FlatIdent_138C9 = 4;
										end
										if (FlatIdent_138C9 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = Inst[3];
											FlatIdent_138C9 = 1;
										end
										if (FlatIdent_138C9 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											FlatIdent_138C9 = 5;
										end
										if (1 == FlatIdent_138C9) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_138C9 = 2;
										end
										if (FlatIdent_138C9 == 5) then
											B = Inst[3];
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
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
							elseif (Enum > 108) then
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
									local FlatIdent_84CEE = 0;
									while true do
										if (FlatIdent_84CEE == 0) then
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
									local FlatIdent_947A = 0;
									while true do
										if (FlatIdent_947A == 0) then
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
									local FlatIdent_6F5E5 = 0;
									while true do
										if (FlatIdent_6F5E5 == 0) then
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
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									local FlatIdent_7AB68 = 0;
									while true do
										if (FlatIdent_7AB68 == 0) then
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
						elseif (Enum <= 164) then
							if (Enum <= 136) then
								if (Enum <= 122) then
									if (Enum <= 115) then
										if (Enum <= 112) then
											if (Enum <= 110) then
												local FlatIdent_94B1B = 0;
												local NewProto;
												local NewUvals;
												local Indexes;
												while true do
													if (FlatIdent_94B1B == 1) then
														Indexes = {};
														NewUvals = Setmetatable({}, {__index=function(_, Key)
															local FlatIdent_8EC0B = 0;
															local Val;
															while true do
																if (FlatIdent_8EC0B == 0) then
																	Val = Indexes[Key];
																	return Val[1][Val[2]];
																end
															end
														end,__newindex=function(_, Key, Value)
															local FlatIdent_81EBA = 0;
															local Val;
															while true do
																if (FlatIdent_81EBA == 0) then
																	Val = Indexes[Key];
																	Val[1][Val[2]] = Value;
																	break;
																end
															end
														end});
														FlatIdent_94B1B = 2;
													end
													if (FlatIdent_94B1B == 2) then
														for Idx = 1, Inst[4] do
															local FlatIdent_27CA0 = 0;
															local Mvm;
															while true do
																if (FlatIdent_27CA0 == 1) then
																	if (Mvm[1] == 41) then
																		Indexes[Idx - 1] = {Stk,Mvm[3]};
																	else
																		Indexes[Idx - 1] = {Upvalues,Mvm[3]};
																	end
																	Lupvals[#Lupvals + 1] = Indexes;
																	break;
																end
																if (FlatIdent_27CA0 == 0) then
																	VIP = VIP + 1;
																	Mvm = Instr[VIP];
																	FlatIdent_27CA0 = 1;
																end
															end
														end
														Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
														break;
													end
													if (0 == FlatIdent_94B1B) then
														NewProto = Proto[Inst[3]];
														NewUvals = nil;
														FlatIdent_94B1B = 1;
													end
												end
											elseif (Enum > 111) then
												local FlatIdent_7C4B9 = 0;
												local B;
												local T;
												local A;
												while true do
													if (FlatIdent_7C4B9 == 3) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7C4B9 = 4;
													end
													if (FlatIdent_7C4B9 == 5) then
														Inst = Instr[VIP];
														A = Inst[2];
														T = Stk[A];
														B = Inst[3];
														FlatIdent_7C4B9 = 6;
													end
													if (FlatIdent_7C4B9 == 0) then
														B = nil;
														T = nil;
														A = nil;
														Stk[Inst[2]] = {};
														FlatIdent_7C4B9 = 1;
													end
													if (FlatIdent_7C4B9 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7C4B9 = 2;
													end
													if (FlatIdent_7C4B9 == 2) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7C4B9 = 3;
													end
													if (FlatIdent_7C4B9 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
														VIP = VIP + 1;
														FlatIdent_7C4B9 = 5;
													end
													if (FlatIdent_7C4B9 == 6) then
														for Idx = 1, B do
															T[Idx] = Stk[A + Idx];
														end
														break;
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
										elseif (Enum <= 113) then
											Stk[Inst[2]] = Inst[3];
										elseif (Enum == 114) then
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
											local FlatIdent_283EA = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_283EA == 5) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_283EA == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													FlatIdent_283EA = 5;
												end
												if (FlatIdent_283EA == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_283EA = 3;
												end
												if (FlatIdent_283EA == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_283EA = 1;
												end
												if (FlatIdent_283EA == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													FlatIdent_283EA = 4;
												end
												if (FlatIdent_283EA == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_283EA = 2;
												end
											end
										end
									elseif (Enum <= 118) then
										if (Enum <= 116) then
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
										elseif (Enum > 117) then
											local FlatIdent_2A175 = 0;
											local B;
											local T;
											local A;
											while true do
												if (1 == FlatIdent_2A175) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2A175 = 2;
												end
												if (FlatIdent_2A175 == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2A175 = 3;
												end
												if (FlatIdent_2A175 == 7) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_2A175 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2A175 = 5;
												end
												if (FlatIdent_2A175 == 6) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_2A175 = 7;
												end
												if (FlatIdent_2A175 == 5) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2A175 = 6;
												end
												if (FlatIdent_2A175 == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2A175 = 4;
												end
												if (FlatIdent_2A175 == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_2A175 = 1;
												end
											end
										else
											local FlatIdent_40596 = 0;
											local A;
											while true do
												if (FlatIdent_40596 == 5) then
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
													FlatIdent_40596 = 6;
												end
												if (20 == FlatIdent_40596) then
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
													FlatIdent_40596 = 21;
												end
												if (23 == FlatIdent_40596) then
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
													FlatIdent_40596 = 24;
												end
												if (FlatIdent_40596 == 16) then
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
													FlatIdent_40596 = 17;
												end
												if (FlatIdent_40596 == 0) then
													A = nil;
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_40596 = 1;
												end
												if (FlatIdent_40596 == 10) then
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
													FlatIdent_40596 = 11;
												end
												if (FlatIdent_40596 == 1) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40596 = 2;
												end
												if (FlatIdent_40596 == 24) then
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
													FlatIdent_40596 = 25;
												end
												if (FlatIdent_40596 == 18) then
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
													FlatIdent_40596 = 19;
												end
												if (FlatIdent_40596 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40596 = 4;
												end
												if (FlatIdent_40596 == 17) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40596 = 18;
												end
												if (FlatIdent_40596 == 2) then
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
													FlatIdent_40596 = 3;
												end
												if (FlatIdent_40596 == 7) then
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
													FlatIdent_40596 = 8;
												end
												if (FlatIdent_40596 == 11) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40596 = 12;
												end
												if (FlatIdent_40596 == 9) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40596 = 10;
												end
												if (25 == FlatIdent_40596) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_40596 == 13) then
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
													FlatIdent_40596 = 14;
												end
												if (FlatIdent_40596 == 4) then
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
													FlatIdent_40596 = 5;
												end
												if (FlatIdent_40596 == 19) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_40596 = 20;
												end
												if (FlatIdent_40596 == 22) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_40596 = 23;
												end
												if (FlatIdent_40596 == 14) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_40596 = 15;
												end
												if (FlatIdent_40596 == 15) then
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
													FlatIdent_40596 = 16;
												end
												if (FlatIdent_40596 == 12) then
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
													FlatIdent_40596 = 13;
												end
												if (FlatIdent_40596 == 8) then
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
													FlatIdent_40596 = 9;
												end
												if (FlatIdent_40596 == 21) then
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
													FlatIdent_40596 = 22;
												end
												if (6 == FlatIdent_40596) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_40596 = 7;
												end
											end
										end
									elseif (Enum <= 120) then
										if (Enum == 119) then
											local FlatIdent_3CB60 = 0;
											local A;
											while true do
												if (13 == FlatIdent_3CB60) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 14;
												end
												if (FlatIdent_3CB60 == 12) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3CB60 = 13;
												end
												if (FlatIdent_3CB60 == 17) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_3CB60 = 18;
												end
												if (FlatIdent_3CB60 == 28) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 29;
												end
												if (FlatIdent_3CB60 == 6) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3CB60 = 7;
												end
												if (FlatIdent_3CB60 == 16) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_3CB60 = 17;
												end
												if (FlatIdent_3CB60 == 26) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 27;
												end
												if (14 == FlatIdent_3CB60) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3CB60 = 15;
												end
												if (FlatIdent_3CB60 == 9) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 10;
												end
												if (FlatIdent_3CB60 == 7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 8;
												end
												if (FlatIdent_3CB60 == 18) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3CB60 = 19;
												end
												if (FlatIdent_3CB60 == 29) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_3CB60 = 30;
												end
												if (FlatIdent_3CB60 == 22) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_3CB60 = 23;
												end
												if (FlatIdent_3CB60 == 8) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_3CB60 = 9;
												end
												if (FlatIdent_3CB60 == 11) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 12;
												end
												if (FlatIdent_3CB60 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_3CB60 = 2;
												end
												if (FlatIdent_3CB60 == 25) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3CB60 = 26;
												end
												if (FlatIdent_3CB60 == 23) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_3CB60 = 24;
												end
												if (FlatIdent_3CB60 == 19) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3CB60 = 20;
												end
												if (FlatIdent_3CB60 == 21) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3CB60 = 22;
												end
												if (FlatIdent_3CB60 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3CB60 = 3;
												end
												if (FlatIdent_3CB60 == 15) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 16;
												end
												if (FlatIdent_3CB60 == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 6;
												end
												if (FlatIdent_3CB60 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_3CB60 = 4;
												end
												if (FlatIdent_3CB60 == 0) then
													A = nil;
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3CB60 = 1;
												end
												if (FlatIdent_3CB60 == 30) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 31;
												end
												if (24 == FlatIdent_3CB60) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 25;
												end
												if (FlatIdent_3CB60 == 20) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_3CB60 = 21;
												end
												if (FlatIdent_3CB60 == 10) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_3CB60 = 11;
												end
												if (FlatIdent_3CB60 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_3CB60 = 5;
												end
												if (FlatIdent_3CB60 == 27) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_3CB60 = 28;
												end
												if (FlatIdent_3CB60 == 31) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
											end
										else
											local FlatIdent_2DF26 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_2DF26 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_2DF26 = 2;
												end
												if (FlatIdent_2DF26 == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2DF26 = 4;
												end
												if (FlatIdent_2DF26 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2DF26 = 3;
												end
												if (FlatIdent_2DF26 == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = {};
													FlatIdent_2DF26 = 1;
												end
												if (FlatIdent_2DF26 == 6) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (5 == FlatIdent_2DF26) then
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_2DF26 = 6;
												end
												if (FlatIdent_2DF26 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_2DF26 = 5;
												end
											end
										end
									elseif (Enum > 121) then
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
										local FlatIdent_8918D = 0;
										local A;
										while true do
											if (FlatIdent_8918D == 22) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_8918D = 23;
											end
											if (FlatIdent_8918D == 15) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 16;
											end
											if (FlatIdent_8918D == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_8918D = 5;
											end
											if (FlatIdent_8918D == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 29;
											end
											if (FlatIdent_8918D == 16) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_8918D = 17;
											end
											if (23 == FlatIdent_8918D) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_8918D = 24;
											end
											if (19 == FlatIdent_8918D) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_8918D = 20;
											end
											if (FlatIdent_8918D == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_8918D = 3;
											end
											if (FlatIdent_8918D == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_8918D = 4;
											end
											if (FlatIdent_8918D == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_8918D = 2;
											end
											if (FlatIdent_8918D == 27) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_8918D = 28;
											end
											if (FlatIdent_8918D == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 8;
											end
											if (FlatIdent_8918D == 5) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 6;
											end
											if (FlatIdent_8918D == 20) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_8918D = 21;
											end
											if (FlatIdent_8918D == 8) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_8918D = 9;
											end
											if (30 == FlatIdent_8918D) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 31;
											end
											if (FlatIdent_8918D == 24) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 25;
											end
											if (11 == FlatIdent_8918D) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 12;
											end
											if (FlatIdent_8918D == 13) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 14;
											end
											if (FlatIdent_8918D == 17) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_8918D = 18;
											end
											if (FlatIdent_8918D == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_8918D = 15;
											end
											if (31 == FlatIdent_8918D) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_8918D == 29) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_8918D = 30;
											end
											if (18 == FlatIdent_8918D) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_8918D = 19;
											end
											if (FlatIdent_8918D == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 27;
											end
											if (21 == FlatIdent_8918D) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_8918D = 22;
											end
											if (FlatIdent_8918D == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8918D = 10;
											end
											if (6 == FlatIdent_8918D) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_8918D = 7;
											end
											if (10 == FlatIdent_8918D) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_8918D = 11;
											end
											if (FlatIdent_8918D == 25) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_8918D = 26;
											end
											if (FlatIdent_8918D == 12) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_8918D = 13;
											end
											if (FlatIdent_8918D == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_8918D = 1;
											end
										end
									end
								elseif (Enum <= 129) then
									if (Enum <= 125) then
										if (Enum <= 123) then
											local FlatIdent_36682 = 0;
											while true do
												if (FlatIdent_36682 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_36682 = 6;
												end
												if (FlatIdent_36682 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_36682 = 5;
												end
												if (FlatIdent_36682 == 6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_36682 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_36682 = 3;
												end
												if (FlatIdent_36682 == 3) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_36682 = 4;
												end
												if (0 == FlatIdent_36682) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_36682 = 1;
												end
												if (FlatIdent_36682 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_36682 = 2;
												end
											end
										elseif (Enum == 124) then
											local FlatIdent_173BB = 0;
											while true do
												if (FlatIdent_173BB == 3) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_173BB = 4;
												end
												if (FlatIdent_173BB == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_173BB = 1;
												end
												if (FlatIdent_173BB == 6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_173BB == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_173BB = 3;
												end
												if (FlatIdent_173BB == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_173BB = 5;
												end
												if (FlatIdent_173BB == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_173BB = 6;
												end
												if (FlatIdent_173BB == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_173BB = 2;
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
									elseif (Enum <= 127) then
										if (Enum > 126) then
											local FlatIdent_953ED = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_953ED == 0) then
													B = nil;
													T = nil;
													A = nil;
													Stk[Inst[2]] = Inst[3];
													FlatIdent_953ED = 1;
												end
												if (FlatIdent_953ED == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													T = Stk[A];
													FlatIdent_953ED = 5;
												end
												if (FlatIdent_953ED == 5) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_953ED == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_953ED = 3;
												end
												if (FlatIdent_953ED == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_953ED = 2;
												end
												if (FlatIdent_953ED == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													FlatIdent_953ED = 4;
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
									elseif (Enum > 128) then
										local FlatIdent_5C8A7 = 0;
										local A;
										while true do
											if (11 == FlatIdent_5C8A7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 12;
											end
											if (FlatIdent_5C8A7 == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 10;
											end
											if (FlatIdent_5C8A7 == 18) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 19;
											end
											if (FlatIdent_5C8A7 == 5) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 6;
											end
											if (16 == FlatIdent_5C8A7) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 17;
											end
											if (FlatIdent_5C8A7 == 24) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 25;
											end
											if (FlatIdent_5C8A7 == 27) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5C8A7 = 28;
											end
											if (1 == FlatIdent_5C8A7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 2;
											end
											if (FlatIdent_5C8A7 == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5C8A7 = 1;
											end
											if (FlatIdent_5C8A7 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_5C8A7 = 5;
											end
											if (FlatIdent_5C8A7 == 8) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_5C8A7 = 9;
											end
											if (FlatIdent_5C8A7 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 4;
											end
											if (FlatIdent_5C8A7 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 29;
											end
											if (FlatIdent_5C8A7 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 8;
											end
											if (FlatIdent_5C8A7 == 20) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 21;
											end
											if (FlatIdent_5C8A7 == 31) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_5C8A7 == 13) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 14;
											end
											if (FlatIdent_5C8A7 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5C8A7 = 3;
											end
											if (FlatIdent_5C8A7 == 25) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5C8A7 = 26;
											end
											if (FlatIdent_5C8A7 == 29) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_5C8A7 = 30;
											end
											if (22 == FlatIdent_5C8A7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 23;
											end
											if (FlatIdent_5C8A7 == 30) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 31;
											end
											if (FlatIdent_5C8A7 == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 15;
											end
											if (10 == FlatIdent_5C8A7) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_5C8A7 = 11;
											end
											if (FlatIdent_5C8A7 == 15) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 16;
											end
											if (FlatIdent_5C8A7 == 23) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_5C8A7 = 24;
											end
											if (FlatIdent_5C8A7 == 12) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_5C8A7 = 13;
											end
											if (FlatIdent_5C8A7 == 17) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_5C8A7 = 18;
											end
											if (FlatIdent_5C8A7 == 19) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5C8A7 = 20;
											end
											if (FlatIdent_5C8A7 == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5C8A7 = 27;
											end
											if (FlatIdent_5C8A7 == 6) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5C8A7 = 7;
											end
											if (FlatIdent_5C8A7 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_5C8A7 = 22;
											end
										end
									else
										local FlatIdent_A82F = 0;
										local A;
										while true do
											if (19 == FlatIdent_A82F) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 20;
											end
											if (FlatIdent_A82F == 1) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 2;
											end
											if (FlatIdent_A82F == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_A82F = 12;
											end
											if (FlatIdent_A82F == 13) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 14;
											end
											if (FlatIdent_A82F == 2) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_A82F = 3;
											end
											if (FlatIdent_A82F == 22) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_A82F = 23;
											end
											if (5 == FlatIdent_A82F) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_A82F = 6;
											end
											if (FlatIdent_A82F == 8) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 9;
											end
											if (FlatIdent_A82F == 20) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 21;
											end
											if (FlatIdent_A82F == 21) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_A82F = 22;
											end
											if (3 == FlatIdent_A82F) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_A82F = 4;
											end
											if (FlatIdent_A82F == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 15;
											end
											if (25 == FlatIdent_A82F) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_A82F == 15) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_A82F = 16;
											end
											if (FlatIdent_A82F == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_A82F = 5;
											end
											if (FlatIdent_A82F == 23) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_A82F = 24;
											end
											if (FlatIdent_A82F == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_A82F = 18;
											end
											if (FlatIdent_A82F == 24) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_A82F = 25;
											end
											if (16 == FlatIdent_A82F) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_A82F = 17;
											end
											if (FlatIdent_A82F == 0) then
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
												FlatIdent_A82F = 1;
											end
											if (FlatIdent_A82F == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_A82F = 7;
											end
											if (FlatIdent_A82F == 18) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_A82F = 19;
											end
											if (FlatIdent_A82F == 7) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_A82F = 8;
											end
											if (FlatIdent_A82F == 12) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_A82F = 13;
											end
											if (FlatIdent_A82F == 10) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_A82F = 11;
											end
											if (FlatIdent_A82F == 9) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_A82F = 10;
											end
										end
									end
								elseif (Enum <= 132) then
									if (Enum <= 130) then
										local FlatIdent_4EF63 = 0;
										while true do
											if (FlatIdent_4EF63 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_4EF63 = 5;
											end
											if (FlatIdent_4EF63 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_4EF63 = 6;
											end
											if (FlatIdent_4EF63 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_4EF63 = 1;
											end
											if (FlatIdent_4EF63 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_4EF63 = 3;
											end
											if (FlatIdent_4EF63 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (3 == FlatIdent_4EF63) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_4EF63 = 4;
											end
											if (FlatIdent_4EF63 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_4EF63 = 2;
											end
										end
									elseif (Enum > 131) then
										local FlatIdent_8C8B6 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_8C8B6 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8C8B6 = 2;
											end
											if (FlatIdent_8C8B6 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8C8B6 = 5;
											end
											if (FlatIdent_8C8B6 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8C8B6 = 4;
											end
											if (FlatIdent_8C8B6 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8C8B6 = 3;
											end
											if (FlatIdent_8C8B6 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_8C8B6 = 1;
											end
											if (FlatIdent_8C8B6 == 6) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_8C8B6 = 7;
											end
											if (7 == FlatIdent_8C8B6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_8C8B6 == 5) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8C8B6 = 6;
											end
										end
									else
										local FlatIdent_301D6 = 0;
										while true do
											if (FlatIdent_301D6 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_301D6 = 4;
											end
											if (FlatIdent_301D6 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_301D6 = 1;
											end
											if (2 == FlatIdent_301D6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_301D6 = 3;
											end
											if (5 == FlatIdent_301D6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_301D6 = 6;
											end
											if (FlatIdent_301D6 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_301D6 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_301D6 = 2;
											end
											if (FlatIdent_301D6 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_301D6 = 5;
											end
										end
									end
								elseif (Enum <= 134) then
									if (Enum > 133) then
										local FlatIdent_8E02C = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_8E02C == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8E02C = 6;
											end
											if (FlatIdent_8E02C == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8E02C = 4;
											end
											if (FlatIdent_8E02C == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8E02C = 3;
											end
											if (FlatIdent_8E02C == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_8E02C = 8;
											end
											if (FlatIdent_8E02C == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8E02C = 5;
											end
											if (FlatIdent_8E02C == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8E02C = 7;
											end
											if (0 == FlatIdent_8E02C) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_8E02C = 1;
											end
											if (8 == FlatIdent_8E02C) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (1 == FlatIdent_8E02C) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8E02C = 2;
											end
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									end
								elseif (Enum == 135) then
									local FlatIdent_12DD = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_12DD == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_12DD = 5;
										end
										if (FlatIdent_12DD == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_12DD = 4;
										end
										if (FlatIdent_12DD == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_12DD = 6;
										end
										if (FlatIdent_12DD == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_12DD = 1;
										end
										if (FlatIdent_12DD == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_12DD = 3;
										end
										if (FlatIdent_12DD == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_12DD == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_12DD = 2;
										end
									end
								else
									local FlatIdent_3E49C = 0;
									local A;
									while true do
										if (FlatIdent_3E49C == 19) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3E49C = 20;
										end
										if (FlatIdent_3E49C == 9) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 10;
										end
										if (FlatIdent_3E49C == 14) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_3E49C = 15;
										end
										if (FlatIdent_3E49C == 15) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 16;
										end
										if (FlatIdent_3E49C == 20) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_3E49C = 21;
										end
										if (FlatIdent_3E49C == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_3E49C = 2;
										end
										if (FlatIdent_3E49C == 24) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 25;
										end
										if (FlatIdent_3E49C == 26) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 27;
										end
										if (FlatIdent_3E49C == 16) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_3E49C = 17;
										end
										if (FlatIdent_3E49C == 22) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_3E49C = 23;
										end
										if (8 == FlatIdent_3E49C) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_3E49C = 9;
										end
										if (FlatIdent_3E49C == 12) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_3E49C = 13;
										end
										if (23 == FlatIdent_3E49C) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_3E49C = 24;
										end
										if (FlatIdent_3E49C == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 6;
										end
										if (FlatIdent_3E49C == 17) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_3E49C = 18;
										end
										if (18 == FlatIdent_3E49C) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_3E49C = 19;
										end
										if (30 == FlatIdent_3E49C) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 31;
										end
										if (FlatIdent_3E49C == 3) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_3E49C = 4;
										end
										if (FlatIdent_3E49C == 13) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 14;
										end
										if (FlatIdent_3E49C == 27) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_3E49C = 28;
										end
										if (FlatIdent_3E49C == 10) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_3E49C = 11;
										end
										if (FlatIdent_3E49C == 29) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_3E49C = 30;
										end
										if (FlatIdent_3E49C == 6) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3E49C = 7;
										end
										if (FlatIdent_3E49C == 4) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_3E49C = 5;
										end
										if (FlatIdent_3E49C == 25) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3E49C = 26;
										end
										if (FlatIdent_3E49C == 31) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_3E49C == 21) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3E49C = 22;
										end
										if (FlatIdent_3E49C == 28) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 29;
										end
										if (7 == FlatIdent_3E49C) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 8;
										end
										if (0 == FlatIdent_3E49C) then
											A = nil;
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3E49C = 1;
										end
										if (11 == FlatIdent_3E49C) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3E49C = 12;
										end
										if (FlatIdent_3E49C == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3E49C = 3;
										end
									end
								end
							elseif (Enum <= 150) then
								if (Enum <= 143) then
									if (Enum <= 139) then
										if (Enum <= 137) then
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
										elseif (Enum == 138) then
											local FlatIdent_92611 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_92611 == 8) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_92611 == 5) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_92611 = 6;
												end
												if (FlatIdent_92611 == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_92611 = 1;
												end
												if (FlatIdent_92611 == 2) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_92611 = 3;
												end
												if (FlatIdent_92611 == 3) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_92611 = 4;
												end
												if (FlatIdent_92611 == 6) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_92611 = 7;
												end
												if (1 == FlatIdent_92611) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_92611 = 2;
												end
												if (7 == FlatIdent_92611) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_92611 = 8;
												end
												if (FlatIdent_92611 == 4) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_92611 = 5;
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
									elseif (Enum <= 141) then
										if (Enum == 140) then
											local FlatIdent_2039D = 0;
											local A;
											while true do
												if (FlatIdent_2039D == 6) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_2039D = 7;
												end
												if (FlatIdent_2039D == 13) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_2039D = 14;
												end
												if (FlatIdent_2039D == 10) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_2039D = 11;
												end
												if (FlatIdent_2039D == 8) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 9;
												end
												if (FlatIdent_2039D == 22) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 23;
												end
												if (15 == FlatIdent_2039D) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 16;
												end
												if (FlatIdent_2039D == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2039D = 2;
												end
												if (FlatIdent_2039D == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_2039D = 5;
												end
												if (FlatIdent_2039D == 25) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_2039D = 26;
												end
												if (FlatIdent_2039D == 0) then
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2039D = 1;
												end
												if (FlatIdent_2039D == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_2039D = 6;
												end
												if (FlatIdent_2039D == 28) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													break;
												end
												if (2 == FlatIdent_2039D) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 3;
												end
												if (FlatIdent_2039D == 24) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_2039D = 25;
												end
												if (FlatIdent_2039D == 21) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 22;
												end
												if (FlatIdent_2039D == 12) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													FlatIdent_2039D = 13;
												end
												if (FlatIdent_2039D == 7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2039D = 8;
												end
												if (14 == FlatIdent_2039D) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_2039D = 15;
												end
												if (FlatIdent_2039D == 26) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2039D = 27;
												end
												if (FlatIdent_2039D == 11) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_2039D = 12;
												end
												if (FlatIdent_2039D == 27) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 28;
												end
												if (FlatIdent_2039D == 20) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2039D = 21;
												end
												if (9 == FlatIdent_2039D) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 10;
												end
												if (FlatIdent_2039D == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 4;
												end
												if (FlatIdent_2039D == 18) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_2039D = 19;
												end
												if (FlatIdent_2039D == 23) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_2039D = 24;
												end
												if (FlatIdent_2039D == 19) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_2039D = 20;
												end
												if (FlatIdent_2039D == 16) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2039D = 17;
												end
												if (FlatIdent_2039D == 17) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_2039D = 18;
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
									elseif (Enum == 142) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
									if (Enum <= 144) then
										local FlatIdent_25613 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_25613 == 5) then
												B = Inst[3];
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_25613 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_25613 = 3;
											end
											if (FlatIdent_25613 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												FlatIdent_25613 = 5;
											end
											if (FlatIdent_25613 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = Inst[3];
												FlatIdent_25613 = 1;
											end
											if (3 == FlatIdent_25613) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												FlatIdent_25613 = 4;
											end
											if (FlatIdent_25613 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_25613 = 2;
											end
										end
									elseif (Enum == 145) then
										local FlatIdent_7A5E1 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_7A5E1 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_7A5E1 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_7A5E1 = 1;
											end
											if (FlatIdent_7A5E1 == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7A5E1 = 2;
											end
											if (FlatIdent_7A5E1 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7A5E1 = 3;
											end
											if (FlatIdent_7A5E1 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7A5E1 = 4;
											end
											if (4 == FlatIdent_7A5E1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7A5E1 = 5;
											end
											if (FlatIdent_7A5E1 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7A5E1 = 6;
											end
											if (FlatIdent_7A5E1 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7A5E1 = 7;
											end
											if (7 == FlatIdent_7A5E1) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_7A5E1 = 8;
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
										local FlatIdent_672CF = 0;
										local B;
										local T;
										local A;
										while true do
											if (3 == FlatIdent_672CF) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_672CF = 4;
											end
											if (FlatIdent_672CF == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_672CF = 1;
											end
											if (FlatIdent_672CF == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_672CF = 5;
											end
											if (FlatIdent_672CF == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_672CF = 2;
											end
											if (FlatIdent_672CF == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_672CF = 3;
											end
											if (FlatIdent_672CF == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_672CF = 6;
											end
											if (FlatIdent_672CF == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
										end
									end
								elseif (Enum > 149) then
									local FlatIdent_8D717 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_8D717 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_8D717 = 6;
										end
										if (FlatIdent_8D717 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8D717 = 3;
										end
										if (FlatIdent_8D717 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_8D717 = 1;
										end
										if (FlatIdent_8D717 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_8D717 = 4;
										end
										if (FlatIdent_8D717 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_8D717 = 5;
										end
										if (FlatIdent_8D717 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_8D717 = 2;
										end
										if (FlatIdent_8D717 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
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
							elseif (Enum <= 157) then
								if (Enum <= 153) then
									if (Enum <= 151) then
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
									elseif (Enum > 152) then
										local FlatIdent_19EBF = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_19EBF == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_19EBF = 6;
											end
											if (FlatIdent_19EBF == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_19EBF = 3;
											end
											if (FlatIdent_19EBF == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_19EBF == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_19EBF = 1;
											end
											if (FlatIdent_19EBF == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_19EBF = 2;
											end
											if (FlatIdent_19EBF == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_19EBF = 8;
											end
											if (FlatIdent_19EBF == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_19EBF = 5;
											end
											if (FlatIdent_19EBF == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_19EBF = 4;
											end
											if (6 == FlatIdent_19EBF) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_19EBF = 7;
											end
										end
									else
										local FlatIdent_6BCD2 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_6BCD2 == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_6BCD2 = 6;
											end
											if (FlatIdent_6BCD2 == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_6BCD2 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_6BCD2 = 1;
											end
											if (FlatIdent_6BCD2 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_6BCD2 = 5;
											end
											if (FlatIdent_6BCD2 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_6BCD2 = 4;
											end
											if (2 == FlatIdent_6BCD2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6BCD2 = 3;
											end
											if (1 == FlatIdent_6BCD2) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_6BCD2 = 2;
											end
										end
									end
								elseif (Enum <= 155) then
									if (Enum == 154) then
										local FlatIdent_6319D = 0;
										local A;
										local Index;
										local Step;
										while true do
											if (FlatIdent_6319D == 1) then
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
											if (FlatIdent_6319D == 0) then
												A = Inst[2];
												Index = Stk[A];
												FlatIdent_6319D = 1;
											end
										end
									else
										local FlatIdent_698EE = 0;
										while true do
											if (FlatIdent_698EE == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_698EE == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_698EE = 1;
											end
											if (FlatIdent_698EE == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_698EE = 2;
											end
											if (FlatIdent_698EE == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_698EE = 3;
											end
											if (FlatIdent_698EE == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_698EE = 4;
											end
											if (FlatIdent_698EE == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_698EE = 6;
											end
											if (FlatIdent_698EE == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_698EE = 5;
											end
										end
									end
								elseif (Enum > 156) then
									local FlatIdent_57072 = 0;
									local A;
									while true do
										if (0 == FlatIdent_57072) then
											A = Inst[2];
											do
												return Unpack(Stk, A, Top);
											end
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
							elseif (Enum <= 160) then
								if (Enum <= 158) then
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
								elseif (Enum == 159) then
									local FlatIdent_38A95 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_38A95 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_38A95 = 6;
										end
										if (3 == FlatIdent_38A95) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_38A95 = 4;
										end
										if (FlatIdent_38A95 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_38A95 = 5;
										end
										if (FlatIdent_38A95 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_38A95 = 1;
										end
										if (FlatIdent_38A95 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_38A95 = 2;
										end
										if (FlatIdent_38A95 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_38A95 = 3;
										end
										if (FlatIdent_38A95 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
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
							elseif (Enum <= 162) then
								if (Enum == 161) then
									local FlatIdent_8EBD6 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_8EBD6 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EBD6 = 5;
										end
										if (FlatIdent_8EBD6 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EBD6 = 4;
										end
										if (FlatIdent_8EBD6 == 7) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_8EBD6 == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EBD6 = 2;
										end
										if (FlatIdent_8EBD6 == 6) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_8EBD6 = 7;
										end
										if (2 == FlatIdent_8EBD6) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EBD6 = 3;
										end
										if (FlatIdent_8EBD6 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_8EBD6 = 1;
										end
										if (FlatIdent_8EBD6 == 5) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8EBD6 = 6;
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
							elseif (Enum > 163) then
								local FlatIdent_74295 = 0;
								while true do
									if (FlatIdent_74295 == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 2;
									end
									if (FlatIdent_74295 == 7) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 8;
									end
									if (FlatIdent_74295 == 3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 4;
									end
									if (5 == FlatIdent_74295) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 6;
									end
									if (8 == FlatIdent_74295) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 9;
									end
									if (FlatIdent_74295 == 4) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 5;
									end
									if (FlatIdent_74295 == 6) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 7;
									end
									if (FlatIdent_74295 == 9) then
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_74295 == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 3;
									end
									if (FlatIdent_74295 == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_74295 = 1;
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
						elseif (Enum <= 192) then
							if (Enum <= 178) then
								if (Enum <= 171) then
									if (Enum <= 167) then
										if (Enum <= 165) then
											local FlatIdent_35B09 = 0;
											local B;
											local T;
											local A;
											while true do
												if (FlatIdent_35B09 == 4) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_35B09 = 5;
												end
												if (7 == FlatIdent_35B09) then
													A = Inst[2];
													T = Stk[A];
													B = Inst[3];
													FlatIdent_35B09 = 8;
												end
												if (FlatIdent_35B09 == 2) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_35B09 = 3;
												end
												if (FlatIdent_35B09 == 1) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_35B09 = 2;
												end
												if (6 == FlatIdent_35B09) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_35B09 = 7;
												end
												if (FlatIdent_35B09 == 0) then
													B = nil;
													T = nil;
													A = nil;
													FlatIdent_35B09 = 1;
												end
												if (FlatIdent_35B09 == 8) then
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (3 == FlatIdent_35B09) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_35B09 = 4;
												end
												if (FlatIdent_35B09 == 5) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_35B09 = 6;
												end
											end
										elseif (Enum > 166) then
											local FlatIdent_79549 = 0;
											while true do
												if (FlatIdent_79549 == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_79549 = 1;
												end
												if (FlatIdent_79549 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_79549 = 6;
												end
												if (3 == FlatIdent_79549) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													FlatIdent_79549 = 4;
												end
												if (FlatIdent_79549 == 6) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_79549 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_79549 = 5;
												end
												if (FlatIdent_79549 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_79549 = 3;
												end
												if (FlatIdent_79549 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													FlatIdent_79549 = 2;
												end
											end
										else
											local FlatIdent_44337 = 0;
											local A;
											while true do
												if (FlatIdent_44337 == 0) then
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Top));
													break;
												end
											end
										end
									elseif (Enum <= 169) then
										if (Enum > 168) then
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
											local FlatIdent_577DC = 0;
											while true do
												if (FlatIdent_577DC == 7) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 8;
												end
												if (FlatIdent_577DC == 4) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 5;
												end
												if (FlatIdent_577DC == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 2;
												end
												if (FlatIdent_577DC == 9) then
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_577DC == 5) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 6;
												end
												if (FlatIdent_577DC == 8) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 9;
												end
												if (FlatIdent_577DC == 6) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 7;
												end
												if (2 == FlatIdent_577DC) then
													Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 3;
												end
												if (FlatIdent_577DC == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 4;
												end
												if (FlatIdent_577DC == 0) then
													Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_577DC = 1;
												end
											end
										end
									elseif (Enum > 170) then
										local FlatIdent_48E3 = 0;
										local A;
										while true do
											if (FlatIdent_48E3 == 9) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_48E3 = 10;
											end
											if (FlatIdent_48E3 == 12) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_48E3 = 13;
											end
											if (FlatIdent_48E3 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 12;
											end
											if (FlatIdent_48E3 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_48E3 = 9;
											end
											if (31 == FlatIdent_48E3) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												break;
											end
											if (FlatIdent_48E3 == 16) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_48E3 = 17;
											end
											if (FlatIdent_48E3 == 23) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_48E3 = 24;
											end
											if (FlatIdent_48E3 == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_48E3 = 15;
											end
											if (FlatIdent_48E3 == 18) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_48E3 = 19;
											end
											if (FlatIdent_48E3 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_48E3 = 8;
											end
											if (FlatIdent_48E3 == 20) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_48E3 = 21;
											end
											if (FlatIdent_48E3 == 15) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 16;
											end
											if (FlatIdent_48E3 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_48E3 = 5;
											end
											if (FlatIdent_48E3 == 27) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_48E3 = 28;
											end
											if (FlatIdent_48E3 == 25) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_48E3 = 26;
											end
											if (FlatIdent_48E3 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_48E3 = 4;
											end
											if (FlatIdent_48E3 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 3;
											end
											if (5 == FlatIdent_48E3) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_48E3 = 6;
											end
											if (FlatIdent_48E3 == 22) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_48E3 = 23;
											end
											if (6 == FlatIdent_48E3) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_48E3 = 7;
											end
											if (19 == FlatIdent_48E3) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 20;
											end
											if (FlatIdent_48E3 == 10) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_48E3 = 11;
											end
											if (FlatIdent_48E3 == 24) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_48E3 = 25;
											end
											if (FlatIdent_48E3 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 22;
											end
											if (FlatIdent_48E3 == 29) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_48E3 = 30;
											end
											if (FlatIdent_48E3 == 0) then
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 1;
											end
											if (1 == FlatIdent_48E3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_48E3 = 2;
											end
											if (30 == FlatIdent_48E3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 31;
											end
											if (FlatIdent_48E3 == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_48E3 = 27;
											end
											if (FlatIdent_48E3 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_48E3 = 29;
											end
											if (FlatIdent_48E3 == 13) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 14;
											end
											if (FlatIdent_48E3 == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_48E3 = 18;
											end
										end
									else
										local FlatIdent_3370B = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_3370B == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3370B = 4;
											end
											if (FlatIdent_3370B == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3370B = 3;
											end
											if (FlatIdent_3370B == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3370B = 6;
											end
											if (FlatIdent_3370B == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3370B = 5;
											end
											if (FlatIdent_3370B == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3370B = 2;
											end
											if (FlatIdent_3370B == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_3370B = 8;
											end
											if (FlatIdent_3370B == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_3370B == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_3370B = 1;
											end
											if (FlatIdent_3370B == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3370B = 7;
											end
										end
									end
								elseif (Enum <= 174) then
									if (Enum <= 172) then
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
									elseif (Enum == 173) then
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
										local FlatIdent_628E8 = 0;
										while true do
											if (FlatIdent_628E8 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_628E8 = 4;
											end
											if (FlatIdent_628E8 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_628E8 = 2;
											end
											if (FlatIdent_628E8 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_628E8 = 1;
											end
											if (FlatIdent_628E8 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_628E8 = 6;
											end
											if (6 == FlatIdent_628E8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_628E8 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_628E8 = 3;
											end
											if (FlatIdent_628E8 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_628E8 = 5;
											end
										end
									end
								elseif (Enum <= 176) then
									if (Enum == 175) then
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
										local FlatIdent_98961 = 0;
										local A;
										while true do
											if (0 == FlatIdent_98961) then
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_98961 = 1;
											end
											if (FlatIdent_98961 == 20) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_98961 = 21;
											end
											if (FlatIdent_98961 == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_98961 = 15;
											end
											if (FlatIdent_98961 == 19) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_98961 = 20;
											end
											if (FlatIdent_98961 == 10) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_98961 = 11;
											end
											if (FlatIdent_98961 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_98961 = 12;
											end
											if (FlatIdent_98961 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_98961 == 16) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_98961 = 17;
											end
											if (FlatIdent_98961 == 12) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 13;
											end
											if (FlatIdent_98961 == 2) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 3;
											end
											if (FlatIdent_98961 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_98961 = 5;
											end
											if (FlatIdent_98961 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												FlatIdent_98961 = 22;
											end
											if (FlatIdent_98961 == 8) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 9;
											end
											if (FlatIdent_98961 == 13) then
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 14;
											end
											if (FlatIdent_98961 == 22) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_98961 = 23;
											end
											if (FlatIdent_98961 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_98961 = 2;
											end
											if (FlatIdent_98961 == 25) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_98961 = 26;
											end
											if (FlatIdent_98961 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												FlatIdent_98961 = 6;
											end
											if (FlatIdent_98961 == 24) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 25;
											end
											if (FlatIdent_98961 == 26) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_98961 = 27;
											end
											if (FlatIdent_98961 == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_98961 = 18;
											end
											if (FlatIdent_98961 == 18) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 19;
											end
											if (FlatIdent_98961 == 15) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_98961 = 16;
											end
											if (FlatIdent_98961 == 23) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 24;
											end
											if (FlatIdent_98961 == 6) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_98961 = 7;
											end
											if (FlatIdent_98961 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_98961 = 8;
											end
											if (27 == FlatIdent_98961) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_98961 = 28;
											end
											if (9 == FlatIdent_98961) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_98961 = 10;
											end
											if (FlatIdent_98961 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_98961 = 4;
											end
										end
									end
								elseif (Enum > 177) then
									local FlatIdent_4C4BD = 0;
									while true do
										if (FlatIdent_4C4BD == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 3;
										end
										if (FlatIdent_4C4BD == 7) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 8;
										end
										if (FlatIdent_4C4BD == 9) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_4C4BD == 4) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 5;
										end
										if (FlatIdent_4C4BD == 8) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 9;
										end
										if (FlatIdent_4C4BD == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 2;
										end
										if (FlatIdent_4C4BD == 6) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 7;
										end
										if (5 == FlatIdent_4C4BD) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 6;
										end
										if (FlatIdent_4C4BD == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 4;
										end
										if (FlatIdent_4C4BD == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4C4BD = 1;
										end
									end
								else
									Stk[Inst[2]] = {};
								end
							elseif (Enum <= 185) then
								if (Enum <= 181) then
									if (Enum <= 179) then
										local FlatIdent_72D7A = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_72D7A == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_72D7A = 8;
											end
											if (FlatIdent_72D7A == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_72D7A = 7;
											end
											if (FlatIdent_72D7A == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_72D7A = 5;
											end
											if (FlatIdent_72D7A == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_72D7A = 1;
											end
											if (FlatIdent_72D7A == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_72D7A == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_72D7A = 6;
											end
											if (FlatIdent_72D7A == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_72D7A = 4;
											end
											if (FlatIdent_72D7A == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_72D7A = 3;
											end
											if (FlatIdent_72D7A == 1) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_72D7A = 2;
											end
										end
									elseif (Enum > 180) then
										local FlatIdent_75B77 = 0;
										while true do
											if (FlatIdent_75B77 == 2) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 3;
											end
											if (FlatIdent_75B77 == 8) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 9;
											end
											if (FlatIdent_75B77 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 4;
											end
											if (FlatIdent_75B77 == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 7;
											end
											if (FlatIdent_75B77 == 7) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 8;
											end
											if (FlatIdent_75B77 == 4) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 5;
											end
											if (FlatIdent_75B77 == 5) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 6;
											end
											if (FlatIdent_75B77 == 9) then
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_75B77 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 1;
											end
											if (FlatIdent_75B77 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_75B77 = 2;
											end
										end
									else
										local FlatIdent_1C598 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_1C598 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_1C598 = 1;
											end
											if (FlatIdent_1C598 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_1C598 = 4;
											end
											if (FlatIdent_1C598 == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (2 == FlatIdent_1C598) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1C598 = 3;
											end
											if (FlatIdent_1C598 == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_1C598 = 6;
											end
											if (FlatIdent_1C598 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_1C598 = 5;
											end
											if (1 == FlatIdent_1C598) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_1C598 = 2;
											end
										end
									end
								elseif (Enum <= 183) then
									if (Enum > 182) then
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
										local FlatIdent_92644 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_92644 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_92644 = 3;
											end
											if (FlatIdent_92644 == 4) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_92644 = 5;
											end
											if (FlatIdent_92644 == 7) then
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_92644 = 8;
											end
											if (1 == FlatIdent_92644) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_92644 = 2;
											end
											if (FlatIdent_92644 == 0) then
												B = nil;
												T = nil;
												A = nil;
												FlatIdent_92644 = 1;
											end
											if (FlatIdent_92644 == 3) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_92644 = 4;
											end
											if (FlatIdent_92644 == 8) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_92644 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_92644 = 7;
											end
											if (FlatIdent_92644 == 5) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_92644 = 6;
											end
										end
									end
								elseif (Enum > 184) then
									local FlatIdent_50B68 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_50B68 == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_50B68 = 6;
										end
										if (FlatIdent_50B68 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_50B68 = 5;
										end
										if (FlatIdent_50B68 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_50B68 = 2;
										end
										if (2 == FlatIdent_50B68) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_50B68 = 3;
										end
										if (FlatIdent_50B68 == 6) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (3 == FlatIdent_50B68) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_50B68 = 4;
										end
										if (FlatIdent_50B68 == 0) then
											B = nil;
											T = nil;
											A = nil;
											Stk[Inst[2]] = {};
											FlatIdent_50B68 = 1;
										end
									end
								else
									local FlatIdent_70C86 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_70C86 == 8) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_70C86 == 4) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_70C86 = 5;
										end
										if (FlatIdent_70C86 == 1) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_70C86 = 2;
										end
										if (6 == FlatIdent_70C86) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_70C86 = 7;
										end
										if (FlatIdent_70C86 == 2) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_70C86 = 3;
										end
										if (FlatIdent_70C86 == 7) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_70C86 = 8;
										end
										if (FlatIdent_70C86 == 3) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_70C86 = 4;
										end
										if (5 == FlatIdent_70C86) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_70C86 = 6;
										end
										if (FlatIdent_70C86 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_70C86 = 1;
										end
									end
								end
							elseif (Enum <= 188) then
								if (Enum <= 186) then
									local FlatIdent_3111D = 0;
									while true do
										if (FlatIdent_3111D == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_3111D = 4;
										end
										if (FlatIdent_3111D == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_3111D = 1;
										end
										if (FlatIdent_3111D == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3111D = 3;
										end
										if (4 == FlatIdent_3111D) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_3111D = 5;
										end
										if (FlatIdent_3111D == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_3111D = 2;
										end
										if (FlatIdent_3111D == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_3111D = 6;
										end
										if (FlatIdent_3111D == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
									end
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
									local FlatIdent_5642D = 0;
									local A;
									while true do
										if (13 == FlatIdent_5642D) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_5642D = 14;
										end
										if (FlatIdent_5642D == 22) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_5642D = 23;
										end
										if (FlatIdent_5642D == 16) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_5642D = 17;
										end
										if (FlatIdent_5642D == 12) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_5642D = 13;
										end
										if (FlatIdent_5642D == 17) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_5642D = 18;
										end
										if (FlatIdent_5642D == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_5642D = 8;
										end
										if (FlatIdent_5642D == 11) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_5642D = 12;
										end
										if (FlatIdent_5642D == 20) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 21;
										end
										if (25 == FlatIdent_5642D) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											break;
										end
										if (FlatIdent_5642D == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_5642D = 6;
										end
										if (FlatIdent_5642D == 9) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 10;
										end
										if (FlatIdent_5642D == 18) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_5642D = 19;
										end
										if (FlatIdent_5642D == 6) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_5642D = 7;
										end
										if (FlatIdent_5642D == 23) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_5642D = 24;
										end
										if (14 == FlatIdent_5642D) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 15;
										end
										if (FlatIdent_5642D == 21) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 22;
										end
										if (FlatIdent_5642D == 0) then
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
											FlatIdent_5642D = 1;
										end
										if (FlatIdent_5642D == 2) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 3;
										end
										if (FlatIdent_5642D == 15) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 16;
										end
										if (FlatIdent_5642D == 3) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_5642D = 4;
										end
										if (FlatIdent_5642D == 1) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 2;
										end
										if (FlatIdent_5642D == 8) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5642D = 9;
										end
										if (FlatIdent_5642D == 4) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_5642D = 5;
										end
										if (FlatIdent_5642D == 10) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_5642D = 11;
										end
										if (FlatIdent_5642D == 19) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_5642D = 20;
										end
										if (FlatIdent_5642D == 24) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_5642D = 25;
										end
									end
								end
							elseif (Enum <= 190) then
								if (Enum == 189) then
									local FlatIdent_85D6F = 0;
									local A;
									while true do
										if (FlatIdent_85D6F == 8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 9;
										end
										if (13 == FlatIdent_85D6F) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_85D6F = 14;
										end
										if (FlatIdent_85D6F == 25) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_85D6F = 26;
										end
										if (FlatIdent_85D6F == 21) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 22;
										end
										if (FlatIdent_85D6F == 12) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_85D6F = 13;
										end
										if (FlatIdent_85D6F == 28) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											break;
										end
										if (FlatIdent_85D6F == 18) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_85D6F = 19;
										end
										if (FlatIdent_85D6F == 20) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_85D6F = 21;
										end
										if (FlatIdent_85D6F == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_85D6F = 6;
										end
										if (FlatIdent_85D6F == 26) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_85D6F = 27;
										end
										if (14 == FlatIdent_85D6F) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_85D6F = 15;
										end
										if (FlatIdent_85D6F == 10) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_85D6F = 11;
										end
										if (FlatIdent_85D6F == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_85D6F = 5;
										end
										if (FlatIdent_85D6F == 23) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_85D6F = 24;
										end
										if (FlatIdent_85D6F == 11) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_85D6F = 12;
										end
										if (0 == FlatIdent_85D6F) then
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_85D6F = 1;
										end
										if (FlatIdent_85D6F == 15) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 16;
										end
										if (FlatIdent_85D6F == 7) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_85D6F = 8;
										end
										if (FlatIdent_85D6F == 17) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_85D6F = 18;
										end
										if (FlatIdent_85D6F == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_85D6F = 2;
										end
										if (FlatIdent_85D6F == 22) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 23;
										end
										if (FlatIdent_85D6F == 24) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_85D6F = 25;
										end
										if (FlatIdent_85D6F == 2) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 3;
										end
										if (FlatIdent_85D6F == 9) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 10;
										end
										if (16 == FlatIdent_85D6F) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 17;
										end
										if (FlatIdent_85D6F == 6) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_85D6F = 7;
										end
										if (FlatIdent_85D6F == 19) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_85D6F = 20;
										end
										if (FlatIdent_85D6F == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 4;
										end
										if (FlatIdent_85D6F == 27) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_85D6F = 28;
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
							elseif (Enum > 191) then
								local FlatIdent_5F9B = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_5F9B == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_5F9B = 8;
									end
									if (FlatIdent_5F9B == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5F9B = 3;
									end
									if (FlatIdent_5F9B == 0) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_5F9B = 1;
									end
									if (FlatIdent_5F9B == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5F9B = 5;
									end
									if (FlatIdent_5F9B == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5F9B = 4;
									end
									if (FlatIdent_5F9B == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5F9B = 2;
									end
									if (FlatIdent_5F9B == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5F9B = 6;
									end
									if (FlatIdent_5F9B == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_5F9B = 7;
									end
									if (FlatIdent_5F9B == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
								end
							else
								local FlatIdent_44C3A = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_44C3A == 3) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										FlatIdent_44C3A = 4;
									end
									if (FlatIdent_44C3A == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										FlatIdent_44C3A = 5;
									end
									if (0 == FlatIdent_44C3A) then
										B = nil;
										T = nil;
										A = nil;
										Stk[Inst[2]] = {};
										FlatIdent_44C3A = 1;
									end
									if (FlatIdent_44C3A == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_44C3A = 3;
									end
									if (FlatIdent_44C3A == 6) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (1 == FlatIdent_44C3A) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										FlatIdent_44C3A = 2;
									end
									if (FlatIdent_44C3A == 5) then
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_44C3A = 6;
									end
								end
							end
						elseif (Enum <= 206) then
							if (Enum <= 199) then
								if (Enum <= 195) then
									if (Enum <= 193) then
										local FlatIdent_4EF99 = 0;
										while true do
											if (FlatIdent_4EF99 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_4EF99 = 2;
											end
											if (FlatIdent_4EF99 == 6) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												break;
											end
											if (FlatIdent_4EF99 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_4EF99 = 3;
											end
											if (FlatIdent_4EF99 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_4EF99 = 4;
											end
											if (FlatIdent_4EF99 == 0) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_4EF99 = 1;
											end
											if (4 == FlatIdent_4EF99) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_4EF99 = 5;
											end
											if (FlatIdent_4EF99 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_4EF99 = 6;
											end
										end
									elseif (Enum > 194) then
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
										local FlatIdent_2F127 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_2F127 == 6) then
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_2F127 == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												T = Stk[A];
												B = Inst[3];
												FlatIdent_2F127 = 6;
											end
											if (FlatIdent_2F127 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												FlatIdent_2F127 = 5;
											end
											if (FlatIdent_2F127 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2F127 = 3;
											end
											if (FlatIdent_2F127 == 3) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_2F127 = 4;
											end
											if (FlatIdent_2F127 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]] = {};
												FlatIdent_2F127 = 1;
											end
											if (FlatIdent_2F127 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_2F127 = 2;
											end
										end
									end
								elseif (Enum <= 197) then
									if (Enum == 196) then
										local FlatIdent_466E4 = 0;
										local A;
										while true do
											if (FlatIdent_466E4 == 19) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 20;
											end
											if (FlatIdent_466E4 == 24) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_466E4 = 25;
											end
											if (FlatIdent_466E4 == 10) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_466E4 = 11;
											end
											if (FlatIdent_466E4 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_466E4 = 9;
											end
											if (FlatIdent_466E4 == 11) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 12;
											end
											if (FlatIdent_466E4 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_466E4 = 2;
											end
											if (FlatIdent_466E4 == 18) then
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_466E4 = 19;
											end
											if (FlatIdent_466E4 == 17) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 18;
											end
											if (FlatIdent_466E4 == 3) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_466E4 = 4;
											end
											if (FlatIdent_466E4 == 0) then
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 1;
											end
											if (FlatIdent_466E4 == 26) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_466E4 = 27;
											end
											if (12 == FlatIdent_466E4) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_466E4 = 13;
											end
											if (FlatIdent_466E4 == 28) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_466E4 = 29;
											end
											if (FlatIdent_466E4 == 30) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 31;
											end
											if (FlatIdent_466E4 == 16) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_466E4 = 17;
											end
											if (FlatIdent_466E4 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 3;
											end
											if (9 == FlatIdent_466E4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_466E4 = 10;
											end
											if (29 == FlatIdent_466E4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												FlatIdent_466E4 = 30;
											end
											if (FlatIdent_466E4 == 25) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_466E4 = 26;
											end
											if (FlatIdent_466E4 == 5) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_466E4 = 6;
											end
											if (FlatIdent_466E4 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_466E4 = 8;
											end
											if (FlatIdent_466E4 == 27) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_466E4 = 28;
											end
											if (FlatIdent_466E4 == 22) then
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_466E4 = 23;
											end
											if (FlatIdent_466E4 == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_466E4 = 7;
											end
											if (13 == FlatIdent_466E4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 14;
											end
											if (FlatIdent_466E4 == 21) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 22;
											end
											if (FlatIdent_466E4 == 23) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_466E4 = 24;
											end
											if (20 == FlatIdent_466E4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_466E4 = 21;
											end
											if (4 == FlatIdent_466E4) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_466E4 = 5;
											end
											if (FlatIdent_466E4 == 14) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												FlatIdent_466E4 = 15;
											end
											if (FlatIdent_466E4 == 15) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_466E4 = 16;
											end
											if (FlatIdent_466E4 == 31) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
												break;
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
								elseif (Enum > 198) then
									local FlatIdent_5851D = 0;
									local A;
									while true do
										if (FlatIdent_5851D == 0) then
											A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
											end
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
							elseif (Enum <= 202) then
								if (Enum <= 200) then
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
								elseif (Enum == 201) then
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
									local FlatIdent_19995 = 0;
									local A;
									while true do
										if (0 == FlatIdent_19995) then
											A = Inst[2];
											do
												return Stk[A](Unpack(Stk, A + 1, Inst[3]));
											end
											break;
										end
									end
								end
							elseif (Enum <= 204) then
								if (Enum > 203) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							elseif (Enum > 205) then
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
								local FlatIdent_15046 = 0;
								local B;
								local T;
								local A;
								while true do
									if (FlatIdent_15046 == 7) then
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										FlatIdent_15046 = 8;
									end
									if (FlatIdent_15046 == 1) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_15046 = 2;
									end
									if (FlatIdent_15046 == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_15046 = 4;
									end
									if (0 == FlatIdent_15046) then
										B = nil;
										T = nil;
										A = nil;
										FlatIdent_15046 = 1;
									end
									if (FlatIdent_15046 == 5) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_15046 = 6;
									end
									if (FlatIdent_15046 == 6) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_15046 = 7;
									end
									if (FlatIdent_15046 == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_15046 = 3;
									end
									if (FlatIdent_15046 == 8) then
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_15046 == 4) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_15046 = 5;
									end
								end
							end
						elseif (Enum <= 213) then
							if (Enum <= 209) then
								if (Enum <= 207) then
									local FlatIdent_4B4A4 = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_4B4A4 == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4B4A4 = 4;
										end
										if (FlatIdent_4B4A4 == 7) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_4B4A4 == 6) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_4B4A4 = 7;
										end
										if (1 == FlatIdent_4B4A4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4B4A4 = 2;
										end
										if (FlatIdent_4B4A4 == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_4B4A4 = 1;
										end
										if (FlatIdent_4B4A4 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4B4A4 = 5;
										end
										if (FlatIdent_4B4A4 == 5) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4B4A4 = 6;
										end
										if (FlatIdent_4B4A4 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_4B4A4 = 3;
										end
									end
								elseif (Enum > 208) then
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
							elseif (Enum <= 211) then
								if (Enum == 210) then
									local FlatIdent_5728 = 0;
									while true do
										if (FlatIdent_5728 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_5728 = 5;
										end
										if (FlatIdent_5728 == 0) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_5728 = 1;
										end
										if (FlatIdent_5728 == 3) then
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											FlatIdent_5728 = 4;
										end
										if (FlatIdent_5728 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											FlatIdent_5728 = 2;
										end
										if (FlatIdent_5728 == 6) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_5728 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5728 = 3;
										end
										if (FlatIdent_5728 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5728 = 6;
										end
									end
								else
									local FlatIdent_1606B = 0;
									local B;
									local T;
									local A;
									while true do
										if (FlatIdent_1606B == 1) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1606B = 2;
										end
										if (FlatIdent_1606B == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1606B = 5;
										end
										if (FlatIdent_1606B == 3) then
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1606B = 4;
										end
										if (FlatIdent_1606B == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1606B = 3;
										end
										if (6 == FlatIdent_1606B) then
											A = Inst[2];
											T = Stk[A];
											B = Inst[3];
											FlatIdent_1606B = 7;
										end
										if (FlatIdent_1606B == 5) then
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1606B = 6;
										end
										if (FlatIdent_1606B == 7) then
											for Idx = 1, B do
												T[Idx] = Stk[A + Idx];
											end
											break;
										end
										if (FlatIdent_1606B == 0) then
											B = nil;
											T = nil;
											A = nil;
											FlatIdent_1606B = 1;
										end
									end
								end
							elseif (Enum == 212) then
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								local FlatIdent_6C44A = 0;
								while true do
									if (FlatIdent_6C44A == 5) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 6;
									end
									if (FlatIdent_6C44A == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 3;
									end
									if (FlatIdent_6C44A == 9) then
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_6C44A == 8) then
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 9;
									end
									if (FlatIdent_6C44A == 1) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 2;
									end
									if (3 == FlatIdent_6C44A) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 4;
									end
									if (FlatIdent_6C44A == 7) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 8;
									end
									if (FlatIdent_6C44A == 4) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 5;
									end
									if (FlatIdent_6C44A == 0) then
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 1;
									end
									if (FlatIdent_6C44A == 6) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_6C44A = 7;
									end
								end
							elseif (Enum == 215) then
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
								local FlatIdent_1E6D = 0;
								local A;
								while true do
									if (23 == FlatIdent_1E6D) then
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
										FlatIdent_1E6D = 24;
									end
									if (FlatIdent_1E6D == 4) then
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
										FlatIdent_1E6D = 5;
									end
									if (FlatIdent_1E6D == 14) then
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
										FlatIdent_1E6D = 15;
									end
									if (FlatIdent_1E6D == 1) then
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
										FlatIdent_1E6D = 2;
									end
									if (FlatIdent_1E6D == 20) then
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
										FlatIdent_1E6D = 21;
									end
									if (FlatIdent_1E6D == 5) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_1E6D = 6;
									end
									if (FlatIdent_1E6D == 9) then
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
										FlatIdent_1E6D = 10;
									end
									if (FlatIdent_1E6D == 8) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1E6D = 9;
									end
									if (FlatIdent_1E6D == 2) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1E6D = 3;
									end
									if (19 == FlatIdent_1E6D) then
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
										FlatIdent_1E6D = 20;
									end
									if (FlatIdent_1E6D == 0) then
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
										FlatIdent_1E6D = 1;
									end
									if (11 == FlatIdent_1E6D) then
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
										FlatIdent_1E6D = 12;
									end
									if (FlatIdent_1E6D == 25) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										break;
									end
									if (FlatIdent_1E6D == 3) then
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
										FlatIdent_1E6D = 4;
									end
									if (FlatIdent_1E6D == 16) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1E6D = 17;
									end
									if (FlatIdent_1E6D == 12) then
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
										FlatIdent_1E6D = 13;
									end
									if (FlatIdent_1E6D == 6) then
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
										FlatIdent_1E6D = 7;
									end
									if (FlatIdent_1E6D == 10) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1E6D = 11;
									end
									if (FlatIdent_1E6D == 21) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_1E6D = 22;
									end
									if (24 == FlatIdent_1E6D) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1E6D = 25;
									end
									if (FlatIdent_1E6D == 7) then
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
										FlatIdent_1E6D = 8;
									end
									if (FlatIdent_1E6D == 17) then
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
										FlatIdent_1E6D = 18;
									end
									if (FlatIdent_1E6D == 22) then
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
										FlatIdent_1E6D = 23;
									end
									if (FlatIdent_1E6D == 15) then
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
										FlatIdent_1E6D = 16;
									end
									if (FlatIdent_1E6D == 13) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										FlatIdent_1E6D = 14;
									end
									if (FlatIdent_1E6D == 18) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_1E6D = 19;
									end
								end
							end
						elseif (Enum <= 218) then
							if (Enum > 217) then
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
						elseif (Enum > 219) then
							local FlatIdent_358C1 = 0;
							local A;
							local Step;
							local Index;
							while true do
								if (FlatIdent_358C1 == 0) then
									A = Inst[2];
									Step = Stk[A + 2];
									FlatIdent_358C1 = 1;
								end
								if (FlatIdent_358C1 == 1) then
									Index = Stk[A] + Step;
									Stk[A] = Index;
									FlatIdent_358C1 = 2;
								end
								if (FlatIdent_358C1 == 2) then
									if (Step > 0) then
										if (Index <= Stk[A + 1]) then
											local FlatIdent_121C8 = 0;
											while true do
												if (FlatIdent_121C8 == 0) then
													VIP = Inst[3];
													Stk[A + 3] = Index;
													break;
												end
											end
										end
									elseif (Index >= Stk[A + 1]) then
										local FlatIdent_8F7C2 = 0;
										while true do
											if (FlatIdent_8F7C2 == 0) then
												VIP = Inst[3];
												Stk[A + 3] = Index;
												break;
											end
										end
									end
									break;
								end
							end
						else
							Stk[Inst[2]] = #Stk[Inst[3]];
						end
						VIP = VIP + 1;
						break;
					end
					if (FlatIdent_23853 == 0) then
						Inst = Instr[VIP];
						Enum = Inst[1];
						FlatIdent_23853 = 1;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!C8052Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E73657274025Q00C0814003043Q0076EFC63D03073Q0047248EA85673B0025Q00B8814003243Q0069BF12FD6A3FB216E2623FE413E26A68E340E2633BB515E26369B043F93D6FE310F66D6A03053Q005B598626CF025Q00B0814003043Q0012BECC8B03053Q00174ADBA2E4025Q00A8814003803Q00D76A75E4D76975E7D76B75E5D26B70E4D76B75E1D76A75E2D76E75E6D76875E4D76E75E0D76770E6D76A75E1D76875E6D76B75E3D76F70E7D76975E6D26C75E6D76D75E2D26E75E6D76B75E6D76975EDD76F70E6D76C70E3D76670E6D76875E2D76775EDD76C75E2D26D70E7D76970E6D26C75ECD76675E6D76F75E7D76B75E703043Q00D5E45F46025Q00A0814003063Q00C845E47BD83F03063Q005E9B2A881AAA025Q0098814003093Q00E3454AD1D34940C0D503043Q00B2A63D2F025Q0090814003133Q00E5EABD637A03F7ACE9B461780AF4A3ECBC647903073Q00C195DE85504C3A025Q0080814003043Q00BAB13FB703043Q00DCE8D051025Q0078814003403Q007B57AF707E50AE2E7854F92D7B06A5702909F92E2A53A52A2D09FC792C55F87F7E04A5297701A5787D00FC7E7C01FB2E7D02FC2Q2904AD2C7A57A47B2C52AD2C03043Q00484F319D025Q007081402Q033Q00259C8203073Q00BD64CBD25C3869025Q0068814003093Q00DE33BD1448EF24AA0403053Q003D9B4BD877025Q0060814003133Q00F3615EBB9DE469B1615DB39CE56FB56E54BC9803073Q005B83566C8BAED3025Q0050814003043Q00D5BC2A4503053Q006E87DD442E025Q0048814003403Q00598F8D7E42FF77092QDC2E15F9770D8F8C2E41FA7559DB807140FE70092Q8D7A10A9205E8B8D2C11AF705E8A812A46A92253D8DA7F47A8205C8F897847A9220E03073Q00166BBAB84824CC025Q004081402Q033Q001E1C4A03083Q00E05F4B1A96A9B5B4025Q0038814003093Q009D3E0C0935C6B7341A03063Q00B2D846696A40025Q0030814003133Q00EA14F25D4B2220BEAE1BF858482C21B7AD10F603083Q00869A23C06F7F1519025Q0020814003043Q009922A4AC03073Q0098CB43CAC7EDC7025Q0018814003403Q00FFB058A77CAA4A0AABB853F429FC4E0AFCB903F029A91E5CFABC06F279A11A0FABE905F62EA84E01FCB159A52DFF1958F9ED56FE2EFA1800AFBD50A779A94F0903083Q0039CA8860C64F992B025Q0010814003023Q006ED103043Q006C208957025Q0008814003093Q0050E08946AEB8D367EB03073Q00BC1598EC25DBCC026Q00814003133Q00E3D5B82F511BA5D6B22F541EA5D0B3265711A703063Q002893E7811760025Q00F0804003043Q0035A414D203073Q00B667C57AB94FD1025Q00E8804003803Q000DB2AE29B3B50DB2AB2EB6B20DBDAB2BB3B60DBCAE2FB3B40DBDAE2CB3B10DB0AE2FB3B40DB4AE28B3B508B1AE2DB3B40DB5AE2DB6B408B1AE2BB6B308B6AE2FB3B60DB5AB2BB6B70DB5AB2EB6B00DB1AE2AB6B308B1AE2DB6B70DB4AE2CB6B70DBCAE28B3B708B7AE2EB6B508B1AE29B6B70DB3AB2EB3B00DB0AB2CB6B00DB303063Q00863E859D1880025Q00E0804003063Q00B775CE0C967B03043Q006DE41AA2025Q00D8804003093Q0061EFE7CD17F94BE5F103063Q008D249782AE62025Q00D0804003133Q0028EA5A5F6AE8545C61EE2Q506DEA5B5C69EE5103043Q006858DF62025Q00C0804003043Q00304B53D103083Q008E622A3DBA776762025Q00B8804003803Q0072B0F7601C73B7F2631277B7F7661976B2F5631D77B2F7641C70B2F7631A72B3F2621C77B7F7661C72B0F7661C72B2F3661877B3F7631973B2F5631977B0F7631C77B2F4631372B6F7631C74B7F1661B72B0F2651979B2F5631977B7F7601976B7F2631A72B9F2651977B2F7631C77B0F7681978B7F5661872B2F7671974B2FC03053Q002A4181C450025Q00B0804003063Q0031A58AD33ADA03063Q00BB62CAE6B248025Q00A8804003093Q00A341F084692E8EDE9503083Q00ACE63995E71C5AE1025Q00A0804003143Q00488EB895F6B160A20B88B896FABC60AA018AB99403083Q009A38BF8AA0CE8956025Q0090804003043Q00C05B363D03043Q0056923A58025Q0088804003403Q00E3111D87C8A3B9FDE1124CD4C8A8BCADE61218869CA9B9A8E04348D39BF0EDAFE5104A86CCF4ECFBB5171980CDF4B9FBE7454C87CDF2EDF9E5194C879AA7EEA803083Q009FD0217BB7A9918F025Q002Q80402Q033Q0089B41803073Q0011C8E348E21418025Q0078804003093Q00D2F0DCACE2FCD6BDE403043Q00CF9788B9025Q0070804003133Q000BFEF58D10F1F3614FF8F38C15F1F7604AFDF303083Q00567BC9C4B426C4C2025Q0060804003043Q00C4A37FF903073Q00D596C21192D67F025Q0058804003243Q00984F94FE09EE73B58D1492A80AA576B4C5108EA20EB87FA8984695FE0EEE71E0964F95A803083Q0085A076A39B388847025Q0050804003043Q0048FB0C1903053Q0024109E6276025Q0048804003093Q00171DF4FDEB260AE3ED03053Q009E5265919E025Q0040804003143Q00E54B9CA8F45B6E8CA34F99A1F05C698DA44D9FA103083Q00BE957AAC90C76B59025Q0030804003043Q0094FDD73003073Q007FC69CB95B6350025Q0028804003243Q00818C4A0C16DDD34817162QD710171ED5D04C171686821E2Q17D4834C0C49D2D01F0319D703053Q002FE4B5293A025Q0020804003043Q00B2E6B83A03053Q007EEA83D655025Q0018804003093Q009105278950970EA60E03073Q0061D47D42EA25E3025Q0010804003143Q005E4A5BBDFD689B164C5BBDFB6294184E58BFF96103073Q00AD2E7B688FCE51026Q00804003043Q0072E5E8C603043Q00AD208486025Q00F07F4003243Q008A5B95E42B4E2QE5915ECAE87856B6B0D95981E97C1AE2AC840F9AB4791DB1E48A069AE203083Q0081BC3FACD14F7B87025Q00E07F4003043Q00B579E32403043Q004BED1C8D025Q00D07F4003093Q00E837B77E65F1C23DA103063Q0085AD4FD21D10025Q00C07F4003133Q00E85D910C94A158950491AE59910A9BAA5F940903053Q00A29868A53D025Q00A07F4003043Q00E8A77B4903043Q0022BAC615025Q00907F4003603Q0029FE4C157DA81B1C21A84A462DA91C412BAF4E132EFE1B1D29A64B177AAA49477DFB1E467DA8481720A84B477AF91E1C2CFC1C162CAE4D147EAB4E1D7BA74B472AAE484020A64A117CAE1C162EFA1E102EAC4C117BAF4A1079FC494020A6184003043Q0025189F7D025Q00807F4003043Q006AB6E5D803063Q007E3DD793BD27025Q00707F4003803Q00B3814E0824D660B1854E0623D166B3804E0324D160B08049032BD161B3814B0124D465B5804D032AD162B3844E0124D265B680450321D466B3834E0824D665B3804E032AD462B3824B0621DE65B4804A0321D162B3814E0524D660B4854C0624D466B6804E0721DE60B98049032AD462B3834E0121D660B4804B0626D46AB38B03073Q005380B37D3012E7025Q00607F4003063Q00DCCD5148E2EE03053Q00908FA23D29025Q00507F4003093Q00E3BB1E8ADAD2AC099A03053Q00AFA6C37BE9025Q00407F4003143Q00E05D2320128BA55427201582A95822201187A75503063Q00B3906C121625025Q00207F4003043Q0094B759D803043Q00B3C6D637025Q00107F4003603Q00882B8DA1D729DDA4837189A7D478DDA383788FA2847EDDA6852CDDF2877DDFF1852ADDA68278D9ACD22984A1862ED8A7827BD8F5822DDDA28771DAF6D47E89A4D47D8BA7862D8AA7817D89A2832C8DF1D47F8AA7D37B8DA7D02DDFF081718CA703043Q0094B148BC026Q007F4003043Q00604FFECE03063Q001F372E88AB34025Q00F07E4003093Q00E037FDAAED6904D73C03073Q006BA54F98C9981D025Q00E07E4003133Q00DB877851A7928A7F57A39C8D7E52AE9B8D7D5503053Q0097ABBE4D65025Q00C07E4003043Q006ADF1F7103073Q00AD38BE711A71A2025Q00B07E4003243Q00D65F097FD25C0C2ACF080B79D0460B7A870F1772D75F5B66DA5B0C2ED40D0C2ED4520C7803043Q004BE26B3A025Q00A07E4003043Q00EAB6CE4903073Q0099B2D3A0265441025Q00907E4003403Q0096FBFF057721C3A0AC037227C4FBAB00722296ABA8007629C32QAE002528C4A8AE57227494FCAD042Q26C3FCAB557674C0A0AA057C28C3FBAF0F777594AEFA5503063Q0010A62Q993644025Q00807E4003083Q00F6C68BBEB8C4D18203053Q00CFA5A3E7D7025Q00707E4003093Q00DB6A00DCEB660ACDED03043Q00BF9E1265025Q00607E4003133Q00CB12F1F98C1CF5F48E1CF3FA831EF9F58212F103043Q00CDBB2BC1025Q00407E4003043Q003E3CB72F03053Q00216C5DD944025Q00307E4003243Q007CAC4F5A1626162EB94B5217265E28A51D055926427AA2555B4471162FF24E06427E452A03073Q0073199478637447025Q00207E4003043Q0025AC84A403063Q00197DC9EACB43025Q00107E4003093Q00D8F9535B10E9EE444B03053Q00659D813638026Q007E4003143Q00EA7F661D1F6AE662AA7664151060E761A878641C03083Q00549A4E54242759D7025Q00E07D4003043Q001C8AED0D03043Q00664EEB83025Q00D07D4003803Q002EFB15F12EFB15F12EF910F22BF810F62BF410F52BFD10F62BF415F62EFE10F52EFE10F32BFA15F52BF815F72EF910FC2BF810FD2BFD10F72BFC15F52EF915F72BFF15F62BF510FC2BFE15F72BFE15F62BFB15F52BF910F22EF810F72BFA10F32EF915F62BFE10F72BFC10FC2BFE15F12EFF10FC2EFF15F62BFB10FD2BFA10F503043Q00C418CD23025Q00C07D4003063Q0034C77909AA0603053Q00D867A81568025Q00B07D4003093Q00FDF0F94E54A5D7FAEF03063Q00D1B8889C2D21025Q00A07D4003143Q001BB171BF7E92692A5FB472B57392682B58B970B103083Q001F6B8043874AA55F025Q00807D4003043Q0016BAC0BE03043Q00D544DBAE025Q00707D4003243Q00892906BEE7852F06A3E9842204A3EE817E51A3BED42804A3E7802D52B8B9867E01B7E98303053Q00DFB01B378E025Q00607D4003043Q00895672DA03063Q005AD1331CB519025Q00507D4003093Q0097C0DF760D29C02BA103083Q0059D2B8BA15785DAF025Q00407D4003143Q00E01E0BD0A41C02D2A51C0AD3A31909D3A1170AD603043Q00E7902F3A025Q00207D4003043Q00172BA24A03073Q00C5454ACC212F1F025Q00107D4003603Q00B7BD1E4BF9B1B41019FABDBE1F4BA2B3B4151CFDE1BA454CFFE1E84219FEB1BE1319AFB6EF1248F8E1EB4448AFE3BC441EFAB3B9131FF9B5EF171FADB3EB1E1CFAE3E9474FACBDEF1649FFB7B91743A3BDBE4542A8B6B4124DAEBDBE154DFDB303053Q009B858D267A026Q007D4003043Q00C01BB2C303083Q002E977AC4A6749CA9025Q00F07C4003403Q004D1ADCA6E6491889F5E4181B82F5B11B1F8AF0B41D4782A1B44E1D8DF7B2194CDCF1B54D1F82F6E4181A82F3B54D1DDFA6E11F1DD9F6B11949DCF6E34F49DCA203053Q00D02C7EBAC0025Q00E07C4003053Q005C1F385ECF03063Q005712765031A1025Q00D07C4003243Q0054EBFDCC4206EBAF851954BBAF851001EFFC851800E9AB851900BCFD9E4706EFAE91172Q03053Q0021308A98A8025Q00C07C4003043Q00647527E903083Q00583C104986C5757C025Q00B07C40034A3Q008DEA050C41B77C47DCED520941FC64408FB703095DE762128CBB072Q13B3324589B94B5D46E130428CA2565C11E7371294EE555A15E9635B8DB7000842B37C138EBA020D16FC60148BB903083Q0076B98F663E70D151025Q00A07C4003053Q00B45BBF03FF03053Q008BE72CD665025Q00907C4003403Q00B67AB57B87B17FE42CDCED7EE47B80B42FB12FD4E77CE42BD7B12DE12AD3E27DE27ED0E67AE62CD4E42DE47C80E57DB02885E477E37CD7E62AE67C87E32FE37C03053Q00E4D54ED41D025Q00807C4003023Q00CB9E03063Q008C85C6DAA7E8025Q00707C4003093Q00DE06DCE12336C2E90D03073Q00AD9B7EB9825642025Q00607C4003133Q00EE60A4E0B6EFA66EAEE4BCE8AD63A2E6BDECAF03063Q00DA9E5796D784025Q00407C4003043Q00638DA67803043Q001331ECC8025Q00307C4003243Q00D1B6EA8B06A2DDB3A28F07F481AEBE8806A0C8BBBD8900EBDDB3B9DC55A0D3E6B98055F503063Q00C6E5838FB963025Q00207C4003043Q00B54D8AE603063Q00D6ED28E48910025Q00107C4003093Q00AE36B0232E16E0993D03073Q008FEB4ED5405B62026Q007C4003143Q00988A8FFAF140F17ADD8E8AF9F74FF572DC838AFB03083Q0043E8BBBDCCC176C6025Q00E07B4003043Q00F3F48B1E03073Q00B2A195E57584DE025Q00D07B4003603Q003C477CAEDE663E467FACDE666F1477AB8E6838437BACD96B3E162FFC8D6C6F432FAB8B6B6F1378AE8A6D68487DFD8E3938437CAF8F3A3B127EA08C663C4479ACD86B39477CFE893E6B4128A88B6B691178FC896F6C137DA18F6C6D157EAFD93B03063Q005F5D704E98BC025Q00C07B4003043Q00F00F431B03043Q007EA76E35025Q00B07B4003243Q004BBD10E53E40E940FD6C1CEE47FD6B48ED44FD634BBB11FD6249BE47E63C4FED14E96C4A03053Q005A798822D0025Q00A07B4003043Q00CDFD292D03053Q002395984742025Q00907B4003403Q004164DE5812358C0A4037DC0A4F63880A1432DC0B1567DE58476B8A0D41608C5E4F61DF514035DC5A1665885E1665DE5F4261D15112638F5B1160DE0A4435D05C03043Q00687753E9025Q00807B4003053Q0003A374A7D903053Q00B74DCA1CC8025Q00707B4003093Q00ED414079F06FC74B5603063Q001BA839251A85025Q00607B4003143Q004F79FE560F0C7AFE51020C7EF657020779F8540603053Q00363F48CE64025Q00407B4003043Q002CC0AEEF03063Q00127EA1C084DD025Q00307B4003243Q0028BEE168084D1029ABB23D0216592BB7E03B1D4D112CBFA8600019112CE0B33D0616422903073Q00741A868558302F025Q00207B4003043Q00EFEDAC2303043Q004CB788C2025Q00107B4003093Q00A8001F4E980C155F9E03043Q002DED787A026Q007B4003133Q00338C227A84A17A8C277A86A670812D7F81AE7003063Q009643B41449B1025Q00E07A4003043Q00CFCAA3E903063Q00949DABCD82C9025Q00D07A4003243Q0074ABA2E82927FCA1A72C72FBF8A72821AFA4A77B27AEF4A72120FCA5BC7F26AFF6B32F2303053Q001910CAC08A025Q00C07A4003043Q007B4E153A03073Q00CF232B7B556B3C025Q00B07A4003093Q0004C5BF711A35D2A86103053Q006F41BDDA12025Q00A07A4003133Q004DB51CD90AB91DDC05BE12D909BD17D908BC1203043Q00EA3D8C24025Q00807A4003043Q0078DB18D903073Q00DE2ABA76B2B761025Q00707A4003243Q00BD762A552BD4AB2AA1752B5E2DC0A87DE925655F2F8FA861B4717E032D8BAF29BA787E5503083Q004C8C4148661BED99025Q00607A4003043Q003BD52CA903053Q00E863B042C6025Q00507A4003093Q00053AE8A6EC9CE1FB3303083Q008940428DC599E88E025Q00407A4003133Q00334C882Q787314704A88787B7119734B877D7803073Q002D4378BE4A4843025Q00207A4003043Q00C28AA41C03063Q00D590EBCA77CC025Q00107A4003243Q004BDD2B351ADD2E62568A293049C128651E8F346D49D9787943DC2F314D8A2F314DD52F6703043Q00547BEC19026Q007A4003043Q00C40C517403053Q00889C693F1B025Q00F0794003803Q00F1E29A8FF4E29F8FF1E19F8DF1E29A8EF4E39F8FF1E29A8CF4E69F8AF1E59F88F4E09F88F4E79A8EF1E39A8EF1E59A8DF4E59A88F1E59A8EF4E79A85F1E49F8FF4EE9A8EF4E39F8DF1E39A8DF1E29A8FF4E49F8EF4E19A85F4E29A85F4EE9A8BF4EE9F8FF1E59A8EF1E49A85F1E19A8AF4EE9F88F1E49F8AF4EF9A8BF4E59F8D03043Q00BCC7D7A9025Q00E0794003063Q001DF38617D32F03053Q00A14E9CEA76025Q00D0794003093Q00A536BA48C2FFD2923D03073Q00BDE04EDF2BB78B025Q00C0794003133Q002CA9B7968CF46B6CA6BB9585F66B6CABB7918403073Q00585C9F83A4BCC3025Q00A0794003043Q0088E314ED03053Q0085DA827A86025Q0090794003803Q0088DA296A74738DDA2C6F71768DDA296D71728DDA2C6D717688DD2C6A717688D92C6971738DDF2C6D717E8DD8296B71778DDE2C6771728DD8296B717088DA296D747088DD2C6D71758DDB2C6871768DDC2C6E74728DD82C6A71708DDD296D74728DDC2C66717E8DDA2C6B71758DDF296B717288DA2C6D71748DDB2C6E2Q7188DF03063Q0046BEEB1F5F42025Q0080794003063Q008EE433A1DBBC03053Q00A9DD8B5FC0025Q0070794003093Q00C3E78FA0C4F2F098B003053Q00B1869FEAC3025Q0060794003143Q00FDF4D42B40E20765BEFCD32B41E50368BAF4D42D03083Q005C8DC5E71B70D333025Q0040794003043Q00B1F1A48003063Q00D6E390CAEBBD025Q0030794003243Q00F5A61D90F1A61890E8A5499CF0BD1995A0F6059CA7F54A89FDA01EC1F3F61EC1F3A91E9703043Q00A4C59028025Q0020794003043Q002F19C15103073Q00DA777CAF3EA8B9025Q0010794003093Q003F053B1B20E52B080E03073Q00447A7D5E785591026Q00794003133Q0005F5AE4F6D4DFAAF486846F7AB4E634CF7A94103053Q005B75C29F78025Q00E0784003043Q0028265C0703083Q008E7A47326C4D8D7B025Q00D0784003243Q004EABA34721244BFDEF1A287712B3F313742707FFA417706C12AEF4472Q271CFBF41B277203063Q00412A9EC22211025Q00C0784003043Q00FF71F4F703053Q002AA7149A98025Q00B0784003803Q00DE1DBC1EDB1DBC1BDE1ABC1DDE11BC1CDE1CBC1ADE10BC19DE11B91EDE1AB911DB1CBC1ADE11B91ADE19BC1BDB1CB91EDB1ABC1DDB1AB91DDB1CBC19DE19B919DB18B910DE19BC1CDB1FB911DE11B919DE1DB910DE1BB91EDB1FB91BDB1BB91EDE10B919DB1AB910DE18BC1BDE1DBC19DB18BC1BDB1BBC1EDE1EB918DE10BC1D03043Q0028ED298A025Q00A0784003063Q00E5A9EBC66BB603063Q00D7B6C687A719025Q0090784003093Q000117A744311BAD553703043Q0027446FC2025Q0080784003133Q00DC69EAA5946BEDA3996BEFA49F6DEDA89D6DEE03043Q0090AC5EDF025Q0060784003043Q0063A90AF803073Q003831C864937C77025Q0050784003803Q00DE68AB770BB5DE63AB720EB3DE60AB700BB4DE60AE700BB3DB65AE760EB1DE60AB720EB2DB62AB730EB1DB66AB760BB4DE61AE760EB9DE64AE760EB6DB63AB750EB7DB66AE710EB4DE61AB7D0EB9DB61AB700EB8DE68AE700BB2DE68AB720EB2DB64AE760EB3DE66AB7D0EB4DE66AB730EB4DE65AE770EB3DE61AE700BB3DE6703063Q0081ED5098443D025Q0040784003063Q00D423A459347703063Q0016874CC83846025Q0030784003093Q000DB9C17F0B373E303B03083Q004248C1A41C7E4351025Q0020784003133Q002867B7ADB8B386E06E67B7AABABE85E86069B703083Q00D1585E839A898AB3026Q00784003043Q006933A24B03053Q009D3B52CC20025Q00F0774003803Q00EEEC4F692QEB4A6DEBE84A68EBED4F6BEEEB4A6FEBEA4A68EEEB4F69EBE94A69EEE94F64EEEA4F69EBEE4F6BEEE94F64EBE04F6DEEEB4F69EBE84A6EEBE04F6EEBE14F68EBEA4F69EBEE4A6F2QEE4F642QEB4F6CEEEC4A6DEEEA4F6EEBEA4F65EBE14F68EBEC4A68EEEB4F6EEBE14F6FEEEB4A6DEEE94F69EBED4F6DEBEE4F6803043Q005C2QD87C025Q00E0774003063Q007E1E20EE5F1003043Q008F2D714C025Q00D0774003093Q00E9D5877253D8C2906203053Q0026ACADE211025Q00C0774003143Q00E376434E4A4EA77E40484342A27F462Q4B49A57F03063Q007B9347707F7A025Q00A0774003043Q00F6CC493703073Q0095A4AD275C926E025Q0090774003403Q002C888F0A536A822ADB800C516AD42B8B8A04526286258CDE09526180282QD95B516A807D88DD0C5561807AD88E0B016A867A8ADC0C0361D17A8D8B0E05658B2E03073Q00B21CBAB83D3753025Q008077402Q033Q0071BC0E03043Q001730EB5E025Q0070774003243Q0097DA90D48387C6D18980D2D4C5C495D084D38E8B9CD0D4989BD99284D7D3958C92D8D78603063Q00B5A3E9A42QE1025Q0060774003043Q00BDC029EE03083Q0020E5A54781C47EDF025Q0050774003093Q000B16FEF53B1AF4E43D03043Q00964E6E9B025Q0040774003133Q00AE28829657ECD749EF22889655E1D245EC238203083Q0071DE10BAA763D5E3025Q0020774003043Q00F1074DD903073Q0044A36623B2271E025Q0010774003403Q00788A08D41C2F7F880C871D287A8E5CDB1E282C8B5FD71C287EDA04861B7D7ED859864F277F8F5FD51D2871820BDA1D7B7C8A5886187A71820ED71F7C2ED9098303063Q001F48BB3DE22E026Q0077402Q033Q00E24BD703053Q0036A31C8772025Q00F0764003093Q00D22248DA3D6FB6E52903073Q00D9975A2DB9481B025Q00E0764003143Q00A3879D9099F313E18E9B9298F71CEA8E9F9590F403073Q0025D3B6ADA1A9C1025Q00C0764003043Q00887EDD7803063Q007ADA1FB3133E025Q00B0764003803Q00794F7C735250794D7C7E57557C46797E5257794B2Q7957517C4F7C7F5751794C797F5254794A7C7A57527C4D7C7F57567C4C7C7A57557C467C78525F794D7C785755794A797F52577C4B797E57547C47797F5256794F2Q7957517C4A2Q7952577C4D7C7F57527C492Q7C525E794A7C7F5255794D7C7B575579487C7D57557C4A03063Q00674F7E4F4A61025Q00A0764003063Q00B2C95DF3DB5D03063Q003CE1A63192A9025Q0090764003093Q00DA2B0C0927ECF0211A03063Q00989F53696A52025Q0080764003133Q00BAE2B5B220B914FFE5BEB323BA12FDE9BEB72203073Q0027CAD18D87178E025Q0060764003043Q00268C8B3C03063Q003974EDE55747025Q0050764003803Q00015E6D06218C71005F690C26877004556D07248071055F6F0C248772045D680C248571065A6A0927877104586D0D218374035F6D0926827101586D0B218471025F6D0927827104586D0A2480710E5F6D0C21827304596D07218671005A6C0C26877101596D0E248671035F6609278276015D6D0B248074015F670C218273015A03073Q0042376C5E3F12B4025Q0040764003063Q00B8D539E7941203083Q0066EBBA5586E67350025Q0030764003093Q003BF870C9FF9F16C40D03083Q00B67E8015AA8AEB79025Q0020764003133Q00445ED0E7F6E3DC035FDEE7FCE0D70C52D1E2F503073Q00E43466E7D6C5D0026Q00764003043Q002A42EDC103073Q002B782383AA6636025Q00F0754003803Q005116BBA55110BBA55117BBA65411BBA55111BEA75119BBA55117BEA05112BBA75117BEA75113BEA65110BBA25416BEA25116BEA35110BEA45414BEA35119BEA55116BBA65117BEA35112BBA05119BEA65115BBA25414BEA05113BEA65413BBA25415BBA25413BEAB5119BEA35110BBA55111BEAA5413BEA15411BEA45115BEA703043Q009362208D025Q00E0754003063Q0063F60ABE4D7E03083Q001A309966DF3F1F99025Q00D0754003093Q00DAF8B7BA1D2AF0F2A103063Q005E9F80D2D968025Q00C0754003133Q005C6DB0F7591F6AB0F658186EB7F7511463B1F703053Q00692C5A83CE025Q00A0754003043Q00E7CAF8A403083Q00DFB5AB96CFC3961C025Q0090754003803Q004FA959BA4AA959B04AA959B74FA359B24FA259B04FAD59B34FAB59B34AAF5CB74FA35CB34FAA5CB34FA95CB74AA859B14FA95CB74AAA59BA4AAA5CB74FAC59BA4FAC59B24FA95CB74FAC5CB34AAA59B74AA859B74FA25CB04AAE59B64AAE59B54AAD5CB04AAD5CB14AAD5CB74AAD5CB44AAE59B74FAE5CB64FA95CB34FAF5CB003043Q00827C9B6A025Q0080754003063Q007010B6A6107203063Q0013237FDAC762025Q0070754003093Q001D2A16802D261C912B03043Q00E3585273025Q0060754003133Q009A2Q49F688DB4E48FF8DD84E49F788DD474DF703053Q00BCEA7F79C6025Q0040754003043Q00C32443E403053Q00B991452D8F025Q0030754003803Q004E2D701BF84F287618FC4E2F7012F84E287018FC4B2A701BF84E287618F84B2F751FFD4D2D7B18F94E2C751FF84B2D761DFF4B2B7018F8492D751DFD4E2D701DF84D287518F94E2B701EF84C2D7B18FA4B2A7012F84B2D771DFA4E2B7019F84E2D7218F24E2A7018FD4A287518F24B2D701DF84B28761DFD4B267013FD4B287503053Q00CB781E432B025Q0020754003063Q00B058DC144F3E03063Q005FE337B0753D025Q0010754003093Q0017FB8D3E5C4E3DF19B03063Q003A5283E85D29026Q00754003133Q00E98F5DF4EC810DFCA18158F5EA850DF9A9805B03083Q00C899B76AC3DEB234025Q00E0744003043Q003F58393503063Q00986D39575E45025Q00D0744003403Q0048B6198040D9A749E3198D40DCF71DB24F8311D5A71AE24FD6178DA61EB14ED647D9A113E318D0408EFB1BB11AD447DEF21FB41D8444D4F24CB61ED414DCF31E03073Q00C32AD77CB521EC025Q00C0744003083Q00E0BC230EC4B83D0203043Q0067B3D94F025Q00B0744003803Q0083DBEFA550B38782D1EFA053B08086D0EFA650B08780D4EBA057B08D83D3EAA150B58781D4E8A556B08083DBEFA555B58783D1EFA050B08386D1EAA055B18283D1E9A056B08C86D7EFA250B48284D1E9A556B08D83D7EAA450B32Q82D1E8A557B08786D0EFA555B68785D1EAA552B08D83D2EFA150B78788D1EEA052B08683D603073Q00B4B0E2D9936383025Q00A0744003063Q0075C4FFE86EEE03063Q008F26AB93891C025Q0090744003093Q00033320BCF4322437AC03053Q0081464B45DF025Q0080744003143Q00F314E6E745E1B711E4E54AE4B112E5E64AE6B11103063Q00D583252QD67D025Q0060744003043Q008D37338803073Q0083DF565DE3D094025Q0050744003803Q00189B47BC7CFE189A47BB7CF8189747B47CFB1D9047BE7CFC189642BF7CF1189447B979FB1D9742B979F91D9042BE7CFE189742B879FB1D9642BC79F9189742BE7CFB1D9747B87CF91D9742B87CFF1D9047BC7CFF189642BE7CF1189547B979FD189247B47CFA189447B879F9189542BE79FE1D9747B879F91D9642BB7CF01D9203063Q00C82BA3748D4F025Q0040744003063Q003FFDF189630D03053Q00116C929DE8025Q0030744003093Q005D92CB40BA4632436B03083Q003118EAAE23CF325D025Q0020744003133Q000EE52Q5F49B14DE85F5C4BBB4DE253594DB04B03063Q00887ED0666878026Q00744003043Q00C3E23E2803053Q00C491835043025Q00F0734003243Q00B20025611D507EB349786F1C5137B755243C015F78E2516C611C517FB002773C1A5E2CB503073Q001A866441592C67025Q00E0734003043Q0015BEE03503043Q005A4DDB8E025Q00D0734003603Q004D2QA01A081F47F4F64D5E1411F2A74D0A4713A4A7180D404CF5A248091042A2F140534311A5F34C0E1E17A4A34E524240AFA01D0F1641A7A14F0E1F41A3A54D0D1211A0A71A5C4745F4F1185A124DA3F5410E144DF2A91A5A4741F2A64F0E1103063Q0026759690796B025Q00C0734003043Q00BAF193EA03053Q005DED90E58F025Q00B0734003093Q00761371702F4704666003053Q005A336B1413025Q00A0734003133Q00D362BF40AE67966AB947AF649462B940AE619403063Q0056A35B8D7298025Q0080734003043Q0037881E1F03073Q003F65E97074B42F025Q0070734003243Q0056ABF74AAEEDEF8142FFFE44FEA5BD800AADE34AA8BAB89C57FFF816A9EEBAD459F6F84003083Q00B16FCFCE739F888C025Q00607340030F3Q0008F5F6B6EB831E6562C7859EE2821803083Q001142BFA5C687EC77025Q0050734003243Q00D1A5B09B258DA2B98F24D8F6E88F25D9A4EB8F2DDFF3BD8F2CD8F7EC9472DEA4BF9B22DB03053Q0014E8C189A2025Q0040734003043Q0042B93C7B03083Q00EB1ADC5214E6551B025Q0030734003093Q00DBBBCC7441EAACDB6403053Q00349EC3A917025Q0020734003133Q00A566B47300D952E368BE7101D150E567BE7F0503073Q0062D55F874634E0026Q00734003043Q00E5D9493403043Q005FB7B827025Q00F0724003603Q00AE2D687CD61C5413A97F6E7CD01D5447AB7C6F798614541CAF7A3A7183155217A02C6E2D84465511FB2D672C80445646A12E6D7881130045A12D3D7B8C465A13FE2A3F2D85155247FE2A6B2D85155110AD2D677E8C440310A87B6C2CD41C514503083Q0024984F5E48B52562025Q00E0724003043Q008EB2B11A03073Q0090D9D3C77FE893025Q00D0724003093Q002591ECBD159DE6AC1303043Q00DE60E989025Q00C0724003133Q00F05B75BBA790B8547ABDAA95B65B76BCAA9CB903063Q00A4806342899F025Q00A0724003043Q0083B3002603073Q00C0D1D26E4D97BA025Q0090724003403Q00FA6D4EE2AA6A19B3FC6941B6FB6B4EE1FC3D4FBDFD6740E2F83E48E6A83E19B5FD3A1ABDAD6740E6AF6E1CE1FA684CB7AB3B4FB4A96A4CB2FF6E1EB1AD391BB203043Q0084995F78025Q008072402Q033Q00FBE89303053Q00B3BABFC3E7025Q0070724003243Q00EB8A7754E0552C76F5847256B7192977BDD93B5AEA037A6BE08D2007E4522E23EE84205103083Q0046D8BD1662D23418025Q0060724003043Q0081CBDE3003053Q002FD9AEB05F025Q0050724003803Q007EBA7D8E5E89D17CBF7D8C5D8AD77EBF78895B8CD17FBF7E895F8FD37EB87D8F5E88D17DBA798C5E8FD57BBF78895E8AD17CBA7A89598FD17BB878885B8AD17FBF7D89598AD67BBE788C5B8FD17EBA798C5E8FD17EBE788E5E8DD17CBF7F89588FD67EB478885B8BD174BA798C598FD57EB5788C5B84D178BA7E895C8AD37EB403073Q00E24D8C4BBA68BC025Q0040724003063Q00DB22A54E60BD03083Q00D8884DC92F12DCA1025Q0030724003093Q0057F0C1A01E577660FB03073Q00191288A4C36B23025Q0020724003133Q003E1E69840744AC771A67850242A8791B678C0703073Q009C4E2B5EB53171026Q00724003043Q0091A72QC103083Q00CBC3C6AFAA5D47ED025Q00F0714003403Q000A391B172Q55FB5C684A440509FC0B6B4346505FA95A3F48110259A4586B1E10570CAD59654E195C0CAC5B684C14500FAE513D1F17555CFF0A6C1C10055BA45803073Q009D685C7A20646D025Q00E071402Q033Q00F7421903083Q0076B61549C387ECCC025Q00D0714003603Q00F94054B9F11606BAF0405DBAF11B03BFF34204EBF21A51EFF91753EBA3425DE8F21503BEF34655EFF31154B9F41A51B8F01A51EFF61250BBF21554EBF54200BBA61355E8F11051ECF44752B6F64555EDF01A52B9F71251EAA1415DB8A54155EA03043Q008EC02365025Q00C0714003043Q006FC441FF03073Q009738A5379A2353025Q00B0714003803Q00BDE5ABD01188BDEAABD6118ABDECAED11180BDEDABD7148AB8ECABDA148BBDE4ABD6148DBDEBABD7118FB8E9AED7118DBDEDABD7118EB8E9AED51189BDE9ABD5118ABDE5ABD4118BBDEFABD31189BDEAABD3118BB8EEABD2148ABDECAED71180BDE5ABD1118FBDEBAED0148ABDE9ABDB118AB8EBAED0118EB8E9ABD2118CBDE403063Q00B98EDD98E322025Q00A0714003063Q008EE828A7D55D03063Q003CDD8744C6A7025Q0090714003093Q00C0A55233DA20EAAF4403063Q005485DD3750AF025Q0080714003133Q009C8B458AE905DE8C418FED09D58C4781E008DC03063Q0030ECB876B9D8025Q0060714003043Q00CE56F35E03063Q001A9C379D3533025Q0050714003803Q0078D7431E7A8B7DD443127A8878D743147A8F7DDB46177A8A7DD3431E7F8F78D746147A827DD243117F8F7DD6431E7F887DD043177A8D78D746107F887DD743107F8F7DD743137A887DD243157A8C7DD246127F8B78D746107A8B7DDB46127A8F7DD446107A827DD643177F897DD546107A8D78D646127F8F7DD043107F8878D703063Q00BA4EE3702649025Q0040714003063Q001AA33C393BAD03043Q005849CC50025Q0030714003093Q0019C5C6102028D2D10003053Q00555CBDA373025Q0020714003133Q004E98F87E9E0997F876960B90F3769C0991FB7403053Q00AF3EA1CB46026Q00714003043Q001E78EA5303043Q00384C1984025Q00F0704003803Q002Q79F21220797EF310232Q79F716257B7EF71025797FF21625787BF515277970F21125797EF4102F7970F21425727BF81021797AF210207B7EF310252Q79F710257C7EF01022797EF711257D7BF4102F797DF21425787BF81524797CF715257B7EF210237C7AF217207B7EF01020797BF21525797BF610227C7DF21725797BF103053Q00164A48C123025Q00E0704003063Q00D9BA28E2523E03063Q005F8AD5448320025Q00D0704003093Q006F408DE15F4C87F05903043Q00822A38E8025Q00C0704003143Q00A4D881786BFC61EDD880766CFE62EDDC89766DFC03073Q0055D4E9B04E5CCD025Q00A0704003043Q00B656F05103043Q003AE4379E025Q0090704003803Q0042F22QFB654442F22QFB604647F2FBFF654342F42QFB654447F72QFE654B47F2FEF7654642F1FEFC602Q42F0FBFF652Q47F5FEFF654042F52QFE602Q47F4FEFA654142FEFBF8654442F2FEF7604147F42QFE652Q47F2FBFC654A42F5FEFB654247F4FEFD654642FFFEF7654342F4FEFD654342F2FBF8604547F2FBFD604742FE03063Q007371C6CDCE56025Q0080704003063Q00C943EEFD65FB03053Q00179A2C829C025Q002Q704003093Q008832564FA3B925415F03053Q00D6CD4A332C025Q0060704003143Q00AAD728AB079A74E3D021A10D9C72E2D32CAA0B9803073Q0044DAE619933FAE025Q0040704003043Q001E5152B303073Q00424C303CD8A3CB025Q0030704003803Q0013F8F4B44311FBF3B04113F0F4B14319FBF6B54616FEF4BB4318FEF1B04413FDF1B04612FBF4B04416FBF4B34315FEF3B04516FEF4B74315FEF4B04116FCF1B74316FBF1B54313FFF4B04316FBF6B04116FCF1B54615FBF6B04516FAF4B74314FEF2B04316FBF1B54615FEF1B04016F9F4B74311FEF3B04516FEF4B04310FBF003053Q007020C8C783025Q0020704003063Q00CE2909131B2103063Q00409D46657269025Q0010704003093Q00631BEC2F46024911FA03063Q00762663894C33026Q00704003133Q00B3EAB1969554262EF2E0B3989352282EF1E7B403083Q0018C3D382A1A66310025Q00C06F4003043Q00D9C4BFEA03053Q00AE8BA5D181025Q00A06F4003803Q007A5AB05E7F58B55B7F5FB5547F50B55F7F5CB55B7A5BB05E7A58B05D7F5EB0587A5AB55F7A58B5587F5EB05F7A5CB55D7F59B05F7F5EB0597F50B5547F59B5597F50B5597A5FB05F7F5AB05E7F5FB5587A5AB5587A58B55C7F5DB0597F5BB55F7F5DB55C7A58B55E7F5BB0597F58B55D7F5FB5547A58B55D7F58B5587A58B55903043Q006C4C6986025Q00806F4003063Q00DEF101F2EAD603063Q00B78D9E6D9398025Q00606F4003093Q008AD3C4CDBADFCEDCBC03043Q00AECFABA1025Q00406F4003133Q00B95F87D768FF588AD46EFA5A87D56DFC5C8ED803053Q005FC968BEE1026Q006F4003043Q003BAC337803043Q001369CD5D025Q00E06E4003243Q000AB0A3D45EE1A4D710B7A0DE0DF8F3D658B3EFDE09E3FACA05E5F4820BB3F4820BECF4D403043Q00E73DD5C2025Q00C06E4003043Q003382AA4B03043Q00246BE7C4025Q00A06E4003803Q005B0F5F0B5B085A0B5B015A0B5E0D5A0C5E0D5A075E0B5F0D5B095F0A5B0C5A0B5B095F0A5E0D5F0D5B005A075B095A0B5B005A095B0F5F0B5B0E5A065B0B5A0E5B005F095E0B5A085B0C5F0D5B005A075B085F0E5E085A0E5B005A0A5E0F5A065B0E5A085B015A0A5B0B5F0B5B015A095E0B5A0E5E085A065B0E5F0A5B0B5A0E03043Q003F683969025Q00806E4003063Q000682775EC0AE03083Q00B855ED1B3FB2CFD4025Q00606E4003093Q0081F848B0F114ABF25E03063Q0060C4802DD384025Q00406E4003143Q00E94597A9D9F5A762AF4790AFD5F8A760A04791AD03083Q00559974A69CECC190026Q006E4003043Q001F35ABD703083Q00E64D54C5BC16CFB7025Q00E06D4003803Q00F3DB569A2A24F6D9569B2A21F6DD56962A21F3DF569A2A22F6D9569A2F27F6D9569C2A2FF6DA56992F25F6DA56962F20F3D8539D2A2FF3DC53982A24F3DC569F2A27F3DC569C2A27F6DA539D2A26F6D3569A2A24F6DE569B2A22F6D2569F2A23F6D8569B2A2FF6DF569F2F24F6DD539A2F25F3D9539D2F24F3DE569F2A24F3DE03063Q0016C5EA65AE19025Q00C06D4003063Q001FDECA1BE0C003083Q002A4CB1A67A92A18D025Q00A06D4003093Q00924FC01E34AAB845D603063Q00DED737A57D41025Q00806D4003143Q0065E0091F8226E80B1B8025E90A198623E9081D8603053Q00B615D13B2A025Q00406D4003043Q0028432DA803083Q006E7A2243C35F2985025Q00206D4003803Q0057BEF791620C57B6F794670C52B9F796620A52BEF796620957B9F297620C57BBF79B670C57BBF797620F52BDF793620D57BBF290670957BFF296620357BBF791620D52BCF790670952BEF79B670C57BCF793620A52BDF794620857BFF794670B52BEF796620357BEF795670852BDF295620D52BBF790620F52B9F795670F57BC03063Q003A648FC4A351026Q006D4003063Q000F4AD0B5E87C03073Q006D5C25BCD49A1D025Q00E06C4003093Q00FBBC5E4F51C847CCB703073Q0028BEC43B2C24BC025Q00C06C4003133Q002D81EB89231677036B82EA8D2E1674036986ED03083Q00325DB4DABD172E47025Q00806C4003043Q00B9853BB003073Q001DEBE455DB8EEB025Q00606C4003803Q00239BDAD8E9432398DAD8EC44239BDFDDE940239CDADFE942269DDFDDEC412397DADFEC4F239D2QDFEC4E269DDFDCEC472397DADEEC4F239ADADFEC4E239FDADDEC442398DFDDEC43269EDFD8EC422398DADFEC42239CDFDBEC42239DDADEEC4E269ADFDAEC45269CDADCEC43239FDADDEC42239EDFDBE9432396DFDDE940269C03063Q007610AF2QE9DF025Q00406C4003063Q00C2E520B737F003053Q0045918A4CD6025Q00206C4003093Q00FF915A0119F9D59B4C03063Q008DBAE93F626C026Q006C4003133Q00E6A42E53D68FA4A72D59DF84A3A42856D68EA303063Q00BC2Q961961E6025Q00C06B4003043Q00F439B73D03063Q0062A658D956D9025Q00A06B4003803Q009824966201704A9C27976404704E982D936304724F982795640B754D9823936101764F9827936100704B98229662017A4A982791640A70419826936601774F9F22966400754B9826966304724A9A279D6106754B9826966304714A9822906104754D9D27966F01714F99279C640A704D9820966604704A9C27966104754A982603073Q0079AB14A5573243025Q00806B4003063Q00F5D68FDF3CEB03063Q008AA6B9E3BE4E025Q00606B4003093Q00E13724271AD020333703053Q006FA44F4144025Q00406B4003143Q004425576618072C0322536A18032C032552621B0003073Q0018341466532E34026Q006B4003043Q00D53BE57B03043Q0010875A8B025Q00E06A4003803Q0040F9D50940F9D50E40FAD50445FED00F40FFD00D45F8D50C45F8D00D45FDD00A45F9D00D45FAD50D45FED00D40F8D50A45FFD00A40FCD00A45FED50840FDD50F45FED50440FED00945FFD50F45F8D50840F4D00D40FDD00840F5D00E40F4D50F40F9D00F40F5D50445F8D50A45FAD50440F9D50940F5D00F40FFD50E45F8D00D03043Q003C73CCE6025Q00C06A4003063Q0007BF2FE726B103043Q008654D043025Q00A06A4003093Q00A7C9A48EAC908DC3B203063Q00E4E2B1C1EDD9025Q00806A4003133Q00130890A3520C90AA510793AB510E97A951089A03043Q009B633FA3025Q00406A4003043Q00493DB14B03083Q00C51B5CDF20D1BB11025Q00206A4003243Q00CB03587B1C8DF8D48502592C4F95FED2CD5C43751D8CABCE900A58284FDEF9869E03587E03083Q00E3A83A6E4D79B8CF026Q006A4003043Q003882AC5F03043Q003060E7C2025Q00E0694003803Q00571017799F511611799D5216177D9A501317799C521017799F51161179995213127C9A5C161779915712177E9A561612799E572Q17789A5D16127C9C571D12789A571311799B521617729A522Q167C9D5210177F9A551613799A522Q177E9A5D161D79995216177D9A5D13177998571217739A5D1614799C5217127B9A56161403053Q00A96425244A025Q00C0694003063Q002QD6043234E403053Q004685B96853025Q00A0694003093Q006D69B1FDD05C7EA6ED03053Q00A52811D49E025Q0080694003133Q0029FFE370D969E2976BFEE379DA60E79761F0E303083Q00A059C6D549EA59D7025Q0040694003043Q001D135C4503073Q006B4F72322E97E7025Q0020694003403Q0068752011CA3F222942CC3A7528199868252D10CF6D217B429C60202A439A38222047CF6B2629189F6B767B19CD6D722919983C202F129D6B222E109D6072211703053Q00AE59131921026Q0069402Q033Q00F9713003063Q00CBB8266013CB025Q00E0684003803Q00F51FD249EF58F51FD24BEF5FF51AD74DEA5AF518D244EF59F015D24EEA59F018D74EEA5BF01AD24BEF57F51ED248EF5BF51ED24FEF5AF01BD249EF5DF51DD24CEF5AF01ED74EEF5AF014D24EEF5CF519D74FEF59F014D24FEF5DF01BD244EF5FF519D74AEF5BF519D24DEA5CF01AD248EA5EF51AD74AEF5BF51ED24CEA5CF01D03063Q006FC32CE17CDC025Q00C0684003063Q007C5A78095D5403043Q00682F3514025Q00A0684003093Q00F83EF340A0C929E45003053Q00D5BD469623025Q0080684003143Q00E5EF584824ACA6ED5B432E2QA0EF584B22AFA3E803063Q009895DE6A7B17025Q0040684003043Q00B47C231C03073Q00B2E61D4D77B8AC025Q0020684003803Q00FDBEEEE9FDBFEBEFFDB8EEE4F8BEEEEBFDB8EEE9FDBEEEEFF8BEEBEDF8B9EBEDF8BBEEE5FDBDEEE9FDBAEEEFFDBFEEE9FDB7EEEAF8BEEBEFF8BBEBEDF8BAEEEAFDB8EEECF8BAEEEDF8B9EEE8FDBBEBEEFDBEEEEBF8BDEBEFF8BEEBEDF8BEEEE5FDB8EEEFF8BA2QEEFDB9EBEDF8BDEBE9F8BDEBE9F8BEEEEDFDBAEEEFFDBEEEEC03043Q00DCCE8FDD026Q00684003063Q00CC7E58B724DF03073Q009C9F1134D656BE025Q00E0674003093Q002829307E186A02232603063Q001E6D51551D6D025Q00C0674003133Q0046F96F4D44B7A507F86C4F45B2A503F6654E4703073Q009336CF5C7E7383025Q0080674003043Q0065590AD503043Q00BE373864025Q0060674003403Q00BCC2B38F10BE92B2DF16EF93E3D814EFC2B9D819ED91E18C16BCC5B08813EAC0E18814E89AE28012EE95B5DB42B29BB6D813E9C5B78E42B9C6B7DA17BE92E5DC03053Q00218BA380B9025Q004067402Q033Q002F9A4003063Q00E26ECD10846B025Q0020674003403Q007147FAB861A7852712FFE730A5D22642FFB463F582214FAEB863F4D27C42FDB066A4817317F9E535F4D17C42FEE733A5857745AEB869A58F7C14AFE567A0D67703073Q00B74476CC815190026Q00674003083Q0068058102320E03AE03083Q00CB3B60ED6B456F71025Q00E0664003803Q006519A54620986510A0442598651DA0442099601DA544209C651FA541259D6519A046259D6510A045209B651DA0432097651CA543209A6519A040259F601BA04425986511A044209D6518A044209C651BA545259D651AA545209C601AA049209D6518A0482598601DA043209B651EA044209B601DA048209B651BA048259C601B03063Q00AE5629937013025Q00C0664003063Q00B727AAC0CA5203073Q00D2E448C6A1B833025Q00A0664003093Q00FAFFABDBE6CBE8BCCB03053Q0093BF87CEB8025Q0080664003143Q0031100154A70A7570160850A20F7B74130552AE0A03073Q004341213064973C025Q0040664003043Q00E084D22803073Q0034B2E5BC43E7C9025Q0020664003803Q00FD95181E101D6D1EFD961812101B681CF89A1812101C681FF8911D1315186D18F8941D141518681DFD91181E101A6D19F8961D2Q101F681BFD971D2Q101B6D1EF89B181310136D1BF8941815101A6815FD95181310136D19F8901816151F6D19F8951812101E6D1FF8941D171518681CF8951D12101D6D1FFD901D12101F681F03083Q002DCBA32B26232A5B026Q00664003063Q000AA74019D2E303073Q006E59C82C78A082025Q00E0654003093Q00350C37F6C3BAAD020703073Q00C270745295B6CE025Q00C0654003133Q00F54102D54A557806B54D0CD54D547608B74E0003083Q003E857935E37F6D4F025Q0080654003043Q00B04F515403073Q003EE22E2Q3FD0A9025Q0060654003403Q00BE71B1F688EA22BBA489E177E1A1D5BB24B4F189B923B5F3D8E92DB4A18FEA74B3F489BD76B0A6DFEB27B6ADDFEA24E0A4DDEC74B4A68BE82CB0A3DBBB25E3A403053Q00EDD8158295025Q0040654003063Q00C00C2511905903083Q001693634970E23878025Q0020654003093Q0059EF2C3526B073E53A03063Q00C41C97495653026Q00654003133Q001395211452952718569726155A922E1E52972303043Q002C63A617025Q00C0644003043Q00DCF6AC3B03043Q00508E97C2025Q00A0644003803Q0049E6DE5849E2DE5849E0DE5E49E0DE5B49E3DB5949E1DB5F49E2DB5B4CE3DE5C49E0DB5549E3DB5A49E6DB5549E3DB5C49ECDB554CE4DE594CE0DE5949ECDB584CE3DE5949E5DB5449EDDB5E49E4DE5F49ECDE5B4CE6DB5E49E4DB584CE0DB5E4CE6DB5F49ECDB5949E2DB5A4CE1DB5B49E2DB5549ECDE5B4CE7DB5F49E5DE5903043Q006D7AD5E8025Q0080644003063Q00E9E47BE999C603063Q00A7BA8B1788EB025Q0060644003093Q00FBBFC0DE66E5521CCD03083Q006EBEC7A5BD13913D025Q0040644003133Q0052BA0CD216B80AD317BC01D913B60AD411B80103043Q00E0228E39026Q00644003043Q00B2FD8C7D03083Q0076E09CE2165088D6025Q00E0634003803Q00101F92F2A09D151B92F0A09A151A97F7A5982Q1592F1A09B101892F1A59E101997F2A59E151992F2A599101A92F7A59E151492F5A59A101F92F7A099151E92FBA59C151A97F5A591101992F3A590101992F6A59C101E97F0A59F151492F5A598101F92FAA09E151D97F5A099101897F2A591101992F7A590151492FBA59E2Q1503063Q00A8262CA1C396025Q00C0634003063Q00B4FB0827B08603053Q00C2E7946446025Q00A0634003093Q00C9B006C749F8A711D703053Q003C8CC863A4025Q0080634003143Q00204FD24D166347D94C13614ED34F18674DD64A1703053Q0021507EE078025Q0040634003043Q0062A0FB2803063Q004E30C1954324025Q0020634003803Q0055470195FA26DD574C0591FA21DE5548019FFF22D85E490691FD24D8504C0190FF20DD544C0794FD21DE504E0193FA21D856490691FE21DF50490196FF2ADD524C0B91F924DD554C019EFF22DD544C0391F924DD554C0491FF26D8534C0294FE21D8504E0196FF2BD855490394FC21DD504C0493FF2AD8554C0791F821DF554F03073Q00EB667F32A7CC12026Q00634003063Q00337C0E7E590F03073Q00EA6013621F2B6E025Q00E0624003093Q00810109B950BCBA22B703083Q0050C4796CDA25C8D5025Q00C0624003133Q009C6412B10051DA6C1CB50654D56817B0065ADB03063Q0062EC5C248233025Q0080624003043Q001913265E03073Q00A24B724835EBE7025Q0060624003803Q0080D5AC108C81D7AC1A8C80D5AC198982D7AC1A8D85D8A91C8C83D7A91A8B85D3A91D8C81D7AE1A8985D4A91D8985D2AB1A8D85D3A91D8C82D7AD1F8980D5AC1B8C81D2A61F8C85D3AC188C81D2AA1A8C85D8A91A8C87D2AC1A8C80D3A91D8C8FD7AA1A8685D6A9188985D2AE1F8C80D7AC1F8C84D7AD1F8A85D8A9188980D2AD03053Q00BFB6E19F29025Q0040624003063Q00C0E054D7375703063Q0036938F38B645025Q0020624003093Q007D0F22454D0328544B03043Q0026387747026Q00624003133Q005622035967102C015661102B045C67152C055B03053Q0053261A346E025Q00C0614003043Q00C9AFBC2303043Q00489BCED2025Q00A0614003603Q00E602CC211B640398B6559C21183C0796B50B9C20426F03C2E355CC244B3E0094B60B92291B6E0CC2B2009B244E3853C2E202CF294A655799E351C92249640C91E40A9F731C6F0496E301CE254D3E03C3B7579D204D6804C3E20B9C744E6A079003083Q00A1D333AA107A5D35025Q0080614003043Q000F071BE803043Q008D58666D025Q0060614003093Q00113E05C3E0202912D303053Q0095544660A0025Q0040614003143Q00C6F15F7B9584F4597E9187F05D7D9182F65F7F9A03053Q00A3B6C06D4F026Q00614003043Q006CC2FBEE03063Q00A03EA395854C025Q00E0604003803Q00EA5AD5725464FFE05AD2725266F5EF5DD5775160FFEB5FD3725063F9EA5DD5725162FFEB5AD1725B66F5EF58D073516DFFEA5FD2725266F5EA59D0795163FFE85AD7775066FDEA5ED5755165FAEF5FD3725666FCEF58D0745466FFEB5AD7725A66FEEF5AD0715467FFE15FD6725463F8EF59D0795165FFEC5FD4725166FCEA5D03073Q00CCD96CE3416255025Q00C0604003063Q003106AB57AFE503083Q00C96269C736DD8477025Q00A0604003093Q002ABE287CF2FC00B43E03063Q00886FC64D1F87025Q0080604003143Q00E320A45A4312A326A45E4919A026A155461CA22203063Q002A9311966C70025Q0040604003043Q0029EC885A03073Q00597B8DE6318D5D025Q0020604003803Q009D2AE15BD69D28E450D79D29E456D69E2DE255D19D2CE156D69D28E650DC9D29E151D6962DE050D09D2CE156D69E28E050D79D2CE157D69F28E355D19D2BE155D39D28E650D49D2DE152D39A28E755D39D2DE450D39C28E750D39D2AE455D69F28E650D49D2DE450D69A28E350D69D26E157D39D2DE350D49D27E152D69F2DE003053Q00E5AE1ED263026Q00604003063Q00B74E542F964003043Q004EE42138025Q00C05F4003403Q007C9A07E81F9BD7789B0BB247CBD57C980AEE439ED77ECC0CED149FD128CB07BA40CE867B9A07B2159AD0799F08BA459AD87A980CBD159FD4789607B9129A827F03073Q00E04DAE3F8B26AF025Q00805F4003083Q00E8D422553856C9D403063Q0037BBB14E3C4F025Q00405F4003093Q00A1D905BA2A25C796D203073Q00A8E4A160D95F51026Q005F4003133Q00DDB245AD4294BE44AF4A95BE4CAB499EB14DAB03053Q007AAD877D9B025Q00805E4003043Q000300DCBF03073Q00DD5161B2D498B0025Q00405E4003803Q0041796E2DEF2644716B2BEF2341796B2CEF2641706E2AEA2541756B2BEF2244736E2DEF2244766E29EA2741736B2BEF2641716E2AEF2641726E2AEF2D41776B2BEA2144766E2AEF2644746B25EF2D44766B25EF2541706B2BEF2241796B28EA2041736B2AEF2244746B2CEF2344736B29EF2D44746E2FEF2044726E2AEF26417403063Q00147240581CDC026Q005E4003063Q00F21D01F4107103073Q00D9A1726D956210025Q00C05D4003093Q00786E761F66BF424F6503073Q002D3D16137C13CB025Q00805D4003143Q00232Q03AEA1660206A0AB650003A0A9670407AFAB03053Q0099532Q3296026Q005D4003043Q008CF50D4E03053Q00E3DE946325025Q00C05C4003243Q00979B409C0CA2A99186129509A3E5959A16C210F7AE90985E9C0DA0AD92CD45C10BAFFE9703073Q00C8A4AB73A43D96025Q00805C4003043Q002AF82Q3B03053Q0016729D5554025Q00405C4003803Q00A7F9E081FB0E0AA1FBE482FC050EA7FEE085FB0E0AA7FEE687FD0501A7FAE081FB0E0AA1FEEF82FC050AA7FAE082FE070FA5FEE187FE0509A7FAE581FE040AA4FBE787F9000CA7F4E586FB060FA6FEE487F9050DA7FEE082FB020FA5FEE282FA000FA7F5E580FE030FA7FEE182FB000BA2FBE583FE030FA1FEEE82F9000DA7F403073Q003994CDD6B4C836026Q005C4003063Q0085BAEAD1A4B403043Q00B0D6D586025Q00C05B4003093Q009F95ADD1AF99A7C0A903043Q00B2DAEDC8025Q00805B4003143Q00A972FA23EEED12EDEC76FD24E8EF13E5EE72FB2D03083Q00D4D943CB142QDF25026Q005B4003043Q007C11397103043Q001A2E7057025Q00C05A4003243Q0012199B20661448CA3862421ECB3861154FCC3832471CCB3868141CCB2336124F982C661703053Q0050242AAE15025Q00805A4003043Q00DA27E95303073Q00A68242873C1B11025Q00405A4003803Q004584D1A9B9974082D1AFB9924084D1ABB9954587D1A8B9954583D1ADBC954081D1A3BC914586D4AFB9944085D1ABB9904587D1AEBC964084D4AEBC96408DD1AFB9914084D1A9B9954083D4AFBC944086D4AAB99F4580D4AEBC944581D1ACBC954084D1ABBC944087D1AFBC944586D1ADB993408DD1AAB99E4587D1AEBC96408D03063Q00A773B5E29B8A026Q005A4003063Q00028D70BD238303043Q00DC51E21C025Q00C0594003093Q00791DC5AC37CC5317D303063Q00B83C65A0CF42025Q0080594003133Q00D2D645AF6FBE0096D940AB69B60C9BD54EA86103073Q0038A2E1769E598E026Q00594003043Q0007B585F903053Q00BA55D4EB92025Q00C0584003803Q00AE9E42811DE4AE9942801DE3AE9E47841DE2AB9B47841DEFAE9C42811DE2AE9A47841DE2AE9E478718E2AB98428618E6AE94428118E2AB9F42861DE2AE9B47841DE7AE9A47831DE1AE9B42841DE5AE9A47821DEFAE9C478118E4AB9947871DE5AE9842861DE6AE9D47861DE4AE95478D18E5AB9E478D18E1AB9B42871DE6AE9503063Q00D79DAD74B52E025Q0080584003063Q000D30F5F02C3E03043Q00915E5F99025Q0040584003093Q00CD155CFDCEF68D3CFB03083Q004E886D399EBB82E2026Q00584003143Q00D1136084579414618F5698136A855D991466855D03053Q0065A12252B6025Q0080574003043Q00B7B33D0003073Q00E9E5D2536B282E025Q0040574003803Q00B29961AAB966AF1AB79E64ACB964AF15B29B61A9B963AF1AB29B64ABBC60AF14B29A61A2BC67AA11B29161ADBC61AA17B79C64A9BC69AF10B29961A9B966AA16B29E61ABBC64AF11B29D61ABBC69AF1BB29B64ACBC69AA16B29D64ACB966AF10B29864ACB961AA14B79A61AFB962AF16B29C64AFBC65AA13B79E64A9BC64AF1A03083Q002281A8529A8F509C026Q00574003063Q0084EA75F4FBCA03063Q00ABD785199589025Q00C0564003243Q0071D00A0FE070880B17B273820A17E274D45F17B17CD40E17EB75875F0CB573D40C03E57603053Q00D345B12Q3A025Q0080564003043Q00122BDB5403043Q003B4A4EB5025Q0040564003093Q00A9E549310758759EEE03073Q001AEC9D2C52722C026Q00564003133Q00E7A46F82AEAA6F8BA3AB68822QA56885A7A56D03043Q00B297935C025Q0080554003043Q00B2A6C9F003063Q009FE0C7A79B37025Q0040554003803Q00A222A3FC7678D4A722ACFE737BD2A723A6FB737BD4A122ACFB747BD2A727A6F5737BD4A727A6FE717ED5A729A3F97678D4A622A7FE767EDEA726A6F97679D1A522A0FE7D7EDFA222A3FF767AD1A127A3FB737BD4A722A3FE737CD4A122ADFB717BD5A726A6F9737ED4A627A3FE7C7BD4A726A6FB767FD1A522A4FE777ED1A22203073Q00E7941195CD454D026Q00554003063Q00F8782855EF3203073Q00A8AB1744349D53025Q00C0544003093Q00C21AFFCAF216F5DBF403043Q00A987629A025Q0080544003143Q00270A8D70D3030B640E8F79D5010B650F8F7BD52Q03073Q003E573BBF49E036026Q00544003043Q0097AB2D1503083Q0031C5CA437E7364A7025Q00C0534003243Q00FD7EFF1A9E561A58E12CFC4F951A4F58A928E613C2561B44F47EFD4E9151480CFA77FD1803083Q0069CC4ECB2BA7377E025Q0080534003043Q003937083503053Q003D6152665A025Q0040534003803Q00C526296AFA1DB4B324251D8A1DC6C7502C688C1BB8C22Q291FFA1CB9B75229688E6CB6B2502E6DFD1BB0B1262A6B886BC2B4532C1EFE1AB0B3502E6C8C18B0B1295D18881FB6C0545A1EF96DB5B4502E19F86CB9C5525D1CFF1AC4C5505D688E1CC5B354241C8E1CC4C2542F1F8B18B1C720291EFA16C2BD295D6D8269C1B12103073Q008084111C29BB2F026Q00534003093Q0063A3CFBA40A9C4FB6A03043Q00DB30DAA1025Q00C0524003603Q00221672D1A9DB70407683AEDB201275D5A7DB204327D7A78F25162ED4A8D2701826D3A98F711520D6ADD3201974DCAF8F22152E87FA8874172EDCAB8A24167280A8DA20107183FC8E20452ED5FF8E744372D6A9DD771374D0A68E74157683FCD303063Q00EB122117E59E025Q0080524003043Q001C8D26A903073Q00564BEC50CCC9DD025Q0040524003803Q001D4262FFA2E616021D4462FEA2E5160C1D4467FCA7E613091D4662FBA2E2160D1D4662FFA7E6160F1D4262FFA2E0130F184562FFA2E81309184167FCA7E1130E1D4562FEA7E1160B1D4362F0A2E2160B184567FCA2E8160F1D4162FEA2E3160F1D4E67FEA2E11608184362FEA2E01602184367FCA7E2130C1D4162F8A2E2130E03083Q003A2E7751C891D025026Q00524003063Q00895BBA41A85503043Q0020DA34D6025Q00C0514003093Q006B9FE62E5B93EC3F5D03043Q004D2EE783025Q0080514003143Q00A3795DAD8703E7705FAD860DE67F5FA98902E17A03063Q003BD3486F9CB0026Q00514003043Q0022578D8003083Q00907036E3EBE64ECD025Q00C0504003803Q000877E2001E0F7DE6001E087DE7001E097DE2051A087FE2071E0D78E5001E0D7AE7021E0E7DE5051F0D7DE2021E0E7DE00018087CE7061B087DE5051B0876E7051B0D7DE7051D0D7BE7061E0978E705150D7AE70E1E097DE605190876E7071B097DE205180878E7041E0D7DEC001F087AE7001E027DE3001F0D7CE70F1E0878E703053Q002D3B4ED436025Q0080504003063Q000919F8B4281703043Q00D55A7694025Q0040504003093Q00A735A049C9541E903E03073Q0071E24DC52ABC20026Q00504003133Q0068D57A4E2DD7774629D77F432AD47D4028D57A03043Q007718E74E026Q004F4003043Q00ED1EFA1703053Q005ABF7F947C025Q00804E4003803Q00AEE603102F8BAEE406112F89AEE406112A8EAEE503172A89ABE206162F89ABE503102F86ABE006162F87AEEB03122F88AEE303172A8BABE003172A8DAEE006162F8BABE506172A89AEEA03152F8DAEE506162A8BAEE503172A8CAEE206132A8CABE103102F8AAEE0031D2F8DAEE303172A89ABE503132F8DAEE006142A89ABE003063Q00BF9DD330251C026Q004E4003063Q000F3E05BA0BEA03083Q00555C5169DB798B41025Q00804D4003093Q00074032DBCB00E9304B03073Q0086423857B8BE74026Q004D4003133Q00BA905E9990FB87B4FA9B5B9F96F38EB4FB985903083Q0081CAA86DABA5C3B7026Q004C4003043Q008A23701503073Q008FD8421E7E449B025Q00804B4003803Q001DF2862179971BF51DF9832B7C9B1BF618FE83267C971EFC1DF886277C951BF01DFD83217C901EF21DF286207C931BF71DF2862379901EF31DF983207C951BF11DFD83227C9A1BF01DFE86237C941EF618FF832479971EF01DFE86267C931BF71DFD83277C931EFC1DFF86247C9A1EF718F883227C941EF21DFD832579921EF003083Q00C42ECBB0124FA32D026Q004B4003063Q009D533F3A3D3003063Q0051CE3C535B4F025Q00804A4003093Q0024FF4D5C6615E85A4C03053Q00136187283F026Q004A4003133Q00AD807118EC8A7314EE88781AEC8B7818E58E7503043Q002CDDB940026Q00494003043Q0079D2B64703063Q001D2BB3D82C7B025Q0080484003803Q006FF8D71DB52A2B6FFCD31FB72A296FF9D21BB52D2E68F9D21FB62F2E6FF8D218B02D2B69F9D31FB52F296FFFD218B52A2B6AFCD61FBA2A296AF9D719B52C2B69FCD51FB22F2E6FF7D21FB02C2B6FFCD71FB12A296FF7D21CB02D2B6EF9D71FB52A2D6FFCD215B02C2B6DFCD71FB32A216FF6D21EB5282E6EF9D51FB62A2C6AFD03073Q00185CCFE12C8319026Q00484003063Q00E8841DF4ABDD03073Q00AFBBEB7195D9BC025Q0080474003603Q000A0519A473DFDE2Q080318A421D2DF580F0E4DFE76DED50A5D5249A824DED459010019AF7084835E0A5012AE2785D15D0E031EF92DD782520C501BA422D4D65A010E48FB7787D3095A5548F82185835E01551FA877D4D55809031BA47480845903083Q006B39362B9D15E6E7026Q00474003043Q006DC9F35303073Q00E03AA885363A92025Q0080464003093Q007D3876FF4F5457326003063Q00203840139C3A026Q00464003143Q00F51F2252B7162358B41A235EBC1F225CBD19225903043Q006A852E10026Q00454003043Q008CF3CFC903083Q001EDE92A1A25AAED2025Q0080444003803Q00B0969E6FB5979B6FB0969E65B0949B6BB5959E68B5939E6BB5909E6BB59D9E6EB5979E6DB59C9E64B5949B6EB59D9B68B59D9E68B59D9B69B5909E68B0949E69B0979B6CB59D9B6CB0919B6CB5929B6BB0939E68B0919B6CB5939E69B0979B69B5929B6BB0939E68B5939E6CB5969E6BB5929B68B59D9E6FB5919E65B5979B6803043Q005D86A5AD026Q00444003063Q009E77B58121AC03053Q0053CD18D9E0025Q0080434003093Q0062D430DF1153C327CF03053Q006427AC55BC026Q00434003133Q00BCFE4716E5BF98FFF94013E3BC98FBF04812EF03073Q00AFCCC97124D68B026Q00424003043Q00BE04514D03073Q0080EC653F268421025Q0080414003243Q00D24E0383E17E8786520485E67ACB854E02D5FB24D3D74D4A8BE62A83821951D6E025D08703073Q00E6B47F67B3D61C026Q00414003043Q001D81B14303083Q007045E4DF2C64E871025Q00802Q4003603Q00FB8847A72BF2A98846F62AA3A88C44A67DF5AC8545A97BF7F8D940F12FAFA88514A22BAFFA8F42F62FF3A88913A52AA3A98B45F12FF5F9DC15A27AA5FDDE40F52BA4F5DB41A52DA3F4DB13F32AF4AC8E44A07AA7AF8449A720A7AEDC15A92EA603063Q0096CDBD709018026Q002Q4003043Q002DECAEB503073Q00C77A8DD8D0CCDD026Q003F4003803Q00D77F9B46B4D97A9941BED77A9E41B4D27F9F44B3D27E9E46B1D37F9541B4D7789E46B1D47A9C44B6D27E9B47B1D47A9E44B1D2789B44B4D67A9841B0D77D9B40B1D37A9844B1D2759E44B4D17A9F41B0D77D9B46B1D77A9C44B4D77A9E43B4D97A9B41B7D7789E46B1D57A9F44B5D7789B47B4D57A9F41B3D27E9E47B4D57F9B03053Q0087E14CAD72026Q003E4003063Q00223FBE395C3603073Q00497150D2582E57026Q003D4003093Q00E61787F4DFD70090E403053Q00AAA36FE297026Q003C4003133Q002857D190F96C58D297FA6A59D294FA6B57D79003053Q00CA586EE2A6026Q003A4003043Q00E0E73FB903073Q006BB28651D2C69E026Q00394003803Q00EEBB8897EEBD889CEEBC8893EBBF8D95EBBA8895EBB88D90EEBB8893EBB88D96EBBD8D96EBB08890EEBF8892EBB18D95EEBF8D92EBBD8896EBBC8894EBBA8D91EBB1889DEEB88890EBBB8D90EEBF8893EEBA889CEBB8889DEEB88D92EEBA8894EEBA8D95EBBD8895EEBC8D92EBBC8893EBBD8D92EBBA8D97EEBA8D97EBBA889D03043Q00A4D889BB026Q00384003063Q006B51092835EC03073Q0072383E6549478D026Q00374003093Q00F1DCEB5FC1D0E14EC703043Q003CB4A48E026Q00364003133Q00467E0661760BAC0F7109607406AB077B0D697203073Q009836483F58453E026Q00344003043Q0035EFABC503043Q00AE678EC5026Q00334003243Q00907D22D7E54FFFC96376D3B718B1997F2586F941FA9F2C6DD8E44FF99E287685E240AA9B03073Q009CA84E40E0D479026Q00324003043Q00FF517E1B03063Q007EA7341074D9026Q00314003803Q005447EA79544EEF7A5445EA7B5140EA79544FEA785447EA7E5444EA7A544EEF7A5143EF7D5447EA7C5441EA785446EA7B5140EF795140EA7C5145EA725446EF7F5143EA735441EF78544FEA7F544FEA7D5445EA795442EF7E544FEA735145EA7F5145EF7E5147EA7E5142EF7F5143EA785442EA7F5441EA7F5441EA7A5442EA7A03043Q004B6776D9026Q00304003063Q00B8FF3E5CEAA603063Q00C7EB90523D98026Q002E4003093Q0093F12FC80DBA3CD5A503083Q00A7D6894AAB78CE53026Q002C4003133Q001C9A0C232C27A3B35E9B0C202A22A3B45E970803083Q00876CAE3E121E1793026Q002A402Q033Q0081F67403053Q007EDBB9223D026Q00284003043Q001BC0228303043Q00E849A14C026Q00264003243Q00986825B487FFC86C6AE38EF9C87176B7DBAB863D71B18CE7936C71E388AC9D3971BF88F903063Q00CAAB5C4786BE026Q00244003043Q003ABF853803053Q00B962DAEB57026Q00224003403Q00BFC1D15F0379BFC282595178E9C08E0C537AB8C1805F5A72E4C084095B73BA93875D5573EEC78052037DEB94D45F0372EE94870E577CE9C08F0F0473E8C28F5903063Q004BDCA3B76A62026Q0020402Q033Q0068753003043Q0045292260026Q001C4003803Q009F029FF118056896EB779EF91B731390EE72EDF56F0515E3E977EAF1197311E29A079B851C0464959E0291F5180469969F0198816D061395E801EDF71C7665E4E374ED841E7663919E0390831E736696EE74918369036696E80FEA846C7567E7EB77E8F218721399E80699F36B0764E7E8739A811F076393EE749DF06374669003083Q00A1DB36A9C05A3050026Q00184003093Q002AA6DFDE9D3F31598503073Q005479DFB1BFED4C026Q00144003603Q00FD2A7D784420A212FE782F291220A846FF782C2E1626AF1AF0257A794A2DFF1AAD252B714372FE1AF8797E2A462DF913AA287A2B4027F817AE7B29794622AF12FF2A2E704021AF45FC7B2D7F1625FB17FB7B7F2C4670AA12AD7F7E7C422DAC1603083Q0023C81D1C4873149A026Q00104003043Q00CB56B14303043Q00269C37C7026Q00084003803Q008B63AF102BB2158C65AA162BB6128E63AA132EB3158465AB162EB3138E61AA112EB6108F65A8162CB3148E66AF182BB2108B65A9162BB6158B62AF192EB4158A60AA162DB3138E60AF102BB2158565A5162BB6138E65AF132EB4158465A9132FB6128B63AF132BB0108B65A5132EB6178B64AF182BB7108960AE1629B3128E6E03073Q0026BD569C201885027Q004003063Q00171F3A72B7BF03073Q00CB44705613C5DE026Q00F03F03093Q000BE655153706D9343D03083Q00464E9E30764272B6028Q0003133Q00A71D4661E41D4465E11E4365E21C446DE51B4003043Q0054D7297603013Q005A03013Q005303013Q00410072123Q00287Q00122Q000100013Q00202Q00010001000200122Q000200013Q00202Q00020002000300122Q000300013Q00202Q00030003000400122Q000400053Q00062Q0004000B0001000100044Q000B0001001257000400063Q002016000500040007001257000600083Q002016000600060009001257000700083Q00201600070007000A00066E00083Q000100062Q00293Q00074Q00293Q00014Q00293Q00054Q00293Q00024Q00293Q00034Q00293Q00064Q00D8000900083Q00122Q000A000C3Q00122Q000B000D6Q0009000B000200104Q000B00094Q000900083Q00122Q000A000F3Q00122Q000B00106Q0009000B000200104Q000E00094Q000900083Q00122Q000A00123Q00122Q000B00136Q0009000B000200104Q001100094Q000900083Q00122Q000A00153Q00122Q000B00166Q0009000B000200104Q001400094Q000900083Q00122Q000A00183Q00122Q000B00196Q0009000B000200104Q001700094Q000900083Q00122Q000A001B3Q00122Q000B001C6Q0009000B000200104Q001A00094Q000900083Q00122Q000A001E3Q00122Q000B001F6Q0009000B000200104Q001D00094Q000900083Q00122Q000A00213Q00122Q000B00226Q0009000B000200104Q002000094Q000900083Q00122Q000A00243Q00122Q000B00256Q0009000B000200104Q002300094Q000900083Q00122Q000A00273Q00122Q000B00286Q0009000B000200104Q002600094Q000900083Q00122Q000A002A3Q00122Q000B002B6Q0009000B000200104Q002900094Q000900083Q00122Q000A002D3Q00122Q000B002E6Q0009000B000200104Q002C00094Q000900083Q00122Q000A00303Q00122Q000B00316Q0009000B000200104Q002F00094Q000900083Q00122Q000A00333Q00122Q000B00346Q0009000B000200104Q003200094Q000900083Q00122Q000A00363Q00122Q000B00376Q0009000B000200104Q003500094Q000900083Q00122Q000A00393Q00122Q000B003A6Q0009000B000200104Q003800092Q00D8000900083Q00122Q000A003C3Q00122Q000B003D6Q0009000B000200104Q003B00094Q000900083Q00122Q000A003F3Q00122Q000B00406Q0009000B000200104Q003E00094Q000900083Q00122Q000A00423Q00122Q000B00436Q0009000B000200104Q004100094Q000900083Q00122Q000A00453Q00122Q000B00466Q0009000B000200104Q004400094Q000900083Q00122Q000A00483Q00122Q000B00496Q0009000B000200104Q004700094Q000900083Q00122Q000A004B3Q00122Q000B004C6Q0009000B000200104Q004A00094Q000900083Q00122Q000A004E3Q00122Q000B004F6Q0009000B000200104Q004D00094Q000900083Q00122Q000A00513Q00122Q000B00526Q0009000B000200104Q005000094Q000900083Q00122Q000A00543Q00122Q000B00556Q0009000B000200104Q005300094Q000900083Q00122Q000A00573Q00122Q000B00586Q0009000B000200104Q005600094Q000900083Q00122Q000A005A3Q00122Q000B005B6Q0009000B000200104Q005900094Q000900083Q00122Q000A005D3Q00122Q000B005E6Q0009000B000200104Q005C00094Q000900083Q00122Q000A00603Q00122Q000B00616Q0009000B000200104Q005F00094Q000900083Q00122Q000A00633Q00122Q000B00646Q0009000B000200104Q006200094Q000900083Q00122Q000A00663Q00122Q000B00676Q0009000B000200104Q006500094Q000900083Q00122Q000A00693Q00122Q000B006A6Q0009000B000200104Q006800092Q00D8000900083Q00122Q000A006C3Q00122Q000B006D6Q0009000B000200104Q006B00094Q000900083Q00122Q000A006F3Q00122Q000B00706Q0009000B000200104Q006E00094Q000900083Q00122Q000A00723Q00122Q000B00736Q0009000B000200104Q007100094Q000900083Q00122Q000A00753Q00122Q000B00766Q0009000B000200104Q007400094Q000900083Q00122Q000A00783Q00122Q000B00796Q0009000B000200104Q007700094Q000900083Q00122Q000A007B3Q00122Q000B007C6Q0009000B000200104Q007A00094Q000900083Q00122Q000A007E3Q00122Q000B007F6Q0009000B000200104Q007D00094Q000900083Q00122Q000A00813Q00122Q000B00826Q0009000B000200104Q008000094Q000900083Q00122Q000A00843Q00122Q000B00856Q0009000B000200104Q008300094Q000900083Q00122Q000A00873Q00122Q000B00886Q0009000B000200104Q008600094Q000900083Q00122Q000A008A3Q00122Q000B008B6Q0009000B000200104Q008900094Q000900083Q00122Q000A008D3Q00122Q000B008E6Q0009000B000200104Q008C00094Q000900083Q00122Q000A00903Q00122Q000B00916Q0009000B000200104Q008F00094Q000900083Q00122Q000A00933Q00122Q000B00946Q0009000B000200104Q009200094Q000900083Q00122Q000A00963Q00122Q000B00976Q0009000B000200104Q009500094Q000900083Q00122Q000A00993Q00122Q000B009A6Q0009000B000200104Q009800092Q00D8000900083Q00122Q000A009C3Q00122Q000B009D6Q0009000B000200104Q009B00094Q000900083Q00122Q000A009F3Q00122Q000B00A06Q0009000B000200104Q009E00094Q000900083Q00122Q000A00A23Q00122Q000B00A36Q0009000B000200104Q00A100094Q000900083Q00122Q000A00A53Q00122Q000B00A66Q0009000B000200104Q00A400094Q000900083Q00122Q000A00A83Q00122Q000B00A96Q0009000B000200104Q00A700094Q000900083Q00122Q000A00AB3Q00122Q000B00AC6Q0009000B000200104Q00AA00094Q000900083Q00122Q000A00AE3Q00122Q000B00AF6Q0009000B000200104Q00AD00094Q000900083Q00122Q000A00B13Q00122Q000B00B26Q0009000B000200104Q00B000094Q000900083Q00122Q000A00B43Q00122Q000B00B56Q0009000B000200104Q00B300094Q000900083Q00122Q000A00B73Q00122Q000B00B86Q0009000B000200104Q00B600094Q000900083Q00122Q000A00BA3Q00122Q000B00BB6Q0009000B000200104Q00B900094Q000900083Q00122Q000A00BD3Q00122Q000B00BE6Q0009000B000200104Q00BC00094Q000900083Q00122Q000A00C03Q00122Q000B00C16Q0009000B000200104Q00BF00094Q000900083Q00122Q000A00C33Q00122Q000B00C46Q0009000B000200104Q00C200094Q000900083Q00122Q000A00C63Q00122Q000B00C76Q0009000B000200104Q00C500094Q000900083Q00122Q000A00C93Q00122Q000B00CA6Q0009000B000200104Q00C800092Q00D8000900083Q00122Q000A00CC3Q00122Q000B00CD6Q0009000B000200104Q00CB00094Q000900083Q00122Q000A00CF3Q00122Q000B00D06Q0009000B000200104Q00CE00094Q000900083Q00122Q000A00D23Q00122Q000B00D36Q0009000B000200104Q00D100094Q000900083Q00122Q000A00D53Q00122Q000B00D66Q0009000B000200104Q00D400094Q000900083Q00122Q000A00D83Q00122Q000B00D96Q0009000B000200104Q00D700094Q000900083Q00122Q000A00DB3Q00122Q000B00DC6Q0009000B000200104Q00DA00094Q000900083Q00122Q000A00DE3Q00122Q000B00DF6Q0009000B000200104Q00DD00094Q000900083Q00122Q000A00E13Q00122Q000B00E26Q0009000B000200104Q00E000094Q000900083Q00122Q000A00E43Q00122Q000B00E56Q0009000B000200104Q00E300094Q000900083Q00122Q000A00E73Q00122Q000B00E86Q0009000B000200104Q00E600094Q000900083Q00122Q000A00EA3Q00122Q000B00EB6Q0009000B000200104Q00E900094Q000900083Q00122Q000A00ED3Q00122Q000B00EE6Q0009000B000200104Q00EC00094Q000900083Q00122Q000A00F03Q00122Q000B00F16Q0009000B000200104Q00EF00094Q000900083Q00122Q000A00F33Q00122Q000B00F46Q0009000B000200104Q00F200094Q000900083Q00122Q000A00F63Q00122Q000B00F76Q0009000B000200104Q00F500094Q000900083Q00122Q000A00F93Q00122Q000B00FA6Q0009000B000200104Q00F800092Q0015000900083Q00122Q000A00FC3Q00122Q000B00FD6Q0009000B000200104Q00FB00092Q001D000900083Q00122Q000A00FF3Q00122Q000B2Q00015Q0009000B000200104Q00FE000900122Q0009002Q015Q000A00083Q00122Q000B0002012Q00122Q000C0003015Q000A000C00026Q0009000A00122Q00090004015Q000A00083Q00122Q000B0005012Q00122Q000C0006015Q000A000C00026Q0009000A00122Q00090007015Q000A00083Q00122Q000B0008012Q00122Q000C0009015Q000A000C00026Q0009000A00122Q0009000A015Q000A00083Q00122Q000B000B012Q00122Q000C000C015Q000A000C00026Q0009000A00122Q0009000D015Q000A00083Q00122Q000B000E012Q00122Q000C000F015Q000A000C00026Q0009000A00122Q00090010015Q000A00083Q00122Q000B0011012Q00122Q000C0012015Q000A000C00026Q0009000A00122Q00090013015Q000A00083Q00122Q000B0014012Q00122Q000C0015015Q000A000C00026Q0009000A00122Q00090016015Q000A00083Q00122Q000B0017012Q00122Q000C0018015Q000A000C00026Q0009000A00122Q00090019015Q000A00083Q00122Q000B001A012Q00122Q000C001B015Q000A000C00026Q0009000A00122Q0009001C015Q000A00083Q00122Q000B001D012Q00122Q000C001E015Q000A000C00026Q0009000A00122Q0009001F015Q000A00083Q00122Q000B0020012Q00122Q000C0021015Q000A000C00026Q0009000A00122Q00090022015Q000A00083Q00122Q000B0023012Q00122Q000C0024015Q000A000C00026Q0009000A00122Q00090025015Q000A00083Q00122Q000B0026012Q001271000C0027013Q008C000A000C00026Q0009000A00122Q00090028015Q000A00083Q00122Q000B0029012Q00122Q000C002A015Q000A000C00026Q0009000A00122Q0009002B015Q000A00083Q00122Q000B002C012Q00122Q000C002D015Q000A000C00026Q0009000A00122Q0009002E015Q000A00083Q00122Q000B002F012Q00122Q000C0030015Q000A000C00026Q0009000A00122Q00090031015Q000A00083Q00122Q000B0032012Q00122Q000C0033015Q000A000C00026Q0009000A00122Q00090034015Q000A00083Q00122Q000B0035012Q00122Q000C0036015Q000A000C00026Q0009000A00122Q00090037015Q000A00083Q00122Q000B0038012Q00122Q000C0039015Q000A000C00026Q0009000A00122Q0009003A015Q000A00083Q00122Q000B003B012Q00122Q000C003C015Q000A000C00026Q0009000A00122Q0009003D015Q000A00083Q00122Q000B003E012Q00122Q000C003F015Q000A000C00026Q0009000A00122Q00090040015Q000A00083Q00122Q000B0041012Q00122Q000C0042015Q000A000C00026Q0009000A00122Q00090043015Q000A00083Q00122Q000B0044012Q00122Q000C0045015Q000A000C00026Q0009000A00122Q00090046015Q000A00083Q00122Q000B0047012Q00122Q000C0048015Q000A000C00026Q0009000A00122Q00090049015Q000A00083Q00122Q000B004A012Q00122Q000C004B015Q000A000C00026Q0009000A00122Q0009004C015Q000A00083Q00122Q000B004D012Q00122Q000C004E015Q000A000C00026Q0009000A0012710009004F013Q00BB000A00083Q00122Q000B0050012Q00122Q000C0051015Q000A000C00026Q0009000A00122Q00090052015Q000A00083Q00122Q000B0053012Q00122Q000C0054015Q000A000C00026Q0009000A00122Q00090055015Q000A00083Q00122Q000B0056012Q00122Q000C0057015Q000A000C00026Q0009000A00122Q00090058015Q000A00083Q00122Q000B0059012Q00122Q000C005A015Q000A000C00026Q0009000A00122Q0009005B015Q000A00083Q00122Q000B005C012Q00122Q000C005D015Q000A000C00026Q0009000A00122Q0009005E015Q000A00083Q00122Q000B005F012Q00122Q000C0060015Q000A000C00026Q0009000A00122Q00090061015Q000A00083Q00122Q000B0062012Q00122Q000C0063015Q000A000C00026Q0009000A00122Q00090064015Q000A00083Q00122Q000B0065012Q00122Q000C0066015Q000A000C00026Q0009000A00122Q00090067015Q000A00083Q00122Q000B0068012Q00122Q000C0069015Q000A000C00026Q0009000A00122Q0009006A015Q000A00083Q00122Q000B006B012Q00122Q000C006C015Q000A000C00026Q0009000A00122Q0009006D015Q000A00083Q00122Q000B006E012Q00122Q000C006F015Q000A000C00026Q0009000A00122Q00090070015Q000A00083Q00122Q000B0071012Q00122Q000C0072015Q000A000C00026Q0009000A00122Q00090073015Q000A00083Q00122Q000B0074012Q00122Q000C0075015Q000A000C00026Q0009000A00122Q00090076015Q000A00083Q00122Q000B0077012Q001271000C0078013Q008C000A000C00026Q0009000A00122Q00090079015Q000A00083Q00122Q000B007A012Q00122Q000C007B015Q000A000C00026Q0009000A00122Q0009007C015Q000A00083Q00122Q000B007D012Q00122Q000C007E015Q000A000C00026Q0009000A00122Q0009007F015Q000A00083Q00122Q000B0080012Q00122Q000C0081015Q000A000C00026Q0009000A00122Q00090082015Q000A00083Q00122Q000B0083012Q00122Q000C0084015Q000A000C00026Q0009000A00122Q00090085015Q000A00083Q00122Q000B0086012Q00122Q000C0087015Q000A000C00026Q0009000A00122Q00090088015Q000A00083Q00122Q000B0089012Q00122Q000C008A015Q000A000C00026Q0009000A00122Q0009008B015Q000A00083Q00122Q000B008C012Q00122Q000C008D015Q000A000C00026Q0009000A00122Q0009008E015Q000A00083Q00122Q000B008F012Q00122Q000C0090015Q000A000C00026Q0009000A00122Q00090091015Q000A00083Q00122Q000B0092012Q00122Q000C0093015Q000A000C00026Q0009000A00122Q00090094015Q000A00083Q00122Q000B0095012Q00122Q000C0096015Q000A000C00026Q0009000A00122Q00090097015Q000A00083Q00122Q000B0098012Q00122Q000C0099015Q000A000C00026Q0009000A00122Q0009009A015Q000A00083Q00122Q000B009B012Q00122Q000C009C015Q000A000C00026Q0009000A00122Q0009009D015Q000A00083Q00122Q000B009E012Q00122Q000C009F015Q000A000C00026Q0009000A001271000900A0013Q00BB000A00083Q00122Q000B00A1012Q00122Q000C00A2015Q000A000C00026Q0009000A00122Q000900A3015Q000A00083Q00122Q000B00A4012Q00122Q000C00A5015Q000A000C00026Q0009000A00122Q000900A6015Q000A00083Q00122Q000B00A7012Q00122Q000C00A8015Q000A000C00026Q0009000A00122Q000900A9015Q000A00083Q00122Q000B00AA012Q00122Q000C00AB015Q000A000C00026Q0009000A00122Q000900AC015Q000A00083Q00122Q000B00AD012Q00122Q000C00AE015Q000A000C00026Q0009000A00122Q000900AF015Q000A00083Q00122Q000B00B0012Q00122Q000C00B1015Q000A000C00026Q0009000A00122Q000900B2015Q000A00083Q00122Q000B00B3012Q00122Q000C00B4015Q000A000C00026Q0009000A00122Q000900B5015Q000A00083Q00122Q000B00B6012Q00122Q000C00B7015Q000A000C00026Q0009000A00122Q000900B8015Q000A00083Q00122Q000B00B9012Q00122Q000C00BA015Q000A000C00026Q0009000A00122Q000900BB015Q000A00083Q00122Q000B00BC012Q00122Q000C00BD015Q000A000C00026Q0009000A00122Q000900BE015Q000A00083Q00122Q000B00BF012Q00122Q000C00C0015Q000A000C00026Q0009000A00122Q000900C1015Q000A00083Q00122Q000B00C2012Q00122Q000C00C3015Q000A000C00026Q0009000A00122Q000900C4015Q000A00083Q00122Q000B00C5012Q00122Q000C00C6015Q000A000C00026Q0009000A00122Q000900C7015Q000A00083Q00122Q000B00C8012Q001271000C00C9013Q008C000A000C00026Q0009000A00122Q000900CA015Q000A00083Q00122Q000B00CB012Q00122Q000C00CC015Q000A000C00026Q0009000A00122Q000900CD015Q000A00083Q00122Q000B00CE012Q00122Q000C00CF015Q000A000C00026Q0009000A00122Q000900D0015Q000A00083Q00122Q000B00D1012Q00122Q000C00D2015Q000A000C00026Q0009000A00122Q000900D3015Q000A00083Q00122Q000B00D4012Q00122Q000C00D5015Q000A000C00026Q0009000A00122Q000900D6015Q000A00083Q00122Q000B00D7012Q00122Q000C00D8015Q000A000C00026Q0009000A00122Q000900D9015Q000A00083Q00122Q000B00DA012Q00122Q000C00DB015Q000A000C00026Q0009000A00122Q000900DC015Q000A00083Q00122Q000B00DD012Q00122Q000C00DE015Q000A000C00026Q0009000A00122Q000900DF015Q000A00083Q00122Q000B00E0012Q00122Q000C00E1015Q000A000C00026Q0009000A00122Q000900E2015Q000A00083Q00122Q000B00E3012Q00122Q000C00E4015Q000A000C00026Q0009000A00122Q000900E5015Q000A00083Q00122Q000B00E6012Q00122Q000C00E7015Q000A000C00026Q0009000A00122Q000900E8015Q000A00083Q00122Q000B00E9012Q00122Q000C00EA015Q000A000C00026Q0009000A00122Q000900EB015Q000A00083Q00122Q000B00EC012Q00122Q000C00ED015Q000A000C00026Q0009000A00122Q000900EE015Q000A00083Q00122Q000B00EF012Q00122Q000C00F0015Q000A000C00026Q0009000A001271000900F1013Q00BB000A00083Q00122Q000B00F2012Q00122Q000C00F3015Q000A000C00026Q0009000A00122Q000900F4015Q000A00083Q00122Q000B00F5012Q00122Q000C00F6015Q000A000C00026Q0009000A00122Q000900F7015Q000A00083Q00122Q000B00F8012Q00122Q000C00F9015Q000A000C00026Q0009000A00122Q000900FA015Q000A00083Q00122Q000B00FB012Q00122Q000C00FC015Q000A000C00026Q0009000A00122Q000900FD015Q000A00083Q00122Q000B00FE012Q00122Q000C00FF015Q000A000C00026Q0009000A00122Q00092Q00025Q000A00083Q00122Q000B0001022Q00122Q000C002Q025Q000A000C00026Q0009000A00122Q00090003025Q000A00083Q00122Q000B0004022Q00122Q000C0005025Q000A000C00026Q0009000A00122Q00090006025Q000A00083Q00122Q000B0007022Q00122Q000C0008025Q000A000C00026Q0009000A00122Q00090009025Q000A00083Q00122Q000B000A022Q00122Q000C000B025Q000A000C00026Q0009000A00122Q0009000C025Q000A00083Q00122Q000B000D022Q00122Q000C000E025Q000A000C00026Q0009000A00122Q0009000F025Q000A00083Q00122Q000B0010022Q00122Q000C0011025Q000A000C00026Q0009000A00122Q00090012025Q000A00083Q00122Q000B0013022Q00122Q000C0014025Q000A000C00026Q0009000A00122Q00090015025Q000A00083Q00122Q000B0016022Q00122Q000C0017025Q000A000C00026Q0009000A00122Q00090018025Q000A00083Q00122Q000B0019022Q001271000C001A023Q008C000A000C00026Q0009000A00122Q0009001B025Q000A00083Q00122Q000B001C022Q00122Q000C001D025Q000A000C00026Q0009000A00122Q0009001E025Q000A00083Q00122Q000B001F022Q00122Q000C0020025Q000A000C00026Q0009000A00122Q00090021025Q000A00083Q00122Q000B0022022Q00122Q000C0023025Q000A000C00026Q0009000A00122Q00090024025Q000A00083Q00122Q000B0025022Q00122Q000C0026025Q000A000C00026Q0009000A00122Q00090027025Q000A00083Q00122Q000B0028022Q00122Q000C0029025Q000A000C00026Q0009000A00122Q0009002A025Q000A00083Q00122Q000B002B022Q00122Q000C002C025Q000A000C00026Q0009000A00122Q0009002D025Q000A00083Q00122Q000B002E022Q00122Q000C002F025Q000A000C00026Q0009000A00122Q00090030025Q000A00083Q00122Q000B0031022Q00122Q000C0032025Q000A000C00026Q0009000A00122Q00090033025Q000A00083Q00122Q000B0034022Q00122Q000C0035025Q000A000C00026Q0009000A00122Q00090036025Q000A00083Q00122Q000B0037022Q00122Q000C0038025Q000A000C00026Q0009000A00122Q00090039025Q000A00083Q00122Q000B003A022Q00122Q000C003B025Q000A000C00026Q0009000A00122Q0009003C025Q000A00083Q00122Q000B003D022Q00122Q000C003E025Q000A000C00026Q0009000A00122Q0009003F025Q000A00083Q00122Q000B0040022Q00122Q000C0041025Q000A000C00026Q0009000A00127100090042023Q00BB000A00083Q00122Q000B0043022Q00122Q000C0044025Q000A000C00026Q0009000A00122Q00090045025Q000A00083Q00122Q000B0046022Q00122Q000C0047025Q000A000C00026Q0009000A00122Q00090048025Q000A00083Q00122Q000B0049022Q00122Q000C004A025Q000A000C00026Q0009000A00122Q0009004B025Q000A00083Q00122Q000B004C022Q00122Q000C004D025Q000A000C00026Q0009000A00122Q0009004E025Q000A00083Q00122Q000B004F022Q00122Q000C0050025Q000A000C00026Q0009000A00122Q00090051025Q000A00083Q00122Q000B0052022Q00122Q000C0053025Q000A000C00026Q0009000A00122Q00090054025Q000A00083Q00122Q000B0055022Q00122Q000C0056025Q000A000C00026Q0009000A00122Q00090057025Q000A00083Q00122Q000B0058022Q00122Q000C0059025Q000A000C00026Q0009000A00122Q0009005A025Q000A00083Q00122Q000B005B022Q00122Q000C005C025Q000A000C00026Q0009000A00122Q0009005D025Q000A00083Q00122Q000B005E022Q00122Q000C005F025Q000A000C00026Q0009000A00122Q00090060025Q000A00083Q00122Q000B0061022Q00122Q000C0062025Q000A000C00026Q0009000A00122Q00090063025Q000A00083Q00122Q000B0064022Q00122Q000C0065025Q000A000C00026Q0009000A00122Q00090066025Q000A00083Q00122Q000B0067022Q00122Q000C0068025Q000A000C00026Q0009000A00122Q00090069025Q000A00083Q00122Q000B006A022Q001271000C006B023Q008C000A000C00026Q0009000A00122Q0009006C025Q000A00083Q00122Q000B006D022Q00122Q000C006E025Q000A000C00026Q0009000A00122Q0009006F025Q000A00083Q00122Q000B0070022Q00122Q000C0071025Q000A000C00026Q0009000A00122Q00090072025Q000A00083Q00122Q000B0073022Q00122Q000C0074025Q000A000C00026Q0009000A00122Q00090075025Q000A00083Q00122Q000B0076022Q00122Q000C0077025Q000A000C00026Q0009000A00122Q00090078025Q000A00083Q00122Q000B0079022Q00122Q000C007A025Q000A000C00026Q0009000A00122Q0009007B025Q000A00083Q00122Q000B007C022Q00122Q000C007D025Q000A000C00026Q0009000A00122Q0009007E025Q000A00083Q00122Q000B007F022Q00122Q000C0080025Q000A000C00026Q0009000A00122Q00090081025Q000A00083Q00122Q000B0082022Q00122Q000C0083025Q000A000C00026Q0009000A00122Q00090084025Q000A00083Q00122Q000B0085022Q00122Q000C0086025Q000A000C00026Q0009000A00122Q00090087025Q000A00083Q00122Q000B0088022Q00122Q000C0089025Q000A000C00026Q0009000A00122Q0009008A025Q000A00083Q00122Q000B008B022Q00122Q000C008C025Q000A000C00026Q0009000A00122Q0009008D025Q000A00083Q00122Q000B008E022Q00122Q000C008F025Q000A000C00026Q0009000A00122Q00090090025Q000A00083Q00122Q000B0091022Q00122Q000C0092025Q000A000C00026Q0009000A00127100090093023Q00BB000A00083Q00122Q000B0094022Q00122Q000C0095025Q000A000C00026Q0009000A00122Q00090096025Q000A00083Q00122Q000B0097022Q00122Q000C0098025Q000A000C00026Q0009000A00122Q00090099025Q000A00083Q00122Q000B009A022Q00122Q000C009B025Q000A000C00026Q0009000A00122Q0009009C025Q000A00083Q00122Q000B009D022Q00122Q000C009E025Q000A000C00026Q0009000A00122Q0009009F025Q000A00083Q00122Q000B00A0022Q00122Q000C00A1025Q000A000C00026Q0009000A00122Q000900A2025Q000A00083Q00122Q000B00A3022Q00122Q000C00A4025Q000A000C00026Q0009000A00122Q000900A5025Q000A00083Q00122Q000B00A6022Q00122Q000C00A7025Q000A000C00026Q0009000A00122Q000900A8025Q000A00083Q00122Q000B00A9022Q00122Q000C00AA025Q000A000C00026Q0009000A00122Q000900AB025Q000A00083Q00122Q000B00AC022Q00122Q000C00AD025Q000A000C00026Q0009000A00122Q000900AE025Q000A00083Q00122Q000B00AF022Q00122Q000C00B0025Q000A000C00026Q0009000A00122Q000900B1025Q000A00083Q00122Q000B00B2022Q00122Q000C00B3025Q000A000C00026Q0009000A00122Q000900B4025Q000A00083Q00122Q000B00B5022Q00122Q000C00B6025Q000A000C00026Q0009000A00122Q000900B7025Q000A00083Q00122Q000B00B8022Q00122Q000C00B9025Q000A000C00026Q0009000A00122Q000900BA025Q000A00083Q00122Q000B00BB022Q001271000C00BC023Q008C000A000C00026Q0009000A00122Q000900BD025Q000A00083Q00122Q000B00BE022Q00122Q000C00BF025Q000A000C00026Q0009000A00122Q000900C0025Q000A00083Q00122Q000B00C1022Q00122Q000C00C2025Q000A000C00026Q0009000A00122Q000900C3025Q000A00083Q00122Q000B00C4022Q00122Q000C00C5025Q000A000C00026Q0009000A00122Q000900C6025Q000A00083Q00122Q000B00C7022Q00122Q000C00C8025Q000A000C00026Q0009000A00122Q000900C9025Q000A00083Q00122Q000B00CA022Q00122Q000C00CB025Q000A000C00026Q0009000A00122Q000900CC025Q000A00083Q00122Q000B00CD022Q00122Q000C00CE025Q000A000C00026Q0009000A00122Q000900CF025Q000A00083Q00122Q000B00D0022Q00122Q000C00D1025Q000A000C00026Q0009000A00122Q000900D2025Q000A00083Q00122Q000B00D3022Q00122Q000C00D4025Q000A000C00026Q0009000A00122Q000900D5025Q000A00083Q00122Q000B00D6022Q00122Q000C00D7025Q000A000C00026Q0009000A00122Q000900D8025Q000A00083Q00122Q000B00D9022Q00122Q000C00DA025Q000A000C00026Q0009000A00122Q000900DB025Q000A00083Q00122Q000B00DC022Q00122Q000C00DD025Q000A000C00026Q0009000A00122Q000900DE025Q000A00083Q00122Q000B00DF022Q00122Q000C00E0025Q000A000C00026Q0009000A00122Q000900E1025Q000A00083Q00122Q000B00E2022Q00122Q000C00E3025Q000A000C00026Q0009000A001271000900E4023Q00BB000A00083Q00122Q000B00E5022Q00122Q000C00E6025Q000A000C00026Q0009000A00122Q000900E7025Q000A00083Q00122Q000B00E8022Q00122Q000C00E9025Q000A000C00026Q0009000A00122Q000900EA025Q000A00083Q00122Q000B00EB022Q00122Q000C00EC025Q000A000C00026Q0009000A00122Q000900ED025Q000A00083Q00122Q000B00EE022Q00122Q000C00EF025Q000A000C00026Q0009000A00122Q000900F0025Q000A00083Q00122Q000B00F1022Q00122Q000C00F2025Q000A000C00026Q0009000A00122Q000900F3025Q000A00083Q00122Q000B00F4022Q00122Q000C00F5025Q000A000C00026Q0009000A00122Q000900F6025Q000A00083Q00122Q000B00F7022Q00122Q000C00F8025Q000A000C00026Q0009000A00122Q000900F9025Q000A00083Q00122Q000B00FA022Q00122Q000C00FB025Q000A000C00026Q0009000A00122Q000900FC025Q000A00083Q00122Q000B00FD022Q00122Q000C00FE025Q000A000C00026Q0009000A00122Q000900FF025Q000A00083Q00122Q000B2Q00032Q00122Q000C0001035Q000A000C00026Q0009000A00122Q00090002035Q000A00083Q00122Q000B002Q032Q00122Q000C0004035Q000A000C00026Q0009000A00122Q00090005035Q000A00083Q00122Q000B0006032Q00122Q000C0007035Q000A000C00026Q0009000A00122Q00090008035Q000A00083Q00122Q000B0009032Q00122Q000C000A035Q000A000C00026Q0009000A00122Q0009000B035Q000A00083Q00122Q000B000C032Q001271000C000D033Q008C000A000C00026Q0009000A00122Q0009000E035Q000A00083Q00122Q000B000F032Q00122Q000C0010035Q000A000C00026Q0009000A00122Q00090011035Q000A00083Q00122Q000B0012032Q00122Q000C0013035Q000A000C00026Q0009000A00122Q00090014035Q000A00083Q00122Q000B0015032Q00122Q000C0016035Q000A000C00026Q0009000A00122Q00090017035Q000A00083Q00122Q000B0018032Q00122Q000C0019035Q000A000C00026Q0009000A00122Q0009001A035Q000A00083Q00122Q000B001B032Q00122Q000C001C035Q000A000C00026Q0009000A00122Q0009001D035Q000A00083Q00122Q000B001E032Q00122Q000C001F035Q000A000C00026Q0009000A00122Q00090020035Q000A00083Q00122Q000B0021032Q00122Q000C0022035Q000A000C00026Q0009000A00122Q00090023035Q000A00083Q00122Q000B0024032Q00122Q000C0025035Q000A000C00026Q0009000A00122Q00090026035Q000A00083Q00122Q000B0027032Q00122Q000C0028035Q000A000C00026Q0009000A00122Q00090029035Q000A00083Q00122Q000B002A032Q00122Q000C002B035Q000A000C00026Q0009000A00122Q0009002C035Q000A00083Q00122Q000B002D032Q00122Q000C002E035Q000A000C00026Q0009000A00122Q0009002F035Q000A00083Q00122Q000B0030032Q00122Q000C0031035Q000A000C00026Q0009000A00122Q00090032035Q000A00083Q00122Q000B0033032Q00122Q000C0034035Q000A000C00026Q0009000A00127100090035033Q00BB000A00083Q00122Q000B0036032Q00122Q000C0037035Q000A000C00026Q0009000A00122Q00090038035Q000A00083Q00122Q000B0039032Q00122Q000C003A035Q000A000C00026Q0009000A00122Q0009003B035Q000A00083Q00122Q000B003C032Q00122Q000C003D035Q000A000C00026Q0009000A00122Q0009003E035Q000A00083Q00122Q000B003F032Q00122Q000C0040035Q000A000C00026Q0009000A00122Q00090041035Q000A00083Q00122Q000B0042032Q00122Q000C0043035Q000A000C00026Q0009000A00122Q00090044035Q000A00083Q00122Q000B0045032Q00122Q000C0046035Q000A000C00026Q0009000A00122Q00090047035Q000A00083Q00122Q000B0048032Q00122Q000C0049035Q000A000C00026Q0009000A00122Q0009004A035Q000A00083Q00122Q000B004B032Q00122Q000C004C035Q000A000C00026Q0009000A00122Q0009004D035Q000A00083Q00122Q000B004E032Q00122Q000C004F035Q000A000C00026Q0009000A00122Q00090050035Q000A00083Q00122Q000B0051032Q00122Q000C0052035Q000A000C00026Q0009000A00122Q00090053035Q000A00083Q00122Q000B0054032Q00122Q000C0055035Q000A000C00026Q0009000A00122Q00090056035Q000A00083Q00122Q000B0057032Q00122Q000C0058035Q000A000C00026Q0009000A00122Q00090059035Q000A00083Q00122Q000B005A032Q00122Q000C005B035Q000A000C00026Q0009000A00122Q0009005C035Q000A00083Q00122Q000B005D032Q001271000C005E033Q008C000A000C00026Q0009000A00122Q0009005F035Q000A00083Q00122Q000B0060032Q00122Q000C0061035Q000A000C00026Q0009000A00122Q00090062035Q000A00083Q00122Q000B0063032Q00122Q000C0064035Q000A000C00026Q0009000A00122Q00090065035Q000A00083Q00122Q000B0066032Q00122Q000C0067035Q000A000C00026Q0009000A00122Q00090068035Q000A00083Q00122Q000B0069032Q00122Q000C006A035Q000A000C00026Q0009000A00122Q0009006B035Q000A00083Q00122Q000B006C032Q00122Q000C006D035Q000A000C00026Q0009000A00122Q0009006E035Q000A00083Q00122Q000B006F032Q00122Q000C0070035Q000A000C00026Q0009000A00122Q00090071035Q000A00083Q00122Q000B0072032Q00122Q000C0073035Q000A000C00026Q0009000A00122Q00090074035Q000A00083Q00122Q000B0075032Q00122Q000C0076035Q000A000C00026Q0009000A00122Q00090077035Q000A00083Q00122Q000B0078032Q00122Q000C0079035Q000A000C00026Q0009000A00122Q0009007A035Q000A00083Q00122Q000B007B032Q00122Q000C007C035Q000A000C00026Q0009000A00122Q0009007D035Q000A00083Q00122Q000B007E032Q00122Q000C007F035Q000A000C00026Q0009000A00122Q00090080035Q000A00083Q00122Q000B0081032Q00122Q000C0082035Q000A000C00026Q0009000A00122Q00090083035Q000A00083Q00122Q000B0084032Q00122Q000C0085035Q000A000C00026Q0009000A00127100090086033Q00BB000A00083Q00122Q000B0087032Q00122Q000C0088035Q000A000C00026Q0009000A00122Q00090089035Q000A00083Q00122Q000B008A032Q00122Q000C008B035Q000A000C00026Q0009000A00122Q0009008C035Q000A00083Q00122Q000B008D032Q00122Q000C008E035Q000A000C00026Q0009000A00122Q0009008F035Q000A00083Q00122Q000B0090032Q00122Q000C0091035Q000A000C00026Q0009000A00122Q00090092035Q000A00083Q00122Q000B0093032Q00122Q000C0094035Q000A000C00026Q0009000A00122Q00090095035Q000A00083Q00122Q000B0096032Q00122Q000C0097035Q000A000C00026Q0009000A00122Q00090098035Q000A00083Q00122Q000B0099032Q00122Q000C009A035Q000A000C00026Q0009000A00122Q0009009B035Q000A00083Q00122Q000B009C032Q00122Q000C009D035Q000A000C00026Q0009000A00122Q0009009E035Q000A00083Q00122Q000B009F032Q00122Q000C00A0035Q000A000C00026Q0009000A00122Q000900A1035Q000A00083Q00122Q000B00A2032Q00122Q000C00A3035Q000A000C00026Q0009000A00122Q000900A4035Q000A00083Q00122Q000B00A5032Q00122Q000C00A6035Q000A000C00026Q0009000A00122Q000900A7035Q000A00083Q00122Q000B00A8032Q00122Q000C00A9035Q000A000C00026Q0009000A00122Q000900AA035Q000A00083Q00122Q000B00AB032Q00122Q000C00AC035Q000A000C00026Q0009000A00122Q000900AD035Q000A00083Q00122Q000B00AE032Q001271000C00AF033Q008C000A000C00026Q0009000A00122Q000900B0035Q000A00083Q00122Q000B00B1032Q00122Q000C00B2035Q000A000C00026Q0009000A00122Q000900B3035Q000A00083Q00122Q000B00B4032Q00122Q000C00B5035Q000A000C00026Q0009000A00122Q000900B6035Q000A00083Q00122Q000B00B7032Q00122Q000C00B8035Q000A000C00026Q0009000A00122Q000900B9035Q000A00083Q00122Q000B00BA032Q00122Q000C00BB035Q000A000C00026Q0009000A00122Q000900BC035Q000A00083Q00122Q000B00BD032Q00122Q000C00BE035Q000A000C00026Q0009000A00122Q000900BF035Q000A00083Q00122Q000B00C0032Q00122Q000C00C1035Q000A000C00026Q0009000A00122Q000900C2035Q000A00083Q00122Q000B00C3032Q00122Q000C00C4035Q000A000C00026Q0009000A00122Q000900C5035Q000A00083Q00122Q000B00C6032Q00122Q000C00C7035Q000A000C00026Q0009000A00122Q000900C8035Q000A00083Q00122Q000B00C9032Q00122Q000C00CA035Q000A000C00026Q0009000A00122Q000900CB035Q000A00083Q00122Q000B00CC032Q00122Q000C00CD035Q000A000C00026Q0009000A00122Q000900CE035Q000A00083Q00122Q000B00CF032Q00122Q000C00D0035Q000A000C00026Q0009000A00122Q000900D1035Q000A00083Q00122Q000B00D2032Q00122Q000C00D3035Q000A000C00026Q0009000A00122Q000900D4035Q000A00083Q00122Q000B00D5032Q00122Q000C00D6035Q000A000C00026Q0009000A001271000900D7033Q00BB000A00083Q00122Q000B00D8032Q00122Q000C00D9035Q000A000C00026Q0009000A00122Q000900DA035Q000A00083Q00122Q000B00DB032Q00122Q000C00DC035Q000A000C00026Q0009000A00122Q000900DD035Q000A00083Q00122Q000B00DE032Q00122Q000C00DF035Q000A000C00026Q0009000A00122Q000900E0035Q000A00083Q00122Q000B00E1032Q00122Q000C00E2035Q000A000C00026Q0009000A00122Q000900E3035Q000A00083Q00122Q000B00E4032Q00122Q000C00E5035Q000A000C00026Q0009000A00122Q000900E6035Q000A00083Q00122Q000B00E7032Q00122Q000C00E8035Q000A000C00026Q0009000A00122Q000900E9035Q000A00083Q00122Q000B00EA032Q00122Q000C00EB035Q000A000C00026Q0009000A00122Q000900EC035Q000A00083Q00122Q000B00ED032Q00122Q000C00EE035Q000A000C00026Q0009000A00122Q000900EF035Q000A00083Q00122Q000B00F0032Q00122Q000C00F1035Q000A000C00026Q0009000A00122Q000900F2035Q000A00083Q00122Q000B00F3032Q00122Q000C00F4035Q000A000C00026Q0009000A00122Q000900F5035Q000A00083Q00122Q000B00F6032Q00122Q000C00F7035Q000A000C00026Q0009000A00122Q000900F8035Q000A00083Q00122Q000B00F9032Q00122Q000C00FA035Q000A000C00026Q0009000A00122Q000900FB035Q000A00083Q00122Q000B00FC032Q00122Q000C00FD035Q000A000C00026Q0009000A00122Q000900FE035Q000A00083Q00122Q000B00FF032Q001271000C2Q00043Q008C000A000C00026Q0009000A00122Q00090001045Q000A00083Q00122Q000B0002042Q00122Q000C0003045Q000A000C00026Q0009000A00122Q0009002Q045Q000A00083Q00122Q000B0005042Q00122Q000C0006045Q000A000C00026Q0009000A00122Q00090007045Q000A00083Q00122Q000B0008042Q00122Q000C0009045Q000A000C00026Q0009000A00122Q0009000A045Q000A00083Q00122Q000B000B042Q00122Q000C000C045Q000A000C00026Q0009000A00122Q0009000D045Q000A00083Q00122Q000B000E042Q00122Q000C000F045Q000A000C00026Q0009000A00122Q00090010045Q000A00083Q00122Q000B0011042Q00122Q000C0012045Q000A000C00026Q0009000A00122Q00090013045Q000A00083Q00122Q000B0014042Q00122Q000C0015045Q000A000C00026Q0009000A00122Q00090016045Q000A00083Q00122Q000B0017042Q00122Q000C0018045Q000A000C00026Q0009000A00122Q00090019045Q000A00083Q00122Q000B001A042Q00122Q000C001B045Q000A000C00026Q0009000A00122Q0009001C045Q000A00083Q00122Q000B001D042Q00122Q000C001E045Q000A000C00026Q0009000A00122Q0009001F045Q000A00083Q00122Q000B0020042Q00122Q000C0021045Q000A000C00026Q0009000A00122Q00090022045Q000A00083Q00122Q000B0023042Q00122Q000C0024045Q000A000C00026Q0009000A00122Q00090025045Q000A00083Q00122Q000B0026042Q00122Q000C0027045Q000A000C00026Q0009000A00127100090028043Q00BB000A00083Q00122Q000B0029042Q00122Q000C002A045Q000A000C00026Q0009000A00122Q0009002B045Q000A00083Q00122Q000B002C042Q00122Q000C002D045Q000A000C00026Q0009000A00122Q0009002E045Q000A00083Q00122Q000B002F042Q00122Q000C0030045Q000A000C00026Q0009000A00122Q00090031045Q000A00083Q00122Q000B0032042Q00122Q000C0033045Q000A000C00026Q0009000A00122Q00090034045Q000A00083Q00122Q000B0035042Q00122Q000C0036045Q000A000C00026Q0009000A00122Q00090037045Q000A00083Q00122Q000B0038042Q00122Q000C0039045Q000A000C00026Q0009000A00122Q0009003A045Q000A00083Q00122Q000B003B042Q00122Q000C003C045Q000A000C00026Q0009000A00122Q0009003D045Q000A00083Q00122Q000B003E042Q00122Q000C003F045Q000A000C00026Q0009000A00122Q00090040045Q000A00083Q00122Q000B0041042Q00122Q000C0042045Q000A000C00026Q0009000A00122Q00090043045Q000A00083Q00122Q000B0044042Q00122Q000C0045045Q000A000C00026Q0009000A00122Q00090046045Q000A00083Q00122Q000B0047042Q00122Q000C0048045Q000A000C00026Q0009000A00122Q00090049045Q000A00083Q00122Q000B004A042Q00122Q000C004B045Q000A000C00026Q0009000A00122Q0009004C045Q000A00083Q00122Q000B004D042Q00122Q000C004E045Q000A000C00026Q0009000A00122Q0009004F045Q000A00083Q00122Q000B0050042Q001271000C0051043Q008C000A000C00026Q0009000A00122Q00090052045Q000A00083Q00122Q000B0053042Q00122Q000C0054045Q000A000C00026Q0009000A00122Q00090055045Q000A00083Q00122Q000B0056042Q00122Q000C0057045Q000A000C00026Q0009000A00122Q00090058045Q000A00083Q00122Q000B0059042Q00122Q000C005A045Q000A000C00026Q0009000A00122Q0009005B045Q000A00083Q00122Q000B005C042Q00122Q000C005D045Q000A000C00026Q0009000A00122Q0009005E045Q000A00083Q00122Q000B005F042Q00122Q000C0060045Q000A000C00026Q0009000A00122Q00090061045Q000A00083Q00122Q000B0062042Q00122Q000C0063045Q000A000C00026Q0009000A00122Q00090064045Q000A00083Q00122Q000B0065042Q00122Q000C0066045Q000A000C00026Q0009000A00122Q00090067045Q000A00083Q00122Q000B0068042Q00122Q000C0069045Q000A000C00026Q0009000A00122Q0009006A045Q000A00083Q00122Q000B006B042Q00122Q000C006C045Q000A000C00026Q0009000A00122Q0009006D045Q000A00083Q00122Q000B006E042Q00122Q000C006F045Q000A000C00026Q0009000A00122Q00090070045Q000A00083Q00122Q000B0071042Q00122Q000C0072045Q000A000C00026Q0009000A00122Q00090073045Q000A00083Q00122Q000B0074042Q00122Q000C0075045Q000A000C00026Q0009000A00122Q00090076045Q000A00083Q00122Q000B0077042Q00122Q000C0078045Q000A000C00026Q0009000A00127100090079043Q00BB000A00083Q00122Q000B007A042Q00122Q000C007B045Q000A000C00026Q0009000A00122Q0009007C045Q000A00083Q00122Q000B007D042Q00122Q000C007E045Q000A000C00026Q0009000A00122Q0009007F045Q000A00083Q00122Q000B0080042Q00122Q000C0081045Q000A000C00026Q0009000A00122Q00090082045Q000A00083Q00122Q000B0083042Q00122Q000C0084045Q000A000C00026Q0009000A00122Q00090085045Q000A00083Q00122Q000B0086042Q00122Q000C0087045Q000A000C00026Q0009000A00122Q00090088045Q000A00083Q00122Q000B0089042Q00122Q000C008A045Q000A000C00026Q0009000A00122Q0009008B045Q000A00083Q00122Q000B008C042Q00122Q000C008D045Q000A000C00026Q0009000A00122Q0009008E045Q000A00083Q00122Q000B008F042Q00122Q000C0090045Q000A000C00026Q0009000A00122Q00090091045Q000A00083Q00122Q000B0092042Q00122Q000C0093045Q000A000C00026Q0009000A00122Q00090094045Q000A00083Q00122Q000B0095042Q00122Q000C0096045Q000A000C00026Q0009000A00122Q00090097045Q000A00083Q00122Q000B0098042Q00122Q000C0099045Q000A000C00026Q0009000A00122Q0009009A045Q000A00083Q00122Q000B009B042Q00122Q000C009C045Q000A000C00026Q0009000A00122Q0009009D045Q000A00083Q00122Q000B009E042Q00122Q000C009F045Q000A000C00026Q0009000A00122Q000900A0045Q000A00083Q00122Q000B00A1042Q001271000C00A2043Q008C000A000C00026Q0009000A00122Q000900A3045Q000A00083Q00122Q000B00A4042Q00122Q000C00A5045Q000A000C00026Q0009000A00122Q000900A6045Q000A00083Q00122Q000B00A7042Q00122Q000C00A8045Q000A000C00026Q0009000A00122Q000900A9045Q000A00083Q00122Q000B00AA042Q00122Q000C00AB045Q000A000C00026Q0009000A00122Q000900AC045Q000A00083Q00122Q000B00AD042Q00122Q000C00AE045Q000A000C00026Q0009000A00122Q000900AF045Q000A00083Q00122Q000B00B0042Q00122Q000C00B1045Q000A000C00026Q0009000A00122Q000900B2045Q000A00083Q00122Q000B00B3042Q00122Q000C00B4045Q000A000C00026Q0009000A00122Q000900B5045Q000A00083Q00122Q000B00B6042Q00122Q000C00B7045Q000A000C00026Q0009000A00122Q000900B8045Q000A00083Q00122Q000B00B9042Q00122Q000C00BA045Q000A000C00026Q0009000A00122Q000900BB045Q000A00083Q00122Q000B00BC042Q00122Q000C00BD045Q000A000C00026Q0009000A00122Q000900BE045Q000A00083Q00122Q000B00BF042Q00122Q000C00C0045Q000A000C00026Q0009000A00122Q000900C1045Q000A00083Q00122Q000B00C2042Q00122Q000C00C3045Q000A000C00026Q0009000A00122Q000900C4045Q000A00083Q00122Q000B00C5042Q00122Q000C00C6045Q000A000C00026Q0009000A00122Q000900C7045Q000A00083Q00122Q000B00C8042Q00122Q000C00C9045Q000A000C00026Q0009000A001271000900CA043Q00BB000A00083Q00122Q000B00CB042Q00122Q000C00CC045Q000A000C00026Q0009000A00122Q000900CD045Q000A00083Q00122Q000B00CE042Q00122Q000C00CF045Q000A000C00026Q0009000A00122Q000900D0045Q000A00083Q00122Q000B00D1042Q00122Q000C00D2045Q000A000C00026Q0009000A00122Q000900D3045Q000A00083Q00122Q000B00D4042Q00122Q000C00D5045Q000A000C00026Q0009000A00122Q000900D6045Q000A00083Q00122Q000B00D7042Q00122Q000C00D8045Q000A000C00026Q0009000A00122Q000900D9045Q000A00083Q00122Q000B00DA042Q00122Q000C00DB045Q000A000C00026Q0009000A00122Q000900DC045Q000A00083Q00122Q000B00DD042Q00122Q000C00DE045Q000A000C00026Q0009000A00122Q000900DF045Q000A00083Q00122Q000B00E0042Q00122Q000C00E1045Q000A000C00026Q0009000A00122Q000900E2045Q000A00083Q00122Q000B00E3042Q00122Q000C00E4045Q000A000C00026Q0009000A00122Q000900E5045Q000A00083Q00122Q000B00E6042Q00122Q000C00E7045Q000A000C00026Q0009000A00122Q000900E8045Q000A00083Q00122Q000B00E9042Q00122Q000C00EA045Q000A000C00026Q0009000A00122Q000900EB045Q000A00083Q00122Q000B00EC042Q00122Q000C00ED045Q000A000C00026Q0009000A00122Q000900EE045Q000A00083Q00122Q000B00EF042Q00122Q000C00F0045Q000A000C00026Q0009000A00122Q000900F1045Q000A00083Q00122Q000B00F2042Q001271000C00F3043Q008C000A000C00026Q0009000A00122Q000900F4045Q000A00083Q00122Q000B00F5042Q00122Q000C00F6045Q000A000C00026Q0009000A00122Q000900F7045Q000A00083Q00122Q000B00F8042Q00122Q000C00F9045Q000A000C00026Q0009000A00122Q000900FA045Q000A00083Q00122Q000B00FB042Q00122Q000C00FC045Q000A000C00026Q0009000A00122Q000900FD045Q000A00083Q00122Q000B00FE042Q00122Q000C00FF045Q000A000C00026Q0009000A00122Q00092Q00055Q000A00083Q00122Q000B0001052Q00122Q000C0002055Q000A000C00026Q0009000A00122Q00090003055Q000A00083Q00122Q000B0004052Q00122Q000C002Q055Q000A000C00026Q0009000A00122Q00090006055Q000A00083Q00122Q000B0007052Q00122Q000C0008055Q000A000C00026Q0009000A00122Q00090009055Q000A00083Q00122Q000B000A052Q00122Q000C000B055Q000A000C00026Q0009000A00122Q0009000C055Q000A00083Q00122Q000B000D052Q00122Q000C000E055Q000A000C00026Q0009000A00122Q0009000F055Q000A00083Q00122Q000B0010052Q00122Q000C0011055Q000A000C00026Q0009000A00122Q00090012055Q000A00083Q00122Q000B0013052Q00122Q000C0014055Q000A000C00026Q0009000A00122Q00090015055Q000A00083Q00122Q000B0016052Q00122Q000C0017055Q000A000C00026Q0009000A00122Q00090018055Q000A00083Q00122Q000B0019052Q00122Q000C001A055Q000A000C00026Q0009000A0012710009001B053Q00BB000A00083Q00122Q000B001C052Q00122Q000C001D055Q000A000C00026Q0009000A00122Q0009001E055Q000A00083Q00122Q000B001F052Q00122Q000C0020055Q000A000C00026Q0009000A00122Q00090021055Q000A00083Q00122Q000B0022052Q00122Q000C0023055Q000A000C00026Q0009000A00122Q00090024055Q000A00083Q00122Q000B0025052Q00122Q000C0026055Q000A000C00026Q0009000A00122Q00090027055Q000A00083Q00122Q000B0028052Q00122Q000C0029055Q000A000C00026Q0009000A00122Q0009002A055Q000A00083Q00122Q000B002B052Q00122Q000C002C055Q000A000C00026Q0009000A00122Q0009002D055Q000A00083Q00122Q000B002E052Q00122Q000C002F055Q000A000C00026Q0009000A00122Q00090030055Q000A00083Q00122Q000B0031052Q00122Q000C0032055Q000A000C00026Q0009000A00122Q00090033055Q000A00083Q00122Q000B0034052Q00122Q000C0035055Q000A000C00026Q0009000A00122Q00090036055Q000A00083Q00122Q000B0037052Q00122Q000C0038055Q000A000C00026Q0009000A00122Q00090039055Q000A00083Q00122Q000B003A052Q00122Q000C003B055Q000A000C00026Q0009000A00122Q0009003C055Q000A00083Q00122Q000B003D052Q00122Q000C003E055Q000A000C00026Q0009000A00122Q0009003F055Q000A00083Q00122Q000B0040052Q00122Q000C0041055Q000A000C00026Q0009000A00122Q00090042055Q000A00083Q00122Q000B0043052Q001271000C0044053Q008C000A000C00026Q0009000A00122Q00090045055Q000A00083Q00122Q000B0046052Q00122Q000C0047055Q000A000C00026Q0009000A00122Q00090048055Q000A00083Q00122Q000B0049052Q00122Q000C004A055Q000A000C00026Q0009000A00122Q0009004B055Q000A00083Q00122Q000B004C052Q00122Q000C004D055Q000A000C00026Q0009000A00122Q0009004E055Q000A00083Q00122Q000B004F052Q00122Q000C0050055Q000A000C00026Q0009000A00122Q00090051055Q000A00083Q00122Q000B0052052Q00122Q000C0053055Q000A000C00026Q0009000A00122Q00090054055Q000A00083Q00122Q000B0055052Q00122Q000C0056055Q000A000C00026Q0009000A00122Q00090057055Q000A00083Q00122Q000B0058052Q00122Q000C0059055Q000A000C00026Q0009000A00122Q0009005A055Q000A00083Q00122Q000B005B052Q00122Q000C005C055Q000A000C00026Q0009000A00122Q0009005D055Q000A00083Q00122Q000B005E052Q00122Q000C005F055Q000A000C00026Q0009000A00122Q00090060055Q000A00083Q00122Q000B0061052Q00122Q000C0062055Q000A000C00026Q0009000A00122Q00090063055Q000A00083Q00122Q000B0064052Q00122Q000C0065055Q000A000C00026Q0009000A00122Q00090066055Q000A00083Q00122Q000B0067052Q00122Q000C0068055Q000A000C00026Q0009000A00122Q00090069055Q000A00083Q00122Q000B006A052Q00122Q000C006B055Q000A000C00026Q0009000A0012710009006C053Q00BB000A00083Q00122Q000B006D052Q00122Q000C006E055Q000A000C00026Q0009000A00122Q0009006F055Q000A00083Q00122Q000B0070052Q00122Q000C0071055Q000A000C00026Q0009000A00122Q00090072055Q000A00083Q00122Q000B0073052Q00122Q000C0074055Q000A000C00026Q0009000A00122Q00090075055Q000A00083Q00122Q000B0076052Q00122Q000C0077055Q000A000C00026Q0009000A00122Q00090078055Q000A00083Q00122Q000B0079052Q00122Q000C007A055Q000A000C00026Q0009000A00122Q0009007B055Q000A00083Q00122Q000B007C052Q00122Q000C007D055Q000A000C00026Q0009000A00122Q0009007E055Q000A00083Q00122Q000B007F052Q00122Q000C0080055Q000A000C00026Q0009000A00122Q00090081055Q000A00083Q00122Q000B0082052Q00122Q000C0083055Q000A000C00026Q0009000A00122Q00090084055Q000A00083Q00122Q000B0085052Q00122Q000C0086055Q000A000C00026Q0009000A00122Q00090087055Q000A00083Q00122Q000B0088052Q00122Q000C0089055Q000A000C00026Q0009000A00122Q0009008A055Q000A00083Q00122Q000B008B052Q00122Q000C008C055Q000A000C00026Q0009000A00122Q0009008D055Q000A00083Q00122Q000B008E052Q00122Q000C008F055Q000A000C00026Q0009000A00122Q00090090055Q000A00083Q00122Q000B0091052Q00122Q000C0092055Q000A000C00026Q0009000A00122Q00090093055Q000A00083Q00122Q000B0094052Q001271000C0095053Q008C000A000C00026Q0009000A00122Q00090096055Q000A00083Q00122Q000B0097052Q00122Q000C0098055Q000A000C00026Q0009000A00122Q00090099055Q000A00083Q00122Q000B009A052Q00122Q000C009B055Q000A000C00026Q0009000A00122Q0009009C055Q000A00083Q00122Q000B009D052Q00122Q000C009E055Q000A000C00026Q0009000A00122Q0009009F055Q000A00083Q00122Q000B00A0052Q00122Q000C00A1055Q000A000C00026Q0009000A00122Q000900A2055Q000A00083Q00122Q000B00A3052Q00122Q000C00A4055Q000A000C00026Q0009000A00122Q000900A5055Q000A00083Q00122Q000B00A6052Q00122Q000C00A7055Q000A000C00026Q0009000A00122Q000900A8055Q000A00083Q00122Q000B00A9052Q00122Q000C00AA055Q000A000C00026Q0009000A00122Q000900AB055Q000A00083Q00122Q000B00AC052Q00122Q000C00AD055Q000A000C00026Q0009000A00122Q000900AE055Q000A00083Q00122Q000B00AF052Q00122Q000C00B0055Q000A000C00026Q0009000A00122Q000900B1055Q000A00083Q00122Q000B00B2052Q00122Q000C00B3055Q000A000C00026Q0009000A00122Q000900B4055Q000A00083Q00122Q000B00B5052Q00122Q000C00B6055Q000A000C00026Q0009000A00122Q000900B7055Q000A00083Q00122Q000B00B8052Q00122Q000C00B9055Q000A000C00026Q0009000A00122Q000900BA055Q000A00083Q00122Q000B00BB052Q00122Q000C00BC055Q000A000C00026Q0009000A001271000900BD053Q0029000A00083Q001271000B00BE052Q001271000C00BF053Q0019000A000C00022Q008E3Q0009000A001271000900C0053Q0029000A00083Q001271000B00C1052Q001271000C00C2053Q0019000A000C00022Q00AF3Q0009000A00122Q000900C3055Q000A00083Q00122Q000B00C4052Q00122Q000C00C5055Q000A000C00026Q0009000A00122Q000900C3055Q000A000A3Q001271000B00C3052Q0006520009003D0B01000B00044Q003D0B01001271000B00C3052Q001271000C00C3052Q000652000B00410B01000C00044Q00410B012Q00B1000C3Q0023001271000D00C3053Q003A000D3Q000D2Q00B1000E3Q0002001271000F00C0053Q003A000F3Q000F2Q00DA00103Q000500122Q001100BD055Q00113Q00114Q001200013Q00122Q001300BA055Q00133Q00134Q0012000100012Q008E00100011001200120D001100B7055Q00113Q00114Q001200013Q00122Q001300B4055Q00133Q00134Q0012000100012Q008E00100011001200120D001100B1055Q00113Q00114Q001200013Q00122Q001300AE055Q00133Q00134Q0012000100012Q008E00100011001200120D001100AB055Q00113Q00114Q001200013Q00122Q001300A8055Q00133Q00134Q0012000100012Q008E00100011001200120D001100A5055Q00113Q00114Q001200013Q00122Q001300A2055Q00133Q00134Q0012000100012Q008E0010001100122Q0060000E000F001000122Q000F009F055Q000F3Q000F00122Q0010009C055Q00103Q00104Q000E000F00104Q000C000D000E00122Q000D0099055Q000D3Q000D4Q000E3Q0002001271000F0096053Q003A000F3Q000F2Q00DA00103Q000200122Q00110093055Q00113Q00114Q001200013Q00122Q00130090055Q00133Q00134Q0012000100012Q008E00100011001200120D0011008D055Q00113Q00114Q001200013Q00122Q0013008A055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0087055Q000F3Q000F00122Q001000C6055Q000E000F00104Q000C000D000E00122Q000D0084055Q000D3Q000D4Q000E3Q000200122Q000F0081053Q003A000F3Q000F2Q00DA00103Q000100122Q0011007E055Q00113Q00114Q001200013Q00122Q0013007B055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0078055Q000F3Q000F00122Q001000C6055Q000E000F00104Q000C000D000E00122Q000D0075055Q000D3Q000D4Q000E3Q000200122Q000F0072053Q003A000F3Q000F2Q00DA00103Q000300122Q0011006F055Q00113Q00114Q001200013Q00122Q0013006C055Q00133Q00134Q0012000100012Q008E00100011001200120D00110069055Q00113Q00114Q001200013Q00122Q00130066055Q00133Q00134Q0012000100012Q008E00100011001200120D00110063055Q00113Q00114Q001200013Q00122Q00130060055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F005D055Q000F3Q000F00122Q001000C6055Q000E000F00104Q000C000D000E00122Q000D005A055Q000D3Q000D4Q000E3Q000200122Q000F0057053Q003A000F3Q000F2Q00DA00103Q000100122Q00110054055Q00113Q00114Q001200013Q00122Q00130051055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F004E055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D004B055Q000D3Q000D4Q000E3Q000200122Q000F0048053Q003A000F3Q000F2Q00DA00103Q000200122Q00110045055Q00113Q00114Q001200013Q00122Q00130042055Q00133Q00134Q0012000100012Q008E00100011001200120D0011003F055Q00113Q00114Q001200013Q00122Q0013003C055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0039055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0036055Q000D3Q000D4Q000E3Q000200122Q000F0033053Q003A000F3Q000F2Q00DA00103Q000100122Q00110030055Q00113Q00114Q001200013Q00122Q0013002D055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F002A055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0027055Q000D3Q000D4Q000E3Q000200122Q000F0024053Q003A000F3Q000F2Q00DA00103Q000100122Q00110021055Q00113Q00114Q001200013Q00122Q0013001E055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F001B055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0018055Q000D3Q000D4Q000E3Q000200122Q000F0015053Q003A000F3Q000F2Q00DA00103Q000100122Q00110012055Q00113Q00114Q001200013Q00122Q0013000F055Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F000C055Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0009055Q000D3Q000D4Q000E3Q000200122Q000F0006053Q003A000F3Q000F2Q00DA00103Q000400122Q00110003055Q00113Q00114Q001200013Q00122Q00132Q00055Q00133Q00134Q0012000100012Q008E00100011001200120D001100FD045Q00113Q00114Q001200013Q00122Q001300FA045Q00133Q00134Q0012000100012Q008E00100011001200120D001100F7045Q00113Q00114Q001200013Q00122Q001300F4045Q00133Q00134Q0012000100012Q008E00100011001200120D001100F1045Q00113Q00114Q001200013Q00122Q001300EE045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00EB045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00E8045Q000D3Q000D4Q000E3Q000200122Q000F00E5043Q003A000F3Q000F2Q00DA00103Q000100122Q001100E2045Q00113Q00114Q001200013Q00122Q001300DF045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00DC045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00D9045Q000D3Q000D4Q000E3Q000200122Q000F00D6043Q003A000F3Q000F2Q00DA00103Q000200122Q001100D3045Q00113Q00114Q001200013Q00122Q001300D0045Q00133Q00134Q0012000100012Q008E00100011001200120D001100CD045Q00113Q00114Q001200013Q00122Q001300CA045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00C7045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00C4045Q000D3Q000D4Q000E3Q000200122Q000F00C1043Q003A000F3Q000F2Q00DA00103Q000100122Q001100BE045Q00113Q00114Q001200013Q00122Q001300BB045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00B8045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00B5045Q000D3Q000D4Q000E3Q000200122Q000F00B2043Q003A000F3Q000F2Q00DA00103Q000200122Q001100AF045Q00113Q00114Q001200013Q00122Q001300AC045Q00133Q00134Q0012000100012Q008E00100011001200120D001100A9045Q00113Q00114Q001200013Q00122Q001300A6045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00A3045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D00A0045Q000D3Q000D4Q000E3Q000200122Q000F009D043Q003A000F3Q000F2Q00DA00103Q000200122Q0011009A045Q00113Q00114Q001200013Q00122Q00130097045Q00133Q00134Q0012000100012Q008E00100011001200120D00110094045Q00113Q00114Q001200013Q00122Q00130091045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F008E045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D008B045Q000D3Q000D4Q000E3Q000200122Q000F0088043Q003A000F3Q000F2Q00DA00103Q000100122Q00110085045Q00113Q00114Q001200013Q00122Q00130082045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F007F045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D007C045Q000D3Q000D4Q000E3Q000200122Q000F0079043Q003A000F3Q000F2Q00DA00103Q000200122Q00110076045Q00113Q00114Q001200013Q00122Q00130073045Q00133Q00134Q0012000100012Q008E00100011001200120D00110070045Q00113Q00114Q001200013Q00122Q0013006D045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F006A045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0067045Q000D3Q000D4Q000E3Q000200122Q000F0064043Q003A000F3Q000F2Q00DA00103Q000100122Q00110061045Q00113Q00114Q001200013Q00122Q0013005E045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F005B045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0058045Q000D3Q000D4Q000E3Q000200122Q000F0055043Q003A000F3Q000F2Q00DA00103Q000100122Q00110052045Q00113Q00114Q001200013Q00122Q0013004F045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F004C045Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D0049045Q000D3Q000D4Q000E3Q000200122Q000F0046043Q003A000F3Q000F2Q00DA00103Q000100122Q00110043045Q00113Q00114Q001200013Q00122Q00130040045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F003D045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003A045Q000D3Q000D4Q000E3Q000200122Q000F0037043Q003A000F3Q000F2Q00DA00103Q000100122Q00110034045Q00113Q00114Q001200013Q00122Q00130031045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F002E045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002B045Q000D3Q000D4Q000E3Q000200122Q000F0028043Q003A000F3Q000F2Q00DA00103Q000100122Q00110025045Q00113Q00114Q001200013Q00122Q00130022045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F001F045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D001C045Q000D3Q000D4Q000E3Q000200122Q000F0019043Q003A000F3Q000F2Q00DA00103Q000100122Q00110016045Q00113Q00114Q001200013Q00122Q00130013045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0010045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D000D045Q000D3Q000D4Q000E3Q000200122Q000F000A043Q003A000F3Q000F2Q00DA00103Q000100122Q00110007045Q00113Q00114Q001200013Q00122Q0013002Q045Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0001045Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00FE035Q000D3Q000D4Q000E3Q000200122Q000F00FB033Q003A000F3Q000F2Q00DA00103Q000100122Q001100F8035Q00113Q00114Q001200013Q00122Q001300F5035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00F2035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00EF035Q000D3Q000D4Q000E3Q000200122Q000F00EC033Q003A000F3Q000F2Q00DA00103Q000300122Q001100E9035Q00113Q00114Q001200013Q00122Q001300E6035Q00133Q00134Q0012000100012Q008E00100011001200120D001100E3035Q00113Q00114Q001200013Q00122Q001300E0035Q00133Q00134Q0012000100012Q008E00100011001200120D001100DD035Q00113Q00114Q001200013Q00122Q001300DA035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00D7035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00D4035Q000D3Q000D4Q000E3Q000200122Q000F00D1033Q003A000F3Q000F2Q00DA00103Q000100122Q001100CE035Q00113Q00114Q001200013Q00122Q001300CB035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00C8035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00C5035Q000D3Q000D4Q000E3Q000200122Q000F00C2033Q003A000F3Q000F2Q00DA00103Q000200122Q001100BF035Q00113Q00114Q001200013Q00122Q001300BC035Q00133Q00134Q0012000100012Q008E00100011001200120D001100B9035Q00113Q00114Q001200013Q00122Q001300B6035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00B3035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00B0035Q000D3Q000D4Q000E3Q000200122Q000F00AD033Q003A000F3Q000F2Q00DA00103Q000200122Q001100AA035Q00113Q00114Q001200013Q00122Q001300A7035Q00133Q00134Q0012000100012Q008E00100011001200120D001100A4035Q00113Q00114Q001200013Q00122Q001300A1035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F009E035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D009B035Q000D3Q000D4Q000E3Q000200122Q000F0098033Q003A000F3Q000F2Q00DA00103Q000100122Q00110095035Q00113Q00114Q001200013Q00122Q00130092035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F008F035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D008C035Q000D3Q000D4Q000E3Q000200122Q000F0089033Q003A000F3Q000F2Q00DA00103Q000100122Q00110086035Q00113Q00114Q001200013Q00122Q00130083035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0080035Q000F3Q000F00122Q001000C7055Q000E000F00104Q000C000D000E00122Q000D007D035Q000D3Q000D4Q000E3Q000200122Q000F007A033Q003A000F3Q000F2Q00DA00103Q000100122Q00110077035Q00113Q00114Q001200013Q00122Q00130074035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0071035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D006E035Q000D3Q000D4Q000E3Q000200122Q000F006B033Q003A000F3Q000F2Q00DA00103Q000100122Q00110068035Q00113Q00114Q001200013Q00122Q00130065035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0062035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D005F035Q000D3Q000D4Q000E3Q000200122Q000F005C033Q003A000F3Q000F2Q00DA00103Q000100122Q00110059035Q00113Q00114Q001200013Q00122Q00130056035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0053035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0050035Q000D3Q000D4Q000E3Q000200122Q000F004D033Q003A000F3Q000F2Q00DA00103Q000200122Q0011004A035Q00113Q00114Q001200013Q00122Q00130047035Q00133Q00134Q0012000100012Q008E00100011001200120D00110044035Q00113Q00114Q001200013Q00122Q00130041035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F003E035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003B035Q000D3Q000D4Q000E3Q000200122Q000F0038033Q003A000F3Q000F2Q00DA00103Q000100122Q00110035035Q00113Q00114Q001200013Q00122Q00130032035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F002F035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002C035Q000D3Q000D4Q000E3Q000200122Q000F0029033Q003A000F3Q000F2Q00DA00103Q000100122Q00110026035Q00113Q00114Q001200013Q00122Q00130023035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0020035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D001D035Q000D3Q000D4Q000E3Q000200122Q000F001A033Q003A000F3Q000F2Q00DA00103Q000100122Q00110017035Q00113Q00114Q001200013Q00122Q00130014035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0011035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D000E035Q000D3Q000D4Q000E3Q000200122Q000F000B033Q003A000F3Q000F2Q00DA00103Q000100122Q00110008035Q00113Q00114Q001200013Q00122Q00130005035Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0002035Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00FF025Q000D3Q000D4Q000E3Q000200122Q000F00FC023Q003A000F3Q000F2Q00DA00103Q000100122Q001100F9025Q00113Q00114Q001200013Q00122Q001300F6025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00F3025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00F0025Q000D3Q000D4Q000E3Q000200122Q000F00ED023Q003A000F3Q000F2Q00DA00103Q000300122Q001100EA025Q00113Q00114Q001200013Q00122Q001300E7025Q00133Q00134Q0012000100012Q008E00100011001200120D001100E4025Q00113Q00114Q001200013Q00122Q001300E1025Q00133Q00134Q0012000100012Q008E00100011001200120D001100DE025Q00113Q00114Q001200013Q00122Q001300DB025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00D8025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00D5025Q000D3Q000D4Q000E3Q000200122Q000F00D2023Q003A000F3Q000F2Q00DA00103Q000300122Q001100CF025Q00113Q00114Q001200013Q00122Q001300CC025Q00133Q00134Q0012000100012Q008E00100011001200120D001100C9025Q00113Q00114Q001200013Q00122Q001300C6025Q00133Q00134Q0012000100012Q008E00100011001200120D001100C3025Q00113Q00114Q001200013Q00122Q001300C0025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00BD025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00BA025Q000D3Q000D4Q000E3Q000200122Q000F00B7023Q003A000F3Q000F2Q00DA00103Q000100122Q001100B4025Q00113Q00114Q001200013Q00122Q001300B1025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00AE025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00AB025Q000D3Q000D4Q000E3Q000200122Q000F00A8023Q003A000F3Q000F2Q00DA00103Q000200122Q001100A5025Q00113Q00114Q001200013Q00122Q001300A2025Q00133Q00134Q0012000100012Q008E00100011001200120D0011009F025Q00113Q00114Q001200013Q00122Q0013009C025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0099025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0096025Q000D3Q000D4Q000E3Q000200122Q000F0093023Q003A000F3Q000F2Q00DA00103Q000200122Q00110090025Q00113Q00114Q001200013Q00122Q0013008D025Q00133Q00134Q0012000100012Q008E00100011001200120D0011008A025Q00113Q00114Q001200013Q00122Q00130087025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0084025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0081025Q000D3Q000D4Q000E3Q000200122Q000F007E023Q003A000F3Q000F2Q00DA00103Q000100122Q0011007B025Q00113Q00114Q001200013Q00122Q00130078025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0075025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0072025Q000D3Q000D4Q000E3Q000200122Q000F006F023Q003A000F3Q000F2Q00DA00103Q000200122Q0011006C025Q00113Q00114Q001200013Q00122Q00130069025Q00133Q00134Q0012000100012Q008E00100011001200120D00110066025Q00113Q00114Q001200013Q00122Q00130063025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0060025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D005D025Q000D3Q000D4Q000E3Q000200122Q000F005A023Q003A000F3Q000F2Q00DA00103Q000100122Q00110057025Q00113Q00114Q001200013Q00122Q00130054025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0051025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D004E025Q000D3Q000D4Q000E3Q000200122Q000F004B023Q003A000F3Q000F2Q00DA00103Q000100122Q00110048025Q00113Q00114Q001200013Q00122Q00130045025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0042025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003F025Q000D3Q000D4Q000E3Q000200122Q000F003C023Q003A000F3Q000F2Q00DA00103Q000100122Q00110039025Q00113Q00114Q001200013Q00122Q00130036025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0033025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0030025Q000D3Q000D4Q000E3Q000200122Q000F002D023Q003A000F3Q000F2Q00DA00103Q000100122Q0011002A025Q00113Q00114Q001200013Q00122Q00130027025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0024025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0021025Q000D3Q000D4Q000E3Q000200122Q000F001E023Q003A000F3Q000F2Q00DA00103Q000100122Q0011001B025Q00113Q00114Q001200013Q00122Q00130018025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0015025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0012025Q000D3Q000D4Q000E3Q000200122Q000F000F023Q003A000F3Q000F2Q00DA00103Q000100122Q0011000C025Q00113Q00114Q001200013Q00122Q00130009025Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0006025Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0003025Q000D3Q000D4Q000E3Q000200122Q000F2Q00023Q003A000F3Q000F2Q00DA00103Q000200122Q001100FD015Q00113Q00114Q001200013Q00122Q001300FA015Q00133Q00134Q0012000100012Q008E00100011001200120D001100F7015Q00113Q00114Q001200013Q00122Q001300F4015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00F1015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00EE015Q000D3Q000D4Q000E3Q000200122Q000F00EB013Q003A000F3Q000F2Q00DA00103Q000100122Q001100E8015Q00113Q00114Q001200013Q00122Q001300E5015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00E2015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00DF015Q000D3Q000D4Q000E3Q000200122Q000F00DC013Q003A000F3Q000F2Q00DA00103Q000100122Q001100D9015Q00113Q00114Q001200013Q00122Q001300D6015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00D3015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00D0015Q000D3Q000D4Q000E3Q000200122Q000F00CD013Q003A000F3Q000F2Q00DA00103Q000200122Q001100CA015Q00113Q00114Q001200013Q00122Q001300C7015Q00133Q00134Q0012000100012Q008E00100011001200120D001100C4015Q00113Q00114Q001200013Q00122Q001300C1015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00BE015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00BB015Q000D3Q000D4Q000E3Q000200122Q000F00B8013Q003A000F3Q000F2Q00DA00103Q000100122Q001100B5015Q00113Q00114Q001200013Q00122Q001300B2015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00AF015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00AC015Q000D3Q000D4Q000E3Q000200122Q000F00A9013Q003A000F3Q000F2Q00DA00103Q000100122Q001100A6015Q00113Q00114Q001200013Q00122Q001300A3015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00A0015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D009D015Q000D3Q000D4Q000E3Q000200122Q000F009A013Q003A000F3Q000F2Q00DA00103Q000200122Q00110097015Q00113Q00114Q001200013Q00122Q00130094015Q00133Q00134Q0012000100012Q008E00100011001200120D00110091015Q00113Q00114Q001200013Q00122Q0013008E015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F008B015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0088015Q000D3Q000D4Q000E3Q000200122Q000F0085013Q003A000F3Q000F2Q00DA00103Q000100122Q00110082015Q00113Q00114Q001200013Q00122Q0013007F015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F007C015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0079015Q000D3Q000D4Q000E3Q000200122Q000F0076013Q003A000F3Q000F2Q00DA00103Q000100122Q00110073015Q00113Q00114Q001200013Q00122Q00130070015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F006D015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D006A015Q000D3Q000D4Q000E3Q000200122Q000F0067013Q003A000F3Q000F2Q00DA00103Q000100122Q00110064015Q00113Q00114Q001200013Q00122Q00130061015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F005E015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D005B015Q000D3Q000D4Q000E3Q000200122Q000F0058013Q003A000F3Q000F2Q00DA00103Q000300122Q00110055015Q00113Q00114Q001200013Q00122Q00130052015Q00133Q00134Q0012000100012Q008E00100011001200120D0011004F015Q00113Q00114Q001200013Q00122Q0013004C015Q00133Q00134Q0012000100012Q008E00100011001200120D00110049015Q00113Q00114Q001200013Q00122Q00130046015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0043015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0040015Q000D3Q000D4Q000E3Q000200122Q000F003D013Q003A000F3Q000F2Q00DA00103Q000100122Q0011003A015Q00113Q00114Q001200013Q00122Q00130037015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F0034015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D0031015Q000D3Q000D4Q000E3Q000200122Q000F002E013Q003A000F3Q000F2Q00DA00103Q000500122Q0011002B015Q00113Q00114Q001200013Q00122Q00130028015Q00133Q00134Q0012000100012Q008E00100011001200120D00110025015Q00113Q00114Q001200013Q00122Q00130022015Q00133Q00134Q0012000100012Q008E00100011001200120D0011001F015Q00113Q00114Q001200013Q00122Q0013001C015Q00133Q00134Q0012000100012Q008E00100011001200120D00110019015Q00113Q00114Q001200013Q00122Q00130016015Q00133Q00134Q0012000100012Q008E00100011001200120D00110013015Q00113Q00114Q001200013Q00122Q00130010015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F000D015Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D000A015Q000D3Q000D4Q000E3Q000200122Q000F0007013Q003A000F3Q000F2Q00DA00103Q000100122Q00110004015Q00113Q00114Q001200013Q00122Q0013002Q015Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00FE6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00FB6Q000D3Q000D4Q000E3Q000200122Q000F00F84Q003A000F3Q000F2Q00DA00103Q000100122Q001100F56Q00113Q00114Q001200013Q00122Q001300F26Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00EF6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00EC6Q000D3Q000D4Q000E3Q000200122Q000F00E94Q003A000F3Q000F2Q00DA00103Q000100122Q001100E66Q00113Q00114Q001200013Q00122Q001300E36Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00E06Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00DD6Q000D3Q000D4Q000E3Q000200122Q000F00DA4Q003A000F3Q000F2Q00DA00103Q000200122Q001100D76Q00113Q00114Q001200013Q00122Q001300D46Q00133Q00134Q0012000100012Q008E00100011001200120D001100D16Q00113Q00114Q001200013Q00122Q001300CE6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00CB6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00C86Q000D3Q000D4Q000E3Q000200122Q000F00C54Q003A000F3Q000F2Q00DA00103Q000100122Q001100C26Q00113Q00114Q001200013Q00122Q001300BF6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00BC6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00B96Q000D3Q000D4Q000E3Q000200122Q000F00B64Q003A000F3Q000F2Q00DA00103Q000200122Q001100B36Q00113Q00114Q001200013Q00122Q001300B06Q00133Q00134Q0012000100012Q008E00100011001200120D001100AD6Q00113Q00114Q001200013Q00122Q001300AA6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00A76Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00A46Q000D3Q000D4Q000E3Q000200122Q000F00A14Q003A000F3Q000F2Q00DA00103Q000100122Q0011009E6Q00113Q00114Q001200013Q00122Q0013009B6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00986Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00956Q000D3Q000D4Q000E3Q000200122Q000F00924Q003A000F3Q000F2Q00DA00103Q000100122Q0011008F6Q00113Q00114Q001200013Q00122Q0013008C6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00896Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00866Q000D3Q000D4Q000E3Q000200122Q000F00834Q003A000F3Q000F2Q00DA00103Q000100122Q001100806Q00113Q00114Q001200013Q00122Q0013007D6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F007A6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00776Q000D3Q000D4Q000E3Q000200122Q000F00744Q003A000F3Q000F2Q00DA00103Q000100122Q001100716Q00113Q00114Q001200013Q00122Q0013006E6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F006B6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00686Q000D3Q000D4Q000E3Q000200122Q000F00654Q003A000F3Q000F2Q00DA00103Q000100122Q001100626Q00113Q00114Q001200013Q00122Q0013005F6Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F005C6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D00596Q000D3Q000D4Q000E3Q000200122Q000F00564Q003A000F3Q000F2Q00DA00103Q000100122Q001100536Q00113Q00114Q001200013Q00122Q001300506Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F004D6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D004A6Q000D3Q000D4Q000E3Q000200122Q000F00474Q003A000F3Q000F2Q00DA00103Q000100122Q001100446Q00113Q00114Q001200013Q00122Q001300416Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F003E6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D003B6Q000D3Q000D4Q000E3Q000200122Q000F00384Q003A000F3Q000F2Q00DA00103Q000100122Q001100356Q00113Q00114Q001200013Q00122Q001300326Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F002F6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D002C6Q000D3Q000D4Q000E3Q000200122Q000F00294Q003A000F3Q000F2Q00DA00103Q000100122Q001100266Q00113Q00114Q001200013Q00122Q001300236Q00133Q00134Q0012000100012Q008E0010001100122Q0046000E000F001000122Q000F00206Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E00122Q000D001D6Q000D3Q000D4Q000E3Q000200122Q000F001A4Q003A000F3Q000F2Q00DA00103Q000200122Q001100176Q00113Q00114Q001200013Q00122Q001300146Q00133Q00134Q0012000100012Q008E00100011001200120D001100116Q00113Q00114Q001200013Q00122Q0013000E6Q00133Q00134Q0012000100012Q008E0010001100122Q0040000E000F001000122Q000F000B6Q000F3Q000F00122Q001000C8055Q000E000F00104Q000C000D000E4Q000A000C6Q000A00023Q00044Q00410B0100044Q003D0B012Q00D13Q00013Q00013Q00023Q00026Q00F03F026Q00704002264Q001000025Q00122Q000300016Q00045Q00122Q000500013Q00042Q0003002100012Q002E00076Q006D000800026Q000900016Q000A00026Q000B00036Q000C00046Q000D8Q000E00063Q00202Q000F000600014Q000C000F6Q000B3Q00024Q000C00036Q000D00046Q000E00016Q000F00016Q000F0006000F00102Q000F0001000F4Q001000016Q00100006001000102Q00100001001000202Q0010001000014Q000D00106Q000C8Q000A3Q000200202Q000A000A00024Q0009000A6Q00073Q00010004DC0003000500012Q002E000300054Q0029000400024Q00CA000300044Q009D00036Q00D13Q00017Q00", GetFEnv(), ...);
