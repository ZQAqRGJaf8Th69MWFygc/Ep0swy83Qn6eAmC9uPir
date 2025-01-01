--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.8) ~  Much Love, Ferib 

]]--

local v0 = tonumber;
local v1 = string.byte;
local v2 = string.char;
local v3 = string.sub;
local v4 = string.gsub;
local v5 = string.rep;
local v6 = table.concat;
local v7 = table.insert;
local v8 = math.ldexp;
local v9 = getfenv or function()
	return _ENV;
end;
local v10 = setmetatable;
local v11 = pcall;
local v12 = select;
local v13 = unpack or table.unpack;
local v14 = tonumber;
local function v15(v16, v17, ...)
	local v18 = 1;
	local v19;
	v16 = v4(v3(v16, 5), "..", function(v30)
		if (v1(v30, 2) == 81) then
			v19 = v0(v3(v30, 1, 1));
			return "";
		else
			local v82 = 0;
			local v83;
			while true do
				if (v82 == 0) then
					v83 = v2(v0(v30, 16));
					if v19 then
						local v98 = 0;
						local v99;
						while true do
							if (v98 == 0) then
								v99 = v5(v83, v19);
								v19 = nil;
								v98 = 1;
							end
							if (v98 == 1) then
								return v99;
							end
						end
					else
						return v83;
					end
					break;
				end
			end
		end
	end);
	local function v20(v31, v32, v33)
		if v33 then
			local v84 = 0 - 0;
			local v85;
			while true do
				if (v84 == (0 - 0)) then
					v85 = (v31 / ((3 - 1) ^ (v32 - (2 - 1)))) % (((559 + 62) - (555 + 64)) ^ (((v33 - (932 - (857 + 74))) - (v32 - (569 - (367 + 201)))) + (928 - (214 + (1015 - 302)))));
					return v85 - (v85 % (1066 - (68 + 997)));
				end
			end
		else
			local v86 = 0;
			local v87;
			while true do
				if (v86 == ((1270 - (226 + 1044)) + 0)) then
					v87 = (8 - 6) ^ (v32 - (1 + 0));
					return (((v31 % (v87 + v87)) >= v87) and (878 - (282 + 595))) or (1637 - (1523 + 114));
				end
			end
		end
	end
	local function v21()
		local v34 = v1(v16, v18, v18);
		v18 = v18 + 1;
		return v34;
	end
	local function v22()
		local v35, v36 = v1(v16, v18, v18 + (119 - (32 + 85)));
		v18 = v18 + 2 + 0;
		return (v36 * (57 + 199)) + v35;
	end
	local function v23()
		local v37 = 957 - (892 + 65);
		local v38;
		local v39;
		local v40;
		local v41;
		while true do
			if (v37 == 1) then
				return (v41 * (40022563 - 23245347)) + (v40 * (48056 + 17480)) + (v39 * 256) + v38;
			end
			if (v37 == ((0 - 0) - 0)) then
				v38, v39, v40, v41 = v1(v16, v18, v18 + (4 - 1));
				v18 = v18 + (354 - (87 + 263));
				v37 = 181 - (67 + 113);
			end
		end
	end
	local function v24()
		local v42 = 0 + 0;
		local v43;
		local v44;
		local v45;
		local v46;
		local v47;
		local v48;
		while true do
			if (v42 == (3 - 2)) then
				v45 = 439 - (145 + 293);
				v46 = (v20(v44, 953 - (802 + 150), 53 - 33) * ((432 - (44 + 386)) ^ (1518 - (998 + 488)))) + v43;
				v42 = 2;
			end
			if ((0 - 0) == v42) then
				v43 = v23();
				v44 = v23();
				v42 = 1 + 0;
			end
			if (v42 == (999 - (915 + 82))) then
				v47 = v20(v44, 21, 87 - 56);
				v48 = ((v20(v44, 19 + 13) == (1 - 0)) and -1) or 1;
				v42 = 1190 - (1069 + 118);
			end
			if (v42 == (6 - 3)) then
				if (v47 == (0 - 0)) then
					if (v46 == 0) then
						return v48 * (0 + 0 + 0);
					else
						local v100 = 0 - 0;
						while true do
							if (v100 == (0 + 0)) then
								v47 = 792 - (368 + 423);
								v45 = 0 - 0;
								break;
							end
						end
					end
				elseif (v47 == (2065 - (10 + 7 + 1))) then
					return ((v46 == ((772 - (201 + 571)) - 0)) and (v48 * ((443 - (416 + 26)) / (0 - 0)))) or (v48 * NaN);
				end
				return v8(v48, v47 - 1023) * (v45 + (v46 / ((1 + 1) ^ (91 - 39))));
			end
		end
	end
	local function v25(v49)
		local v50;
		if not v49 then
			v49 = v23();
			if (v49 == (1138 - (116 + 1022))) then
				return "";
			end
		end
		v50 = v3(v16, v18, (v18 + v49) - (4 - 3));
		v18 = v18 + v49;
		local v51 = {};
		for v65 = 1 + 0, #v50 do
			v51[v65] = v2(v1(v3(v50, v65, v65)));
		end
		return v6(v51);
	end
	local v26 = v23;
	local function v27(...)
		return {...}, v12("#", ...);
	end
	local function v28()
		local v52 = (function()
			return 374 - (123 + 251);
		end)();
		local v53 = (function()
			return;
		end)();
		local v54 = (function()
			return;
		end)();
		local v55 = (function()
			return;
		end)();
		local v56 = (function()
			return;
		end)();
		local v57 = (function()
			return;
		end)();
		local v58 = (function()
			return;
		end)();
		while true do
			local v67 = (function()
				return 0 - 0;
			end)();
			while true do
				if (v67 == (699 - (208 + 490))) then
					if (v52 == (1 + 1)) then
						for v101 = #"[", v23() do
							local v102 = (function()
								return v21();
							end)();
							if (v20(v102, #"!", #"[") ~= (0 + 0)) then
							else
								local v105 = (function()
									return 836 - (660 + 176);
								end)();
								local v106 = (function()
									return;
								end)();
								local v107 = (function()
									return;
								end)();
								local v108 = (function()
									return;
								end)();
								while true do
									if (v105 ~= (1 + 0)) then
									else
										v108 = (function()
											return {v22(),v22(),nil,nil};
										end)();
										if (v106 == 0) then
											local v116 = (function()
												return 0;
											end)();
											local v117 = (function()
												return;
											end)();
											while true do
												if (v116 ~= 0) then
												else
													v117 = (function()
														return 0;
													end)();
													while true do
														if (0 ~= v117) then
														else
															v108[#"asd"] = (function()
																return v22();
															end)();
															v108[#"?id="] = (function()
																return v22();
															end)();
															break;
														end
													end
													break;
												end
											end
										elseif (v106 == #"~") then
											v108[#"-19"] = (function()
												return v23();
											end)();
										elseif (v106 == 2) then
											v108[#"asd"] = (function()
												return v23() - ((677 - (534 + 141)) ^ 16);
											end)();
										elseif (v106 == #"gha") then
											local v4741 = (function()
												return 0;
											end)();
											local v4742 = (function()
												return;
											end)();
											while true do
												if (v4741 ~= 0) then
												else
													v4742 = (function()
														return 0 + 0;
													end)();
													while true do
														if (v4742 == (0 + 0)) then
															v108[#"asd"] = (function()
																return v23() - (2 ^ 16);
															end)();
															v108[#".dev"] = (function()
																return v22();
															end)();
															break;
														end
													end
													break;
												end
											end
										end
										v105 = (function()
											return 2 + 0;
										end)();
									end
									if (v105 == (0 - 0)) then
										v106 = (function()
											return v20(v102, 2, #"91(");
										end)();
										v107 = (function()
											return v20(v102, #"?id=", 6);
										end)();
										v105 = (function()
											return 1 - 0;
										end)();
									end
									if (v105 ~= 3) then
									else
										if (v20(v107, #"19(", #"xxx") ~= #">") then
										else
											v108[#"0313"] = (function()
												return v58[v108[#"0836"]];
											end)();
										end
										v53[v101] = (function()
											return v108;
										end)();
										break;
									end
									if (v105 == 2) then
										if (v20(v107, #">", #"|") ~= #"~") then
										else
											v108[5 - 3] = (function()
												return v58[v108[2 + 0]];
											end)();
										end
										if (v20(v107, 2 + 0, 2) ~= #"[") then
										else
											v108[#"xxx"] = (function()
												return v58[v108[#"91("]];
											end)();
										end
										v105 = (function()
											return 399 - (115 + 281);
										end)();
									end
								end
							end
						end
						for v103 = #"{", v23() do
							v54[v103 - #"}"] = (function()
								return v28();
							end)();
						end
						return v56;
					end
					break;
				end
				if (v67 ~= 0) then
				else
					if (v52 ~= #"[") then
					else
						local v95 = (function()
							return 0 - 0;
						end)();
						local v96 = (function()
							return;
						end)();
						while true do
							if (v95 == (0 + 0)) then
								v96 = (function()
									return 0;
								end)();
								while true do
									if (v96 ~= 1) then
									else
										for v111 = #"<", v57 do
											local v112 = (function()
												return 0 - 0;
											end)();
											local v113 = (function()
												return;
											end)();
											local v114 = (function()
												return;
											end)();
											local v115 = (function()
												return;
											end)();
											while true do
												if (v112 == 0) then
													local v122 = (function()
														return 0 - 0;
													end)();
													while true do
														if (v122 ~= 0) then
														else
															v113 = (function()
																return 867 - (550 + 317);
															end)();
															v114 = (function()
																return nil;
															end)();
															v122 = (function()
																return 1 - 0;
															end)();
														end
														if (v122 == 1) then
															v112 = (function()
																return 1 - 0;
															end)();
															break;
														end
													end
												end
												if (v112 ~= (2 - 1)) then
												else
													v115 = (function()
														return nil;
													end)();
													while true do
														if (v113 ~= #"~") then
														else
															if (v114 == #"}") then
																v115 = (function()
																	return v21() ~= (285 - (134 + 151));
																end)();
															elseif (v114 == (1667 - (970 + 695))) then
																v115 = (function()
																	return v24();
																end)();
															elseif (v114 ~= #"19(") then
															else
																v115 = (function()
																	return v25();
																end)();
															end
															v58[v111] = (function()
																return v115;
															end)();
															break;
														end
														if (v113 ~= 0) then
														else
															local v3754 = (function()
																return 0 - 0;
															end)();
															local v3755 = (function()
																return;
															end)();
															while true do
																if (v3754 ~= (1990 - (582 + 1408))) then
																else
																	v3755 = (function()
																		return 0 - 0;
																	end)();
																	while true do
																		if (v3755 ~= (0 - 0)) then
																		else
																			v114 = (function()
																				return v21();
																			end)();
																			v115 = (function()
																				return nil;
																			end)();
																			v3755 = (function()
																				return 3 - 2;
																			end)();
																		end
																		if ((1825 - (1195 + 629)) == v3755) then
																			v113 = (function()
																				return #"\\";
																			end)();
																			break;
																		end
																	end
																	break;
																end
															end
														end
													end
													break;
												end
											end
										end
										v56[#"asd"] = (function()
											return v21();
										end)();
										v96 = (function()
											return 2;
										end)();
									end
									if (v96 == 0) then
										v57 = (function()
											return v23();
										end)();
										v58 = (function()
											return {};
										end)();
										v96 = (function()
											return 1 - 0;
										end)();
									end
									if (v96 == (243 - (187 + 54))) then
										v52 = (function()
											return 2;
										end)();
										break;
									end
								end
								break;
							end
						end
					end
					if (v52 == 0) then
						local v97 = (function()
							return 0;
						end)();
						while true do
							if (v97 ~= 1) then
							else
								v55 = (function()
									return {};
								end)();
								v56 = (function()
									return {v53,v54,nil,v55};
								end)();
								v97 = (function()
									return 2 + 0;
								end)();
							end
							if (v97 == (0 + 0)) then
								v53 = (function()
									return {};
								end)();
								v54 = (function()
									return {};
								end)();
								v97 = (function()
									return 1 - 0;
								end)();
							end
							if (v97 == 2) then
								v52 = (function()
									return #"|";
								end)();
								break;
							end
						end
					end
					v67 = (function()
						return 1 - 0;
					end)();
				end
			end
		end
	end
	local function v29(v59, v60, v61)
		local v62 = v59[1];
		local v63 = v59[(1378 - (922 + 455)) + 1];
		local v64 = v59[1639 - (1373 + 263)];
		return function(...)
			local v68 = v62;
			local v69 = v63;
			local v70 = v64;
			local v71 = v27;
			local v72 = 1001 - (451 + 549);
			local v73 = -1;
			local v74 = {};
			local v75 = {...};
			local v76 = v12("#", ...) - (1 - 0);
			local v77 = {};
			local v78 = {};
			for v88 = 0 - 0, v76 do
				if ((1321 > 375) and (v88 >= v70)) then
					v74[v88 - v70] = v75[v88 + (1 - 0)];
				else
					v78[v88] = v75[v88 + (1385 - (746 + 638))];
				end
			end
			local v79 = (v76 - v70) + 1 + 0;
			local v80;
			local v81;
			while true do
				v80 = v68[v72];
				v81 = v80[1 - (0 + 0)];
				if ((2680 >= 1710) and (v81 <= (448 - (218 + 123)))) then
					if (v81 <= (1634 - (1535 + 46))) then
						if (v81 <= (26 + 0)) then
							if (v81 <= (2 + 10)) then
								if (v81 <= 5) then
									if ((v81 <= (562 - (306 + 254))) or (2778 >= 3693)) then
										if (v81 <= (0 + 0)) then
											local v123 = 0 - (61 - (31 + 30));
											while true do
												if (v123 == 2) then
													v80 = v68[v72];
													v78[v80[1469 - (899 + 568)]] = v80[2 + 1];
													v72 = v72 + (2 - 1);
													v80 = v68[v72];
													v123 = 3;
												end
												if ((v123 == (604 - (268 + 335))) or (1132 >= 3109)) then
													v72 = v72 + (291 - (60 + 230));
													v80 = v68[v72];
													v78[v80[2]] = v78[v80[575 - (426 + 146)]][v78[v80[1 + 0 + 3]]];
													v72 = v72 + (1457 - ((668 - 386) + 1174));
													v123 = (620 + 193) - (569 + 242);
												end
												if (v123 == (14 - 9)) then
													v80 = v68[v72];
													v78[v80[2 + 0]] = v78[v80[1 + 1 + 1]][v78[v80[1028 - ((1091 - 385) + 318)]]];
													v72 = v72 + (1252 - (721 + 530));
													v80 = v68[v72];
													v123 = 1277 - (945 + 326);
												end
												if (v123 == 6) then
													v78[v80[2]] = {};
													v72 = v72 + (2 - 1);
													v80 = v68[v72];
													v78[v80[2]] = v80[3];
													break;
												end
												if ((v123 == (0 + 0)) or (738 < 271)) then
													v78[v80[702 - (271 + 429)]][v78[v80[3 + 0]]] = v78[v80[1504 - (1408 + 92)]];
													v72 = v72 + (1087 - (461 + 625));
													v80 = v68[v72];
													v78[v80[(1312 - (5 + 17)) - (993 + 295)]] = v80[3];
													v123 = 1;
												end
												if (v123 == 4) then
													v72 = v72 + 1;
													v80 = v68[v72];
													v78[v80[(1 - 0) + (71 - (65 + 5))]] = v80[1174 - (418 + 513 + 240)];
													v72 = v72 + 1;
													v123 = 5;
												end
												if ((335 < 1904) and (v123 == (2 + 1))) then
													v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[2 + 2]];
													v72 = v72 + 1 + 0;
													v80 = v68[v72];
													v78[v80[531 - (406 + 123)]][v78[v80[1772 - ((4248 - 2499) + 20)]]] = v78[v80[1 + 0 + 1 + 2]];
													v123 = (2167 - (685 + 156)) - (1249 + 73);
												end
											end
										elseif (v81 == (1 + 0)) then
											v78[v80[1147 - (466 + 679)]] = v61[v80[6 - 3]];
										else
											local v941 = 0 - 0;
											local v942;
											local v943;
											local v944;
											while true do
												if (v941 == (1900 - (106 + 1794))) then
													v942 = nil;
													v943 = nil;
													v944 = nil;
													v941 = 1 + 0;
												end
												if ((5 == v941) or (2211 >= 3084)) then
													v78[v80[(3 - 2) + 1]] = v80[3];
													v72 = v72 + 1;
													v80 = v68[v72];
													v941 = 17 - (8 + 3);
												end
												if ((10 - 6) == v941) then
													v78[v80[116 - (4 + 110)]] = {};
													v72 = v72 + (585 - (57 + 527));
													v80 = v68[v72];
													v941 = 1432 - (41 + 1386);
												end
												if ((4394 == 4394) and ((110 - ((61 - 44) + (818 - (620 + 112)))) == v941)) then
													v944 = v80[2 + 0];
													v943 = v78[v944];
													v942 = v80[(15 - 9) - 3];
													v941 = 23 - 15;
												end
												if ((v941 == (168 - (122 + 44))) or (3667 <= 253)) then
													v78[v80[2 - 0]] = v80[3];
													v72 = v72 + (3 - 2);
													v80 = v68[v72];
													v941 = 3 + 0;
												end
												if ((v941 == (1 + 0)) or (4563 < 1626)) then
													v78[v80[3 - (3 - 2)]] = {};
													v72 = v72 + (66 - (30 + (284 - (89 + 160))));
													v80 = v68[v72];
													v941 = 2 + 0;
												end
												if ((2211 > 34) and (v941 == (1265 - (1043 + 214)))) then
													for v6810 = 3 - 2, v942 do
														v943[v6810] = v78[v944 + v6810];
													end
													break;
												end
												if (v941 == (1215 - (323 + 889))) then
													v78[v80[5 - (7 - 4)]] = v78[v80[3]][v78[v80[584 - ((1968 - (975 + 632)) + 219)]]];
													v72 = v72 + (321 - (53 + (450 - 183)));
													v80 = v68[v72];
													v941 = 1 + 3;
												end
												if (6 == v941) then
													v78[v80[415 - (15 + 0 + 398)]] = v78[v80[985 - ((30 - 12) + 964)]][v78[v80[14 - (520 - (358 + 152))]]];
													v72 = v72 + 1 + 0;
													v80 = v68[v72];
													v941 = 5 + 2;
												end
											end
										end
									elseif (v81 <= (853 - (20 + 830))) then
										local v124;
										local v125;
										local v126;
										v78[v80[2 + 0]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + (127 - (116 + 10));
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[741 - (542 + 196)]][v78[v80[8 - 4]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[7 - 4];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1553 - (1126 + 425)]] = v78[v80[408 - (118 + 287)]][v78[v80[15 - 11]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v126 = v80[1123 - (118 + 1003)];
										v125 = v78[v126];
										v124 = v80[8 - 5];
										for v907 = 1, v124 do
											v125[v907] = v78[v126 + v907];
										end
									elseif (v81 > (381 - (142 + 235))) then
										local v945 = 0 - 0;
										while true do
											if ((4812 >= 4440) and (v945 == (2 + 4))) then
												v78[v80[979 - (553 + 424)]] = {};
												v72 = v72 + (1 - 0);
												v80 = v68[v72];
												v78[v80[2 + 0]] = v80[3 + 0];
												break;
											end
											if ((1291 > 876) and (v945 == (0 - 0))) then
												v78[v80[2 + 0]][v78[v80[2 + 1]]] = v78[v80[4]];
												v72 = v72 + 1 + 0;
												v80 = v68[v72];
												v78[v80[4 - 2]] = v80[7 - (1115 - (727 + 384))];
												v945 = 2 - 1;
											end
											if (v945 == (1 + 1)) then
												v80 = v68[v72];
												v78[v80[9 - 7]] = v80[756 - (239 + 514)];
												v72 = v72 + 1;
												v80 = v68[v72];
												v945 = 2 + 1;
											end
											if (v945 == 3) then
												v78[v80[1331 - (797 + 532)]][v78[v80[3 + 0]]] = v78[v80[2 + 2]];
												v72 = v72 + (2 - (3 - 2));
												v80 = v68[v72];
												v78[v80[1204 - ((1010 - 637) + (2163 - 1334))]][v78[v80[734 - (476 + 255)]]] = v78[v80[(1120 + 14) - (369 + 761)]];
												v945 = 3 + 1;
											end
											if (((1234 - (804 + 421)) - 4) == v945) then
												v80 = v68[v72];
												v78[v80[3 - 1]] = v78[v80[241 - (64 + 174)]][v78[v80[1 + 3]]];
												v72 = v72 + (1 - 0);
												v80 = v68[v72];
												v945 = 342 - (144 + 192);
											end
											if (v945 == (217 - (42 + 174))) then
												v72 = v72 + 1 + 0;
												v80 = v68[v72];
												v78[v80[2]] = v78[v80[3 + 0]][v78[v80[2 + 2]]];
												v72 = v72 + (1505 - (363 + 1141));
												v945 = 1582 - (1183 + 397);
											end
											if (((11 - 7) == v945) or (475 == 396)) then
												v72 = v72 + 1 + 0;
												v80 = v68[v72];
												v78[v80[2 + 0]] = v80[1978 - (1913 + 62)];
												v72 = v72 + 1;
												v945 = 4 + 1;
											end
										end
									else
										local v946 = (0 - 0) - 0;
										while true do
											if (v946 == (1939 - (565 + 1368))) then
												v78[v80[2]] = v80[(36 - 25) - 8];
												v72 = v72 + 1;
												v80 = v68[v72];
												v946 = 1668 - (1477 + 184);
											end
											if (v946 == 1) then
												v78[v80[2 - 0]] = v80[3 + 0];
												v72 = v72 + (857 - (564 + 292));
												v80 = v68[v72];
												v946 = 2 - 0;
											end
											if (v946 == (8 - 5)) then
												v78[v80[2]] = v80[307 - (244 + 60)];
												v72 = v72 + 1;
												v80 = v68[v72];
												v946 = (13 - 9) + 0;
											end
											if (v946 == (1081 - (1029 + 44))) then
												v78[v80[478 - (41 + 435)]] = {};
												v72 = v72 + 1;
												v80 = v68[v72];
												v946 = 1010 - (938 + 63);
											end
											if (v946 == (4 + 1)) then
												v78[v80[1127 - (936 + 189)]][v78[v80[1 + 2]]] = v78[v80[1617 - (1565 + 48)]];
												v72 = v72 + 1 + 0 + 0;
												v80 = v68[v72];
												v946 = 1144 - (782 + 356);
											end
											if (v946 == 7) then
												v78[v80[2 + 0]] = v78[v80[3]][v78[v80[271 - (176 + 70 + 21)]]];
												v72 = v72 + (2 - 1);
												v80 = v68[v72];
												v946 = 11 - 3;
											end
											if (v946 == (1092 - (975 + 117))) then
												v78[v80[2]][v78[v80[1878 - (157 + 1718)]]] = v78[v80[4 + 0]];
												v72 = v72 + (3 - 2);
												v80 = v68[v72];
												v946 = 3 - 2;
											end
											if (v946 == 4) then
												v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
												v72 = v72 + (1019 - (697 + 321));
												v80 = v68[v72];
												v946 = 13 - 8;
											end
											if (v946 == (18 - 9)) then
												v78[v80[4 - 2]] = v80[2 + 1];
												break;
											end
											if (v946 == (3 - 1)) then
												v78[v80[5 - 3]] = v78[v80[1230 - (322 + 905)]][v78[v80[615 - (602 + 9)]]];
												v72 = v72 + (1190 - (449 + 740));
												v80 = v68[v72];
												v946 = 875 - (826 + 46);
											end
										end
									end
								elseif (v81 <= (955 - (245 + 702))) then
									if ((4210 == 4210) and (v81 <= (18 - 12))) then
										local v139;
										local v140;
										local v141;
										v78[v80[1 + 1]] = {};
										v72 = v72 + (1899 - (260 + 1638));
										v80 = v68[v72];
										v78[v80[2]] = v80[443 - (382 + 58)];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[6 - 4]] = v78[v80[3]][v78[v80[4]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[3 - 1]] = v80[8 - 5];
										v72 = v72 + (1206 - (902 + 303));
										v80 = v68[v72];
										v78[v80[3 - 1]] = v78[v80[6 - 3]][v78[v80[1 + 3]]];
										v72 = v72 + (1691 - (1121 + 569));
										v80 = v68[v72];
										v141 = v80[216 - (22 + 192)];
										v140 = v78[v141];
										v139 = v80[686 - (483 + 200)];
										for v910 = 1464 - (1404 + 59), v139 do
											v140[v910] = v78[v141 + v910];
										end
									elseif (v81 == (19 - 12)) then
										local v947 = 0 - 0;
										while true do
											if ((767 - (468 + 297)) == v947) then
												v80 = v68[v72];
												v78[v80[564 - (334 + 228)]] = v80[10 - 7];
												v72 = v72 + (2 - 1);
												v80 = v68[v72];
												v947 = 5 - 2;
											end
											if ((0 + 0) == v947) then
												v78[v80[238 - (141 + 95)]][v78[v80[3 + 0]]] = v78[v80[9 - 5]];
												v72 = v72 + (2 - 1);
												v80 = v68[v72];
												v78[v80[1 + 1]] = v80[8 - 5];
												v947 = 1 + 0;
											end
											if ((2918 < 3377) and (v947 == (3 + 1))) then
												v72 = v72 + (1 - 0);
												v80 = v68[v72];
												v78[v80[2]] = v80[2 + 1];
												v72 = v72 + (164 - (92 + 71));
												v947 = 3 + 2;
											end
											if ((1 <= 283) and (v947 == 1)) then
												v72 = v72 + (1 - 0);
												v80 = v68[v72];
												v78[v80[2]] = v78[v80[768 - (574 + 191)]][v78[v80[4 + 0]]];
												v72 = v72 + (2 - 1);
												v947 = 2 + 0;
											end
											if (v947 == (854 - (254 + 595))) then
												v80 = v68[v72];
												v78[v80[128 - (55 + 71)]] = v78[v80[3 - 0]][v78[v80[1794 - (573 + 1217)]]];
												v72 = v72 + 1;
												v80 = v68[v72];
												v947 = 16 - 10;
											end
											if (v947 == 3) then
												v78[v80[1 + 1]][v78[v80[4 - 1]]] = v78[v80[4]];
												v72 = v72 + (940 - (714 + 225));
												v80 = v68[v72];
												v78[v80[5 - 3]][v78[v80[3 - 0]]] = v78[v80[4]];
												v947 = 4;
											end
											if (v947 == (1 + 5)) then
												v78[v80[2 - 0]] = {};
												v72 = v72 + 1;
												v80 = v68[v72];
												v78[v80[808 - (118 + 688)]] = v80[51 - (25 + 23)];
												break;
											end
										end
									else
										local v948 = 0;
										local v949;
										local v950;
										local v951;
										while true do
											if (v948 == (1 + 1)) then
												v78[v80[1888 - (927 + 959)]] = v80[3];
												v72 = v72 + (3 - 2);
												v80 = v68[v72];
												v948 = 735 - (16 + 716);
											end
											if ((15 - 7) == v948) then
												for v6813 = 1, v949 do
													v950[v6813] = v78[v951 + v6813];
												end
												break;
											end
											if (5 == v948) then
												v78[v80[99 - (11 + 86)]] = v80[6 - 3];
												v72 = v72 + (286 - (175 + 110));
												v80 = v68[v72];
												v948 = 6;
											end
											if (v948 == (2 - 1)) then
												v78[v80[2]] = {};
												v72 = v72 + 1;
												v80 = v68[v72];
												v948 = 9 - 7;
											end
											if ((1802 - (503 + 1293)) == v948) then
												v78[v80[5 - 3]] = v78[v80[3 + 0]][v78[v80[1065 - (810 + 251)]]];
												v72 = v72 + 1 + 0;
												v80 = v68[v72];
												v948 = 7;
											end
											if (v948 == (0 + 0)) then
												v949 = nil;
												v950 = nil;
												v951 = nil;
												v948 = 1 + 0;
											end
											if (v948 == (537 - (43 + 490))) then
												v78[v80[2]] = {};
												v72 = v72 + 1;
												v80 = v68[v72];
												v948 = 738 - (711 + 22);
											end
											if (v948 == (11 - 8)) then
												v78[v80[861 - (240 + 619)]] = v78[v80[1 + 2]][v78[v80[4]]];
												v72 = v72 + (1 - 0);
												v80 = v68[v72];
												v948 = 4;
											end
											if (v948 == (1 + 6)) then
												v951 = v80[1746 - (1344 + 400)];
												v950 = v78[v951];
												v949 = v80[408 - (255 + 150)];
												v948 = 7 + 1;
											end
										end
									end
								elseif ((v81 <= 10) or (3606 < 1671)) then
									if (v81 == (5 + 4)) then
										local v952 = 0;
										local v953;
										local v954;
										local v955;
										while true do
											if (v952 == (0 - 0)) then
												v953 = v80[2];
												v954 = v78[v953];
												v952 = 3 - 2;
											end
											if (v952 == 1) then
												v955 = v80[1742 - (404 + 1335)];
												for v6816 = 407 - (183 + 223), v955 do
													v954[v6816] = v78[v953 + v6816];
												end
												break;
											end
										end
									else
										local v956 = 0 - 0;
										local v957;
										local v958;
										local v959;
										while true do
											if (v956 == 2) then
												v78[v80[2 + 0]] = v78[v80[2 + 1]][v78[v80[4]]];
												v72 = v72 + (338 - (10 + 327));
												v80 = v68[v72];
												v956 = 3 + 0;
											end
											if (v956 == (343 - (118 + 220))) then
												v78[v80[2]] = v78[v80[1 + 2]][v78[v80[4]]];
												v72 = v72 + (450 - (108 + 341));
												v80 = v68[v72];
												v956 = 3 + 3;
											end
											if ((3768 == 3768) and (v956 == 7)) then
												for v6819 = 4 - 3, v957 do
													v958[v6819] = v78[v959 + v6819];
												end
												break;
											end
											if ((v956 == (1497 - (711 + 782))) or (2670 < 538)) then
												v78[v80[3 - 1]] = v80[3];
												v72 = v72 + 1;
												v80 = v68[v72];
												v956 = 5;
											end
											if ((1800 < 2822) and (v956 == (470 - (270 + 199)))) then
												v78[v80[1 + 1]] = v80[1822 - (580 + 1239)];
												v72 = v72 + (2 - 1);
												v80 = v68[v72];
												v956 = 2 + 0;
											end
											if (v956 == (1 + 2)) then
												v78[v80[1 + 1]] = {};
												v72 = v72 + (2 - 1);
												v80 = v68[v72];
												v956 = 3 + 1;
											end
											if ((2298 == 2298) and ((1173 - (645 + 522)) == v956)) then
												v959 = v80[1792 - (1010 + 780)];
												v958 = v78[v959];
												v957 = v80[3 + 0];
												v956 = 33 - 26;
											end
											if ((220 < 1058) and ((0 - 0) == v956)) then
												v957 = nil;
												v958 = nil;
												v959 = nil;
												v956 = 1837 - (1045 + 791);
											end
										end
									end
								elseif ((1868 == 1868) and (v81 == (27 - 16))) then
									local v960;
									v78[v80[2 - 0]] = v78[v80[3]];
									v72 = v72 + (506 - (351 + 154));
									v80 = v68[v72];
									v78[v80[1576 - (1281 + 293)]] = v80[269 - (28 + 238)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v960 = v80[1561 - (1381 + 178)];
									v78[v960] = v78[v960](v13(v78, v960 + 1 + 0, v80[3 + 0]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[6 - 4]][v78[v80[2 + 1]]] = v78[v80[474 - (381 + 89)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[3]];
									v72 = v72 + (1157 - (1074 + 82));
									v80 = v68[v72];
									v78[v80[2]] = v80[6 - 3];
									v72 = v72 + (1785 - (214 + 1570));
									v80 = v68[v72];
									v78[v80[1457 - (990 + 465)]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v960 = v80[2 + 0];
									v78[v960] = v78[v960](v13(v78, v960 + (3 - 2), v80[1729 - (1668 + 58)]));
									v72 = v72 + (627 - (512 + 114));
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[5 - 2]]] = v78[v80[13 - 9]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[10 - 7]];
									v72 = v72 + (1995 - (109 + 1885));
									v80 = v68[v72];
									v78[v80[2]] = v80[1472 - (1269 + 200)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[817 - (98 + 717)]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v960 = v80[828 - (802 + 24)];
									v78[v960] = v78[v960](v13(v78, v960 + (1 - 0), v80[3 - 0]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[1 + 3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[9 - 6]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + (1434 - (797 + 636));
									v80 = v68[v72];
									v960 = v80[2];
									v78[v960] = v78[v960](v13(v78, v960 + (4 - 3), v80[1622 - (1427 + 192)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]][v78[v80[3 + 0]]] = v78[v80[2 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[328 - (192 + 134)]] = v80[1279 - (316 + 960)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[11 - 8];
									v72 = v72 + (552 - (83 + 468));
									v80 = v68[v72];
									v78[v80[1808 - (1202 + 604)]] = v80[13 - 10];
									v72 = v72 + 1;
									v80 = v68[v72];
									v960 = v80[2 - 0];
									v78[v960] = v78[v960](v13(v78, v960 + 1, v80[8 - 5]));
									v72 = v72 + (326 - (45 + 280));
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4 + 0]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1 + 2]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1913 - (340 + 1571)]] = v80[2 + 1];
									v72 = v72 + (1773 - (1733 + 39));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[1037 - (125 + 909)];
									v72 = v72 + (1949 - (1096 + 852));
									v80 = v68[v72];
									v960 = v80[1 + 1];
									v78[v960] = v78[v960](v13(v78, v960 + (1 - 0), v80[3]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[514 - (409 + 103)]][v78[v80[239 - (46 + 190)]]] = v78[v80[99 - (51 + 44)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1320 - (1114 + 203)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[728 - (228 + 498)]] = v78[v80[1 + 2]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[666 - (174 + 489)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1907 - (830 + 1075)]] = v80[527 - (303 + 221)];
									v72 = v72 + (1270 - (231 + 1038));
									v80 = v68[v72];
									v960 = v80[2 + 0];
									v78[v960] = v78[v960](v13(v78, v960 + (1163 - (171 + 991)), v80[12 - 9]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[7 - 4]]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[8 - 5];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[6 - 4]] = v78[v80[3]];
									v72 = v72 + (1249 - (111 + 1137));
									v80 = v68[v72];
									v78[v80[160 - (91 + 67)]] = v80[8 - 5];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[525 - (423 + 100)]] = v80[1 + 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v960 = v80[2 + 0];
									v78[v960] = v78[v960](v13(v78, v960 + (772 - (326 + 445)), v80[13 - 10]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[9 - 5]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[713 - (530 + 181)]] = v80[884 - (614 + 267)];
									v72 = v72 + (33 - (19 + 13));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[6 - 3]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[4 - 1];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1814 - (1293 + 519)]] = v80[5 - 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v960 = v80[4 - 2];
									v78[v960] = v78[v960](v13(v78, v960 + (1 - 0), v80[12 - 9]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[1 + 2]]] = v78[v80[4]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1099 - (709 + 387)]];
									v72 = v72 + (1859 - (673 + 1185));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[9 - 6];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v960 = v80[2 - 0];
									v78[v960] = v78[v960](v13(v78, v960 + 1 + 0, v80[3]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[1883 - (446 + 1434)]]] = v78[v80[1287 - (1040 + 243)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1849 - (559 + 1288)]] = v80[1934 - (609 + 1322)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[457 - (13 + 441)]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[14 - 11];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[10 - 7];
									v72 = v72 + 1;
									v80 = v68[v72];
									v960 = v80[1 + 1];
									v78[v960] = v78[v960](v13(v78, v960 + 1 + 0, v80[8 - 5]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[2 + 1]]] = v78[v80[3 + 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[436 - (153 + 280)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v960 = v80[2];
									v78[v960] = v78[v960](v13(v78, v960 + (1 - 0), v80[2 + 1]));
									v72 = v72 + (668 - (89 + 578));
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[5 - 2]]] = v78[v80[1053 - (572 + 477)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3]];
									v72 = v72 + (87 - (84 + 2));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[845 - (497 + 345)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v960 = v80[2];
									v78[v960] = v78[v960](v13(v78, v960 + 1 + 0, v80[3]));
									v72 = v72 + (1334 - (605 + 728));
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[6 - 3]]] = v78[v80[1 + 3]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[10 - 7];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[3 + 0]];
									v72 = v72 + (490 - (457 + 32));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
								else
									local v1045;
									local v1046;
									local v1047;
									v78[v80[2]] = {};
									v72 = v72 + (1403 - (832 + 570));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[799 - (588 + 208)]][v78[v80[10 - 6]]];
									v72 = v72 + (1801 - (884 + 916));
									v80 = v68[v72];
									v78[v80[3 - 1]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[655 - (232 + 421)]] = v80[1892 - (1569 + 320)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[9 - 6]][v78[v80[609 - (316 + 289)]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v1047 = v80[2];
									v1046 = v78[v1047];
									v1045 = v80[1 + 2];
									for v3781 = 1454 - (666 + 787), v1045 do
										v1046[v3781] = v78[v1047 + v3781];
									end
								end
							elseif (v81 <= (444 - (360 + 65))) then
								if ((v81 <= (15 + 0)) or (759 >= 4671)) then
									if (v81 <= (267 - (79 + 175))) then
										local v155 = 0 - 0;
										local v156;
										local v157;
										local v158;
										while true do
											if ((v155 == 6) or (2621 <= 2066)) then
												v78[v80[2]] = v78[v80[3 + 0]][v78[v80[12 - 8]]];
												v72 = v72 + (1 - 0);
												v80 = v68[v72];
												v155 = 906 - (503 + 396);
											end
											if (((186 - (92 + 89)) == v155) or (3184 < 2843)) then
												v78[v80[3 - 1]] = v80[2 + 1];
												v72 = v72 + 1;
												v80 = v68[v72];
												v155 = 4 + 2;
											end
											if (v155 == 8) then
												for v4743 = 3 - 2, v156 do
													v157[v4743] = v78[v158 + v4743];
												end
												break;
											end
											if ((v155 == (1 + 3)) or (2241 >= 2907)) then
												v78[v80[2]] = {};
												v72 = v72 + 1;
												v80 = v68[v72];
												v155 = 11 - 6;
											end
											if ((0 + 0) == v155) then
												v156 = nil;
												v157 = nil;
												v158 = nil;
												v155 = 1;
											end
											if (v155 == (2 + 1)) then
												v78[v80[5 - 3]] = v78[v80[3]][v78[v80[4]]];
												v72 = v72 + 1 + 0;
												v80 = v68[v72];
												v155 = 5 - 1;
											end
											if (v155 == (1246 - (485 + 759))) then
												v78[v80[2]] = v80[3];
												v72 = v72 + 1;
												v80 = v68[v72];
												v155 = 3;
											end
											if ((2 - 1) == v155) then
												v78[v80[1191 - (442 + 747)]] = {};
												v72 = v72 + (1136 - (832 + 303));
												v80 = v68[v72];
												v155 = 2;
											end
											if (v155 == (953 - (88 + 858))) then
												v158 = v80[2];
												v157 = v78[v158];
												v156 = v80[1 + 2];
												v155 = 7 + 1;
											end
										end
									elseif (v81 == 14) then
										local v1060;
										local v1061;
										local v1062;
										v78[v80[1 + 1]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[791 - (766 + 23)]] = v80[14 - 11];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[4 - 2]] = v78[v80[10 - 7]][v78[v80[1077 - (1036 + 37)]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[3 - 1]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1482 - (641 + 839)]] = v80[916 - (910 + 3)];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[1687 - (1466 + 218)]][v78[v80[2 + 2]]];
										v72 = v72 + (1149 - (556 + 592));
										v80 = v68[v72];
										v1062 = v80[1 + 1];
										v1061 = v78[v1062];
										v1060 = v80[811 - (329 + 479)];
										for v3803 = 855 - (174 + 680), v1060 do
											v1061[v3803] = v78[v1062 + v3803];
										end
									else
										local v1077;
										v78[v80[2]] = v78[v80[10 - 7]];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[742 - (396 + 343)];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1479 - (29 + 1448)]] = v80[1392 - (135 + 1254)];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v1077 = v80[2];
										v78[v1077] = v78[v1077](v13(v78, v1077 + (4 - 3), v80[2 + 1]));
										v72 = v72 + (1528 - (389 + 1138));
										v80 = v68[v72];
										v78[v80[576 - (102 + 472)]][v78[v80[3 + 0]]] = v78[v80[3 + 1]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1547 - (320 + 1225)]] = v80[5 - 2];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										for v3806 = v80[1466 - (157 + 1307)], v80[1862 - (821 + 1038)] do
											v78[v3806] = nil;
										end
									end
								elseif (v81 <= (42 - 25)) then
									if (v81 == (2 + 14)) then
										v78[v80[3 - 1]][v78[v80[2 + 1]]] = v78[v80[9 - 5]];
										v72 = v72 + (1027 - (834 + 192));
										v80 = v68[v72];
										v78[v80[2]] = v80[1 + 2];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[4 - 1]][v78[v80[308 - (300 + 4)]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v80[7 - 4];
										v72 = v72 + (363 - (112 + 250));
										v80 = v68[v72];
										v78[v80[1 + 1]][v78[v80[7 - 4]]] = v78[v80[3 + 1]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[3 + 1]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[3 + 0];
										v72 = v72 + (1415 - (1001 + 413));
										v80 = v68[v72];
										v78[v80[4 - 2]] = v78[v80[3]][v78[v80[886 - (244 + 638)]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[695 - (627 + 66)]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[5 - 3]] = v80[605 - (512 + 90)];
									else
										v78[v80[1908 - (1665 + 241)]][v78[v80[3]]] = v78[v80[721 - (373 + 344)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[7 - 4];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 - 0]] = v78[v80[1102 - (35 + 1064)]][v78[v80[4]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[1 + 2];
										v72 = v72 + (1237 - (298 + 938));
										v80 = v68[v72];
										v78[v80[2]][v78[v80[1262 - (233 + 1026)]]] = v78[v80[4]];
										v72 = v72 + (1667 - (636 + 1030));
										v80 = v68[v72];
										v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[2 + 2]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v80[224 - (55 + 166)];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[11 - 8]][v78[v80[4]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[299 - (36 + 261)]] = {};
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
									end
								elseif ((v81 == (1386 - (34 + 1334))) or (4304 < 3469)) then
									v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + (1284 - (1035 + 248));
									v80 = v68[v72];
									v78[v80[23 - (20 + 1)]] = v80[2 + 1];
									v72 = v72 + (320 - (134 + 185));
									v80 = v68[v72];
									v78[v80[1135 - (549 + 584)]] = v78[v80[3]][v78[v80[689 - (314 + 371)]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[971 - (478 + 490)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[1175 - (786 + 386)]]] = v78[v80[12 - 8]];
									v72 = v72 + (1380 - (1055 + 324));
									v80 = v68[v72];
									v78[v80[1342 - (1093 + 247)]][v78[v80[3 + 0]]] = v78[v80[1 + 3]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v80[9 - 6];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[2 + 1]][v78[v80[15 - 11]]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[690 - (364 + 324)]] = v80[7 - 4];
								elseif (v78[v80[4 - 2]] == v78[v80[2 + 2]]) then
									v72 = v72 + 1;
								else
									v72 = v80[12 - 9];
								end
							elseif ((v81 <= (34 - 12)) or (2713 > 4455)) then
								if (v81 <= (60 - 40)) then
									local v159;
									local v160;
									local v161;
									v78[v80[1270 - (1249 + 19)]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[1089 - (686 + 400)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[232 - (73 + 156)]][v78[v80[4]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[813 - (721 + 90)]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[473 - (224 + 246)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[3]][v78[v80[6 - 2]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v161 = v80[1 + 1];
									v160 = v78[v161];
									v159 = v80[3];
									for v913 = 1 + 0, v159 do
										v160[v913] = v78[v161 + v913];
									end
								elseif (v81 > (41 - 20)) then
									local v1146 = 0 - 0;
									local v1147;
									local v1148;
									local v1149;
									while true do
										if (v1146 == (520 - (203 + 310))) then
											for v6822 = 1, v1147 do
												v1148[v6822] = v78[v1149 + v6822];
											end
											break;
										end
										if (v1146 == (1994 - (1238 + 755))) then
											v78[v80[1 + 1]] = v80[1537 - (709 + 825)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1146 = 3 - 1;
										end
										if (v1146 == (5 - 1)) then
											v78[v80[866 - (196 + 668)]] = v80[11 - 8];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1146 = 5;
										end
										if (v1146 == 2) then
											v78[v80[835 - (171 + 662)]] = v78[v80[96 - (4 + 89)]][v78[v80[13 - 9]]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1146 = 13 - 10;
										end
										if (v1146 == (2 + 1)) then
											v78[v80[1488 - (35 + 1451)]] = {};
											v72 = v72 + (1454 - (28 + 1425));
											v80 = v68[v72];
											v1146 = 1997 - (941 + 1052);
										end
										if ((v1146 == (5 + 0)) or (2315 > 4254)) then
											v78[v80[1516 - (822 + 692)]] = v78[v80[3 - 0]][v78[v80[2 + 2]]];
											v72 = v72 + (298 - (45 + 252));
											v80 = v68[v72];
											v1146 = 6;
										end
										if (v1146 == 6) then
											v1149 = v80[2 + 0];
											v1148 = v78[v1149];
											v1147 = v80[2 + 1];
											v1146 = 16 - 9;
										end
										if (v1146 == (433 - (114 + 319))) then
											v1147 = nil;
											v1148 = nil;
											v1149 = nil;
											v1146 = 1 - 0;
										end
									end
								else
									local v1150 = 0 - 0;
									while true do
										if (v1150 == (2 + 1)) then
											v78[v80[2 - 0]][v78[v80[5 - 2]]] = v78[v80[1967 - (556 + 1407)]];
											v72 = v72 + (1207 - (741 + 465));
											v80 = v68[v72];
											v78[v80[2]][v78[v80[468 - (170 + 295)]]] = v78[v80[3 + 1]];
											v1150 = 4 + 0;
										end
										if (v1150 == 1) then
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[2 + 1]][v78[v80[3 + 1]]];
											v72 = v72 + (1231 - (957 + 273));
											v1150 = 2;
										end
										if (v1150 == 5) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[2 + 1]][v78[v80[15 - 11]]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v1150 = 18 - 12;
										end
										if (v1150 == 4) then
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (1781 - (389 + 1391));
											v1150 = 4 + 1;
										end
										if ((1 + 5) == v1150) then
											v78[v80[4 - 2]] = {};
											v72 = v72 + (952 - (783 + 168));
											v80 = v68[v72];
											v78[v80[6 - 4]] = v80[3 + 0];
											break;
										end
										if ((v1150 == (313 - (309 + 2))) or (2431 > 3602)) then
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[1215 - (1090 + 122)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1150 = 9 - 6;
										end
										if (v1150 == (0 + 0)) then
											v78[v80[1120 - (628 + 490)]][v78[v80[1 + 2]]] = v78[v80[4]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[9 - 7]] = v80[777 - (431 + 343)];
											v1150 = 1 - 0;
										end
									end
								end
							elseif (v81 <= 24) then
								if (v81 > (66 - 43)) then
									do
										return;
									end
								else
									local v1151 = 0;
									local v1152;
									while true do
										if ((1394 == 1394) and (v1151 == (18 + 4))) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[1698 - (556 + 1139)];
											v72 = v72 + (16 - (6 + 9));
											v80 = v68[v72];
											v1152 = v80[1 + 1];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1, v80[2 + 1]));
											v72 = v72 + (170 - (28 + 141));
											v80 = v68[v72];
											v1151 = 23;
										end
										if ((v1151 == (0 + 0)) or (4827 < 2256)) then
											v1152 = nil;
											v78[v80[2]] = v80[3 - 0];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[1319 - (486 + 831)];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (2 - 1), v80[10 - 7]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1151 = 1;
										end
										if (v1151 == 21) then
											v78[v80[2]][v80[9 - 6]] = v78[v80[1267 - (668 + 595)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[8 - 5]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[292 - (23 + 267)]] = v80[1947 - (1129 + 815)];
											v72 = v72 + (388 - (371 + 16));
											v1151 = 22;
										end
										if (v1151 == (1761 - (1326 + 424))) then
											v78[v80[3 - 1]][v80[10 - 7]] = v78[v80[4]];
											v72 = v72 + (119 - (88 + 30));
											v80 = v68[v72];
											v78[v80[773 - (720 + 51)]] = v78[v80[6 - 3]];
											v72 = v72 + (1777 - (421 + 1355));
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[2 + 1];
											v72 = v72 + (1084 - (286 + 797));
											v1151 = 12;
										end
										if ((v1151 == (62 - 45)) or (3466 >= 3471)) then
											v78[v80[2 - 0]][v80[3]] = v78[v80[443 - (397 + 42)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[803 - (24 + 776)]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[787 - (222 + 563)]] = v80[6 - 3];
											v72 = v72 + 1;
											v1151 = 18;
										end
										if (v1151 == (6 + 2)) then
											v80 = v68[v72];
											v78[v80[192 - (23 + 167)]] = v80[1801 - (690 + 1108)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1, v80[3 + 0]));
											v72 = v72 + (849 - (40 + 808));
											v80 = v68[v72];
											v1151 = 9;
										end
										if (v1151 == (2 + 10)) then
											v80 = v68[v72];
											v78[v80[7 - 5]] = v80[3 + 0];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1 + 0, v80[574 - (47 + 524)]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1151 = 35 - 22;
										end
										if ((v1151 == (22 - 7)) or (1688 <= 1418)) then
											v78[v80[4 - 2]][v80[1729 - (1165 + 561)]] = v78[v80[1 + 3]];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[482 - (341 + 138)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[3 - 1]] = v80[329 - (89 + 237)];
											v72 = v72 + (3 - 2);
											v1151 = 33 - 17;
										end
										if (v1151 == (890 - (581 + 300))) then
											v78[v80[2]][v80[1223 - (855 + 365)]] = v78[v80[9 - 5]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[1238 - (1030 + 205)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[289 - (156 + 130)];
											v72 = v72 + (2 - 1);
											v1151 = 10;
										end
										if (v1151 == (31 - 12)) then
											v78[v80[3 - 1]][v80[1 + 2]] = v78[v80[4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[71 - (10 + 59)]] = v78[v80[1 + 2]];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v78[v80[1165 - (671 + 492)]] = v80[3 + 0];
											v72 = v72 + 1;
											v1151 = 20;
										end
										if ((1243 - (369 + 846)) == v1151) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[3 + 0];
											v72 = v72 + (1946 - (1036 + 909));
											v80 = v68[v72];
											v1152 = v80[2 + 0];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (1 - 0), v80[3]));
											v72 = v72 + (204 - (11 + 192));
											v80 = v68[v72];
											v1151 = 15 + 14;
										end
										if ((v1151 == 24) or (4350 <= 2953)) then
											v80 = v68[v72];
											v78[v80[177 - (135 + 40)]] = v80[6 - 3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (2 - 1), v80[4 - 1]));
											v72 = v72 + (177 - (50 + 126));
											v80 = v68[v72];
											v1151 = 69 - 44;
										end
										if (v1151 == (2 + 4)) then
											v80 = v68[v72];
											v78[v80[2]] = v80[1416 - (1233 + 180)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1152 = v80[971 - (522 + 447)];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (1422 - (107 + 1314)), v80[2 + 1]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v1151 = 3 + 4;
										end
										if ((v1151 == 4) or (4362 >= 4894)) then
											v80 = v68[v72];
											v78[v80[2]] = v80[5 - 2];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v1152 = v80[1912 - (716 + 1194)];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1 + 0, v80[1 + 2]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v1151 = 508 - (74 + 429);
										end
										if (v1151 == (51 - 24)) then
											v78[v80[1 + 1]][v80[3]] = v78[v80[4]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[8 - 5]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2]] = v80[436 - (279 + 154)];
											v72 = v72 + (779 - (454 + 324));
											v1151 = 23 + 5;
										end
										if (v1151 == (40 - (12 + 5))) then
											v78[v80[2 + 0]][v80[7 - 4]] = v78[v80[2 + 2]];
											v72 = v72 + (1094 - (277 + 816));
											v80 = v68[v72];
											v78[v80[8 - 6]] = v78[v80[1186 - (1058 + 125)]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[1 + 2];
											v72 = v72 + 1;
											v1151 = 24;
										end
										if ((4266 >= 1425) and (v1151 == (1001 - (815 + 160)))) then
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v1152 = v80[2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (2 - 1), v80[3]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1151 = 27;
										end
										if ((648 <= 2263) and (v1151 == 29)) then
											v78[v80[2]][v80[8 - 5]] = v78[v80[4]];
											v72 = v72 + (1899 - (41 + 1857));
											v80 = v68[v72];
											v78[v80[1895 - (1222 + 671)]] = v78[v80[3]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[1185 - (229 + 953)];
											v72 = v72 + 1;
											v1151 = 30;
										end
										if ((2280 < 3987) and (v1151 == (1776 - (1111 + 663)))) then
											v80 = v68[v72];
											v78[v80[1581 - (874 + 705)]] = v80[1 + 2];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[3 - 1];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1, v80[1 + 2]));
											v72 = v72 + (680 - (642 + 37));
											v80 = v68[v72];
											v1151 = 3;
										end
										if ((v1151 == 31) or (365 > 1874)) then
											v78[v80[1 + 1]][v80[1 + 2]] = v78[v80[9 - 5]];
											v72 = v72 + (455 - (233 + 221));
											v80 = v68[v72];
											v78[v80[4 - 2]] = v78[v80[3 + 0]];
											v72 = v72 + (1542 - (718 + 823));
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											break;
										end
										if ((4 + 1) == v1151) then
											v78[v80[2]][v80[808 - (266 + 539)]] = v78[v80[11 - 7]];
											v72 = v72 + (1226 - (636 + 589));
											v80 = v68[v72];
											v78[v80[4 - 2]] = v78[v80[3]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[2 + 1];
											v72 = v72 + 1;
											v1151 = 1021 - (657 + 358);
										end
										if (v1151 == (52 - 32)) then
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[3];
											v72 = v72 + (1188 - (1151 + 36));
											v80 = v68[v72];
											v1152 = v80[2 + 0];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1 + 0, v80[8 - 5]));
											v72 = v72 + (1833 - (1552 + 280));
											v80 = v68[v72];
											v1151 = 855 - (64 + 770);
										end
										if (v1151 == (7 + 3)) then
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[1 + 2];
											v72 = v72 + (1244 - (157 + 1086));
											v80 = v68[v72];
											v1152 = v80[2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (1 - 0), v80[13 - 10]));
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1151 = 14 - 3;
										end
										if (v1151 == (849 - (599 + 220))) then
											v80 = v68[v72];
											v78[v80[3 - 1]] = v80[1934 - (1813 + 118)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (1218 - (841 + 376)), v80[3 - 0]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v1151 = 8 + 23;
										end
										if (v1151 == 7) then
											v78[v80[5 - 3]][v80[862 - (464 + 395)]] = v78[v80[4]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v78[v80[2 + 1]];
											v72 = v72 + (838 - (467 + 370));
											v80 = v68[v72];
											v78[v80[3 - 1]] = v80[3 + 0];
											v72 = v72 + (3 - 2);
											v1151 = 8;
										end
										if (v1151 == (4 + 21)) then
											v78[v80[4 - 2]][v80[523 - (150 + 370)]] = v78[v80[1286 - (74 + 1208)]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[9 - 7]] = v78[v80[3 + 0]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[393 - (14 + 376)];
											v72 = v72 + (1 - 0);
											v1151 = 26;
										end
										if ((v1151 == (1 + 0)) or (4549 < 1567)) then
											v78[v80[2 + 0]][v80[3 + 0]] = v78[v80[11 - 7]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[3 + 0]];
											v72 = v72 + (79 - (23 + 55));
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[3 + 0];
											v72 = v72 + 1 + 0;
											v1151 = 2 - 0;
										end
										if (v1151 == (5 + 8)) then
											v78[v80[903 - (652 + 249)]][v80[7 - 4]] = v78[v80[4]];
											v72 = v72 + (1869 - (708 + 1160));
											v80 = v68[v72];
											v78[v80[5 - 3]] = v78[v80[3]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2]] = v80[30 - (10 + 17)];
											v72 = v72 + 1 + 0;
											v1151 = 1746 - (1400 + 332);
										end
										if ((4109 == 4109) and (v1151 == (5 - 2))) then
											v78[v80[2]][v80[1911 - (242 + 1666)]] = v78[v80[2 + 2]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[3 + 0]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[942 - (850 + 90)]] = v80[4 - 1];
											v72 = v72 + (1391 - (360 + 1030));
											v1151 = 4 + 0;
										end
										if (v1151 == (39 - 25)) then
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[1664 - (909 + 752)];
											v72 = v72 + (1224 - (109 + 1114));
											v80 = v68[v72];
											v1152 = v80[3 - 1];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1 + 0, v80[245 - (6 + 236)]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v1151 = 15;
										end
										if (v1151 == (12 + 6)) then
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1152 = v80[4 - 2];
											v78[v1152] = v78[v1152](v13(v78, v1152 + (1 - 0), v80[1136 - (1076 + 57)]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v1151 = 19;
										end
										if (v1151 == 16) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[692 - (579 + 110)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1152 = v80[2 + 0];
											v78[v1152] = v78[v1152](v13(v78, v1152 + 1 + 0, v80[410 - (174 + 233)]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v1151 = 29 - 12;
										end
									end
								end
							elseif (v81 == (12 + 13)) then
								v78[v80[2]][v78[v80[1177 - (663 + 511)]]] = v78[v80[4 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[9 - 5]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[5 - 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[725 - (478 + 244)]]] = v78[v80[521 - (440 + 77)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[7 - 5]][v78[v80[1559 - (655 + 901)]]] = v78[v80[1 + 3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[11 - 8];
								v72 = v72 + (1446 - (695 + 750));
								v80 = v68[v72];
								v78[v80[6 - 4]] = v78[v80[3 - 0]][v78[v80[15 - 11]]];
								v72 = v72 + (352 - (285 + 66));
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1312 - (682 + 628)]] = v80[1 + 2];
							else
								v78[v80[2]][v78[v80[302 - (176 + 123)]]] = v78[v80[2 + 2]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[271 - (239 + 30)]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[4 - 1]][v78[v80[12 - 8]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[317 - (306 + 9)]] = v80[10 - 7];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[2 + 1]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3]]] = v78[v80[11 - 7]];
								v72 = v72 + (1376 - (1140 + 235));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3 + 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[54 - (33 + 19)]] = v78[v80[2 + 1]][v78[v80[11 - 7]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[3 - 1]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[691 - (586 + 103)]] = v80[1 + 2];
							end
						elseif (v81 <= 39) then
							if (v81 <= 32) then
								if (v81 <= (89 - 60)) then
									if (v81 <= (1515 - (1309 + 179))) then
										v78[v80[2 - 0]][v78[v80[2 + 1]]] = v78[v80[4]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[5 - 2];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[611 - (295 + 314)]] = v78[v80[6 - 3]][v78[v80[1966 - (1300 + 662)]]];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v78[v80[1757 - (1178 + 577)]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[5 - 3]][v78[v80[1408 - (851 + 554)]]] = v78[v80[4 + 0]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[3 - 1]][v78[v80[305 - (115 + 187)]]] = v78[v80[4 + 0]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[7 - 5]] = v80[3];
										v72 = v72 + (1162 - (160 + 1001));
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3 + 0]][v78[v80[3 + 1]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[3 - 1]] = {};
										v72 = v72 + (359 - (237 + 121));
										v80 = v68[v72];
										v78[v80[899 - (525 + 372)]] = v80[4 - 1];
									elseif ((v81 > 28) or (3157 < 315)) then
										local v1191;
										local v1192;
										local v1193;
										v78[v80[2]] = {};
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v78[v80[2]] = v80[145 - (96 + 46)];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[780 - (643 + 134)]][v78[v80[2 + 2]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = {};
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[7 - 5]] = v80[3 + 0];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[3 - 1]] = v78[v80[722 - (316 + 403)]][v78[v80[3 + 1]]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v1193 = v80[1 + 1];
										v1192 = v78[v1193];
										v1191 = v80[7 - 4];
										for v3808 = 1 + 0, v1191 do
											v1192[v3808] = v78[v1193 + v3808];
										end
									else
										local v1205;
										local v1206;
										local v1207;
										v78[v80[1 + 1]] = v80[10 - 7];
										v72 = v72 + (4 - 3);
										v80 = v68[v72];
										v78[v80[3 - 1]] = v78[v80[1 + 2]][v78[v80[7 - 3]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = {};
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[19 - (12 + 5)]] = v80[11 - 8];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[3 - 1]] = v78[v80[7 - 4]][v78[v80[1 + 3]]];
										v72 = v72 + (1974 - (1656 + 317));
										v80 = v68[v72];
										v1207 = v80[2 + 0];
										v1206 = v78[v1207];
										v1205 = v80[3];
										for v3811 = 1 + 0, v1205 do
											v1206[v3811] = v78[v1207 + v3811];
										end
									end
								elseif (v81 <= (79 - 49)) then
									local v194;
									local v195;
									local v196;
									v78[v80[9 - 7]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[357 - (5 + 349)];
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[1273 - (266 + 1005)]] = v78[v80[2 + 1]][v78[v80[4]]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 - 0]] = {};
									v72 = v72 + (1697 - (561 + 1135));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[9 - 6];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1068 - (507 + 559)]] = v78[v80[7 - 4]][v78[v80[12 - 8]]];
									v72 = v72 + (389 - (212 + 176));
									v80 = v68[v72];
									v196 = v80[907 - (250 + 655)];
									v195 = v78[v196];
									v194 = v80[8 - 5];
									for v916 = 1 - 0, v194 do
										v195[v916] = v78[v196 + v916];
									end
								elseif ((v81 > 31) or (2939 <= 2421)) then
									v78[v80[2 - 0]] = v78[v80[1959 - (1869 + 87)]] % v78[v80[4]];
								else
									v78[v80[6 - 4]][v78[v80[3]]] = v78[v80[1905 - (484 + 1417)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[776 - (48 + 725)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[2 + 1]][v78[v80[10 - 6]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[857 - (152 + 701)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1313 - (430 + 881)]][v78[v80[2 + 1]]] = v78[v80[899 - (557 + 338)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[10 - 7];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[804 - (499 + 302)]][v78[v80[870 - (39 + 827)]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[11 - 8];
								end
							elseif (v81 <= (53 - 18)) then
								if (v81 <= (3 + 30)) then
									local v210;
									local v211;
									local v212;
									v78[v80[2]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[1 + 2];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[107 - (103 + 1)]][v78[v80[558 - (475 + 79)]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[6 - 4]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1506 - (1395 + 108)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1206 - (7 + 1197)]] = v78[v80[2 + 1]][v78[v80[2 + 2]]];
									v72 = v72 + (320 - (27 + 292));
									v80 = v68[v72];
									v212 = v80[2];
									v211 = v78[v212];
									v210 = v80[8 - 5];
									for v919 = 1 - 0, v210 do
										v211[v919] = v78[v212 + v919];
									end
								elseif (v81 > (142 - 108)) then
									v78[v80[2]] = #v78[v80[5 - 2]];
								else
									v78[v80[3 - 1]][v78[v80[142 - (43 + 96)]]] = v78[v80[16 - 12]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[2 + 1]][v78[v80[7 - 3]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1754 - (1414 + 337)];
									v72 = v72 + (1941 - (1642 + 298));
									v80 = v68[v72];
									v78[v80[4 - 2]][v78[v80[8 - 5]]] = v78[v80[11 - 7]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[4 + 0]];
									v72 = v72 + (973 - (357 + 615));
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[6 - 3]][v78[v80[4 + 0]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1304 - (384 + 917)];
								end
							elseif (v81 <= (734 - (128 + 569))) then
								if ((2240 < 2699) and (v81 == (1579 - (1407 + 136)))) then
									local v1255 = 0;
									local v1256;
									local v1257;
									local v1258;
									while true do
										if (v1255 == (1890 - (687 + 1200))) then
											v78[v80[1712 - (556 + 1154)]] = {};
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[97 - (9 + 86)]] = v80[424 - (275 + 146)];
											v1255 = 1 + 3;
										end
										if (v1255 == (65 - (29 + 35))) then
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (2 - 1);
											v1255 = 8 - 6;
										end
										if ((v1255 == 2) or (3055 <= 2818)) then
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[1015 - (53 + 959)]][v78[v80[412 - (312 + 96)]]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1255 = 3;
										end
										if ((v1255 == (8 - 3)) or (4716 <= 2804)) then
											v80 = v68[v72];
											v1258 = v80[287 - (147 + 138)];
											v1257 = v78[v1258];
											v1256 = v80[3];
											v1255 = 905 - (813 + 86);
										end
										if ((v1255 == (4 + 0)) or (393 > 4241)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[3 - 1]] = v78[v80[495 - (18 + 474)]][v78[v80[2 + 2]]];
											v72 = v72 + (3 - 2);
											v1255 = 1091 - (860 + 226);
										end
										if (v1255 == 6) then
											for v6825 = 304 - (121 + 182), v1256 do
												v1257[v6825] = v78[v1258 + v6825];
											end
											break;
										end
										if (0 == v1255) then
											v1256 = nil;
											v1257 = nil;
											v1258 = nil;
											v78[v80[1 + 1]] = {};
											v1255 = 1;
										end
									end
								else
									local v1259 = 0;
									local v1260;
									local v1261;
									local v1262;
									while true do
										if ((1241 - (988 + 252)) == v1259) then
											v78[v80[1 + 1]] = v80[1 + 2];
											v72 = v72 + (1971 - (49 + 1921));
											v80 = v68[v72];
											v1259 = 892 - (223 + 667);
										end
										if (v1259 == (56 - (51 + 1))) then
											v78[v80[2 - 0]] = v80[3];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1259 = 1130 - (146 + 979);
										end
										if (v1259 == (1 + 1)) then
											v78[v80[607 - (311 + 294)]] = v78[v80[8 - 5]][v78[v80[2 + 2]]];
											v72 = v72 + (1444 - (496 + 947));
											v80 = v68[v72];
											v1259 = 1361 - (1233 + 125);
										end
										if (v1259 == (3 + 3)) then
											v1262 = v80[2 + 0];
											v1261 = v78[v1262];
											v1260 = v80[1 + 2];
											v1259 = 1652 - (963 + 682);
										end
										if (v1259 == (3 + 0)) then
											v78[v80[1506 - (504 + 1000)]] = {};
											v72 = v72 + 1;
											v80 = v68[v72];
											v1259 = 3 + 1;
										end
										if ((4501 > 4485) and (5 == v1259)) then
											v78[v80[2]] = v78[v80[3 + 0]][v78[v80[1 + 3]]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1259 = 6 + 0;
										end
										if ((1661 <= 3530) and ((5 + 2) == v1259)) then
											for v6828 = 183 - (156 + 26), v1260 do
												v1261[v6828] = v78[v1262 + v6828];
											end
											break;
										end
										if (v1259 == (0 + 0)) then
											v1260 = nil;
											v1261 = nil;
											v1262 = nil;
											v1259 = 1 - 0;
										end
									end
								end
							elseif ((v81 > (202 - (149 + 15))) or (1382 >= 4993)) then
								local v1263;
								local v1264;
								local v1265;
								v78[v80[962 - (890 + 70)]] = v80[120 - (39 + 78)];
								v72 = v72 + (483 - (14 + 468));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[8 - 5]][v78[v80[4]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[3]][v78[v80[4 + 0]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v1265 = v80[1 + 1];
								v1264 = v78[v1265];
								v1263 = v80[54 - (12 + 39)];
								for v3814 = 1 + 0, v1263 do
									v1264[v3814] = v78[v1265 + v3814];
								end
							else
								v78[v80[5 - 3]] = v60[v80[10 - 7]];
							end
						elseif (v81 <= (14 + 32)) then
							if (v81 <= 42) then
								if (v81 <= (22 + 18)) then
									local v226 = 0 - 0;
									while true do
										if (v226 == (4 + 2)) then
											v78[v80[9 - 7]] = {};
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1712 - (1596 + 114)]] = v80[3];
											break;
										end
										if (v226 == (10 - 6)) then
											v72 = v72 + (714 - (164 + 549));
											v80 = v68[v72];
											v78[v80[1440 - (1059 + 379)]] = v80[3];
											v72 = v72 + 1;
											v226 = 6 - 1;
										end
										if (v226 == (0 + 0)) then
											v78[v80[1 + 1]][v78[v80[395 - (145 + 247)]]] = v78[v80[4 + 0]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[1 + 2];
											v226 = 1 + 0;
										end
										if (v226 == (4 - 1)) then
											v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
											v72 = v72 + (721 - (254 + 466));
											v80 = v68[v72];
											v78[v80[2]][v78[v80[3]]] = v78[v80[564 - (544 + 16)]];
											v226 = 4;
										end
										if ((1 == v226) or (3137 == 2260)) then
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[631 - (294 + 334)]][v78[v80[257 - (236 + 17)]]];
											v72 = v72 + 1;
											v226 = 1 + 1;
										end
										if (v226 == 5) then
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[10 - 7]][v78[v80[18 - 14]]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v226 = 5 + 1;
										end
										if (v226 == (796 - (413 + 381))) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[3];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v226 = 7 - 4;
										end
									end
								elseif (v81 > 41) then
									local v1281 = v80[1972 - (582 + 1388)];
									local v1282, v1283 = v71(v78[v1281](v13(v78, v1281 + 1, v73)));
									v73 = (v1283 + v1281) - (1 - 0);
									local v1284 = 0 + 0;
									for v3842 = v1281, v73 do
										v1284 = v1284 + 1;
										v78[v3842] = v1282[v1284];
									end
								else
									v78[v80[2]][v78[v80[367 - (326 + 38)]]] = v78[v80[11 - 7]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[623 - (47 + 573)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[8 - 6]] = v78[v80[4 - 1]][v78[v80[4]]];
									v72 = v72 + (1665 - (1269 + 395));
									v80 = v68[v72];
									v78[v80[494 - (76 + 416)]] = v80[446 - (319 + 124)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[3]][v78[v80[1011 - (564 + 443)]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[460 - (337 + 121)]][v78[v80[3]]] = v78[v80[11 - 7]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1913 - (1261 + 650)]][v78[v80[3]]] = v78[v80[2 + 2]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[1820 - (772 + 1045)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[146 - (102 + 42)]] = v78[v80[1847 - (1524 + 320)]][v78[v80[1274 - (1049 + 221)]]];
									v72 = v72 + (157 - (18 + 138));
									v80 = v68[v72];
									v78[v80[4 - 2]] = {};
								end
							elseif ((4244 > 2705) and (v81 <= (1146 - (67 + 1035)))) then
								if (v81 > (391 - (136 + 212))) then
									local v1302;
									local v1303;
									local v1304;
									v78[v80[2]] = {};
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]][v78[v80[4]]];
									v72 = v72 + (1605 - (240 + 1364));
									v80 = v68[v72];
									v78[v80[2]] = {};
									v72 = v72 + (1083 - (1050 + 32));
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[2 + 1];
									v72 = v72 + (1056 - (331 + 724));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1 + 2]][v78[v80[648 - (269 + 375)]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1304 = v80[727 - (267 + 458)];
									v1303 = v78[v1304];
									v1302 = v80[1 + 2];
									for v3845 = 1 - 0, v1302 do
										v1303[v3845] = v78[v1304 + v3845];
									end
								else
									local v1315;
									v78[v80[820 - (667 + 151)]] = v78[v80[3]];
									v72 = v72 + (1498 - (1410 + 87));
									v80 = v68[v72];
									v78[v80[1899 - (1504 + 393)]] = v80[8 - 5];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[798 - (461 + 335)]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1315 = v80[1763 - (1730 + 31)];
									v78[v1315] = v78[v1315](v13(v78, v1315 + 1, v80[1670 - (728 + 939)]));
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[6 - 3]]] = v78[v80[1072 - (138 + 930)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[8 - 6]] = v78[v80[1769 - (459 + 1307)]];
									v72 = v72 + (1871 - (474 + 1396));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v1315 = v80[1 + 1];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (3 - 2), v80[3]));
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[593 - (562 + 29)]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + (1420 - (374 + 1045));
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[9 - 6]];
									v72 = v72 + (639 - (448 + 190));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[8 - 5];
									v72 = v72 + (1495 - (1307 + 187));
									v80 = v68[v72];
									v1315 = v80[7 - 5];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (2 - 1), v80[8 - 5]));
									v72 = v72 + (684 - (232 + 451));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[567 - (510 + 54)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[39 - (13 + 23)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3 - 0];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1090 - (830 + 258)]] = v80[10 - 7];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1315 = v80[2 + 0];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (1442 - (860 + 581)), v80[10 - 7]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[244 - (237 + 4)]]] = v78[v80[9 - 5]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1429 - (85 + 1341)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[8 - 5];
									v72 = v72 + (373 - (45 + 327));
									v80 = v68[v72];
									v1315 = v80[2];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (1 - 0), v80[505 - (444 + 58)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[2 + 1]]] = v78[v80[11 - 7]];
									v72 = v72 + (1733 - (64 + 1668));
									v80 = v68[v72];
									v78[v80[1975 - (1227 + 746)]] = v80[9 - 6];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[496 - (415 + 79)]] = v78[v80[1 + 2]];
									v72 = v72 + (492 - (142 + 349));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 - 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[7 - 4];
									v72 = v72 + (1865 - (1710 + 154));
									v80 = v68[v72];
									v1315 = v80[320 - (200 + 118)];
									v78[v1315] = v78[v1315](v13(v78, v1315 + 1 + 0, v80[5 - 2]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[1253 - (363 + 887)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[14 - 11];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[6 - 3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1315 = v80[1666 - (674 + 990)];
									v78[v1315] = v78[v1315](v13(v78, v1315 + 1, v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3 - 0]]] = v78[v80[4]];
									v72 = v72 + (1056 - (507 + 548));
									v80 = v68[v72];
									v78[v80[839 - (289 + 548)]] = v80[3];
									v72 = v72 + (1819 - (821 + 997));
									v80 = v68[v72];
									v78[v80[257 - (195 + 60)]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1503 - (251 + 1250)]] = v80[8 - 5];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1034 - (809 + 223)]] = v80[3 - 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v1315 = v80[6 - 4];
									v78[v1315] = v78[v1315](v13(v78, v1315 + 1, v80[3 + 0]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[619 - (14 + 603)]][v78[v80[132 - (118 + 11)]]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 + 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[951 - (551 + 398)]] = v78[v80[2 + 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 + 0];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v80[6 - 3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1315 = v80[7 - 5];
									v78[v1315] = v78[v1315](v13(v78, v1315 + 1, v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[91 - (40 + 49)]][v78[v80[3]]] = v78[v80[15 - 11]];
									v72 = v72 + (491 - (99 + 391));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[13 - 10];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1606 - (1032 + 572)]] = v80[420 - (203 + 214)];
									v72 = v72 + (1818 - (568 + 1249));
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v1315 = v80[7 - 5];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (1307 - (913 + 393)), v80[8 - 5]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[3]]] = v78[v80[414 - (269 + 141)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1983 - (362 + 1619)]] = v80[1628 - (950 + 675)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1181 - (216 + 963)]] = v78[v80[1290 - (485 + 802)]];
									v72 = v72 + (560 - (432 + 127));
									v80 = v68[v72];
									v78[v80[1075 - (1065 + 8)]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1603 - (635 + 966)]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1315 = v80[2 + 0];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (43 - (5 + 37)), v80[7 - 4]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[3]]] = v78[v80[2 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[5 - 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[3]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[531 - (318 + 211)]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1315 = v80[9 - 7];
									v78[v1315] = v78[v1315](v13(v78, v1315 + (1588 - (963 + 624)), v80[2 + 1]));
									v72 = v72 + (847 - (518 + 328));
									v80 = v68[v72];
									v78[v80[4 - 2]][v78[v80[3]]] = v78[v80[6 - 2]];
									v72 = v72 + (318 - (301 + 16));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[8 - 5];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[1 + 2];
									v72 = v72 + (1020 - (829 + 190));
									v80 = v68[v72];
									v1315 = v80[7 - 5];
									v78[v1315] = v78[v1315](v13(v78, v1315 + 1, v80[3 - 0]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[7 - 4]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[8 - 5];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[616 - (520 + 93)]];
									v72 = v72 + (277 - (259 + 17));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[2 + 1];
								end
							elseif (v81 == (152 - 107)) then
								local v1402;
								local v1403;
								local v1404;
								v78[v80[593 - (396 + 195)]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1764 - (440 + 1321)]][v78[v80[1833 - (1059 + 770)]]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + (546 - (424 + 121));
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + (1348 - (641 + 706));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[2 + 1]][v78[v80[444 - (249 + 191)]]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v1404 = v80[1 + 1];
								v1403 = v78[v1404];
								v1402 = v80[3];
								for v3848 = 3 - 2, v1402 do
									v1403[v3848] = v78[v1404 + v3848];
								end
							else
								v78[v80[429 - (183 + 244)]][v78[v80[1 + 2]]] = v78[v80[734 - (434 + 296)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[514 - (169 + 343)]] = v80[3 + 0];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[8 - 5]][v78[v80[4 + 0]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1125 - (651 + 472)]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[2 + 2]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[485 - (397 + 86)]][v78[v80[3]]] = v78[v80[880 - (423 + 453)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3 + 0]][v78[v80[1194 - (50 + 1140)]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[2 + 1];
							end
						elseif (v81 <= (4 + 45)) then
							if ((v81 <= (67 - 20)) or (4619 < 3081)) then
								local v227;
								local v228;
								local v229;
								v78[v80[2]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[598 - (157 + 439)]] = v80[4 - 1];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[8 - 5]][v78[v80[922 - (782 + 136)]]];
								v72 = v72 + (856 - (112 + 743));
								v80 = v68[v72];
								v78[v80[1173 - (1026 + 145)]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[720 - (493 + 225)]] = v78[v80[11 - 8]][v78[v80[3 + 1]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v229 = v80[1 + 1];
								v228 = v78[v229];
								v227 = v80[3];
								for v922 = 2 - 1, v227 do
									v228[v922] = v78[v229 + v922];
								end
							elseif (v81 > (14 + 34)) then
								local v1432 = 0 - 0;
								local v1433;
								local v1434;
								local v1435;
								while true do
									if (v1432 == (1598 - (210 + 1385))) then
										v78[v80[1691 - (1201 + 488)]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2 - 0]] = v80[5 - 2];
										v1432 = 589 - (352 + 233);
									end
									if ((v1432 == 4) or (191 > 4019)) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v78[v80[2 + 1]][v78[v80[11 - 7]]];
										v72 = v72 + (575 - (489 + 85));
										v1432 = 1506 - (277 + 1224);
									end
									if ((4732 == 4732) and (v1432 == (1498 - (663 + 830)))) then
										v80 = v68[v72];
										v1435 = v80[2 + 0];
										v1434 = v78[v1435];
										v1433 = v80[6 - 3];
										v1432 = 881 - (461 + 414);
									end
									if (v1432 == (1 + 1)) then
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[3]][v78[v80[1 + 3]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1432 = 253 - (172 + 78);
									end
									if (v1432 == (0 - 0)) then
										v1433 = nil;
										v1434 = nil;
										v1435 = nil;
										v78[v80[1 + 1]] = {};
										v1432 = 1;
									end
									if (v1432 == (1 - 0)) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[4 - 1];
										v72 = v72 + (1 - 0);
										v1432 = 2;
									end
									if (v1432 == (2 + 4)) then
										for v6831 = 1 + 0, v1433 do
											v1434[v6831] = v78[v1435 + v6831];
										end
										break;
									end
								end
							else
								local v1436;
								local v1437;
								local v1438;
								v78[v80[1 + 1]] = {};
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[451 - (133 + 314)]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[215 - (199 + 14)]] = {};
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = v80[1552 - (647 + 902)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[235 - (85 + 148)]] = v78[v80[1292 - (426 + 863)]][v78[v80[18 - 14]]];
								v72 = v72 + (1655 - (873 + 781));
								v80 = v68[v72];
								v1438 = v80[2 - 0];
								v1437 = v78[v1438];
								v1436 = v80[7 - 4];
								for v3851 = 1 + 0, v1436 do
									v1437[v3851] = v78[v1438 + v3851];
								end
							end
						elseif (v81 <= (188 - 137)) then
							if (v81 > (71 - 21)) then
								local v1452 = 0;
								local v1453;
								while true do
									if ((0 - 0) == v1452) then
										v1453 = nil;
										v78[v80[1949 - (414 + 1533)]] = v80[3 + 0];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[557 - (443 + 112)]] = v80[3];
										v72 = v72 + 1;
										v1452 = 1480 - (888 + 591);
									end
									if ((3683 >= 1805) and (v1452 == (7 - 4))) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[7 - 5]] = v80[2 + 1];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[5 - 2];
										v1452 = 6 - 2;
									end
									if ((4 == v1452) or (947 > 1459)) then
										v72 = v72 + (1679 - (136 + 1542));
										v80 = v68[v72];
										v1453 = v80[2];
										v78[v1453] = v78[v1453](v13(v78, v1453 + (3 - 2), v80[3 + 0]));
										v72 = v72 + 1;
										v80 = v68[v72];
										v1452 = 7 - 2;
									end
									if (v1452 == (2 + 0)) then
										v72 = v72 + (487 - (68 + 418));
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[5 - 2];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1094 - (770 + 322)]] = v78[v80[1 + 2]];
										v1452 = 1 + 2;
									end
									if ((1245 >= 375) and ((1 + 4) == v1452)) then
										v78[v80[2 - 0]][v78[v80[5 - 2]]] = v78[v80[10 - 6]];
										break;
									end
									if ((4332 >= 309) and (v1452 == 1)) then
										v80 = v68[v72];
										v1453 = v80[7 - 5];
										v78[v1453] = v78[v1453](v13(v78, v1453 + 1 + 0, v80[4 - 1]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[4 + 0]];
										v1452 = 7 - 5;
									end
								end
							else
								local v1454;
								local v1455;
								local v1456;
								v78[v80[2 - 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[13 - 10];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[14 - 11]][v78[v80[4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[833 - (762 + 69)]] = {};
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[2 + 1];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1 + 2]][v78[v80[15 - 11]]];
								v72 = v72 + (158 - (8 + 149));
								v80 = v68[v72];
								v1456 = v80[1322 - (1199 + 121)];
								v1455 = v78[v1456];
								v1454 = v80[3];
								for v3854 = 1 - 0, v1454 do
									v1455[v3854] = v78[v1456 + v3854];
								end
							end
						elseif (v81 == (117 - 65)) then
							local v1469;
							local v1470;
							local v1471;
							v78[v80[2]] = v80[2 + 1];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3]][v78[v80[8 - 4]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = {};
							v72 = v72 + (1808 - (518 + 1289));
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[1 + 2];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3 + 0]][v78[v80[4]]];
							v72 = v72 + (470 - (304 + 165));
							v80 = v68[v72];
							v1471 = v80[2 + 0];
							v1470 = v78[v1471];
							v1469 = v80[3];
							for v3857 = 161 - (54 + 106), v1469 do
								v1470[v3857] = v78[v1471 + v3857];
							end
						else
							v78[v80[1971 - (1618 + 351)]][v78[v80[3]]] = v78[v80[3 + 1]];
							v72 = v72 + (1017 - (10 + 1006));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1 + 2];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[9 - 6]][v78[v80[4]]];
							v72 = v72 + (1034 - (912 + 121));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1292 - (1140 + 149)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[3]]] = v78[v80[1 + 3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[6 - 4]][v78[v80[5 - 2]]] = v78[v80[1 + 3]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[188 - (165 + 21)]] = v80[3];
							v72 = v72 + (112 - (61 + 50));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[14 - 11]][v78[v80[7 - 3]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1462 - (1295 + 165)]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[2 + 1];
						end
					elseif ((v81 <= (1477 - (819 + 578))) or (280 >= 4169)) then
						if (v81 <= (1468 - (331 + 1071))) then
							if (v81 <= (802 - (588 + 155))) then
								if (v81 <= (1338 - (546 + 736))) then
									if (v81 <= (1991 - (1834 + 103))) then
										local v241 = v80[2 + 0];
										local v242, v243 = v71(v78[v241](v13(v78, v241 + (2 - 1), v80[3])));
										v73 = (v243 + v241) - (1767 - (1536 + 230));
										local v244 = 491 - (128 + 363);
										for v925 = v241, v73 do
											local v926 = 0 + 0;
											while true do
												if ((2396 <= 3548) and (v926 == (0 - 0))) then
													v244 = v244 + 1 + 0;
													v78[v925] = v242[v244];
													break;
												end
											end
										end
									elseif (v81 > (90 - 35)) then
										local v1498;
										local v1499;
										local v1500;
										v78[v80[5 - 3]] = {};
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[1012 - (615 + 394)];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[3]][v78[v80[4]]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[8 - 6]] = {};
										v72 = v72 + (652 - (59 + 592));
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v78[v80[4 - 1]][v78[v80[3 + 1]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v1500 = v80[173 - (70 + 101)];
										v1499 = v78[v1500];
										v1498 = v80[7 - 4];
										for v3860 = 1 + 0, v1498 do
											v1499[v3860] = v78[v1500 + v3860];
										end
									else
										v78[v80[4 - 2]][v78[v80[244 - (123 + 118)]]] = v78[v80[1 + 3]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1401 - (653 + 746)]] = v80[3];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 - 0]] = v78[v80[7 - 4]][v78[v80[2 + 2]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v80[3 + 0];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[9 - 5]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]][v78[v80[4 - 1]]] = v78[v80[1238 - (885 + 349)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[8 - 5];
										v72 = v72 + (969 - (915 + 53));
										v80 = v68[v72];
										v78[v80[803 - (768 + 33)]] = v78[v80[11 - 8]][v78[v80[4]]];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2]] = {};
										v72 = v72 + (329 - (287 + 41));
										v80 = v68[v72];
										v78[v80[849 - (638 + 209)]] = v80[2 + 1];
									end
								elseif (v81 <= 57) then
									local v245 = 1686 - (96 + 1590);
									while true do
										if (1 == v245) then
											v72 = v72 + (1673 - (741 + 931));
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[8 - 5]][v78[v80[18 - 14]]];
											v72 = v72 + 1 + 0;
											v245 = 1 + 1;
										end
										if (v245 == 3) then
											v78[v80[1 + 1]][v78[v80[11 - 8]]] = v78[v80[4]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[2 + 2]];
											v245 = 16 - 12;
										end
										if ((v245 == (6 + 0)) or (1588 >= 3118)) then
											v78[v80[2]] = {};
											v72 = v72 + (495 - (64 + 430));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[366 - (106 + 257)];
											break;
										end
										if (v245 == (0 + 0)) then
											v78[v80[723 - (496 + 225)]][v78[v80[5 - 2]]] = v78[v80[19 - 15]];
											v72 = v72 + (1659 - (256 + 1402));
											v80 = v68[v72];
											v78[v80[1901 - (30 + 1869)]] = v80[1372 - (213 + 1156)];
											v245 = 189 - (96 + 92);
										end
										if ((v245 == 4) or (2121 <= 1356)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[902 - (142 + 757)];
											v72 = v72 + 1;
											v245 = 5 + 0;
										end
										if ((3807 > 3095) and (v245 == (1 + 1))) then
											v80 = v68[v72];
											v78[v80[81 - (32 + 47)]] = v80[1980 - (1053 + 924)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v245 = 4 - 1;
										end
										if (v245 == (1653 - (685 + 963))) then
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[5 - 2]][v78[v80[6 - 2]]];
											v72 = v72 + (1710 - (541 + 1168));
											v80 = v68[v72];
											v245 = 1603 - (645 + 952);
										end
									end
								elseif (v81 > (896 - (669 + 169))) then
									local v1533;
									local v1534;
									local v1535;
									v78[v80[6 - 4]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[767 - (181 + 584)]] = v78[v80[1398 - (665 + 730)]][v78[v80[11 - 7]]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1352 - (540 + 810)]] = {};
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[3 + 0];
									v72 = v72 + (204 - (166 + 37));
									v80 = v68[v72];
									v78[v80[1883 - (22 + 1859)]] = v78[v80[1775 - (843 + 929)]][v78[v80[4]]];
									v72 = v72 + (263 - (30 + 232));
									v80 = v68[v72];
									v1535 = v80[5 - 3];
									v1534 = v78[v1535];
									v1533 = v80[780 - (55 + 722)];
									for v3889 = 1 - 0, v1533 do
										v1534[v3889] = v78[v1535 + v3889];
									end
								else
									local v1550;
									v78[v80[2]] = v80[1678 - (78 + 1597)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1550 = v80[551 - (305 + 244)];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1 + 0, v80[108 - (95 + 10)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[6 - 4]][v80[3 - 0]] = v78[v80[766 - (592 + 170)]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[2 + 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[1 + 2];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[509 - (353 + 154)]] = v80[3 - 0];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v1550 = v80[2 + 0];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1 + 0, v80[2 + 1]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[3 - 1]][v80[3]] = v78[v80[9 - 5]];
									v72 = v72 + (87 - (7 + 79));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[2 + 1]];
									v72 = v72 + (182 - (24 + 157));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[6 - 3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[383 - (262 + 118)];
									v72 = v72 + (1084 - (1038 + 45));
									v80 = v68[v72];
									v1550 = v80[3 - 1];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (231 - (19 + 211)), v80[116 - (88 + 25)]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]][v80[3 + 0]] = v78[v80[4]];
									v72 = v72 + (1037 - (1007 + 29));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[7 - 4]];
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + (812 - (340 + 471));
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[3];
									v72 = v72 + (590 - (276 + 313));
									v80 = v68[v72];
									v1550 = v80[4 - 2];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1 + 0, v80[3]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]][v80[1 + 2]] = v78[v80[1976 - (495 + 1477)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + (404 - (342 + 61));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[168 - (4 + 161)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v1550 = v80[5 - 3];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (498 - (322 + 175)), v80[3]));
									v72 = v72 + (564 - (173 + 390));
									v80 = v68[v72];
									v78[v80[1 + 1]][v80[317 - (203 + 111)]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[709 - (57 + 649)];
									v72 = v72 + (385 - (328 + 56));
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1550 = v80[514 - (433 + 79)];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1, v80[3]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]][v80[3]] = v78[v80[4 + 0]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[9 - 7]] = v78[v80[3 + 0]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1038 - (562 + 474)]] = v80[6 - 3];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[908 - (76 + 829)];
									v72 = v72 + (1674 - (1506 + 167));
									v80 = v68[v72];
									v1550 = v80[3 - 1];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (267 - (58 + 208)), v80[2 + 1]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v80[3 + 0]] = v78[v80[3 + 1]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[339 - (258 + 79)]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[1473 - (1219 + 251)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1674 - (1231 + 440)];
									v72 = v72 + (59 - (34 + 24));
									v80 = v68[v72];
									v1550 = v80[2 + 0];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (1 - 0), v80[2 + 1]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[6 - 4]][v80[3]] = v78[v80[10 - 6]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1591 - (877 + 712)]] = v80[2 + 1];
									v72 = v72 + (755 - (242 + 512));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[630 - (92 + 535)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1550 = v80[2];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (1 - 0), v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v80[10 - 7]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[4 - 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1787 - (1476 + 309)]] = v80[1287 - (299 + 985)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1550 = v80[6 - 4];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (94 - (86 + 7)), v80[12 - 9]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[882 - (672 + 208)]][v80[3]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[134 - (14 + 118)]] = v78[v80[448 - (339 + 106)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + (1396 - (440 + 955));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v1550 = v80[1 + 1];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (2 - 1), v80[3 + 0]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v80[356 - (260 + 93)]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[4 - 1]];
									v72 = v72 + (1975 - (1181 + 793));
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + (308 - (105 + 202));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + (811 - (352 + 458));
									v80 = v68[v72];
									v1550 = v80[7 - 5];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (2 - 1), v80[3 + 0]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]][v80[952 - (438 + 511)]] = v78[v80[1387 - (1262 + 121)]];
									v72 = v72 + (1069 - (728 + 340));
									v80 = v68[v72];
									v78[v80[1792 - (816 + 974)]] = v78[v80[9 - 6]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[341 - (163 + 176)]] = v80[8 - 5];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[9 - 7]] = v80[1 + 2];
									v72 = v72 + (1811 - (1564 + 246));
									v80 = v68[v72];
									v1550 = v80[347 - (124 + 221)];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1, v80[3]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[453 - (115 + 336)]][v80[6 - 3]] = v78[v80[1 + 3]];
									v72 = v72 + (47 - (45 + 1));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[1993 - (1282 + 708)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1214 - (583 + 629)]] = v80[1 + 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1173 - (943 + 227)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1550 = v80[1633 - (1539 + 92)];
									v78[v1550] = v78[v1550](v13(v78, v1550 + (1947 - (706 + 1240)), v80[3]));
									v72 = v72 + (259 - (81 + 177));
									v80 = v68[v72];
									v78[v80[2]][v80[8 - 5]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[259 - (212 + 45)]] = v78[v80[9 - 6]];
									v72 = v72 + (1947 - (708 + 1238));
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1669 - (586 + 1081)]] = v80[514 - (348 + 163)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1550 = v80[282 - (215 + 65)];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1, v80[7 - 4]));
									v72 = v72 + (1860 - (1541 + 318));
									v80 = v68[v72];
									v78[v80[2]][v80[3 + 0]] = v78[v80[3 + 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1752 - (1036 + 714)]] = v78[v80[2 + 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1283 - (883 + 397)];
									v72 = v72 + (591 - (563 + 27));
									v80 = v68[v72];
									v1550 = v80[7 - 5];
									v78[v1550] = v78[v1550](v13(v78, v1550 + 1, v80[1989 - (1369 + 617)]));
									v72 = v72 + (1488 - (85 + 1402));
									v80 = v68[v72];
									v78[v80[1 + 1]][v80[7 - 4]] = v78[v80[407 - (274 + 129)]];
									v72 = v72 + (218 - (12 + 205));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]];
								end
							elseif (v81 <= 62) then
								if (v81 <= (232 - 172)) then
									local v246;
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + (385 - (27 + 357));
									v80 = v68[v72];
									v78[v80[2]] = v80[483 - (91 + 389)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[299 - (90 + 207)]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v246 = v80[863 - (706 + 155)];
									v78[v246] = v78[v246](v13(v78, v246 + (1796 - (730 + 1065)), v80[1566 - (1339 + 224)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[3 - 0]]] = v78[v80[847 - (268 + 575)]];
									v72 = v72 + (1295 - (919 + 375));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[974 - (180 + 791)];
									v72 = v72 + (1806 - (323 + 1482));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1921 - (1177 + 741)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[2 + 1];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[112 - (96 + 13)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v246 = v80[1923 - (962 + 959)];
									v78[v246] = v78[v246](v13(v78, v246 + (2 - 1), v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[1355 - (461 + 890)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[3];
									v72 = v72 + (244 - (19 + 224));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + (199 - (37 + 161));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[63 - (60 + 1)]] = v80[926 - (826 + 97)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v246 = v80[6 - 4];
									v78[v246] = v78[v246](v13(v78, v246 + (1 - 0), v80[688 - (375 + 310)]));
									v72 = v72 + (2000 - (1864 + 135));
									v80 = v68[v72];
									v78[v80[4 - 2]][v78[v80[1 + 2]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[1134 - (314 + 817)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[216 - (32 + 182)]] = v78[v80[3 + 0]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[67 - (39 + 26)]] = v80[147 - (54 + 90)];
									v72 = v72 + (199 - (45 + 153));
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v246 = v80[2];
									v78[v246] = v78[v246](v13(v78, v246 + 1 + 0, v80[555 - (457 + 95)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[6 - 3]]] = v78[v80[4]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[10 - 7];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[751 - (485 + 263)]];
									v72 = v72 + (708 - (575 + 132));
									v80 = v68[v72];
									v78[v80[863 - (750 + 111)]] = v80[3];
									v72 = v72 + (1011 - (445 + 565));
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v246 = v80[2 - 0];
									v78[v246] = v78[v246](v13(v78, v246 + 1, v80[2 + 1]));
									v72 = v72 + (311 - (189 + 121));
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[1350 - (634 + 713)]]] = v78[v80[542 - (493 + 45)]];
									v72 = v72 + (969 - (493 + 475));
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[786 - (158 + 626)]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + (1092 - (1035 + 56));
									v80 = v68[v72];
									v246 = v80[2];
									v78[v246] = v78[v246](v13(v78, v246 + (960 - (114 + 845)), v80[2 + 1]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[1052 - (179 + 870)]]] = v78[v80[4 - 0]];
									v72 = v72 + (879 - (827 + 51));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[476 - (95 + 378)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3 + 0];
									v72 = v72 + (1012 - (334 + 677));
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[1059 - (1049 + 7)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v246 = v80[8 - 6];
									v78[v246] = v78[v246](v13(v78, v246 + (1 - 0), v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[5 - 2]]] = v78[v80[2 + 2]];
									v72 = v72 + (1421 - (1004 + 416));
									v80 = v68[v72];
									v78[v80[1959 - (1621 + 336)]] = v80[1942 - (337 + 1602)];
									v72 = v72 + (1518 - (1014 + 503));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1018 - (446 + 569)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[8 - 5];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[1 + 2];
									v72 = v72 + (506 - (223 + 282));
									v80 = v68[v72];
									v246 = v80[2];
									v78[v246] = v78[v246](v13(v78, v246 + 1 + 0, v80[4 - 1]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[672 - (623 + 47)]][v78[v80[48 - (32 + 13)]]] = v78[v80[3 + 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + (1802 - (1070 + 731));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[1407 - (1257 + 147)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[136 - (98 + 35)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[9 - 6];
									v72 = v72 + 1;
									v80 = v68[v72];
									v246 = v80[2 + 0];
									v78[v246] = v78[v246](v13(v78, v246 + 1 + 0, v80[2 + 1]));
									v72 = v72 + (558 - (395 + 162));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + (1942 - (816 + 1125));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[1151 - (701 + 447)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[3]];
									v72 = v72 + (1342 - (391 + 950));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[7 - 4];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v246 = v80[2 + 0];
									v78[v246] = v78[v246](v13(v78, v246 + (3 - 2), v80[1525 - (251 + 1271)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[7 - 4]]] = v78[v80[4]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1261 - (1147 + 112)]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[1 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[699 - (335 + 362)]] = v80[3 + 0];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[11 - 8];
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v246 = v80[5 - 3];
									v78[v246] = v78[v246](v13(v78, v246 + (567 - (237 + 329)), v80[10 - 7]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[4]];
									v72 = v72 + (1125 - (408 + 716));
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[824 - (344 + 477)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1 + 2]];
									v72 = v72 + (1762 - (1188 + 573));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[3 - 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v246 = v80[1531 - (508 + 1021)];
									v78[v246] = v78[v246](v13(v78, v246 + 1, v80[3 + 0]));
									v72 = v72 + (1167 - (228 + 938));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[688 - (332 + 353)]]] = v78[v80[4]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[7 - 4];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[3];
									v72 = v72 + (424 - (18 + 405));
									v80 = v68[v72];
									v246 = v80[2];
									v78[v246] = v78[v246](v13(v78, v246 + 1 + 0, v80[2 + 1]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[981 - (194 + 784)]]] = v78[v80[1774 - (694 + 1076)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1906 - (122 + 1782)]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[8 - 5];
								elseif ((17 == 17) and (v81 == (57 + 4))) then
									v78[v80[1972 - (214 + 1756)]][v78[v80[14 - 11]]] = v78[v80[1 + 3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[587 - (217 + 368)]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[8 - 5]][v78[v80[4]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (890 - (844 + 45));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[287 - (242 + 42)]]] = v78[v80[4]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[4 - 2]][v78[v80[1203 - (132 + 1068)]]] = v78[v80[4]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1625 - (214 + 1409)]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1636 - (497 + 1137)]] = v78[v80[3]][v78[v80[944 - (9 + 931)]]];
									v72 = v72 + (290 - (181 + 108));
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[8 - 5];
								else
									local v1655 = 0 + 0;
									while true do
										if ((v1655 == (1 + 0)) or (3081 >= 4287)) then
											v72 = v72 + (477 - (296 + 180));
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[1406 - (1183 + 220)]][v78[v80[1269 - (1037 + 228)]]];
											v72 = v72 + (1 - 0);
											v1655 = 5 - 3;
										end
										if (v1655 == (6 - 4)) then
											v80 = v68[v72];
											v78[v80[736 - (527 + 207)]] = v80[530 - (187 + 340)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1655 = 1873 - (1298 + 572);
										end
										if (v1655 == (0 - 0)) then
											v78[v80[172 - (144 + 26)]][v78[v80[7 - 4]]] = v78[v80[8 - 4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v80[8 - 5];
											v1655 = 2 - 1;
										end
										if (v1655 == 3) then
											v78[v80[9 - 7]][v78[v80[2 + 1]]] = v78[v80[4]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2 + 0]][v78[v80[2 + 1]]] = v78[v80[206 - (5 + 197)]];
											v1655 = 690 - (339 + 347);
										end
										if (v1655 == (8 - 4)) then
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[378 - (365 + 11)]] = v78[v80[3]];
											v72 = v72 + 1 + 0;
											v1655 = 5;
										end
										if ((v1655 == (23 - 17)) or (897 > 3112)) then
											v72 = v80[6 - 3];
											break;
										end
										if ((v1655 == 5) or (2756 == 4341)) then
											v80 = v68[v72];
											do
												return v78[v80[2]];
											end
											v72 = v72 + (925 - (837 + 87));
											v80 = v68[v72];
											v1655 = 10 - 4;
										end
									end
								end
							elseif (v81 <= (1734 - (837 + 833))) then
								if ((3167 == 3167) and (v81 == (14 + 49))) then
									local v1656 = 1387 - (356 + 1031);
									local v1657;
									local v1658;
									local v1659;
									while true do
										if ((2333 > 446) and (v1656 == 4)) then
											v78[v80[2]] = {};
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1656 = 1651 - (73 + 1573);
										end
										if (v1656 == (1388 - (1307 + 81))) then
											v1657 = nil;
											v1658 = nil;
											v1659 = nil;
											v1656 = 235 - (7 + 227);
										end
										if (v1656 == 2) then
											v78[v80[2]] = v80[4 - 1];
											v72 = v72 + (167 - (90 + 76));
											v80 = v68[v72];
											v1656 = 3;
										end
										if ((v1656 == 1) or (3273 < 837)) then
											v78[v80[6 - 4]] = {};
											v72 = v72 + 1;
											v80 = v68[v72];
											v1656 = 1 + 1;
										end
										if (v1656 == (7 + 1)) then
											for v6834 = 1 + 0, v1657 do
												v1658[v6834] = v78[v1659 + v6834];
											end
											break;
										end
										if (v1656 == (27 - 20)) then
											v1659 = v80[2];
											v1658 = v78[v1659];
											v1657 = v80[263 - (197 + 63)];
											v1656 = 2 + 6;
										end
										if (v1656 == (2 + 4)) then
											v78[v80[2]] = v78[v80[2 + 1]][v78[v80[1 + 3]]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1656 = 7;
										end
										if ((2301 <= 4642) and (v1656 == (1372 - (618 + 751)))) then
											v78[v80[2 + 0]] = v78[v80[1913 - (206 + 1704)]][v78[v80[6 - 2]]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1656 = 2 + 2;
										end
										if (v1656 == 5) then
											v78[v80[1277 - (155 + 1120)]] = v80[1509 - (396 + 1110)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1656 = 12 - 6;
										end
									end
								else
									v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4 + 0]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[978 - (230 + 746)]] = v80[604 - (473 + 128)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[50 - (39 + 9)]] = v78[v80[269 - (38 + 228)]][v78[v80[6 - 2]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[475 - (106 + 367)]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1864 - (354 + 1508)]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3 - 0];
									v72 = v72 + (1245 - (334 + 910));
									v80 = v68[v72];
									v78[v80[897 - (92 + 803)]] = v78[v80[3]][v78[v80[3 + 1]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1183 - (1035 + 146)]] = {};
									v72 = v72 + (617 - (230 + 386));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1513 - (353 + 1157)];
								end
							elseif (v81 > (1179 - (53 + 1061))) then
								v78[v80[1637 - (1568 + 67)]][v78[v80[2 + 1]]] = v78[v80[1 + 3]];
							else
								local v1680;
								local v1681;
								local v1682;
								v78[v80[4 - 2]] = v80[8 - 5];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[3 + 0]][v78[v80[1216 - (615 + 597)]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1902 - (1056 + 843)]][v78[v80[8 - 4]]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v1682 = v80[5 - 3];
								v1681 = v78[v1682];
								v1680 = v80[2 + 1];
								for v3892 = 1, v1680 do
									v1681[v3892] = v78[v1682 + v3892];
								end
							end
						elseif ((v81 <= (2049 - (286 + 1690))) or (4191 <= 2183)) then
							if (v81 <= (980 - (98 + 813))) then
								if ((2056 <= 2503) and (v81 <= 67)) then
									v78[v80[1 + 1]][v78[v80[7 - 4]]] = v78[v80[3 + 1]];
									v72 = v72 + (508 - (263 + 244));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1690 - (1502 + 185)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[9 - 7]] = v78[v80[7 - 4]][v78[v80[1531 - (629 + 898)]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[368 - (12 + 353)];
									v72 = v72 + (1912 - (1680 + 231));
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[3 + 1]];
									v72 = v72 + (1150 - (212 + 937));
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[1065 - (111 + 951)]]] = v78[v80[1 + 3]];
									v72 = v72 + (28 - (18 + 9));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[537 - (31 + 503)];
									v72 = v72 + (1633 - (595 + 1037));
									v80 = v68[v72];
									v78[v80[1446 - (189 + 1255)]] = v78[v80[2 + 1]][v78[v80[5 - 1]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1281 - (1170 + 109)]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1820 - (348 + 1469)];
								elseif (v81 > (1357 - (1115 + 174))) then
									local v1695;
									local v1696;
									local v1697;
									v78[v80[4 - 2]] = {};
									v72 = v72 + (1015 - (85 + 929));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1870 - (1151 + 716)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]][v78[v80[4]]];
									v72 = v72 + (1705 - (95 + 1609));
									v80 = v68[v72];
									v78[v80[6 - 4]] = {};
									v72 = v72 + (759 - (364 + 394));
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3 + 0]][v78[v80[4]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v1697 = v80[2 + 0];
									v1696 = v78[v1697];
									v1695 = v80[2 + 1];
									for v3895 = 1 + 0, v1695 do
										v1696[v3895] = v78[v1697 + v3895];
									end
								else
									do
										return v78[v80[1 + 1]];
									end
								end
							elseif (v81 <= (1027 - (719 + 237))) then
								if (v81 == (195 - 125)) then
									local v1711 = 0 + 0;
									local v1712;
									local v1713;
									local v1714;
									while true do
										if (v1711 == (7 - 4)) then
											v78[v80[5 - 3]] = v78[v80[3]][v78[v80[9 - 5]]];
											v72 = v72 + (1992 - (761 + 1230));
											v80 = v68[v72];
											v1711 = 197 - (80 + 113);
										end
										if (v1711 == (3 + 1)) then
											v78[v80[2 + 0]] = {};
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1711 = 20 - 15;
										end
										if (v1711 == (2 + 4)) then
											v78[v80[2]] = v78[v80[1 + 2]][v78[v80[4]]];
											v72 = v72 + (1244 - (965 + 278));
											v80 = v68[v72];
											v1711 = 1736 - (1391 + 338);
										end
										if ((v1711 == (2 - 1)) or (2194 > 3745)) then
											v78[v80[2 + 0]] = {};
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1711 = 1 + 1;
										end
										if (v1711 == (1416 - (496 + 912))) then
											for v6837 = 1, v1712 do
												v1713[v6837] = v78[v1714 + v6837];
											end
											break;
										end
										if (v1711 == (16 - 11)) then
											v78[v80[2]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1711 = 6;
										end
										if (v1711 == (3 - 1)) then
											v78[v80[1332 - (1190 + 140)]] = v80[2 + 1];
											v72 = v72 + (719 - (317 + 401));
											v80 = v68[v72];
											v1711 = 952 - (303 + 646);
										end
										if (v1711 == 7) then
											v1714 = v80[6 - 4];
											v1713 = v78[v1714];
											v1712 = v80[3];
											v1711 = 1740 - (1675 + 57);
										end
										if ((4482 == 4482) and (v1711 == 0)) then
											v1712 = nil;
											v1713 = nil;
											v1714 = nil;
											v1711 = 1 + 0;
										end
									end
								else
									v78[v80[4 - 2]][v78[v80[1 + 2]]] = v78[v80[981 - (338 + 639)]];
									v72 = v72 + (380 - (320 + 59));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[735 - (628 + 104)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1893 - (439 + 1452)]] = v78[v80[1950 - (105 + 1842)]][v78[v80[18 - 14]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v80[14 - 11];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[3]]] = v78[v80[3 + 1]];
									v72 = v72 + (1165 - (274 + 890));
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 - 0]][v78[v80[823 - (731 + 88)]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 - 0];
								end
							elseif ((v81 > 72) or (2502 >= 4437)) then
								local v1732 = 0 - 0;
								local v1733;
								local v1734;
								local v1735;
								while true do
									if (v1732 == (5 - 3)) then
										v80 = v68[v72];
										v78[v80[3 - 1]] = v78[v80[3 + 0]][v78[v80[1 + 3]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1732 = 3 + 0;
									end
									if ((161 - (139 + 19)) == v1732) then
										v78[v80[1 + 1]] = {};
										v72 = v72 + (1994 - (1687 + 306));
										v80 = v68[v72];
										v78[v80[2]] = v80[10 - 7];
										v1732 = 1158 - (1018 + 136);
									end
									if (v1732 == 1) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[8 - 6]] = v80[3];
										v72 = v72 + (816 - (117 + 698));
										v1732 = 483 - (305 + 176);
									end
									if ((4470 > 1426) and (v1732 == (1 + 3))) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3 + 0]][v78[v80[4]]];
										v72 = v72 + (1 - 0);
										v1732 = 5 + 0;
									end
									if (v1732 == (8 - 3)) then
										v80 = v68[v72];
										v1735 = v80[4 - 2];
										v1734 = v78[v1735];
										v1733 = v80[3];
										v1732 = 10 - 4;
									end
									if ((v1732 == (266 - (159 + 101))) or (4263 > 4449)) then
										for v6840 = 1, v1733 do
											v1734[v6840] = v78[v1735 + v6840];
										end
										break;
									end
									if (v1732 == (0 - 0)) then
										v1733 = nil;
										v1734 = nil;
										v1735 = nil;
										v78[v80[6 - 4]] = {};
										v1732 = 1 + 0;
									end
								end
							else
								local v1736;
								v78[v80[6 - 4]] = v78[v80[3]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[269 - (112 + 154)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + (32 - (21 + 10));
								v80 = v68[v72];
								v1736 = v80[1721 - (531 + 1188)];
								v78[v1736] = v78[v1736](v13(v78, v1736 + 1 + 0, v80[666 - (96 + 567)]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]][v80[10 - 7]] = v78[v80[1699 - (867 + 828)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[6 - 3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[4 - 1]];
								v72 = v72 + (772 - (134 + 637));
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + (1158 - (775 + 382));
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[610 - (45 + 562)];
								v72 = v72 + (863 - (545 + 317));
								v80 = v68[v72];
								v1736 = v80[2 - 0];
								v78[v1736] = v78[v1736](v13(v78, v1736 + 1, v80[1029 - (763 + 263)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[1753 - (512 + 1238)]]] = v78[v80[4]];
								v72 = v72 + (1595 - (272 + 1322));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[1249 - (533 + 713)];
								v72 = v72 + (29 - (14 + 14));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[828 - (499 + 326)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[426 - (104 + 320)]] = v80[2000 - (1929 + 68)];
								v72 = v72 + (1324 - (1206 + 117));
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v1736 = v80[1594 - (683 + 909)];
								v78[v1736] = v78[v1736](v13(v78, v1736 + 1, v80[9 - 6]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[779 - (772 + 5)]][v78[v80[3]]] = v78[v80[4]];
								v72 = v72 + (1428 - (19 + 1408));
								v80 = v68[v72];
								v78[v80[290 - (134 + 154)]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[6 - 4]] = v78[v80[3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + (203 - (10 + 192));
								v80 = v68[v72];
								v78[v80[49 - (13 + 34)]] = v80[1292 - (342 + 947)];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v1736 = v80[1710 - (119 + 1589)];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (2 - 1), v80[3 - 0]));
								v72 = v72 + (553 - (545 + 7));
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[2 + 1]]] = v78[v80[1707 - (494 + 1209)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[1001 - (197 + 801)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[14 - 11]];
								v72 = v72 + (955 - (919 + 35));
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[11 - 8];
								v72 = v72 + (468 - (369 + 98));
								v80 = v68[v72];
								v1736 = v80[1117 - (400 + 715)];
								v78[v1736] = v78[v1736](v13(v78, v1736 + 1, v80[2 + 1]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1327 - (744 + 581)]][v78[v80[2 + 1]]] = v78[v80[1626 - (653 + 969)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1633 - (12 + 1619)]] = v78[v80[166 - (103 + 60)]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2]] = v80[12 - 9];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v1736 = v80[2];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (1663 - (710 + 952)), v80[1871 - (555 + 1313)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[1472 - (1261 + 207)]];
								v72 = v72 + (253 - (245 + 7));
								v80 = v68[v72];
								v78[v80[2]] = v80[750 - (212 + 535)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[9 - 7]] = v78[v80[3]];
								v72 = v72 + (1477 - (905 + 571));
								v80 = v68[v72];
								v78[v80[9 - 7]] = v80[3 - 0];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1466 - (522 + 941)];
								v72 = v72 + (1512 - (292 + 1219));
								v80 = v68[v72];
								v1736 = v80[1114 - (787 + 325)];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (2 - 1), v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[8 - 4]];
								v72 = v72 + (535 - (424 + 110));
								v80 = v68[v72];
								v78[v80[2]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[315 - (33 + 279)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1355 - (1338 + 15)]] = v80[1426 - (528 + 895)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[1927 - (1606 + 318)];
								v72 = v72 + (1820 - (298 + 1521));
								v80 = v68[v72];
								v1736 = v80[8 - 6];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (311 - (154 + 156)), v80[11 - 8]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1117 - (712 + 403)]][v78[v80[453 - (168 + 282)]]] = v78[v80[8 - 4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1453 - (1242 + 209)]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[682 - (20 + 659)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v1736 = v80[2];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (1 - 0), v80[622 - (427 + 192)]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[1950 - (1427 + 520)]]] = v78[v80[3 + 1]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + (1233 - (712 + 520));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[1349 - (565 + 781)]];
								v72 = v72 + (566 - (35 + 530));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[10 - 7];
								v72 = v72 + (1379 - (1330 + 48));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v1736 = v80[8 - 6];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (1170 - (854 + 315)), v80[9 - 6]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[47 - (31 + 13)]]] = v78[v80[5 - 1]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + (564 - (281 + 282));
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[2 + 1]];
								v72 = v72 + (950 - (216 + 733));
								v80 = v68[v72];
								v78[v80[2]] = v80[1850 - (137 + 1710)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[540 - (100 + 438)]] = v80[1368 - (205 + 1160)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v1736 = v80[2 + 0];
								v78[v1736] = v78[v1736](v13(v78, v1736 + (1306 - (535 + 770)), v80[3]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[1998 - (211 + 1783)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1432 - (1236 + 193)];
								v72 = v72 + (911 - (793 + 117));
								v80 = v68[v72];
								v78[v80[1894 - (1607 + 285)]] = v78[v80[3]];
								v72 = v72 + (861 - (747 + 113));
								v80 = v68[v72];
								v78[v80[1978 - (80 + 1896)]] = v80[14 - 11];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[6 - 3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v1736 = v80[5 - 3];
								v78[v1736] = v78[v1736](v13(v78, v1736 + 1, v80[3]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[6 - 3]]] = v78[v80[458 - (246 + 208)]];
								v72 = v72 + (1893 - (614 + 1278));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[317 - (249 + 65)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[1278 - (726 + 549)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1426 - (916 + 508)]] = v80[9 - 6];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[325 - (140 + 183)]] = v80[3 + 0];
								v72 = v72 + (565 - (297 + 267));
								v80 = v68[v72];
								v1736 = v80[2 + 0];
								v78[v1736] = v78[v1736](v13(v78, v1736 + 1, v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[344 - (37 + 305)]][v78[v80[1269 - (323 + 943)]]] = v78[v80[2 + 2]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1537 - (394 + 1141)]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1 + 2]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3 + 0];
							end
						elseif ((v81 <= 76) or (531 >= 4703)) then
							if ((1728 < 1775) and (v81 <= 74)) then
								local v346 = 0 + 0;
								local v347;
								local v348;
								local v349;
								while true do
									if (((529 - (87 + 442)) == v346) or (1244 == 3167)) then
										v347 = nil;
										v348 = nil;
										v349 = nil;
										v78[v80[807 - (13 + 792)]] = v80[3 + 0];
										v346 = 1 + 0;
									end
									if ((504 <= 1762) and (v346 == 2)) then
										v80 = v68[v72];
										v78[v80[2 + 0]] = {};
										v72 = v72 + (1866 - (1231 + 634));
										v80 = v68[v72];
										v346 = 1769 - (1362 + 404);
									end
									if (v346 == 1) then
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[8 - 5]][v78[v80[1020 - (660 + 356)]]];
										v72 = v72 + 1;
										v346 = 2;
									end
									if (v346 == (4 - 1)) then
										v78[v80[2 + 0]] = v80[1953 - (1111 + 839)];
										v72 = v72 + (952 - (496 + 455));
										v80 = v68[v72];
										v78[v80[700 - (66 + 632)]] = v78[v80[4 - 1]][v78[v80[1140 - (441 + 695)]]];
										v346 = 10 - 6;
									end
									if (v346 == (9 - 4)) then
										v347 = v80[14 - 11];
										for v4749 = 1 + 0, v347 do
											v348[v4749] = v78[v349 + v4749];
										end
										break;
									end
									if (v346 == (1842 - (286 + 1552))) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v349 = v80[2];
										v348 = v78[v349];
										v346 = 1282 - (1016 + 261);
									end
								end
							elseif (v81 == (1395 - (708 + 612))) then
								local v1831 = 0 - 0;
								local v1832;
								local v1833;
								local v1834;
								while true do
									if (v1831 == (3 + 3)) then
										for v6843 = 380 - (113 + 266), v1832 do
											v1833[v6843] = v78[v1834 + v6843];
										end
										break;
									end
									if (v1831 == (1175 - (979 + 191))) then
										v80 = v68[v72];
										v1834 = v80[2 - 0];
										v1833 = v78[v1834];
										v1832 = v80[1738 - (339 + 1396)];
										v1831 = 2 + 4;
									end
									if (v1831 == (0 + 0)) then
										v1832 = nil;
										v1833 = nil;
										v1834 = nil;
										v78[v80[2]] = {};
										v1831 = 1 - 0;
									end
									if (2 == v1831) then
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[3]][v78[v80[4]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1831 = 350 - (187 + 160);
									end
									if ((v1831 == (2 - 1)) or (3775 <= 2976)) then
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v78[v80[2]] = v80[1 + 2];
										v72 = v72 + (3 - 2);
										v1831 = 1 + 1;
									end
									if ((v1831 == (1 + 3)) or (2783 < 621)) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[5 - 2]][v78[v80[332 - (56 + 272)]]];
										v72 = v72 + 1 + 0;
										v1831 = 5 + 0;
									end
									if (v1831 == (6 - 3)) then
										v78[v80[2 + 0]] = {};
										v72 = v72 + (641 - (455 + 185));
										v80 = v68[v72];
										v78[v80[2]] = v80[791 - (757 + 31)];
										v1831 = 2003 - (762 + 1237);
									end
								end
							else
								local v1835;
								local v1836;
								local v1837;
								v78[v80[3 - 1]] = v80[272 - (265 + 4)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]][v78[v80[6 - 2]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[5 - 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[3]][v78[v80[1738 - (1691 + 43)]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v1837 = v80[6 - 4];
								v1836 = v78[v1837];
								v1835 = v80[1 + 2];
								for v3914 = 1, v1835 do
									v1836[v3914] = v78[v1837 + v3914];
								end
							end
						elseif (v81 <= (284 - 206)) then
							if (v81 == (253 - (127 + 49))) then
								local v1850 = 1680 - (281 + 1399);
								while true do
									if ((1723 < 4326) and (v1850 == (1660 - (184 + 1475)))) then
										v78[v80[2]] = v80[3 - 0];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v1850 = 4 - 2;
									end
									if (v1850 == 4) then
										v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4 + 0]];
										v72 = v72 + (1292 - (260 + 1031));
										v80 = v68[v72];
										v1850 = 1182 - (313 + 864);
									end
									if (v1850 == 8) then
										v78[v80[694 - (655 + 37)]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1850 = 14 - 5;
									end
									if (((11 - 6) == v1850) or (121 > 4474)) then
										v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[7 - 3]];
										v72 = v72 + (771 - (383 + 387));
										v80 = v68[v72];
										v1850 = 2 + 4;
									end
									if (v1850 == (1 + 8)) then
										v78[v80[2]] = v80[3];
										break;
									end
									if (v1850 == 7) then
										v78[v80[6 - 4]] = v78[v80[3]][v78[v80[2 + 2]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1850 = 8;
									end
									if (v1850 == (512 - (304 + 206))) then
										v78[v80[227 - (182 + 43)]] = v78[v80[778 - (264 + 511)]][v78[v80[1 + 3]]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v1850 = 984 - (128 + 853);
									end
									if (v1850 == (1702 - (1635 + 67))) then
										v78[v80[1 + 1]][v78[v80[2 + 1]]] = v78[v80[201 - (131 + 66)]];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v1850 = 4 - 3;
									end
									if (v1850 == (2 + 1)) then
										v78[v80[2 + 0]] = v80[4 - 1];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v1850 = 1609 - (306 + 1299);
									end
									if (((3 + 3) == v1850) or (1417 == 784)) then
										v78[v80[4 - 2]] = v80[792 - (671 + 118)];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v1850 = 7;
									end
								end
							else
								local v1851;
								local v1852;
								local v1853;
								v78[v80[78 - (73 + 3)]] = {};
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[9 - 7]] = v80[6 - 3];
								v72 = v72 + (1756 - (1668 + 87));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1902 - (296 + 1603)]][v78[v80[110 - (79 + 27)]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1009 - (700 + 307)]] = v80[3 + 0];
								v72 = v72 + (1800 - (1477 + 322));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[6 - 3]][v78[v80[4]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v1853 = v80[2];
								v1852 = v78[v1853];
								v1851 = v80[9 - 6];
								for v3917 = 1, v1851 do
									v1852[v3917] = v78[v1853 + v3917];
								end
							end
						elseif ((70 <= 1818) and (v81 > (60 + 19))) then
							local v1867 = v80[8 - 6];
							v78[v1867] = v78[v1867](v13(v78, v1867 + 1, v73));
						else
							v78[v80[5 - 3]][v78[v80[3]]] = v78[v80[2 + 2]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v78[v80[5 - 2]][v78[v80[1790 - (20 + 1766)]]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (810 - (88 + 721));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[1 + 3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[9 - 5]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[439 - (93 + 344)]] = v80[1216 - (960 + 253)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[8 - 5]][v78[v80[11 - 7]]];
							v72 = v72 + (1417 - (74 + 1342));
							v80 = v68[v72];
							v78[v80[1 + 1]] = {};
							v72 = v72 + (475 - (33 + 441));
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[1422 - (64 + 1355)];
						end
					elseif (v81 <= (135 - 42)) then
						if ((v81 <= (97 - (5 + 6))) or (1470 <= 480)) then
							if (v81 <= 83) then
								if ((2047 < 4750) and (v81 <= 81)) then
									local v350;
									v350 = v80[1 + 1];
									v78[v350] = v78[v350](v13(v78, v350 + 1 + 0, v80[449 - (369 + 77)]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[741 - (438 + 300)]]] = v78[v80[298 - (50 + 244)]];
									v72 = v72 + (1202 - (95 + 1106));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[14 - 11];
									v72 = v72 + (1897 - (1741 + 155));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[8 - 5]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v350 = v80[2];
									v78[v350] = v78[v350](v13(v78, v350 + 1, v80[7 - 4]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1779 - (1263 + 514)]][v78[v80[500 - (73 + 424)]]] = v78[v80[10 - 6]];
									v72 = v72 + (309 - (93 + 215));
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[1938 - (1756 + 179)];
									v72 = v72 + (1680 - (550 + 1129));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[110 - (57 + 50)]];
									v72 = v72 + (630 - (30 + 599));
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 - 0];
									v72 = v72 + (919 - (794 + 124));
									v80 = v68[v72];
									v350 = v80[2];
									v78[v350] = v78[v350](v13(v78, v350 + 1 + 0, v80[1 + 2]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1929 - (1299 + 628)]][v78[v80[5 - 2]]] = v78[v80[10 - 6]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1447 - (335 + 1110)]] = v78[v80[3 + 0]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[335 - (268 + 64)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1280 - (243 + 1035)]] = v80[7 - 4];
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v350 = v80[8 - 6];
									v78[v350] = v78[v350](v13(v78, v350 + 1, v80[2 + 1]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[103 - (90 + 10)]]] = v78[v80[808 - (209 + 595)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[807 - (603 + 202)]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[8 - 5];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v350 = v80[5 - 3];
									v78[v350] = v78[v350](v13(v78, v350 + (4 - 3), v80[282 - (174 + 105)]));
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[915 - (532 + 381)]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + (840 - (137 + 702));
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[1 + 2]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1888 - (1819 + 67)]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1359 - (259 + 1098)]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v350 = v80[1 + 1];
									v78[v350] = v78[v350](v13(v78, v350 + (3 - 2), v80[2 + 1]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[14 - 11]]] = v78[v80[1710 - (667 + 1039)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1022 - (274 + 745)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[433 - (288 + 142)]];
									v72 = v72 + (1307 - (301 + 1005));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[6 - 3];
									v72 = v72 + (1874 - (674 + 1199));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v350 = v80[8 - 6];
									v78[v350] = v78[v350](v13(v78, v350 + 1, v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[447 - (92 + 353)]][v78[v80[3]]] = v78[v80[4 + 0]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[4 - 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[12 - 9];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v350 = v80[267 - (34 + 231)];
									v78[v350] = v78[v350](v13(v78, v350 + (1318 - (930 + 387)), v80[3 + 0]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[700 - (389 + 308)]]] = v78[v80[9 - 5]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[325 - (125 + 197)]];
									v72 = v72 + (998 - (339 + 658));
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[5 - 2];
									v72 = v72 + (1349 - (743 + 605));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v350 = v80[5 - 3];
									v78[v350] = v78[v350](v13(v78, v350 + 1 + 0, v80[252 - (197 + 52)]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[4 - 2]][v78[v80[2 + 1]]] = v78[v80[3 + 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[10 - 7];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3 - 0]];
									v72 = v72 + (1098 - (97 + 1000));
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[1848 - (143 + 1702)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[371 - (40 + 329)]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v350 = v80[2 - 0];
									v78[v350] = v78[v350](v13(v78, v350 + 1 + 0, v80[68 - (9 + 56)]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[586 - (531 + 53)]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + (774 - (89 + 684));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[4 - 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (614 - (238 + 375));
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v350 = v80[2 + 0];
									v78[v350] = v78[v350](v13(v78, v350 + (2 - 1), v80[7 - 4]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[11 - 8]]] = v78[v80[4 - 0]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + (463 - (428 + 34));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[4 - 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[6 - 3];
									v72 = v72 + (919 - (223 + 695));
									v80 = v68[v72];
									v350 = v80[6 - 4];
									v78[v350] = v78[v350](v13(v78, v350 + (512 - (329 + 182)), v80[1 + 2]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[1 + 3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3 - 0];
									v72 = v72 + (1201 - (177 + 1023));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[1 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1467 - (120 + 1345)]] = v80[340 - (8 + 329)];
									v72 = v72 + (126 - (19 + 106));
									v80 = v68[v72];
									v350 = v80[7 - 5];
									v78[v350] = v78[v350](v13(v78, v350 + (1 - 0), v80[3]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[11 - 7]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[3];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1 + 2]];
									v72 = v72 + (1504 - (957 + 546));
									v80 = v68[v72];
									v78[v80[8 - 6]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[2 + 1];
									v72 = v72 + (704 - (227 + 476));
									v80 = v68[v72];
									v350 = v80[3 - 1];
									v78[v350] = v78[v350](v13(v78, v350 + (1 - 0), v80[4 - 1]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[957 - (166 + 788)]]] = v78[v80[990 - (21 + 965)]];
								elseif (v81 > (778 - (127 + 569))) then
									local v1886 = 0 + 0;
									local v1887;
									while true do
										if ((846 >= 285) and (v1886 == 25)) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[2 + 1];
											break;
										end
										if (v1886 == (33 - 10)) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[2 + 1];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (1293 - (1162 + 130));
											v80 = v68[v72];
											v1887 = v80[3 - 1];
											v78[v1887] = v78[v1887](v13(v78, v1887 + 1 + 0, v80[3]));
											v1886 = 53 - 29;
										end
										if ((3663 == 3663) and ((937 - (889 + 47)) == v1886)) then
											v1887 = v80[2 + 0];
											v78[v1887] = v78[v1887](v13(v78, v1887 + 1, v80[1267 - (1153 + 111)]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 - 0]][v78[v80[2 + 1]]] = v78[v80[3 + 1]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[1 + 2];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1886 = 2 + 0;
										end
										if ((2359 >= 1909) and (v1886 == (115 - (23 + 73)))) then
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[288 - (26 + 259)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[6 - 4]] = v80[1632 - (1094 + 535)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1886 = 20;
										end
										if (((1897 - (1554 + 322)) == v1886) or (2542 < 1166)) then
											v78[v80[1427 - (989 + 436)]] = v78[v80[1181 - (816 + 362)]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[3 - 1]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[11 - 8];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v1887 = v80[4 - 2];
											v1886 = 96 - 74;
										end
										if ((v1886 == (1 + 3)) or (2314 == 365)) then
											v72 = v72 + (764 - (86 + 677));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[1 + 2];
											v72 = v72 + (1027 - (263 + 763));
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[861 - (649 + 209)];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v1887 = v80[733 - (643 + 88)];
											v78[v1887] = v78[v1887](v13(v78, v1887 + (1770 - (54 + 1715)), v80[11 - 8]));
											v1886 = 14 - 9;
										end
										if (v1886 == (30 - 15)) then
											v78[v80[2 + 0]] = v80[1 + 2];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[1386 - (132 + 1251)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[461 - (185 + 273)];
											v1886 = 4 + 12;
										end
										if (v1886 == (63 - 41)) then
											v78[v1887] = v78[v1887](v13(v78, v1887 + 1 + 0, v80[1227 - (361 + 863)]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[1329 - (443 + 884)]][v78[v80[3]]] = v78[v80[4]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[4 - 1];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[6 - 3]];
											v1886 = 770 - (16 + 731);
										end
										if (v1886 == (9 + 8)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[3]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[762 - (527 + 233)]] = v80[3 + 0];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[1788 - (1107 + 678)];
											v72 = v72 + 1 + 0;
											v1886 = 16 + 2;
										end
										if (v1886 == 16) then
											v72 = v72 + (51 - (4 + 46));
											v80 = v68[v72];
											v1887 = v80[2];
											v78[v1887] = v78[v1887](v13(v78, v1887 + (3 - 2), v80[5 - 2]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[3 - 1]][v78[v80[4 - 1]]] = v78[v80[1400 - (1262 + 134)]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[3];
											v1886 = 5 + 12;
										end
										if (v1886 == (4 + 1)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]][v78[v80[798 - (383 + 412)]]] = v78[v80[4 + 0]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[3 + 0]];
											v72 = v72 + (1 - 0);
											v1886 = 6;
										end
										if (v1886 == (18 + 2)) then
											v1887 = v80[5 - 3];
											v78[v1887] = v78[v1887](v13(v78, v1887 + 1, v80[3 - 0]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[4]];
											v72 = v72 + (708 - (667 + 40));
											v80 = v68[v72];
											v78[v80[2]] = v80[1313 - (436 + 874)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1886 = 1627 - (762 + 844);
										end
										if (v1886 == (4 - 1)) then
											v78[v1887] = v78[v1887](v13(v78, v1887 + (2 - 1), v80[1 + 2]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[478 - (209 + 267)]][v78[v80[3]]] = v78[v80[6 - 2]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[1713 - (1611 + 100)]] = v78[v80[3 + 0]];
											v1886 = 788 - (14 + 770);
										end
										if (v1886 == (1795 - (1165 + 619))) then
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2]] = v80[384 - (229 + 152)];
											v72 = v72 + (195 - (107 + 87));
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[5 - 2]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[14 - 11];
											v72 = v72 + (3 - 2);
											v1886 = 11 + 1;
										end
										if (v1886 == (20 - (13 + 1))) then
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1060 - (987 + 71)]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1887 = v80[5 - 3];
											v78[v1887] = v78[v1887](v13(v78, v1887 + (1 - 0), v80[702 - (514 + 185)]));
											v72 = v72 + 1 + 0;
											v1886 = 13 - 6;
										end
										if (v1886 == (92 - 68)) then
											v72 = v72 + (1505 - (771 + 733));
											v80 = v68[v72];
											v78[v80[3 - 1]][v78[v80[3]]] = v78[v80[8 - 4]];
											v72 = v72 + (1168 - (407 + 760));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[1 + 2];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1856 - (169 + 1685)]] = v78[v80[1 + 2]];
											v72 = v72 + (392 - (41 + 350));
											v1886 = 68 - 43;
										end
										if ((4693 > 796) and (v1886 == (25 - 16))) then
											v78[v80[8 - 6]][v78[v80[3]]] = v78[v80[9 - 5]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[889 - (790 + 97)]] = v80[13 - 10];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[2 + 1]];
											v72 = v72 + (246 - (235 + 10));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[3];
											v1886 = 20 - 10;
										end
										if (v1886 == (1201 - (887 + 296))) then
											v80 = v68[v72];
											v1887 = v80[1047 - (512 + 533)];
											v78[v1887] = v78[v1887](v13(v78, v1887 + (1425 - (662 + 762)), v80[3]));
											v72 = v72 + (678 - (334 + 343));
											v80 = v68[v72];
											v78[v80[6 - 4]][v78[v80[492 - (198 + 291)]]] = v78[v80[1 + 3]];
											v72 = v72 + (575 - (141 + 433));
											v80 = v68[v72];
											v78[v80[9 - 7]] = v80[2 + 1];
											v72 = v72 + (778 - (227 + 550));
											v1886 = 47 - 28;
										end
										if (v1886 == (19 - 12)) then
											v80 = v68[v72];
											v78[v80[105 - (72 + 31)]][v78[v80[351 - (89 + 259)]]] = v78[v80[4 + 0]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[5 - 2];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[3 - 1]] = v78[v80[1406 - (1333 + 70)]];
											v72 = v72 + (1833 - (701 + 1131));
											v80 = v68[v72];
											v1886 = 135 - (55 + 72);
										end
										if ((4827 >= 973) and (v1886 == (168 - (99 + 57)))) then
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1887 = v80[1581 - (1243 + 336)];
											v78[v1887] = v78[v1887](v13(v78, v1887 + (1330 - (774 + 555)), v80[3]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[801 - (150 + 649)]][v78[v80[2 + 1]]] = v78[v80[5 - 1]];
											v72 = v72 + (1 - 0);
											v1886 = 1997 - (1122 + 862);
										end
										if (v1886 == (0 - 0)) then
											v1887 = nil;
											v78[v80[1 + 1]] = v78[v80[3]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[1 + 2];
											v72 = v72 + (744 - (549 + 194));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[11 - 8];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1886 = 1 - 0;
										end
										if (v1886 == 13) then
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[10 - 7];
											v72 = v72 + (1704 - (453 + 1250));
											v80 = v68[v72];
											v78[v80[5 - 3]] = v78[v80[3 + 0]];
											v72 = v72 + (576 - (203 + 372));
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1886 = 40 - 26;
										end
										if (v1886 == (1384 - (978 + 404))) then
											v78[v80[6 - 4]] = v78[v80[3 + 0]];
											v72 = v72 + (319 - (56 + 262));
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[116 - (108 + 6)]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1887 = v80[2 + 0];
											v1886 = 3 + 0;
										end
										if ((v1886 == (1962 - (653 + 1299))) or (4282 == 2535)) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[6 - 3];
											v72 = v72 + (1923 - (1042 + 880));
											v80 = v68[v72];
											v1887 = v80[1 + 1];
											v78[v1887] = v78[v1887](v13(v78, v1887 + (1003 - (16 + 986)), v80[1221 - (700 + 518)]));
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2 - 0]][v78[v80[1514 - (617 + 894)]]] = v78[v80[7 - 3]];
											v1886 = 11;
										end
										if ((466 - (271 + 187)) == v1886) then
											v78[v80[2]] = v80[1587 - (731 + 853)];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2]] = v80[1524 - (199 + 1322)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v1887 = v80[3 - 1];
											v78[v1887] = v78[v1887](v13(v78, v1887 + 1, v80[2 + 1]));
											v72 = v72 + (1661 - (1291 + 369));
											v80 = v68[v72];
											v1886 = 1 + 8;
										end
										if ((2233 <= 4785) and (v1886 == 14)) then
											v78[v80[1 + 1]] = v80[3 + 0];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v1887 = v80[687 - (561 + 124)];
											v78[v1887] = v78[v1887](v13(v78, v1887 + 1 + 0, v80[856 - (25 + 828)]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[3 - 1]][v78[v80[593 - (99 + 491)]]] = v78[v80[52 - (18 + 30)]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v1886 = 15;
										end
									end
								else
									local v1888;
									local v1889;
									local v1890;
									v78[v80[3 - 1]] = {};
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[734 - (501 + 231)]] = v78[v80[3]][v78[v80[4 + 0]]];
									v72 = v72 + (1699 - (470 + 1228));
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[689 - (537 + 149)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[5 - 2]][v78[v80[12 - 8]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v1890 = v80[2 + 0];
									v1889 = v78[v1890];
									v1888 = v80[2 + 1];
									for v3920 = 1 + 0, v1888 do
										v1889[v3920] = v78[v1890 + v3920];
									end
								end
							elseif (v81 <= (37 + 47)) then
								local v432;
								v432 = v80[2 + 0];
								v78[v432] = v78[v432](v13(v78, v432 + 1 + 0, v80[3 + 0]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]][v80[2 + 1]] = v78[v80[583 - (134 + 445)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[11 - 8];
								v72 = v72 + (261 - (36 + 224));
								v80 = v68[v72];
								v78[v80[1862 - (1033 + 827)]] = v80[1849 - (1002 + 844)];
								v72 = v72 + (1351 - (1126 + 224));
								v80 = v68[v72];
								v432 = v80[1 + 1];
								v78[v432] = v78[v432](v13(v78, v432 + 1 + 0, v80[9 - 6]));
								v72 = v72 + (65 - (48 + 16));
								v80 = v68[v72];
								v78[v80[2 + 0]][v80[14 - 11]] = v78[v80[12 - 8]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1092 - (910 + 179)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[5 - 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1381 - (933 + 446)]] = v80[2 + 1];
								v72 = v72 + (1525 - (248 + 1276));
								v80 = v68[v72];
								v432 = v80[2 + 0];
								v78[v432] = v78[v432](v13(v78, v432 + 1 + 0, v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]][v80[9 - 6]] = v78[v80[1549 - (151 + 1394)]];
								v72 = v72 + (945 - (929 + 15));
								v80 = v68[v72];
								v78[v80[1998 - (1173 + 823)]] = v78[v80[4 - 1]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1778 - (482 + 1294)]] = v80[5 - 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1308 - (1125 + 181)]] = v80[8 - 5];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v432 = v80[2 - 0];
								v78[v432] = v78[v432](v13(v78, v432 + (1190 - (626 + 563)), v80[3]));
								v72 = v72 + (1251 - (153 + 1097));
								v80 = v68[v72];
								v78[v80[2]][v80[9 - 6]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[7 - 4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v432 = v80[2];
								v78[v432] = v78[v432](v13(v78, v432 + 1 + 0, v80[3 + 0]));
								v72 = v72 + (1158 - (199 + 958));
								v80 = v68[v72];
								v78[v80[2 + 0]][v80[3]] = v78[v80[4]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[3]];
								v72 = v72 + (1177 - (1169 + 7));
								v80 = v68[v72];
								v78[v80[1875 - (751 + 1122)]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1 + 2];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v432 = v80[1183 - (589 + 592)];
								v78[v432] = v78[v432](v13(v78, v432 + 1, v80[3]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]][v80[3]] = v78[v80[2 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[27 - (13 + 11)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + (1261 - (684 + 576));
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v432 = v80[2];
								v78[v432] = v78[v432](v13(v78, v432 + (2 - 1), v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v80[1 + 2]] = v78[v80[4 - 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[2 + 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (1849 - (230 + 1618));
								v80 = v68[v72];
								v432 = v80[2 + 0];
								v78[v432] = v78[v432](v13(v78, v432 + 1 + 0, v80[3 + 0]));
								v72 = v72 + (204 - (131 + 72));
								v80 = v68[v72];
								v78[v80[1 + 1]][v80[207 - (144 + 60)]] = v78[v80[16 - 12]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[3]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + (1923 - (523 + 1399));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[407 - (72 + 332)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v432 = v80[2];
								v78[v432] = v78[v432](v13(v78, v432 + (977 - (269 + 707)), v80[5 - 2]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[132 - (123 + 7)]][v80[3]] = v78[v80[4 + 0]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + (1089 - (38 + 1050));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v432 = v80[2];
								v78[v432] = v78[v432](v13(v78, v432 + (824 - (426 + 397)), v80[1409 - (751 + 655)]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]][v80[1248 - (39 + 1206)]] = v78[v80[12 - 8]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[844 - (566 + 275)];
								v72 = v72 + (936 - (167 + 768));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[4 - 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v432 = v80[2 + 0];
								v78[v432] = v78[v432](v13(v78, v432 + (1 - 0), v80[18 - (8 + 7)]));
								v72 = v72 + (1684 - (1510 + 173));
								v80 = v68[v72];
								v78[v80[2]][v80[4 - 1]] = v78[v80[1 + 3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[255 - (30 + 223)]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1258 - (300 + 956)]] = v80[125 - (22 + 100)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[284 - (47 + 235)]] = v80[3];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v432 = v80[2];
								v78[v432] = v78[v432](v13(v78, v432 + 1, v80[2 + 1]));
								v72 = v72 + (487 - (21 + 465));
								v80 = v68[v72];
								v78[v80[2 + 0]][v80[3 + 0]] = v78[v80[2 + 2]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1219 - (553 + 664)]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[81 - (73 + 5)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1717 - (1128 + 587)]] = v80[11 - 8];
								v72 = v72 + (691 - (558 + 132));
								v80 = v68[v72];
								v432 = v80[5 - 3];
								v78[v432] = v78[v432](v13(v78, v432 + (2 - 1), v80[1 + 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v80[3 + 0]] = v78[v80[5 - 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + (772 - (294 + 477));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[6 - 3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v432 = v80[4 - 2];
								v78[v432] = v78[v432](v13(v78, v432 + (983 - (97 + 885)), v80[2 + 1]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[367 - (271 + 94)]][v80[1606 - (777 + 826)]] = v78[v80[2 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1357 - (117 + 1238)]] = v78[v80[1718 - (686 + 1029)]];
								v72 = v72 + (1357 - (1074 + 282));
								v80 = v68[v72];
								v78[v80[1619 - (1359 + 258)]] = v80[6 - 3];
								v72 = v72 + (1936 - (1730 + 205));
								v80 = v68[v72];
								v78[v80[530 - (67 + 461)]] = v80[4 - 1];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v432 = v80[2];
								v78[v432] = v78[v432](v13(v78, v432 + (2 - 1), v80[1 + 2]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[631 - (129 + 500)]][v80[1714 - (1157 + 554)]] = v78[v80[5 - 1]];
								v72 = v72 + (608 - (82 + 525));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1625 - (948 + 675)]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[7 - 4];
								v72 = v72 + 1;
								v80 = v68[v72];
								v432 = v80[855 - (406 + 447)];
								v78[v432] = v78[v432](v13(v78, v432 + (118 - (91 + 26)), v80[3]));
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2 + 0]][v80[989 - (968 + 18)]] = v78[v80[4 + 0]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3 + 0]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[269 - (172 + 95)]] = v80[9 - 6];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[267 - (260 + 5)]] = v80[8 - 5];
							elseif (v81 > (904 - (265 + 554))) then
								local v1903 = 0;
								while true do
									if ((v1903 == 6) or (401 == 1816)) then
										v78[v80[1573 - (1440 + 131)]] = {};
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1397 - (253 + 1142)]] = v80[256 - (133 + 120)];
										break;
									end
									if ((v1903 == (5 - 2)) or (4472 <= 2732)) then
										v78[v80[1958 - (809 + 1147)]][v78[v80[500 - (178 + 319)]]] = v78[v80[4]];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 + 0]][v78[v80[1273 - (1255 + 15)]]] = v78[v80[1546 - (1221 + 321)]];
										v1903 = 11 - 7;
									end
									if (v1903 == (0 + 0)) then
										v78[v80[2]][v78[v80[11 - 8]]] = v78[v80[4]];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[3 + 0];
										v1903 = 1 - 0;
									end
									if (v1903 == (408 - (204 + 203))) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[81 - (48 + 30)]][v78[v80[2 + 2]]];
										v72 = v72 + (1965 - (1472 + 492));
										v1903 = 2;
									end
									if ((3648 < 3700) and (v1903 == (5 - 3))) then
										v80 = v68[v72];
										v78[v80[2]] = v80[2 + 1];
										v72 = v72 + (612 - (258 + 353));
										v80 = v68[v72];
										v1903 = 1997 - (1382 + 612);
									end
									if (v1903 == 4) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[1 + 2];
										v72 = v72 + (2 - 1);
										v1903 = 4 + 1;
									end
									if (v1903 == (124 - (35 + 84))) then
										v80 = v68[v72];
										v78[v80[217 - (75 + 140)]] = v78[v80[10 - 7]][v78[v80[4]]];
										v72 = v72 + (1800 - (923 + 876));
										v80 = v68[v72];
										v1903 = 15 - 9;
									end
								end
							else
								local v1904;
								local v1905;
								local v1906;
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[814 - (284 + 528)]] = v78[v80[1022 - (867 + 152)]][v78[v80[1110 - (709 + 397)]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[38 - (21 + 15)]] = {};
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v80[5 - 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[7 - 4]][v78[v80[4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v1906 = v80[2];
								v1905 = v78[v1906];
								v1904 = v80[3];
								for v3923 = 1 + 0, v1904 do
									v1905[v3923] = v78[v1906 + v3923];
								end
							end
						elseif (v81 <= (224 - (97 + 38))) then
							if ((1877 <= 2038) and (v81 <= (167 - (52 + 28)))) then
								v78[v80[1 + 1]][v78[v80[852 - (59 + 790)]]] = v78[v80[4 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[942 - (467 + 473)]] = v80[3];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[7 - 4]][v78[v80[4]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[6 - 3];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[4 - 1]]] = v78[v80[1 + 3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[241 - (58 + 179)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (1254 - (677 + 576));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[6 - 3]][v78[v80[224 - (88 + 132)]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
							elseif (v81 > 88) then
								local v1918;
								local v1919;
								local v1920;
								v78[v80[9 - 7]] = {};
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[293 - (12 + 279)]] = v80[4 - 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[4]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[949 - (652 + 295)]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[992 - (848 + 141)];
								v72 = v72 + (741 - (372 + 368));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[1133 - (542 + 588)]][v78[v80[4]]];
								v72 = v72 + (819 - (6 + 812));
								v80 = v68[v72];
								v1920 = v80[2];
								v1919 = v78[v1920];
								v1918 = v80[1708 - (1599 + 106)];
								for v3926 = 1, v1918 do
									v1919[v3926] = v78[v1920 + v3926];
								end
							else
								local v1934 = 0 - 0;
								while true do
									if (v1934 == 1) then
										v78[v80[1 + 1]] = v80[2 + 1];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v1934 = 2 - 0;
									end
									if ((1061 < 2971) and (v1934 == 4)) then
										v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1934 = 4 + 1;
									end
									if (9 == v1934) then
										v78[v80[1 + 1]] = v80[1 + 2];
										break;
									end
									if (5 == v1934) then
										v78[v80[1 + 1]][v78[v80[1932 - (1690 + 239)]]] = v78[v80[13 - 9]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1934 = 12 - 6;
									end
									if (v1934 == 8) then
										v78[v80[2]] = {};
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v1934 = 9;
									end
									if (v1934 == (5 + 1)) then
										v78[v80[7 - 5]] = v80[1871 - (1736 + 132)];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1934 = 22 - 15;
									end
									if (v1934 == (32 - 25)) then
										v78[v80[1 + 1]] = v78[v80[35 - (27 + 5)]][v78[v80[1 + 3]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1934 = 3 + 5;
									end
									if (v1934 == (0 + 0)) then
										v78[v80[2 + 0]][v78[v80[1120 - (771 + 346)]]] = v78[v80[4]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v1934 = 1635 - (1577 + 57);
									end
									if (v1934 == (2 - 0)) then
										v78[v80[1082 - (684 + 396)]] = v78[v80[8 - 5]][v78[v80[1200 - (700 + 496)]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1934 = 3;
									end
									if (v1934 == (255 - (65 + 187))) then
										v78[v80[941 - (827 + 112)]] = v80[3 + 0];
										v72 = v72 + 1;
										v80 = v68[v72];
										v1934 = 10 - 6;
									end
								end
							end
						elseif ((767 <= 2182) and (v81 <= (233 - 142))) then
							if (v81 > 90) then
								local v1935;
								local v1936;
								local v1937;
								v78[v80[9 - 7]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1198 - (551 + 645)]] = v78[v80[346 - (166 + 177)]][v78[v80[1860 - (1361 + 495)]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[226 - (148 + 76)]] = v78[v80[10 - 7]][v78[v80[10 - 6]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v1937 = v80[1744 - (735 + 1007)];
								v1936 = v78[v1937];
								v1935 = v80[282 - (111 + 168)];
								for v3929 = 1 + 0, v1935 do
									v1936[v3929] = v78[v1937 + v3929];
								end
							else
								v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[12 - 9]][v78[v80[4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[935 - (147 + 785)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[668 - (483 + 183)]][v78[v80[8 - 5]]] = v78[v80[4 + 0]];
								v72 = v72 + (1912 - (1790 + 121));
								v80 = v68[v72];
								v78[v80[6 - 4]][v78[v80[1542 - (259 + 1280)]]] = v78[v80[4]];
								v72 = v72 + (1585 - (160 + 1424));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + (771 - (479 + 291));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[4 - 1]][v78[v80[975 - (569 + 402)]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1307 - (635 + 670)]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[6 - 3];
							end
						elseif ((4530 > 2836) and (v81 > 92)) then
							local v1967 = 0 - 0;
							local v1968;
							local v1969;
							local v1970;
							while true do
								if (v1967 == (601 - (42 + 556))) then
									v78[v80[1403 - (1246 + 155)]] = {};
									v72 = v72 + (733 - (31 + 701));
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[3];
									v1967 = 503 - (393 + 106);
								end
								if ((v1967 == (1175 - (727 + 444))) or (4885 <= 2758)) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[8 - 5]][v78[v80[2 + 2]]];
									v72 = v72 + (654 - (269 + 384));
									v1967 = 1574 - (598 + 971);
								end
								if (v1967 == (2 + 3)) then
									v80 = v68[v72];
									v1970 = v80[6 - 4];
									v1969 = v78[v1970];
									v1968 = v80[3];
									v1967 = 28 - 22;
								end
								if ((2591 >= 1729) and (v1967 == (0 - 0))) then
									v1968 = nil;
									v1969 = nil;
									v1970 = nil;
									v78[v80[1447 - (800 + 645)]] = {};
									v1967 = 1 + 0;
								end
								if ((1521 > 330) and (v1967 == (796 - (687 + 103)))) then
									for v6846 = 1, v1968 do
										v1969[v6846] = v78[v1970 + v6846];
									end
									break;
								end
								if (v1967 == (1164 - (142 + 1020))) then
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[1 + 2]][v78[v80[517 - (306 + 207)]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1967 = 1407 - (112 + 1292);
								end
								if (v1967 == (1 + 0)) then
									v72 = v72 + (953 - (587 + 365));
									v80 = v68[v72];
									v78[v80[1717 - (829 + 886)]] = v80[7 - 4];
									v72 = v72 + 1 + 0;
									v1967 = 7 - 5;
								end
							end
						else
							local v1971 = 0;
							local v1972;
							local v1973;
							local v1974;
							while true do
								if (v1971 == (9 - 6)) then
									v78[v80[2 + 0]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[4 - 1];
									v1971 = 981 - (613 + 364);
								end
								if (v1971 == (5 + 0)) then
									v80 = v68[v72];
									v1974 = v80[1 + 1];
									v1973 = v78[v1974];
									v1972 = v80[1 + 2];
									v1971 = 13 - 7;
								end
								if ((14 - 10) == v1971) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[9 - 6]][v78[v80[3 + 1]]];
									v72 = v72 + (1940 - (1467 + 472));
									v1971 = 6 - 1;
								end
								if (v1971 == (1548 - (1077 + 470))) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + (4 - 3);
									v1971 = 431 - (12 + 417);
								end
								if ((v1971 == (0 - 0)) or (1722 == 1128)) then
									v1972 = nil;
									v1973 = nil;
									v1974 = nil;
									v78[v80[2]] = {};
									v1971 = 1 + 0;
								end
								if (v1971 == (2 - 0)) then
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[5 - 2]][v78[v80[2 + 2]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v1971 = 2 + 1;
								end
								if (v1971 == (1 + 5)) then
									for v6849 = 2 - 1, v1972 do
										v1973[v6849] = v78[v1974 + v6849];
									end
									break;
								end
							end
						end
					elseif (v81 <= (1205 - (924 + 181))) then
						if (v81 <= (893 - (263 + 534))) then
							if (v81 <= (4 + 90)) then
								v78[v80[2 + 0]] = {};
							elseif (v81 == (196 - 101)) then
								local v1975 = 0 - 0;
								while true do
									if ((v1975 == (3 + 1)) or (2128 >= 3553)) then
										v72 = v72 + (708 - (562 + 145));
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[3];
										v72 = v72 + 1 + 0;
										v1975 = 5;
									end
									if (v1975 == (3 + 3)) then
										v78[v80[1 + 1]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[3 - 1]] = v80[3 + 0];
										break;
									end
									if (v1975 == (23 - 18)) then
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[2 + 1]][v78[v80[1880 - (1459 + 417)]]];
										v72 = v72 + (287 - (194 + 92));
										v80 = v68[v72];
										v1975 = 1391 - (1057 + 328);
									end
									if (v1975 == (8 - 5)) then
										v78[v80[2]][v78[v80[3]]] = v78[v80[19 - 15]];
										v72 = v72 + (533 - (5 + 527));
										v80 = v68[v72];
										v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[784 - (342 + 438)]];
										v1975 = 2 + 2;
									end
									if ((1 + 1) == v1975) then
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[5 - 2];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v1975 = 1 + 2;
									end
									if ((3273 >= 1739) and (v1975 == (1 - 0))) then
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[14 - (6 + 6)]] = v78[v80[8 - 5]][v78[v80[10 - 6]]];
										v72 = v72 + 1 + 0;
										v1975 = 1255 - (206 + 1047);
									end
									if (v1975 == (1112 - (470 + 642))) then
										v78[v80[1 + 1]][v78[v80[1070 - (552 + 515)]]] = v78[v80[4 + 0]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v80[3 + 0];
										v1975 = 1 + 0;
									end
								end
							else
								local v1976;
								local v1977;
								local v1978;
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[1054 - (701 + 350)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[2 + 1]][v78[v80[6 - 2]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[7 - 5]] = v78[v80[1349 - (281 + 1065)]][v78[v80[18 - 14]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v1978 = v80[2];
								v1977 = v78[v1978];
								v1976 = v80[1214 - (1114 + 97)];
								for v3932 = 1, v1976 do
									v1977[v3932] = v78[v1978 + v3932];
								end
							end
						elseif (v81 <= 98) then
							if (v81 == (147 - 50)) then
								v78[v80[1915 - (279 + 1634)]][v78[v80[1283 - (1213 + 67)]]] = v78[v80[195 - (65 + 126)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1087 - (189 + 896)]] = v78[v80[1 + 2]][v78[v80[4]]];
								v72 = v72 + (1964 - (1872 + 91));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[14 - 10]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[14 - 10]];
								v72 = v72 + (77 - (22 + 54));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[7 - 4];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1 + 2]][v78[v80[15 - 11]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1536 - (553 + 981)]] = v80[3 + 0];
							else
								v78[v80[2 + 0]][v80[3 + 0]] = v78[v80[11 - 7]];
							end
						elseif (v81 > (146 - 47)) then
							v78[v80[1899 - (1320 + 577)]] = v80[852 - (667 + 182)];
						else
							local v2010;
							local v2011;
							local v2012;
							v78[v80[1290 - (1115 + 173)]] = {};
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[1758 - (1375 + 380)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[28 - (12 + 14)]] = #v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[6 - 3];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v2012 = v80[5 - 3];
							v2011 = v78[v2012];
							v2010 = v78[v2012 + (2 - 0)];
							if ((214 < 1254) and (v2010 > 0)) then
								if (v2011 > v78[v2012 + (1 - 0)]) then
									v72 = v80[734 - (354 + 377)];
								else
									v78[v2012 + (14 - 11)] = v2011;
								end
							elseif (v2011 < v78[v2012 + (2 - 1)]) then
								v72 = v80[1985 - (263 + 1719)];
							else
								v78[v2012 + 2 + 1] = v2011;
							end
						end
					elseif (v81 <= (462 - (335 + 24))) then
						if (v81 <= 101) then
							local v530;
							local v531;
							local v532;
							v78[v80[953 - (882 + 69)]] = v80[1689 - (657 + 1029)];
							v72 = v72 + (1201 - (685 + 515));
							v80 = v68[v72];
							v78[v80[1640 - (745 + 893)]] = v78[v80[1 + 2]][v78[v80[776 - (274 + 498)]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = {};
							v72 = v72 + (1607 - (1035 + 571));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[2 + 1];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[7 - 5]] = v78[v80[8 - 5]][v78[v80[4 + 0]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v532 = v80[5 - 3];
							v531 = v78[v532];
							v530 = v80[227 - (109 + 115)];
							for v927 = 1400 - (1047 + 352), v530 do
								v531[v927] = v78[v532 + v927];
							end
						elseif ((v81 > 102) or (1773 > 1975)) then
							v78[v80[2]] = v78[v80[1768 - (852 + 913)]] % v80[3 + 1];
						else
							local v2024 = 1345 - (384 + 961);
							local v2025;
							local v2026;
							local v2027;
							while true do
								if ((v2024 == (4 - 2)) or (2753 > 4358)) then
									for v6856 = 1, v80[11 - 7] do
										local v6857 = 0 - 0;
										local v6858;
										while true do
											if (v6857 == (592 - (591 + 1))) then
												v72 = v72 + 1 + 0;
												v6858 = v68[v72];
												v6857 = 1471 - (218 + 1252);
											end
											if (v6857 == (1 + 0)) then
												if (v6858[357 - (321 + 35)] == (574 - (239 + 155))) then
													v2027[v6856 - (1 + 0)] = {v78,v6858[3]};
												else
													v2027[v6856 - (1 + 0)] = {v60,v6858[3 + 0]};
												end
												v77[#v77 + (4 - 3)] = v2027;
												break;
											end
										end
									end
									v78[v80[4 - 2]] = v29(v2025, v2026, v61);
									break;
								end
								if ((v2024 == (0 - 0)) or (3435 <= 1453)) then
									v2025 = v69[v80[4 - 1]];
									v2026 = nil;
									v2024 = 1;
								end
								if (v2024 == (1 + 0)) then
									v2027 = {};
									v2026 = v10({}, {__index=function(v6859, v6860)
										local v6861 = v2027[v6860];
										return v6861[1 + 0][v6861[1 + 1]];
									end,__newindex=function(v6862, v6863, v6864)
										local v6865 = v2027[v6863];
										v6865[1][v6865[1228 - (165 + 1061)]] = v6864;
									end});
									v2024 = 2 + 0;
								end
							end
						end
					elseif (v81 <= (85 + 20)) then
						if (v81 > (1747 - (596 + 1047))) then
							v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4 + 0]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3];
							v72 = v72 + (738 - (185 + 552));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[604 - (507 + 94)]][v78[v80[17 - 13]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[1740 - (569 + 1168)];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[3 - 1]][v78[v80[354 - (118 + 233)]]] = v78[v80[4]];
							v72 = v72 + (345 - (279 + 65));
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[3]]] = v78[v80[7 - 3]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[1821 - (1414 + 404)];
							v72 = v72 + (757 - (347 + 409));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3 + 0]][v78[v80[3 + 1]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1580 - (420 + 1158)]] = {};
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[613 - (406 + 205)]] = v80[10 - 7];
						else
							local v2046;
							local v2047;
							local v2048;
							v78[v80[2 + 0]] = {};
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[64 - (28 + 33)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[1010 - (858 + 149)]][v78[v80[1 + 3]]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1509 - (829 + 678)]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1218 - (143 + 1073)]] = v78[v80[1818 - (898 + 917)]][v78[v80[7 - 3]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v2048 = v80[1471 - (882 + 587)];
							v2047 = v78[v2048];
							v2046 = v80[3 + 0];
							for v3935 = 1 + 0, v2046 do
								v2047[v3935] = v78[v2048 + v3935];
							end
						end
					elseif (v81 == (370 - (140 + 124))) then
						local v2062;
						v78[v80[2 + 0]][v80[3]] = v78[v80[4]];
						v72 = v72 + (1536 - (1105 + 430));
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[7 - 4]];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2]] = v80[6 - 3];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[3 - 1]] = v80[3 + 0];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v2062 = v80[2 + 0];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1 + 0, v80[1994 - (1047 + 944)]));
						v72 = v72 + (1303 - (206 + 1096));
						v80 = v68[v72];
						v78[v80[196 - (30 + 164)]][v80[3]] = v78[v80[17 - 13]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1476 - (1383 + 91)]] = v78[v80[11 - 8]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[1662 - (1174 + 486)]] = v80[430 - (172 + 255)];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2]] = v80[6 - 3];
						v72 = v72 + 1;
						v80 = v68[v72];
						v2062 = v80[1530 - (594 + 934)];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1, v80[3]));
						v72 = v72 + (569 - (211 + 357));
						v80 = v68[v72];
						v78[v80[1 + 1]][v80[3 + 0]] = v78[v80[6 - 2]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1416 - (159 + 1255)]] = v78[v80[3 + 0]];
						v72 = v72 + (778 - (24 + 753));
						v80 = v68[v72];
						v78[v80[1 + 1]] = v80[3 - 0];
						v72 = v72 + (1133 - (898 + 234));
						v80 = v68[v72];
						v78[v80[537 - (333 + 202)]] = v80[2 + 1];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v2062 = v80[3 - 1];
						v78[v2062] = v78[v2062](v13(v78, v2062 + (1280 - (1018 + 261)), v80[7 - 4]));
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[133 - (93 + 38)]][v80[1 + 2]] = v78[v80[3 + 1]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 + 0]] = v78[v80[6 - 3]];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[5 - 3]] = v80[14 - 11];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[3 - 1]] = v80[1 + 2];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v2062 = v80[2 + 0];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1, v80[423 - (14 + 406)]));
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[7 - 5]][v80[1633 - (20 + 1610)]] = v78[v80[4]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1 + 1]] = v78[v80[8 - 5]];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[519 - (243 + 274)]] = v80[3];
						v72 = v72 + (1623 - (1437 + 185));
						v80 = v68[v72];
						v78[v80[2]] = v80[9 - 6];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v2062 = v80[7 - 5];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1, v80[3 + 0]));
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[818 - (326 + 490)]][v80[3 + 0]] = v78[v80[207 - (181 + 22)]];
						v72 = v72 + (76 - (35 + 40));
						v80 = v68[v72];
						v78[v80[7 - 5]] = v78[v80[3 - 0]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]] = v80[881 - (297 + 581)];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 - 0]] = v80[9 - 6];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v2062 = v80[2];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1, v80[12 - 9]));
						v72 = v72 + (4 - 3);
						v80 = v68[v72];
						v78[v80[2]][v80[1740 - (1505 + 232)]] = v78[v80[1322 - (415 + 903)]];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[2 - 0]] = v78[v80[720 - (155 + 562)]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[119 - (71 + 46)]] = v80[4 - 1];
						v72 = v72 + (686 - (436 + 249));
						v80 = v68[v72];
						v78[v80[1623 - (56 + 1565)]] = v80[2 + 1];
						v72 = v72 + (985 - (80 + 904));
						v80 = v68[v72];
						v2062 = v80[1 + 1];
						v78[v2062] = v78[v2062](v13(v78, v2062 + (801 - (595 + 205)), v80[6 - 3]));
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[2 + 0]][v80[2 + 1]] = v78[v80[12 - 8]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[668 - (400 + 265)]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[1 + 1]] = v80[6 - 3];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]] = v80[1674 - (962 + 709)];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v2062 = v80[2 + 0];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1 + 0, v80[11 - 8]));
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[783 - (636 + 145)]][v80[298 - (282 + 13)]] = v78[v80[1152 - (366 + 782)]];
						v72 = v72 + (90 - (10 + 79));
						v80 = v68[v72];
						v78[v80[1709 - (1297 + 410)]] = v78[v80[10 - 7]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[281 - (262 + 16)];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v80[6 - 3];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v2062 = v80[1 + 1];
						v78[v2062] = v78[v2062](v13(v78, v2062 + (1851 - (1056 + 794)), v80[1351 - (741 + 607)]));
						v72 = v72 + (1757 - (730 + 1026));
						v80 = v68[v72];
						v78[v80[1795 - (248 + 1545)]][v80[3]] = v78[v80[996 - (191 + 801)]];
						v72 = v72 + (4 - 3);
						v80 = v68[v72];
						v78[v80[562 - (478 + 82)]] = v78[v80[1710 - (434 + 1273)]];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[12 - 9];
						v72 = v72 + (574 - (349 + 224));
						v80 = v68[v72];
						v78[v80[866 - (275 + 589)]] = v80[5 - 2];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v2062 = v80[1534 - (1064 + 468)];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1 + 0, v80[2 + 1]));
						v72 = v72 + (4 - 3);
						v80 = v68[v72];
						v78[v80[2]][v80[3]] = v78[v80[707 - (676 + 27)]];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[1430 - (48 + 1379)]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[2 + 1];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 - 0]] = v80[3 + 0];
						v72 = v72 + (116 - (79 + 36));
						v80 = v68[v72];
						v2062 = v80[2];
						v78[v2062] = v78[v2062](v13(v78, v2062 + (3 - 2), v80[2 + 1]));
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1 + 1]][v80[3]] = v78[v80[4 + 0]];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[1 + 1]] = v78[v80[2 + 1]];
						v72 = v72 + (1015 - (631 + 383));
						v80 = v68[v72];
						v78[v80[1637 - (445 + 1190)]] = v80[1428 - (810 + 615)];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1296 - (819 + 475)]] = v80[1338 - (243 + 1092)];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v2062 = v80[2];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1 + 0, v80[3 + 0]));
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 + 0]][v80[4 - 1]] = v78[v80[11 - 7]];
						v72 = v72 + (525 - (119 + 405));
						v80 = v68[v72];
						v78[v80[4 - 2]] = v78[v80[10 - 7]];
						v72 = v72 + (610 - (352 + 257));
						v80 = v68[v72];
						v78[v80[2]] = v80[1 + 2];
						v72 = v72 + (1164 - (88 + 1075));
						v80 = v68[v72];
						v78[v80[1073 - (477 + 594)]] = v80[726 - (328 + 395)];
						v72 = v72 + (505 - (164 + 340));
						v80 = v68[v72];
						v2062 = v80[2 - 0];
						v78[v2062] = v78[v2062](v13(v78, v2062 + (2 - 1), v80[1232 - (1008 + 221)]));
						v72 = v72 + (1512 - (1025 + 486));
						v80 = v68[v72];
						v78[v80[2]][v80[6 - 3]] = v78[v80[11 - 7]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[221 - (108 + 111)]] = v78[v80[101 - (82 + 16)]];
						v72 = v72 + (1730 - (533 + 1196));
						v80 = v68[v72];
						v78[v80[2 - 0]] = v80[215 - (161 + 51)];
						v72 = v72 + (435 - (294 + 140));
						v80 = v68[v72];
						v78[v80[2]] = v80[12 - 9];
						v72 = v72 + (839 - (717 + 121));
						v80 = v68[v72];
						v2062 = v80[2 - 0];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1 + 0, v80[1 + 2]));
						v72 = v72 + (1711 - (1001 + 709));
						v80 = v68[v72];
						v78[v80[2]][v80[3 + 0]] = v78[v80[1124 - (242 + 878)]];
						v72 = v72 + (1784 - (1395 + 388));
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[2 + 1]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v80[3 + 0];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1 + 1]] = v80[3];
						v72 = v72 + (1948 - (1289 + 658));
						v80 = v68[v72];
						v2062 = v80[2 + 0];
						v78[v2062] = v78[v2062](v13(v78, v2062 + (1 - 0), v80[3]));
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 + 0]][v80[3]] = v78[v80[4]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[5 - 2]];
						v72 = v72 + (1977 - (337 + 1639));
						v80 = v68[v72];
						v78[v80[2]] = v80[3 + 0];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[5 - 3]] = v80[6 - 3];
						v72 = v72 + (1738 - (630 + 1107));
						v80 = v68[v72];
						v2062 = v80[2];
						v78[v2062] = v78[v2062](v13(v78, v2062 + 1 + 0, v80[3]));
					else
						local v2156 = 0;
						local v2157;
						local v2158;
						local v2159;
						while true do
							if (v2156 == (1 + 2)) then
								v78[v80[2 - 0]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2156 = 4 + 0;
							end
							if ((4067 >= 1631) and ((65 - (13 + 48)) == v2156)) then
								v78[v80[701 - (658 + 41)]] = v80[5 - 2];
								v72 = v72 + (1908 - (1591 + 316));
								v80 = v68[v72];
								v2156 = 9 - 4;
							end
							if ((1 + 0) == v2156) then
								v78[v80[2]] = v80[2 + 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2156 = 6 - 4;
							end
							if ((2354 == 2354) and (v2156 == (1282 - (1241 + 35)))) then
								v2159 = v80[2];
								v2158 = v78[v2159];
								v2157 = v80[43 - (18 + 22)];
								v2156 = 9 - 2;
							end
							if ((v2156 == 2) or (1309 == 3691)) then
								v78[v80[1 + 1]] = v78[v80[1305 - (697 + 605)]][v78[v80[4]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2156 = 6 - 3;
							end
							if (v2156 == (329 - (188 + 141))) then
								v2157 = nil;
								v2158 = nil;
								v2159 = nil;
								v2156 = 4 - 3;
							end
							if (v2156 == 7) then
								for v6867 = 1, v2157 do
									v2158[v6867] = v78[v2159 + v6867];
								end
								break;
							end
							if ((1516 > 172) and (v2156 == (11 - 6))) then
								v78[v80[952 - (34 + 916)]] = v78[v80[1740 - (357 + 1380)]][v78[v80[4]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2156 = 6;
							end
						end
					end
				elseif ((2505 < 4949) and (v81 <= (76 + 85))) then
					if ((717 > 504) and (v81 <= (35 + 99))) then
						if (v81 <= 120) then
							if ((3435 == 3435) and (v81 <= (2040 - (178 + 1749)))) then
								if (v81 <= (307 - 197)) then
									if (v81 <= (1523 - (142 + 1273))) then
										local v545;
										local v546;
										local v547;
										v78[v80[595 - (284 + 309)]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[692 - (622 + 68)]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[6 - 3]][v78[v80[4]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1900 - (855 + 1043)]] = v80[6 - 3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[6 - 4]] = v78[v80[9 - 6]][v78[v80[783 - (576 + 203)]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v547 = v80[4 - 2];
										v546 = v78[v547];
										v545 = v80[3];
										for v930 = 1 - 0, v545 do
											v546[v930] = v78[v547 + v930];
										end
									elseif (v81 > (2093 - (709 + 1275))) then
										v78[v80[2 + 0]] = v78[v80[10 - 7]][v80[15 - 11]];
									else
										local v2162;
										local v2163;
										local v2164;
										v78[v80[120 - (31 + 87)]] = v80[134 - (44 + 87)];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[7 - 5]] = v78[v80[3 + 0]][v78[v80[4]]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[5 - 3]] = {};
										v72 = v72 + (787 - (284 + 502));
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[1189 - (124 + 1062)]][v78[v80[1031 - (847 + 180)]]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2164 = v80[8 - 6];
										v2163 = v78[v2164];
										v2162 = v80[1366 - (369 + 994)];
										for v3938 = 964 - (583 + 380), v2162 do
											v2163[v3938] = v78[v2164 + v3938];
										end
									end
								elseif (v81 <= (25 + 86)) then
									local v561;
									v78[v80[2 + 0]] = v78[v80[2 + 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1976 - (1085 + 888)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[13 - 10];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v561 = v80[1 + 1];
									v78[v561] = v78[v561](v13(v78, v561 + 1, v80[2 + 1]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[4 - 1]]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3 + 0];
									v72 = v72 + (215 - (153 + 61));
									v80 = v68[v72];
									v78[v80[945 - (704 + 239)]] = v78[v80[2 + 1]];
									v72 = v72 + (1387 - (740 + 646));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1925 - (1547 + 375)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v561 = v80[405 - (211 + 192)];
									v78[v561] = v78[v561](v13(v78, v561 + (4 - 3), v80[4 - 1]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[783 - (425 + 356)]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[1569 - (83 + 1483)];
									v72 = v72 + (1273 - (123 + 1149));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1582 - (908 + 672)]] = v80[516 - (206 + 307)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[64 - (18 + 44)]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v561 = v80[3 - 1];
									v78[v561] = v78[v561](v13(v78, v561 + (2 - 1), v80[3]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[937 - (226 + 709)]][v78[v80[729 - (235 + 491)]]] = v78[v80[6 - 2]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[1302 - (463 + 836)];
									v72 = v72 + (405 - (166 + 238));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[3 + 0]];
									v72 = v72 + (1442 - (1080 + 361));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[2 + 1];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[302 - (254 + 46)]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v561 = v80[2 + 0];
									v78[v561] = v78[v561](v13(v78, v561 + (257 - (37 + 219)), v80[1902 - (1330 + 569)]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 - 0]][v78[v80[11 - 8]]] = v78[v80[5 - 1]];
									v72 = v72 + (671 - (128 + 542));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[10 - 7];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[10 - 7]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3 + 0];
									v72 = v72 + (813 - (96 + 716));
									v80 = v68[v72];
									v561 = v80[1609 - (85 + 1522)];
									v78[v561] = v78[v561](v13(v78, v561 + 1, v80[3]));
									v72 = v72 + (854 - (724 + 129));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[9 - 6]]] = v78[v80[377 - (83 + 290)]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[6 - 3];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[449 - (190 + 257)]] = v80[3];
									v72 = v72 + (592 - (402 + 189));
									v80 = v68[v72];
									v561 = v80[2];
									v78[v561] = v78[v561](v13(v78, v561 + 1 + 0, v80[569 - (90 + 476)]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[817 - (688 + 126)]]] = v78[v80[2 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + (500 - (34 + 465));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[12 - 9]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[5 - 2];
									v72 = v72 + (1808 - (587 + 1220));
									v80 = v68[v72];
									v561 = v80[1894 - (1211 + 681)];
									v78[v561] = v78[v561](v13(v78, v561 + (78 - (64 + 13)), v80[658 - (121 + 534)]));
									v72 = v72 + (804 - (622 + 181));
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[1672 - (296 + 1373)]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1 + 2];
									v72 = v72 + (1615 - (143 + 1471));
									v80 = v68[v72];
									v78[v80[6 - 4]] = v78[v80[2 + 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[183 - (103 + 77)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v561 = v80[2];
									v78[v561] = v78[v561](v13(v78, v561 + 1, v80[1160 - (895 + 262)]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[1630 - (581 + 1045)]];
									v72 = v72 + (1276 - (582 + 693));
									v80 = v68[v72];
									v78[v80[1188 - (454 + 732)]] = v80[5 - 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[3 - 0]];
									v72 = v72 + (651 - (367 + 283));
									v80 = v68[v72];
									v78[v80[2]] = v80[71 - (7 + 61)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[1 + 2];
									v72 = v72 + (679 - (332 + 346));
									v80 = v68[v72];
									v561 = v80[3 - 1];
									v78[v561] = v78[v561](v13(v78, v561 + 1, v80[4 - 1]));
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[4 + 0]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[1857 - (815 + 1039)];
									v72 = v72 + (777 - (336 + 440));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v561 = v80[432 - (222 + 208)];
									v78[v561] = v78[v561](v13(v78, v561 + 1, v80[3]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[832 - (652 + 178)]][v78[v80[3]]] = v78[v80[5 - 1]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[397 - (259 + 135)]];
									v72 = v72 + (1461 - (1393 + 67));
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1450 - (1129 + 319)]] = v80[2 + 1];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v561 = v80[414 - (137 + 275)];
									v78[v561] = v78[v561](v13(v78, v561 + (440 - (140 + 299)), v80[1104 - (421 + 680)]));
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[7 - 4]]] = v78[v80[3 + 1]];
									v72 = v72 + (541 - (58 + 482));
									v80 = v68[v72];
									v78[v80[681 - (310 + 369)]] = v80[3 + 0];
									v72 = v72 + (287 - (274 + 12));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3 + 0]];
									v72 = v72 + (1763 - (681 + 1081));
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[5 - 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[879 - (842 + 35)]] = v80[4 - 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v561 = v80[2];
									v78[v561] = v78[v561](v13(v78, v561 + (1868 - (180 + 1687)), v80[6 - 3]));
									v72 = v72 + (972 - (269 + 702));
									v80 = v68[v72];
									v78[v80[816 - (776 + 38)]][v78[v80[2 + 1]]] = v78[v80[8 - 4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[1 + 2]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[11 - 8];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[957 - (135 + 820)]] = v80[139 - (118 + 18)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v561 = v80[1 + 1];
									v78[v561] = v78[v561](v13(v78, v561 + 1, v80[14 - 11]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[1 + 2]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1295 - (741 + 552)]] = v80[1 + 2];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[887 - (779 + 105)]];
									v72 = v72 + (1782 - (1451 + 330));
									v80 = v68[v72];
									v78[v80[1871 - (1259 + 610)]] = v80[853 - (4 + 846)];
								elseif (v81 > (1969 - (1108 + 749))) then
									local v2178;
									local v2179;
									local v2180;
									v78[v80[1743 - (1301 + 440)]] = {};
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[479 - (168 + 308)]][v78[v80[4]]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1349 - (469 + 878)]] = v80[3 + 0];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[1 + 2]][v78[v80[4]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v2180 = v80[2 + 0];
									v2179 = v78[v2180];
									v2178 = v80[11 - 8];
									for v3941 = 1841 - (1332 + 508), v2178 do
										v2179[v3941] = v78[v2180 + v3941];
									end
								else
									v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[1 + 3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1144 - (650 + 492)]] = v80[3];
									v72 = v72 + (807 - (689 + 117));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]][v78[v80[9 - 5]]];
									v72 = v72 + (1924 - (794 + 1129));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[864 - (553 + 308)]]] = v78[v80[7 - 3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1770 - (1764 + 4)]] = v80[520 - (121 + 396)];
									v72 = v72 + (555 - (498 + 56));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]][v78[v80[14 - 10]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[1 + 2];
								end
							elseif ((4301 >= 318) and (v81 <= (274 - 158))) then
								if (v81 <= 114) then
									local v644 = 1616 - (316 + 1300);
									while true do
										if ((175 - (78 + 94)) == v644) then
											v78[v80[1418 - (261 + 1155)]] = v80[1459 - (1040 + 416)];
											v72 = v72 + (44 - (29 + 14));
											v80 = v68[v72];
											v644 = 7 - 3;
										end
										if (v644 == (966 - (928 + 34))) then
											v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[1 + 3]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v644 = 18 - 13;
										end
										if (v644 == (2 - 1)) then
											v78[v80[2 - 0]] = v80[513 - (69 + 441)];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v644 = 2 + 0;
										end
										if ((464 < 1234) and ((20 - 11) == v644)) then
											v78[v80[1882 - (517 + 1363)]] = v80[3];
											break;
										end
										if (v644 == 0) then
											v78[v80[2]][v78[v80[3]]] = v78[v80[932 - (802 + 126)]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v644 = 1669 - (1660 + 8);
										end
										if (v644 == (17 - 12)) then
											v78[v80[183 - (38 + 143)]][v78[v80[8 - 5]]] = v78[v80[121 - (29 + 88)]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v644 = 495 - (308 + 181);
										end
										if (v644 == 7) then
											v78[v80[1399 - (537 + 860)]] = v78[v80[2 + 1]][v78[v80[4]]];
											v72 = v72 + (1096 - (691 + 404));
											v80 = v68[v72];
											v644 = 8;
										end
										if (v644 == (1962 - (870 + 1084))) then
											v78[v80[131 - (47 + 82)]] = {};
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v644 = 8 + 1;
										end
										if (((2 + 0) == v644) or (1228 >= 1774)) then
											v78[v80[2]] = v78[v80[9 - 6]][v78[v80[4]]];
											v72 = v72 + (118 - (84 + 33));
											v80 = v68[v72];
											v644 = 2 + 1;
										end
										if (v644 == 6) then
											v78[v80[6 - 4]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v644 = 17 - 10;
										end
									end
								elseif ((4090 > 1368) and (v81 > (333 - 218))) then
									local v2210;
									local v2211;
									local v2212;
									v78[v80[2]] = v80[14 - 11];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1222 - (87 + 1133)]] = v78[v80[8 - 5]][v78[v80[2 + 2]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + (668 - (205 + 462));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 - 0];
									v72 = v72 + (1382 - (1035 + 346));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3]][v78[v80[4]]];
									v72 = v72 + (1781 - (970 + 810));
									v80 = v68[v72];
									v2212 = v80[2];
									v2211 = v78[v2212];
									v2210 = v80[3 + 0];
									for v3972 = 2 - 1, v2210 do
										v2211[v3972] = v78[v2212 + v3972];
									end
								else
									local v2225;
									local v2226;
									local v2227;
									v78[v80[2]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[7 - 4];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1390 - (601 + 787)]] = v78[v80[613 - (256 + 354)]][v78[v80[7 - 3]]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[4 - 2]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[4 - 1];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[5 - 2]][v78[v80[9 - 5]]];
									v72 = v72 + (573 - (259 + 313));
									v80 = v68[v72];
									v2227 = v80[2 - 0];
									v2226 = v78[v2227];
									v2225 = v80[3];
									for v3975 = 1 + 0, v2225 do
										v2226[v3975] = v78[v2227 + v3975];
									end
								end
							elseif ((1318 < 4118) and (v81 <= (36 + 82))) then
								if ((548 < 2182) and (v81 == (80 + 37))) then
									v78[v80[2]][v78[v80[8 - 5]]] = v78[v80[1342 - (413 + 925)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[3]][v78[v80[3 + 1]]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v80[1947 - (1164 + 780)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1362 - (596 + 764)]][v78[v80[3]]] = v78[v80[286 - (52 + 230)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[9 - 6]]] = v78[v80[4]];
									v72 = v72 + (1567 - (806 + 760));
									v80 = v68[v72];
									v78[v80[2]] = v80[8 - 5];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[2 + 1]][v78[v80[1 + 3]]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 - 0]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
								else
									v78[v80[1967 - (1000 + 965)]] = v78[v80[2 + 1]][v78[v80[16 - 12]]];
								end
							elseif (v81 > 119) then
								local v2260 = 0 - 0;
								local v2261;
								local v2262;
								local v2263;
								while true do
									if (v2260 == (0 + 0)) then
										v2261 = nil;
										v2262 = nil;
										v2263 = nil;
										v2260 = 1127 - (261 + 865);
									end
									if (v2260 == (14 - 9)) then
										v78[v80[2 - 0]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2260 = 6;
									end
									if ((1241 <= 1550) and (v2260 == (553 - (33 + 512)))) then
										for v6870 = 1837 - (1555 + 281), v2261 do
											v2262[v6870] = v78[v2263 + v6870];
										end
										break;
									end
									if (7 == v2260) then
										v2263 = v80[2];
										v2262 = v78[v2263];
										v2261 = v80[6 - 3];
										v2260 = 5 + 3;
									end
									if (v2260 == (2 - 0)) then
										v78[v80[2 + 0]] = v80[8 - 5];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2260 = 42 - (34 + 5);
									end
									if (v2260 == (3 + 0)) then
										v78[v80[1 + 1]] = v78[v80[3 + 0]][v78[v80[2 + 2]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2260 = 4;
									end
									if ((1114 <= 2934) and ((2 + 4) == v2260)) then
										v78[v80[2]] = v78[v80[9 - 6]][v78[v80[8 - 4]]];
										v72 = v72 + (1222 - (999 + 222));
										v80 = v68[v72];
										v2260 = 3 + 4;
									end
									if ((2107 > 496) and ((1 + 0) == v2260)) then
										v78[v80[346 - (166 + 178)]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2260 = 2;
									end
									if ((1413 >= 1083) and (v2260 == (11 - 7))) then
										v78[v80[1302 - (587 + 713)]] = {};
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2260 = 1127 - (11 + 1111);
									end
								end
							else
								local v2264 = 0 + 0;
								local v2265;
								while true do
									if (v2264 == 3) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[1103 - (882 + 218)];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2265 = v80[2];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1 + 0, v80[965 - (115 + 847)]));
										v72 = v72 + (2 - 1);
										v2264 = 1619 - (1231 + 384);
									end
									if (v2264 == (39 - 21)) then
										v78[v2265] = v78[v2265](v13(v78, v2265 + (1697 - (1202 + 494)), v80[181 - (12 + 166)]));
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[606 - (202 + 402)]] = v80[2 + 1];
										v72 = v72 + (999 - (936 + 62));
										v2264 = 367 - (119 + 229);
									end
									if ((v2264 == (33 - 19)) or (2087 >= 2118)) then
										v78[v80[7 - 5]] = v80[1 + 2];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1438 - (513 + 923)]] = v78[v80[1780 - (507 + 1270)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[7 - 5]] = v80[3];
										v72 = v72 + 1 + 0;
										v2264 = 57 - 42;
									end
									if (v2264 == (2 - 0)) then
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + (770 - (644 + 125));
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[1850 - (718 + 1129)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[5 - 3]] = v80[1412 - (564 + 845)];
										v2264 = 8 - 5;
									end
									if (((190 - (46 + 116)) == v2264) or (4769 == 2887)) then
										v72 = v72 + (651 - (575 + 75));
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v78[v80[9 - 6]];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v2264 = 11 + 18;
									end
									if (v2264 == 9) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[3 + 0];
										v72 = v72 + (671 - (224 + 446));
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[1 + 2]];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v2264 = 10;
									end
									if (v2264 == (343 - (56 + 262))) then
										v2265 = v80[7 - 5];
										v78[v2265] = v78[v2265](v13(v78, v2265 + (702 - (666 + 35)), v80[3]));
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1182 - (553 + 627)]][v78[v80[1476 - (936 + 537)]]] = v78[v80[1 + 3]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[1203 - (737 + 463)];
										v2264 = 20 + 6;
									end
									if ((682 - (424 + 243)) == v2264) then
										v80 = v68[v72];
										v78[v80[2]] = v80[1 + 2];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v2265 = v80[1348 - (1213 + 133)];
										v78[v2265] = v78[v2265](v13(v78, v2265 + (1 - 0), v80[3]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2264 = 76 - (37 + 23);
									end
									if ((v2264 == (61 - 44)) or (4657 <= 4605)) then
										v80 = v68[v72];
										v78[v80[1345 - (122 + 1221)]] = v80[3];
										v72 = v72 + (243 - (139 + 103));
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[2 + 1];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v2265 = v80[2 + 0];
										v2264 = 18;
									end
									if (v2264 == 11) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]][v78[v80[109 - (9 + 97)]]] = v78[v80[6 - 2]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2264 = 7 + 5;
									end
									if ((4 + 1) == v2264) then
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v78[v80[1077 - (657 + 418)]] = v80[3];
										v72 = v72 + (1981 - (448 + 1532));
										v80 = v68[v72];
										v78[v80[2]] = v80[256 - (110 + 143)];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2264 = 16 - 10;
									end
									if (v2264 == 24) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[945 - (549 + 394)]] = v80[2 + 1];
										v72 = v72 + (1235 - (500 + 734));
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[1 + 2];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2264 = 25;
									end
									if (v2264 == (688 - (343 + 322))) then
										v80 = v68[v72];
										v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[1 + 2];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3]];
										v2264 = 84 - 60;
									end
									if (v2264 == (1132 - (297 + 834))) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v2265 = v80[9 - 7];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1 + 0, v80[3]));
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[4]];
										v72 = v72 + (787 - (494 + 292));
										v2264 = 1 + 1;
									end
									if (v2264 == 4) then
										v80 = v68[v72];
										v78[v80[9 - 7]][v78[v80[1635 - (888 + 744)]]] = v78[v80[1 + 3]];
										v72 = v72 + (686 - (206 + 479));
										v80 = v68[v72];
										v78[v80[2]] = v80[1 + 2];
										v72 = v72 + (1174 - (861 + 312));
										v80 = v68[v72];
										v78[v80[738 - (135 + 601)]] = v78[v80[1145 - (1085 + 57)]];
										v2264 = 1930 - (224 + 1701);
									end
									if ((v2264 == 27) or (1744 >= 4525)) then
										v78[v80[1 + 1]] = v80[3];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v2265 = v80[2 + 0];
										v78[v2265] = v78[v2265](v13(v78, v2265 + (3 - 2), v80[3 + 0]));
										v72 = v72 + (747 - (730 + 16));
										v80 = v68[v72];
										v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4]];
										v2264 = 1610 - (790 + 792);
									end
									if ((v2264 == 20) or (3849 < 2971)) then
										v72 = v72 + (1082 - (474 + 607));
										v80 = v68[v72];
										v2265 = v80[532 - (129 + 401)];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1, v80[4 - 1]));
										v72 = v72 + (119 - (51 + 67));
										v80 = v68[v72];
										v78[v80[1 + 1]][v78[v80[116 - (93 + 20)]]] = v78[v80[4]];
										v72 = v72 + (3 - 2);
										v2264 = 41 - (12 + 8);
									end
									if ((v2264 == (198 - (161 + 37))) or (4027 < 427)) then
										v2265 = nil;
										v78[v80[1 + 1]] = v78[v80[1560 - (507 + 1050)]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[3 - 1]] = v80[3];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[1 + 2];
										v2264 = 1;
									end
									if (v2264 == (4 + 12)) then
										v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[7 - 3]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[867 - (184 + 680)];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[8 - 5]];
										v72 = v72 + 1;
										v2264 = 10 + 7;
									end
									if (v2264 == 8) then
										v78[v80[4 - 2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2265 = v80[3 - 1];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1 + 0, v80[1053 - (629 + 421)]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[3 - 1]][v78[v80[6 - 3]]] = v78[v80[944 - (544 + 396)]];
										v2264 = 9;
									end
									if ((v2264 == (35 - 16)) or (4326 > 4624)) then
										v80 = v68[v72];
										v78[v80[993 - (904 + 87)]] = v78[v80[10 - 7]];
										v72 = v72 + (1475 - (1443 + 31));
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[1816 - (1110 + 703)];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[7 - 4];
										v2264 = 54 - 34;
									end
									if (v2264 == (213 - (78 + 125))) then
										v78[v80[2]] = v80[3];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2]] = v80[5 - 2];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v2265 = v80[1826 - (1392 + 432)];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1 + 0, v80[7 - 4]));
										v2264 = 11;
									end
									if ((v2264 == 30) or (4974 == 3938)) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]][v78[v80[1405 - (963 + 439)]]] = v78[v80[8 - 4]];
										v72 = v72 + (1326 - (76 + 1249));
										v80 = v68[v72];
										v78[v80[2]] = v80[1754 - (1165 + 586)];
										v72 = v72 + (1929 - (1916 + 12));
										v80 = v68[v72];
										v2264 = 31;
									end
									if (v2264 == (1263 - (604 + 652))) then
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[3]];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[6 - 3];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v2264 = 8;
									end
									if (v2264 == (42 - 16)) then
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[15 - (11 + 2)]] = v78[v80[1445 - (64 + 1378)]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1755 - (256 + 1497)]] = v80[3 - 0];
										v72 = v72 + (878 - (562 + 315));
										v80 = v68[v72];
										v2264 = 107 - 80;
									end
									if (v2264 == (1217 - (577 + 611))) then
										v78[v80[2 + 0]] = v80[3];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[3 - 1]] = v80[74 - (58 + 13)];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2265 = v80[2 + 0];
										v78[v2265] = v78[v2265](v13(v78, v2265 + (455 - (404 + 50)), v80[39 - (6 + 30)]));
										v2264 = 1363 - (770 + 563);
									end
									if (v2264 == 12) then
										v78[v80[2 + 0]] = v78[v80[1 + 2]];
										v72 = v72 + (171 - (25 + 145));
										v80 = v68[v72];
										v78[v80[2]] = v80[3 + 0];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[701 - (153 + 546)]] = v80[3 + 0];
										v72 = v72 + (928 - (60 + 867));
										v2264 = 46 - 33;
									end
									if ((1289 - (309 + 974)) == v2264) then
										v2265 = v80[2];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1, v80[2 + 1]));
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1143 - (677 + 464)]][v78[v80[825 - (567 + 255)]]] = v78[v80[5 - 1]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 - 0]] = v80[531 - (384 + 144)];
										v2264 = 1228 - (1030 + 191);
									end
									if (((41 - 20) == v2264) or (1116 >= 3762)) then
										v80 = v68[v72];
										v78[v80[2]] = v80[4 - 1];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[860 - (326 + 531)]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[3];
										v2264 = 8 + 14;
									end
									if (v2264 == (6 + 16)) then
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2]] = v80[1 + 2];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2265 = v80[2 + 0];
										v78[v2265] = v78[v2265](v13(v78, v2265 + 1, v80[1624 - (1367 + 254)]));
										v72 = v72 + (679 - (305 + 373));
										v2264 = 23;
									end
									if (v2264 == (41 - 10)) then
										v78[v80[321 - (129 + 190)]] = v78[v80[8 - 5]];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[3];
										break;
									end
									if ((13 + 0) == v2264) then
										v80 = v68[v72];
										v2265 = v80[291 - (210 + 79)];
										v78[v2265] = v78[v2265](v13(v78, v2265 + (1 - 0), v80[7 - 4]));
										v72 = v72 + (673 - (32 + 640));
										v80 = v68[v72];
										v78[v80[2 + 0]][v78[v80[2 + 1]]] = v78[v80[2 + 2]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2264 = 14;
									end
								end
							end
						elseif (v81 <= (81 + 46)) then
							if ((v81 <= (1884 - (847 + 914))) or (4732 == 1094)) then
								if (v81 <= (349 - 228)) then
									local v645 = 0;
									local v646;
									local v647;
									local v648;
									while true do
										if (v645 == 4) then
											v78[v80[4 - 2]] = v78[v80[527 - (163 + 361)]][v78[v80[889 - (162 + 723)]]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v645 = 406 - (258 + 143);
										end
										if ((v645 == (8 - 6)) or (2691 < 2454)) then
											v78[v80[3 - 1]] = {};
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v645 = 1694 - (486 + 1205);
										end
										if ((168 - (92 + 73)) == v645) then
											v78[v80[2 + 0]] = v80[3 + 0];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v645 = 4;
										end
										if ((4578 == 4578) and (1 == v645)) then
											v78[v80[274 - (68 + 204)]] = v78[v80[4 - 1]][v78[v80[4]]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v645 = 1 + 1;
										end
										if (v645 == (0 - 0)) then
											v646 = nil;
											v647 = nil;
											v648 = nil;
											v645 = 1;
										end
										if (v645 == (3 + 3)) then
											v78[v80[2]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v645 = 7;
										end
										if (v645 == (6 + 1)) then
											v78[v80[318 - (20 + 296)]] = v78[v80[3]][v78[v80[3 + 1]]];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v645 = 27 - 19;
										end
										if ((13 - 4) == v645) then
											for v4752 = 1 + 0, v646 do
												v647[v4752] = v78[v648 + v4752];
											end
											break;
										end
										if ((2 + 6) == v645) then
											v648 = v80[5 - 3];
											v647 = v78[v648];
											v646 = v80[2 + 1];
											v645 = 9 + 0;
										end
										if (v645 == (3 + 2)) then
											v78[v80[5 - 3]] = {};
											v72 = v72 + 1;
											v80 = v68[v72];
											v645 = 6;
										end
									end
								elseif (v81 > (222 - 100)) then
									local v2266;
									local v2267;
									local v2268;
									v78[v80[2 + 0]] = {};
									v72 = v72 + (250 - (155 + 94));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[910 - (515 + 392)];
									v72 = v72 + (327 - (7 + 319));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[1 + 2]][v78[v80[1501 - (292 + 1205)]]];
									v72 = v72 + (53 - (13 + 39));
									v80 = v68[v72];
									v78[v80[2]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[7 - 5]] = v78[v80[1041 - (850 + 188)]][v78[v80[1040 - (822 + 214)]]];
									v72 = v72 + (1162 - (317 + 844));
									v80 = v68[v72];
									v2268 = v80[2 + 0];
									v2267 = v78[v2268];
									v2266 = v80[2 + 1];
									for v4000 = 1191 - (508 + 682), v2266 do
										v2267[v4000] = v78[v2268 + v4000];
									end
								else
									local v2281 = 0 + 0;
									while true do
										if (v2281 == (2 + 1)) then
											v78[v80[547 - (127 + 418)]][v78[v80[8 - 5]]] = v78[v80[9 - 5]];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v78[v80[2]][v78[v80[3]]] = v78[v80[6 - 2]];
											v2281 = 1124 - (690 + 430);
										end
										if (((19 - 14) == v2281) or (4835 < 265)) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[5 - 2]][v78[v80[956 - (637 + 315)]]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2281 = 17 - 11;
										end
										if ((1088 == 1088) and (v2281 == (12 - 8))) then
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[7 - 4];
											v72 = v72 + (21 - (13 + 7));
											v2281 = 1 + 4;
										end
										if (v2281 == (9 - 3)) then
											v78[v80[4 - 2]] = {};
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2]] = v80[2 + 1];
											break;
										end
										if (v2281 == 2) then
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[354 - (44 + 307)];
											v72 = v72 + (798 - (127 + 670));
											v80 = v68[v72];
											v2281 = 3 + 0;
										end
										if (v2281 == (584 - (375 + 209))) then
											v78[v80[2]][v78[v80[1819 - (1673 + 143)]]] = v78[v80[4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[3];
											v2281 = 1450 - (836 + 613);
										end
										if (v2281 == (1 - 0)) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1532 - (295 + 1235)]] = v78[v80[3]][v78[v80[544 - (328 + 212)]]];
											v72 = v72 + (2 - 1);
											v2281 = 921 - (517 + 402);
										end
									end
								end
							elseif (v81 <= (279 - 154)) then
								if (v81 == 124) then
									local v2282 = 0 - 0;
									local v2283;
									local v2284;
									local v2285;
									while true do
										if (v2282 == (1086 - (700 + 382))) then
											v72 = v72 + (880 - (677 + 202));
											v80 = v68[v72];
											v2285 = v80[2 - 0];
											v2284 = v78[v2285];
											v2282 = 5;
										end
										if ((5 - 3) == v2282) then
											v80 = v68[v72];
											v78[v80[2]] = {};
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2282 = 3;
										end
										if ((758 - (360 + 393)) == v2282) then
											v2283 = v80[9 - 6];
											for v6873 = 1958 - (1231 + 726), v2283 do
												v2284[v6873] = v78[v2285 + v6873];
											end
											break;
										end
										if ((v2282 == (1 - 0)) or (200 >= 3460)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1912 - (173 + 1737)]] = v78[v80[1950 - (441 + 1506)]][v78[v80[1 + 3]]];
											v72 = v72 + (3 - 2);
											v2282 = 696 - (136 + 558);
										end
										if (v2282 == (2 + 1)) then
											v78[v80[1224 - (988 + 234)]] = v80[2 + 1];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[4 - 2]] = v78[v80[654 - (125 + 526)]][v78[v80[13 - 9]]];
											v2282 = 4 + 0;
										end
										if ((0 - 0) == v2282) then
											v2283 = nil;
											v2284 = nil;
											v2285 = nil;
											v78[v80[1128 - (290 + 836)]] = v80[3];
											v2282 = 1 + 0;
										end
									end
								else
									local v2286 = 0 - 0;
									local v2287;
									while true do
										if (v2286 == (690 - (8 + 672))) then
											v78[v80[2]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[1439 - (740 + 696)];
											v72 = v72 + (1047 - (353 + 693));
											v80 = v68[v72];
											v2287 = v80[2 + 0];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (1494 - (35 + 1458)), v80[1873 - (1821 + 49)]));
											v72 = v72 + (2 - 1);
											v2286 = 11;
										end
										if ((1736 - (727 + 1007)) == v2286) then
											v72 = v72 + (168 - (165 + 2));
											v80 = v68[v72];
											v2287 = v80[1661 - (1028 + 631)];
											v78[v2287] = v78[v2287](v13(v78, v2287 + 1, v80[3]));
											v72 = v72 + (1616 - (311 + 1304));
											v80 = v68[v72];
											v78[v80[4 - 2]][v78[v80[1 + 2]]] = v78[v80[1 + 3]];
											v72 = v72 + (580 - (512 + 67));
											v80 = v68[v72];
											v2286 = 7 - 4;
										end
										if (v2286 == (2 + 6)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[1 + 2];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2287 = v80[2 - 0];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (2 - 1), v80[1 + 2]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v2286 = 1798 - (395 + 1394);
										end
										if ((4080 == 4080) and (v2286 == (68 - 49))) then
											v80 = v68[v72];
											v2287 = v80[2 + 0];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (2 - 1), v80[8 - 5]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[469 - (143 + 324)]][v78[v80[7 - 4]]] = v78[v80[1 + 3]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[1106 - (342 + 761)];
											v2286 = 20;
										end
										if (v2286 == (8 + 3)) then
											v80 = v68[v72];
											v78[v80[5 - 3]][v78[v80[2 + 1]]] = v78[v80[5 - 1]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[1160 - (889 + 268)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[7 - 4]];
											v72 = v72 + (298 - (196 + 101));
											v2286 = 21 - 9;
										end
										if ((4610 > 1856) and (16 == v2286)) then
											v78[v80[5 - 3]] = v78[v80[2 + 1]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[6 - 4]] = v80[7 - 4];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[4 - 1];
											v72 = v72 + (1584 - (431 + 1152));
											v80 = v68[v72];
											v2286 = 17;
										end
										if (v2286 == (24 + 4)) then
											v78[v80[2]][v78[v80[347 - (107 + 237)]]] = v78[v80[1804 - (690 + 1110)]];
											break;
										end
										if (v2286 == 24) then
											v80 = v68[v72];
											v78[v80[2]] = v80[4 - 1];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1499 - (1374 + 123)]] = v78[v80[6 - 3]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[3 + 0];
											v72 = v72 + 1 + 0;
											v2286 = 1628 - (454 + 1149);
										end
										if (v2286 == (17 - 8)) then
											v78[v80[4 - 2]][v78[v80[2 + 1]]] = v78[v80[4 + 0]];
											v72 = v72 + (638 - (21 + 616));
											v80 = v68[v72];
											v78[v80[3 - 1]] = v80[1 + 2];
											v72 = v72 + (438 - (125 + 312));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[3 + 0]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2286 = 1118 - (266 + 842);
										end
										if (v2286 == (643 - (395 + 243))) then
											v80 = v68[v72];
											v78[v80[2]] = v80[3 + 0];
											v72 = v72 + (1036 - (383 + 652));
											v80 = v68[v72];
											v78[v80[5 - 3]] = v78[v80[2 + 1]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[646 - (114 + 529)];
											v72 = v72 + 1 + 0;
											v2286 = 4 + 2;
										end
										if (v2286 == (1206 - (352 + 837))) then
											v2287 = v80[8 - 6];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (551 - (465 + 85)), v80[534 - (366 + 165)]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[12 - 8]];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2]] = v80[1 + 2];
											v72 = v72 + (1666 - (521 + 1144));
											v2286 = 35 - 17;
										end
										if (v2286 == (3 + 23)) then
											v72 = v72 + (91 - (5 + 85));
											v80 = v68[v72];
											v78[v80[1695 - (1547 + 146)]] = v80[9 - 6];
											v72 = v72 + (318 - (272 + 45));
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[6 - 3]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[1 + 2];
											v2286 = 11 + 16;
										end
										if ((v2286 == (13 + 2)) or (1278 < 426)) then
											v78[v2287] = v78[v2287](v13(v78, v2287 + 1 + 0, v80[1299 - (997 + 299)]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1289 - (903 + 384)]][v78[v80[1 + 2]]] = v78[v80[2 + 2]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2]] = v80[5 - 2];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v2286 = 16;
										end
										if ((0 + 0) == v2286) then
											v2287 = nil;
											v2287 = v80[2];
											v78[v2287] = v78[v2287](v13(v78, v2287 + 1, v80[3 - 0]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]][v78[v80[592 - (313 + 276)]]] = v78[v80[1 + 3]];
											v72 = v72 + (329 - (168 + 160));
											v80 = v68[v72];
											v78[v80[2]] = v80[1459 - (1452 + 4)];
											v2286 = 1;
										end
										if (v2286 == 14) then
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v78[v80[422 - (338 + 82)]] = v80[576 - (133 + 440)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[1 + 2];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2287 = v80[2 + 0];
											v2286 = 1317 - (422 + 880);
										end
										if ((v2286 == 13) or (2091 < 1573)) then
											v72 = v72 + (1981 - (365 + 1615));
											v80 = v68[v72];
											v78[v80[2 - 0]][v78[v80[1355 - (479 + 873)]]] = v78[v80[4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[8 - 5];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[3]];
											v2286 = 14;
										end
										if (v2286 == (7 + 0)) then
											v72 = v72 + (1503 - (832 + 670));
											v80 = v68[v72];
											v78[v80[6 - 4]] = v80[8 - 5];
											v72 = v72 + (1248 - (707 + 540));
											v80 = v68[v72];
											v78[v80[61 - (18 + 41)]] = v78[v80[3 + 0]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1222 - (554 + 666)]] = v80[503 - (438 + 62)];
											v2286 = 1913 - (1497 + 408);
										end
										if (v2286 == (3 - 0)) then
											v78[v80[2]] = v80[2 + 1];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[643 - (508 + 132)]];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[1210 - (49 + 1158)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2286 = 4 - 0;
										end
										if (v2286 == (1 + 0)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[6 - 3]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1223 - (460 + 761)]] = v80[7 - 4];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[599 - (405 + 191)];
											v2286 = 1672 - (311 + 1359);
										end
										if (23 == v2286) then
											v78[v80[4 - 2]] = v80[3 + 0];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2287 = v80[1 + 1];
											v78[v2287] = v78[v2287](v13(v78, v2287 + 1 + 0, v80[1 + 2]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 - 0]][v78[v80[1 + 2]]] = v78[v80[4]];
											v72 = v72 + (1 - 0);
											v2286 = 24;
										end
										if (v2286 == (4 + 14)) then
											v80 = v68[v72];
											v78[v80[3 - 1]] = v78[v80[3]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[1522 - (1408 + 112)]] = v80[985 - (285 + 697)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[9 - 7]] = v80[1263 - (737 + 523)];
											v72 = v72 + (4 - 3);
											v2286 = 19;
										end
										if ((218 <= 4212) and ((1 + 5) == v2286)) then
											v80 = v68[v72];
											v78[v80[846 - (789 + 55)]] = v80[9 - 6];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2287 = v80[2];
											v78[v2287] = v78[v2287](v13(v78, v2287 + 1 + 0, v80[5 - 2]));
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[4]];
											v2286 = 19 - 12;
										end
										if ((v2286 == (1894 - (1492 + 390))) or (3602 < 3141)) then
											v80 = v68[v72];
											v78[v80[2 - 0]] = v80[996 - (312 + 681)];
											v72 = v72 + (1912 - (1255 + 656));
											v80 = v68[v72];
											v78[v80[1729 - (485 + 1242)]] = v80[1 + 2];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2287 = v80[4 - 2];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (1 - 0), v80[11 - 8]));
											v2286 = 13;
										end
										if ((12 - 8) == v2286) then
											v78[v80[2]] = v80[6 - 3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2287 = v80[961 - (722 + 237)];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (2 - 1), v80[719 - (77 + 639)]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2]][v78[v80[14 - 11]]] = v78[v80[7 - 3]];
											v72 = v72 + (2 - 1);
											v2286 = 14 - 9;
										end
										if (v2286 == 22) then
											v78[v80[2 + 0]] = v80[1 + 2];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[1362 - (888 + 471)]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[1112 - (1034 + 75)];
											v72 = v72 + (1158 - (448 + 709));
											v80 = v68[v72];
											v2286 = 23;
										end
										if ((v2286 == (3 + 22)) or (4227 <= 2634)) then
											v80 = v68[v72];
											v78[v80[6 - 4]] = v80[3];
											v72 = v72 + (1856 - (1643 + 212));
											v80 = v68[v72];
											v2287 = v80[2];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (481 - (320 + 160)), v80[6 - 3]));
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[1 + 1]][v78[v80[4 - 1]]] = v78[v80[4]];
											v2286 = 162 - (114 + 22);
										end
										if (v2286 == (1 + 20)) then
											v72 = v72 + (1060 - (89 + 970));
											v80 = v68[v72];
											v2287 = v80[1730 - (1083 + 645)];
											v78[v2287] = v78[v2287](v13(v78, v2287 + 1, v80[169 - (50 + 116)]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1964 - (1058 + 904)]][v78[v80[6 - 3]]] = v78[v80[15 - 11]];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v2286 = 64 - 42;
										end
										if ((5 + 15) == v2286) then
											v72 = v72 + (197 - (94 + 102));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[1267 - (735 + 529)]];
											v72 = v72 + (1152 - (875 + 276));
											v80 = v68[v72];
											v78[v80[981 - (461 + 518)]] = v80[3 + 0];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[783 - (656 + 125)]] = v80[7 - 4];
											v2286 = 869 - (532 + 316);
										end
										if (v2286 == (281 - (150 + 104))) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[1850 - (564 + 1283)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2287 = v80[2 + 0];
											v78[v2287] = v78[v2287](v13(v78, v2287 + (2 - 1), v80[2 + 1]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2286 = 103 - 75;
										end
									end
								end
							elseif (v81 > (1674 - (330 + 1218))) then
								local v2288;
								v78[v80[2]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3 + 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2288 = v80[2];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (1 - 0), v80[2 + 1]));
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[1573 - (511 + 1058)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[1501 - (1315 + 183)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[544 - (233 + 309)]] = v78[v80[3 - 0]];
								v72 = v72 + (654 - (267 + 386));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[856 - (744 + 109)];
								v72 = v72 + (1551 - (1271 + 279));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[1647 - (642 + 1002)];
								v72 = v72 + (1864 - (643 + 1220));
								v80 = v68[v72];
								v2288 = v80[5 - 3];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (1 - 0), v80[1420 - (1063 + 354)]));
								v72 = v72 + (831 - (739 + 91));
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3]]] = v78[v80[6 - 2]];
								v72 = v72 + (1878 - (790 + 1087));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[7 - 4];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[10 - 7]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[3];
								v72 = v72 + (150 - (82 + 67));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[5 - 2];
								v72 = v72 + (1986 - (1835 + 150));
								v80 = v68[v72];
								v2288 = v80[16 - (12 + 2)];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (1037 - (784 + 252)), v80[2 + 1]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[1388 - (1134 + 250)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[5 - 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[6 - 3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1983 - (1940 + 41)]] = v80[241 - (39 + 199)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2288 = v80[3 - 1];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (1 - 0), v80[1932 - (313 + 1616)]));
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3 - 0]]] = v78[v80[8 - 4]];
								v72 = v72 + (38 - (7 + 30));
								v80 = v68[v72];
								v78[v80[1188 - (961 + 225)]] = v80[12 - 9];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[842 - (281 + 559)]] = v78[v80[8 - 5]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1442 - (102 + 1338)]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2288 = v80[1 + 1];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (442 - (319 + 122)), v80[1 + 2]));
								v72 = v72 + (997 - (45 + 951));
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[1 + 2]]] = v78[v80[2 + 2]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1378 - (684 + 691)]];
								v72 = v72 + (1645 - (1161 + 483));
								v80 = v68[v72];
								v78[v80[968 - (245 + 721)]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[45 - (31 + 11)];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v2288 = v80[2];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (3 - 2), v80[839 - (179 + 657)]));
								v72 = v72 + (328 - (150 + 177));
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4]];
								v72 = v72 + (1206 - (142 + 1063));
								v80 = v68[v72];
								v78[v80[1907 - (1346 + 559)]] = v80[1 + 2];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[7 - 5]] = v78[v80[3 + 0]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (1727 - (1695 + 31));
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + (1438 - (1073 + 364));
								v80 = v68[v72];
								v2288 = v80[819 - (405 + 412)];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (650 - (518 + 131)), v80[1305 - (667 + 635)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]][v78[v80[1913 - (1397 + 513)]]] = v78[v80[4]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1077 - (454 + 621)]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1 + 2]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[600 - (417 + 181)]] = v80[4 - 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[14 - 11];
								v72 = v72 + (1121 - (995 + 125));
								v80 = v68[v72];
								v2288 = v80[4 - 2];
								v78[v2288] = v78[v2288](v13(v78, v2288 + 1 + 0, v80[7 - 4]));
								v72 = v72 + (1326 - (754 + 571));
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[8 - 5]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[11 - 8]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1493 - (1141 + 350)]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[1 + 2];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2288 = v80[2 + 0];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (1870 - (513 + 1356)), v80[1939 - (196 + 1740)]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[7 - 3]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[1634 - (362 + 1269)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2288 = v80[2];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (2 - 1), v80[40 - (26 + 11)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[1822 - (183 + 1636)]]] = v78[v80[3 + 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1232 - (1161 + 69)]] = v80[1381 - (672 + 706)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[107 - (82 + 23)]] = v78[v80[1524 - (100 + 1421)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[782 - (61 + 719)]] = v80[415 - (180 + 232)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[4 - 1];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2288 = v80[1783 - (728 + 1053)];
								v78[v2288] = v78[v2288](v13(v78, v2288 + 1 + 0, v80[562 - (427 + 132)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[967 - (786 + 179)]][v78[v80[1 + 2]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3 + 0];
								v72 = v72 + (1925 - (1685 + 239));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[6 - 3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[8 - 5];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1180 - (457 + 720)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2288 = v80[6 - 4];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (722 - (124 + 597)), v80[14 - 11]));
								v72 = v72 + (565 - (414 + 150));
								v80 = v68[v72];
								v78[v80[9 - 7]][v78[v80[3]]] = v78[v80[4]];
								v72 = v72 + (830 - (592 + 237));
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[615 - (122 + 491)]] = v78[v80[13 - 10]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (286 - (116 + 169));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[3 + 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2288 = v80[2 - 0];
								v78[v2288] = v78[v2288](v13(v78, v2288 + (1 - 0), v80[3]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1232 - (477 + 753)]][v78[v80[1 + 2]]] = v78[v80[4 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[9 - 6];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1379 - (649 + 728)]] = v78[v80[915 - (478 + 434)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[14 - 11];
							else
								local v2379;
								local v2380;
								local v2381;
								v78[v80[2 + 0]] = v80[1563 - (1329 + 231)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[1913 - (1523 + 387)]][v78[v80[6 - 2]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1309 - (1013 + 294)]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (1349 - (25 + 1323));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[1933 - (611 + 1319)]][v78[v80[4 + 0]]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2381 = v80[2 + 0];
								v2380 = v78[v2381];
								v2379 = v80[1 + 2];
								for v4003 = 1 + 0, v2379 do
									v2380[v4003] = v78[v2381 + v4003];
								end
							end
						elseif (v81 <= (269 - 139)) then
							if (v81 <= 128) then
								local v649 = 0 + 0;
								local v650;
								local v651;
								local v652;
								while true do
									if ((v649 == 1) or (4519 <= 4409)) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[818 - (353 + 463)]] = v78[v80[5 - 2]][v78[v80[3 + 1]]];
										v72 = v72 + 1;
										v649 = 1063 - (605 + 456);
									end
									if (v649 == (8 - 5)) then
										v78[v80[786 - (122 + 662)]] = v80[3];
										v72 = v72 + (1493 - (1184 + 308));
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3]][v78[v80[4]]];
										v649 = 4;
									end
									if (v649 == 5) then
										v650 = v80[3];
										for v4755 = 1169 - (445 + 723), v650 do
											v651[v4755] = v78[v652 + v4755];
										end
										break;
									end
									if (v649 == 2) then
										v80 = v68[v72];
										v78[v80[1642 - (1245 + 395)]] = {};
										v72 = v72 + (1128 - (191 + 936));
										v80 = v68[v72];
										v649 = 6 - 3;
									end
									if (v649 == (0 - 0)) then
										v650 = nil;
										v651 = nil;
										v652 = nil;
										v78[v80[1 + 1]] = v80[261 - (90 + 168)];
										v649 = 172 - (87 + 84);
									end
									if (v649 == (8 - 4)) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v652 = v80[2];
										v651 = v78[v652];
										v649 = 717 - (176 + 536);
									end
								end
							elseif (v81 == (96 + 33)) then
								local v2394 = 0;
								local v2395;
								local v2396;
								local v2397;
								while true do
									if (v2394 == (1698 - (858 + 840))) then
										v2395 = nil;
										v2396 = nil;
										v2397 = nil;
										v2394 = 1;
									end
									if (v2394 == (665 - (447 + 213))) then
										v78[v80[1462 - (1458 + 2)]] = v80[14 - 11];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2394 = 10 - 4;
									end
									if ((3 + 1) == v2394) then
										v78[v80[1 + 1]] = {};
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v2394 = 485 - (248 + 232);
									end
									if (v2394 == 6) then
										v78[v80[2]] = v78[v80[3]][v78[v80[234 - (109 + 121)]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2394 = 1 + 6;
									end
									if ((4514 >= 1479) and (v2394 == 2)) then
										v78[v80[1406 - (1288 + 116)]] = v80[3 + 0];
										v72 = v72 + (237 - (212 + 24));
										v80 = v68[v72];
										v2394 = 2 + 1;
									end
									if ((v2394 == (5 + 2)) or (3414 <= 210)) then
										v2397 = v80[1709 - (1175 + 532)];
										v2396 = v78[v2397];
										v2395 = v80[3 + 0];
										v2394 = 11 - 3;
									end
									if ((v2394 == (1 + 0)) or (349 <= 242)) then
										v78[v80[2]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v2394 = 2 + 0;
									end
									if (v2394 == (577 - (252 + 317))) then
										for v6876 = 1 - 0, v2395 do
											v2396[v6876] = v78[v2397 + v6876];
										end
										break;
									end
									if ((2209 >= 1935) and (v2394 == (806 - (738 + 65)))) then
										v78[v80[559 - (410 + 147)]] = v78[v80[903 - (272 + 628)]][v78[v80[9 - 5]]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2394 = 10 - 6;
									end
								end
							else
								local v2398;
								local v2399;
								local v2400;
								v78[v80[170 - (62 + 106)]] = v80[8 - 5];
								v72 = v72 + (695 - (167 + 527));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[4 - 1]][v78[v80[6 - 2]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + (1067 - (326 + 740));
								v80 = v68[v72];
								v78[v80[78 - (68 + 8)]] = v80[1474 - (133 + 1338)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[2 + 1]][v78[v80[4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2400 = v80[1 + 1];
								v2399 = v78[v2400];
								v2398 = v80[3];
								for v4022 = 1, v2398 do
									v2399[v4022] = v78[v2400 + v4022];
								end
							end
						elseif (v81 <= 132) then
							if (v81 > (456 - 325)) then
								local v2413 = v80[1 + 1];
								local v2414 = v78[v2413];
								for v4025 = v2413 + 1 + 0, v80[3] do
									v7(v2414, v78[v4025]);
								end
							else
								local v2415;
								local v2416, v2417;
								local v2418;
								v78[v80[5 - 3]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1989 - (1930 + 57)]] = v60[v80[1 + 2]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v60[v80[907 - (14 + 890)]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v60[v80[6 - 3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[9 - 7]] = v60[v80[9 - 6]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[8 - 6]] = v78[v80[3 + 0]];
								v72 = v72 + (1782 - (755 + 1026));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[9 - 7]] = v78[v80[3]] + v80[950 - (217 + 729)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2418 = v80[1 + 1];
								v2416, v2417 = v71(v78[v2418](v13(v78, v2418 + (1 - 0), v80[8 - 5])));
								v73 = (v2417 + v2418) - (1 + 0);
								v2415 = 0 - 0;
								for v4026 = v2418, v73 do
									local v4027 = 1680 - (619 + 1061);
									while true do
										if ((v4027 == (0 + 0)) or (1369 == 4914)) then
											v2415 = v2415 + (1 - 0);
											v78[v4026] = v2416[v2415];
											break;
										end
									end
								end
								v72 = v72 + (137 - (108 + 28));
								v80 = v68[v72];
								v2418 = v80[2];
								v78[v2418] = v78[v2418](v13(v78, v2418 + (1928 - (191 + 1736)), v73));
								v72 = v72 + (764 - (757 + 6));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v60[v80[1258 - (337 + 918)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v60[v80[1 + 2]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1679 - (754 + 922)]];
								v72 = v72 + (635 - (487 + 147));
								v80 = v68[v72];
								v78[v80[2]] = #v78[v80[3 - 0]];
								v72 = v72 + (1570 - (825 + 744));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[3 + 0]] % v78[v80[4]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[252 - (150 + 99)] + v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = #v78[v80[1506 - (1335 + 168)]];
								v72 = v72 + (940 - (256 + 683));
								v80 = v68[v72];
								v78[v80[320 - (33 + 285)]] = v78[v80[9 - 6]] % v78[v80[7 - 3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0] + v78[v80[951 - (776 + 171)]];
								v72 = v72 + (264 - (244 + 19));
								v80 = v68[v72];
								v78[v80[2 - 0]] = v78[v80[3]] + v80[410 - (8 + 398)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2418 = v80[518 - (228 + 288)];
								v2416, v2417 = v71(v78[v2418](v13(v78, v2418 + (1 - 0), v80[5 - 2])));
								v73 = (v2417 + v2418) - 1;
								v2415 = 0 + 0;
								for v4028 = v2418, v73 do
									v2415 = v2415 + (589 - (434 + 154));
									v78[v4028] = v2416[v2415];
								end
								v72 = v72 + 1;
								v80 = v68[v72];
								v2418 = v80[2 + 0];
								v2416, v2417 = v71(v78[v2418](v13(v78, v2418 + (2 - 1), v73)));
								v73 = (v2417 + v2418) - (3 - 2);
								v2415 = 0 - 0;
								for v4031 = v2418, v73 do
									v2415 = v2415 + 1 + 0;
									v78[v4031] = v2416[v2415];
								end
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2418 = v80[2];
								v78[v2418] = v78[v2418](v13(v78, v2418 + 1 + 0, v73));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1 + 2]] % v80[3 + 1];
								v72 = v72 + (1666 - (810 + 855));
								v80 = v68[v72];
								v2418 = v80[2];
								v2416, v2417 = v71(v78[v2418](v78[v2418 + 1 + 0]));
								v73 = (v2417 + v2418) - 1;
								v2415 = 0 + 0;
								for v4034 = v2418, v73 do
									v2415 = v2415 + 1 + 0;
									v78[v4034] = v2416[v2415];
								end
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2418 = v80[5 - 3];
								v78[v2418](v13(v78, v2418 + (1615 - (463 + 1151)), v73));
							end
						elseif (v81 == (128 + 5)) then
							local v2443;
							local v2444;
							local v2445;
							v78[v80[1977 - (29 + 1946)]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[518 - (337 + 178)]][v78[v80[68 - (4 + 60)]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[7 - 5]] = {};
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1118 - (425 + 691)]] = v80[2001 - (354 + 1644)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[844 - (499 + 342)]][v78[v80[4]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v2445 = v80[162 - (65 + 95)];
							v2444 = v78[v2445];
							v2443 = v80[3 + 0];
							for v4037 = 1640 - (1403 + 236), v2443 do
								v2444[v4037] = v78[v2445 + v4037];
							end
						else
							local v2459;
							local v2460;
							local v2461;
							v78[v80[1362 - (1117 + 243)]] = v80[245 - (67 + 175)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v78[v80[3]][v78[v80[735 - (387 + 344)]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = {};
							v72 = v72 + (975 - (654 + 320));
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[433 - (276 + 155)]] = v78[v80[8 - 5]][v78[v80[4]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v2461 = v80[2 + 0];
							v2460 = v78[v2461];
							v2459 = v80[777 - (65 + 709)];
							for v4040 = 1 + 0, v2459 do
								v2460[v4040] = v78[v2461 + v4040];
							end
						end
					elseif ((v81 <= (1891 - (884 + 860))) or (3459 >= 4887)) then
						if (v81 <= (201 - 61)) then
							if ((v81 <= (817 - (492 + 188))) or (2964 <= 78)) then
								if (v81 <= (93 + 42)) then
									local v653 = 0 - 0;
									while true do
										if (v653 == (1 + 3)) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[4 - 1];
											v72 = v72 + (1 - 0);
											v653 = 7 - 2;
										end
										if (((1 + 4) == v653) or (730 == 3621)) then
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[1 + 2]][v78[v80[4]]];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v653 = 1 + 5;
										end
										if ((301 < 4219) and (v653 == (2 + 0))) then
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[2 + 1];
											v72 = v72 + 1;
											v80 = v68[v72];
											v653 = 1 + 2;
										end
										if ((8 - 2) == v653) then
											v78[v80[2]] = {};
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[7 - 5]] = v80[4 - 1];
											break;
										end
										if ((5 - 2) == v653) then
											v78[v80[1253 - (1190 + 61)]][v78[v80[2 + 1]]] = v78[v80[4]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1695 - (1448 + 245)]][v78[v80[3]]] = v78[v80[4]];
											v653 = 5 - 1;
										end
										if ((v653 == (2 - 1)) or (1855 > 2408)) then
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[4 - 2]] = v78[v80[4 - 1]][v78[v80[827 - (528 + 295)]]];
											v72 = v72 + (1 - 0);
											v653 = 1349 - (1224 + 123);
										end
										if (v653 == (0 + 0)) then
											v78[v80[639 - (97 + 540)]][v78[v80[3]]] = v78[v80[1972 - (484 + 1484)]];
											v72 = v72 + (1553 - (1398 + 154));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[3];
											v653 = 1;
										end
									end
								elseif (v81 == 136) then
									local v2474;
									local v2475;
									local v2476;
									v78[v80[4 - 2]] = {};
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v80[533 - (354 + 176)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3]][v78[v80[5 - 1]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = {};
									v72 = v72 + (1431 - (649 + 781));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[5 - 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[779 - (126 + 651)]] = v78[v80[3]][v78[v80[8 - 4]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v2476 = v80[1 + 1];
									v2475 = v78[v2476];
									v2474 = v80[3];
									for v4068 = 1 + 0, v2474 do
										v2475[v4068] = v78[v2476 + v4068];
									end
								else
									local v2490;
									local v2491;
									local v2492;
									v78[v80[4 - 2]] = {};
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1031 - (179 + 850)]] = v78[v80[3]][v78[v80[788 - (34 + 750)]]];
									v72 = v72 + (306 - (302 + 3));
									v80 = v68[v72];
									v78[v80[2]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[1 + 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[4 - 1]][v78[v80[6 - 2]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v2492 = v80[2 - 0];
									v2491 = v78[v2492];
									v2490 = v80[1 + 2];
									for v4071 = 105 - (56 + 48), v2490 do
										v2491[v4071] = v78[v2492 + v4071];
									end
								end
							elseif ((3635 < 4494) and (v81 <= (111 + 27))) then
								v78[v80[2 + 0]][v78[v80[4 - 1]]] = v78[v80[86 - (7 + 75)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[258 - (170 + 85)];
								v72 = v72 + (350 - (288 + 61));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3 + 0]][v78[v80[4]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[6 - 3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[739 - (330 + 407)]][v78[v80[191 - (29 + 159)]]] = v78[v80[7 - 3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[8 - 6]][v78[v80[5 - 2]]] = v78[v80[3 + 1]];
								v72 = v72 + (758 - (15 + 742));
								v80 = v68[v72];
								v78[v80[452 - (414 + 36)]] = v80[1509 - (745 + 761)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[2 + 1]][v78[v80[4]]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
							elseif (v81 > (1218 - (126 + 953))) then
								local v2504;
								local v2505;
								local v2506;
								v78[v80[1702 - (759 + 941)]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1606 - (896 + 708)]] = v80[1 + 2];
								v72 = v72 + (1578 - (555 + 1022));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[144 - (14 + 127)]][v78[v80[1 + 3]]];
								v72 = v72 + (796 - (141 + 654));
								v80 = v68[v72];
								v78[v80[933 - (156 + 775)]] = {};
								v72 = v72 + (1591 - (167 + 1423));
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[8 - 5];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[6 - 3]][v78[v80[3 + 1]]];
								v72 = v72 + (1881 - (1625 + 255));
								v80 = v68[v72];
								v2506 = v80[2];
								v2505 = v78[v2506];
								v2504 = v80[3];
								for v4074 = 1 + 0, v2504 do
									v2505[v4074] = v78[v2506 + v4074];
								end
							elseif not v78[v80[1 + 1]] then
								v72 = v72 + (1517 - (1026 + 490));
							else
								v72 = v80[3];
							end
						elseif (v81 <= 143) then
							if (v81 <= (116 + 25)) then
								local v672 = 1734 - (16 + 1718);
								local v673;
								while true do
									if ((2295 >= 592) and (v672 == (2 + 2))) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[5 - 3]][v80[4 - 1]] = v78[v80[582 - (168 + 410)]];
										break;
									end
									if (v672 == (1 + 1)) then
										v80 = v68[v72];
										v78[v80[8 - 6]] = v80[810 - (134 + 673)];
										v72 = v72 + 1;
										v672 = 3;
									end
									if (v672 == (3 + 0)) then
										v80 = v68[v72];
										v673 = v80[2 - 0];
										v78[v673] = v78[v673](v13(v78, v673 + (1909 - (1174 + 734)), v80[3 - 0]));
										v672 = 4;
									end
									if (v672 == (1 + 0)) then
										v80 = v68[v72];
										v78[v80[3 - 1]] = v80[7 - 4];
										v72 = v72 + (3 - 2);
										v672 = 2;
									end
									if (v672 == (0 + 0)) then
										v673 = nil;
										v78[v80[2 - 0]] = v78[v80[1 + 2]];
										v72 = v72 + (3 - 2);
										v672 = 1 + 0;
									end
								end
							elseif (v81 > 142) then
								local v2520 = 0 - 0;
								local v2521;
								local v2522;
								local v2523;
								while true do
									if ((2728 == 2728) and (v2520 == (5 - 1))) then
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v2523 = v80[1 + 1];
										v2522 = v78[v2523];
										v2520 = 15 - 10;
									end
									if (5 == v2520) then
										v2521 = v80[3 + 0];
										for v6881 = 2 - 1, v2521 do
											v2522[v6881] = v78[v2523 + v6881];
										end
										break;
									end
									if ((v2520 == (515 - (289 + 223))) or (1582 <= 1424)) then
										v78[v80[2]] = v80[4 - 1];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[2 + 1]][v78[v80[4]]];
										v2520 = 644 - (514 + 126);
									end
									if ((v2520 == 2) or (393 >= 2017)) then
										v80 = v68[v72];
										v78[v80[1 + 1]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v2520 = 3 + 0;
									end
									if ((v2520 == 0) or (4350 == 423)) then
										v2521 = nil;
										v2522 = nil;
										v2523 = nil;
										v78[v80[2 - 0]] = v80[2 + 1];
										v2520 = 3 - 2;
									end
									if (v2520 == (1 + 0)) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[1 + 2]][v78[v80[9 - 5]]];
										v72 = v72 + 1;
										v2520 = 2 + 0;
									end
								end
							else
								v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[610 - (4 + 604)]] = v80[9 - 6];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[14 - 10]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[9 - 7]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[11 - 8]]] = v78[v80[1449 - (344 + 1101)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[3 - 1]][v78[v80[3]]] = v78[v80[4 + 0]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[13 - 10];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v78[v80[3 + 0]][v78[v80[305 - (57 + 244)]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[1966 - (883 + 1080)];
							end
						elseif (v81 <= (345 - (138 + 62))) then
							if ((3161 >= 2045) and (v81 == (12 + 132))) then
								local v2542 = 0 - 0;
								local v2543;
								while true do
									if ((3332 > 2568) and (v2542 == (83 - (62 + 21)))) then
										v2543 = v80[2 + 0];
										v78[v2543](v13(v78, v2543 + 1, v73));
										break;
									end
								end
							else
								local v2544;
								v2544 = v80[1451 - (1036 + 413)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1, v80[5 - 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[3]]] = v78[v80[4]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[11 - 8]];
								v72 = v72 + (1473 - (649 + 823));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[3];
								v72 = v72 + (1564 - (1202 + 361));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2544 = v80[1711 - (263 + 1446)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1 + 0, v80[1 + 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[747 - (387 + 356)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v80[10 - 7];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[1719 - (646 + 1070)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2544 = v80[1099 - (288 + 809)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + (1654 - (471 + 1182)), v80[3]));
								v72 = v72 + (1496 - (385 + 1110));
								v80 = v68[v72];
								v78[v80[1611 - (1201 + 408)]][v78[v80[1850 - (747 + 1100)]]] = v78[v80[3 + 1]];
								v72 = v72 + (612 - (269 + 342));
								v80 = v68[v72];
								v78[v80[2]] = v80[3 - 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[349 - (263 + 83)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[824 - (659 + 162)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[217 - (109 + 106)]] = v80[4 - 1];
								v72 = v72 + (1166 - (1157 + 8));
								v80 = v68[v72];
								v2544 = v80[513 - (179 + 332)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + (838 - (705 + 132)), v80[3 + 0]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[10 - 7]]] = v78[v80[4 + 0]];
								v72 = v72 + (44 - (17 + 26));
								v80 = v68[v72];
								v78[v80[2]] = v80[1965 - (1866 + 96)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[8 - 5]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[10 - 7];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[11 - 8];
								v72 = v72 + (1132 - (725 + 406));
								v80 = v68[v72];
								v2544 = v80[4 - 2];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1 + 0, v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[377 - (198 + 177)]][v78[v80[7 - 4]]] = v78[v80[6 - 2]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3 + 0]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[1722 - (1082 + 638)]] = v80[1365 - (1322 + 40)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2544 = v80[1650 - (435 + 1213)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1 + 0, v80[991 - (696 + 292)]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[9 - 7]][v78[v80[3]]] = v78[v80[17 - 13]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[1467 - (731 + 734)]] = v80[3];
								v72 = v72 + (1572 - (1286 + 285));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v78[v80[2 + 1]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v2544 = v80[1263 - (1048 + 213)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + (1 - 0), v80[1 + 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[1360 - (223 + 1134)]]] = v78[v80[19 - 15]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1884 - (982 + 899)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3 - 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[1 + 2];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v2544 = v80[2 - 0];
								v78[v2544] = v78[v2544](v13(v78, v2544 + (1484 - (310 + 1173)), v80[3]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[10 - 7]]] = v78[v80[1455 - (968 + 483)]];
								v72 = v72 + (225 - (37 + 187));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[4 - 1];
								v72 = v72 + (495 - (204 + 290));
								v80 = v68[v72];
								v78[v80[843 - (680 + 161)]] = v78[v80[1 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1070 - (979 + 89)]] = v80[1877 - (802 + 1072)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[9 - 6];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2544 = v80[2];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1, v80[3 + 0]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[6 - 3]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[6 - 3];
								v72 = v72 + (1995 - (1413 + 581));
								v80 = v68[v72];
								v78[v80[1216 - (630 + 584)]] = v78[v80[9 - 6]];
								v72 = v72 + (1129 - (184 + 944));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[956 - (927 + 26)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[642 - (284 + 356)]] = v80[2 + 1];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2544 = v80[2 + 0];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1 + 0, v80[3 + 0]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1130 - (211 + 917)]][v78[v80[3 + 0]]] = v78[v80[1799 - (1151 + 644)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1902 - (745 + 1155)]] = v80[8 - 5];
								v72 = v72 + (315 - (27 + 287));
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2544 = v80[2];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1, v80[4 - 1]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[7 - 4]]] = v78[v80[10 - 6]];
								v72 = v72 + (217 - (148 + 68));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[2 + 1]];
								v72 = v72 + (1175 - (1064 + 110));
								v80 = v68[v72];
								v78[v80[21 - (9 + 10)]] = v80[1 + 2];
								v72 = v72 + (1896 - (1219 + 676));
								v80 = v68[v72];
								v78[v80[1143 - (130 + 1011)]] = v80[1974 - (1639 + 332)];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2544 = v80[1 + 1];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1 + 0, v80[251 - (229 + 19)]));
								v72 = v72 + (124 - (21 + 102));
								v80 = v68[v72];
								v78[v80[2]][v78[v80[1188 - (931 + 254)]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[447 - (428 + 17)]] = v80[8 - 5];
								v72 = v72 + (89 - (26 + 62));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]];
								v72 = v72 + (1081 - (173 + 907));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[2 + 1];
								v72 = v72 + (132 - (71 + 60));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + (1229 - (774 + 454));
								v80 = v68[v72];
								v2544 = v80[1604 - (849 + 753)];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1, v80[7 - 4]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]][v78[v80[3]]] = v78[v80[1220 - (861 + 355)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[1 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[6 - 3];
								v72 = v72 + (1144 - (455 + 688));
								v80 = v68[v72];
								v78[v80[1346 - (481 + 863)]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2544 = v80[5 - 3];
								v78[v2544] = v78[v2544](v13(v78, v2544 + 1, v80[1971 - (896 + 1072)]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4]];
							end
						elseif (v81 > (351 - 205)) then
							local v2633;
							v78[v80[790 - (50 + 738)]] = v78[v80[3 + 0]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[1556 - (1128 + 425)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[459 - (398 + 58)];
							v72 = v72 + (713 - (194 + 518));
							v80 = v68[v72];
							v2633 = v80[2];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1, v80[378 - (42 + 333)]));
							v72 = v72 + (1445 - (1308 + 136));
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[123 - (56 + 64)]]] = v78[v80[4]];
							v72 = v72 + (697 - (251 + 445));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[1572 - (999 + 570)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[6 - 3];
							v72 = v72 + (1700 - (1476 + 223));
							v80 = v68[v72];
							v78[v80[1838 - (597 + 1239)]] = v80[3];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v2633 = v80[2 + 0];
							v78[v2633] = v78[v2633](v13(v78, v2633 + (885 - (590 + 294)), v80[6 - 3]));
							v72 = v72 + (790 - (433 + 356));
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[4 - 1]]] = v78[v80[1260 - (791 + 465)]];
							v72 = v72 + (1115 - (1048 + 66));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[12 - 9];
							v72 = v72 + (1998 - (666 + 1331));
							v80 = v68[v72];
							v78[v80[1902 - (854 + 1046)]] = v78[v80[8 - 5]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[7 - 4];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[99 - (61 + 35)];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v2633 = v80[1 + 1];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1, v80[1821 - (1591 + 227)]));
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[793 - (173 + 618)]][v78[v80[3]]] = v78[v80[1327 - (588 + 735)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[582 - (170 + 410)]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3 + 0];
							v72 = v72 + (553 - (362 + 190));
							v80 = v68[v72];
							v78[v80[850 - (529 + 319)]] = v80[2 + 1];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v2633 = v80[2 + 0];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1, v80[3 + 0]));
							v72 = v72 + (1201 - (829 + 371));
							v80 = v68[v72];
							v78[v80[3 - 1]][v78[v80[2 + 1]]] = v78[v80[1680 - (700 + 976)]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1643 - (1137 + 504)]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[10 - 7];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v2633 = v80[1 + 1];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1 + 0, v80[1617 - (327 + 1287)]));
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[2 + 1]]] = v78[v80[4]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1115 - (224 + 889)]] = v80[1223 - (574 + 646)];
							v72 = v72 + (608 - (83 + 524));
							v80 = v68[v72];
							v78[v80[770 - (577 + 191)]] = v78[v80[3 + 0]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[801 - (248 + 551)]] = v80[80 - (53 + 24)];
							v72 = v72 + (134 - (12 + 121));
							v80 = v68[v72];
							v78[v80[2]] = v80[8 - 5];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v2633 = v80[608 - (164 + 442)];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1 + 0, v80[2 + 1]));
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[4 - 2]][v78[v80[3]]] = v78[v80[4]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[6 - 3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1249 - (585 + 662)]] = v78[v80[3 + 0]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[582 - (126 + 454)]] = v80[417 - (366 + 48)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[1686 - (1633 + 50)];
							v72 = v72 + (1102 - (892 + 209));
							v80 = v68[v72];
							v2633 = v80[2 + 0];
							v78[v2633] = v78[v2633](v13(v78, v2633 + (2 - 1), v80[5 - 2]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[662 - (495 + 165)]][v78[v80[3]]] = v78[v80[11 - 7]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v78[v80[2 + 1]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[584 - (431 + 151)]] = v80[3 - 0];
							v72 = v72 + (16 - (10 + 5));
							v80 = v68[v72];
							v78[v80[424 - (403 + 19)]] = v80[1774 - (454 + 1317)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v2633 = v80[1816 - (187 + 1627)];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1 + 0, v80[3]));
							v72 = v72 + (1953 - (832 + 1120));
							v80 = v68[v72];
							v78[v80[5 - 3]][v78[v80[1 + 2]]] = v78[v80[1100 - (1001 + 95)]];
							v72 = v72 + (30 - (4 + 25));
							v80 = v68[v72];
							v78[v80[2]] = v80[1164 - (904 + 257)];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[3]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[8 - 6]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v2633 = v80[2];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1 + 0, v80[4 - 1]));
							v72 = v72 + (1790 - (735 + 1054));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[1696 - (418 + 1275)]]] = v78[v80[3 + 1]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[1475 - (784 + 688)];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[3]];
							v72 = v72 + (1250 - (374 + 875));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3];
							v72 = v72 + (981 - (304 + 676));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1361 - (517 + 841)];
							v72 = v72 + (867 - (356 + 510));
							v80 = v68[v72];
							v2633 = v80[3 - 1];
							v78[v2633] = v78[v2633](v13(v78, v2633 + (2 - 1), v80[1212 - (306 + 903)]));
							v72 = v72 + (1104 - (70 + 1033));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[12 - 9]]] = v78[v80[4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[807 - (523 + 281)];
							v72 = v72 + (923 - (241 + 681));
							v80 = v68[v72];
							v78[v80[1100 - (358 + 740)]] = v80[3 + 0];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v2633 = v80[2];
							v78[v2633] = v78[v2633](v13(v78, v2633 + (1042 - (1005 + 36)), v80[1 + 2]));
							v72 = v72 + (703 - (533 + 169));
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[2 + 1]]] = v78[v80[1 + 3]];
							v72 = v72 + (1526 - (817 + 708));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3 + 0];
							v72 = v72 + (1699 - (636 + 1062));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[1661 - (1130 + 528)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[6 - 4]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v2633 = v80[145 - (115 + 28)];
							v78[v2633] = v78[v2633](v13(v78, v2633 + 1, v80[2 + 1]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1383 - (1076 + 305)]][v78[v80[1772 - (1198 + 571)]]] = v78[v80[1521 - (629 + 888)]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[4 - 1];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[3]];
							v72 = v72 + (170 - (113 + 56));
							v80 = v68[v72];
							v78[v80[1255 - (521 + 732)]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[1541 - (99 + 1439)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v2633 = v80[6 - 4];
							v78[v2633] = v78[v2633](v13(v78, v2633 + (3 - 2), v80[411 - (39 + 369)]));
							v72 = v72 + (1960 - (870 + 1089));
							v80 = v68[v72];
							v78[v80[797 - (564 + 231)]][v78[v80[1924 - (1893 + 28)]]] = v78[v80[4 + 0]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[528 - (140 + 386)]] = v80[2 + 1];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[2 + 1]];
							v72 = v72 + (1917 - (485 + 1431));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[4 - 1];
						else
							local v2722 = 0;
							local v2723;
							local v2724;
							local v2725;
							while true do
								if (v2722 == (1 + 1)) then
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v2722 = 11 - 8;
								end
								if (v2722 == (2 + 5)) then
									v2725 = v80[1183 - (945 + 236)];
									v2724 = v78[v2725];
									v2723 = v80[3];
									v2722 = 19 - 11;
								end
								if (3 == v2722) then
									v78[v80[1 + 1]] = v78[v80[6 - 3]][v78[v80[9 - 5]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v2722 = 517 - (383 + 130);
								end
								if (v2722 == 1) then
									v78[v80[905 - (643 + 260)]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v2722 = 1449 - (109 + 1338);
								end
								if ((v2722 == (2 + 3)) or (2573 <= 2291)) then
									v78[v80[2]] = v80[13 - 10];
									v72 = v72 + (745 - (338 + 406));
									v80 = v68[v72];
									v2722 = 6;
								end
								if ((1667 <= 1727) and (v2722 == (11 - 7))) then
									v78[v80[477 - (20 + 455)]] = {};
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v2722 = 5;
								end
								if ((3642 >= 2739) and (v2722 == (10 - 2))) then
									for v6884 = 76 - (39 + 36), v2723 do
										v2724[v6884] = v78[v2725 + v6884];
									end
									break;
								end
								if (v2722 == (0 + 0)) then
									v2723 = nil;
									v2724 = nil;
									v2725 = nil;
									v2722 = 1 + 0;
								end
								if (((1712 - (609 + 1097)) == v2722) or (4686 == 3242)) then
									v78[v80[660 - (543 + 115)]] = v78[v80[2 + 1]][v78[v80[8 - 4]]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v2722 = 19 - 12;
								end
							end
						end
					elseif ((v81 <= 154) or (1872 > 4054)) then
						if (v81 <= 150) then
							if ((v81 <= (1756 - (1559 + 49))) or (1292 >= 4566)) then
								for v933 = v80[2], v80[625 - (317 + 305)] do
									v78[v933] = nil;
								end
							elseif (v81 > (400 - 251)) then
								local v2726;
								v2726 = v80[2];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (4 - 3), v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[829 - (509 + 318)]][v78[v80[1820 - (384 + 1433)]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[13 - 10]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1536 - (198 + 1336)]] = v80[1 + 2];
								v72 = v72 + (1406 - (1149 + 256));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2726 = v80[2 - 0];
								v78[v2726] = v78[v2726](v13(v78, v2726 + 1, v80[1769 - (1280 + 486)]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 - 0]][v78[v80[3 + 0]]] = v78[v80[1612 - (786 + 822)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1462 - (1303 + 157)]] = v78[v80[2 + 1]];
								v72 = v72 + (1416 - (505 + 910));
								v80 = v68[v72];
								v78[v80[2]] = v80[8 - 5];
								v72 = v72 + (869 - (548 + 320));
								v80 = v68[v72];
								v78[v80[2]] = v80[594 - (52 + 539)];
								v72 = v72 + (556 - (378 + 177));
								v80 = v68[v72];
								v2726 = v80[5 - 3];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (2 - 1), v80[2 + 1]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[209 - (108 + 99)]][v78[v80[2 + 1]]] = v78[v80[5 - 1]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[5 - 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[2 + 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2726 = v80[1 + 1];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (1 - 0), v80[2 + 1]));
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[843 - (823 + 16)]];
								v72 = v72 + (279 - (19 + 259));
								v80 = v68[v72];
								v78[v80[2]] = v80[1823 - (1780 + 40)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[4 - 1]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[5 - 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[8 - 6]] = v80[1 + 2];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v2726 = v80[2];
								v78[v2726] = v78[v2726](v13(v78, v2726 + 1 + 0, v80[7 - 4]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[1 + 2]]] = v78[v80[4]];
								v72 = v72 + (1181 - (825 + 355));
								v80 = v68[v72];
								v78[v80[862 - (846 + 14)]] = v80[3 + 0];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[372 - (237 + 133)]] = v78[v80[1189 - (624 + 562)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3 + 0];
								v72 = v72 + (803 - (700 + 102));
								v80 = v68[v72];
								v78[v80[2]] = v80[9 - 6];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2726 = v80[5 - 3];
								v78[v2726] = v78[v2726](v13(v78, v2726 + 1 + 0, v80[3 - 0]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[1279 - (735 + 541)]]] = v78[v80[844 - (497 + 343)]];
								v72 = v72 + (1784 - (995 + 788));
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[1 + 2];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[3]];
								v72 = v72 + (199 - (37 + 161));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2726 = v80[2];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (2 - 1), v80[3]));
								v72 = v72 + (1273 - (357 + 915));
								v80 = v68[v72];
								v78[v80[677 - (50 + 625)]][v78[v80[1883 - (1624 + 256)]]] = v78[v80[8 - 4]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1525 - (180 + 1343)]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1345 - (1057 + 285)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[1406 - (135 + 1268)];
								v72 = v72 + (1422 - (1088 + 333));
								v80 = v68[v72];
								v78[v80[1684 - (1280 + 402)]] = v80[4 - 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2726 = v80[1 + 1];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (3 - 2), v80[1 + 2]));
								v72 = v72 + (18 - (11 + 6));
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[8 - 4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[1739 - (1015 + 721)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[244 - (169 + 73)]] = v78[v80[3]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1898 - (1052 + 844)]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[19 - (5 + 11)];
								v72 = v72 + (1516 - (210 + 1305));
								v80 = v68[v72];
								v2726 = v80[1 + 1];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (1 - 0), v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[749 - (646 + 101)]][v78[v80[3]]] = v78[v80[380 - (12 + 364)]];
								v72 = v72 + (716 - (587 + 128));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[6 - 3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[229 - (196 + 31)]] = v78[v80[3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[539 - (227 + 310)]] = v80[3 + 0];
								v72 = v72 + (774 - (689 + 84));
								v80 = v68[v72];
								v78[v80[2]] = v80[1378 - (404 + 971)];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v2726 = v80[1 + 1];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (1398 - (764 + 633)), v80[3 + 0]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[208 - (114 + 92)]][v78[v80[2 + 1]]] = v78[v80[533 - (4 + 525)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1315 - (636 + 677)]] = v78[v80[9 - 6]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1356 - (447 + 907)]] = v80[1801 - (303 + 1495)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2726 = v80[1818 - (1446 + 370)];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (552 - (245 + 306)), v80[2 + 1]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[10 - 7]]] = v78[v80[2 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1476 - (536 + 937)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[154 - (143 + 9)]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[1077 - (474 + 600)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[9 - 6];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2726 = v80[5 - 3];
								v78[v2726] = v78[v2726](v13(v78, v2726 + 1 + 0, v80[3 - 0]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1490 - (49 + 1439)]][v78[v80[1 + 2]]] = v78[v80[15 - 11]];
								v72 = v72 + (1991 - (769 + 1221));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1075 - (270 + 802)];
								v72 = v72 + (1857 - (301 + 1555));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1 + 2]];
								v72 = v72 + (76 - (22 + 53));
								v80 = v68[v72];
								v78[v80[2]] = v80[2 + 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[9 - 7]] = v80[6 - 3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2726 = v80[2];
								v78[v2726] = v78[v2726](v13(v78, v2726 + 1 + 0, v80[7 - 4]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[1 + 3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[95 - (41 + 51)];
								v72 = v72 + (604 - (391 + 212));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[5 - 2];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2726 = v80[1 + 1];
								v78[v2726] = v78[v2726](v13(v78, v2726 + (3 - 2), v80[2 + 1]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]][v78[v80[3 + 0]]] = v78[v80[380 - (155 + 221)]];
							else
								local v2811;
								local v2812;
								local v2813;
								v78[v80[1 + 1]] = {};
								v72 = v72 + (1458 - (366 + 1091));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[289 - (90 + 196)];
								v72 = v72 + (1775 - (1710 + 64));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[14 - 11]][v78[v80[6 - 2]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3 - 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[270 - (72 + 195)]][v78[v80[3 + 1]]];
								v72 = v72 + (1179 - (28 + 1150));
								v80 = v68[v72];
								v2813 = v80[1 + 1];
								v2812 = v78[v2813];
								v2811 = v80[601 - (102 + 496)];
								for v4091 = 1, v2811 do
									v2812[v4091] = v78[v2813 + v4091];
								end
							end
						elseif (v81 <= 152) then
							if (v81 == 151) then
								v78[v80[2]] = v78[v80[3]] + v80[4];
							else
								local v2828 = 444 - (181 + 263);
								local v2829;
								while true do
									if ((3766 <= 4403) and ((3 + 1) == v2828)) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v2829 = v80[1 + 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1, v80[10 - 7]));
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]][v80[3]] = v78[v80[1512 - (822 + 686)]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[5 - 3]] = v78[v80[7 - 4]];
										v2828 = 3 + 2;
									end
									if ((v2828 == 2) or (4787 <= 3756)) then
										v78[v80[4 - 2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[863 - (252 + 609)]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2829 = v80[1 + 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1 + 0, v80[4 - 1]));
										v72 = v72 + (959 - (578 + 380));
										v80 = v68[v72];
										v2828 = 1 + 2;
									end
									if ((525 >= 423) and (v2828 == (1729 - (1431 + 285)))) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[4 - 1];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[7 - 5]] = v80[5 - 2];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v2829 = v80[1114 - (1013 + 99)];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (1 - 0), v80[960 - (449 + 508)]));
										v2828 = 21 - 7;
									end
									if ((v2828 == 1) or (2682 < 1809)) then
										v2829 = v80[1894 - (1562 + 330)];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (1973 - (1870 + 102)), v80[1 + 2]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2 - 0]][v80[5 - 2]] = v78[v80[4]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3 + 0]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2828 = 1 + 1;
									end
									if (v2828 == (1019 - (550 + 444))) then
										v2829 = v80[1 + 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (1 - 0), v80[2 + 1]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]][v80[2 + 1]] = v78[v80[1 + 3]];
										break;
									end
									if (v2828 == 12) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v2829 = v80[2 - 0];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (581 - (544 + 36)), v80[1234 - (70 + 1161)]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[759 - (130 + 627)]][v80[5 - 2]] = v78[v80[4]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[313 - (121 + 190)]] = v78[v80[11 - 8]];
										v2828 = 13 + 0;
									end
									if (v2828 == (87 - 66)) then
										v72 = v72 + (323 - (255 + 67));
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[6 - 3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[280 - (225 + 53)]] = v80[3 - 0];
										v72 = v72 + (1300 - (738 + 561));
										v80 = v68[v72];
										v2829 = v80[6 - 4];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1 + 0, v80[3]));
										v2828 = 19 + 3;
									end
									if (v2828 == 22) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[1613 - (1450 + 161)]][v80[1731 - (183 + 1545)]] = v78[v80[4]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1172 - (736 + 434)]] = v78[v80[3]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[9 - 7]] = v80[3];
										v72 = v72 + (40 - (32 + 7));
										v2828 = 89 - 66;
									end
									if (v2828 == (391 - (103 + 270))) then
										v78[v80[1 + 1]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2829 = v80[2];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1 + 0, v80[1456 - (1021 + 432)]));
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v2828 = 1433 - (153 + 1261);
									end
									if (v2828 == (0 + 0)) then
										v2829 = nil;
										v78[v80[1 + 1]] = v78[v80[891 - (800 + 88)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[5 - 3]] = v80[824 - (358 + 463)];
										v72 = v72 + (259 - (176 + 82));
										v80 = v68[v72];
										v2828 = 1;
									end
									if (v2828 == (60 - 36)) then
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3]];
										v72 = v72 + (771 - (543 + 227));
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[1 + 2];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[11 - 8];
										v72 = v72 + (1787 - (1509 + 277));
										v80 = v68[v72];
										v2828 = 1985 - (1453 + 507);
									end
									if ((4143 > 1460) and (6 == v2828)) then
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[1 + 1]][v80[11 - 8]] = v78[v80[15 - 11]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[3]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1033 - (22 + 1009)]] = v80[14 - 11];
										v72 = v72 + (1941 - (245 + 1695));
										v2828 = 7;
									end
									if ((1050 - (611 + 424)) == v2828) then
										v80 = v68[v72];
										v78[v80[300 - (280 + 18)]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2829 = v80[3 - 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (2 - 1), v80[281 - (109 + 169)]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]][v80[1 + 2]] = v78[v80[2 + 2]];
										v72 = v72 + 1;
										v2828 = 16;
									end
									if ((v2828 == 17) or (2772 < 256)) then
										v2829 = v80[2];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1 + 0, v80[3]));
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[7 - 5]][v80[7 - 4]] = v78[v80[1346 - (875 + 467)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[9 - 7]] = v78[v80[7 - 4]];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v2828 = 817 - (717 + 82);
									end
									if ((v2828 == (1040 - (693 + 327))) or (231 == 3795)) then
										v72 = v72 + (1912 - (746 + 1165));
										v80 = v68[v72];
										v2829 = v80[1737 - (1473 + 262)];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1 + 0, v80[1 + 2]));
										v72 = v72 + (1874 - (874 + 999));
										v80 = v68[v72];
										v78[v80[2]][v80[3]] = v78[v80[11 - 7]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[3]];
										v2828 = 20 + 1;
									end
									if (v2828 == (29 - 18)) then
										v78[v80[2]][v80[3 + 0]] = v78[v80[3 + 1]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[8 - 6]] = v78[v80[4 - 1]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[461 - (388 + 70)];
										v2828 = 12 + 0;
									end
									if (v2828 == (18 + 1)) then
										v78[v80[2 + 0]][v80[3]] = v78[v80[4]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[585 - (319 + 263)]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[11 - 8];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[2 + 1];
										v2828 = 15 + 5;
									end
									if ((4247 >= 417) and (v2828 == (823 - (94 + 720)))) then
										v2829 = v80[380 - (78 + 300)];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (1918 - (774 + 1143)), v80[2 + 1]));
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[193 - (18 + 173)]][v80[7 - 4]] = v78[v80[5 - 1]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[14 - 11]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2828 = 10;
									end
									if ((v2828 == (1492 - (677 + 808))) or (283 >= 937)) then
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2829 = v80[1 + 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (971 - (528 + 442)), v80[3]));
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[349 - (116 + 231)]][v80[3 + 0]] = v78[v80[3 + 1]];
										v72 = v72 + (3 - 2);
										v2828 = 2 + 6;
									end
									if (v2828 == (1475 - (1242 + 228))) then
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + (845 - (320 + 524));
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[7 - 4];
										v72 = v72 + (4 - 3);
										v80 = v68[v72];
										v2829 = v80[1 + 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (2 - 1), v80[478 - (63 + 412)]));
										v2828 = 1870 - (1299 + 565);
									end
									if (8 == v2828) then
										v80 = v68[v72];
										v78[v80[5 - 3]] = v78[v80[1 + 2]];
										v72 = v72 + (4 - 3);
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[2 + 1];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2828 = 9;
									end
									if ((3116 <= 4290) and ((10 - 7) == v2828)) then
										v78[v80[2]][v80[331 - (79 + 249)]] = v78[v80[10 - 6]];
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v78[v80[1633 - (305 + 1325)]];
										v72 = v72 + (1729 - (1585 + 143));
										v80 = v68[v72];
										v78[v80[6 - 4]] = v80[1833 - (1727 + 103)];
										v72 = v72 + (3 - 2);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[2 + 1];
										v2828 = 12 - 8;
									end
									if ((v2828 == (297 - (135 + 139))) or (1679 >= 3504)) then
										v80 = v68[v72];
										v78[v80[2 + 0]] = v80[3];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v2829 = v80[2];
										v78[v2829] = v78[v2829](v13(v78, v2829 + 1 + 0, v80[2 + 1]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]][v80[2 + 1]] = v78[v80[12 - 8]];
										v72 = v72 + (1705 - (1084 + 620));
										v2828 = 1077 - (404 + 649);
									end
									if ((2030 <= 3278) and (v2828 == (828 - (318 + 496)))) then
										v72 = v72 + (1883 - (1730 + 152));
										v80 = v68[v72];
										v78[v80[5 - 3]][v80[10 - 7]] = v78[v80[1865 - (527 + 1334)]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1948 - (464 + 1482)]] = v78[v80[3]];
										v72 = v72 + (2 - 1);
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[572 - (485 + 84)];
										v72 = v72 + 1;
										v2828 = 7 + 8;
									end
									if ((v2828 == (8 + 2)) or (331 > 4148)) then
										v78[v80[1 + 1]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[7 - 4];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2829 = v80[1 + 1];
										v78[v2829] = v78[v2829](v13(v78, v2829 + (2 - 1), v80[1004 - (359 + 642)]));
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v2828 = 5 + 6;
									end
									if (((1360 - (564 + 780)) == v2828) or (1943 >= 2818)) then
										v80 = v68[v72];
										v78[v80[6 - 4]] = v78[v80[1 + 2]];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[2]] = v80[5 - 2];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[4 - 2]] = v80[2 + 1];
										v72 = v72 + 1;
										v80 = v68[v72];
										v2828 = 17;
									end
								end
							end
						elseif (v81 == (1579 - (909 + 517))) then
							local v2830 = v80[461 - (432 + 27)];
							do
								return v13(v78, v2830, v2830 + v80[1739 - (69 + 1667)]);
							end
						else
							v78[v80[1 + 1]] = v80[125 - (16 + 106)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1254 - (1178 + 74)]] = v78[v80[1 + 2]][v78[v80[4]]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]] = {};
							v72 = v72 + (448 - (312 + 135));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[6 - 4]] = v78[v80[7 - 4]][v78[v80[4]]];
							v72 = v72 + (1830 - (492 + 1337));
							v80 = v68[v72];
							v78[v80[1 + 1]] = {};
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1392 - (814 + 576)]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v78[v80[3]][v78[v80[9 - 5]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[1 + 2];
						end
					elseif ((v81 <= 157) or (4736 < 933)) then
						if ((v81 <= (5 + 150)) or (2212 > 3383)) then
							local v674;
							local v675;
							local v676;
							v78[v80[5 - 3]] = {};
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[8 - 5];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1361 - (978 + 381)]] = v78[v80[1 + 2]][v78[v80[4]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = {};
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v78[v80[3 + 0]][v78[v80[9 - 5]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v676 = v80[2 + 0];
							v675 = v78[v676];
							v674 = v80[2 + 1];
							for v935 = 1 + 0, v674 do
								v675[v935] = v78[v676 + v935];
							end
						elseif (v81 == 156) then
							v78[v80[571 - (397 + 172)]][v78[v80[4 - 1]]] = v78[v80[1121 - (267 + 850)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[6 - 4]] = v80[997 - (41 + 953)];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[5 - 2]][v78[v80[4]]];
							v72 = v72 + (821 - (817 + 3));
							v80 = v68[v72];
							v78[v80[1387 - (867 + 518)]] = v80[8 - 5];
							v72 = v72 + (331 - (256 + 74));
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[2 + 2]];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[189 - (111 + 76)]][v78[v80[3 + 0]]] = v78[v80[1055 - (100 + 951)]];
							v72 = v72 + (626 - (369 + 256));
							v80 = v68[v72];
							v78[v80[8 - 6]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[3]][v78[v80[67 - (25 + 38)]]];
							v72 = v72 + (1037 - (890 + 146));
							v80 = v68[v72];
							v78[v80[2]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3 + 0];
						else
							local v2865 = 1584 - (549 + 1035);
							while true do
								if (v2865 == (13 - 7)) then
									v78[v80[1 + 1]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v2865 = 968 - (546 + 415);
								end
								if (v2865 == (1024 - (175 + 849))) then
									v78[v80[2]][v78[v80[1667 - (734 + 930)]]] = v78[v80[1419 - (1093 + 322)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v2865 = 3 - 2;
								end
								if (v2865 == (1310 - (1256 + 45))) then
									v78[v80[1847 - (66 + 1779)]] = v80[1776 - (920 + 853)];
									break;
								end
								if ((v2865 == (61 - (6 + 52))) or (3153 == 1399)) then
									v78[v80[2]] = v80[5 - 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v2865 = 9 - 5;
								end
								if (v2865 == (3 - 2)) then
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v2865 = 89 - (11 + 76);
								end
								if (v2865 == (10 - 6)) then
									v78[v80[824 - (560 + 262)]][v78[v80[3 - 0]]] = v78[v80[1861 - (12 + 1845)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v2865 = 5;
								end
								if ((v2865 == (1324 - (1278 + 39))) or (969 >= 1823)) then
									v78[v80[6 - 4]] = v78[v80[2 + 1]][v78[v80[8 - 4]]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v2865 = 31 - 23;
								end
								if ((335 <= 3087) and (v2865 == 5)) then
									v78[v80[2 + 0]][v78[v80[2 + 1]]] = v78[v80[1540 - (385 + 1151)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v2865 = 1456 - (240 + 1210);
								end
								if (v2865 == (1673 - (816 + 849))) then
									v78[v80[2]] = {};
									v72 = v72 + (1855 - (99 + 1755));
									v80 = v68[v72];
									v2865 = 11 - 2;
								end
								if ((3962 == 3962) and (v2865 == (786 - (424 + 360)))) then
									v78[v80[1376 - (41 + 1333)]] = v78[v80[548 - (161 + 384)]][v78[v80[935 - (355 + 576)]]];
									v72 = v72 + (688 - (348 + 339));
									v80 = v68[v72];
									v2865 = 3;
								end
							end
						end
					elseif (v81 <= (721 - 562)) then
						if (v81 > (775 - 617)) then
							local v2866 = 468 - (285 + 183);
							local v2867;
							local v2868;
							local v2869;
							while true do
								if (0 == v2866) then
									v2867 = nil;
									v2868 = nil;
									v2869 = nil;
									v78[v80[4 - 2]] = v80[3];
									v2866 = 1 + 0;
								end
								if (v2866 == 5) then
									v2867 = v80[1973 - (928 + 1042)];
									for v6887 = 1577 - (545 + 1031), v2867 do
										v2868[v6887] = v78[v2869 + v6887];
									end
									break;
								end
								if (v2866 == (11 - 7)) then
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v2869 = v80[2];
									v2868 = v78[v2869];
									v2866 = 5;
								end
								if ((1473 >= 821) and (v2866 == (1 - 0))) then
									v72 = v72 + (926 - (345 + 580));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[1 + 2]][v78[v80[313 - (136 + 173)]]];
									v72 = v72 + (1904 - (1448 + 455));
									v2866 = 5 - 3;
								end
								if (v2866 == 2) then
									v80 = v68[v72];
									v78[v80[1 + 1]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v2866 = 3;
								end
								if ((2 + 1) == v2866) then
									v78[v80[4 - 2]] = v80[1564 - (1137 + 424)];
									v72 = v72 + (1928 - (372 + 1555));
									v80 = v68[v72];
									v78[v80[383 - (174 + 207)]] = v78[v80[1 + 2]][v78[v80[4]]];
									v2866 = 3 + 1;
								end
							end
						else
							local v2870;
							local v2871;
							local v2872;
							v78[v80[2]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (72 - (65 + 6));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[1314 - (1041 + 270)]][v78[v80[6 - 2]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[6 - 4]] = {};
							v72 = v72 + (1711 - (222 + 1488));
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[1525 - (1023 + 499)]][v78[v80[7 - 3]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v2872 = v80[6 - 4];
							v2871 = v78[v2872];
							v2870 = v80[2 + 1];
							for v4094 = 2 - 1, v2870 do
								v2871[v4094] = v78[v2872 + v4094];
							end
						end
					elseif (v81 == (5 + 155)) then
						local v2884;
						local v2885;
						local v2886;
						v78[v80[2]] = v80[3];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1 + 1]] = v78[v80[810 - (134 + 673)]][v78[v80[4]]];
						v72 = v72 + (1058 - (810 + 247));
						v80 = v68[v72];
						v78[v80[2]] = {};
						v72 = v72 + (1461 - (753 + 707));
						v80 = v68[v72];
						v78[v80[4 - 2]] = v80[6 - 3];
						v72 = v72 + (601 - (462 + 138));
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[3 + 0]][v78[v80[1 + 3]]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v2886 = v80[6 - 4];
						v2885 = v78[v2886];
						v2884 = v80[663 - (642 + 18)];
						for v4097 = 979 - (155 + 823), v2884 do
							v2885[v4097] = v78[v2886 + v4097];
						end
					else
						v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[3 + 1]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]] = v80[2 + 1];
						v72 = v72 + (1454 - (799 + 654));
						v80 = v68[v72];
						v78[v80[3 - 1]] = v78[v80[10 - 7]][v78[v80[4 - 0]]];
						v72 = v72 + (634 - (527 + 106));
						v80 = v68[v72];
						v78[v80[3 - 1]] = v80[4 - 1];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[1 + 3]];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[737 - (589 + 144)]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v80[3 + 0];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[530 - (179 + 349)]] = v78[v80[12 - 9]][v78[v80[10 - 6]]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 + 0]] = {};
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]] = v80[2 + 1];
					end
				elseif (v81 <= (366 - 178)) then
					if (v81 <= (98 + 76)) then
						if (v81 <= (574 - 407)) then
							if (v81 <= 164) then
								if (v81 <= (110 + 52)) then
									local v689 = 0 + 0;
									local v690;
									while true do
										if (v689 == (8 + 18)) then
											v72 = v72 + (487 - (242 + 244));
											v80 = v68[v72];
											v690 = v80[409 - (303 + 104)];
											v78[v690] = v78[v690](v13(v78, v690 + 1, v80[9 - 6]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[645 - (411 + 232)]][v78[v80[3]]] = v78[v80[4 + 0]];
											v72 = v72 + 1 + 0;
											v689 = 79 - 52;
										end
										if ((v689 == (2 - 1)) or (3515 >= 4532)) then
											v78[v80[2]] = v80[3];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[8 - 5]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[484 - (164 + 317)];
											v72 = v72 + (100 - (65 + 34));
											v689 = 2;
										end
										if (v689 == 0) then
											v690 = nil;
											v690 = v80[5 - 3];
											v78[v690] = v78[v690](v13(v78, v690 + 1 + 0, v80[3]));
											v72 = v72 + (319 - (61 + 257));
											v80 = v68[v72];
											v78[v80[1881 - (398 + 1481)]][v78[v80[5 - 2]]] = v78[v80[8 - 4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v689 = 1 - 0;
										end
										if (v689 == (694 - (338 + 348))) then
											v80 = v68[v72];
											v78[v80[2]] = v80[1381 - (401 + 977)];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[3]];
											v72 = v72 + (46 - (17 + 28));
											v80 = v68[v72];
											v78[v80[187 - (27 + 158)]] = v80[8 - 5];
											v689 = 2 + 7;
										end
										if ((v689 == (4 + 9)) or (2750 > 4696)) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[1295 - (372 + 921)]] = v78[v80[3 + 0]];
											v72 = v72 + (484 - (350 + 133));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[2 + 1];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v689 = 1552 - (1432 + 106);
										end
										if ((2861 < 3339) and (v689 == 29)) then
											v80 = v68[v72];
											v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[5 - 1]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[1449 - (1075 + 371)];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[4 - 2]] = v78[v80[1 + 2]];
											v689 = 30;
										end
										if (v689 == (86 - 62)) then
											v78[v690] = v78[v690](v13(v78, v690 + 1 + 0, v80[3 + 0]));
											v72 = v72 + (1548 - (234 + 1313));
											v80 = v68[v72];
											v78[v80[2]][v78[v80[6 - 3]]] = v78[v80[4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[910 - (597 + 311)]] = v80[30 - (13 + 14)];
											v72 = v72 + 1;
											v689 = 2 + 23;
										end
										if (v689 == (1063 - (713 + 340))) then
											v80 = v68[v72];
											v78[v80[4 - 2]][v78[v80[3]]] = v78[v80[4 + 0]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[354 - (265 + 86)];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[1 + 1]] = v78[v80[874 - (747 + 124)]];
											v689 = 11;
										end
										if (v689 == (1484 - (692 + 764))) then
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2 + 0]] = v80[11 - 8];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v690 = v80[2];
											v78[v690] = v78[v690](v13(v78, v690 + (2 - 1), v80[1033 - (283 + 747)]));
											v72 = v72 + 1 + 0;
											v689 = 934 - (816 + 89);
										end
										if ((88 - 65) == v689) then
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[1081 - (709 + 369)];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[4 - 1];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v690 = v80[2];
											v689 = 22 + 2;
										end
										if ((120 <= 3286) and (v689 == (13 + 2))) then
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[701 - (478 + 221)]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[774 - (607 + 165)]] = v78[v80[1247 - (1108 + 136)]];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v689 = 34 - 18;
										end
										if ((v689 == (40 - 26)) or (1295 >= 4401)) then
											v78[v80[638 - (352 + 284)]] = v80[1 + 2];
											v72 = v72 + 1;
											v80 = v68[v72];
											v690 = v80[893 - (352 + 539)];
											v78[v690] = v78[v690](v13(v78, v690 + (3 - 2), v80[2 + 1]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[4 - 2]][v78[v80[769 - (714 + 52)]]] = v78[v80[4]];
											v689 = 13 + 2;
										end
										if (v689 == 7) then
											v72 = v72 + (1814 - (1482 + 331));
											v80 = v68[v72];
											v690 = v80[1203 - (766 + 435)];
											v78[v690] = v78[v690](v13(v78, v690 + 1, v80[1 + 2]));
											v72 = v72 + (1820 - (62 + 1757));
											v80 = v68[v72];
											v78[v80[1370 - (833 + 535)]][v78[v80[3]]] = v78[v80[4]];
											v72 = v72 + 1;
											v689 = 2 + 6;
										end
										if ((1796 <= 4893) and ((154 - (5 + 133)) == v689)) then
											v78[v80[2 + 0]] = v80[523 - (393 + 127)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[1059 - (705 + 351)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v690 = v80[1 + 1];
											v78[v690] = v78[v690](v13(v78, v690 + 1, v80[3 + 0]));
											v689 = 1174 - (414 + 743);
										end
										if (v689 == (2 + 0)) then
											v80 = v68[v72];
											v78[v80[474 - (65 + 407)]] = v80[5 - 2];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v690 = v80[9 - 7];
											v78[v690] = v78[v690](v13(v78, v690 + 1, v80[3]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v689 = 11 - 8;
										end
										if (v689 == 9) then
											v72 = v72 + (1545 - (116 + 1428));
											v80 = v68[v72];
											v78[v80[8 - 6]] = v80[1305 - (79 + 1223)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v690 = v80[390 - (353 + 35)];
											v78[v690] = v78[v690](v13(v78, v690 + (1 - 0), v80[7 - 4]));
											v72 = v72 + (1941 - (490 + 1450));
											v689 = 1356 - (778 + 568);
										end
										if (v689 == (22 + 3)) then
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[1297 - (914 + 380)]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[534 - (126 + 406)]] = v80[1193 - (655 + 535)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[7 - 4];
											v689 = 61 - 35;
										end
										if (v689 == (5 + 26)) then
											v690 = v80[1300 - (711 + 587)];
											v78[v690] = v78[v690](v13(v78, v690 + (884 - (168 + 715)), v80[5 - 2]));
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[2 - 0]][v78[v80[3]]] = v78[v80[296 - (232 + 60)]];
											break;
										end
										if (v689 == (2 + 1)) then
											v78[v80[2]][v78[v80[40 - (22 + 15)]]] = v78[v80[8 - 4]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[4 - 2]] = v80[3];
											v72 = v72 + (1174 - (797 + 376));
											v80 = v68[v72];
											v78[v80[2 + 0]] = v78[v80[1 + 2]];
											v72 = v72 + 1 + 0;
											v689 = 16 - 12;
										end
										if (v689 == (12 + 6)) then
											v78[v80[8 - 6]] = v78[v80[9 - 6]];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[1379 - (1071 + 306)]] = v80[7 - 4];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v72 = v72 + (1192 - (412 + 779));
											v689 = 37 - 18;
										end
										if ((1256 <= 3198) and (v689 == (48 - 26))) then
											v78[v80[2]][v78[v80[3]]] = v78[v80[616 - (427 + 185)]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1653 - (1444 + 207)]] = v80[7 - 4];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[1 + 2]];
											v72 = v72 + (2 - 1);
											v689 = 34 - 11;
										end
										if (v689 == 6) then
											v80 = v68[v72];
											v78[v80[641 - (261 + 378)]] = v78[v80[1 + 2]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[6 - 4]] = v80[3];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[350 - (22 + 326)]] = v80[9 - 6];
											v689 = 1221 - (836 + 378);
										end
										if ((4 + 7) == v689) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[5 - 2];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[1290 - (742 + 545)];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v689 = 12;
										end
										if ((4255 >= 1819) and (v689 == (75 - 54))) then
											v80 = v68[v72];
											v78[v80[1203 - (334 + 867)]] = v80[7 - 4];
											v72 = v72 + (1405 - (317 + 1087));
											v80 = v68[v72];
											v690 = v80[1 + 1];
											v78[v690] = v78[v690](v13(v78, v690 + (1 - 0), v80[673 - (97 + 573)]));
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v689 = 3 + 19;
										end
										if (((8 + 11) == v689) or (1003 >= 4367)) then
											v80 = v68[v72];
											v690 = v80[5 - 3];
											v78[v690] = v78[v690](v13(v78, v690 + 1, v80[3 + 0]));
											v72 = v72 + (1336 - (1234 + 101));
											v80 = v68[v72];
											v78[v80[2]][v78[v80[4 - 1]]] = v78[v80[3 + 1]];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v689 = 52 - 32;
										end
										if ((1212 - (711 + 489)) == v689) then
											v690 = v80[2];
											v78[v690] = v78[v690](v13(v78, v690 + 1 + 0, v80[3]));
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2 + 0]][v78[v80[5 - 2]]] = v78[v80[9 - 5]];
											v72 = v72 + (643 - (483 + 159));
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v689 = 13 + 0;
										end
										if (v689 == 20) then
											v78[v80[319 - (200 + 117)]] = v80[50 - (5 + 42)];
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[3 + 0]];
											v72 = v72 + (4 - 3);
											v80 = v68[v72];
											v78[v80[538 - (298 + 238)]] = v80[1824 - (1370 + 451)];
											v72 = v72 + 1 + 0;
											v689 = 1282 - (493 + 768);
										end
										if ((v689 == (1204 - (622 + 555))) or (474 > 3806)) then
											v80 = v68[v72];
											v78[v80[621 - (581 + 38)]] = v80[2 + 1];
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[8 - 6]] = v78[v80[1925 - (567 + 1355)]];
											v72 = v72 + (1565 - (801 + 763));
											v80 = v68[v72];
											v78[v80[2]] = v80[3];
											v689 = 28;
										end
										if (v689 == (2 + 28)) then
											v72 = v72 + (405 - (251 + 153));
											v80 = v68[v72];
											v78[v80[904 - (709 + 193)]] = v80[1890 - (737 + 1150)];
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v689 = 31;
										end
										if ((v689 == (1049 - (755 + 277))) or (543 >= 4521)) then
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[463 - (182 + 279)]][v78[v80[3]]] = v78[v80[364 - (323 + 37)]];
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[2]] = v80[1 + 2];
											v72 = v72 + 1;
											v80 = v68[v72];
											v689 = 1033 - (992 + 23);
										end
										if ((1812 == 1812) and (v689 == (2 + 2))) then
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[3];
											v72 = v72 + (646 - (269 + 376));
											v80 = v68[v72];
											v78[v80[3 - 1]] = v80[474 - (169 + 302)];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v690 = v80[2];
											v689 = 1 + 4;
										end
										if ((1332 - (623 + 704)) == v689) then
											v78[v690] = v78[v690](v13(v78, v690 + 1, v80[2 + 1]));
											v72 = v72 + 1;
											v80 = v68[v72];
											v78[v80[819 - (420 + 397)]][v78[v80[1 + 2]]] = v78[v80[2 + 2]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v78[v80[5 - 3]] = v80[3];
											v72 = v72 + (4 - 3);
											v689 = 6;
										end
									end
								elseif (v81 == (644 - 481)) then
									local v2913 = 0 + 0;
									local v2914;
									local v2915;
									local v2916;
									while true do
										if (v2913 == (0 + 0)) then
											v2914 = nil;
											v2915 = nil;
											v2916 = nil;
											v78[v80[5 - 3]] = {};
											v2913 = 2 - 1;
										end
										if ((2582 == 2582) and (v2913 == (2 - 1))) then
											v72 = v72 + (2 - 1);
											v80 = v68[v72];
											v78[v80[2]] = v80[1061 - (440 + 618)];
											v72 = v72 + (1036 - (593 + 442));
											v2913 = 1 + 1;
										end
										if (v2913 == (2 - 0)) then
											v80 = v68[v72];
											v78[v80[1046 - (801 + 243)]] = v78[v80[8 - 5]][v78[v80[4 - 0]]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2913 = 5 - 2;
										end
										if ((v2913 == (5 + 1)) or (3889 <= 992)) then
											for v6890 = 1, v2914 do
												v2915[v6890] = v78[v2916 + v6890];
											end
											break;
										end
										if (v2913 == (126 - (41 + 81))) then
											v72 = v72 + (3 - 2);
											v80 = v68[v72];
											v78[v80[2]] = v78[v80[509 - (145 + 361)]][v78[v80[4 + 0]]];
											v72 = v72 + (1 - 0);
											v2913 = 161 - (28 + 128);
										end
										if (v2913 == (4 - 1)) then
											v78[v80[2]] = {};
											v72 = v72 + (1 - 0);
											v80 = v68[v72];
											v78[v80[1 + 1]] = v80[88 - (33 + 52)];
											v2913 = 4;
										end
										if (v2913 == (8 - 3)) then
											v80 = v68[v72];
											v2916 = v80[2 + 0];
											v2915 = v78[v2916];
											v2914 = v80[3];
											v2913 = 29 - 23;
										end
									end
								else
									local v2917 = 0 - 0;
									while true do
										if (v2917 == 2) then
											v78[v80[2 + 0]] = v78[v80[3]][v78[v80[4]]];
											v72 = v72 + (1347 - (1135 + 211));
											v80 = v68[v72];
											v2917 = 3 + 0;
										end
										if (v2917 == (33 - 24)) then
											v78[v80[2]] = v80[3];
											break;
										end
										if (v2917 == (4 + 3)) then
											v78[v80[1097 - (380 + 715)]] = v78[v80[1 + 2]][v78[v80[1972 - (462 + 1506)]]];
											v72 = v72 + (1823 - (1182 + 640));
											v80 = v68[v72];
											v2917 = 21 - 13;
										end
										if (v2917 == (3 - 2)) then
											v78[v80[1 + 1]] = v80[13 - 10];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2917 = 2;
										end
										if (v2917 == (348 - (323 + 20))) then
											v78[v80[4 - 2]][v78[v80[3]]] = v78[v80[4 + 0]];
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2917 = 13 - 7;
										end
										if (v2917 == (1178 - (769 + 405))) then
											v78[v80[7 - 5]][v78[v80[3]]] = v78[v80[89 - (9 + 76)]];
											v72 = v72 + (255 - (244 + 10));
											v80 = v68[v72];
											v2917 = 1 + 4;
										end
										if ((v2917 == (1308 - (601 + 704))) or (1785 < 1002)) then
											v78[v80[2]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2917 = 2 + 2;
										end
										if ((v2917 == (530 - (23 + 499))) or (2729 <= 2324)) then
											v78[v80[2]] = {};
											v72 = v72 + 1 + 0;
											v80 = v68[v72];
											v2917 = 9 + 0;
										end
										if (v2917 == 0) then
											v78[v80[2]][v78[v80[309 - (35 + 271)]]] = v78[v80[4]];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2917 = 1 - 0;
										end
										if (v2917 == (7 - 1)) then
											v78[v80[1 + 1]] = v80[3];
											v72 = v72 + 1;
											v80 = v68[v72];
											v2917 = 6 + 1;
										end
									end
								end
							elseif (v81 <= (676 - 511)) then
								local v691;
								v691 = v80[2];
								v78[v691] = v78[v691](v13(v78, v691 + 1, v80[1 + 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[10 - 7]]] = v78[v80[1 + 3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[8 - 5]];
								v72 = v72 + (1876 - (1136 + 739));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[576 - (125 + 449)]] = v80[7 - 4];
								v72 = v72 + 1;
								v80 = v68[v72];
								v691 = v80[881 - (96 + 783)];
								v78[v691] = v78[v691](v13(v78, v691 + (1029 - (888 + 140)), v80[3 + 0]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[65 - (41 + 21)]]] = v78[v80[591 - (570 + 17)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[11 - 8]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + (756 - (321 + 434));
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v691 = v80[2];
								v78[v691] = v78[v691](v13(v78, v691 + 1, v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[1289 - (137 + 1149)]]] = v78[v80[8 - 4]];
								v72 = v72 + (1824 - (566 + 1257));
								v80 = v68[v72];
								v78[v80[679 - (391 + 286)]] = v80[1377 - (384 + 990)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[615 - (505 + 108)]] = v78[v80[3 + 0]];
								v72 = v72 + (1298 - (549 + 748));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[11 - 8];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v691 = v80[2];
								v78[v691] = v78[v691](v13(v78, v691 + 1 + 0, v80[8 - 5]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[6 - 3]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[8 - 5];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[695 - (205 + 487)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[10 - 7];
								v72 = v72 + (1427 - (309 + 1117));
								v80 = v68[v72];
								v691 = v80[2 + 0];
								v78[v691] = v78[v691](v13(v78, v691 + (1 - 0), v80[3 + 0]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[78 - (50 + 26)]][v78[v80[3]]] = v78[v80[2 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[1821 - (520 + 1298)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1062 - (420 + 640)]] = v80[5 - 2];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1584 - (15 + 1567)]] = v80[3 + 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v691 = v80[1986 - (110 + 1874)];
								v78[v691] = v78[v691](v13(v78, v691 + 1 + 0, v80[785 - (101 + 681)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[546 - (120 + 423)]]] = v78[v80[11 - 7]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[7 - 4]];
								v72 = v72 + (46 - (41 + 4));
								v80 = v68[v72];
								v78[v80[1085 - (246 + 837)]] = v80[909 - (492 + 414)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[6 - 3];
								v72 = v72 + (1050 - (829 + 220));
								v80 = v68[v72];
								v691 = v80[2 + 0];
								v78[v691] = v78[v691](v13(v78, v691 + 1 + 0, v80[9 - 6]));
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[3 - 1]][v78[v80[1498 - (345 + 1150)]]] = v78[v80[1361 - (1017 + 340)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + (1840 - (1279 + 560));
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[1 + 2];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v691 = v80[1465 - (140 + 1323)];
								v78[v691] = v78[v691](v13(v78, v691 + (1989 - (1607 + 381)), v80[4 - 1]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[197 - (162 + 32)]]] = v78[v80[608 - (440 + 164)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[5 - 2];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[958 - (553 + 403)]] = v78[v80[3]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[344 - (111 + 230)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[12 - 9];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v691 = v80[2 + 0];
								v78[v691] = v78[v691](v13(v78, v691 + (339 - (85 + 253)), v80[3]));
								v72 = v72 + (1850 - (1558 + 291));
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[7 - 4]]] = v78[v80[5 - 1]];
								v72 = v72 + (1083 - (985 + 97));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[616 - (424 + 189)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3 + 0]];
								v72 = v72 + (1024 - (19 + 1004));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[2 + 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
								v72 = v72 + (1346 - (231 + 1114));
								v80 = v68[v72];
								v691 = v80[1 + 1];
								v78[v691] = v78[v691](v13(v78, v691 + (1046 - (114 + 931)), v80[3]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]][v78[v80[1 + 2]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[66 - (17 + 46)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1038 - (931 + 105)]] = v80[1131 - (718 + 410)];
								v72 = v72 + (1206 - (361 + 844));
								v80 = v68[v72];
								v78[v80[1912 - (1760 + 150)]] = v80[1570 - (917 + 650)];
								v72 = v72 + (182 - (104 + 77));
								v80 = v68[v72];
								v691 = v80[2];
								v78[v691] = v78[v691](v13(v78, v691 + (2 - 1), v80[1 + 2]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]][v78[v80[4 - 1]]] = v78[v80[4]];
								v72 = v72 + (265 - (53 + 211));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3 + 0]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[1302 - (282 + 1018)]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[517 - (162 + 352)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v691 = v80[931 - (22 + 907)];
								v78[v691] = v78[v691](v13(v78, v691 + 1, v80[442 - (280 + 159)]));
								v72 = v72 + (1581 - (1064 + 516));
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[3 + 0]]] = v78[v80[4 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1908 - (1293 + 612)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3 - 0]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[1754 - (782 + 969)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v691 = v80[1670 - (1085 + 583)];
								v78[v691] = v78[v691](v13(v78, v691 + 1 + 0, v80[1463 - (229 + 1231)]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3]]] = v78[v80[11 - 7]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[147 - (48 + 97)]] = v78[v80[1849 - (676 + 1170)]];
								v72 = v72 + (1973 - (830 + 1142));
								v80 = v68[v72];
								v78[v80[97 - (41 + 54)]] = v80[12 - 9];
								v72 = v72 + (1067 - (536 + 530));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[12 - 9];
								v72 = v72 + (1256 - (1129 + 126));
								v80 = v68[v72];
								v691 = v80[2];
								v78[v691] = v78[v691](v13(v78, v691 + 1, v80[3 + 0]));
								v72 = v72 + (453 - (282 + 170));
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[1 + 3]];
							elseif ((1609 == 1609) and (v81 > (796 - 630))) then
								v78[v80[1225 - (610 + 613)]][v78[v80[3]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[8 - 5];
								v72 = v72 + (1609 - (1182 + 426));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1 + 2]][v78[v80[4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + (1235 - (1210 + 24));
								v80 = v68[v72];
								v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[2 + 2]];
								v72 = v72 + (1358 - (307 + 1050));
								v80 = v68[v72];
								v78[v80[816 - (693 + 121)]][v78[v80[287 - (267 + 17)]]] = v78[v80[63 - (22 + 37)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1450 - (391 + 1056)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1579 - (1117 + 459)]][v78[v80[4]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[463 - (65 + 396)]] = v80[7 - 4];
							else
								local v2935;
								v2935 = v80[7 - 5];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1, v80[2 + 1]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[1704 - (620 + 1081)]]] = v78[v80[1 + 3]];
								v72 = v72 + (1881 - (845 + 1035));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[7 - 4];
								v72 = v72 + (1570 - (1348 + 221));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1044 - (320 + 721)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1959 - (1284 + 673)]] = v80[6 - 3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[7 - 4];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2935 = v80[2];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (2 - 1), v80[8 - 5]));
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[4 - 2]][v78[v80[3]]] = v78[v80[4]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[364 - (170 + 191)];
								v72 = v72 + (1743 - (209 + 1533));
								v80 = v68[v72];
								v78[v80[2 - 0]] = v78[v80[1419 - (1049 + 367)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[10 - 7];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2935 = v80[2 + 0];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (2 - 1), v80[5 - 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[225 - (167 + 56)]][v78[v80[8 - 5]]] = v78[v80[2 + 2]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3 + 0];
								v72 = v72 + (881 - (752 + 128));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[1 + 2]];
								v72 = v72 + (19 - (7 + 11));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[134 - (87 + 44)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[10 - 7];
								v72 = v72 + 1;
								v80 = v68[v72];
								v2935 = v80[1537 - (656 + 879)];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1, v80[5 - 2]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[4 - 2]][v78[v80[13 - 10]]] = v78[v80[1086 - (529 + 553)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[939 - (613 + 324)]] = v80[1323 - (585 + 735)];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[2 + 1]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[8 - 5];
								v72 = v72 + (16 - (6 + 9));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2935 = v80[5 - 3];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1, v80[8 - 5]));
								v72 = v72 + (461 - (59 + 401));
								v80 = v68[v72];
								v78[v80[791 - (743 + 46)]][v78[v80[2 + 1]]] = v78[v80[8 - 4]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[539 - (285 + 252)]] = v78[v80[3]];
								v72 = v72 + (476 - (146 + 329));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + (1471 - (417 + 1053));
								v80 = v68[v72];
								v78[v80[1874 - (1251 + 621)]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2935 = v80[8 - 6];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (237 - (213 + 23)), v80[3]));
								v72 = v72 + (745 - (617 + 127));
								v80 = v68[v72];
								v78[v80[694 - (181 + 511)]][v78[v80[383 - (187 + 193)]]] = v78[v80[4]];
								v72 = v72 + (1290 - (107 + 1182));
								v80 = v68[v72];
								v78[v80[1986 - (1623 + 361)]] = v80[1 + 2];
								v72 = v72 + (1822 - (325 + 1496));
								v80 = v68[v72];
								v78[v80[358 - (235 + 121)]] = v78[v80[3 + 0]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[2 + 1];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2]] = v80[6 - 3];
								v72 = v72 + (50 - (28 + 21));
								v80 = v68[v72];
								v2935 = v80[4 - 2];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1, v80[2 + 1]));
								v72 = v72 + (688 - (630 + 57));
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[11 - 8]]] = v78[v80[1 + 3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[890 - (21 + 867)]] = v80[10 - 7];
								v72 = v72 + (1768 - (1555 + 212));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3 + 0]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[2 + 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[2 + 1];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2935 = v80[4 - 2];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1, v80[4 - 1]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[7 - 4]]] = v78[v80[3 + 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[944 - (903 + 38)]];
								v72 = v72 + (387 - (74 + 312));
								v80 = v68[v72];
								v78[v80[1322 - (837 + 483)]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[2 + 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2935 = v80[1 + 1];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (1542 - (1455 + 86)), v80[827 - (803 + 21)]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 - 0]][v78[v80[7 - 4]]] = v78[v80[5 - 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[3 + 0]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[902 - (497 + 402)];
								v72 = v72 + (989 - (578 + 410));
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[1546 - (464 + 1079)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2935 = v80[2];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (1697 - (1398 + 298)), v80[4 - 1]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4 - 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1292 - (561 + 729)]] = v80[1 + 2];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1161 - (104 + 1055)]] = v78[v80[1676 - (308 + 1365)]];
								v72 = v72 + (548 - (500 + 47));
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[1 + 2];
								v72 = v72 + (1951 - (186 + 1764));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[2 + 1];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2935 = v80[2 + 0];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1 + 0, v80[2 + 1]));
								v72 = v72 + (1175 - (1133 + 41));
								v80 = v68[v72];
								v78[v80[4 - 2]][v78[v80[6 - 3]]] = v78[v80[1897 - (1786 + 107)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[1532 - (344 + 1185)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[698 - (72 + 623)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[1895 - (1093 + 799)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v2935 = v80[2];
								v78[v2935] = v78[v2935](v13(v78, v2935 + 1, v80[3 + 0]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[11 - 8]]] = v78[v80[1059 - (721 + 334)]];
								v72 = v72 + (1863 - (1322 + 540));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3];
								v72 = v72 + (1373 - (575 + 797));
								v80 = v68[v72];
								v78[v80[1131 - (274 + 855)]] = v78[v80[6 - 3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[4 - 1];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[2 + 1];
								v72 = v72 + (1810 - (986 + 823));
								v80 = v68[v72];
								v2935 = v80[2 + 0];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (1014 - (872 + 141)), v80[1 + 2]));
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[3 - 1]][v78[v80[3]]] = v78[v80[542 - (139 + 399)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1705 - (1038 + 664)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[4 - 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v2935 = v80[576 - (388 + 186)];
								v78[v2935] = v78[v2935](v13(v78, v2935 + (487 - (421 + 65)), v80[5 - 2]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[4]];
							end
						elseif (v81 <= (1433 - (604 + 659))) then
							if (v81 <= 168) then
								local v776;
								v78[v80[1506 - (1267 + 237)]] = v80[3];
								v72 = v72 + (182 - (112 + 69));
								v80 = v68[v72];
								v776 = v80[2 - 0];
								v78[v776] = v78[v776](v13(v78, v776 + 1, v80[487 - (319 + 165)]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[1356 - (634 + 719)]]] = v78[v80[1043 - (248 + 791)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
								v72 = v72 + (1086 - (888 + 197));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v78[v80[6 - 3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[9 - 6];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[11 - 8];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v776 = v80[2 - 0];
								v78[v776] = v78[v776](v13(v78, v776 + (1967 - (1355 + 611)), v80[3]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[1004 - (497 + 504)]]] = v78[v80[5 - 1]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
							elseif ((1876 < 3848) and (v81 == 169)) then
								v78[v80[6 - 4]][v78[v80[6 - 3]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1259 - (1159 + 98)]] = v80[1446 - (418 + 1025)];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[9 - 5]]];
								v72 = v72 + (1794 - (297 + 1496));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[945 - (547 + 396)]][v78[v80[6 - 3]]] = v78[v80[3 + 1]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[1746 - (999 + 744)]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[502 - (324 + 176)]] = v80[1513 - (1171 + 339)];
								v72 = v72 + (948 - (492 + 455));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1479 - (805 + 671)]][v78[v80[1317 - (265 + 1048)]]];
								v72 = v72 + (1577 - (252 + 1324));
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + (1571 - (544 + 1026));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[5 - 2];
							else
								local v3035 = 662 - (217 + 445);
								local v3036;
								while true do
									if (((0 + 0) == v3035) or (3994 > 4973)) then
										v3036 = v80[942 - (492 + 448)];
										do
											return v78[v3036](v13(v78, v3036 + (1433 - (1152 + 280)), v80[4 - 1]));
										end
										break;
									end
								end
							end
						elseif (v81 <= (856 - 684)) then
							if (v81 > (145 + 26)) then
								v72 = v80[3];
							else
								local v3038;
								local v3039;
								local v3040;
								v78[v80[1 + 1]] = v80[848 - (175 + 670)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1655 - (1411 + 242)]] = v78[v80[2 + 1]][v78[v80[697 - (678 + 15)]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = {};
								v72 = v72 + (811 - (593 + 217));
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3 + 0];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[492 - (112 + 378)]] = v78[v80[1550 - (952 + 595)]][v78[v80[400 - (23 + 373)]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v3040 = v80[5 - 3];
								v3039 = v78[v3040];
								v3038 = v80[3];
								for v4291 = 1 + 0, v3038 do
									v3039[v4291] = v78[v3040 + v4291];
								end
							end
						elseif (v81 == (1957 - (1102 + 682))) then
							local v3053 = 0 + 0;
							local v3054;
							local v3055;
							local v3056;
							while true do
								if (v3053 == (1 + 0)) then
									v3056 = v78[v3054 + (1385 - (118 + 1265))];
									if (v3056 > 0) then
										if (v3055 > v78[v3054 + 1]) then
											v72 = v80[3];
										else
											v78[v3054 + 3] = v3055;
										end
									elseif (v3055 < v78[v3054 + (1100 - (725 + 374))]) then
										v72 = v80[2 + 1];
									else
										v78[v3054 + 3 + 0] = v3055;
									end
									break;
								end
								if (v3053 == (1998 - (1142 + 856))) then
									v3054 = v80[2 + 0];
									v3055 = v78[v3054];
									v3053 = 1 - 0;
								end
							end
						else
							local v3057;
							v78[v80[2 + 0]] = v78[v80[3 + 0]];
							v72 = v72 + (645 - (104 + 540));
							v80 = v68[v72];
							v78[v80[964 - (496 + 466)]] = v80[2 + 1];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3057 = v80[726 - (657 + 67)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1, v80[14 - 11]));
							v72 = v72 + (1747 - (127 + 1619));
							v80 = v68[v72];
							v78[v80[6 - 4]][v78[v80[1193 - (1069 + 121)]]] = v78[v80[4]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[11 - 8];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[1193 - (27 + 1163)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v80[1162 - (371 + 788)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[6 - 3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3057 = v80[7 - 5];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1 + 0, v80[3]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[11 - 7]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[431 - (139 + 290)]] = v80[3];
							v72 = v72 + (1336 - (639 + 696));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[506 - (156 + 348)]] = v80[893 - (488 + 402)];
							v72 = v72 + (203 - (186 + 16));
							v80 = v68[v72];
							v3057 = v80[325 - (119 + 204)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + (1 - 0), v80[4 - 1]));
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[7 - 4]]] = v78[v80[4 + 0]];
							v72 = v72 + (1760 - (1709 + 50));
							v80 = v68[v72];
							v78[v80[2]] = v80[1332 - (249 + 1080)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[453 - (155 + 296)]] = v78[v80[3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[6 - 3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3057 = v80[2];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1, v80[9 - 6]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[2 + 2]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[5 - 2];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[700 - (604 + 94)]] = v80[1 + 2];
							v72 = v72 + (1804 - (500 + 1303));
							v80 = v68[v72];
							v3057 = v80[1522 - (916 + 604)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1 + 0, v80[2 + 1]));
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[4 + 0]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1477 - (754 + 721)]] = v80[509 - (181 + 325)];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[1 + 2]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1412 - (413 + 997)]] = v80[7 - 4];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3057 = v80[2];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1, v80[1 + 2]));
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[4 - 2]][v78[v80[1744 - (708 + 1033)]]] = v78[v80[2 + 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[1 + 2];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[1 + 2]];
							v72 = v72 + (1658 - (505 + 1152));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[2 + 1];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3057 = v80[2];
							v78[v3057] = v78[v3057](v13(v78, v3057 + (3 - 2), v80[5 - 2]));
							v72 = v72 + (1524 - (53 + 1470));
							v80 = v68[v72];
							v78[v80[1006 - (482 + 522)]][v78[v80[649 - (496 + 150)]]] = v78[v80[4 - 0]];
							v72 = v72 + (86 - (32 + 53));
							v80 = v68[v72];
							v78[v80[2]] = v80[1813 - (956 + 854)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[5 - 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[1896 - (1192 + 701)];
							v72 = v72 + (1622 - (326 + 1295));
							v80 = v68[v72];
							v78[v80[1814 - (1595 + 217)]] = v80[219 - (93 + 123)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3057 = v80[1838 - (848 + 988)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + (1561 - (546 + 1014)), v80[6 - 3]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[76 - (53 + 21)]][v78[v80[3]]] = v78[v80[295 - (167 + 124)]];
							v72 = v72 + (181 - (4 + 176));
							v80 = v68[v72];
							v78[v80[2]] = v80[6 - 3];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[6 - 4]] = v78[v80[3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3 + 0];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3057 = v80[121 - (93 + 26)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1 + 0, v80[3 - 0]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[1 + 2]]] = v78[v80[1658 - (220 + 1434)]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[10 - 7];
							v72 = v72 + (1603 - (906 + 696));
							v80 = v68[v72];
							v78[v80[3 - 1]] = v78[v80[2 + 1]];
							v72 = v72 + (680 - (178 + 501));
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3057 = v80[1029 - (444 + 583)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + (1 - 0), v80[3]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[431 - (407 + 22)]][v78[v80[3]]] = v78[v80[7 - 3]];
							v72 = v72 + (1233 - (1139 + 93));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3];
							v72 = v72 + (1345 - (237 + 1107));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[2 + 1]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[13 - (4 + 7)]] = v80[11 - 8];
							v72 = v72 + (514 - (8 + 505));
							v80 = v68[v72];
							v78[v80[2]] = v80[2 + 1];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3057 = v80[1 + 1];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1, v80[3 + 0]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[937 - (662 + 273)]][v78[v80[3]]] = v78[v80[2 + 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[247 - (127 + 117)];
							v72 = v72 + (208 - (105 + 102));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[7 - 4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[6 - 4]] = v80[749 - (588 + 158)];
							v72 = v72 + (1081 - (126 + 954));
							v80 = v68[v72];
							v3057 = v80[6 - 4];
							v78[v3057] = v78[v3057](v13(v78, v3057 + (344 - (52 + 291)), v80[3]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[280 - (76 + 202)]][v78[v80[3 + 0]]] = v78[v80[850 - (504 + 342)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[2 + 1];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[483 - (387 + 93)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[2 + 1];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3057 = v80[941 - (36 + 903)];
							v78[v3057] = v78[v3057](v13(v78, v3057 + 1, v80[5 - 2]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[266 - (220 + 42)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[3];
							v72 = v72 + (1506 - (300 + 1205));
							v80 = v68[v72];
							v78[v80[6 - 4]] = v78[v80[925 - (728 + 194)]];
							v72 = v72 + (658 - (445 + 212));
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[2 + 1];
						end
					elseif ((4549 > 2977) and (v81 <= (161 + 20))) then
						if (v81 <= (1534 - (167 + 1190))) then
							if (v81 <= (819 - (315 + 329))) then
								local v792 = 0 + 0;
								while true do
									if (v792 == 4) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[652 - (545 + 105)]] = v80[2 + 1];
										v72 = v72 + 1 + 0;
										v792 = 5 + 0;
									end
									if (v792 == 3) then
										v78[v80[4 - 2]][v78[v80[4 - 1]]] = v78[v80[4]];
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[1191 - (1044 + 145)]][v78[v80[7 - 4]]] = v78[v80[1254 - (122 + 1128)]];
										v792 = 1819 - (371 + 1444);
									end
									if ((4577 > 2876) and (v792 == (18 - (14 + 2)))) then
										v80 = v68[v72];
										v78[v80[1 + 1]] = v80[3];
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v792 = 3;
									end
									if ((851 <= 2362) and (v792 == (1 - 0))) then
										v72 = v72 + (1 - 0);
										v80 = v68[v72];
										v78[v80[2 + 0]] = v78[v80[4 - 1]][v78[v80[14 - 10]]];
										v72 = v72 + 1;
										v792 = 2;
									end
									if (v792 == (4 + 1)) then
										v80 = v68[v72];
										v78[v80[4 - 2]] = v78[v80[3]][v78[v80[13 - 9]]];
										v72 = v72 + (4 - 3);
										v80 = v68[v72];
										v792 = 2 + 4;
									end
									if (v792 == (0 + 0)) then
										v78[v80[2]][v78[v80[12 - 9]]] = v78[v80[6 - 2]];
										v72 = v72 + (150 - (50 + 99));
										v80 = v68[v72];
										v78[v80[441 - (123 + 316)]] = v80[4 - 1];
										v792 = 1583 - (1507 + 75);
									end
									if ((v792 == (600 - (145 + 449))) or (3985 <= 1377)) then
										v78[v80[2]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[2]] = v80[3];
										break;
									end
								end
							elseif ((v81 == (1287 - (241 + 870))) or (1921 > 2154)) then
								local v3137;
								local v3138;
								local v3139;
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[11 - 8]][v78[v80[8 - 4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + (758 - (627 + 130));
								v80 = v68[v72];
								v78[v80[147 - (82 + 63)]] = v80[3 + 0];
								v72 = v72 + (1285 - (386 + 898));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[3]][v78[v80[4]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v3139 = v80[2];
								v3138 = v78[v3139];
								v3137 = v80[3 + 0];
								for v4319 = 1 + 0, v3137 do
									v3138[v4319] = v78[v3139 + v4319];
								end
							else
								local v3149;
								local v3150;
								local v3151;
								v78[v80[2]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[971 - (659 + 310)]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[606 - (364 + 239)]][v78[v80[3 + 1]]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[2 - 0]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[196 - (30 + 163)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[5 - 3]] = v78[v80[558 - (213 + 342)]][v78[v80[11 - 7]]];
								v72 = v72 + (1419 - (843 + 575));
								v80 = v68[v72];
								v3151 = v80[704 - (347 + 355)];
								v3150 = v78[v3151];
								v3149 = v80[7 - 4];
								for v4322 = 468 - (386 + 81), v3149 do
									v3150[v4322] = v78[v3151 + v4322];
								end
							end
						elseif (v81 <= (364 - 185)) then
							if ((3447 > 533) and (v81 == (410 - 232))) then
								local v3165;
								local v3166;
								local v3167;
								v78[v80[2 + 0]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[1660 - (610 + 1047)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[565 - (304 + 259)]] = v78[v80[8 - 5]][v78[v80[4]]];
								v72 = v72 + (966 - (306 + 659));
								v80 = v68[v72];
								v78[v80[1 + 1]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[1742 - (315 + 1424)];
								v72 = v72 + (589 - (27 + 561));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1930 - (1904 + 23)]][v78[v80[1 + 3]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v3167 = v80[2];
								v3166 = v78[v3167];
								v3165 = v80[2001 - (1852 + 146)];
								for v4325 = 1, v3165 do
									v3166[v4325] = v78[v3167 + v4325];
								end
							else
								v78[v80[5 - 3]][v78[v80[10 - 7]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[188 - (18 + 168)]] = v80[2 + 1];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[11 - 8]][v78[v80[5 - 1]]];
								v72 = v72 + (639 - (399 + 239));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[3];
								v72 = v72 + (1409 - (779 + 629));
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[2 + 1]]] = v78[v80[1773 - (855 + 914)]];
								v72 = v72 + (23 - (15 + 7));
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[1705 - (646 + 1056)]]] = v78[v80[1 + 3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[1869 - (1443 + 423)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[2 + 1]][v78[v80[4]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[7 - 4];
							end
						elseif (v81 == 180) then
							v78[v80[1508 - (271 + 1235)]] = v78[v80[2 + 1]];
						else
							local v3201;
							v3201 = v80[6 - 4];
							v78[v3201] = v78[v3201](v13(v78, v3201 + (3 - 2), v80[9 - 6]));
							v72 = v72 + (1045 - (463 + 581));
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[1178 - (599 + 576)]]] = v78[v80[1516 - (316 + 1196)]];
							v72 = v72 + (1304 - (970 + 333));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[963 - (538 + 423)]] = v78[v80[1 + 2]];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[2]] = v80[7 - 4];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1357 - (1061 + 293)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3201 = v80[531 - (153 + 376)];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1 + 0, v80[708 - (173 + 532)]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[5 - 2]]] = v78[v80[4]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v80[7 - 4];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[6 - 3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[10 - 7];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1538 - (561 + 975)]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3201 = v80[2 + 0];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1 + 0, v80[3]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[4 + 0]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[9 - 6];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[126 - (115 + 8)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[1559 - (1476 + 80)];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v80[845 - (648 + 194)];
							v72 = v72 + (256 - (111 + 144));
							v80 = v68[v72];
							v3201 = v80[2];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1, v80[2 + 1]));
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[320 - (275 + 42)]]] = v78[v80[186 - (104 + 78)]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[1939 - (813 + 1123)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[1 + 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[6 - 4]] = v80[3 + 0];
							v72 = v72 + (1794 - (144 + 1649));
							v80 = v68[v72];
							v78[v80[553 - (125 + 426)]] = v80[6 - 3];
							v72 = v72 + (83 - (51 + 31));
							v80 = v68[v72];
							v3201 = v80[6 - 4];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1 + 0, v80[292 - (174 + 115)]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1700 - (941 + 757)]][v78[v80[1165 - (696 + 466)]]] = v78[v80[7 - 3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[4 - 1];
							v72 = v72 + (1352 - (165 + 1186));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[9 - 7]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[3 + 0];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3201 = v80[1 + 1];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1 + 0, v80[1040 - (853 + 184)]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[36 - (14 + 20)]][v78[v80[1 + 2]]] = v78[v80[4]];
							v72 = v72 + (767 - (35 + 731));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1 + 2];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[5 - 2];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[149 - (26 + 121)]] = v80[114 - (95 + 16)];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v3201 = v80[2 - 0];
							v78[v3201] = v78[v3201](v13(v78, v3201 + (552 - (423 + 128)), v80[3]));
							v72 = v72 + (1575 - (1331 + 243));
							v80 = v68[v72];
							v78[v80[4 - 2]][v78[v80[7 - 4]]] = v78[v80[1638 - (284 + 1350)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[30 - (10 + 18)]] = v80[7 - 4];
							v72 = v72 + (1308 - (73 + 1234));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[740 - (503 + 234)]];
							v72 = v72 + (1902 - (425 + 1476));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[5 - 2];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1058 - (856 + 200)]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3201 = v80[1 + 1];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1 + 0, v80[3 + 0]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[1614 - (734 + 877)]]] = v78[v80[2 + 2]];
							v72 = v72 + (1482 - (514 + 967));
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[3];
							v72 = v72 + (648 - (325 + 322));
							v80 = v68[v72];
							v78[v80[2 - 0]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1832 - (1668 + 162)]] = v80[8 - 5];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[235 - (43 + 189)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3201 = v80[2];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1, v80[5 - 2]));
							v72 = v72 + (1659 - (694 + 964));
							v80 = v68[v72];
							v78[v80[3 - 1]][v78[v80[3 - 0]]] = v78[v80[6 - 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[340 - (57 + 280)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1956 - (414 + 1540)]] = v78[v80[903 - (561 + 339)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[1553 - (1342 + 208)];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3201 = v80[6 - 4];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1, v80[1849 - (1139 + 707)]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[1 + 3]];
							v72 = v72 + (541 - (335 + 205));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[4 - 1];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[7 - 4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1064 - (622 + 440)]] = v80[5 - 2];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[754 - (672 + 80)]] = v80[1129 - (601 + 525)];
							v72 = v72 + (1819 - (1515 + 303));
							v80 = v68[v72];
							v3201 = v80[1 + 1];
							v78[v3201] = v78[v3201](v13(v78, v3201 + (1 - 0), v80[3]));
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[966 - (144 + 818)]];
							v72 = v72 + (28 - (5 + 22));
							v80 = v68[v72];
							v78[v80[863 - (446 + 415)]] = v80[216 - (204 + 9)];
							v72 = v72 + (1259 - (479 + 779));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[118 - (61 + 54)]];
							v72 = v72 + (1806 - (1235 + 570));
							v80 = v68[v72];
							v78[v80[970 - (217 + 751)]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (111 - (94 + 16));
							v80 = v68[v72];
							v3201 = v80[6 - 4];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1, v80[3 + 0]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1547 - (1188 + 357)]][v78[v80[812 - (580 + 229)]]] = v78[v80[514 - (82 + 428)]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]] = v80[499 - (259 + 237)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[7 - 5]] = v78[v80[1359 - (215 + 1141)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[673 - (405 + 265)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1985 - (1136 + 847)]] = v80[3];
							v72 = v72 + (1735 - (230 + 1504));
							v80 = v68[v72];
							v3201 = v80[2];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1, v80[9 - 6]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[1885 - (913 + 969)]]] = v78[v80[6 - 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1395 - (1277 + 116)]] = v80[3];
							v72 = v72 + (1188 - (1178 + 9));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[2 + 1]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1842 - (1018 + 822)]] = v80[7 - 4];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[3 + 0];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3201 = v80[2 + 0];
							v78[v3201] = v78[v3201](v13(v78, v3201 + 1 + 0, v80[384 - (111 + 270)]));
							v72 = v72 + (1197 - (1082 + 114));
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[8 - 5]]] = v78[v80[499 - (257 + 238)]];
						end
					elseif ((1957 == 1957) and (v81 <= (2038 - (831 + 1023)))) then
						if ((v81 <= (303 - (6 + 115))) or (1998 < 1926)) then
							local v793 = 0 - 0;
							local v794;
							while true do
								if (v793 == (61 - 36)) then
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[2 + 1]]] = v78[v80[9 - 5]];
									break;
								end
								if (v793 == (22 - 13)) then
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (1201 - (608 + 592));
									v80 = v68[v72];
									v78[v80[2]] = v80[6 - 3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v794 = v80[2];
									v78[v794] = v78[v794](v13(v78, v794 + (1942 - (24 + 1917)), v80[3]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v793 = 1535 - (521 + 1004);
								end
								if ((1249 <= 3024) and (v793 == (10 - 3))) then
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (295 - (87 + 207));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v794 = v80[2];
									v78[v794] = v78[v794](v13(v78, v794 + (1596 - (625 + 970)), v80[2 + 1]));
									v72 = v72 + (350 - (122 + 227));
									v793 = 3 + 5;
								end
								if (v793 == (1117 - (706 + 409))) then
									v794 = v80[1 + 1];
									v78[v794] = v78[v794](v13(v78, v794 + (2 - 1), v80[2 + 1]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[448 - (433 + 13)]][v78[v80[3 + 0]]] = v78[v80[985 - (824 + 157)]];
									v72 = v72 + (361 - (120 + 240));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v793 = 1035 - (291 + 741);
								end
								if (24 == v793) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1494 - (810 + 682)]] = v80[496 - (16 + 477)];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v794 = v80[1368 - (658 + 708)];
									v78[v794] = v78[v794](v13(v78, v794 + 1 + 0, v80[4 - 1]));
									v793 = 22 + 3;
								end
								if (v793 == (670 - (483 + 164))) then
									v78[v794] = v78[v794](v13(v78, v794 + (2 - 1), v80[4 - 1]));
									v72 = v72 + (549 - (151 + 397));
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[1226 - (1005 + 218)]]] = v78[v80[4]];
									v72 = v72 + (656 - (294 + 361));
									v80 = v68[v72];
									v78[v80[1062 - (150 + 910)]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[12 - 9]];
									v793 = 17 + 7;
								end
								if (v793 == (25 - 17)) then
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[1804 - (756 + 1044)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[832 - (738 + 92)]] = v80[8 - 5];
									v72 = v72 + (1413 - (569 + 843));
									v80 = v68[v72];
									v78[v80[1430 - (262 + 1166)]] = v78[v80[654 - (410 + 241)]];
									v72 = v72 + (1185 - (388 + 796));
									v80 = v68[v72];
									v793 = 9;
								end
								if ((3379 > 1633) and (v793 == (1009 - (534 + 474)))) then
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[1102 - (642 + 457)]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1478 - (384 + 1092)]] = v80[1732 - (1190 + 539)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[755 - (91 + 662)]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v793 = 7 - 5;
								end
								if (v793 == (1058 - (116 + 931))) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v794 = v80[7 - 5];
									v78[v794] = v78[v794](v13(v78, v794 + (2 - 1), v80[3]));
									v72 = v72 + (178 - (18 + 159));
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[4 - 1]]] = v78[v80[9 - 5]];
									v793 = 17 - 5;
								end
								if (v793 == (44 - 26)) then
									v72 = v72 + (320 - (111 + 208));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3 + 0]];
									v72 = v72 + (593 - (364 + 228));
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[5 - 2];
									v72 = v72 + 1;
									v793 = 7 + 12;
								end
								if ((v793 == (9 + 1)) or (4017 <= 3166)) then
									v78[v80[1 + 1]][v78[v80[4 - 1]]] = v78[v80[4 + 0]];
									v72 = v72 + (378 - (121 + 256));
									v80 = v68[v72];
									v78[v80[8 - 6]] = v80[3];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v793 = 8 + 3;
								end
								if (v793 == 14) then
									v80 = v68[v72];
									v78[v80[1760 - (549 + 1209)]] = v80[3 - 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[1384 - (643 + 738)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[6 - 3];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v793 = 4 + 11;
								end
								if (v793 == (43 - 22)) then
									v794 = v80[2 - 0];
									v78[v794] = v78[v794](v13(v78, v794 + (1108 - (1038 + 69)), v80[3]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[338 - (157 + 179)]][v78[v80[1133 - (204 + 926)]]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[1960 - (184 + 1773)];
									v72 = v72 + (720 - (111 + 608));
									v80 = v68[v72];
									v793 = 14 + 8;
								end
								if ((1583 <= 2620) and (v793 == (44 - 32))) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[8 - 6]] = v78[v80[6 - 3]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v793 = 10 + 3;
								end
								if (v793 == (1685 - (1328 + 340))) then
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v794 = v80[2 + 0];
									v78[v794] = v78[v794](v13(v78, v794 + (2 - 1), v80[2 + 1]));
									v72 = v72 + (1015 - (782 + 232));
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1305 - (397 + 906)]] = v80[603 - (360 + 240)];
									v793 = 18;
								end
								if ((v793 == (22 - 3)) or (3063 > 4794)) then
									v80 = v68[v72];
									v794 = v80[2 + 0];
									v78[v794] = v78[v794](v13(v78, v794 + (23 - (13 + 9)), v80[4 - 1]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1576 - (272 + 1302)]][v78[v80[12 - 9]]] = v78[v80[11 - 7]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[5 - 2];
									v72 = v72 + 1;
									v793 = 41 - (8 + 13);
								end
								if (v793 == 15) then
									v78[v80[2 + 0]] = v80[9 - 6];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v794 = v80[90 - (28 + 60)];
									v78[v794] = v78[v794](v13(v78, v794 + 1 + 0, v80[1 + 2]));
									v72 = v72 + (954 - (133 + 820));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[101 - (9 + 88)]];
									v72 = v72 + (251 - (98 + 152));
									v80 = v68[v72];
									v793 = 16 + 0;
								end
								if ((2736 > 1647) and (v793 == 0)) then
									v794 = nil;
									v794 = v80[5 - 3];
									v78[v794] = v78[v794](v13(v78, v794 + 1, v80[13 - 10]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[2 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3];
									v72 = v72 + 1;
									v793 = 289 - (44 + 244);
								end
								if (v793 == 20) then
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + (1390 - (207 + 1182));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[919 - (904 + 12)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[2 + 1];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v793 = 21;
								end
								if ((1010 < 4057) and (v793 == 16)) then
									v78[v80[255 - (241 + 12)]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1256 - (1187 + 67)]] = v80[275 - (56 + 216)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[1482 - (1194 + 285)];
									v793 = 1717 - (401 + 1299);
								end
								if ((1000 < 2304) and ((1568 - (1522 + 33)) == v793)) then
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[3 - 0];
									v72 = v72 + (1823 - (1108 + 714));
									v80 = v68[v72];
									v794 = v80[2];
									v78[v794] = v78[v794](v13(v78, v794 + 1, v80[677 - (357 + 317)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[470 - (73 + 394)]]] = v78[v80[12 - 8]];
									v72 = v72 + 1 + 0;
									v793 = 14;
								end
								if ((3 + 0) == v793) then
									v78[v80[2]] = v78[v80[254 - (247 + 4)]];
									v72 = v72 + (629 - (435 + 193));
									v80 = v68[v72];
									v78[v80[2]] = v80[476 - (428 + 45)];
									v72 = v72 + (1221 - (158 + 1062));
									v80 = v68[v72];
									v78[v80[1379 - (858 + 519)]] = v80[5 - 2];
									v72 = v72 + (1458 - (711 + 746));
									v80 = v68[v72];
									v794 = v80[1 + 1];
									v793 = 4;
								end
								if (v793 == 5) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[679 - (229 + 448)]] = v80[744 - (357 + 384)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v794 = v80[1 + 1];
									v78[v794] = v78[v794](v13(v78, v794 + (1581 - (984 + 596)), v80[5 - 2]));
									v793 = 927 - (465 + 456);
								end
								if ((v793 == (20 + 2)) or (1042 > 4243)) then
									v78[v80[5 - 3]] = v78[v80[2 + 1]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[10 - 7];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (217 - (172 + 44));
									v80 = v68[v72];
									v794 = v80[1 + 1];
									v793 = 23 + 0;
								end
								if (v793 == (383 - (170 + 209))) then
									v78[v794] = v78[v794](v13(v78, v794 + (2 - 1), v80[7 - 4]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[959 - (244 + 712)]]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[1 + 2]];
									v793 = 4 + 1;
								end
								if ((v793 == (23 - 17)) or (3108 <= 2052)) then
									v72 = v72 + (1247 - (769 + 477));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3 - 0]]] = v78[v80[4 + 0]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3 + 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[6 - 3]];
									v72 = v72 + (1 - 0);
									v793 = 24 - 17;
								end
							end
						elseif (v81 > (180 + 3)) then
							local v3291 = v80[6 - 4];
							v78[v3291] = v78[v3291](v13(v78, v3291 + (1 - 0), v80[641 - (526 + 112)]));
						else
							local v3293;
							v78[v80[2]] = v78[v80[3]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[661 - (318 + 340)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[625 - (274 + 349)]] = v80[6 - 3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3293 = v80[4 - 2];
							v78[v3293] = v78[v3293](v13(v78, v3293 + 1, v80[2 + 1]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[1455 - (1429 + 23)]]] = v78[v80[4]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3 + 0];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1508 - (1140 + 366)]] = v80[4 - 1];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3293 = v80[2];
							v78[v3293] = v78[v3293](v13(v78, v3293 + 1 + 0, v80[3]));
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[1 + 2]]] = v78[v80[389 - (271 + 114)]];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[861 - (240 + 619)]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[5 - 2]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[859 - (509 + 348)]] = v80[8 - 5];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1381 - (1014 + 364)];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v3293 = v80[2 - 0];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (2 - 1), v80[5 - 2]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[2 + 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[8 - 5];
							v72 = v72 + (1725 - (1565 + 159));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[6 - 3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[1866 - (1445 + 418)];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v3293 = v80[2 + 0];
							v78[v3293] = v78[v3293](v13(v78, v3293 + 1, v80[1416 - (26 + 1387)]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4 + 0]];
							v72 = v72 + (804 - (355 + 448));
							v80 = v68[v72];
							v78[v80[263 - (246 + 15)]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[1 + 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[1 + 2];
							v72 = v72 + (1120 - (391 + 728));
							v80 = v68[v72];
							v78[v80[1097 - (594 + 501)]] = v80[3 + 0];
							v72 = v72 + (1138 - (730 + 407));
							v80 = v68[v72];
							v3293 = v80[2 + 0];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (1 - 0), v80[7 - 4]));
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[1904 - (438 + 1463)]]] = v78[v80[4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[1 + 2];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1619 - (900 + 717)]] = v78[v80[1139 - (820 + 316)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[6 - 3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1800 - (719 + 1079)]] = v80[6 - 3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3293 = v80[1 + 1];
							v78[v3293] = v78[v3293](v13(v78, v3293 + 1 + 0, v80[4 - 1]));
							v72 = v72 + (204 - (148 + 55));
							v80 = v68[v72];
							v78[v80[1455 - (914 + 539)]][v78[v80[3]]] = v78[v80[3 + 1]];
							v72 = v72 + (561 - (253 + 307));
							v80 = v68[v72];
							v78[v80[1068 - (926 + 140)]] = v80[1061 - (331 + 727)];
							v72 = v72 + (1383 - (1014 + 368));
							v80 = v68[v72];
							v78[v80[1579 - (1035 + 542)]] = v78[v80[81 - (44 + 34)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[1 + 2];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[10 - 7];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3293 = v80[1 + 1];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (669 - (355 + 313)), v80[2 + 1]));
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[3 - 1]][v78[v80[3 + 0]]] = v78[v80[1869 - (762 + 1103)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[2 + 1];
							v72 = v72 + (1568 - (1491 + 76));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[1 + 2]];
							v72 = v72 + (763 - (94 + 668));
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (1410 - (36 + 1373));
							v80 = v68[v72];
							v78[v80[1103 - (58 + 1043)]] = v80[13 - 10];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3293 = v80[2];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (2 - 1), v80[8 - 5]));
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[230 - (35 + 193)]][v78[v80[14 - 11]]] = v78[v80[4]];
							v72 = v72 + (653 - (242 + 410));
							v80 = v68[v72];
							v78[v80[1497 - (1285 + 210)]] = v80[3];
							v72 = v72 + (1740 - (1179 + 560));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[1 + 2]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]] = v80[5 - 2];
							v72 = v72 + (1217 - (262 + 954));
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[7 - 4];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3293 = v80[6 - 4];
							v78[v3293] = v78[v3293](v13(v78, v3293 + 1, v80[2 + 1]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[1845 - (1696 + 146)]]] = v78[v80[4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1908 - (1835 + 71)]] = v80[3];
							v72 = v72 + (635 - (58 + 576));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[83 - (27 + 53)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[1732 - (22 + 1707)];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3293 = v80[892 - (627 + 263)];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (3 - 2), v80[3 - 0]));
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[3]]] = v78[v80[1190 - (255 + 931)]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1390 - (507 + 881)]] = v80[3 - 0];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[6 - 4]] = v78[v80[1606 - (475 + 1128)]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[10 - 7];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[360 - (110 + 247)];
							v72 = v72 + (1247 - (1109 + 137));
							v80 = v68[v72];
							v3293 = v80[2];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (4 - 3), v80[2 + 1]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]][v78[v80[1 + 2]]] = v78[v80[4 + 0]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[2 + 1];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[11 - 8];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3293 = v80[2 + 0];
							v78[v3293] = v78[v3293](v13(v78, v3293 + (3 - 2), v80[3]));
							v72 = v72 + (206 - (192 + 13));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[760 - (585 + 172)]]] = v78[v80[8 - 4]];
							v72 = v72 + (797 - (76 + 720));
							v80 = v68[v72];
							v78[v80[2]] = v80[7 - 4];
							v72 = v72 + (133 - (45 + 87));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[4 - 1]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[10 - 7];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[2 + 1];
							v72 = v72 + (1284 - (61 + 1222));
							v80 = v68[v72];
							v3293 = v80[1505 - (628 + 875)];
							v78[v3293] = v78[v3293](v13(v78, v3293 + 1, v80[3 + 0]));
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[5 - 3]][v78[v80[3]]] = v78[v80[1926 - (590 + 1332)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v80[9 - 6];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1628 - (173 + 1453)]] = v78[v80[851 - (237 + 611)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[11 - 8];
						end
					elseif (v81 <= 186) then
						if (v81 == (91 + 94)) then
							local v3378 = 0;
							local v3379;
							local v3380;
							local v3381;
							while true do
								if (v3378 == 2) then
									v80 = v68[v72];
									v78[v80[4 - 2]] = v78[v80[7 - 4]][v78[v80[4]]];
									v72 = v72 + (376 - (129 + 246));
									v80 = v68[v72];
									v3378 = 7 - 4;
								end
								if (v3378 == (1092 - (83 + 1009))) then
									v3379 = nil;
									v3380 = nil;
									v3381 = nil;
									v78[v80[2]] = {};
									v3378 = 874 - (506 + 367);
								end
								if (v3378 == 6) then
									for v6893 = 1, v3379 do
										v3380[v6893] = v78[v3381 + v6893];
									end
									break;
								end
								if ((v3378 == 3) or (1296 == 4060)) then
									v78[v80[9 - 7]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[360 - (72 + 286)]] = v80[3 + 0];
									v3378 = 138 - (107 + 27);
								end
								if (v3378 == (1 + 4)) then
									v80 = v68[v72];
									v3381 = v80[3 - 1];
									v3380 = v78[v3381];
									v3379 = v80[14 - 11];
									v3378 = 6;
								end
								if (v3378 == (1 + 0)) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3];
									v72 = v72 + 1;
									v3378 = 2;
								end
								if ((4 == v3378) or (2234 < 1197)) then
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[397 - (304 + 91)]] = v78[v80[3]][v78[v80[3 + 1]]];
									v72 = v72 + (3 - 2);
									v3378 = 4 + 1;
								end
							end
						else
							local v3382 = 0;
							while true do
								if ((154 < 2530) and (v3382 == 8)) then
									v78[v80[2 - 0]] = {};
									v72 = v72 + 1;
									v80 = v68[v72];
									v3382 = 1569 - (648 + 912);
								end
								if ((3688 >= 963) and (v3382 == (16 - 10))) then
									v78[v80[2]] = v80[8 - 5];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3382 = 7;
								end
								if (v3382 == (452 - (206 + 239))) then
									v78[v80[2]] = v78[v80[1423 - (956 + 464)]][v78[v80[272 - (159 + 109)]]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3382 = 8;
								end
								if (v3382 == (680 - (239 + 440))) then
									v78[v80[5 - 3]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3382 = 2;
								end
								if (v3382 == (1728 - (1664 + 64))) then
									v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[3 + 1]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v3382 = 1 + 0;
								end
								if (v3382 == 2) then
									v78[v80[2]] = v78[v80[1 + 2]][v78[v80[1518 - (1421 + 93)]]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v3382 = 1151 - (1049 + 99);
								end
								if ((v3382 == (3 + 0)) or (1864 == 600)) then
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3382 = 1252 - (871 + 377);
								end
								if ((1320 == 1320) and (v3382 == 9)) then
									v78[v80[2 + 0]] = v80[1780 - (1238 + 539)];
									break;
								end
								if ((577 - (206 + 366)) == v3382) then
									v78[v80[2]][v78[v80[529 - (489 + 37)]]] = v78[v80[8 - 4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3382 = 8 - 2;
								end
								if (v3382 == (2 + 2)) then
									v78[v80[1 + 1]][v78[v80[6 - 3]]] = v78[v80[4]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v3382 = 1 + 4;
								end
							end
						end
					elseif (v81 > (12 + 175)) then
						local v3383 = 0;
						local v3384;
						local v3385;
						local v3386;
						while true do
							if ((4951 >= 1563) and (v3383 == (3 - 1))) then
								if (v3385 > 0) then
									if (v3386 <= v78[v3384 + 1 + 0]) then
										v72 = v80[1290 - (254 + 1033)];
										v78[v3384 + 3 + 0] = v3386;
									end
								elseif ((1291 < 4426) and (v3386 >= v78[v3384 + 1])) then
									local v6916 = 1762 - (1099 + 663);
									while true do
										if ((4462 > 1837) and (v6916 == (807 - (504 + 303)))) then
											v72 = v80[3 + 0];
											v78[v3384 + (14 - 11)] = v3386;
											break;
										end
									end
								end
								break;
							end
							if (v3383 == (0 - 0)) then
								v3384 = v80[2];
								v3385 = v78[v3384 + (5 - 3)];
								v3383 = 240 - (155 + 84);
							end
							if ((v3383 == (3 - 2)) or (217 >= 1513)) then
								v3386 = v78[v3384] + v3385;
								v78[v3384] = v3386;
								v3383 = 6 - 4;
							end
						end
					else
						local v3387;
						v3387 = v80[2 + 0];
						v78[v3387] = v78[v3387](v13(v78, v3387 + (1426 - (557 + 868)), v80[3]));
						v72 = v72 + (608 - (33 + 574));
						v80 = v68[v72];
						v78[v80[1567 - (839 + 726)]][v78[v80[4 - 1]]] = v78[v80[4]];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[333 - (124 + 207)]] = v80[5 - 2];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2 - 0]] = v78[v80[10 - 7]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[2]] = v80[1 + 2];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v80[2 + 1];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v3387 = v80[2 + 0];
						v78[v3387] = v78[v3387](v13(v78, v3387 + (2 - 1), v80[3 + 0]));
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]][v78[v80[8 - 5]]] = v78[v80[9 - 5]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 - 0]] = v80[3 + 0];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[4 - 2]] = v78[v80[4 - 1]];
						v72 = v72 + (1011 - (15 + 995));
						v80 = v68[v72];
						v78[v80[3 - 1]] = v80[3 + 0];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1 + 1]] = v80[40 - (34 + 3)];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v3387 = v80[1 + 1];
						v78[v3387] = v78[v3387](v13(v78, v3387 + (3 - 2), v80[624 - (477 + 144)]));
						v72 = v72 + (971 - (797 + 173));
						v80 = v68[v72];
						v78[v80[1263 - (161 + 1100)]][v78[v80[3]]] = v78[v80[1340 - (1150 + 186)]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[2 + 1];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[3]];
						v72 = v72 + (30 - (12 + 17));
						v80 = v68[v72];
						v78[v80[2]] = v80[3 - 0];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[283 - (68 + 213)]] = v80[7 - 4];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v3387 = v80[1 + 1];
						v78[v3387] = v78[v3387](v13(v78, v3387 + (1 - 0), v80[3 + 0]));
						v72 = v72 + (1383 - (349 + 1033));
						v80 = v68[v72];
						v78[v80[2]][v78[v80[357 - (68 + 286)]]] = v78[v80[1 + 3]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[4 - 2]] = v80[2 + 1];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[7 - 5]] = v78[v80[7 - 4]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[5 - 3]] = v80[3];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v80[2 + 1];
						v72 = v72 + (1198 - (1064 + 133));
						v80 = v68[v72];
						v3387 = v80[2];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1, v80[10 - 7]));
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[4 + 0]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[5 - 3]] = v80[3];
						v72 = v72 + (1634 - (670 + 963));
						v80 = v68[v72];
						v78[v80[1 + 1]] = v78[v80[1102 - (1034 + 65)]];
						v72 = v72 + (50 - (5 + 44));
						v80 = v68[v72];
						v78[v80[1 + 1]] = v80[3];
						v72 = v72 + (46 - (25 + 20));
						v80 = v68[v72];
						v78[v80[2 - 0]] = v80[1978 - (1535 + 440)];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v3387 = v80[621 - (477 + 142)];
						v78[v3387] = v78[v3387](v13(v78, v3387 + (1345 - (1324 + 20)), v80[3 + 0]));
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2 + 0]][v78[v80[7 - 4]]] = v78[v80[4]];
						v72 = v72 + (1619 - (818 + 800));
						v80 = v68[v72];
						v78[v80[231 - (163 + 66)]] = v80[14 - 11];
						v72 = v72 + (88 - (40 + 47));
						v80 = v68[v72];
						v78[v80[637 - (146 + 489)]] = v78[v80[2 + 1]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1389 - (499 + 888)]] = v80[2 + 1];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[3 - 1]] = v80[10 - 7];
						v72 = v72 + 1;
						v80 = v68[v72];
						v3387 = v80[3 - 1];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1, v80[747 - (522 + 222)]));
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1487 - (72 + 1413)]][v78[v80[1206 - (216 + 987)]]] = v78[v80[4 + 0]];
						v72 = v72 + (4 - 3);
						v80 = v68[v72];
						v78[v80[1413 - (1300 + 111)]] = v80[1084 - (1055 + 26)];
						v72 = v72 + (644 - (475 + 168));
						v80 = v68[v72];
						v78[v80[1369 - (302 + 1065)]] = v78[v80[3]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1 + 1]] = v80[3];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1320 - (917 + 401)]] = v80[1273 - (631 + 639)];
						v72 = v72 + 1;
						v80 = v68[v72];
						v3387 = v80[2];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1, v80[1703 - (654 + 1046)]));
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 + 0]][v78[v80[1602 - (1007 + 592)]]] = v78[v80[18 - 14]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[2]] = v80[2 + 1];
						v72 = v72 + (4 - 3);
						v80 = v68[v72];
						v78[v80[5 - 3]] = v78[v80[11 - 8]];
						v72 = v72 + (323 - (26 + 296));
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[11 - 8];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[819 - (418 + 399)]] = v80[3];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v3387 = v80[2];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1 + 0, v80[3]));
						v72 = v72 + (708 - (314 + 393));
						v80 = v68[v72];
						v78[v80[7 - 5]][v78[v80[173 - (82 + 88)]]] = v78[v80[4 + 0]];
						v72 = v72 + (148 - (95 + 52));
						v80 = v68[v72];
						v78[v80[2]] = v80[1 + 2];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[8 - 5]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[835 - (8 + 825)]] = v80[2 + 1];
						v72 = v72 + (1641 - (471 + 1169));
						v80 = v68[v72];
						v78[v80[2]] = v80[3 + 0];
						v72 = v72 + 1;
						v80 = v68[v72];
						v3387 = v80[1 + 1];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1, v80[14 - 11]));
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[2 + 0]][v78[v80[1 + 2]]] = v78[v80[1 + 3]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[445 - (365 + 78)]] = v80[226 - (200 + 23)];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[1 + 1]] = v78[v80[3 + 0]];
						v72 = v72 + (380 - (373 + 6));
						v80 = v68[v72];
						v78[v80[7 - 5]] = v80[4 - 1];
						v72 = v72 + (923 - (519 + 403));
						v80 = v68[v72];
						v78[v80[1523 - (1435 + 86)]] = v80[180 - (97 + 80)];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v3387 = v80[2];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1, v80[3]));
						v72 = v72 + (703 - (366 + 336));
						v80 = v68[v72];
						v78[v80[607 - (4 + 601)]][v78[v80[3 + 0]]] = v78[v80[672 - (128 + 540)]];
						v72 = v72 + (570 - (341 + 228));
						v80 = v68[v72];
						v78[v80[1790 - (231 + 1557)]] = v80[3];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[8 - 6]] = v78[v80[2 + 1]];
						v72 = v72 + (1352 - (1329 + 22));
						v80 = v68[v72];
						v78[v80[705 - (27 + 676)]] = v80[11 - 8];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2]] = v80[1694 - (219 + 1472)];
						v72 = v72 + 1;
						v80 = v68[v72];
						v3387 = v80[1 + 1];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1 + 0, v80[391 - (162 + 226)]));
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[1 + 1]][v78[v80[6 - 3]]] = v78[v80[894 - (224 + 666)]];
						v72 = v72 + (1681 - (345 + 1335));
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[3];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[7 - 5]] = v78[v80[3 + 0]];
						v72 = v72 + (366 - (18 + 347));
						v80 = v68[v72];
						v78[v80[974 - (556 + 416)]] = v80[1702 - (797 + 902)];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[8 - 6]] = v80[3];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v3387 = v80[1074 - (632 + 440)];
						v78[v3387] = v78[v3387](v13(v78, v3387 + (1 - 0), v80[1212 - (705 + 504)]));
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2 - 0]][v78[v80[6 - 3]]] = v78[v80[1921 - (1300 + 617)]];
						v72 = v72 + (4 - 3);
						v80 = v68[v72];
						v78[v80[1924 - (36 + 1886)]] = v80[11 - 8];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[618 - (305 + 311)]] = v78[v80[2 + 1]];
						v72 = v72 + (1456 - (1093 + 362));
						v80 = v68[v72];
						v78[v80[2]] = v80[3];
						v72 = v72 + (1099 - (734 + 364));
						v80 = v68[v72];
						v78[v80[2]] = v80[1011 - (374 + 634)];
						v72 = v72 + 1;
						v80 = v68[v72];
						v3387 = v80[1 + 1];
						v78[v3387] = v78[v3387](v13(v78, v3387 + 1, v80[1120 - (331 + 786)]));
						v72 = v72 + (1097 - (759 + 337));
						v80 = v68[v72];
						v78[v80[5 - 3]][v78[v80[567 - (255 + 309)]]] = v78[v80[497 - (484 + 9)]];
					end
				elseif (v81 <= 201) then
					if (v81 <= 194) then
						if (v81 <= (181 + 10)) then
							if ((1980 > 362) and (v81 <= (326 - 137))) then
								local v795;
								v795 = v80[2 + 0];
								v78[v795] = v78[v795](v13(v78, v795 + 1, v80[5 - 2]));
								v72 = v72 + (1451 - (341 + 1109));
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3]]] = v78[v80[2 + 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[662 - (483 + 176)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1282 - (47 + 1233)]] = v80[3 + 0];
								v72 = v72 + (615 - (421 + 193));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[4 - 1];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v795 = v80[2];
								v78[v795] = v78[v795](v13(v78, v795 + (4 - 3), v80[2 + 1]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[1 + 2]]] = v78[v80[9 - 5]];
								v72 = v72 + (1845 - (463 + 1381));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1 + 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[6 - 3]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[1163 - (696 + 465)]] = v80[563 - (14 + 546)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1442 - (413 + 1027)]] = v80[1819 - (1382 + 434)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v795 = v80[5 - 3];
								v78[v795] = v78[v795](v13(v78, v795 + (1525 - (86 + 1438)), v80[724 - (692 + 29)]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[12 - 8]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[3 + 0]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[60 - (11 + 47)]] = v80[5 - 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v795 = v80[451 - (287 + 162)];
								v78[v795] = v78[v795](v13(v78, v795 + 1 + 0, v80[1632 - (10 + 1619)]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1272 - (403 + 867)]] = v80[355 - (310 + 42)];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[2 + 1]];
								v72 = v72 + (1446 - (1170 + 275));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[10 - 7];
								v72 = v72 + (684 - (424 + 259));
								v80 = v68[v72];
								v78[v80[7 - 5]] = v80[1067 - (289 + 775)];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v795 = v80[4 - 2];
								v78[v795] = v78[v795](v13(v78, v795 + (3 - 2), v80[6 - 3]));
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[9 - 7]][v78[v80[1893 - (946 + 944)]]] = v78[v80[10 - 6]];
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3 - 0];
								v72 = v72 + (1444 - (949 + 494));
								v80 = v68[v72];
								v78[v80[1232 - (505 + 725)]] = v78[v80[8 - 5]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v80[5 - 2];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v795 = v80[1953 - (1928 + 23)];
								v78[v795] = v78[v795](v13(v78, v795 + 1, v80[1 + 2]));
								v72 = v72 + (4 - 3);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[3]]] = v78[v80[4 - 0]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[238 - (40 + 196)]] = v78[v80[1020 - (845 + 172)]];
								v72 = v72 + (1282 - (423 + 858));
								v80 = v68[v72];
								v78[v80[1704 - (1520 + 182)]] = v80[1469 - (196 + 1270)];
								v72 = v72 + (1807 - (763 + 1043));
								v80 = v68[v72];
								v78[v80[8 - 6]] = v80[3];
								v72 = v72 + (1276 - (1144 + 131));
								v80 = v68[v72];
								v795 = v80[2];
								v78[v795] = v78[v795](v13(v78, v795 + (1 - 0), v80[3]));
								v72 = v72 + (530 - (458 + 71));
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[4 - 1]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[3]];
								v72 = v72 + (1774 - (775 + 998));
								v80 = v68[v72];
								v78[v80[146 - (78 + 66)]] = v80[3 + 0];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1046 - (437 + 607)]] = v80[3];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v795 = v80[33 - (30 + 1)];
								v78[v795] = v78[v795](v13(v78, v795 + (812 - (786 + 25)), v80[11 - 8]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]][v78[v80[2 + 1]]] = v78[v80[8 - 4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[67 - (9 + 55)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[767 - (256 + 509)]] = v78[v80[1963 - (1497 + 463)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[958 - (567 + 389)]] = v80[3];
								v72 = v72 + (61 - (14 + 46));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[4 - 1];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v795 = v80[818 - (301 + 515)];
								v78[v795] = v78[v795](v13(v78, v795 + (538 - (45 + 492)), v80[1 + 2]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[2 + 2]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[645 - (228 + 415)]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[6 - 3];
								v72 = v72 + (255 - (147 + 107));
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[1035 - (925 + 107)];
								v72 = v72 + (473 - (375 + 97));
								v80 = v68[v72];
								v795 = v80[6 - 4];
								v78[v795] = v78[v795](v13(v78, v795 + 1 + 0, v80[8 - 5]));
								v72 = v72 + (1575 - (298 + 1276));
								v80 = v68[v72];
								v78[v80[1782 - (1225 + 555)]][v78[v80[1 + 2]]] = v78[v80[5 - 1]];
								v72 = v72 + (290 - (75 + 214));
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[454 - (366 + 85)];
								v72 = v72 + (854 - (380 + 473));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[4 - 1]];
								v72 = v72 + (1570 - (934 + 635));
								v80 = v68[v72];
								v78[v80[682 - (266 + 414)]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3];
								v72 = v72 + 1;
								v80 = v68[v72];
								v795 = v80[547 - (62 + 483)];
								v78[v795] = v78[v795](v13(v78, v795 + (1635 - (904 + 730)), v80[4 - 1]));
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1228 - (371 + 855)]][v78[v80[3]]] = v78[v80[8 - 4]];
								v72 = v72 + (1213 - (749 + 463));
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[3 + 0];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[3 - 1]] = v78[v80[3]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[9 - 6];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[1 + 2];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v795 = v80[1 + 1];
								v78[v795] = v78[v795](v13(v78, v795 + (3 - 2), v80[1 + 2]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]][v78[v80[1 + 2]]] = v78[v80[6 - 2]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[46 - (5 + 39)]] = v80[3];
								v72 = v72 + (1277 - (20 + 1256));
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[659 - (616 + 40)]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[3 - 0];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[656 - (82 + 572)]] = v80[3];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v795 = v80[4 - 2];
								v78[v795] = v78[v795](v13(v78, v795 + (711 - (349 + 361)), v80[705 - (552 + 150)]));
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[804 - (521 + 281)]][v78[v80[121 - (15 + 103)]]] = v78[v80[1413 - (974 + 435)]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3 + 0];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3 + 0]];
								v72 = v72 + (1103 - (925 + 177));
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								v72 = v72 + (20 - (12 + 7));
								v80 = v68[v72];
								v795 = v80[2];
								v78[v795] = v78[v795](v13(v78, v795 + 1 + 0, v80[3]));
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[3 - 1]][v78[v80[2 + 1]]] = v78[v80[9 - 5]];
							elseif ((1346 == 1346) and (v81 == 190)) then
								v78[v80[7 - 5]][v78[v80[5 - 2]]] = v78[v80[4]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[369 - (198 + 168)];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[4 + 0]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[3];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[5 - 3]][v78[v80[5 - 2]]] = v78[v80[64 - (4 + 56)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]][v78[v80[9 - 6]]] = v78[v80[4 + 0]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 - 0]] = v80[3];
								v72 = v72 + (1899 - (1270 + 628));
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[1325 - (570 + 752)]][v78[v80[1465 - (958 + 503)]]];
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[2 + 0]] = {};
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[2 + 1];
							else
								local v3493 = 0 + 0;
								local v3494;
								local v3495;
								local v3496;
								while true do
									if ((1705 == 1705) and ((15 - 10) == v3493)) then
										v80 = v68[v72];
										v3496 = v80[4 - 2];
										v3495 = v78[v3496];
										v3494 = v80[932 - (799 + 130)];
										v3493 = 6;
									end
									if ((3 + 0) == v3493) then
										v78[v80[1 + 1]] = {};
										v72 = v72 + 1;
										v80 = v68[v72];
										v78[v80[9 - 7]] = v80[1 + 2];
										v3493 = 4;
									end
									if ((2667 == 2667) and (v3493 == 6)) then
										for v6896 = 2 - 1, v3494 do
											v3495[v6896] = v78[v3496 + v6896];
										end
										break;
									end
									if (v3493 == (1440 - (772 + 664))) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1 + 1]] = v78[v80[3]][v78[v80[1077 - (46 + 1027)]]];
										v72 = v72 + (1354 - (467 + 886));
										v3493 = 6 - 1;
									end
									if ((3 - 1) == v3493) then
										v80 = v68[v72];
										v78[v80[685 - (582 + 101)]] = v78[v80[748 - (574 + 171)]][v78[v80[4 + 0]]];
										v72 = v72 + (368 - (66 + 301));
										v80 = v68[v72];
										v3493 = 3;
									end
									if ((2579 == 2579) and (0 == v3493)) then
										v3494 = nil;
										v3495 = nil;
										v3496 = nil;
										v78[v80[2]] = {};
										v3493 = 482 - (423 + 58);
									end
									if (v3493 == 1) then
										v72 = v72 + 1 + 0;
										v80 = v68[v72];
										v78[v80[1082 - (141 + 939)]] = v80[684 - (532 + 149)];
										v72 = v72 + 1 + 0;
										v3493 = 920 - (592 + 326);
									end
								end
							end
						elseif (v81 <= (693 - 501)) then
							v78[v80[9 - 7]][v78[v80[1 + 2]]] = v78[v80[829 - (467 + 358)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[8 - 6]] = v80[3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[9 - 6]][v78[v80[4]]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1828 - (233 + 1593)]] = v80[5 - 2];
							v72 = v72 + (763 - (28 + 734));
							v80 = v68[v72];
							v78[v80[2 - 0]][v78[v80[1134 - (337 + 794)]]] = v78[v80[3 + 1]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[4 + 0]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[6 - 4]] = v80[705 - (342 + 360)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3]][v78[v80[4]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1001 - (440 + 559)]] = {};
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
						elseif ((v81 == (771 - (150 + 428))) or (2363 < 1423)) then
							local v3497;
							v78[v80[1 + 1]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[160 - (15 + 142)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[3 + 0];
							v72 = v72 + (1677 - (757 + 919));
							v80 = v68[v72];
							v3497 = v80[1 + 1];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (4 - 3), v80[3]));
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[10 - 6]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]] = v80[54 - (8 + 43)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v78[v80[1 + 2]];
							v72 = v72 + (297 - (236 + 60));
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[1 + 2];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v3497 = v80[6 - 4];
							v78[v3497] = v78[v3497](v13(v78, v3497 + 1 + 0, v80[3]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[5 - 3]][v78[v80[3 + 0]]] = v78[v80[272 - (35 + 233)]];
							v72 = v72 + (1898 - (547 + 1350));
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[12 - 9];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[604 - (593 + 9)]] = v80[3];
							v72 = v72 + (1396 - (298 + 1097));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[14 - 11];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v3497 = v80[2];
							v78[v3497] = v78[v3497](v13(v78, v3497 + 1, v80[837 - (479 + 355)]));
							v72 = v72 + (397 - (175 + 221));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[6 - 3]]] = v78[v80[2 + 2]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[8 - 5]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (1326 - (471 + 854));
							v80 = v68[v72];
							v78[v80[809 - (55 + 752)]] = v80[3];
							v72 = v72 + (386 - (97 + 288));
							v80 = v68[v72];
							v3497 = v80[1437 - (317 + 1118)];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (1890 - (198 + 1691)), v80[2 + 1]));
							v72 = v72 + (601 - (263 + 337));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[1014 - (577 + 433)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2]] = v80[2 + 1];
							v72 = v72 + (987 - (185 + 801));
							v80 = v68[v72];
							v78[v80[516 - (270 + 244)]] = v78[v80[6 - 3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[5 - 2];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3497 = v80[2];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (1264 - (653 + 610)), v80[1783 - (1358 + 422)]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1153 - (123 + 1028)]][v78[v80[4 - 1]]] = v78[v80[621 - (469 + 148)]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[3 + 0];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[9 - 7]] = v78[v80[13 - 10]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[1433 - (187 + 1243)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1906 - (1011 + 893)]] = v80[1 + 2];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3497 = v80[1483 - (1349 + 132)];
							v78[v3497] = v78[v3497](v13(v78, v3497 + 1, v80[3]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[1420 - (921 + 495)]];
							v72 = v72 + (757 - (112 + 644));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[2 + 1];
							v72 = v72 + (279 - (140 + 138));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[3 + 0]];
							v72 = v72 + (265 - (74 + 190));
							v80 = v68[v72];
							v78[v80[1354 - (233 + 1119)]] = v80[3 + 0];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 - 0]] = v80[2 + 1];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3497 = v80[507 - (248 + 257)];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (1 - 0), v80[3]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1493 - (1472 + 19)]][v78[v80[3 + 0]]] = v78[v80[4]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2]] = v80[275 - (120 + 152)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[2 + 1]];
							v72 = v72 + (1217 - (401 + 815));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[7 - 4];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v3497 = v80[2];
							v78[v3497] = v78[v3497](v13(v78, v3497 + 1 + 0, v80[3 + 0]));
							v72 = v72 + (761 - (51 + 709));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3]]] = v78[v80[113 - (33 + 76)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[5 - 2];
							v72 = v72 + (551 - (154 + 396));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[3 + 0]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1514 - (24 + 1488)]] = v80[3];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + (428 - (246 + 181));
							v80 = v68[v72];
							v3497 = v80[2 + 0];
							v78[v3497] = v78[v3497](v13(v78, v3497 + 1, v80[3 + 0]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]][v78[v80[3 + 0]]] = v78[v80[1863 - (413 + 1446)]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (1977 - (29 + 1947));
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[5 - 2]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[2 + 1];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[7 - 4];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v3497 = v80[2];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (2 - 1), v80[405 - (74 + 328)]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[655 - (144 + 509)]][v78[v80[3 + 0]]] = v78[v80[4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[2 + 1];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v78[v80[1366 - (319 + 1044)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[7 - 5]] = v80[633 - (14 + 616)];
							v72 = v72 + (579 - (303 + 275));
							v80 = v68[v72];
							v78[v80[1852 - (1659 + 191)]] = v80[2 + 1];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3497 = v80[570 - (205 + 363)];
							v78[v3497] = v78[v3497](v13(v78, v3497 + 1, v80[5 - 2]));
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[576 - (147 + 427)]][v78[v80[3]]] = v78[v80[5 - 1]];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v78[v80[2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 - 0]] = v78[v80[5 - 2]];
							v72 = v72 + (1229 - (1108 + 120));
							v80 = v68[v72];
							v78[v80[6 - 4]] = v80[654 - (303 + 348)];
							v72 = v72 + (312 - (242 + 69));
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[216 - (172 + 41)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3497 = v80[1 + 1];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (139 - (40 + 98)), v80[8 - 5]));
							v72 = v72 + (798 - (161 + 636));
							v80 = v68[v72];
							v78[v80[2]][v78[v80[14 - 11]]] = v78[v80[6 - 2]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3 + 0];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[631 - (123 + 506)]] = v78[v80[3]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2]] = v80[1905 - (296 + 1606)];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3 + 0];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3497 = v80[2];
							v78[v3497] = v78[v3497](v13(v78, v3497 + (1620 - (863 + 756)), v80[3]));
							v72 = v72 + (1425 - (39 + 1385));
							v80 = v68[v72];
							v78[v80[761 - (52 + 707)]][v78[v80[2 + 1]]] = v78[v80[449 - (358 + 87)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[10 - 7];
							v72 = v72 + (1335 - (27 + 1307));
							v80 = v68[v72];
							v78[v80[3 - 1]] = v78[v80[3 + 0]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v80[1 + 2];
						else
							local v3575 = v80[5 - 3];
							local v3576, v3577 = v71(v78[v3575](v78[v3575 + (264 - (152 + 111))]));
							v73 = (v3577 + v3575) - (1 + 0);
							local v3578 = 0 - 0;
							for v4508 = v3575, v73 do
								v3578 = v3578 + 1 + 0;
								v78[v4508] = v3576[v3578];
							end
						end
					elseif ((v81 <= (721 - 524)) or (3665 <= 1377)) then
						if (v81 <= (560 - 365)) then
							local v903 = 0;
							local v904;
							while true do
								if (v903 == (10 + 16)) then
									v72 = v72 + (282 - (32 + 249));
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1057 - (793 + 261)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v903 = 55 - 28;
								end
								if ((v903 == 1) or (137 == 3142)) then
									v72 = v72 + (228 - (109 + 118));
									v80 = v68[v72];
									v904 = v80[1 + 1];
									v78[v904] = v78[v904](v13(v78, v904 + (596 - (115 + 480)), v80[1 + 2]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[1416 - (547 + 866)]]] = v78[v80[266 - (259 + 3)]];
									v72 = v72 + 1 + 0;
									v903 = 4 - 2;
								end
								if (v903 == 16) then
									v78[v80[1421 - (891 + 528)]][v78[v80[4 - 1]]] = v78[v80[2 + 2]];
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v78[v80[5 - 2]];
									v72 = v72 + (3 - 2);
									v903 = 17;
								end
								if (v903 == 28) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1953 - (1144 + 807)]] = v78[v80[2 + 1]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v903 = 62 - 33;
								end
								if (v903 == (11 + 3)) then
									v78[v80[2]] = v80[4 - 1];
									v72 = v72 + (1113 - (930 + 182));
									v80 = v68[v72];
									v78[v80[1836 - (1429 + 405)]] = v78[v80[780 - (641 + 136)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[10 - 7];
									v72 = v72 + 1;
									v903 = 15;
								end
								if (v903 == (3 + 27)) then
									v72 = v72 + (714 - (87 + 626));
									v80 = v68[v72];
									v78[v80[3 - 1]][v78[v80[1288 - (1261 + 24)]]] = v78[v80[4 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2]] = v80[10 - 7];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v903 = 31;
								end
								if (8 == v903) then
									v78[v80[2 + 0]] = v80[1 + 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v904 = v80[8 - 6];
									v78[v904] = v78[v904](v13(v78, v904 + (858 - (822 + 35)), v80[1788 - (360 + 1425)]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[3 + 0]]] = v78[v80[300 - (283 + 13)]];
									v903 = 17 - 8;
								end
								if (v903 == (6 + 3)) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[4 - 1];
									v72 = v72 + (1031 - (810 + 220));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[3 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v903 = 221 - (195 + 16);
								end
								if (v903 == (52 - 29)) then
									v80 = v68[v72];
									v78[v80[8 - 6]][v78[v80[1 + 2]]] = v78[v80[4]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[2 + 1];
									v72 = v72 + (586 - (92 + 493));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[2 + 1]];
									v903 = 1182 - (75 + 1083);
								end
								if (v903 == (0 - 0)) then
									v904 = nil;
									v78[v80[3 - 1]] = v78[v80[14 - 11]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[13 - 10];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1377 - (159 + 1216)]] = v80[10 - 7];
									v903 = 1 - 0;
								end
								if (v903 == 5) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[8 - 5];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1617 - (418 + 1197)]] = v80[967 - (632 + 332)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v903 = 1604 - (964 + 634);
								end
								if ((1472 < 4542) and (v903 == (40 - 21))) then
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3 + 0]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3];
									v903 = 35 - 15;
								end
								if ((v903 == (30 - 17)) or (924 >= 1912)) then
									v80 = v68[v72];
									v904 = v80[1653 - (1559 + 92)];
									v78[v904] = v78[v904](v13(v78, v904 + 1 + 0, v80[2 + 1]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[39 - (9 + 28)]][v78[v80[2 + 1]]] = v78[v80[11 - 7]];
									v72 = v72 + (1953 - (922 + 1030));
									v80 = v68[v72];
									v903 = 397 - (345 + 38);
								end
								if (v903 == 20) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v904 = v80[2];
									v78[v904] = v78[v904](v13(v78, v904 + 1, v80[1 + 2]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[9 - 6]]] = v78[v80[564 - (546 + 14)]];
									v72 = v72 + (1068 - (7 + 1060));
									v903 = 19 + 2;
								end
								if (v903 == 18) then
									v78[v904] = v78[v904](v13(v78, v904 + (3 - 2), v80[3]));
									v72 = v72 + (401 - (256 + 144));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[125 - (7 + 115)]]] = v78[v80[4]];
									v72 = v72 + (535 - (21 + 513));
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1;
									v903 = 1296 - (59 + 1218);
								end
								if (v903 == (21 - 10)) then
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[3]]] = v78[v80[4]];
									v72 = v72 + (187 - (155 + 31));
									v80 = v68[v72];
									v78[v80[2 - 0]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v903 = 12;
								end
								if ((v903 == (3 + 0)) or (340 >= 571)) then
									v72 = v72 + (1992 - (1417 + 574));
									v80 = v68[v72];
									v78[v80[154 - (112 + 40)]] = v80[6 - 3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v904 = v80[686 - (326 + 358)];
									v78[v904] = v78[v904](v13(v78, v904 + (833 - (4 + 828)), v80[8 - 5]));
									v72 = v72 + (1718 - (85 + 1632));
									v903 = 4;
								end
								if (v903 == (15 + 2)) then
									v80 = v68[v72];
									v78[v80[1141 - (1096 + 43)]] = v80[421 - (176 + 242)];
									v72 = v72 + (913 - (313 + 599));
									v80 = v68[v72];
									v78[v80[2]] = v80[642 - (402 + 237)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v904 = v80[1058 - (551 + 505)];
									v903 = 60 - 42;
								end
								if ((3065 == 3065) and ((15 - 9) == v903)) then
									v904 = v80[435 - (268 + 165)];
									v78[v904] = v78[v904](v13(v78, v904 + 1, v80[1 + 2]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[7 - 4]]] = v78[v80[1776 - (238 + 1534)]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[920 - (302 + 616)]] = v80[3 + 0];
									v903 = 1835 - (1054 + 774);
								end
								if (v903 == 10) then
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1327 - (240 + 1085)]] = v80[1230 - (1220 + 7)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v904 = v80[1971 - (1819 + 150)];
									v78[v904] = v78[v904](v13(v78, v904 + 1 + 0, v80[3 + 0]));
									v903 = 8 + 3;
								end
								if (v903 == (1 + 1)) then
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3 + 0];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 - 0]] = v78[v80[1367 - (229 + 1135)]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[1 + 2];
									v903 = 3;
								end
								if (v903 == (12 + 12)) then
									v72 = v72 + (783 - (289 + 493));
									v80 = v68[v72];
									v78[v80[2]] = v80[1 + 2];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[6 - 3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v903 = 4 + 21;
								end
								if (v903 == (1310 - (1170 + 118))) then
									v72 = v72 + (1810 - (817 + 992));
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[13 - 10];
									v72 = v72 + (1173 - (852 + 320));
									v80 = v68[v72];
									v904 = v80[2 + 0];
									v78[v904] = v78[v904](v13(v78, v904 + 1, v80[804 - (731 + 70)]));
									v72 = v72 + (1 - 0);
									v903 = 621 - (17 + 581);
								end
								if (v903 == 31) then
									v78[v80[1325 - (470 + 853)]] = v78[v80[67 - (30 + 34)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[223 - (180 + 40)];
									break;
								end
								if ((3257 > 1624) and (v903 == (18 - 11))) then
									v72 = v72 + (179 - (11 + 167));
									v80 = v68[v72];
									v78[v80[1641 - (127 + 1512)]] = v78[v80[3]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v903 = 19 - 11;
								end
								if (v903 == (75 - 46)) then
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[890 - (304 + 584)]] = v80[6 - 3];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v904 = v80[2 - 0];
									v78[v904] = v78[v904](v13(v78, v904 + 1 + 0, v80[14 - 11]));
									v903 = 1691 - (997 + 664);
								end
								if (15 == v903) then
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v904 = v80[2 + 0];
									v78[v904] = v78[v904](v13(v78, v904 + (985 - (231 + 753)), v80[4 - 1]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v903 = 1594 - (615 + 963);
								end
								if ((v903 == 4) or (1526 > 1822)) then
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + (1805 - (863 + 941));
									v80 = v68[v72];
									v78[v80[840 - (461 + 377)]] = v78[v80[3]];
									v903 = 5 + 0;
								end
								if ((6 + 15) == v903) then
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + (1273 - (455 + 817));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3]];
									v72 = v72 + (833 - (123 + 709));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[1697 - (618 + 1076)];
									v903 = 41 - 19;
								end
								if (v903 == 27) then
									v78[v80[8 - 6]] = v80[3 + 0];
									v72 = v72 + (945 - (657 + 287));
									v80 = v68[v72];
									v904 = v80[7 - 5];
									v78[v904] = v78[v904](v13(v78, v904 + (1852 - (1256 + 595)), v80[3 + 0]));
									v72 = v72 + (75 - (59 + 15));
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[2 + 2]];
									v903 = 14 + 14;
								end
								if ((777 - (406 + 346)) == v903) then
									v904 = v80[4 - 2];
									v78[v904] = v78[v904](v13(v78, v904 + (3 - 2), v80[2 + 1]));
									v72 = v72 + (192 - (127 + 64));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[948 - (70 + 875)]]] = v78[v80[6 - 2]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v903 = 16 + 10;
								end
								if ((1530 == 1530) and (v903 == (11 + 1))) then
									v78[v80[1591 - (1039 + 550)]] = v78[v80[205 - (35 + 167)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1215 - (103 + 1110)]] = v80[1117 - (540 + 574)];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1396 - (1283 + 111)]] = v80[355 - (204 + 148)];
									v72 = v72 + (1 - 0);
									v903 = 11 + 2;
								end
							end
						elseif (v81 > 196) then
							v78[v80[1 + 1]][v78[v80[553 - (58 + 492)]]] = v78[v80[17 - 13]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[3];
							v72 = v72 + (4 - 3);
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[1 + 2]][v78[v80[787 - (531 + 252)]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = v80[1789 - (928 + 858)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[3 - 1]][v78[v80[775 - (108 + 664)]]] = v78[v80[6 - 2]];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[839 - (732 + 103)]];
							v72 = v72 + (629 - (351 + 277));
							v80 = v68[v72];
							v78[v80[682 - (538 + 142)]] = v80[13 - 10];
							v72 = v72 + (1828 - (189 + 1638));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[3]][v78[v80[1227 - (348 + 875)]]];
							v72 = v72 + (1217 - (1202 + 14));
							v80 = v68[v72];
							v78[v80[2]] = {};
							v72 = v72 + (636 - (619 + 16));
							v80 = v68[v72];
							v78[v80[2]] = v80[682 - (445 + 234)];
						else
							local v3598 = 0 - 0;
							local v3599;
							while true do
								if (v3598 == (515 - (295 + 206))) then
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v78[v80[3 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[2 + 1];
									v72 = v72 + (148 - (84 + 63));
									v80 = v68[v72];
									v3598 = 1387 - (913 + 459);
								end
								if (v3598 == (782 - (700 + 82))) then
									v3599 = nil;
									v3599 = v80[1 + 1];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1, v80[3 + 0]));
									v72 = v72 + (444 - (362 + 81));
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[183 - (133 + 46)]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + (1526 - (1219 + 306));
									v3598 = 1958 - (1012 + 945);
								end
								if ((v3598 == (767 - (481 + 276))) or (30 > 3885)) then
									v78[v80[4 - 2]][v78[v80[8 - 5]]] = v78[v80[127 - (49 + 74)]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[7 - 4];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[2 + 1]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[8 - 6]] = v80[8 - 5];
									v3598 = 32 - 21;
								end
								if ((4 + 17) == v3598) then
									v3599 = v80[4 - 2];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1, v80[3 + 0]));
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[3 + 0]]] = v78[v80[4]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[3 - 0];
									v72 = v72 + (1729 - (17 + 1711));
									v80 = v68[v72];
									v3598 = 67 - 45;
								end
								if ((1441 <= 3807) and (v3598 == (116 - (14 + 99)))) then
									v78[v80[2]] = v78[v80[2 + 1]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[313 - (287 + 23)];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]] = v80[6 - 3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3599 = v80[436 - (54 + 380)];
									v3598 = 10 - 6;
								end
								if (v3598 == 5) then
									v72 = v72 + (1637 - (486 + 1150));
									v80 = v68[v72];
									v78[v80[818 - (356 + 460)]] = v80[3 + 0];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2]] = v80[6 - 3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3599 = v80[1 + 1];
									v78[v3599] = v78[v3599](v13(v78, v3599 + (1454 - (1281 + 172)), v80[3]));
									v3598 = 591 - (158 + 427);
								end
								if (v3598 == (5 + 2)) then
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[3 + 0];
									v72 = v72 + (877 - (103 + 773));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + (1495 - (739 + 755));
									v80 = v68[v72];
									v3599 = v80[2];
									v78[v3599] = v78[v3599](v13(v78, v3599 + (344 - (39 + 304)), v80[508 - (129 + 376)]));
									v72 = v72 + 1;
									v3598 = 1548 - (282 + 1258);
								end
								if ((v3598 == (1312 - (204 + 1083))) or (4674 < 852)) then
									v72 = v72 + (707 - (471 + 235));
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[1090 - (38 + 1049)]]] = v78[v80[4]];
									break;
								end
								if (v3598 == (1647 - (1437 + 188))) then
									v78[v80[2]] = v78[v80[1 + 2]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3599 = v80[3 - 1];
									v3598 = 66 - (11 + 32);
								end
								if (v3598 == (272 - (81 + 174))) then
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v3599 = v80[8 - 6];
									v78[v3599] = v78[v3599](v13(v78, v3599 + (765 - (513 + 251)), v80[5 - 2]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[1127 - (1075 + 49)]]] = v78[v80[770 - (373 + 393)]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v80[891 - (875 + 13)];
									v3598 = 18;
								end
								if ((2 + 2) == v3598) then
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1, v80[2 + 1]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[8 - 6]][v78[v80[8 - 5]]] = v78[v80[1 + 3]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2]] = v80[3 + 0];
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[335 - (273 + 60)]] = v78[v80[11 - 8]];
									v3598 = 11 - 6;
								end
								if (v3598 == (70 - 52)) then
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[557 - (361 + 194)]] = v78[v80[3 + 0]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[2 + 1];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + (3 - 2);
									v3598 = 866 - (257 + 590);
								end
								if (((43 - 31) == v3598) or (3111 == 1227)) then
									v72 = v72 + (1956 - (856 + 1099));
									v80 = v68[v72];
									v78[v80[2]] = v80[1929 - (1556 + 370)];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[3 - 1]] = v78[v80[3]];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[174 - (24 + 148)]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v3598 = 22 - 9;
								end
								if ((v3598 == (7 + 1)) or (1694 > 3965)) then
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[9 - 6]]] = v78[v80[4 - 0]];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[1 + 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[13 - 10]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3598 = 9;
								end
								if ((2517 > 827) and (v3598 == (8 + 12))) then
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[3]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]] = v80[7 - 4];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v3598 = 18 + 3;
								end
								if ((913 < 2866) and (v3598 == (9 - 3))) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]][v78[v80[3]]] = v78[v80[7 - 3]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[2]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1721 - (976 + 743)]] = v78[v80[5 - 2]];
									v72 = v72 + (1515 - (1273 + 241));
									v3598 = 17 - 10;
								end
								if (v3598 == (31 - 20)) then
									v72 = v72 + (266 - (135 + 130));
									v80 = v68[v72];
									v78[v80[3 - 1]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3599 = v80[2 + 0];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1 + 0, v80[8 - 5]));
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[1744 - (1289 + 452)]]] = v78[v80[1 + 3]];
									v3598 = 341 - (90 + 239);
								end
								if (((948 - (117 + 812)) == v3598) or (1785 == 3150)) then
									v80 = v68[v72];
									v3599 = v80[1001 - (146 + 853)];
									v78[v3599] = v78[v3599](v13(v78, v3599 + (1966 - (986 + 979)), v80[661 - (555 + 103)]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[739 - (329 + 408)]][v78[v80[1 + 2]]] = v78[v80[1714 - (838 + 872)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[525 - (400 + 123)]] = v80[1 + 2];
									v72 = v72 + 1;
									v3598 = 1976 - (547 + 1409);
								end
								if (v3598 == (103 - (73 + 7))) then
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1 + 0, v80[3 + 0]));
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[5 - 3]][v78[v80[3]]] = v78[v80[5 - 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[6 - 4]] = v78[v80[1992 - (98 + 1891)]];
									v3598 = 63 - (16 + 23);
								end
								if ((1756 - (1184 + 548)) == v3598) then
									v72 = v72 + (1531 - (270 + 1260));
									v80 = v68[v72];
									v78[v80[2]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[737 - (60 + 675)]] = v80[1 + 2];
									v72 = v72 + (1203 - (984 + 218));
									v80 = v68[v72];
									v3599 = v80[384 - (45 + 337)];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1, v80[331 - (74 + 254)]));
									v3598 = 4 + 21;
								end
								if (v3598 == (2 + 0)) then
									v3599 = v80[2];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1, v80[1352 - (1190 + 159)]));
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]][v78[v80[3 + 0]]] = v78[v80[9 - 5]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1420 - (192 + 1226)]] = v80[739 - (511 + 225)];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3598 = 1398 - (1200 + 195);
								end
								if (v3598 == (1594 - (329 + 1249))) then
									v78[v80[2]] = v80[780 - (631 + 146)];
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[1 + 1]] = v78[v80[3]];
									v72 = v72 + (1034 - (510 + 523));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[13 - 10];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v80[1474 - (996 + 475)];
									v3598 = 7 + 10;
								end
								if (v3598 == 13) then
									v80 = v68[v72];
									v78[v80[2]] = v80[3 - 0];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3599 = v80[2 + 0];
									v78[v3599] = v78[v3599](v13(v78, v3599 + (1943 - (1132 + 810)), v80[4 - 1]));
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v78[v80[2 + 0]][v78[v80[1964 - (941 + 1020)]]] = v78[v80[531 - (313 + 214)]];
									v72 = v72 + (545 - (363 + 181));
									v3598 = 11 + 3;
								end
								if (1 == v3598) then
									v80 = v68[v72];
									v78[v80[2]] = v78[v80[1 + 2]];
									v72 = v72 + (1450 - (91 + 1358));
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[6 - 3];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[8 - 5];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3598 = 3 - 1;
								end
								if (v3598 == (25 - 16)) then
									v78[v80[1 + 1]] = v80[2 + 1];
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3599 = v80[8 - 6];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1 + 0, v80[3]));
									v72 = v72 + (3 - 2);
									v80 = v68[v72];
									v3598 = 10;
								end
								if (v3598 == (883 - (311 + 557))) then
									v78[v80[165 - (117 + 46)]] = v80[2 + 1];
									v72 = v72 + (505 - (268 + 236));
									v80 = v68[v72];
									v3599 = v80[1 + 1];
									v78[v3599] = v78[v3599](v13(v78, v3599 + 1, v80[183 - (92 + 88)]));
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[1086 - (745 + 339)]][v78[v80[3]]] = v78[v80[3 + 1]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3598 = 26 - 10;
								end
							end
						end
					elseif (v81 <= (57 + 142)) then
						if (v81 > (542 - 344)) then
							local v3600 = 0;
							while true do
								if (v3600 == (741 - (582 + 156))) then
									v78[v80[1772 - (268 + 1502)]][v78[v80[1449 - (219 + 1227)]]] = v78[v80[1 + 3]];
									v72 = v72 + (2 - 1);
									v80 = v68[v72];
									v78[v80[2]][v78[v80[7 - 4]]] = v78[v80[12 - 8]];
									v3600 = 7 - 3;
								end
								if (v3600 == (1980 - (1855 + 121))) then
									v72 = v72 + (4 - 3);
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[789 - (452 + 334)];
									v72 = v72 + (1 - 0);
									v3600 = 1398 - (698 + 695);
								end
								if (v3600 == (11 - 6)) then
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[4 - 1]][v78[v80[4]]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v3600 = 7 - 1;
								end
								if ((2953 > 2726) and (v3600 == (20 - 14))) then
									v78[v80[2]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1731 - (529 + 1200)]] = v80[2 + 1];
									break;
								end
								if ((278 - (199 + 79)) == v3600) then
									v78[v80[2 + 0]][v78[v80[9 - 6]]] = v78[v80[588 - (120 + 464)]];
									v72 = v72 + (1 - 0);
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[757 - (33 + 721)];
									v3600 = 1;
								end
								if (v3600 == (1364 - (1061 + 302))) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v78[v80[1731 - (719 + 1010)]] = v78[v80[11 - 8]][v78[v80[943 - (446 + 493)]]];
									v72 = v72 + 1 + 0;
									v3600 = 1146 - (602 + 542);
								end
								if (v3600 == (2 + 0)) then
									v80 = v68[v72];
									v78[v80[4 - 2]] = v80[364 - (276 + 85)];
									v72 = v72 + 1;
									v80 = v68[v72];
									v3600 = 1383 - (816 + 564);
								end
							end
						else
							local v3601 = 0;
							while true do
								if (v3601 == (11 - 6)) then
									v80 = v68[v72];
									v78[v80[916 - (854 + 60)]] = v78[v80[698 - (227 + 468)]][v78[v80[2 + 2]]];
									v72 = v72 + (530 - (54 + 475));
									v80 = v68[v72];
									v3601 = 9 - 3;
								end
								if (v3601 == (35 - (21 + 11))) then
									v78[v80[2]][v78[v80[3 + 0]]] = v78[v80[1599 - (1351 + 244)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[7 - 5]][v78[v80[3]]] = v78[v80[428 - (407 + 17)]];
									v3601 = 1 + 3;
								end
								if ((v3601 == (0 + 0)) or (2803 < 1104)) then
									v78[v80[951 - (174 + 775)]][v78[v80[1763 - (601 + 1159)]]] = v78[v80[1152 - (388 + 760)]];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1952 - (900 + 1050)]] = v80[3 + 0];
									v3601 = 1;
								end
								if (v3601 == (1 + 3)) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[1 + 1]] = v80[3];
									v72 = v72 + (3 - 2);
									v3601 = 5 + 0;
								end
								if (v3601 == (283 - (80 + 202))) then
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[5 - 3]] = v78[v80[3 + 0]][v78[v80[4 - 0]]];
									v72 = v72 + 1;
									v3601 = 7 - 5;
								end
								if (v3601 == (4 + 2)) then
									v78[v80[2]] = {};
									v72 = v72 + (665 - (308 + 356));
									v80 = v68[v72];
									v78[v80[2 + 0]] = v80[3];
									break;
								end
								if (2 == v3601) then
									v80 = v68[v72];
									v78[v80[6 - 4]] = v80[3];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3601 = 3;
								end
							end
						end
					elseif ((1682 >= 595) and (v81 == (327 - 127))) then
						local v3602 = 1054 - (1021 + 33);
						local v3603;
						local v3604;
						local v3605;
						while true do
							if (5 == v3602) then
								v80 = v68[v72];
								v3605 = v80[1053 - (46 + 1005)];
								v3604 = v78[v3605];
								v3603 = v80[3];
								v3602 = 6;
							end
							if ((4764 >= 1950) and (6 == v3602)) then
								for v6899 = 1 + 0, v3603 do
									v3604[v6899] = v78[v3605 + v6899];
								end
								break;
							end
							if (v3602 == (3 - 1)) then
								v80 = v68[v72];
								v78[v80[2]] = v78[v80[3]][v78[v80[4 + 0]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v3602 = 3 - 0;
							end
							if ((v3602 == (1 + 2)) or (2986 > 4541)) then
								v78[v80[3 - 1]] = {};
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[6 - 3];
								v3602 = 2 + 2;
							end
							if (v3602 == (0 - 0)) then
								v3603 = nil;
								v3604 = nil;
								v3605 = nil;
								v78[v80[1 + 1]] = {};
								v3602 = 1057 - (131 + 925);
							end
							if (v3602 == 4) then
								v72 = v72 + (1289 - (347 + 941));
								v80 = v68[v72];
								v78[v80[1623 - (893 + 728)]] = v78[v80[3]][v78[v80[3 + 1]]];
								v72 = v72 + 1 + 0;
								v3602 = 5;
							end
							if ((v3602 == 1) or (3012 == 4961)) then
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[3 - 1]] = v80[2 + 1];
								v72 = v72 + (3 - 2);
								v3602 = 2 + 0;
							end
						end
					else
						v78[v80[2]][v78[v80[3]]] = v78[v80[912 - (599 + 309)]];
						v72 = v72 + (1913 - (1598 + 314));
						v80 = v68[v72];
						v78[v80[2]] = v80[3 + 0];
						v72 = v72 + (2 - 1);
						v80 = v68[v72];
						v78[v80[1616 - (274 + 1340)]] = v78[v80[3 + 0]][v78[v80[2 + 2]]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1416 - (557 + 857)]] = v80[8 - 5];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[6 - 4]][v78[v80[1115 - (581 + 531)]]] = v78[v80[12 - 8]];
						v72 = v72 + (1336 - (1314 + 21));
						v80 = v68[v72];
						v78[v80[3 - 1]][v78[v80[1 + 2]]] = v78[v80[4]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1191 - (487 + 702)]] = v80[2 + 1];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[5 - 3]] = v78[v80[1 + 2]][v78[v80[1 + 3]]];
						v72 = v72 + (539 - (86 + 452));
						v80 = v68[v72];
						v78[v80[2 + 0]] = {};
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[4 - 2]] = v80[1075 - (123 + 949)];
					end
				elseif (v81 <= (1121 - (836 + 77))) then
					if ((2182 <= 3621) and (v81 <= (854 - (354 + 296)))) then
						if ((3165 >= 2801) and (v81 <= (294 - (5 + 87)))) then
							local v905 = v80[2 + 0];
							do
								return v13(v78, v905, v73);
							end
						elseif (v81 > (98 + 105)) then
							v78[v80[2 + 0]][v78[v80[3]]] = v78[v80[7 - 3]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[684 - (267 + 415)]] = v80[3];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v78[v80[3 + 0]][v78[v80[1 + 3]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[6 - 3]]] = v78[v80[1896 - (1799 + 93)]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]][v78[v80[1 + 2]]] = v78[v80[4]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (20 - (6 + 13));
							v80 = v68[v72];
							v78[v80[1061 - (383 + 676)]] = v78[v80[343 - (119 + 221)]][v78[v80[1 + 3]]];
							v72 = v72 + (482 - (345 + 136));
							v80 = v68[v72];
							v78[v80[2 - 0]] = {};
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[8 - 5];
						else
							local v3643 = 476 - (345 + 131);
							local v3644;
							local v3645;
							local v3646;
							while true do
								if ((v3643 == 1) or (4922 < 1477)) then
									v72 = v72 + (1302 - (916 + 385));
									v80 = v68[v72];
									v78[v80[294 - (6 + 286)]] = v78[v80[7 - 4]][v78[v80[3 + 1]]];
									v72 = v72 + 1 + 0;
									v3643 = 2;
								end
								if (5 == v3643) then
									v3644 = v80[294 - (151 + 140)];
									for v6902 = 1 - 0, v3644 do
										v3645[v6902] = v78[v3646 + v6902];
									end
									break;
								end
								if ((954 - (32 + 922)) == v3643) then
									v3644 = nil;
									v3645 = nil;
									v3646 = nil;
									v78[v80[2]] = v80[845 - (322 + 520)];
									v3643 = 1;
								end
								if ((v3643 == 4) or (2816 >= 3102)) then
									v72 = v72 + 1;
									v80 = v68[v72];
									v3646 = v80[2];
									v3645 = v78[v3646];
									v3643 = 5 + 0;
								end
								if (v3643 == (2 + 0)) then
									v80 = v68[v72];
									v78[v80[1 + 1]] = {};
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v3643 = 3;
								end
								if ((224 - (187 + 34)) == v3643) then
									v78[v80[2 + 0]] = v80[5 - 2];
									v72 = v72 + 1 + 0;
									v80 = v68[v72];
									v78[v80[298 - (194 + 102)]] = v78[v80[555 - (49 + 503)]][v78[v80[11 - 7]]];
									v3643 = 1353 - (12 + 1337);
								end
							end
						end
					elseif (v81 <= (476 - 270)) then
						if ((v81 > 205) or (1721 <= 1704)) then
							local v3647;
							local v3648;
							local v3649;
							v78[v80[2 + 0]] = {};
							v72 = v72 + (1066 - (38 + 1027));
							v80 = v68[v72];
							v78[v80[4 - 2]] = v80[124 - (11 + 110)];
							v72 = v72 + (816 - (199 + 616));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[2 + 1]][v78[v80[4]]];
							v72 = v72 + (480 - (396 + 83));
							v80 = v68[v72];
							v78[v80[2]] = {};
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[3];
							v72 = v72 + (1786 - (774 + 1011));
							v80 = v68[v72];
							v78[v80[2]] = v78[v80[7 - 4]][v78[v80[7 - 3]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3649 = v80[391 - (94 + 295)];
							v3648 = v78[v3649];
							v3647 = v80[1 + 2];
							for v4701 = 1, v3647 do
								v3648[v4701] = v78[v3649 + v4701];
							end
						else
							v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[3 - 1]] = v80[6 - 3];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3]][v78[v80[5 - 1]]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[1 + 1]] = v80[2 + 1];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[3 - 1]][v78[v80[13 - (6 + 4)]]] = v78[v80[4]];
							v72 = v72 + (2 - 1);
							v80 = v68[v72];
							v78[v80[855 - (629 + 224)]][v78[v80[6 - 3]]] = v78[v80[1526 - (466 + 1056)]];
							v72 = v72 + (766 - (485 + 280));
							v80 = v68[v72];
							v78[v80[93 - (51 + 40)]] = v80[796 - (610 + 183)];
							v72 = v72 + 1;
							v80 = v68[v72];
							v78[v80[2 + 0]] = v78[v80[3 + 0]][v78[v80[4]]];
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v78[v80[5 - 3]] = {};
							v72 = v72 + (773 - (572 + 200));
							v80 = v68[v72];
							v78[v80[2]] = v80[1978 - (1598 + 377)];
						end
					elseif (v81 == (416 - 209)) then
						local v3680 = 0 + 0;
						while true do
							if (v3680 == 5) then
								v80 = v68[v72];
								v78[v80[1 + 1]] = v78[v80[1281 - (881 + 397)]][v78[v80[4]]];
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v3680 = 1219 - (892 + 321);
							end
							if (v3680 == (628 - (441 + 186))) then
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[1424 - (606 + 815)]][v78[v80[4]]];
								v72 = v72 + 1;
								v3680 = 2;
							end
							if ((2308 == 2308) and (v3680 == 0)) then
								v78[v80[9 - 7]][v78[v80[3 + 0]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1174 - (1055 + 117)]] = v80[3];
								v3680 = 689 - (266 + 422);
							end
							if ((v3680 == 3) or (1272 >= 1469)) then
								v78[v80[2]][v78[v80[11 - 8]]] = v78[v80[1895 - (1098 + 793)]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[1563 - (12 + 1547)]];
								v3680 = 1362 - (149 + 1209);
							end
							if ((662 <= 4695) and (v3680 == (2 + 4))) then
								v78[v80[1016 - (6 + 1008)]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[2]] = v80[3];
								break;
							end
							if (v3680 == (1348 - (603 + 743))) then
								v80 = v68[v72];
								v78[v80[2]] = v80[243 - (152 + 88)];
								v72 = v72 + (318 - (207 + 110));
								v80 = v68[v72];
								v3680 = 5 - 2;
							end
							if ((v3680 == 4) or (2774 <= 520)) then
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[1835 - (1401 + 432)]] = v80[5 - 2];
								v72 = v72 + (1038 - (838 + 199));
								v3680 = 13 - 8;
							end
						end
					else
						local v3681 = 0 - 0;
						while true do
							if ((3650 >= 369) and (v3681 == (432 - (320 + 110)))) then
								v80 = v68[v72];
								v78[v80[4 - 2]] = v80[5 - 2];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v3681 = 140 - (123 + 14);
							end
							if ((871 <= 3913) and (v3681 == (1 + 0))) then
								v72 = v72 + (2 - 1);
								v80 = v68[v72];
								v78[v80[104 - (62 + 40)]] = v78[v80[7 - 4]][v78[v80[4]]];
								v72 = v72 + (1098 - (823 + 274));
								v3681 = 966 - (134 + 830);
							end
							if (v3681 == 3) then
								v78[v80[2]][v78[v80[3]]] = v78[v80[10 - 6]];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v78[v80[1583 - (1430 + 151)]][v78[v80[1361 - (104 + 1254)]]] = v78[v80[428 - (161 + 263)]];
								v3681 = 7 - 3;
							end
							if (v3681 == (1400 - (317 + 1079))) then
								v72 = v72 + (1 - 0);
								v80 = v68[v72];
								v78[v80[5 - 3]] = v80[3];
								v72 = v72 + (316 - (76 + 239));
								v3681 = 378 - (349 + 24);
							end
							if ((0 - 0) == v3681) then
								v78[v80[4 - 2]][v78[v80[1 + 2]]] = v78[v80[1 + 3]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[1636 - (1428 + 206)]] = v80[1508 - (1207 + 298)];
								v3681 = 349 - (224 + 124);
							end
							if (v3681 == (37 - (7 + 25))) then
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[1055 - (886 + 166)]][v78[v80[4]]];
								v72 = v72 + 1;
								v80 = v68[v72];
								v3681 = 6;
							end
							if (v3681 == (8 - 2)) then
								v78[v80[1 + 1]] = {};
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[320 - (142 + 176)]] = v80[3 + 0];
								break;
							end
						end
					end
				elseif ((3424 < 3498) and (v81 <= 211)) then
					if (v81 <= (1147 - (584 + 354))) then
						local v906 = 488 - (384 + 104);
						while true do
							if ((1195 <= 4043) and (v906 == 0)) then
								v78[v80[5 - 3]][v78[v80[3]]] = v78[v80[39 - (13 + 22)]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[2 + 0]] = v80[5 - 2];
								v906 = 2 - 1;
							end
							if (v906 == (10 - 6)) then
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[1 + 2];
								v72 = v72 + 1 + 0;
								v906 = 15 - 10;
							end
							if (v906 == (255 - (106 + 146))) then
								v78[v80[3 - 1]][v78[v80[5 - 2]]] = v78[v80[4]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[7 - 5]][v78[v80[3]]] = v78[v80[1022 - (75 + 943)]];
								v906 = 1067 - (972 + 91);
							end
							if ((3759 > 724) and (v906 == (3 - 2))) then
								v72 = v72 + 1;
								v80 = v68[v72];
								v78[v80[4 - 2]] = v78[v80[3]][v78[v80[1350 - (918 + 428)]]];
								v72 = v72 + (1598 - (1099 + 498));
								v906 = 1687 - (997 + 688);
							end
							if (v906 == (1427 - (1406 + 16))) then
								v80 = v68[v72];
								v78[v80[2 + 0]] = v78[v80[922 - (715 + 204)]][v78[v80[4 + 0]]];
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v906 = 669 - (275 + 388);
							end
							if ((v906 == (7 - 1)) or (579 > 4048)) then
								v78[v80[2]] = {};
								v72 = v72 + 1 + 0;
								v80 = v68[v72];
								v78[v80[1 + 1]] = v80[3 + 0];
								break;
							end
							if (v906 == 2) then
								v80 = v68[v72];
								v78[v80[6 - 4]] = v80[1 + 2];
								v72 = v72 + (3 - 2);
								v80 = v68[v72];
								v906 = 2 + 1;
							end
						end
					elseif (v81 == 210) then
						v78[v80[2 + 0]] = v80[1 + 2] + v78[v80[569 - (5 + 560)]];
					else
						local v3683;
						local v3684;
						local v3685;
						v78[v80[2]] = {};
						v72 = v72 + (407 - (77 + 329));
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[2 + 1];
						v72 = v72 + (1952 - (397 + 1554));
						v80 = v68[v72];
						v78[v80[1259 - (219 + 1038)]] = v78[v80[3]][v78[v80[3 + 1]]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1 + 1]] = {};
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[3 - 1]] = v80[6 - 3];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[1 + 1]] = v78[v80[755 - (404 + 348)]][v78[v80[152 - (99 + 49)]]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v3685 = v80[2];
						v3684 = v78[v3685];
						v3683 = v80[1972 - (1223 + 746)];
						for v4730 = 1 - 0, v3683 do
							v3684[v4730] = v78[v3685 + v4730];
						end
					end
				elseif (v81 <= 213) then
					if (v81 > (195 + 17)) then
						local v3699;
						local v3700;
						local v3701;
						v78[v80[1363 - (1247 + 114)]] = {};
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v78[v80[2 + 0]] = v80[6 - 3];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[2]] = v78[v80[8 - 5]][v78[v80[4]]];
						v72 = v72 + (1 - 0);
						v80 = v68[v72];
						v78[v80[1941 - (291 + 1648)]] = {};
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[5 - 3]] = v80[7 - 4];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[6 - 4]] = v78[v80[3 + 0]][v78[v80[1702 - (1584 + 114)]]];
						v72 = v72 + 1;
						v80 = v68[v72];
						v3701 = v80[6 - 4];
						v3700 = v78[v3701];
						v3699 = v80[1768 - (957 + 808)];
						for v4733 = 3 - 2, v3699 do
							v3700[v4733] = v78[v3701 + v4733];
						end
					else
						local v3716;
						local v3717;
						local v3718;
						v78[v80[8 - 6]] = {};
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[1073 - (435 + 636)]] = v80[3];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[787 - (342 + 443)]] = v78[v80[4 - 1]][v78[v80[2 + 2]]];
						v72 = v72 + 1 + 0;
						v80 = v68[v72];
						v78[v80[2 + 0]] = {};
						v72 = v72 + (533 - (321 + 211));
						v80 = v68[v72];
						v78[v80[2]] = v80[3];
						v72 = v72 + 1;
						v80 = v68[v72];
						v78[v80[7 - 5]] = v78[v80[3 + 0]][v78[v80[6 - 2]]];
						v72 = v72 + (3 - 2);
						v80 = v68[v72];
						v3718 = v80[1244 - (506 + 736)];
						v3717 = v78[v3718];
						v3716 = v80[1344 - (428 + 913)];
						for v4736 = 1852 - (834 + 1017), v3716 do
							v3717[v4736] = v78[v3718 + v4736];
						end
					end
				elseif (v81 == (1785 - (1493 + 78))) then
					local v3732 = 0;
					local v3733;
					local v3734;
					local v3735;
					while true do
						if ((3689 == 3689) and (v3732 == (11 - 4))) then
							for v6905 = 1, v3733 do
								v3734[v6905] = v78[v3735 + v6905];
							end
							break;
						end
						if (v3732 == (2 + 2)) then
							v78[v80[2 + 0]] = v80[1 + 2];
							v72 = v72 + (1 - 0);
							v80 = v68[v72];
							v3732 = 1 + 4;
						end
						if (v3732 == (192 - (177 + 9))) then
							v3735 = v80[2];
							v3734 = v78[v3735];
							v3733 = v80[1256 - (236 + 1017)];
							v3732 = 3 + 4;
						end
						if (v3732 == (1982 - (1237 + 742))) then
							v78[v80[2 - 0]] = {};
							v72 = v72 + 1 + 0;
							v80 = v68[v72];
							v3732 = 4;
						end
						if (v3732 == (0 + 0)) then
							v3733 = nil;
							v3734 = nil;
							v3735 = nil;
							v3732 = 1;
						end
						if ((2 + 3) == v3732) then
							v78[v80[2]] = v78[v80[2 + 1]][v78[v80[3 + 1]]];
							v72 = v72 + 1;
							v80 = v68[v72];
							v3732 = 17 - 11;
						end
						if ((1947 == 1947) and (v3732 == (5 - 3))) then
							v78[v80[1566 - (566 + 998)]] = v78[v80[2 + 1]][v78[v80[4]]];
							v72 = v72 + (1629 - (11 + 1617));
							v80 = v68[v72];
							v3732 = 3;
						end
						if ((259 <= 597) and ((1866 - (1156 + 709)) == v3732)) then
							v78[v80[2]] = v80[7 - 4];
							v72 = v72 + (3 - 2);
							v80 = v68[v72];
							v3732 = 4 - 2;
						end
					end
				else
					v78[v80[1 + 1]][v78[v80[3]]] = v78[v80[9 - 5]];
					v72 = v72 + (1 - 0);
					v80 = v68[v72];
					v78[v80[691 - (131 + 558)]] = v80[3];
					v72 = v72 + (1 - 0);
					v80 = v68[v72];
					v78[v80[2 + 0]] = v78[v80[9 - 6]][v78[v80[5 - 1]]];
					v72 = v72 + 1 + 0;
					v80 = v68[v72];
					v78[v80[1 + 1]] = v80[1 + 2];
					v72 = v72 + (1646 - (1417 + 228));
					v80 = v68[v72];
					v78[v80[2]][v78[v80[3]]] = v78[v80[4]];
					v72 = v72 + (3 - 2);
					v80 = v68[v72];
					v78[v80[1 + 1]][v78[v80[7 - 4]]] = v78[v80[398 - (134 + 260)]];
					v72 = v72 + (2 - 1);
					v80 = v68[v72];
					v78[v80[1 + 1]] = v80[1 + 2];
					v72 = v72 + (1 - 0);
					v80 = v68[v72];
					v78[v80[136 - (49 + 85)]] = v78[v80[3]][v78[v80[2 + 2]]];
					v72 = v72 + 1 + 0;
					v80 = v68[v72];
					v78[v80[4 - 2]] = {};
					v72 = v72 + 1;
					v80 = v68[v72];
					v78[v80[1 + 1]] = v80[3 + 0];
				end
				v72 = v72 + 1;
			end
		end;
	end
	return v29(v28(), {}, v17)(...);
end
return v15("LOL!02052Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E73657274025Q00C07E4003043Q00F4F8F75D03063Q0010A62Q993644025Q00B07E4003803Q009691D4EFF99490D6E1FC9392D1E2FC9690D4E1F99693D4E3FC9C95D5E4FD9392D1E4F92Q90D7E4F79392D4E0FC9495D2E1F9969BD4E4FC2Q90D7E4F79392D1E4FC9690DFE4FE9692D1E1FC9C95D3E4F89690D1E6FC9790D2E1FE9697D1E6F99390D2E1FC9694D4EEFC9C90D3E4F79692D4E7FC9490D6E4FB9695D1E3FC9C90DF03053Q00CFA5A3E7D7025Q00A07E4003063Q00CD7D09DEEC7303043Q00BF9E1265025Q00907E4003093Q00FE53A4AECE5FAEBFC803043Q00CDBB2BC1025Q00807E4003143Q001C6CE872165468E171175C6CE070115A69ED731803053Q00216C5DD944025Q00607E4003043Q004BF5160803073Q0073199478637447025Q00507E4003603Q0044AADBFE25781CF9D8F2762A18F98BFC71294EFFDFFD222B49AD8BAD752C1EACDEA9222B4EF98FF3207845FCDDAD272A4EFA8EAA707C1CFFDCF2257B18FFDFFB262C4AFADDAE752A4DFCDFFD717D4CAC8FFC752A1FFADBF8227C1EADDAF2732A03063Q00197DC9EACB43025Q00407E4003043Q00CAE0405D03053Q00659D813638025Q00307E4003093Q00DF363147522DB826E903083Q00549A4E54242759D7025Q00207E4003133Q003ED2B6527ED2B7547CDFB4557DDCBA567DDBB303043Q00664EEB83026Q007E4003043Q004AAC4DAF03043Q00C418CD23025Q00F07D4003243Q00539C265CE8509E7445BB569A2745E956CD7145E1529C7445E0579E705EBE51CD2351EE5403053Q00D867A81568025Q00E07D4003043Q00E0EDF24203063Q00D1B8889C2D21025Q00D07D4003403Q005BE225B479943A265EB575B028C76D295DB273B57B936D260EB774B12B9D3D2E5CE125E378C06B2D09B626E278C66D7B0DB970B4729D3A7D5DB970E278923C7C03083Q001F6B8043874AA55F025Q00C07D4003083Q0017BEC2BC33BADCB003043Q00D544DBAE025Q00B07D4003093Q00F56352EDAAC47445FD03053Q00DFB01B378E025Q00A07D4003133Q00A10A2C812E6DE50A29822B6DE906248D2063E103063Q005AD1331CB519025Q00807D4003043Q0080D9D47E03083Q0059D2B8BA15785DAF025Q00707D4003243Q00F5170DDEF24E5FD0BD1C0B84F1020BD6F5491786A14C0CCAA81F0C82A6490C82A6160CD403043Q00E7902F3A025Q00607D4003043Q001D2FA24E03073Q00C5454ACC212F1F025Q00507D4003093Q00C0F54319EEF1E2540903053Q009B858D267A025Q00407D4003143Q00E74BF69F4CAF9818A742F49743A5991BA54CF49E03083Q002E977AC4A6749CA9025Q00207D4003043Q007E1FD4AB03053Q00D02C7EBAC0025Q00107D4003803Q0024406604976124436605926121436303926E214763019265214F6603976421476602926021416600926224456605926F21436308926721456300976624426602926524446309926F21456602926424446307976621426307976221456306926024426603926421456300926F214566049765214E66039765214063089260214703063Q005712765031A1026Q007D4003063Q0063E5F4C9535103053Q0021308A98A8025Q00F07C4003093Q0079682CE5B001132A4F03083Q00583C104986C5757C025Q00E07C4003143Q00C9BE540644E667438DBB570C49E666428AB6550803083Q0076B98F663E70D151025Q00C07C4003043Q00B54DB80E03053Q008BE72CD665025Q00B07C4003243Q00EC7CE52DDCE07AE530D2E177E730D5E42BB23085B17DE730DCE578B12B82E32BE224D2E603053Q00E4D54ED41D025Q00A07C4003043Q00DDA3B4C803063Q008C85C6DAA7E8025Q00907C4003093Q00DE06DCE12336C2E90D03073Q00AD9B7EB9825642025Q00807C4003143Q00EE66A7E0B0E9A662A3E4B4EEAD61A5E3B5E2AE6603063Q00DA9E5796D784025Q00607C4003043Q00638DA67803043Q001331ECC8025Q00507C4003403Q0084E7E9DF55A383B0BA8D57A3DDB6EE8E02F6D5E7BE805BA781E1EC8E54A4D0B1E98806A784BBB98D57A2DDB0EAD800A383B2BCDA00F084B6B8DF55F586B4E9DB03063Q00C6E5838FB963025Q00407C4003053Q00A3418CE67E03063Q00D6ED28E48910025Q00307C4003243Q008F2FB0243854EEDC63ED246A55A2DA7FB024765BBF887DF8786B54EADD28E3256D5BB9D803073Q008FEB4ED5405B62025Q00207C4003043Q00B0DED3A303083Q0043E8BBBDCCC176C6025Q00107C40034A3Q0095F08647B5B89F90F08741B3EF9F94A3D34DE1E99F97A68140B0BF9FC2F78646B4E89FC2A3D514B0EB9F91F78443E2BA9FC0A68110BCEC9F95AD8343B6BC9FC4A2D011B7B89F90F7D74303073Q00B2A195E57584DE026Q007C4003053Q000E0727FEC803063Q005F5D704E98BC025Q00F07B4003403Q00C45A5418C40A044E96560D4E9708511FC60B074E955C0548940A564B9059024D910D014D935C044E960D051FC35E061A920F0447900F064DC35C541D910F021F03043Q007EA76E35025Q00E07B4003023Q0037D003053Q005A798822D0025Q00D07B4003093Q00D0E0222156E1F7353103053Q002395984742025Q00C07B4003133Q000764DB5F4566D1514F60D15A4467DD594E65D803043Q00687753E9025Q00A07B4003043Q001FAB72A303053Q00B74DCA1CC8025Q00907B4003243Q009C0C4028E07F9009082CE129CC2Q142BE07D8501172AE6369009137FB37D9E5C1323B32803063Q001BA839251A85025Q00807B4003043Q00672DA00B03053Q00363F48CE64025Q00707B4003093Q003BD9A5E7A86611D3B303063Q00127EA1C084DD025Q00607B4003143Q006A2QB76E00194323B3B06F05194D29B7B160071803073Q00741A868558302F025Q00407B4003043Q00E5E9AC2703043Q004CB788C2025Q00307B4003243Q00DF4D481889411B4FC04E1F4B88554B1C881E5714DF4B4900D5484C48DB1E4C48DB414C1E03043Q002DED787A025Q00207B4003043Q001BD17A2603063Q009643B41449B1025Q00107B4003403Q00AB9CFAB2ACF2F8C9FAE6FCF6A59BACE0AAF5A8C8AFB6FEA4AD93AEE7FFA7F89DF5B0FFADAACDF8B0A8A2FC9DACB4FEA3A899F5BBACA4FB98ABB1FEF6AECDF4B603063Q00949DABCD82C9026Q007B4003053Q005EA3A8E57703053Q001910CAC08A025Q00F07A4003093Q0066531E361E48A0515803073Q00CF232B7B556B3C025Q00E07A4003143Q00318CEA2056728FEA275B728BE2215B798CEC225F03053Q006F41BDDA12025Q00C07A4003043Q006FED4A8103043Q00EA3D8C24025Q00B07A4003243Q00188212828F03BA199741D78558F31B8B13D19A03BB1C835B8A8757BB1CDC40D78158E81903073Q00DE2ABA76B2B761025Q00A07A4003043Q00D424260903083Q004C8C4148661BED99025Q00907A4003093Q0026C827A59D17DF30B503053Q00E863B042C6025Q00807A4003133Q00307ABBF6ACDFB7B17371BAF5AADDB7BF707ABE03083Q008940428DC599E88E025Q00607A4003043Q001119D02103073Q002D4378BE4A4843025Q00507A4003243Q00F48AA815FCE2A68AE742AEE4A8C6FB46A9B1BD89FD132QF8A8DBFC12FAB3A68EFC4EFAE603063Q00D590EBCA77CC025Q00407A4003043Q002389773B03043Q00547BEC19025Q00307A4003093Q00D9115A78FDE8064D6803053Q00889C693F1B025Q00207A4003133Q00B7EE918FF0E2908AFFE59F8FF3E69A8FF2E79F03043Q00BCC7D7A9026Q007A4003043Q001CFD841D03053Q00A14E9CEA76025Q00F0794003243Q00D179BD1887B28F8663EB488FBD90D17FBA4F9AB289827FF21387BDD8D628E94E81B28BD303073Q00BDE04EDF2BB78B025Q00E0794003043Q0004FAEDCB03073Q00585C9F83A4BCC3025Q00D0794003093Q009FFA1FE5F0AEED08F503053Q0085DA827A86025Q00C0794003133Q00CEDF296D727687D82D6970758CDF2F6C7B718E03063Q0046BEEB1F5F42025Q00A0794003043Q008FEA31AB03053Q00A9DD8B5FC0025Q0090794003803Q00B0AAD9F082B3A9D9F587B0AEDCF682B4ACDEF582B0AAD9F382B7A9DCF583B0ABD9F487B2ACDAF083B0ABD9F187B4ACDBF083B5ABDCF182B4ACDAF088B0ACDCF082BFACD8F085B0AEDCF782B7A9DFF082B5ACDCF182B0ACD3F084B5A6D9FA82B1ACD3F582B0ADD9F187B5ACD3F587B5A9D9FA87B2A9D9F587B5A7D9F482B4A9DB03053Q00B1869FEAC3025Q0080794003063Q00DEAA8B7A02B203083Q005C8DC5E71B70D333025Q0070794003093Q00A6E8AF88C8A28CE2B903063Q00D6E390CAEBBD025Q0060794003133Q00B5A61C96F5A71B94FCA8199DF0A31890F1A51003043Q00A4C59028025Q0040794003043Q00251DC15503073Q00DA777CAF3EA8B9025Q0030794003803Q002Q4C684D63A4774B4E6E4B65A2754C4F6D4C66A077484E6E4E63A271494D684A66A7774F4E6A4B67A27C494E684C66A0774F4E664B61A2774C496D4E63A072484B684E63A276494E6D4866A6774A4E694B64A770494E6D4D66A7774C4B6C4E61A27349446D4066A0772Q4E6D4B61A7702Q49684966A377484E6E4B64A2734C4903073Q00447A7D5E785591025Q0020794003063Q0026ADF319291403053Q005B75C29F78025Q0010794003093Q002Q3F570F38F914FC0903083Q008E7A47326C4D8D7B026Q00794003143Q005AAFF11221701EA7F11B25711BA8F216267019A803063Q00412A9EC22211025Q00E0784003043Q00F575F4F303053Q002AA7149A98025Q00D0784003243Q00DD1FBF1CD91FBA1CC01CEB10D804BB19884FA7108F4CE805D519BC4DDB4FBC4DDB10BC1B03043Q0028ED298A025Q00C0784003043Q00EEA3E9C803063Q00D7B6C687A719025Q00B0784003093Q000117A744311BAD553703043Q0027446FC2025Q00A0784003133Q00DC69EEA79A66E7A09C6DECA59868E7A99968E603043Q0090AC5EDF025Q0080784003043Q0063A90AF803073Q003831C864937C77025Q0070784003803Q00DE64AE720BB5DB63AB770BB4DE68AE700EB4DB62AB7D0BB0DE68AB720EB2DE69AE710BB3DE68AB760EB1DB63AE710EB7DB63AE710BB2DE65AE710BB0DE60AB750BB0DE68AB740BB5DB66AB7D0EB9DE61AB700EB9DE62AB720BB7DE63AE760EB7DE69AB750BB2DE68AB750BB2DE64AE750BB0DB63AE760BB7DE67AB740EB8DB6503063Q0081ED5098443D025Q0060784003063Q00D423A459347703063Q0016874CC83846025Q0050784003093Q000DB9C17F0B373E303B03083Q004248C1A41C7E4351025Q0040784003133Q002869B6AFB1BF81E26D6BB3AEBAB981E9696DB203083Q00D1585E839A898AB3025Q0020784003043Q006933A24B03053Q009D3B52CC20025Q0010784003803Q00EBE04F6FEEEC4F6FEBEE4F6EEBE84F68EEED4F6CEEEC4A6EEEED4A6EEBE84F6CEBEE4F6FEEEA4F6BEBE84A6AEBEA4A69EBE94A6EEBE04F68EEEA4F6BEEEB4F6DEBEE4A6AEEED4F69EBE94F65EBE04A6DEBEC4F65EBE04A68EEEB4F64EBEE4F6FEEEC4A6EEBEA4F6AEBE14F69EBEE4F6BEBED4F69EEEB4F6EEBE94A68EEEA4F6B03043Q005C2QD87C026Q00784003063Q007E1E20EE5F1003043Q008F2D714C025Q00F0774003093Q00E9D5877253D8C2906203053Q0026ACADE211025Q00E0774003133Q00E37E44484B42A6762Q464E4BA0732Q46424CA703063Q007B9347707F7A025Q00C0774003043Q00F6CC493703073Q0095A4AD275C926E025Q00B0774003803Q002A8E8B080460842D89880B0360872F8D8E0E0160812E2Q8C0B0460872F8B8E08016281248C8A0E0260842F8D8E0C046B81242Q890B0460872F8A8E0F046B812E89810E0360802F8F8B0B0160842A89800E0460822A2Q8E0C0161812E898A2Q0E608B2F8E8B090167842F898A2Q0E60812A898E0C01628129898D0E0660842F8E03073Q00B21CBAB83D3753025Q00A0774003063Q0063843276428A03043Q001730EB5E025Q0090774003093Q00E691C18294C1CC9BD703063Q00B5A3E9A42QE1025Q0080774003143Q00959474B0F44BEB19D5927EB8F546E914D49771B903083Q0020E5A54781C47EDF025Q0060774003043Q001C0FF5FD03043Q00964E6E9B025Q0050774003403Q00BC758A9602E5D442EB2383975AECD314E625DF925BE38741BB23D99055B38548BB22DF9155E6D217EE2582C300B4D648ED2889C450B0D147EF218E9657E4854803083Q0071DE10BAA763D5E3025Q004077402Q033Q00E2317303073Q0044A36623B2271E025Q0030774003243Q007C8809D74C2Q2D8310831D7E2E960CD34B7965D905D31B32708B0B8718797EDE0BDB182C03063Q001F48BB3DE22E025Q0020774003043Q00FB79E91D03053Q0036A31C8772025Q0010774003093Q00D22248DA3D6FB6E52903073Q00D9975A2DB9481B026Q00774003133Q00A38E95909DF811EB879F9398F711E2829F929103073Q0025D3B6ADA1A9C1025Q00E0764003043Q00887EDD7803063Q007ADA1FB3133E025Q00D0764003403Q007F4F7A7C5357784D7E2F52507D4B2E7351502B4E2D7F5350791F762E5405791D2B2E005F784A2D7D52507647797252037B4F2A2E570276477C7F5004291C7B2B03063Q00674F7E4F4A61025Q00C076402Q033Q00A0F16103063Q003CE1A63192A9025Q00B0764003093Q00DA2B0C0927ECF0211A03063Q00989F53696A52025Q00A0764003143Q00BAE0BDB627BC11F8E9BBB426B81EF3E9BFB32EBB03073Q0027CAD18D87178E025Q0080764003043Q00268C8B3C03063Q003974EDE55747025Q0070764003803Q00015D6D06218374045F6A0920877A01586D0F248174045A680C238777015A680D248171045A6A0C228277045F6D0A248571055F6E0920877A045E6D07248771055A6C09268277045C6D0A248074045F6709278773015D680C248271035A6D0C2287710459680A218371015F6709268777045E680C218574055A680C258270045803073Q0042376C5E3F12B4025Q0060764003063Q00B8D539E7941203083Q0066EBBA5586E67350025Q0050764003093Q003BF870C9FF9F16C40D03083Q00B67E8015AA8AEB79025Q0040764003133Q004455DFE3F2E7D70152D4E2F1E4D1035ED4E6F003073Q00E43466E7D6C5D0025Q0020764003043Q002A42EDC103073Q002B782383AA6636025Q0010764003803Q005117BBA05411BEA45112BBA65117BEA55117BBA75119BEA15115BBA65110BBA05115BBA75119BEA25414BEA35416BEA45110BBA65113BEA15112BEA45413BBA25112BEA05415BEA35416BEAA5411BEA75111BEA65113BEA05111BEAA5118BEA45413BEA45416BBA75110BEA35412BEA55412BEA55415BEA25413BEA55115BEA403043Q009362208D026Q00764003063Q0063F60ABE4D7E03083Q001A309966DF3F1F99025Q00F0754003093Q00DAF8B7BA1D2AF0F2A103063Q005E9F80D2D968025Q00E0754003133Q005C62B4FF5A1F62B4F7501D63B3FD51186CB7FE03053Q00692C5A83CE025Q00C0754003043Q00E7CAF8A403083Q00DFB5AB96CFC3961C025Q00B0754003803Q004FAD5CB44FAB5CB44FAC5CB74AAA5CB44FAA59B64FA25CB44FAC59B14FA95CB64FAC59B64FA859B74FAB5CB34AAD59B34FAD59B24FAB59B54AAF59B24FA259B44FAD5CB74FAC59B24FA95CB14FA259B74FAE5CB34AAF59B14FA859B74AA85CB34AAE5CB34AA859BA4FA259B24FAB5CB44FAA59BB4AA859B04AAA59B54FAE59B603043Q00827C9B6A025Q00A0754003063Q007010B6A6107203063Q0013237FDAC762025Q0090754003093Q001D2A16802D261C912B03043Q00E3585273025Q0080754003133Q009A484AFF8CD94F4AFE8DDE4B4DFF84D2464BFF03053Q00BCEA7F79C6025Q0060754003043Q00C32443E403053Q00B991452D8F025Q0050754003803Q004B2C7013FD4A2D711DF94B2B7013F8482D7A18F94B28701AF8482D721DFF4E2B7013FD492D721DFA4B2C751EFD4B2D7018F94E2B751AF84028721DFE4B297013F84F2D7318F94E2B701CFD49287218FE4E2D701EF84128711DFE4B2A751EF84F28751DF94E287518FD4E28761DFD4E28751EF84D2D761DFF4B2C751AF84C287103053Q00CB781E432B025Q0040754003063Q00B058DC144F3E03063Q005FE337B0753D025Q0030754003093Q0017FB8D3E5C4E3DF19B03063Q003A5283E85D29025Q0020754003133Q00E9815AF3EA8305F9A08658F2EE8300FFA1835B03083Q00C899B76AC3DEB234026Q00754003043Q003F58393503063Q00986D39575E45025Q00F0744003803Q001CE44F8512DBF51FE44B8310DFFA19E14A8612DBF01EE44C8617DAF619E44F8417D8F51FE4448613DAF11CE34F8612D9F51EE4498612DFF219E14A8317DFF01CE4498317DFF11CE24F8012D8F012E44D8615DFFA19E44F8117DDF51FE44E8617DFF219EE4A8112DFF518E14A8618DFF019E14F8617D9F51CE4448619DAF01CE103073Q00C32AD77CB521EC025Q00E0744003063Q00E0B62306C1B803043Q0067B3D94F025Q00D0744003093Q00F59ABCF016F7DBC29103073Q00B4B0E2D9936383025Q00C0744003133Q005693A4BE2EBC1F9FABBF2EB9129CAAB82CB81703063Q008F26AB93891C025Q00A0744003043Q00142A2BB403053Q0081464B45DF025Q0090744003403Q00E144B3E31CE0E746E2B345B4B311E1B34EE3B31CB2E648E6E013B7B349B3B146B0E31FECB741B3B71FEDB243B0B71BE7B210B5B74CB0BB14B0B71FB4B615E6E203063Q00D583252QD67D025Q0080744003083Q008C33318AA7F5F1BA03073Q0083DF565DE3D094025Q0070744003803Q00189A42BB7CF8189147BB7CF8189742BF79FD189047BD79FA189747B47CF9189147BB7CF91D9242B87CFC189A42BB79FE189047BB7CFB189442BE7CFB1D9142BE7CF8189647B579FD1D9247BA79FC189342B87CF1189647BA7CF81D9147BC79FC189042BF79FE1D9647B87CFB1D9247B47CF81D9147B97CF0189447BC7CFA189703063Q00C82BA3748D4F025Q0060744003063Q003FFDF189630D03053Q00116C929DE8025Q0050744003093Q005D92CB40BA4632436B03083Q003118EAAE23CF325D025Q0040744003143Q000EE1565940BC4AE4545B4FB94CE755584FBB4CE403063Q00887ED0666878025Q0020744003043Q00C3E23E2803053Q00C491835043025Q0010744003803Q00B55C72681F5129BF57776A1C542EB55D726A1A5429B557756A195128B55D726E1F532CB552756F18512BB057776A1F5129B252746F1F512FB05577681F532CB557726F18542FB555776D1A5229B152726A1D542DB551776A1F5E29B057756F19542BB55D726B1F5029B352706A1A5129B052776D1F522CB752746F1A5422B05503073Q001A866441592C67026Q00744003063Q001EB4E23B3FBA03043Q005A4DDB8E025Q00F0734003093Q0030EEF51A1E521AE4E303063Q0026759690796B025Q00E0734003133Q009DA5DCB86CD4A3DDB669DEA3D6BD68DCA5DDBA03053Q005DED90E58F025Q00C0734003043Q00610A7A7803053Q005A336B1413025Q00B0734003243Q00973FE94AA961C76EA04BAE669576BC43FD338E63EF16AD7B9B6BBB17AE30953EBB4BAE6503063Q0056A35B8D7298025Q00A0734003043Q003D8C1E1B03073Q003F65E97074B42F025Q0090734003603Q0057F9FE10FCB1BED3092QFB41FBECBB850EAEA841A8E9EAD756ACFC42FDBEBB850E2QF616FBBBEF840AF7AC41ACBFB5D55AF6FE17FB2QB8805EF9AB4AABBDB98509FBAA45A8EBBBD05FADAF12AEBCB4840AF7AB41A7ECB5D25EAEFA17A9BEE98603083Q00B16FCFCE739F888C025Q0080734003043Q0015DED3A303083Q001142BFA5C687EC77025Q0070734003093Q00ADB9ECC1619CAEFBD103053Q0014E8C189A2025Q0060734003133Q006AE56026D0642EDA2EE96526D16C2FD92CEB6503083Q00EB1ADC5214E6551B025Q0040734003043Q00CCA2C77C03053Q00349EC3A917025Q0030734003243Q00EC3BBE7F058501E572B77603814FE46EE22419D955E76BAA7E04D607E339B12302D954E603073Q0062D55F874634E0025Q00207340030F3Q00FDF2742FDBD74E2B97C02Q07D2D64803043Q005FB7B827025Q0010734003243Q00A12B677184400114B57F6E7FD4085315FD2D737182175609A07F682D83435441AE76687B03083Q0024984F5E48B52562026Q00734003043Q0081B6A91003073Q0090D9D3C77FE893025Q00F0724003093Q002591ECBD159DE6AC1303043Q00DE60E989025Q00E0724003133Q00F05A71BCAB9DB05575B0A891B15172B1A69DB103063Q00A4806342899F025Q00C0724003043Q0083B3002603073Q00C0D1D26E4D97BA025Q00B0724003603Q00AF3D4EB0FA664EB3A86F48B0FC674EE7AA6C49B5AA6E4EBCAE6A1CBDAF6F48B7A13C48E1A83C4FB1FA3D41E0AC3E4CE6A03E4BB4AD691AE5A03D1BB7A03C40B3FF3A19E1A96F48E7FF3A4DE1A96F4BB0AC3D41B2A03E19B0A96B4AE0F8664BE503043Q0084995F78025Q00A0724003043Q00EDDEB58203053Q00B3BABFC3E7025Q0090724003093Q009DC57301A7407734AB03083Q0046D8BD1662D23418025Q0080724003133Q00A996876D17ED9687671BEC9F86671BEC9B886603053Q002FD9AEB05F025Q0060724003043Q001FED25D103073Q00E24D8C4BBA68BC025Q0050724003243Q00BB7AA81920BD95E8A574AD1B77F190E9ED29E4172AEBC3F5B07DFF4A24BA97BDBE74FF1C03083Q00D8884DC92F12DCA1025Q0040724003043Q004AEDCAAC03073Q00191288A4C36B23025Q0030724003803Q007D1D68810744AF7F1868830447A97D186D860241AF7C186B860642AD7D1F68800745AF7E1D6C830742AB78186D860747AF7F1D6F860042AF781F6D870247AF7C1868860047A878196D830242AF7D1D6C830742AF7D196D810740AF7F186A860142A87D136D870246AF771D6C830042AB7D126D830249AF7B1D6B860547AD7D1303073Q009C4E2B5EB53171025Q0020724003063Q0090A9C3CB2F2603083Q00CBC3C6AFAA5D47ED025Q0010724003093Q002D241F431119F21A2F03073Q009D685C7A20646D026Q00724003133Q00C6207EF2B1D9FC4F872C79F0B4D8FB468F2C7F03083Q0076B61549C387ECCC025Q00E0714003043Q0092420BE503043Q008EC02365025Q00D0714003403Q005AC056AD126BF10C9107FE4237F65B920EFC1761A30AC605AB4567AE089253AA1032A7099C03A31B32A60B9101AE1731A401C452AD1262F55A9551AA4265AE0803073Q009738A5379A2353025Q00C071402Q033Q00CF8AC803063Q00B98EDD98E322025Q00B0714003603Q002QE475F19609BEB374A59F08ECBF22F7945DBCE276FF935DE4B372A3C45DE5E176F0C10CEEE274A7940EECB070FF930AEDBE70A7910DE8B276F09659E8E621F3C10CEDE175F5935EE9E373FE915AEDE474FF900BEAB670A2C65EE5B121A4975803063Q003CDD8744C6A7025Q00A0714003043Q00D2BC413503063Q005485DD3750AF025Q0090714003803Q00DF80458AEB01DF8F458CEB03DF89408BEB09DF88458DEE03DA894580EE02DF81458CEE04DF8E458DEB06DA8C408DEB04DF88458DEB07DA8C408FEB00DF8C458FEB03DF80458EEB02DF8A4589EB00DF8F4589EB02DA8B4588EE03DF89408DEB09DF80458BEB06DF8E408AEE03DF8C4581EB03DA8E408AEB07DA8C4588EB05DF8103063Q0030ECB876B9D8025Q0080714003063Q00CF58F154417B03063Q001A9C379D3533025Q0070714003093Q000B9B15453CCE21912Q03063Q00BA4EE3702649025Q0060714003133Q0039FF636B78F9626C7EFA656170F8616071F46003043Q005849CC50025Q0040714003043Q000EDCCD1803053Q00555CBDA373025Q0030714003803Q000895F87E9C0F92FC759B0D93FD729C0C92FE75970890F8769C0E92F3709A0895FD749C0692FA75980894F8739C0697F9759C0D90F871990A97FD709D0D95F870990B92FF759A0D93F8779C0D92FD759E0895FD77990A97FD759E0D99FD729C0B92FC70990D99F8739C0F97F875990897F871990B97FF709A0D92F870990C97FF03053Q00AF3EA1CB46025Q0020714003063Q001F76E8593E7803043Q00384C1984025Q0010714003093Q000F30A440633E27B35003053Q00164A48C123026Q00714003133Q00FAEC77BB1168BCE674BA156EB2E577B4106FB803063Q005F8AD5448320025Q00E0704003043Q00785986E903043Q00822A38E8025Q00D0704003803Q00E7D8837F6AFE63E6DA857D6DFB60E7D886786FFE66E3DA857D6EFE61E2D883766FFF66E7DF857D65FE6DE7DE83766FF466E3DA827D6FFB64E2DB837D6FFC63E7DA86786DFE61E7DF867C6FFA66E1DA897D69FE62E7DB83776AFF66E0DF867D6DFB66E7DC867C6FF963E5DF817D6AFE66E7DF837D6FFA66E0DF857D68FE66E7D903073Q0055D4E9B04E5CCD025Q00C0704003063Q00B758F25B965603043Q003AE4379E025Q00B0704003093Q0034BEA8AD23071EB4BE03063Q007371C6CDCE56025Q00A0704003143Q00EA1DB3AA20AB18BBAD27A21CB1AB2EAF15BAAD2603053Q00179A2C829C025Q0080704003043Q009F2B5D4703053Q00D6CD4A332C025Q002Q704003803Q00E9D22FA60C9977EED02CA50A9870ECD72AA30C9C72EFD52EA50E9D74E9DE2FA70C9777EFD52EA00D9875E9D02FA20C9A72E9D528A00C9D77E9D62FA7099C77EED52BA0079872E9D12AA70C9772E8D02BA00F9D70ECD22FA10C9777E9D52CA00E9876E9D52AA60C9777E3D529A00D9D77E9D62AA7099872ECD02DA50C9870E9DE03073Q0044DAE619933FAE025Q0060704003063Q001F5F50B9D1AA03073Q00424C303CD8A3CB025Q0050704003093Q0065B0A2E00554A7B5F003053Q007020C8C783025Q0040704003143Q00ED77544A5174AD7F534A5B72AF705D475C79A97003063Q00409D46657269025Q0020704003043Q007402E72703063Q00762663894C33025Q0010704003803Q00F0E3B1969552232CF0E2B19995512321F0E2B49790552320F0EBB4979557232DF5E0B4939550232CF5E0B1919556262CF0E6B4979557232DF5E0B12Q9057262CF0E5B1979050232FF0E0B19795522329F5E7B49790562329F0E6B4939557232CF5E6B1929050262EF5E6B49795532629F0E7B12Q9057232DF5E5B1929553232F03083Q0018C3D382A1A66310026Q00704003063Q00D8CABDE0DCEA03053Q00AE8BA5D181025Q00E06F4003093Q000911E30F391DE91E3F03043Q006C4C6986025Q00C06F4003133Q00FDA75EA4AB80BBA85CA0A98EB8AF55A5AA83BB03063Q00B78D9E6D9398025Q00806F4003043Q009DCACFC503043Q00AECFABA1025Q00606F4003803Q00FF5B88D36CF85B89D269FA508DD86CFA5B8BD268FF5A88D369F85E8FD268FF5C88D26CFA5E8FD26BFA5F88D269FC5B8FD26FFF5B8DD669FC5B87D267FA588DD46CF05B8BD769FF5B8DD269FB5B88D26BFF5B8DD569F85B8ED26BFF5D8DD36CFA5B8AD26FFF598DD36CFB5E8BD26EFA598DD76CF15E8FD26EFA598DD569F85B8B03053Q005FC968BEE1025Q00406F4003063Q003AA231721BAC03043Q001369CD5D025Q00206F4003093Q0078ADA78448A1AD954E03043Q00E73DD5C2026Q006F4003133Q001BD0FD125CD1F4105ED6F71652D3F6115FD7FD03043Q00246BE7C4025Q00C06E4003043Q003A58075403043Q003F683969025Q00A06E4003243Q0062887A0CD1FBB288788F790682E2E589308B360686F9EC956DDD2D5A84A9E2DD63D42D0C03083Q00B855ED1B3FB2CFD4025Q00806E4003043Q009CE543BC03063Q0060C4802DD384025Q00606E4003803Q00AA4290A8DFF0A361AA4C95A8DAF5A366AF4095A4DAF3A667AA4490A9DFF4A361AA4490A9DAF5A667AA4D95A4DFF1A361AA4D95AADFF7A661AA4395A5DFF3A364AA4D90AADAF3A362AA4190AEDFF8A36DAA4590ADDAF0A364AA4D95A9DAF7A36CAA4395ABDFF9A360AA4690A8DFF9A363AF4695ADDAF0A36CAA4390A9DFF3A36403083Q00559974A69CECC190025Q00406E4003063Q001E3BA9DD64AE03083Q00E64D54C5BC16CFB7025Q00206E4003093Q00809200CD6C62AA981603063Q0016C5EA65AE19026Q006E4003143Q003C80974FA795BA1D7A829049AB98BA1F7582914B03083Q002A4CB1A67A92A18D025Q00C06D4003043Q008556CB1603063Q00DED737A57D41025Q00A06D4003803Q0023E0081E8527E208198326E6081D852DE20C1C8326E5081E8526E20F1C8726E20818852CE20B198123E2081A852DE70D1C8423E208138023E70D198423E7081B8524E70D198426E0081A8026E20B198F26E508188521E20E198226E9081B8520E209198326E8081F8524E709198123E50D198026E7081C8423E5081B8527E70F03053Q00B615D13B2A025Q00806D4003063Q00294D2FA22D4803083Q006E7A2243C35F2985025Q00606D4003093Q0021F7A1C0244E0BFDB703063Q003A648FC4A351025Q00406D4003143Q002C148EE1AE2E546C148AE4A22C5E6C1384E7AD2D03073Q006D5C25BCD49A1D026Q006D4003043Q00ECA5554703073Q0028BEC43B2C24BC025Q00E06C4003803Q006E85E98F2418740B6E83EC8B211874076E84EC8C241B74016E82EC89241874066E8CEC8B241A74066E81EC8F241E74056E80EC8E211D74026B81E984241A74006E83EC8E241D71016B85E985211874016E84E98D211C74056E86E98D241971036B85E988241774036E82EC8F211C71046E83EC89241D74076B82E98B211B740103083Q00325DB4DABD172E47025Q00C06C4003063Q00B88B39BAFC8A03073Q001DEBE455DB8EEB025Q00A06C4003093Q0055D78C8AAA027FDD9A03063Q007610AF2QE9DF025Q00806C4003133Q00E1BF7DE271A9BA7DE073A1BA75EE76A0BE7EE103053Q0045918A4CD6025Q00406C4003043Q00E888510903063Q008DBAE93F626C025Q00206C4003803Q00A5A22A50D089A5A12A50D58EA5A22F55D08A2QA52A57D088A0A42F55D58BA5AE2A57D585A5A42F57D584A0A42F54D58DA5AE2A56D585A5A32A57D584A5A62A55D58EA5A12F55D589A0A72F50D588A5A12A57D5882QA52F53D588A5A42A56D584A0A32F52D58FA0A52A54D589A5A62A55D588A5A72F53D089A5AF2F55D08AA0A503063Q00BC2Q961961E6026Q006C4003063Q00F537B537AB2Q03063Q0062A658D956D9025Q00E06B4003093Q00EE6CC034473716D96703073Q0079AB14A5573243025Q00C06B4003133Q00D68BD48C7EB99488D78677B2938BD2897EB89303063Q008AA6B9E3BE4E025Q00806B4003043Q00F62E2Q2F03053Q006FA44F4144025Q00606B4003803Q00022750601D012E0022526016072B022650661D052E012250601A022A072555611D052E052753651A072B0220506018062E06225560190229022655621D0C2E02275660160728022555611D062E002250601C07280221556B18002E072250601D022C0727556B1D062B0C2257651A072A072150611D0D2E0127536017022E022603073Q0018341466532E34025Q00406B4003063Q00D435E771F53B03043Q0010875A8B025Q00206B4003093Q0036B4835F06B8894E0003043Q003C73CCE6026Q006B4003143Q0024E172B362E377B162E57AB063E474B760E176B203043Q008654D043025Q00C06A4003043Q00B0D0AF8603063Q00E4E2B1C1EDD9025Q00A06A4003803Q00500A90AE500A90A9500990A3550D95A8500C95AA550B90AB550B95AA550E95AD550A95AA550990AA550D95AA500B90AD550C95AD500F95AD550D90AF500E90A8550D90A3500D95AE550C90A8550B90AF500795AA500E95AF500695A9500790A8500A95A8500690A3550B90AD550990A3500A90AE500695A8500C90A9550B95AA03043Q009B633FA3025Q00806A4003063Q004833B341A3DA03083Q00C51B5CDF20D1BB11025Q00606A4003093Q00ED420B2E0CCCA091DB03083Q00E3A83A6E4D79B8CF025Q00406A4003133Q0010D0F10851D4F10152DFF20052D6F60252D0FB03043Q003060E7C2026Q006A4003043Q0036444A2103053Q00A96425244A025Q00E0694003803Q00B68C5B6070B08A5D6072B38A5B6475B18F5B6073B38C5B6070B08A5D6076B38F5E6575BD8A5B607EB68E5B6775B78A5E6071B68B5B6175BC8A5E6573B6815E6175B68F5D6074B38A5B6B75B38A5A6572B38C5B6675B48A5F6075B38B5B6775BC8A516076B38A5B6475BC8F5B6077B68E5B6A75BC8A586073B38B5E6275B78A5803053Q004685B96853025Q00C0694003063Q007B7EB8FFD74903053Q00A52811D49E025Q00A0694003093Q001CBEB02A9F2DB8D22A03083Q00A059C6D549EA59D7025Q0080694003133Q003F4B0417A4D75E78400A18A7D7527F450A18A103073Q006B4F72322E97E7025Q0040694003043Q000B72774A03053Q00AE59131921025Q0020694003403Q0089405923AFAD89160371A8AD891E5622FDFF89475421A9A88A1F5320A9FFD9175975AAF98D165922F9AEDA1E0327AAFB80100520FDF88B145124FAF88147582503063Q00CBB8266013CB026Q0069402Q033Q00827BB103063Q006FC32CE17CDC025Q00E0684003803Q001906275D1C02225B1C022758190322591900225C1C0D275E1C0C275A1903275C1907225C1C03275F1C0D225A1C01275C1907275B1C00275F1C00275A190427581C00275A1907275D1C0D275A1C06225D1906275E1C0D275B1C07275F1C0D27581900225E1C01225D1C04225B1C03275C1904225E1903275C190727581906275903043Q00682F3514025Q00C0684003063Q00EE29FA42A7DC03053Q00D5BD469623025Q00A0684003093Q00D0A60F1862ECFAAC1903063Q009895DE6A7B17025Q0080684003143Q00962C7F448B9881D52C754E809983D42D78408E9A03073Q00B2E61D4D77B8AC025Q0040684003043Q009CEEB3B703043Q00DCCE8FDD025Q0020684003803Q00AC2007E3658EAAAC2203E56E88ADAC2607E1658BAFAE2207E06788ADA92702E7608AAFA62206E5638DA9AC2207E6658BAFA72202E06788AFA92502E7608BAFA92203E56688A9AC2002E0658AAFAB2706E5678DABA92302E5608FAAAE2705E56F8DABAC2202E3658CAFA92705E064882QA92302E3608FAFAE2201E5658DADAC2103073Q009C9F1134D656BE026Q00684003063Q002Q3E397C1F7F03063Q001E6D51551D6D025Q00E0674003093Q0073B7391D06F7FC44BC03073Q009336CF5C7E7383025Q00C0674003133Q00470E578D000C528F00085588060E51870E085003043Q00BE373864025Q0080674003043Q00D9C2EED203053Q00218BA380B9025Q0060674003403Q0059AC23B25AD75FFF76B30FD20DAC25E00ADB0FF576B60AD759FA76B45AD00FAE71B55E8157AF29B70ED45BAF73BD53D40FFF72E25CD50DFF75B308D45BFC75E103063Q00E26ECD10846B025Q004067402Q033Q0005219C03073Q00B74476CC815190025Q0020674003403Q000E51DB52755843A85F538B0A700A13FF0855DF0E700A48A90252890E7D5B40FA0C54DB5C245A15AF5F06D55F770913FE0953DE097C5744F303028E0F735F10F803083Q00CB3B60ED6B456F71026Q00674003083Q00054CFF1964CF244C03063Q00AE5629937013025Q00E0664003803Q00D778F0978B05E1DD7BF2978E00E6D77CF5968E07E4D07BF4928E05E3D27BF5918B05E4D77BFF928D00E7D77CF5928B0AE1D17EF5928C00E2D778F0908E01E1D07EF0928000E6D77BF5908B07E1D67BF4978D05E1D77BF0948B01E4D77BFF928B00E3D770F0978E07E1D77BF3928F00E6D77DF0958B0BE1D17BF4928005E0D27A03073Q00D2E448C6A1B833025Q00C0664003063Q00ECE8A2D9E1DE03053Q0093BF87CEB8025Q00A0664003093Q0004595507E2482C335203073Q004341213064973C025Q0080664003143Q00C2D48D73D7FF0283D28477D2FA0C87D78975DEFF03073Q0034B2E5BC43E7C9025Q0040664003043Q0099C2454D03083Q002DCBA32B26232A5B025Q0020664003803Q006FFE1F4093B5586AFE194B94B15F6AF91F4193B65D6FFB1E4B92B45B6FFA1A4D93B5586BFE1E4B90B45C6AF01F4896B65D6CFE1A4B95B1586FFC1A4E93B3586AFB144B95B1576FFE1F4F93B15D69FB144E96B15B6AF11A4C93B15D69FE194E94B1586AFC1F4C96B05D6EFE1D4E92B15F6AFE1A4C93B5586BFE1F4E94B15B6AFA03073Q006E59C82C78A082026Q00664003063Q00231B3EF4C4AF03073Q00C270745295B6CE025Q00E0654003093Q00C00150800A19204CF603083Q003E857935E37F6D4F025Q00C0654003133Q0092160809E59109DA1E0B06E69B07DB180D08E503073Q003EE22E2Q3FD0A9025Q0080654003043Q008A74ECFE03053Q00EDD8158295025Q0060654003403Q00F5077A13870A4F2FA2077012810C4075A2552D14830E4F70A6527146D65A4A77A2022D15810A4B24A0517D48D00A4974A2537D11D40B1E26AA517F468108192703083Q001693634970E23878025Q0040654003063Q004FF8253721A503063Q00C41C97495653025Q0020654003093Q0026DE724F16D2785E1003043Q002C63A617026Q00654003133Q00FEA4F468BFA4F264BBA6F369B7A3FB62BFA6F603043Q00508E97C2025Q00C0644003043Q0028B4860603043Q006D7AD5E8025Q00A0644003803Q0089B821BDD8908CBE24BDDD9489BE21BED89189BF24BCD89589BC24BEDD918CBA24BDD89F89BD24BFD89489B324BED89689B224B0DD968CBF21BDDD9389B224BDDD918CBF24B8D89E89B324BBD8968CB924B1DD918CB824BBD89689BE21BDD8948CB824BAD89E89BF24BFD8908CBF24BED89089B324B1DD918CB924BAD8978CBF03063Q00A7BA8B1788EB025Q0080644003063Q00EDA8C9DC61F003083Q006EBEC7A5BD13913D025Q0060644003093Q0067F65C8357FA56925103043Q00E0228E39025Q0040644003133Q0090A8D72464BEE545D5AEDA2F61B0E542D3AADA03083Q0076E09CE2165088D6026Q00644003043Q00744DCFA803063Q00A8262CA1C396025Q00E0634003803Q00D1A75777F4D2A75375F1D1A65770F4D3A75475FBD4A65275F4D3A75675F4D1A15277F1D1A75175F3D4A55270F1D3A75275FAD4A25774F4D4A75070F3D4A6577EF1D3A75270F4D4AD5273F1D7A75C70F7D4A15772F4D5A25775F5D4AC5770F1D7A25775FBD1A25777F4D1A25570F6D1A5577FF4D2A75075FAD4AC577EF1D1A75D03053Q00C2E7946446025Q00C0634003063Q00DFA70FC54EED03053Q003C8CC863A4025Q00A0634003093Q001506851B542411920B03053Q0021507EE078025Q0080634003143Q0040F0A776137D09F8A171157E03F6AC74177802F703063Q004E30C1954324025Q0040634003043Q00341E5CCC03073Q00EB667F32A7CC12025Q0020634003803Q00532B512D1D5ADC512055291D5DDF53245127185ED9582556291A58D956205128185CDC5220572C1A5DDF5622512B1D5DD950255629195DDE5625512E1856DC54205B291E58DC53205126185EDC522053291E58DC53205429185AD95520522C195DD95622512E1857D95325532C1B5DDC5620542B1856D9532057291F5DDE532303073Q00EA6013621F2B6E026Q00634003063Q00971600BB57A903083Q0050C4796CDA25C8D5025Q00E0624003093Q00A92441E14616832E5703063Q0062EC5C248233025Q00C0624003133Q003B4A7E06D8D4947B4A7F00DDDE9678407D0DDC03073Q00A24B724835EBE7025Q0080624003043Q00E480F14203053Q00BFB6E19F29025Q0060624003803Q00A5BB0B8F7601A5BC0B857302A0BF0E827305A0BD0B8F7303A0BA0E807602A0BD0E827601A5BE0B807603A5BB0E857602A0BD0B847302A0BB0E847300A5BB0B847601A0B60E857604A0BE0B817603A0BC0B8F7305A0BE0B857605A5BD0E82760FA5BA0B8F7601A5BE0E857607A5BC0E807600A0BD0E847303A0B60E877300A0BD03063Q0036938F38B645025Q0040624003063Q006B182B474A1603043Q0026387747025Q0020624003093Q006362510D265275461D03053Q0053261A346E026Q00624003133Q00EBF6E57FAFF8E47DA3FCE479ABFCE67BADFFE703043Q00489BCED2025Q00C0614003043Q008152C47B03083Q00A1D333AA107A5D35025Q00A0614003603Q006D570BBC395F5BB43D005BBC3A075FBA3E5E5BBD60545BEE68000BB9690558B83D5E55B4395554EE39555CB96C030BEE695708B4685E0FB568040EBF6B5F54BD6F5F58EE3E545CBA685409B86F055BEF3C025ABD6F535CEF695E5BE96C515FBC03043Q008D58666D025Q0080614003043Q00032716C503053Q0095544660A0025Q0060614003093Q00F3B8082CD6C2AF1F3C03053Q00A3B6C06D4F025Q0040614003143Q004E92A7B17A920A97A4B77D900E91A7B17A920E9A03063Q00A03EA395854C026Q00614003043Q008B0D8D2A03073Q00CCD96CE3416255025Q00E0604003803Q00515FF105EBB544F05458F406EEBD41F8545FF403EEB644F9515BF103EEB541FA515EF404EBB644F05150F102EEB644F1515AF407EEB444F0515CF40EEEB244F8545DF104EEB544FB545DF406EBB244F9515DF406EBB044FC545AF404EBB044F1515BF100EEB441FB2Q51F403EEB241FD545CF40EEEB444FC515EF405EEB444F803083Q00C96269C736DD8477025Q00C0604003063Q003CA9217EF5E903063Q00886FC64D1F87025Q00A0604003093Q00D669F30F055EFC63E503063Q002A9311966C70025Q0080604003143Q000BBCD407BE65694CBFD408BE2Q6E4CB4D007BC6E03073Q00597B8DE6318D5D025Q0040604003043Q00FC7FBC0803053Q00E5AE1ED263025Q0020604003803Q00D7150B76D7120E78D7130B79D2140B7ED7110E7AD7130B7BD7120E7AD7180B79D7130B76D7130B7BD7130B7BD7110E7CD7130B7CD7150B7FD2100E7AD7140B78D2120E7AD7100B7DD7100E7AD2140E78D7120E7DD2130E7BD7170B7AD2170B7FD2150B7FD7120E7DD7150E7FD7120B76D7150E7DD7100B7FD7180B7FD7100B7C03043Q004EE42138026Q00604003063Q001EC153EA54CE03073Q00E04DAE3F8B26AF025Q00C05F4003403Q008A85765F76038C847B087656DF847F0A7A52DE80790F2D04DD837E0D2A528380285D29018F89770F7A078F80790D2C028386780F79048B857B0477058F842C0E03063Q0037BBB14E3C4F025Q00805F4003083Q00B7C40CB02830DA8103073Q00A8E4A160D95F51025Q00405F4003093Q00E8FF18F80FD9E80FE803053Q007AAD877D9B026Q005F4003133Q0021548AE2A089E4685582ECA181ED625284E4A803073Q00DD5161B2D498B0025Q00805E4003043Q002021367703063Q00147240581CDC025Q00405E4003803Q00924B5BA45122EF90415AA65523E092425EA75120EF97445CA65723EE92445BA65421EA97445BA35726EA92415EA25122EA90445BA65023EB97445EAC5127EA964458A35426EF92405BA15129EA98445BA65B23E892425EA25126EA984159A35623EA92445EA35424EA91415AA35123EC924B5BA15423EA95445FA35423EB924603073Q00D9A1726D956210026Q005E4003063Q006E797F1D61AA03073Q002D3D16137C13CB025Q00C05D4003093Q00164A57F5EC275D40E503053Q0099532Q3296025Q00805D4003143Q00AEA5521DDBEBA45713D1E8A65213D3EAA2561CD103053Q00E3DE946325026Q005D4003043Q00F6CA1DCF03073Q00C8A4AB73A43D96025Q00C05C4003243Q0041AD666C2746FC60797743A960792743F833797714A966792E42AB30627044F8636D204103053Q0016729D5554025Q00805C4003043Q00CCA8B8DB03073Q003994CDD6B4C836025Q00405C4003803Q00E5E1B085E5EDB585E0E7B084E5E2B583E0E4B588E5E6B580E5E0B588E5E2B085E5EDB585E5ECB084E5E6B587E0E3B081E0E4B587E5E3B580E5E2B585E0E7B580E0E4B5812QE0B589E5E7B580E0E7B582E5E4B584E5E6B086E5E1B081E5E1B082E0E3B588E5E1B085E0E6B587E0E6B082E0E3B5872QE0B085E5EDB081E0E1B58903043Q00B0D6D586026Q005C4003063Q008982A4D3A88C03043Q00B2DAEDC8025Q00C05B4003093Q009C3BAE77AAAB4AA6AA03083Q00D4D943CB142QDF25025Q00805B4003143Q005E41662D1F4260231B45612A1940612B1941672303043Q001A2E7057026Q005B4003043Q00764BC07E03053Q0050242AAE15025Q00C05A4003243Q00B471B2092D21C4E66FB55A2F748BB373E25E3673C5B427AA042B27C3B424B1592D2890B103073Q00A68242873C1B11025Q00805A4003043Q002BD08CF403063Q00A773B5E29B8A025Q00405A4003803Q0067D32FEE62D22FEB62D62FE962D32FEC62D02AEE62D12FEE67D42FEA67D02FE862DA2AEA67D12AE862D12FEC62D22FEB67D02FE967D32FED67D72AED62DA2FE862D42FED62D02FEE62D42AE867D12FEF67D32FE467D72AE967D12AE862D52AEE62D32FEC67D12FEE62D62AEF67D12FEA62D62FE462D32FE567D02FE967D32FE403043Q00DC51E21C026Q005A4003063Q006F0ACCAE30D903063Q00B83C65A0CF42025Q00C0594003093Q00E79913FD2CFA57D09203073Q0038A2E1769E598E025Q0080594003133Q0025E3D8A38C65ECDFAA8C60E4D3A68361ECDDAA03053Q00BA55D4EB92026Q00594003043Q00CFCC1ADE03063Q00D79DAD74B52E025Q00C0584003803Q006D6CAFA56D6CAAA5686AAAA56D6CAAA06D6AAFA76D6EAAA96D6EAFA56D6AAAA66D6EAAA46D6CAAA3686AAFA4686CAFA06D66AFA5686AAFA3686CAAA46D69AAA06D6FAAA66D69AAA76D69AFA02Q6DAAA66D68AAA96D6EAAA5686CAFA52Q6DAAA36D6AAFA26D6EAAA16D6CAAA26D67AAA9686DAFA26D67AFA76869AFA36D6EAAA903043Q00915E5F99025Q0080584003063Q00DB0255FFC9E303083Q004E886D399EBB82E2025Q0040584003093Q00E45A37D510D54D20C503053Q0065A12252B6026Q00584003143Q0095E361591A1BDFD6EB60521916DADDEA655F1B1603073Q00E9E5D2536B282E025Q0080574003043Q00D3C93CF103083Q002281A8529A8F509C025Q0040574003803Q00E4B42AA5BF9DE4BD2FA3BF9DE1B12AA2BA98E4B62FA6BA93E4B62FA4BA9BE4B32AA7BA93E4B22FA6BA92E4B22AA4BF9EE1B12FA6BA92E4B72AA4BA98E1B32FA1BA9DE4B42AA1BA98E4B02AA4BA92E4BC2AA6BF9DE4BC2FA1BA9EE1B32FA3BA99E4B52FA3BF9AE1B32FA7BA9EE1B72AA1BA9FE1B02AA0BF9AE1B32FA6BA9FE4BD03063Q00ABD785199589026Q00574003063Q0016DE565BA12403053Q00D345B12Q3A025Q00C0564003243Q007E2F850E797B8C0A672F83087A63840A2F2B9859732B8116727E835E7C28835E7C77830803043Q003B4A4EB5025Q0080564003043Q00B4F8423D03073Q001AEC9D2C52722C025Q0040564003093Q00D2EB39D1E2E733C0E403043Q00B297935C026Q00564003133Q0090F094AB0EA6D3FE93A303AFD2F193AC07A9D103063Q009FE0C7A79B37025Q0080554003043Q00C670FBA603073Q00E7941195CD454D025Q0040554003803Q009D247205AE669B98247D07AB659D98257702AB659B9E247D02AC659D9821770CAB659B98217707A9609A982F7200AE669B99247607AE609198207700AE679E9A247107A560909D247206AE642Q9E217202AB659B98247207AB629B9E247C02A9659A98207700AB609B99217207A4659B98207702AE619E9A247507AF609E9D2403073Q00A8AB1744349D53026Q00554003063Q00D40DF6C8F52Q03043Q00A987629A025Q00C0544003093Q001243DA2A954251254803073Q003E573BBF49E036025Q0080544003143Q00B5FB714740519202F0FA734B44519505F5F8764B03083Q0031C5CA437E7364A7026Q00544003043Q009E2FA54003083Q0069CC4ECB2BA7377E025Q00C0534003243Q005062526B04003657775F563654770C503700770504330377055164036C5B573750630B5203053Q003D6152665A025Q0080534003043Q00DC74724603073Q008084111C29BB2F025Q0040534003803Q0071ED949871E895EC05E395EA029CE29A009B96EF089C99EE069B92E20399949A059997ED71E8E59D04EA94EC0698929F72EAE3EB079F94EB079B939E07ED91EE089B90E800ECE59E76EDE39905EAE0E900992QE27199E0EE74EFE59A719BE0EE039F969E08EF94E8749CE4E806EA96EA73EB94EC712QE3E2089BE5E2769B94EB03043Q00DB30DAA1026Q00534003093Q0041587984EE9877014D03063Q00EB122117E59E025Q00C0524003603Q0078DE33FFA8E9657BDD64A8FAED6478DB67A8F0BF6273DE66FDAFB8667FDA67FEAAE53378D863FDF0ED617ADE66AFACEB617ADD36F8FABF332EDB36F9A8BE307ADE62A8F9EE62288E33AFFEE96373DF64AAFAE53078DB36F5FDED64798D68A8FA03073Q00564BEC50CCC9DD025Q0080524003043Q00791627AD03083Q003A2E7751C891D025025Q0040524003803Q00E901E517E902E518E907E516E901E516E907E014EC02E013E905E513E906E517E905E517EC02E515E901E517E904E015EC06E517E90CE013EC02E014EC05E014E906E516EC05E511E900E518E906E511EC06E014E90CE515E902E516E907E515E90DE016E905E512EC00E516E904E518EC00E014EC06E016E902E510E906E01403043Q0020DA34D6026Q00524003063Q007D88EF2C5C8603043Q004D2EE783025Q00C0514003093Q0096300AFFC54FBC3A1C03063Q003BD3486F9CB0025Q0080514003144Q0007D1DAD176F9A84007D5DDD379FDA5490FD1D903083Q00907036E3EBE64ECD026Q00514003043Q00692FBA5D03053Q002D3B4ED436025Q00C0504003803Q00694FA2E36942A7E76C45A7E66940A7E76940A7E26947A2E46940A2E46C45A2E16942A7E06947A7E76C45A2E16943A7E16C43A7E76946A2E66947A7E3694EA7E66C40A7E66946A2E06946A7E76C45A7ED6C42A7ED6944A7E76942A7ED6947A2E76940A7E06940A7E76940A7ED6C44A7E16940A7EC6941A2E76C44A7EC6945A2E603043Q00D55A7694025Q0080504003063Q00B122A94BCE4103073Q0071E24DC52ABC20025Q0040504003093Q005D9F2B146D9321056B03043Q007718E74E026Q00504003133Q00CF4DA0456F8F46A54D6A8E4BA64F69884FA64803053Q005ABF7F947C026Q004F4003043Q00CFB25E4E03063Q00BF9DD330251C025Q00804E4003803Q006F645AEE4ABF72626A655AED4ABC77616A605AED4AB977636A605FE84ABD77636F645AE24FB877666F695AE34ABC72626F615AE94FBF77666F635FE94AB877666F655FED4FB977636F685AEB4AB972636A625FEF4ABD72676A625AEA4FBD77666A635AEE4ABE72666F695AE94ABB72676A675FED4ABD72676F625FEA4FBD776603083Q00555C5169DB798B41026Q004E4003063Q0011573BD9CC1503073Q0086423857B8BE74025Q00804D4003093Q008FD008C8D0B7D8F3B903083Q0081CAA86DABA5C3B7026Q004D4003133Q00A87A2D4C71A3BFED722D4870A8BFE1772F4E7003073Q008FD8421E7E449B026Q004C4003043Q007CAADE7903083Q00C42ECBB0124FA32D025Q00804B4003803Q00FD0565687965F80D60697C68FD0465697964FD08606F7C69FD0F656E7C67F808606D7C62FD0F606D7C68F80E606B7962FD05656A7962FD0B60697C63FD0A656E7C67FD0C60627965FD09656A7C66FD0E656F7C67F808606F7C64F808606B7962FD0A606E7C61FD04606F7967FD0560687962FD0C606C7C67FD0A606C7960FD0803063Q0051CE3C535B4F026Q004B4003063Q0032E8445E610003053Q00136187283F025Q00804A4003093Q0098C1254FA8CD2F5EAE03043Q002CDDB940026Q004A4003133Q005B8AE9184A2E188BEB1D432B1A81E018432A1E03063Q001D2BB3D82C7B026Q00494003043Q000EAE8F4703073Q00185CCFE12C8319025Q0080484003803Q0088DC47A4EF8F9C88D843A6ED8F9E88DD42A2EF88998FDD42A6EC8A9988DC42A1EA889C8EDD43A6EF8A9E88DB42A1EF8F9C8DD846A6E08F9E8DDD47A0EF899C8ED845A6E88A9988D342A6EA899C88D847A6EB8F9E88D342A5EA889C89DD47A6EF8F9A88D842ACEA899C8AD847A6E98F9688D242A7EF8D9989DD45A6EC8F9B8DD903073Q00AFBBEB7195D9BC026Q00484003063Q006A5947FC678703083Q006B39362B9D15E6E7025Q0080474003603Q00099BB70F5CABD95999B00503A6D4029BB30E5CF183029AE4525EF0D50B90B60402A4D208CDE7520FA186039BB7550CA4D70F9DE10E0BF7D90FCEB50F0DA0D10B90BD555CF0810ECAE65559F7D459CCB00E59A6D5589AB7050AA7D003C9E3550803073Q00E03AA885363A92026Q00474003043Q006F2165F903063Q00203840139C3A025Q0080464003093Q00C0567509F05A7F18F603043Q006A852E10026Q00464003143Q00AEA3939A6896E12CEFA69296639FE028E6A5939103083Q001EDE92A1A25AAED2026Q00454003043Q00D4C4C33603043Q005D86A5AD025Q0080444003803Q00FB2BEAD260FF2EEBD660FE20EFD165FB2BE9D366FE2EEAD660F82BEFD36BFE2BEAD260FD2BE0D36AFE29EFD360F52EECD36BFE2DEAD865F92BECD366FB29EAD465FF2EE8D36BFB29EFD465FC2BEED665FB2EEAD565F92EE8D365FE2CEFD265F92BEED665FB2EEAD560FB2BE8D360FE2EEAD765F82BE1D361FE2CEAD860FF2EEC03053Q0053CD18D9E0026Q00444003063Q0074C339DD164603053Q006427AC55BC025Q0080434003093Q0089B11447A3FFC0BEBA03073Q00AFCCC97124D68B026Q00434003133Q009C520914B715B7DF550E11B116B7DB5C0610BD03073Q0080EC653F268421026Q00424003043Q00E61E09D803073Q00E6B47F67B3D61C025Q0080414003243Q007480EE1C57D143126885EF1450C540412082F21451D0435D7DD4E949528E471573DDE91F03083Q007045E4DF2C64E871026Q00414003043Q0095D81EFF03063Q0096CDBD709018025Q00802Q4003603Q004CB8EFE7FFB9A34FBBBEE2F9B8F64EBBBDB3ADE5F243EEB9E5A8EDA64DB4BDE8A8EFF443BAEAE2AAEAA21FB9BBE5FEE8A34CB8B9E7AFE9A61FBFBAE3FCBEF71FBEEAE8AAECF24FB8E1B6AFBEF518ECEBE4FCBFF618B4E1E7F4ECA41BE8E1E6FC03073Q00C77A8DD8D0CCDD026Q002Q4003043Q00B62DDB1703053Q0087E14CAD72026Q003F4003803Q004763E46C1D6F7F4563EB6E18647A4263E16A18637A4363E66E1C64714263E46C1D637F4466E36E1F647B4765E46D18647F4763E66E18647E4765E16F18667F4366E06E1B617F4269E16E1D677F4363E56E1F617D4766E46918647F4763E36B16617F4260E46C1D637F4566E06E1C617D4765E16C18657A4563E06B1B647D426603073Q00497150D2582E57026Q003E4003063Q00F0008EF6D8C203053Q00AAA36FE297026Q003D4003093Q001D1687C5BF2C0190D503053Q00CA586EE2A6026Q003C4003133Q00C2BF62E4F5AA5D82B761E0F1AE5982B568E7F003073Q006BB28651D2C69E026Q003A4003043Q008AE8D5CF03043Q00A4D889BB026Q00394003803Q000E0C567A71B9410008507A70BE440E0F567A74BC410908517F75BE450B0F537B74B9440A0D5C7A73BB440B08562Q71BC440E08537A73BE402Q0B567974BE442Q0D5D7A7EBB430B0A567B71B9440E0D527F74BE4A0B0F567071BC440E08567A77BB410E0F567D74BC440D08537A72BE450B0A537F74BE440B08567F74BE410B0703073Q0072383E6549478D026Q00384003063Q00E7CBE25DC6C503043Q003CB4A48E026Q00374003093Q0073305A3B304AF7443B03073Q009836483F58453E026Q00364003133Q0017B8FC9754BBF1975EB8FD9F5FBDF49D55BFF203043Q00AE678EC5026Q00344003043Q00FA2F2E8B03073Q009CA84E40E0D479026Q00334003243Q009F077243E848C4553D42EA1DC6192145BC188A0C7643BB539F042611EF189151264DEF4D03063Q007EA7341074D9026Q00324003043Q003F13B72403043Q004B6776D9026Q00314003803Q00D8A1610FABFFDDA1610EABF7DDA6610FABFED8A3610CABF2D8A2610CABFFDDA16408AEF1D8A1610AABF0D8A3610DABF7DDA6640FAEF1D8A7640EABFED8A06409AEF2D8A8610AAEF4D8A96109ABFED8A6610EABF5D8A46408ABFED8A8640EABF3DDA36408AEF6D8A56409AEF3DDA5610EABF3D8A4610AABF3D8A7610CABF3D8A103063Q00C7EB90523D98026Q00304003063Q0085E626CA0AAF03083Q00A7D6894AAB78CE53026Q002E4003093Q0029D65B716B63FCF51F03083Q00876CAE3E121E1793026Q002C4003133Q00AB8D100C4CEB89160F4BE98B16084EE88B1B0B03053Q007EDBB9223D026Q002A402Q033Q0013EE1A03043Q00E849A14C026Q00284003043Q00F93D29ED03063Q00CAAB5C4786BE026Q00264003243Q0051EE89658057B9DB7ADC52E9887A8853BF8A7AD854EDD97A8152EC8E61DF54BFDD6E8F5103053Q00B962DAEB57026Q00244003043Q0084C6D90503063Q004BDCA3B76A62026Q00224003403Q004A400670481003241C1153761C415923181304271E17587C11415326101A06751915577D1B46577D481457724A17017C1B1550211C1555261147067D1D43587603043Q0045292260026Q0020402Q033Q0077FE9003073Q00DB36A9C05A3050026Q001C4003803Q00F58BDB7DA3EA8988DD0DD6E6F0FCAE7DD49BF58AD879A49D83FEAE7DA29CF0FCAC7DD39AF78BD978A4EB898AAF78D8E8F588DC0DD6E9F28BDE7BA5E8F7F9D809D99DF5FBA90AD2EFF48AD40FA59C8788D80ED99C828CDB7BD2E6F2FBDB09D69981FEAC7EA39DF287DE7CD1EC8088D90AD29A82FEA87BD2ED84FDD97CD89B878E03063Q00DFB1BFED4CE1026Q00184003093Q0047E3D2350367FF9C0E03053Q0073149ABC54026Q00144003603Q00F2D242F82A280FF6D346FB7C7D03F58014AD2D7A52F5D01AF0257A06FEDC46F1782400FED545AC242C53A58716F17E2C55F28340FB2E7E03A18316F9282A02F6D214FA252F02F28317AE2C2B52F68417FB7B7F53F28113F9787E55F3D41AFE2803073Q0037C7E523C81D1C026Q00104003043Q00CB416EE003073Q00569C2018851D26026Q00084003803Q0025F0EDA8156120F4EDAE106520F1EDAD106525F3EDA1156125F3E8AD156125F4E8AB106420F1E8AC106420F5EDA0156125F3EDAD106520F6E8AC156F25F4EDAF106025F0E8AD156020F5EDAF156E20FCE8AB156320F6EDAB106720FCEDAD156120F1E8AD156520F0E8AE156F20F3EDA9106420FDEDAA106225F7E8A9106220FD03063Q005613C5DE9826027Q004003063Q00E5F4A72500D703053Q0072B69BCB44026Q00F03F03093Q000336FB5303A8293CED03063Q00DC464E9E3076028Q0003133Q00D5871661E41D7894851161E61C7F978A1466E103073Q004AA5B32654D72903013Q005A03013Q005303013Q004100F00F3Q005E7Q001201000100013Q00206E000100010002001201000200013Q00206E000200020003001201000300013Q00206E000300030004001201000400053Q00068B0004000B000100010004AC3Q000B0001001201000400063Q00206E000500040007001201000600083Q00206E000600060009001201000700083Q00206E00070007000A00066600083Q000100062Q00B43Q00074Q00B43Q00014Q00B43Q00054Q00B43Q00024Q00B43Q00034Q00B43Q00064Q0098000900083Q00122Q000A000C3Q00122Q000B000D6Q0009000B000200104Q000B00094Q000900083Q00122Q000A000F3Q00122Q000B00106Q0009000B000200104Q000E00094Q000900083Q00122Q000A00123Q00122Q000B00136Q0009000B000200104Q001100094Q000900083Q00122Q000A00153Q00122Q000B00166Q0009000B000200104Q001400094Q000900083Q00122Q000A00183Q00122Q000B00196Q0009000B000200104Q001700094Q000900083Q00122Q000A001B3Q00122Q000B001C6Q0009000B000200104Q001A00094Q000900083Q00122Q000A001E3Q00122Q000B001F6Q0009000B000200104Q001D00094Q000900083Q00122Q000A00213Q00122Q000B00226Q0009000B000200104Q002000094Q000900083Q00122Q000A00243Q00122Q000B00256Q0009000B000200104Q002300094Q000900083Q00122Q000A00273Q00122Q000B00286Q0009000B000200104Q002600094Q000900083Q00122Q000A002A3Q00122Q000B002B6Q0009000B000200104Q002900094Q000900083Q00122Q000A002D3Q00122Q000B002E6Q0009000B000200104Q002C00094Q000900083Q00122Q000A00303Q00122Q000B00316Q0009000B000200104Q002F00094Q000900083Q00122Q000A00333Q00122Q000B00346Q0009000B000200104Q003200094Q000900083Q00122Q000A00363Q00122Q000B00376Q0009000B000200104Q003500094Q000900083Q00122Q000A00393Q00122Q000B003A6Q0009000B000200104Q003800092Q0098000900083Q00122Q000A003C3Q00122Q000B003D6Q0009000B000200104Q003B00094Q000900083Q00122Q000A003F3Q00122Q000B00406Q0009000B000200104Q003E00094Q000900083Q00122Q000A00423Q00122Q000B00436Q0009000B000200104Q004100094Q000900083Q00122Q000A00453Q00122Q000B00466Q0009000B000200104Q004400094Q000900083Q00122Q000A00483Q00122Q000B00496Q0009000B000200104Q004700094Q000900083Q00122Q000A004B3Q00122Q000B004C6Q0009000B000200104Q004A00094Q000900083Q00122Q000A004E3Q00122Q000B004F6Q0009000B000200104Q004D00094Q000900083Q00122Q000A00513Q00122Q000B00526Q0009000B000200104Q005000094Q000900083Q00122Q000A00543Q00122Q000B00556Q0009000B000200104Q005300094Q000900083Q00122Q000A00573Q00122Q000B00586Q0009000B000200104Q005600094Q000900083Q00122Q000A005A3Q00122Q000B005B6Q0009000B000200104Q005900094Q000900083Q00122Q000A005D3Q00122Q000B005E6Q0009000B000200104Q005C00094Q000900083Q00122Q000A00603Q00122Q000B00616Q0009000B000200104Q005F00094Q000900083Q00122Q000A00633Q00122Q000B00646Q0009000B000200104Q006200094Q000900083Q00122Q000A00663Q00122Q000B00676Q0009000B000200104Q006500094Q000900083Q00122Q000A00693Q00122Q000B006A6Q0009000B000200104Q006800092Q0098000900083Q00122Q000A006C3Q00122Q000B006D6Q0009000B000200104Q006B00094Q000900083Q00122Q000A006F3Q00122Q000B00706Q0009000B000200104Q006E00094Q000900083Q00122Q000A00723Q00122Q000B00736Q0009000B000200104Q007100094Q000900083Q00122Q000A00753Q00122Q000B00766Q0009000B000200104Q007400094Q000900083Q00122Q000A00783Q00122Q000B00796Q0009000B000200104Q007700094Q000900083Q00122Q000A007B3Q00122Q000B007C6Q0009000B000200104Q007A00094Q000900083Q00122Q000A007E3Q00122Q000B007F6Q0009000B000200104Q007D00094Q000900083Q00122Q000A00813Q00122Q000B00826Q0009000B000200104Q008000094Q000900083Q00122Q000A00843Q00122Q000B00856Q0009000B000200104Q008300094Q000900083Q00122Q000A00873Q00122Q000B00886Q0009000B000200104Q008600094Q000900083Q00122Q000A008A3Q00122Q000B008B6Q0009000B000200104Q008900094Q000900083Q00122Q000A008D3Q00122Q000B008E6Q0009000B000200104Q008C00094Q000900083Q00122Q000A00903Q00122Q000B00916Q0009000B000200104Q008F00094Q000900083Q00122Q000A00933Q00122Q000B00946Q0009000B000200104Q009200094Q000900083Q00122Q000A00963Q00122Q000B00976Q0009000B000200104Q009500094Q000900083Q00122Q000A00993Q00122Q000B009A6Q0009000B000200104Q009800092Q0098000900083Q00122Q000A009C3Q00122Q000B009D6Q0009000B000200104Q009B00094Q000900083Q00122Q000A009F3Q00122Q000B00A06Q0009000B000200104Q009E00094Q000900083Q00122Q000A00A23Q00122Q000B00A36Q0009000B000200104Q00A100094Q000900083Q00122Q000A00A53Q00122Q000B00A66Q0009000B000200104Q00A400094Q000900083Q00122Q000A00A83Q00122Q000B00A96Q0009000B000200104Q00A700094Q000900083Q00122Q000A00AB3Q00122Q000B00AC6Q0009000B000200104Q00AA00094Q000900083Q00122Q000A00AE3Q00122Q000B00AF6Q0009000B000200104Q00AD00094Q000900083Q00122Q000A00B13Q00122Q000B00B26Q0009000B000200104Q00B000094Q000900083Q00122Q000A00B43Q00122Q000B00B56Q0009000B000200104Q00B300094Q000900083Q00122Q000A00B73Q00122Q000B00B86Q0009000B000200104Q00B600094Q000900083Q00122Q000A00BA3Q00122Q000B00BB6Q0009000B000200104Q00B900094Q000900083Q00122Q000A00BD3Q00122Q000B00BE6Q0009000B000200104Q00BC00094Q000900083Q00122Q000A00C03Q00122Q000B00C16Q0009000B000200104Q00BF00094Q000900083Q00122Q000A00C33Q00122Q000B00C46Q0009000B000200104Q00C200094Q000900083Q00122Q000A00C63Q00122Q000B00C76Q0009000B000200104Q00C500094Q000900083Q00122Q000A00C93Q00122Q000B00CA6Q0009000B000200104Q00C800092Q0098000900083Q00122Q000A00CC3Q00122Q000B00CD6Q0009000B000200104Q00CB00094Q000900083Q00122Q000A00CF3Q00122Q000B00D06Q0009000B000200104Q00CE00094Q000900083Q00122Q000A00D23Q00122Q000B00D36Q0009000B000200104Q00D100094Q000900083Q00122Q000A00D53Q00122Q000B00D66Q0009000B000200104Q00D400094Q000900083Q00122Q000A00D83Q00122Q000B00D96Q0009000B000200104Q00D700094Q000900083Q00122Q000A00DB3Q00122Q000B00DC6Q0009000B000200104Q00DA00094Q000900083Q00122Q000A00DE3Q00122Q000B00DF6Q0009000B000200104Q00DD00094Q000900083Q00122Q000A00E13Q00122Q000B00E26Q0009000B000200104Q00E000094Q000900083Q00122Q000A00E43Q00122Q000B00E56Q0009000B000200104Q00E300094Q000900083Q00122Q000A00E73Q00122Q000B00E86Q0009000B000200104Q00E600094Q000900083Q00122Q000A00EA3Q00122Q000B00EB6Q0009000B000200104Q00E900094Q000900083Q00122Q000A00ED3Q00122Q000B00EE6Q0009000B000200104Q00EC00094Q000900083Q00122Q000A00F03Q00122Q000B00F16Q0009000B000200104Q00EF00094Q000900083Q00122Q000A00F33Q00122Q000B00F46Q0009000B000200104Q00F200094Q000900083Q00122Q000A00F63Q00122Q000B00F76Q0009000B000200104Q00F500094Q000900083Q00122Q000A00F93Q00122Q000B00FA6Q0009000B000200104Q00F800092Q008D000900083Q00122Q000A00FC3Q00122Q000B00FD6Q0009000B000200104Q00FB00092Q0048000900083Q00122Q000A00FF3Q00122Q000B2Q00015Q0009000B000200104Q00FE000900122Q0009002Q015Q000A00083Q00122Q000B0002012Q00122Q000C0003015Q000A000C00026Q0009000A00122Q00090004015Q000A00083Q00122Q000B0005012Q00122Q000C0006015Q000A000C00026Q0009000A00122Q00090007015Q000A00083Q00122Q000B0008012Q00122Q000C0009015Q000A000C00026Q0009000A00122Q0009000A015Q000A00083Q00122Q000B000B012Q00122Q000C000C015Q000A000C00026Q0009000A00122Q0009000D015Q000A00083Q00122Q000B000E012Q00122Q000C000F015Q000A000C00026Q0009000A00122Q00090010015Q000A00083Q00122Q000B0011012Q00122Q000C0012015Q000A000C00026Q0009000A00122Q00090013015Q000A00083Q00122Q000B0014012Q00122Q000C0015015Q000A000C00026Q0009000A00122Q00090016015Q000A00083Q00122Q000B0017012Q00122Q000C0018015Q000A000C00026Q0009000A00122Q00090019015Q000A00083Q00122Q000B001A012Q00122Q000C001B015Q000A000C00026Q0009000A00122Q0009001C015Q000A00083Q00122Q000B001D012Q00122Q000C001E015Q000A000C00026Q0009000A00122Q0009001F015Q000A00083Q00122Q000B0020012Q00122Q000C0021015Q000A000C00026Q0009000A00122Q00090022015Q000A00083Q00122Q000B0023012Q00122Q000C0024015Q000A000C00026Q0009000A00122Q00090025015Q000A00083Q00122Q000B0026012Q001264000C0027013Q0091000A000C00026Q0009000A00122Q00090028015Q000A00083Q00122Q000B0029012Q00122Q000C002A015Q000A000C00026Q0009000A00122Q0009002B015Q000A00083Q00122Q000B002C012Q00122Q000C002D015Q000A000C00026Q0009000A00122Q0009002E015Q000A00083Q00122Q000B002F012Q00122Q000C0030015Q000A000C00026Q0009000A00122Q00090031015Q000A00083Q00122Q000B0032012Q00122Q000C0033015Q000A000C00026Q0009000A00122Q00090034015Q000A00083Q00122Q000B0035012Q00122Q000C0036015Q000A000C00026Q0009000A00122Q00090037015Q000A00083Q00122Q000B0038012Q00122Q000C0039015Q000A000C00026Q0009000A00122Q0009003A015Q000A00083Q00122Q000B003B012Q00122Q000C003C015Q000A000C00026Q0009000A00122Q0009003D015Q000A00083Q00122Q000B003E012Q00122Q000C003F015Q000A000C00026Q0009000A00122Q00090040015Q000A00083Q00122Q000B0041012Q00122Q000C0042015Q000A000C00026Q0009000A00122Q00090043015Q000A00083Q00122Q000B0044012Q00122Q000C0045015Q000A000C00026Q0009000A00122Q00090046015Q000A00083Q00122Q000B0047012Q00122Q000C0048015Q000A000C00026Q0009000A00122Q00090049015Q000A00083Q00122Q000B004A012Q00122Q000C004B015Q000A000C00026Q0009000A00122Q0009004C015Q000A00083Q00122Q000B004D012Q00122Q000C004E015Q000A000C00026Q0009000A0012640009004F013Q00AE000A00083Q00122Q000B0050012Q00122Q000C0051015Q000A000C00026Q0009000A00122Q00090052015Q000A00083Q00122Q000B0053012Q00122Q000C0054015Q000A000C00026Q0009000A00122Q00090055015Q000A00083Q00122Q000B0056012Q00122Q000C0057015Q000A000C00026Q0009000A00122Q00090058015Q000A00083Q00122Q000B0059012Q00122Q000C005A015Q000A000C00026Q0009000A00122Q0009005B015Q000A00083Q00122Q000B005C012Q00122Q000C005D015Q000A000C00026Q0009000A00122Q0009005E015Q000A00083Q00122Q000B005F012Q00122Q000C0060015Q000A000C00026Q0009000A00122Q00090061015Q000A00083Q00122Q000B0062012Q00122Q000C0063015Q000A000C00026Q0009000A00122Q00090064015Q000A00083Q00122Q000B0065012Q00122Q000C0066015Q000A000C00026Q0009000A00122Q00090067015Q000A00083Q00122Q000B0068012Q00122Q000C0069015Q000A000C00026Q0009000A00122Q0009006A015Q000A00083Q00122Q000B006B012Q00122Q000C006C015Q000A000C00026Q0009000A00122Q0009006D015Q000A00083Q00122Q000B006E012Q00122Q000C006F015Q000A000C00026Q0009000A00122Q00090070015Q000A00083Q00122Q000B0071012Q00122Q000C0072015Q000A000C00026Q0009000A00122Q00090073015Q000A00083Q00122Q000B0074012Q00122Q000C0075015Q000A000C00026Q0009000A00122Q00090076015Q000A00083Q00122Q000B0077012Q001264000C0078013Q0091000A000C00026Q0009000A00122Q00090079015Q000A00083Q00122Q000B007A012Q00122Q000C007B015Q000A000C00026Q0009000A00122Q0009007C015Q000A00083Q00122Q000B007D012Q00122Q000C007E015Q000A000C00026Q0009000A00122Q0009007F015Q000A00083Q00122Q000B0080012Q00122Q000C0081015Q000A000C00026Q0009000A00122Q00090082015Q000A00083Q00122Q000B0083012Q00122Q000C0084015Q000A000C00026Q0009000A00122Q00090085015Q000A00083Q00122Q000B0086012Q00122Q000C0087015Q000A000C00026Q0009000A00122Q00090088015Q000A00083Q00122Q000B0089012Q00122Q000C008A015Q000A000C00026Q0009000A00122Q0009008B015Q000A00083Q00122Q000B008C012Q00122Q000C008D015Q000A000C00026Q0009000A00122Q0009008E015Q000A00083Q00122Q000B008F012Q00122Q000C0090015Q000A000C00026Q0009000A00122Q00090091015Q000A00083Q00122Q000B0092012Q00122Q000C0093015Q000A000C00026Q0009000A00122Q00090094015Q000A00083Q00122Q000B0095012Q00122Q000C0096015Q000A000C00026Q0009000A00122Q00090097015Q000A00083Q00122Q000B0098012Q00122Q000C0099015Q000A000C00026Q0009000A00122Q0009009A015Q000A00083Q00122Q000B009B012Q00122Q000C009C015Q000A000C00026Q0009000A00122Q0009009D015Q000A00083Q00122Q000B009E012Q00122Q000C009F015Q000A000C00026Q0009000A001264000900A0013Q00AE000A00083Q00122Q000B00A1012Q00122Q000C00A2015Q000A000C00026Q0009000A00122Q000900A3015Q000A00083Q00122Q000B00A4012Q00122Q000C00A5015Q000A000C00026Q0009000A00122Q000900A6015Q000A00083Q00122Q000B00A7012Q00122Q000C00A8015Q000A000C00026Q0009000A00122Q000900A9015Q000A00083Q00122Q000B00AA012Q00122Q000C00AB015Q000A000C00026Q0009000A00122Q000900AC015Q000A00083Q00122Q000B00AD012Q00122Q000C00AE015Q000A000C00026Q0009000A00122Q000900AF015Q000A00083Q00122Q000B00B0012Q00122Q000C00B1015Q000A000C00026Q0009000A00122Q000900B2015Q000A00083Q00122Q000B00B3012Q00122Q000C00B4015Q000A000C00026Q0009000A00122Q000900B5015Q000A00083Q00122Q000B00B6012Q00122Q000C00B7015Q000A000C00026Q0009000A00122Q000900B8015Q000A00083Q00122Q000B00B9012Q00122Q000C00BA015Q000A000C00026Q0009000A00122Q000900BB015Q000A00083Q00122Q000B00BC012Q00122Q000C00BD015Q000A000C00026Q0009000A00122Q000900BE015Q000A00083Q00122Q000B00BF012Q00122Q000C00C0015Q000A000C00026Q0009000A00122Q000900C1015Q000A00083Q00122Q000B00C2012Q00122Q000C00C3015Q000A000C00026Q0009000A00122Q000900C4015Q000A00083Q00122Q000B00C5012Q00122Q000C00C6015Q000A000C00026Q0009000A00122Q000900C7015Q000A00083Q00122Q000B00C8012Q001264000C00C9013Q0091000A000C00026Q0009000A00122Q000900CA015Q000A00083Q00122Q000B00CB012Q00122Q000C00CC015Q000A000C00026Q0009000A00122Q000900CD015Q000A00083Q00122Q000B00CE012Q00122Q000C00CF015Q000A000C00026Q0009000A00122Q000900D0015Q000A00083Q00122Q000B00D1012Q00122Q000C00D2015Q000A000C00026Q0009000A00122Q000900D3015Q000A00083Q00122Q000B00D4012Q00122Q000C00D5015Q000A000C00026Q0009000A00122Q000900D6015Q000A00083Q00122Q000B00D7012Q00122Q000C00D8015Q000A000C00026Q0009000A00122Q000900D9015Q000A00083Q00122Q000B00DA012Q00122Q000C00DB015Q000A000C00026Q0009000A00122Q000900DC015Q000A00083Q00122Q000B00DD012Q00122Q000C00DE015Q000A000C00026Q0009000A00122Q000900DF015Q000A00083Q00122Q000B00E0012Q00122Q000C00E1015Q000A000C00026Q0009000A00122Q000900E2015Q000A00083Q00122Q000B00E3012Q00122Q000C00E4015Q000A000C00026Q0009000A00122Q000900E5015Q000A00083Q00122Q000B00E6012Q00122Q000C00E7015Q000A000C00026Q0009000A00122Q000900E8015Q000A00083Q00122Q000B00E9012Q00122Q000C00EA015Q000A000C00026Q0009000A00122Q000900EB015Q000A00083Q00122Q000B00EC012Q00122Q000C00ED015Q000A000C00026Q0009000A00122Q000900EE015Q000A00083Q00122Q000B00EF012Q00122Q000C00F0015Q000A000C00026Q0009000A001264000900F1013Q00AE000A00083Q00122Q000B00F2012Q00122Q000C00F3015Q000A000C00026Q0009000A00122Q000900F4015Q000A00083Q00122Q000B00F5012Q00122Q000C00F6015Q000A000C00026Q0009000A00122Q000900F7015Q000A00083Q00122Q000B00F8012Q00122Q000C00F9015Q000A000C00026Q0009000A00122Q000900FA015Q000A00083Q00122Q000B00FB012Q00122Q000C00FC015Q000A000C00026Q0009000A00122Q000900FD015Q000A00083Q00122Q000B00FE012Q00122Q000C00FF015Q000A000C00026Q0009000A00122Q00092Q00025Q000A00083Q00122Q000B0001022Q00122Q000C002Q025Q000A000C00026Q0009000A00122Q00090003025Q000A00083Q00122Q000B0004022Q00122Q000C0005025Q000A000C00026Q0009000A00122Q00090006025Q000A00083Q00122Q000B0007022Q00122Q000C0008025Q000A000C00026Q0009000A00122Q00090009025Q000A00083Q00122Q000B000A022Q00122Q000C000B025Q000A000C00026Q0009000A00122Q0009000C025Q000A00083Q00122Q000B000D022Q00122Q000C000E025Q000A000C00026Q0009000A00122Q0009000F025Q000A00083Q00122Q000B0010022Q00122Q000C0011025Q000A000C00026Q0009000A00122Q00090012025Q000A00083Q00122Q000B0013022Q00122Q000C0014025Q000A000C00026Q0009000A00122Q00090015025Q000A00083Q00122Q000B0016022Q00122Q000C0017025Q000A000C00026Q0009000A00122Q00090018025Q000A00083Q00122Q000B0019022Q001264000C001A023Q0091000A000C00026Q0009000A00122Q0009001B025Q000A00083Q00122Q000B001C022Q00122Q000C001D025Q000A000C00026Q0009000A00122Q0009001E025Q000A00083Q00122Q000B001F022Q00122Q000C0020025Q000A000C00026Q0009000A00122Q00090021025Q000A00083Q00122Q000B0022022Q00122Q000C0023025Q000A000C00026Q0009000A00122Q00090024025Q000A00083Q00122Q000B0025022Q00122Q000C0026025Q000A000C00026Q0009000A00122Q00090027025Q000A00083Q00122Q000B0028022Q00122Q000C0029025Q000A000C00026Q0009000A00122Q0009002A025Q000A00083Q00122Q000B002B022Q00122Q000C002C025Q000A000C00026Q0009000A00122Q0009002D025Q000A00083Q00122Q000B002E022Q00122Q000C002F025Q000A000C00026Q0009000A00122Q00090030025Q000A00083Q00122Q000B0031022Q00122Q000C0032025Q000A000C00026Q0009000A00122Q00090033025Q000A00083Q00122Q000B0034022Q00122Q000C0035025Q000A000C00026Q0009000A00122Q00090036025Q000A00083Q00122Q000B0037022Q00122Q000C0038025Q000A000C00026Q0009000A00122Q00090039025Q000A00083Q00122Q000B003A022Q00122Q000C003B025Q000A000C00026Q0009000A00122Q0009003C025Q000A00083Q00122Q000B003D022Q00122Q000C003E025Q000A000C00026Q0009000A00122Q0009003F025Q000A00083Q00122Q000B0040022Q00122Q000C0041025Q000A000C00026Q0009000A00126400090042023Q00AE000A00083Q00122Q000B0043022Q00122Q000C0044025Q000A000C00026Q0009000A00122Q00090045025Q000A00083Q00122Q000B0046022Q00122Q000C0047025Q000A000C00026Q0009000A00122Q00090048025Q000A00083Q00122Q000B0049022Q00122Q000C004A025Q000A000C00026Q0009000A00122Q0009004B025Q000A00083Q00122Q000B004C022Q00122Q000C004D025Q000A000C00026Q0009000A00122Q0009004E025Q000A00083Q00122Q000B004F022Q00122Q000C0050025Q000A000C00026Q0009000A00122Q00090051025Q000A00083Q00122Q000B0052022Q00122Q000C0053025Q000A000C00026Q0009000A00122Q00090054025Q000A00083Q00122Q000B0055022Q00122Q000C0056025Q000A000C00026Q0009000A00122Q00090057025Q000A00083Q00122Q000B0058022Q00122Q000C0059025Q000A000C00026Q0009000A00122Q0009005A025Q000A00083Q00122Q000B005B022Q00122Q000C005C025Q000A000C00026Q0009000A00122Q0009005D025Q000A00083Q00122Q000B005E022Q00122Q000C005F025Q000A000C00026Q0009000A00122Q00090060025Q000A00083Q00122Q000B0061022Q00122Q000C0062025Q000A000C00026Q0009000A00122Q00090063025Q000A00083Q00122Q000B0064022Q00122Q000C0065025Q000A000C00026Q0009000A00122Q00090066025Q000A00083Q00122Q000B0067022Q00122Q000C0068025Q000A000C00026Q0009000A00122Q00090069025Q000A00083Q00122Q000B006A022Q001264000C006B023Q0091000A000C00026Q0009000A00122Q0009006C025Q000A00083Q00122Q000B006D022Q00122Q000C006E025Q000A000C00026Q0009000A00122Q0009006F025Q000A00083Q00122Q000B0070022Q00122Q000C0071025Q000A000C00026Q0009000A00122Q00090072025Q000A00083Q00122Q000B0073022Q00122Q000C0074025Q000A000C00026Q0009000A00122Q00090075025Q000A00083Q00122Q000B0076022Q00122Q000C0077025Q000A000C00026Q0009000A00122Q00090078025Q000A00083Q00122Q000B0079022Q00122Q000C007A025Q000A000C00026Q0009000A00122Q0009007B025Q000A00083Q00122Q000B007C022Q00122Q000C007D025Q000A000C00026Q0009000A00122Q0009007E025Q000A00083Q00122Q000B007F022Q00122Q000C0080025Q000A000C00026Q0009000A00122Q00090081025Q000A00083Q00122Q000B0082022Q00122Q000C0083025Q000A000C00026Q0009000A00122Q00090084025Q000A00083Q00122Q000B0085022Q00122Q000C0086025Q000A000C00026Q0009000A00122Q00090087025Q000A00083Q00122Q000B0088022Q00122Q000C0089025Q000A000C00026Q0009000A00122Q0009008A025Q000A00083Q00122Q000B008B022Q00122Q000C008C025Q000A000C00026Q0009000A00122Q0009008D025Q000A00083Q00122Q000B008E022Q00122Q000C008F025Q000A000C00026Q0009000A00122Q00090090025Q000A00083Q00122Q000B0091022Q00122Q000C0092025Q000A000C00026Q0009000A00126400090093023Q00AE000A00083Q00122Q000B0094022Q00122Q000C0095025Q000A000C00026Q0009000A00122Q00090096025Q000A00083Q00122Q000B0097022Q00122Q000C0098025Q000A000C00026Q0009000A00122Q00090099025Q000A00083Q00122Q000B009A022Q00122Q000C009B025Q000A000C00026Q0009000A00122Q0009009C025Q000A00083Q00122Q000B009D022Q00122Q000C009E025Q000A000C00026Q0009000A00122Q0009009F025Q000A00083Q00122Q000B00A0022Q00122Q000C00A1025Q000A000C00026Q0009000A00122Q000900A2025Q000A00083Q00122Q000B00A3022Q00122Q000C00A4025Q000A000C00026Q0009000A00122Q000900A5025Q000A00083Q00122Q000B00A6022Q00122Q000C00A7025Q000A000C00026Q0009000A00122Q000900A8025Q000A00083Q00122Q000B00A9022Q00122Q000C00AA025Q000A000C00026Q0009000A00122Q000900AB025Q000A00083Q00122Q000B00AC022Q00122Q000C00AD025Q000A000C00026Q0009000A00122Q000900AE025Q000A00083Q00122Q000B00AF022Q00122Q000C00B0025Q000A000C00026Q0009000A00122Q000900B1025Q000A00083Q00122Q000B00B2022Q00122Q000C00B3025Q000A000C00026Q0009000A00122Q000900B4025Q000A00083Q00122Q000B00B5022Q00122Q000C00B6025Q000A000C00026Q0009000A00122Q000900B7025Q000A00083Q00122Q000B00B8022Q00122Q000C00B9025Q000A000C00026Q0009000A00122Q000900BA025Q000A00083Q00122Q000B00BB022Q001264000C00BC023Q0091000A000C00026Q0009000A00122Q000900BD025Q000A00083Q00122Q000B00BE022Q00122Q000C00BF025Q000A000C00026Q0009000A00122Q000900C0025Q000A00083Q00122Q000B00C1022Q00122Q000C00C2025Q000A000C00026Q0009000A00122Q000900C3025Q000A00083Q00122Q000B00C4022Q00122Q000C00C5025Q000A000C00026Q0009000A00122Q000900C6025Q000A00083Q00122Q000B00C7022Q00122Q000C00C8025Q000A000C00026Q0009000A00122Q000900C9025Q000A00083Q00122Q000B00CA022Q00122Q000C00CB025Q000A000C00026Q0009000A00122Q000900CC025Q000A00083Q00122Q000B00CD022Q00122Q000C00CE025Q000A000C00026Q0009000A00122Q000900CF025Q000A00083Q00122Q000B00D0022Q00122Q000C00D1025Q000A000C00026Q0009000A00122Q000900D2025Q000A00083Q00122Q000B00D3022Q00122Q000C00D4025Q000A000C00026Q0009000A00122Q000900D5025Q000A00083Q00122Q000B00D6022Q00122Q000C00D7025Q000A000C00026Q0009000A00122Q000900D8025Q000A00083Q00122Q000B00D9022Q00122Q000C00DA025Q000A000C00026Q0009000A00122Q000900DB025Q000A00083Q00122Q000B00DC022Q00122Q000C00DD025Q000A000C00026Q0009000A00122Q000900DE025Q000A00083Q00122Q000B00DF022Q00122Q000C00E0025Q000A000C00026Q0009000A00122Q000900E1025Q000A00083Q00122Q000B00E2022Q00122Q000C00E3025Q000A000C00026Q0009000A001264000900E4023Q00AE000A00083Q00122Q000B00E5022Q00122Q000C00E6025Q000A000C00026Q0009000A00122Q000900E7025Q000A00083Q00122Q000B00E8022Q00122Q000C00E9025Q000A000C00026Q0009000A00122Q000900EA025Q000A00083Q00122Q000B00EB022Q00122Q000C00EC025Q000A000C00026Q0009000A00122Q000900ED025Q000A00083Q00122Q000B00EE022Q00122Q000C00EF025Q000A000C00026Q0009000A00122Q000900F0025Q000A00083Q00122Q000B00F1022Q00122Q000C00F2025Q000A000C00026Q0009000A00122Q000900F3025Q000A00083Q00122Q000B00F4022Q00122Q000C00F5025Q000A000C00026Q0009000A00122Q000900F6025Q000A00083Q00122Q000B00F7022Q00122Q000C00F8025Q000A000C00026Q0009000A00122Q000900F9025Q000A00083Q00122Q000B00FA022Q00122Q000C00FB025Q000A000C00026Q0009000A00122Q000900FC025Q000A00083Q00122Q000B00FD022Q00122Q000C00FE025Q000A000C00026Q0009000A00122Q000900FF025Q000A00083Q00122Q000B2Q00032Q00122Q000C0001035Q000A000C00026Q0009000A00122Q00090002035Q000A00083Q00122Q000B002Q032Q00122Q000C0004035Q000A000C00026Q0009000A00122Q00090005035Q000A00083Q00122Q000B0006032Q00122Q000C0007035Q000A000C00026Q0009000A00122Q00090008035Q000A00083Q00122Q000B0009032Q00122Q000C000A035Q000A000C00026Q0009000A00122Q0009000B035Q000A00083Q00122Q000B000C032Q001264000C000D033Q0091000A000C00026Q0009000A00122Q0009000E035Q000A00083Q00122Q000B000F032Q00122Q000C0010035Q000A000C00026Q0009000A00122Q00090011035Q000A00083Q00122Q000B0012032Q00122Q000C0013035Q000A000C00026Q0009000A00122Q00090014035Q000A00083Q00122Q000B0015032Q00122Q000C0016035Q000A000C00026Q0009000A00122Q00090017035Q000A00083Q00122Q000B0018032Q00122Q000C0019035Q000A000C00026Q0009000A00122Q0009001A035Q000A00083Q00122Q000B001B032Q00122Q000C001C035Q000A000C00026Q0009000A00122Q0009001D035Q000A00083Q00122Q000B001E032Q00122Q000C001F035Q000A000C00026Q0009000A00122Q00090020035Q000A00083Q00122Q000B0021032Q00122Q000C0022035Q000A000C00026Q0009000A00122Q00090023035Q000A00083Q00122Q000B0024032Q00122Q000C0025035Q000A000C00026Q0009000A00122Q00090026035Q000A00083Q00122Q000B0027032Q00122Q000C0028035Q000A000C00026Q0009000A00122Q00090029035Q000A00083Q00122Q000B002A032Q00122Q000C002B035Q000A000C00026Q0009000A00122Q0009002C035Q000A00083Q00122Q000B002D032Q00122Q000C002E035Q000A000C00026Q0009000A00122Q0009002F035Q000A00083Q00122Q000B0030032Q00122Q000C0031035Q000A000C00026Q0009000A00122Q00090032035Q000A00083Q00122Q000B0033032Q00122Q000C0034035Q000A000C00026Q0009000A00126400090035033Q00AE000A00083Q00122Q000B0036032Q00122Q000C0037035Q000A000C00026Q0009000A00122Q00090038035Q000A00083Q00122Q000B0039032Q00122Q000C003A035Q000A000C00026Q0009000A00122Q0009003B035Q000A00083Q00122Q000B003C032Q00122Q000C003D035Q000A000C00026Q0009000A00122Q0009003E035Q000A00083Q00122Q000B003F032Q00122Q000C0040035Q000A000C00026Q0009000A00122Q00090041035Q000A00083Q00122Q000B0042032Q00122Q000C0043035Q000A000C00026Q0009000A00122Q00090044035Q000A00083Q00122Q000B0045032Q00122Q000C0046035Q000A000C00026Q0009000A00122Q00090047035Q000A00083Q00122Q000B0048032Q00122Q000C0049035Q000A000C00026Q0009000A00122Q0009004A035Q000A00083Q00122Q000B004B032Q00122Q000C004C035Q000A000C00026Q0009000A00122Q0009004D035Q000A00083Q00122Q000B004E032Q00122Q000C004F035Q000A000C00026Q0009000A00122Q00090050035Q000A00083Q00122Q000B0051032Q00122Q000C0052035Q000A000C00026Q0009000A00122Q00090053035Q000A00083Q00122Q000B0054032Q00122Q000C0055035Q000A000C00026Q0009000A00122Q00090056035Q000A00083Q00122Q000B0057032Q00122Q000C0058035Q000A000C00026Q0009000A00122Q00090059035Q000A00083Q00122Q000B005A032Q00122Q000C005B035Q000A000C00026Q0009000A00122Q0009005C035Q000A00083Q00122Q000B005D032Q001264000C005E033Q0091000A000C00026Q0009000A00122Q0009005F035Q000A00083Q00122Q000B0060032Q00122Q000C0061035Q000A000C00026Q0009000A00122Q00090062035Q000A00083Q00122Q000B0063032Q00122Q000C0064035Q000A000C00026Q0009000A00122Q00090065035Q000A00083Q00122Q000B0066032Q00122Q000C0067035Q000A000C00026Q0009000A00122Q00090068035Q000A00083Q00122Q000B0069032Q00122Q000C006A035Q000A000C00026Q0009000A00122Q0009006B035Q000A00083Q00122Q000B006C032Q00122Q000C006D035Q000A000C00026Q0009000A00122Q0009006E035Q000A00083Q00122Q000B006F032Q00122Q000C0070035Q000A000C00026Q0009000A00122Q00090071035Q000A00083Q00122Q000B0072032Q00122Q000C0073035Q000A000C00026Q0009000A00122Q00090074035Q000A00083Q00122Q000B0075032Q00122Q000C0076035Q000A000C00026Q0009000A00122Q00090077035Q000A00083Q00122Q000B0078032Q00122Q000C0079035Q000A000C00026Q0009000A00122Q0009007A035Q000A00083Q00122Q000B007B032Q00122Q000C007C035Q000A000C00026Q0009000A00122Q0009007D035Q000A00083Q00122Q000B007E032Q00122Q000C007F035Q000A000C00026Q0009000A00122Q00090080035Q000A00083Q00122Q000B0081032Q00122Q000C0082035Q000A000C00026Q0009000A00122Q00090083035Q000A00083Q00122Q000B0084032Q00122Q000C0085035Q000A000C00026Q0009000A00126400090086033Q00AE000A00083Q00122Q000B0087032Q00122Q000C0088035Q000A000C00026Q0009000A00122Q00090089035Q000A00083Q00122Q000B008A032Q00122Q000C008B035Q000A000C00026Q0009000A00122Q0009008C035Q000A00083Q00122Q000B008D032Q00122Q000C008E035Q000A000C00026Q0009000A00122Q0009008F035Q000A00083Q00122Q000B0090032Q00122Q000C0091035Q000A000C00026Q0009000A00122Q00090092035Q000A00083Q00122Q000B0093032Q00122Q000C0094035Q000A000C00026Q0009000A00122Q00090095035Q000A00083Q00122Q000B0096032Q00122Q000C0097035Q000A000C00026Q0009000A00122Q00090098035Q000A00083Q00122Q000B0099032Q00122Q000C009A035Q000A000C00026Q0009000A00122Q0009009B035Q000A00083Q00122Q000B009C032Q00122Q000C009D035Q000A000C00026Q0009000A00122Q0009009E035Q000A00083Q00122Q000B009F032Q00122Q000C00A0035Q000A000C00026Q0009000A00122Q000900A1035Q000A00083Q00122Q000B00A2032Q00122Q000C00A3035Q000A000C00026Q0009000A00122Q000900A4035Q000A00083Q00122Q000B00A5032Q00122Q000C00A6035Q000A000C00026Q0009000A00122Q000900A7035Q000A00083Q00122Q000B00A8032Q00122Q000C00A9035Q000A000C00026Q0009000A00122Q000900AA035Q000A00083Q00122Q000B00AB032Q00122Q000C00AC035Q000A000C00026Q0009000A00122Q000900AD035Q000A00083Q00122Q000B00AE032Q001264000C00AF033Q0091000A000C00026Q0009000A00122Q000900B0035Q000A00083Q00122Q000B00B1032Q00122Q000C00B2035Q000A000C00026Q0009000A00122Q000900B3035Q000A00083Q00122Q000B00B4032Q00122Q000C00B5035Q000A000C00026Q0009000A00122Q000900B6035Q000A00083Q00122Q000B00B7032Q00122Q000C00B8035Q000A000C00026Q0009000A00122Q000900B9035Q000A00083Q00122Q000B00BA032Q00122Q000C00BB035Q000A000C00026Q0009000A00122Q000900BC035Q000A00083Q00122Q000B00BD032Q00122Q000C00BE035Q000A000C00026Q0009000A00122Q000900BF035Q000A00083Q00122Q000B00C0032Q00122Q000C00C1035Q000A000C00026Q0009000A00122Q000900C2035Q000A00083Q00122Q000B00C3032Q00122Q000C00C4035Q000A000C00026Q0009000A00122Q000900C5035Q000A00083Q00122Q000B00C6032Q00122Q000C00C7035Q000A000C00026Q0009000A00122Q000900C8035Q000A00083Q00122Q000B00C9032Q00122Q000C00CA035Q000A000C00026Q0009000A00122Q000900CB035Q000A00083Q00122Q000B00CC032Q00122Q000C00CD035Q000A000C00026Q0009000A00122Q000900CE035Q000A00083Q00122Q000B00CF032Q00122Q000C00D0035Q000A000C00026Q0009000A00122Q000900D1035Q000A00083Q00122Q000B00D2032Q00122Q000C00D3035Q000A000C00026Q0009000A00122Q000900D4035Q000A00083Q00122Q000B00D5032Q00122Q000C00D6035Q000A000C00026Q0009000A001264000900D7033Q00AE000A00083Q00122Q000B00D8032Q00122Q000C00D9035Q000A000C00026Q0009000A00122Q000900DA035Q000A00083Q00122Q000B00DB032Q00122Q000C00DC035Q000A000C00026Q0009000A00122Q000900DD035Q000A00083Q00122Q000B00DE032Q00122Q000C00DF035Q000A000C00026Q0009000A00122Q000900E0035Q000A00083Q00122Q000B00E1032Q00122Q000C00E2035Q000A000C00026Q0009000A00122Q000900E3035Q000A00083Q00122Q000B00E4032Q00122Q000C00E5035Q000A000C00026Q0009000A00122Q000900E6035Q000A00083Q00122Q000B00E7032Q00122Q000C00E8035Q000A000C00026Q0009000A00122Q000900E9035Q000A00083Q00122Q000B00EA032Q00122Q000C00EB035Q000A000C00026Q0009000A00122Q000900EC035Q000A00083Q00122Q000B00ED032Q00122Q000C00EE035Q000A000C00026Q0009000A00122Q000900EF035Q000A00083Q00122Q000B00F0032Q00122Q000C00F1035Q000A000C00026Q0009000A00122Q000900F2035Q000A00083Q00122Q000B00F3032Q00122Q000C00F4035Q000A000C00026Q0009000A00122Q000900F5035Q000A00083Q00122Q000B00F6032Q00122Q000C00F7035Q000A000C00026Q0009000A00122Q000900F8035Q000A00083Q00122Q000B00F9032Q00122Q000C00FA035Q000A000C00026Q0009000A00122Q000900FB035Q000A00083Q00122Q000B00FC032Q00122Q000C00FD035Q000A000C00026Q0009000A00122Q000900FE035Q000A00083Q00122Q000B00FF032Q001264000C2Q00043Q0091000A000C00026Q0009000A00122Q00090001045Q000A00083Q00122Q000B0002042Q00122Q000C0003045Q000A000C00026Q0009000A00122Q0009002Q045Q000A00083Q00122Q000B0005042Q00122Q000C0006045Q000A000C00026Q0009000A00122Q00090007045Q000A00083Q00122Q000B0008042Q00122Q000C0009045Q000A000C00026Q0009000A00122Q0009000A045Q000A00083Q00122Q000B000B042Q00122Q000C000C045Q000A000C00026Q0009000A00122Q0009000D045Q000A00083Q00122Q000B000E042Q00122Q000C000F045Q000A000C00026Q0009000A00122Q00090010045Q000A00083Q00122Q000B0011042Q00122Q000C0012045Q000A000C00026Q0009000A00122Q00090013045Q000A00083Q00122Q000B0014042Q00122Q000C0015045Q000A000C00026Q0009000A00122Q00090016045Q000A00083Q00122Q000B0017042Q00122Q000C0018045Q000A000C00026Q0009000A00122Q00090019045Q000A00083Q00122Q000B001A042Q00122Q000C001B045Q000A000C00026Q0009000A00122Q0009001C045Q000A00083Q00122Q000B001D042Q00122Q000C001E045Q000A000C00026Q0009000A00122Q0009001F045Q000A00083Q00122Q000B0020042Q00122Q000C0021045Q000A000C00026Q0009000A00122Q00090022045Q000A00083Q00122Q000B0023042Q00122Q000C0024045Q000A000C00026Q0009000A00122Q00090025045Q000A00083Q00122Q000B0026042Q00122Q000C0027045Q000A000C00026Q0009000A00126400090028043Q00AE000A00083Q00122Q000B0029042Q00122Q000C002A045Q000A000C00026Q0009000A00122Q0009002B045Q000A00083Q00122Q000B002C042Q00122Q000C002D045Q000A000C00026Q0009000A00122Q0009002E045Q000A00083Q00122Q000B002F042Q00122Q000C0030045Q000A000C00026Q0009000A00122Q00090031045Q000A00083Q00122Q000B0032042Q00122Q000C0033045Q000A000C00026Q0009000A00122Q00090034045Q000A00083Q00122Q000B0035042Q00122Q000C0036045Q000A000C00026Q0009000A00122Q00090037045Q000A00083Q00122Q000B0038042Q00122Q000C0039045Q000A000C00026Q0009000A00122Q0009003A045Q000A00083Q00122Q000B003B042Q00122Q000C003C045Q000A000C00026Q0009000A00122Q0009003D045Q000A00083Q00122Q000B003E042Q00122Q000C003F045Q000A000C00026Q0009000A00122Q00090040045Q000A00083Q00122Q000B0041042Q00122Q000C0042045Q000A000C00026Q0009000A00122Q00090043045Q000A00083Q00122Q000B0044042Q00122Q000C0045045Q000A000C00026Q0009000A00122Q00090046045Q000A00083Q00122Q000B0047042Q00122Q000C0048045Q000A000C00026Q0009000A00122Q00090049045Q000A00083Q00122Q000B004A042Q00122Q000C004B045Q000A000C00026Q0009000A00122Q0009004C045Q000A00083Q00122Q000B004D042Q00122Q000C004E045Q000A000C00026Q0009000A00122Q0009004F045Q000A00083Q00122Q000B0050042Q001264000C0051043Q0091000A000C00026Q0009000A00122Q00090052045Q000A00083Q00122Q000B0053042Q00122Q000C0054045Q000A000C00026Q0009000A00122Q00090055045Q000A00083Q00122Q000B0056042Q00122Q000C0057045Q000A000C00026Q0009000A00122Q00090058045Q000A00083Q00122Q000B0059042Q00122Q000C005A045Q000A000C00026Q0009000A00122Q0009005B045Q000A00083Q00122Q000B005C042Q00122Q000C005D045Q000A000C00026Q0009000A00122Q0009005E045Q000A00083Q00122Q000B005F042Q00122Q000C0060045Q000A000C00026Q0009000A00122Q00090061045Q000A00083Q00122Q000B0062042Q00122Q000C0063045Q000A000C00026Q0009000A00122Q00090064045Q000A00083Q00122Q000B0065042Q00122Q000C0066045Q000A000C00026Q0009000A00122Q00090067045Q000A00083Q00122Q000B0068042Q00122Q000C0069045Q000A000C00026Q0009000A00122Q0009006A045Q000A00083Q00122Q000B006B042Q00122Q000C006C045Q000A000C00026Q0009000A00122Q0009006D045Q000A00083Q00122Q000B006E042Q00122Q000C006F045Q000A000C00026Q0009000A00122Q00090070045Q000A00083Q00122Q000B0071042Q00122Q000C0072045Q000A000C00026Q0009000A00122Q00090073045Q000A00083Q00122Q000B0074042Q00122Q000C0075045Q000A000C00026Q0009000A00122Q00090076045Q000A00083Q00122Q000B0077042Q00122Q000C0078045Q000A000C00026Q0009000A00126400090079043Q00AE000A00083Q00122Q000B007A042Q00122Q000C007B045Q000A000C00026Q0009000A00122Q0009007C045Q000A00083Q00122Q000B007D042Q00122Q000C007E045Q000A000C00026Q0009000A00122Q0009007F045Q000A00083Q00122Q000B0080042Q00122Q000C0081045Q000A000C00026Q0009000A00122Q00090082045Q000A00083Q00122Q000B0083042Q00122Q000C0084045Q000A000C00026Q0009000A00122Q00090085045Q000A00083Q00122Q000B0086042Q00122Q000C0087045Q000A000C00026Q0009000A00122Q00090088045Q000A00083Q00122Q000B0089042Q00122Q000C008A045Q000A000C00026Q0009000A00122Q0009008B045Q000A00083Q00122Q000B008C042Q00122Q000C008D045Q000A000C00026Q0009000A00122Q0009008E045Q000A00083Q00122Q000B008F042Q00122Q000C0090045Q000A000C00026Q0009000A00122Q00090091045Q000A00083Q00122Q000B0092042Q00122Q000C0093045Q000A000C00026Q0009000A00122Q00090094045Q000A00083Q00122Q000B0095042Q00122Q000C0096045Q000A000C00026Q0009000A00122Q00090097045Q000A00083Q00122Q000B0098042Q00122Q000C0099045Q000A000C00026Q0009000A00122Q0009009A045Q000A00083Q00122Q000B009B042Q00122Q000C009C045Q000A000C00026Q0009000A00122Q0009009D045Q000A00083Q00122Q000B009E042Q00122Q000C009F045Q000A000C00026Q0009000A00122Q000900A0045Q000A00083Q00122Q000B00A1042Q001264000C00A2043Q0091000A000C00026Q0009000A00122Q000900A3045Q000A00083Q00122Q000B00A4042Q00122Q000C00A5045Q000A000C00026Q0009000A00122Q000900A6045Q000A00083Q00122Q000B00A7042Q00122Q000C00A8045Q000A000C00026Q0009000A00122Q000900A9045Q000A00083Q00122Q000B00AA042Q00122Q000C00AB045Q000A000C00026Q0009000A00122Q000900AC045Q000A00083Q00122Q000B00AD042Q00122Q000C00AE045Q000A000C00026Q0009000A00122Q000900AF045Q000A00083Q00122Q000B00B0042Q00122Q000C00B1045Q000A000C00026Q0009000A00122Q000900B2045Q000A00083Q00122Q000B00B3042Q00122Q000C00B4045Q000A000C00026Q0009000A00122Q000900B5045Q000A00083Q00122Q000B00B6042Q00122Q000C00B7045Q000A000C00026Q0009000A00122Q000900B8045Q000A00083Q00122Q000B00B9042Q00122Q000C00BA045Q000A000C00026Q0009000A00122Q000900BB045Q000A00083Q00122Q000B00BC042Q00122Q000C00BD045Q000A000C00026Q0009000A00122Q000900BE045Q000A00083Q00122Q000B00BF042Q00122Q000C00C0045Q000A000C00026Q0009000A00122Q000900C1045Q000A00083Q00122Q000B00C2042Q00122Q000C00C3045Q000A000C00026Q0009000A00122Q000900C4045Q000A00083Q00122Q000B00C5042Q00122Q000C00C6045Q000A000C00026Q0009000A00122Q000900C7045Q000A00083Q00122Q000B00C8042Q00122Q000C00C9045Q000A000C00026Q0009000A001264000900CA043Q00AE000A00083Q00122Q000B00CB042Q00122Q000C00CC045Q000A000C00026Q0009000A00122Q000900CD045Q000A00083Q00122Q000B00CE042Q00122Q000C00CF045Q000A000C00026Q0009000A00122Q000900D0045Q000A00083Q00122Q000B00D1042Q00122Q000C00D2045Q000A000C00026Q0009000A00122Q000900D3045Q000A00083Q00122Q000B00D4042Q00122Q000C00D5045Q000A000C00026Q0009000A00122Q000900D6045Q000A00083Q00122Q000B00D7042Q00122Q000C00D8045Q000A000C00026Q0009000A00122Q000900D9045Q000A00083Q00122Q000B00DA042Q00122Q000C00DB045Q000A000C00026Q0009000A00122Q000900DC045Q000A00083Q00122Q000B00DD042Q00122Q000C00DE045Q000A000C00026Q0009000A00122Q000900DF045Q000A00083Q00122Q000B00E0042Q00122Q000C00E1045Q000A000C00026Q0009000A00122Q000900E2045Q000A00083Q00122Q000B00E3042Q00122Q000C00E4045Q000A000C00026Q0009000A00122Q000900E5045Q000A00083Q00122Q000B00E6042Q00122Q000C00E7045Q000A000C00026Q0009000A00122Q000900E8045Q000A00083Q00122Q000B00E9042Q00122Q000C00EA045Q000A000C00026Q0009000A00122Q000900EB045Q000A00083Q00122Q000B00EC042Q00122Q000C00ED045Q000A000C00026Q0009000A00122Q000900EE045Q000A00083Q00122Q000B00EF042Q00122Q000C00F0045Q000A000C00026Q0009000A00122Q000900F1045Q000A00083Q00122Q000B00F2042Q0012A8000C00F3045Q000A000C00026Q0009000A00122Q000900F4045Q000A00083Q00122Q000B00F5042Q00122Q000C00F6045Q000A000C00026Q0009000A00122Q000900F7043Q00B4000A00083Q001233000B00F8042Q00122Q000C00F9045Q000A000C00026Q0009000A00122Q000900FA045Q000A00083Q00122Q000B00FB042Q00122Q000C00FC045Q000A000C00026Q0009000A001264000900FD043Q000F000A00083Q00122Q000B00FE042Q00122Q000C00FF045Q000A000C00026Q0009000A00122Q000900FD045Q000A000A3Q001264000B00FD042Q000613000900B10901000B0004AC3Q00B10901001264000B00FD042Q001264000C00FD042Q000613000B00B50901000C0004AC3Q00B509012Q005E000C3Q002100129A000D00FD045Q000D3Q000D4Q000E3Q000200122Q000F00FA045Q000F3Q000F4Q00103Q000500122Q001100F7045Q00113Q00114Q001200013Q00122Q001300F4043Q007600133Q00132Q00090012000100012Q0042001000110012001255001100F1045Q00113Q00114Q001200013Q00122Q001300EE045Q00133Q00134Q0012000100012Q0042001000110012001255001100EB045Q00113Q00114Q001200013Q00122Q001300E8045Q00133Q00134Q0012000100012Q0042001000110012001255001100E5045Q00113Q00114Q001200013Q00122Q001300E2045Q00133Q00134Q0012000100012Q0042001000110012001255001100DF045Q00113Q00114Q001200013Q00122Q001300DC045Q00133Q00134Q0012000100012Q00420010001100122Q0029000E000F001000122Q000F00D9045Q000F3Q000F00122Q001000D6045Q00103Q00104Q000E000F00104Q000C000D000E00122Q000D00D3045Q000D3Q000D4Q000E3Q0002001264000F00D0043Q0079000F3Q000F4Q00103Q000200122Q001100CD045Q00113Q00114Q001200013Q00122Q001300CA045Q00133Q00134Q0012000100012Q0042001000110012001255001100C7045Q00113Q00114Q001200013Q00122Q001300C4045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00C1045Q000F3Q000F00122Q00102Q00055Q000E000F00104Q000C000D000E00122Q000D00BE045Q000D3Q000D4Q000E3Q000200122Q000F00BB043Q0079000F3Q000F4Q00103Q000100122Q001100B8045Q00113Q00114Q001200013Q00122Q001300B5045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00B2045Q000F3Q000F00122Q00102Q00055Q000E000F00104Q000C000D000E00122Q000D00AF045Q000D3Q000D4Q000E3Q000200122Q000F00AC043Q0079000F3Q000F4Q00103Q000300122Q001100A9045Q00113Q00114Q001200013Q00122Q001300A6045Q00133Q00134Q0012000100012Q0042001000110012001255001100A3045Q00113Q00114Q001200013Q00122Q001300A0045Q00133Q00134Q0012000100012Q00420010001100120012550011009D045Q00113Q00114Q001200013Q00122Q0013009A045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0097045Q000F3Q000F00122Q00102Q00055Q000E000F00104Q000C000D000E00122Q000D0094045Q000D3Q000D4Q000E3Q000200122Q000F0091043Q0079000F3Q000F4Q00103Q000100122Q0011008E045Q00113Q00114Q001200013Q00122Q0013008B045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0088045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0085045Q000D3Q000D4Q000E3Q000200122Q000F0082043Q0079000F3Q000F4Q00103Q000200122Q0011007F045Q00113Q00114Q001200013Q00122Q0013007C045Q00133Q00134Q0012000100012Q004200100011001200125500110079045Q00113Q00114Q001200013Q00122Q00130076045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0073045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0070045Q000D3Q000D4Q000E3Q000200122Q000F006D043Q0079000F3Q000F4Q00103Q000100122Q0011006A045Q00113Q00114Q001200013Q00122Q00130067045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0064045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0061045Q000D3Q000D4Q000E3Q000200122Q000F005E043Q0079000F3Q000F4Q00103Q000100122Q0011005B045Q00113Q00114Q001200013Q00122Q00130058045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0055045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0052045Q000D3Q000D4Q000E3Q000200122Q000F004F043Q0079000F3Q000F4Q00103Q000100122Q0011004C045Q00113Q00114Q001200013Q00122Q00130049045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0046045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0043045Q000D3Q000D4Q000E3Q000200122Q000F0040043Q0079000F3Q000F4Q00103Q000400122Q0011003D045Q00113Q00114Q001200013Q00122Q0013003A045Q00133Q00134Q0012000100012Q004200100011001200125500110037045Q00113Q00114Q001200013Q00122Q00130034045Q00133Q00134Q0012000100012Q004200100011001200125500110031045Q00113Q00114Q001200013Q00122Q0013002E045Q00133Q00134Q0012000100012Q00420010001100120012550011002B045Q00113Q00114Q001200013Q00122Q00130028045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0025045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0022045Q000D3Q000D4Q000E3Q000200122Q000F001F043Q0079000F3Q000F4Q00103Q000100122Q0011001C045Q00113Q00114Q001200013Q00122Q00130019045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0016045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0013045Q000D3Q000D4Q000E3Q000200122Q000F0010043Q0079000F3Q000F4Q00103Q000200122Q0011000D045Q00113Q00114Q001200013Q00122Q0013000A045Q00133Q00134Q0012000100012Q004200100011001200125500110007045Q00113Q00114Q001200013Q00122Q0013002Q045Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0001045Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00FE035Q000D3Q000D4Q000E3Q000200122Q000F00FB033Q0079000F3Q000F4Q00103Q000100122Q001100F8035Q00113Q00114Q001200013Q00122Q001300F5035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00F2035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00EF035Q000D3Q000D4Q000E3Q000200122Q000F00EC033Q0079000F3Q000F4Q00103Q000200122Q001100E9035Q00113Q00114Q001200013Q00122Q001300E6035Q00133Q00134Q0012000100012Q0042001000110012001255001100E3035Q00113Q00114Q001200013Q00122Q001300E0035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00DD035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00DA035Q000D3Q000D4Q000E3Q000200122Q000F00D7033Q0079000F3Q000F4Q00103Q000200122Q001100D4035Q00113Q00114Q001200013Q00122Q001300D1035Q00133Q00134Q0012000100012Q0042001000110012001255001100CE035Q00113Q00114Q001200013Q00122Q001300CB035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00C8035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00C5035Q000D3Q000D4Q000E3Q000200122Q000F00C2033Q0079000F3Q000F4Q00103Q000100122Q001100BF035Q00113Q00114Q001200013Q00122Q001300BC035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00B9035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00B6035Q000D3Q000D4Q000E3Q000200122Q000F00B3033Q0079000F3Q000F4Q00103Q000200122Q001100B0035Q00113Q00114Q001200013Q00122Q001300AD035Q00133Q00134Q0012000100012Q0042001000110012001255001100AA035Q00113Q00114Q001200013Q00122Q001300A7035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00A4035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00A1035Q000D3Q000D4Q000E3Q000200122Q000F009E033Q0079000F3Q000F4Q00103Q000100122Q0011009B035Q00113Q00114Q001200013Q00122Q00130098035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0095035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0092035Q000D3Q000D4Q000E3Q000200122Q000F008F033Q0079000F3Q000F4Q00103Q000100122Q0011008C035Q00113Q00114Q001200013Q00122Q00130089035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0086035Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D0083035Q000D3Q000D4Q000E3Q000200122Q000F0080033Q0079000F3Q000F4Q00103Q000100122Q0011007D035Q00113Q00114Q001200013Q00122Q0013007A035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0077035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0074035Q000D3Q000D4Q000E3Q000200122Q000F0071033Q0079000F3Q000F4Q00103Q000100122Q0011006E035Q00113Q00114Q001200013Q00122Q0013006B035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0068035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0065035Q000D3Q000D4Q000E3Q000200122Q000F0062033Q0079000F3Q000F4Q00103Q000100122Q0011005F035Q00113Q00114Q001200013Q00122Q0013005C035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0059035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0056035Q000D3Q000D4Q000E3Q000200122Q000F0053033Q0079000F3Q000F4Q00103Q000100122Q00110050035Q00113Q00114Q001200013Q00122Q0013004D035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F004A035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0047035Q000D3Q000D4Q000E3Q000200122Q000F0044033Q0079000F3Q000F4Q00103Q000100122Q00110041035Q00113Q00114Q001200013Q00122Q0013003E035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F003B035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0038035Q000D3Q000D4Q000E3Q000200122Q000F0035033Q0079000F3Q000F4Q00103Q000100122Q00110032035Q00113Q00114Q001200013Q00122Q0013002F035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F002C035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0029035Q000D3Q000D4Q000E3Q000200122Q000F0026033Q0079000F3Q000F4Q00103Q000300122Q00110023035Q00113Q00114Q001200013Q00122Q00130020035Q00133Q00134Q0012000100012Q00420010001100120012550011001D035Q00113Q00114Q001200013Q00122Q0013001A035Q00133Q00134Q0012000100012Q004200100011001200125500110017035Q00113Q00114Q001200013Q00122Q00130014035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0011035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D000E035Q000D3Q000D4Q000E3Q000200122Q000F000B033Q0079000F3Q000F4Q00103Q000100122Q00110008035Q00113Q00114Q001200013Q00122Q00130005035Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0002035Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00FF025Q000D3Q000D4Q000E3Q000200122Q000F00FC023Q0079000F3Q000F4Q00103Q000200122Q001100F9025Q00113Q00114Q001200013Q00122Q001300F6025Q00133Q00134Q0012000100012Q0042001000110012001255001100F3025Q00113Q00114Q001200013Q00122Q001300F0025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00ED025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00EA025Q000D3Q000D4Q000E3Q000200122Q000F00E7023Q0079000F3Q000F4Q00103Q000100122Q001100E4025Q00113Q00114Q001200013Q00122Q001300E1025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00DE025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00DB025Q000D3Q000D4Q000E3Q000200122Q000F00D8023Q0079000F3Q000F4Q00103Q000100122Q001100D5025Q00113Q00114Q001200013Q00122Q001300D2025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00CF025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00CC025Q000D3Q000D4Q000E3Q000200122Q000F00C9023Q0079000F3Q000F4Q00103Q000100122Q001100C6025Q00113Q00114Q001200013Q00122Q001300C3025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00C0025Q000F3Q000F00122Q00100001055Q000E000F00104Q000C000D000E00122Q000D00BD025Q000D3Q000D4Q000E3Q000200122Q000F00BA023Q0079000F3Q000F4Q00103Q000100122Q001100B7025Q00113Q00114Q001200013Q00122Q001300B4025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00B1025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00AE025Q000D3Q000D4Q000E3Q000200122Q000F00AB023Q0079000F3Q000F4Q00103Q000100122Q001100A8025Q00113Q00114Q001200013Q00122Q001300A5025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00A2025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D009F025Q000D3Q000D4Q000E3Q000200122Q000F009C023Q0079000F3Q000F4Q00103Q000100122Q00110099025Q00113Q00114Q001200013Q00122Q00130096025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0093025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0090025Q000D3Q000D4Q000E3Q000200122Q000F008D023Q0079000F3Q000F4Q00103Q000200122Q0011008A025Q00113Q00114Q001200013Q00122Q00130087025Q00133Q00134Q0012000100012Q004200100011001200125500110084025Q00113Q00114Q001200013Q00122Q00130081025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F007E025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D007B025Q000D3Q000D4Q000E3Q000200122Q000F0078023Q0079000F3Q000F4Q00103Q000100122Q00110075025Q00113Q00114Q001200013Q00122Q00130072025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F006F025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D006C025Q000D3Q000D4Q000E3Q000200122Q000F0069023Q0079000F3Q000F4Q00103Q000100122Q00110066025Q00113Q00114Q001200013Q00122Q00130063025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0060025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D005D025Q000D3Q000D4Q000E3Q000200122Q000F005A023Q0079000F3Q000F4Q00103Q000100122Q00110057025Q00113Q00114Q001200013Q00122Q00130054025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0051025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D004E025Q000D3Q000D4Q000E3Q000200122Q000F004B023Q0079000F3Q000F4Q00103Q000100122Q00110048025Q00113Q00114Q001200013Q00122Q00130045025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0042025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D003F025Q000D3Q000D4Q000E3Q000200122Q000F003C023Q0079000F3Q000F4Q00103Q000100122Q00110039025Q00113Q00114Q001200013Q00122Q00130036025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0033025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0030025Q000D3Q000D4Q000E3Q000200122Q000F002D023Q0079000F3Q000F4Q00103Q000300122Q0011002A025Q00113Q00114Q001200013Q00122Q00130027025Q00133Q00134Q0012000100012Q004200100011001200125500110024025Q00113Q00114Q001200013Q00122Q00130021025Q00133Q00134Q0012000100012Q00420010001100120012550011001E025Q00113Q00114Q001200013Q00122Q0013001B025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0018025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0015025Q000D3Q000D4Q000E3Q000200122Q000F0012023Q0079000F3Q000F4Q00103Q000200122Q0011000F025Q00113Q00114Q001200013Q00122Q0013000C025Q00133Q00134Q0012000100012Q004200100011001200125500110009025Q00113Q00114Q001200013Q00122Q00130006025Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0003025Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D2Q00025Q000D3Q000D4Q000E3Q000200122Q000F00FD013Q0079000F3Q000F4Q00103Q000100122Q001100FA015Q00113Q00114Q001200013Q00122Q001300F7015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00F4015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00F1015Q000D3Q000D4Q000E3Q000200122Q000F00EE013Q0079000F3Q000F4Q00103Q000200122Q001100EB015Q00113Q00114Q001200013Q00122Q001300E8015Q00133Q00134Q0012000100012Q0042001000110012001255001100E5015Q00113Q00114Q001200013Q00122Q001300E2015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00DF015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00DC015Q000D3Q000D4Q000E3Q000200122Q000F00D9013Q0079000F3Q000F4Q00103Q000200122Q001100D6015Q00113Q00114Q001200013Q00122Q001300D3015Q00133Q00134Q0012000100012Q0042001000110012001255001100D0015Q00113Q00114Q001200013Q00122Q001300CD015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00CA015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00C7015Q000D3Q000D4Q000E3Q000200122Q000F00C4013Q0079000F3Q000F4Q00103Q000100122Q001100C1015Q00113Q00114Q001200013Q00122Q001300BE015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00BB015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00B8015Q000D3Q000D4Q000E3Q000200122Q000F00B5013Q0079000F3Q000F4Q00103Q000200122Q001100B2015Q00113Q00114Q001200013Q00122Q001300AF015Q00133Q00134Q0012000100012Q0042001000110012001255001100AC015Q00113Q00114Q001200013Q00122Q001300A9015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00A6015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00A3015Q000D3Q000D4Q000E3Q000200122Q000F00A0013Q0079000F3Q000F4Q00103Q000100122Q0011009D015Q00113Q00114Q001200013Q00122Q0013009A015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0097015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0094015Q000D3Q000D4Q000E3Q000200122Q000F0091013Q0079000F3Q000F4Q00103Q000100122Q0011008E015Q00113Q00114Q001200013Q00122Q0013008B015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0088015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0085015Q000D3Q000D4Q000E3Q000200122Q000F0082013Q0079000F3Q000F4Q00103Q000100122Q0011007F015Q00113Q00114Q001200013Q00122Q0013007C015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0079015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0076015Q000D3Q000D4Q000E3Q000200122Q000F0073013Q0079000F3Q000F4Q00103Q000100122Q00110070015Q00113Q00114Q001200013Q00122Q0013006D015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F006A015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0067015Q000D3Q000D4Q000E3Q000200122Q000F0064013Q0079000F3Q000F4Q00103Q000100122Q00110061015Q00113Q00114Q001200013Q00122Q0013005E015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F005B015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0058015Q000D3Q000D4Q000E3Q000200122Q000F0055013Q0079000F3Q000F4Q00103Q000100122Q00110052015Q00113Q00114Q001200013Q00122Q0013004F015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F004C015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0049015Q000D3Q000D4Q000E3Q000200122Q000F0046013Q0079000F3Q000F4Q00103Q000200122Q00110043015Q00113Q00114Q001200013Q00122Q00130040015Q00133Q00134Q0012000100012Q00420010001100120012550011003D015Q00113Q00114Q001200013Q00122Q0013003A015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0037015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0034015Q000D3Q000D4Q000E3Q000200122Q000F0031013Q0079000F3Q000F4Q00103Q000100122Q0011002E015Q00113Q00114Q001200013Q00122Q0013002B015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0028015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0025015Q000D3Q000D4Q000E3Q000200122Q000F0022013Q0079000F3Q000F4Q00103Q000100122Q0011001F015Q00113Q00114Q001200013Q00122Q0013001C015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F0019015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0016015Q000D3Q000D4Q000E3Q000200122Q000F0013013Q0079000F3Q000F4Q00103Q000100122Q00110010015Q00113Q00114Q001200013Q00122Q0013000D015Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F000A015Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D0007015Q000D3Q000D4Q000E3Q000200122Q000F0004013Q0079000F3Q000F4Q00103Q000100122Q0011002Q015Q00113Q00114Q001200013Q00122Q001300FE6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00FB6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00F86Q000D3Q000D4Q000E3Q000200122Q000F00F54Q0079000F3Q000F4Q00103Q000100122Q001100F26Q00113Q00114Q001200013Q00122Q001300EF6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00EC6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00E96Q000D3Q000D4Q000E3Q000200122Q000F00E64Q0079000F3Q000F4Q00103Q000100122Q001100E36Q00113Q00114Q001200013Q00122Q001300E06Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00DD6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00DA6Q000D3Q000D4Q000E3Q000200122Q000F00D74Q0079000F3Q000F4Q00103Q000100122Q001100D46Q00113Q00114Q001200013Q00122Q001300D16Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00CE6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00CB6Q000D3Q000D4Q000E3Q000200122Q000F00C84Q0079000F3Q000F4Q00103Q000100122Q001100C56Q00113Q00114Q001200013Q00122Q001300C26Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00BF6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00BC6Q000D3Q000D4Q000E3Q000200122Q000F00B94Q0079000F3Q000F4Q00103Q000100122Q001100B66Q00113Q00114Q001200013Q00122Q001300B36Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00B06Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00AD6Q000D3Q000D4Q000E3Q000200122Q000F00AA4Q0079000F3Q000F4Q00103Q000200122Q001100A76Q00113Q00114Q001200013Q00122Q001300A46Q00133Q00134Q0012000100012Q0042001000110012001255001100A16Q00113Q00114Q001200013Q00122Q0013009E6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F009B6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00986Q000D3Q000D4Q000E3Q000200122Q000F00954Q0079000F3Q000F4Q00103Q000100122Q001100926Q00113Q00114Q001200013Q00122Q0013008F6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F008C6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00896Q000D3Q000D4Q000E3Q000200122Q000F00864Q0079000F3Q000F4Q00103Q000400122Q001100836Q00113Q00114Q001200013Q00122Q001300806Q00133Q00134Q0012000100012Q00420010001100120012550011007D6Q00113Q00114Q001200013Q00122Q0013007A6Q00133Q00134Q0012000100012Q0042001000110012001255001100776Q00113Q00114Q001200013Q00122Q001300746Q00133Q00134Q0012000100012Q0042001000110012001255001100716Q00113Q00114Q001200013Q00122Q0013006E6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F006B6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00686Q000D3Q000D4Q000E3Q000200122Q000F00654Q0079000F3Q000F4Q00103Q000100122Q001100626Q00113Q00114Q001200013Q00122Q0013005F6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F005C6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00596Q000D3Q000D4Q000E3Q000200122Q000F00564Q0079000F3Q000F4Q00103Q000100122Q001100536Q00113Q00114Q001200013Q00122Q001300506Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F004D6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D004A6Q000D3Q000D4Q000E3Q000200122Q000F00474Q0079000F3Q000F4Q00103Q000100122Q001100446Q00113Q00114Q001200013Q00122Q001300416Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F003E6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D003B6Q000D3Q000D4Q000E3Q000200122Q000F00384Q0079000F3Q000F4Q00103Q000200122Q001100356Q00113Q00114Q001200013Q00122Q001300326Q00133Q00134Q0012000100012Q00420010001100120012550011002F6Q00113Q00114Q001200013Q00122Q0013002C6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F00296Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00266Q000D3Q000D4Q000E3Q000200122Q000F00234Q0079000F3Q000F4Q00103Q000100122Q001100206Q00113Q00114Q001200013Q00122Q0013001D6Q00133Q00134Q0012000100012Q00420010001100122Q0058000E000F001000122Q000F001A6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E00122Q000D00176Q000D3Q000D4Q000E3Q000200122Q000F00144Q0079000F3Q000F4Q00103Q000100122Q001100116Q00113Q00114Q001200013Q00122Q0013000E6Q00133Q00134Q0012000100012Q00420010001100122Q003E000E000F001000122Q000F000B6Q000F3Q000F00122Q00100002055Q000E000F00104Q000C000D000E4Q000A000C6Q000A00023Q00044Q00B509010004AC3Q00B109012Q00183Q00013Q00013Q00023Q00026Q00F03F026Q00704002264Q006300025Q00122Q000300016Q00045Q00122Q000500013Q00042Q0003002100012Q002600076Q0083000800026Q000900016Q000A00026Q000B00036Q000C00046Q000D8Q000E00063Q00202Q000F000600014Q000C000F6Q000B3Q00024Q000C00036Q000D00046Q000E00016Q000F00016Q000F0006000F00102Q000F0001000F4Q001000016Q00100006001000102Q00100001001000202Q0010001000014Q000D00106Q000C8Q000A3Q000200202Q000A000A00024Q0009000A6Q00073Q00010004BC0003000500012Q0026000300054Q00B4000400024Q00AA000300044Q00CA00036Q00183Q00017Q00", v9(), ...);
