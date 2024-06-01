module StringEncoder (
	clock,
	reset,
	io_config_in_valid,
	io_config_in_bits,
	io_start,
	io_done,
	io_bit_out_valid,
	io_bit_out_bits
);
	input clock;
	input reset;
	input io_config_in_valid;
	input [7:0] io_config_in_bits;
	input io_start;
	output wire io_done;
	output wire io_bit_out_valid;
	output wire io_bit_out_bits;
	reg [3:0] state;
	reg [4:0] pc;
	reg [3:0] instr_op;
	reg [7:0] instr_value;
	reg [27:0] accum;
	reg [27:0] mul_reg;
	reg [27:0] reg_n;
	reg [5:0] power_dbm;
	reg [31:0] conv_reg;
	wire _GEN = state == 4'h0;
	wire _GEN_0 = state == 4'h1;
	wire _GEN_1 = state == 4'h2;
	wire _GEN_2 = instr_op == 4'h0;
	wire _GEN_3 = instr_op == 4'h1;
	wire _GEN_4 = instr_op == 4'h2;
	wire _GEN_5 = instr_op == 4'h3;
	wire _GEN_6 = instr_op == 4'h4;
	wire _GEN_7 = instr_op == 4'h5;
	wire _GEN_8 = instr_op == 4'h6;
	wire _GEN_9 = _GEN_5 | _GEN_6;
	wire _GEN_10 = _GEN | _GEN_0;
	reg io_bit_out_REG_valid;
	reg io_bit_out_REG_bits;
	reg bit_out_tmp_valid_REG;
	reg bit_out_tmp_valid_REG_1;
	reg bit_out_tmp_valid_REG_2;
	reg REG;
	reg REG_1;
	always @(posedge clock) begin : sv2v_autoblock_1
		reg [255:0] _GEN_11;
		reg _GEN_12;
		reg _GEN_13;
		reg _GEN_14;
		reg _GEN_15;
		reg _GEN_16;
		reg _GEN_17;
		reg _GEN_18;
		reg _GEN_19;
		reg _GEN_20;
		reg _GEN_21;
		reg bit_tmp_valid;
		reg [127:0] _GEN_22;
		_GEN_11 = 256'h00000000000000030a0112b3020a0000000a051b0a041b0a031b020a01240000;
		_GEN_12 = _GEN_2 | _GEN_3;
		_GEN_13 = instr_op == 4'h7;
		_GEN_14 = state == 4'h3;
		_GEN_15 = state == 4'h4;
		_GEN_16 = state == 4'h5;
		_GEN_17 = _GEN_14 | _GEN_15;
		_GEN_18 = state == 4'h6;
		_GEN_19 = state == 4'h7;
		_GEN_20 = state == 4'h8;
		_GEN_21 = ((_GEN | _GEN_0) | _GEN_1) | _GEN_17;
		bit_tmp_valid = ~_GEN_21 & (_GEN_16 | _GEN_18 ? ~instr_value[0] : (_GEN_19 ? ~(|instr_value) : (_GEN_20 ? ~instr_value[0] : (state == 4'h9) & (~(|instr_value) | ~instr_value[0]))));
		if (reset)
			state <= 4'h0;
		else begin : sv2v_autoblock_2
			reg [63:0] _GEN_23;
			_GEN_23 = {state, state, state, state, 4'h0, (|instr_value ? state : 4'hb), (|instr_value ? state : 4'ha), (|instr_value ? state : 4'h9), (|instr_value ? state : 4'h8), (|instr_value ? state : 4'h7), (|instr_value ? state : 4'h6), 5'h0a, (io_config_in_valid ? 3'h4 : 3'h3), (_GEN_2 ? 4'h1 : (_GEN_3 ? {2'h0, (io_config_in_valid ? 2'h1 : 2'h2)} : (_GEN_4 ? {2'h0, (|instr_value ? 2'h2 : 2'h1)} : (_GEN_9 ? 4'h1 : (_GEN_7 ? {2'h0, (io_config_in_valid ? 2'h1 : 2'h2)} : (_GEN_8 ? {2'h0, (io_config_in_valid ? 2'h1 : 2'h2)} : (_GEN_13 ? 4'h1 : {2'h0, instr_op == 4'h8, 1'h1}))))))), 4'h2, (io_start ? 4'h1 : state)};
			state <= _GEN_23[state * 4+:4];
		end
		if (_GEN) begin
			if (io_start)
				pc <= 5'h00;
		end
		else if (_GEN_0) begin
			pc <= pc + 5'h01;
			mul_reg <= 28'h0000000;
		end
		else if ((~_GEN_1 | _GEN_12) | ~_GEN_4)
			;
		else
			mul_reg <= mul_reg + accum;
		if (_GEN | ~_GEN_0)
			;
		else begin : sv2v_autoblock_3
			reg [127:0] _GEN_24;
			_GEN_24 = 128'h00000086252462507312312312121210;
			instr_op <= _GEN_24[pc * 4+:4];
		end
		_GEN_22 = {instr_value, instr_value, instr_value, instr_value, instr_value, instr_value - 8'h01, (|instr_value ? instr_value - 8'h01 : 8'h80), (|instr_value ? instr_value - 8'h01 : 8'h3d), (|instr_value ? instr_value - 8'h01 : 8'h0b), (|instr_value ? instr_value - 8'h01 : 8'h01), (|instr_value ? instr_value - 8'h01 : 8'h1d), 8'h37, instr_value, (_GEN_12 | ~_GEN_4 ? instr_value : instr_value - 8'h01), _GEN_11[pc * 8+:8], instr_value};
		instr_value <= _GEN_22[state * 8+:8];
		if (~_GEN_10) begin
			if (_GEN_1) begin
				if (_GEN_2)
					accum <= 28'h0000000;
				else begin : sv2v_autoblock_4
					reg [27:0] _dec_res_T;
					_dec_res_T = accum + {21'h000000, ((_GEN_10 | ~_GEN_1) | _GEN_2 ? 7'h00 : (_GEN_3 ? (io_config_in_valid ? (io_config_in_bits == 8'h20 ? 7'h24 : (io_config_in_bits < 8'h3a ? io_config_in_bits[6:0] - 7'h30 : io_config_in_bits[6:0] - 7'h37)) : 7'h00) : (_GEN_4 | _GEN_9 ? 7'h00 : (_GEN_7 ? (io_config_in_valid ? io_config_in_bits[6:0] + 7'h3f : 7'h00) : (_GEN_8 & io_config_in_valid ? io_config_in_bits[6:0] - 7'h30 : 7'h00)))))};
					if (_GEN_3) begin
						if (io_config_in_valid)
							accum <= _dec_res_T;
					end
					else if (_GEN_4) begin
						if (~(|instr_value))
							accum <= mul_reg;
					end
					else if (_GEN_9) begin : sv2v_autoblock_5
						reg _sub_res_T_2;
						reg [27:0] _GEN_25;
						_sub_res_T_2 = instr_op == 4'h4;
						_GEN_25 = {20'h00000, instr_value};
						accum <= (_sub_res_T_2 ? _GEN_25 : accum) - (_sub_res_T_2 ? accum : _GEN_25);
					end
					else if ((_GEN_7 | _GEN_8) & io_config_in_valid)
						accum <= _dec_res_T;
				end
				if (((((((_GEN_2 | _GEN_3) | _GEN_4) | _GEN_5) | _GEN_6) | _GEN_7) | _GEN_8) | ~_GEN_13)
					;
				else
					reg_n <= accum;
			end
			else begin
				if (((_GEN_14 | _GEN_15) | _GEN_16) | ~(_GEN_18 & ~instr_value[0]))
					;
				else
					accum <= {accum[26:0], 1'h0};
				if (_GEN_17 | ~(_GEN_16 & ~instr_value[0]))
					;
				else
					reg_n <= {reg_n[26:0], 1'h0};
			end
		end
		if (~((_GEN | _GEN_0) | _GEN_1)) begin
			if (_GEN_14) begin
				if (io_config_in_valid)
					power_dbm <= io_config_in_bits[5:0];
			end
			else if ((((_GEN_15 | _GEN_16) | _GEN_18) | _GEN_19) | ~(_GEN_20 & ~instr_value[0]))
				;
			else
				power_dbm <= {power_dbm[4:0], 1'h0};
		end
		if (bit_tmp_valid)
			conv_reg <= {conv_reg[30:0], ~_GEN_21 & (_GEN_16 ? reg_n[27] : (_GEN_18 ? accum[14] : _GEN_19 | (_GEN_20 & power_dbm[5])))};
		else if (_GEN & io_start)
			conv_reg <= 32'h00000000;
		io_bit_out_REG_valid <= bit_out_tmp_valid_REG | bit_out_tmp_valid_REG_2;
		io_bit_out_REG_bits <= (REG_1 ? ^(conv_reg & 32'he4613c47) : ^(conv_reg & 32'hf2d05351));
		bit_out_tmp_valid_REG <= bit_tmp_valid;
		bit_out_tmp_valid_REG_1 <= bit_tmp_valid;
		bit_out_tmp_valid_REG_2 <= bit_out_tmp_valid_REG_1;
		REG <= bit_tmp_valid;
		REG_1 <= REG;
	end
	assign io_done = state == 4'hb;
	assign io_bit_out_valid = io_bit_out_REG_valid;
	assign io_bit_out_bits = io_bit_out_REG_bits;
endmodule
module BitGenerator (
	clock,
	reset,
	io_config_in_valid,
	io_config_in_bits,
	io_start,
	io_bit_out_ready,
	io_bit_out_bits
);
	input clock;
	input reset;
	input io_config_in_valid;
	input [7:0] io_config_in_bits;
	input io_start;
	input io_bit_out_ready;
	output wire [1:0] io_bit_out_bits;
	wire _se_io_done;
	wire _se_io_bit_out_valid;
	wire _se_io_bit_out_bits;
	wire [255:0] _GEN = 256'hfffffffffffffffffffffffc63580ca0e2cdc9045634955858b340a407a47103;
	reg regs_0;
	reg regs_1;
	reg regs_2;
	reg regs_3;
	reg regs_4;
	reg regs_5;
	reg regs_6;
	reg regs_7;
	reg regs_8;
	reg regs_9;
	reg regs_10;
	reg regs_11;
	reg regs_12;
	reg regs_13;
	reg regs_14;
	reg regs_15;
	reg regs_16;
	reg regs_17;
	reg regs_18;
	reg regs_19;
	reg regs_20;
	reg regs_21;
	reg regs_22;
	reg regs_23;
	reg regs_24;
	reg regs_25;
	reg regs_26;
	reg regs_27;
	reg regs_28;
	reg regs_29;
	reg regs_30;
	reg regs_31;
	reg regs_32;
	reg regs_33;
	reg regs_34;
	reg regs_35;
	reg regs_36;
	reg regs_37;
	reg regs_38;
	reg regs_39;
	reg regs_40;
	reg regs_41;
	reg regs_42;
	reg regs_43;
	reg regs_44;
	reg regs_45;
	reg regs_46;
	reg regs_47;
	reg regs_48;
	reg regs_49;
	reg regs_50;
	reg regs_51;
	reg regs_52;
	reg regs_53;
	reg regs_54;
	reg regs_55;
	reg regs_56;
	reg regs_57;
	reg regs_58;
	reg regs_59;
	reg regs_60;
	reg regs_61;
	reg regs_62;
	reg regs_63;
	reg regs_64;
	reg regs_65;
	reg regs_66;
	reg regs_67;
	reg regs_68;
	reg regs_69;
	reg regs_70;
	reg regs_71;
	reg regs_72;
	reg regs_73;
	reg regs_74;
	reg regs_75;
	reg regs_76;
	reg regs_77;
	reg regs_78;
	reg regs_79;
	reg regs_80;
	reg regs_81;
	reg regs_82;
	reg regs_83;
	reg regs_84;
	reg regs_85;
	reg regs_86;
	reg regs_87;
	reg regs_88;
	reg regs_89;
	reg regs_90;
	reg regs_91;
	reg regs_92;
	reg regs_93;
	reg regs_94;
	reg regs_95;
	reg regs_96;
	reg regs_97;
	reg regs_98;
	reg regs_99;
	reg regs_100;
	reg regs_101;
	reg regs_102;
	reg regs_103;
	reg regs_104;
	reg regs_105;
	reg regs_106;
	reg regs_107;
	reg regs_108;
	reg regs_109;
	reg regs_110;
	reg regs_111;
	reg regs_112;
	reg regs_113;
	reg regs_114;
	reg regs_115;
	reg regs_116;
	reg regs_117;
	reg regs_118;
	reg regs_119;
	reg regs_120;
	reg regs_121;
	reg regs_122;
	reg regs_123;
	reg regs_124;
	reg regs_125;
	reg regs_126;
	reg regs_127;
	reg regs_128;
	reg regs_129;
	reg regs_130;
	reg regs_131;
	reg regs_132;
	reg regs_133;
	reg regs_134;
	reg regs_135;
	reg regs_136;
	reg regs_137;
	reg regs_138;
	reg regs_139;
	reg regs_140;
	reg regs_141;
	reg regs_142;
	reg regs_143;
	reg regs_144;
	reg regs_145;
	reg regs_146;
	reg regs_147;
	reg regs_148;
	reg regs_149;
	reg regs_150;
	reg regs_151;
	reg regs_152;
	reg regs_153;
	reg regs_154;
	reg regs_155;
	reg regs_156;
	reg regs_157;
	reg regs_158;
	reg regs_159;
	reg regs_160;
	reg regs_161;
	reg [7:0] ctr;
	always @(posedge clock)
		if (io_bit_out_ready) begin
			regs_0 <= regs_81;
			regs_1 <= regs_82;
			regs_2 <= regs_83;
			regs_3 <= regs_84;
			regs_4 <= regs_85;
			regs_5 <= regs_86;
			regs_6 <= regs_87;
			regs_7 <= regs_88;
			regs_8 <= regs_89;
			regs_9 <= regs_90;
			regs_10 <= regs_91;
			regs_11 <= regs_92;
			regs_12 <= regs_93;
			regs_13 <= regs_94;
			regs_14 <= regs_95;
			regs_15 <= regs_96;
			regs_16 <= regs_97;
			regs_17 <= regs_98;
			regs_18 <= regs_99;
			regs_19 <= regs_100;
			regs_20 <= regs_101;
			regs_21 <= regs_102;
			regs_22 <= regs_103;
			regs_23 <= regs_104;
			regs_24 <= regs_105;
			regs_25 <= regs_106;
			regs_26 <= regs_107;
			regs_27 <= regs_108;
			regs_28 <= regs_109;
			regs_29 <= regs_110;
			regs_30 <= regs_111;
			regs_31 <= regs_112;
			regs_32 <= regs_113;
			regs_33 <= regs_114;
			regs_34 <= regs_115;
			regs_35 <= regs_116;
			regs_36 <= regs_117;
			regs_37 <= regs_118;
			regs_38 <= regs_119;
			regs_39 <= regs_120;
			regs_40 <= regs_121;
			regs_41 <= regs_122;
			regs_42 <= regs_123;
			regs_43 <= regs_124;
			regs_44 <= regs_125;
			regs_45 <= regs_126;
			regs_46 <= regs_127;
			regs_47 <= regs_128;
			regs_48 <= regs_129;
			regs_49 <= regs_130;
			regs_50 <= regs_131;
			regs_51 <= regs_132;
			regs_52 <= regs_133;
			regs_53 <= regs_134;
			regs_54 <= regs_135;
			regs_55 <= regs_136;
			regs_56 <= regs_137;
			regs_57 <= regs_138;
			regs_58 <= regs_139;
			regs_59 <= regs_140;
			regs_60 <= regs_141;
			regs_61 <= regs_142;
			regs_62 <= regs_143;
			regs_63 <= regs_144;
			regs_64 <= regs_145;
			regs_65 <= regs_146;
			regs_66 <= regs_147;
			regs_67 <= regs_148;
			regs_68 <= regs_149;
			regs_69 <= regs_150;
			regs_70 <= regs_151;
			regs_71 <= regs_152;
			regs_72 <= regs_153;
			regs_73 <= regs_154;
			regs_74 <= regs_155;
			regs_75 <= regs_156;
			regs_76 <= regs_157;
			regs_77 <= regs_158;
			regs_78 <= regs_159;
			regs_79 <= regs_160;
			regs_80 <= regs_161;
			regs_81 <= regs_41;
			regs_82 <= regs_42;
			regs_83 <= regs_43;
			regs_84 <= regs_44;
			regs_85 <= regs_0;
			regs_86 <= regs_45;
			regs_87 <= regs_46;
			regs_88 <= regs_47;
			regs_89 <= regs_48;
			regs_90 <= regs_49;
			regs_91 <= regs_50;
			regs_92 <= regs_51;
			regs_93 <= regs_52;
			regs_94 <= regs_53;
			regs_95 <= regs_54;
			regs_96 <= regs_55;
			regs_97 <= regs_56;
			regs_98 <= regs_57;
			regs_99 <= regs_58;
			regs_100 <= regs_59;
			regs_101 <= regs_60;
			regs_102 <= regs_61;
			regs_103 <= regs_62;
			regs_104 <= regs_63;
			regs_105 <= regs_64;
			regs_106 <= regs_65;
			regs_107 <= regs_66;
			regs_108 <= regs_67;
			regs_109 <= regs_68;
			regs_110 <= regs_69;
			regs_111 <= regs_70;
			regs_112 <= regs_71;
			regs_113 <= regs_72;
			regs_114 <= regs_73;
			regs_115 <= regs_74;
			regs_116 <= regs_75;
			regs_117 <= regs_76;
			regs_118 <= regs_77;
			regs_119 <= regs_78;
			regs_120 <= regs_79;
			regs_121 <= regs_80;
			regs_122 <= regs_21;
			regs_123 <= regs_22;
			regs_124 <= regs_23;
			regs_125 <= regs_24;
			regs_126 <= regs_25;
			regs_127 <= regs_26;
			regs_128 <= regs_27;
			regs_129 <= regs_28;
			regs_130 <= regs_29;
			regs_131 <= regs_30;
			regs_132 <= regs_31;
			regs_133 <= regs_32;
			regs_134 <= regs_33;
			regs_135 <= regs_34;
			regs_136 <= regs_35;
			regs_137 <= regs_36;
			regs_138 <= regs_37;
			regs_139 <= regs_38;
			regs_140 <= regs_39;
			regs_141 <= regs_40;
			regs_142 <= regs_11;
			regs_143 <= regs_12;
			regs_144 <= regs_13;
			regs_145 <= regs_14;
			regs_146 <= regs_15;
			regs_147 <= regs_16;
			regs_148 <= regs_17;
			regs_149 <= regs_18;
			regs_150 <= regs_19;
			regs_151 <= regs_20;
			regs_152 <= regs_6;
			regs_153 <= regs_7;
			regs_154 <= regs_8;
			regs_155 <= regs_9;
			regs_156 <= regs_10;
			regs_157 <= regs_3;
			regs_158 <= regs_4;
			regs_159 <= regs_5;
			regs_160 <= regs_2;
			regs_161 <= regs_1;
			ctr <= ctr + 8'h01;
		end
		else begin
			if (_se_io_bit_out_valid) begin
				regs_0 <= regs_1;
				regs_1 <= regs_2;
				regs_2 <= regs_3;
				regs_3 <= regs_4;
				regs_4 <= regs_5;
				regs_5 <= regs_6;
				regs_6 <= regs_7;
				regs_7 <= regs_8;
				regs_8 <= regs_9;
				regs_9 <= regs_10;
				regs_10 <= regs_11;
				regs_11 <= regs_12;
				regs_12 <= regs_13;
				regs_13 <= regs_14;
				regs_14 <= regs_15;
				regs_15 <= regs_16;
				regs_16 <= regs_17;
				regs_17 <= regs_18;
				regs_18 <= regs_19;
				regs_19 <= regs_20;
				regs_20 <= regs_21;
				regs_21 <= regs_22;
				regs_22 <= regs_23;
				regs_23 <= regs_24;
				regs_24 <= regs_25;
				regs_25 <= regs_26;
				regs_26 <= regs_27;
				regs_27 <= regs_28;
				regs_28 <= regs_29;
				regs_29 <= regs_30;
				regs_30 <= regs_31;
				regs_31 <= regs_32;
				regs_32 <= regs_33;
				regs_33 <= regs_34;
				regs_34 <= regs_35;
				regs_35 <= regs_36;
				regs_36 <= regs_37;
				regs_37 <= regs_38;
				regs_38 <= regs_39;
				regs_39 <= regs_40;
				regs_40 <= regs_41;
				regs_41 <= regs_42;
				regs_42 <= regs_43;
				regs_43 <= regs_44;
				regs_44 <= regs_45;
				regs_45 <= regs_46;
				regs_46 <= regs_47;
				regs_47 <= regs_48;
				regs_48 <= regs_49;
				regs_49 <= regs_50;
				regs_50 <= regs_51;
				regs_51 <= regs_52;
				regs_52 <= regs_53;
				regs_53 <= regs_54;
				regs_54 <= regs_55;
				regs_55 <= regs_56;
				regs_56 <= regs_57;
				regs_57 <= regs_58;
				regs_58 <= regs_59;
				regs_59 <= regs_60;
				regs_60 <= regs_61;
				regs_61 <= regs_62;
				regs_62 <= regs_63;
				regs_63 <= regs_64;
				regs_64 <= regs_65;
				regs_65 <= regs_66;
				regs_66 <= regs_67;
				regs_67 <= regs_68;
				regs_68 <= regs_69;
				regs_69 <= regs_70;
				regs_70 <= regs_71;
				regs_71 <= regs_72;
				regs_72 <= regs_73;
				regs_73 <= regs_74;
				regs_74 <= regs_75;
				regs_75 <= regs_76;
				regs_76 <= regs_77;
				regs_77 <= regs_78;
				regs_78 <= regs_79;
				regs_79 <= regs_80;
				regs_80 <= regs_81;
				regs_81 <= regs_82;
				regs_82 <= regs_83;
				regs_83 <= regs_84;
				regs_84 <= regs_85;
				regs_85 <= regs_86;
				regs_86 <= regs_87;
				regs_87 <= regs_88;
				regs_88 <= regs_89;
				regs_89 <= regs_90;
				regs_90 <= regs_91;
				regs_91 <= regs_92;
				regs_92 <= regs_93;
				regs_93 <= regs_94;
				regs_94 <= regs_95;
				regs_95 <= regs_96;
				regs_96 <= regs_97;
				regs_97 <= regs_98;
				regs_98 <= regs_99;
				regs_99 <= regs_100;
				regs_100 <= regs_101;
				regs_101 <= regs_102;
				regs_102 <= regs_103;
				regs_103 <= regs_104;
				regs_104 <= regs_105;
				regs_105 <= regs_106;
				regs_106 <= regs_107;
				regs_107 <= regs_108;
				regs_108 <= regs_109;
				regs_109 <= regs_110;
				regs_110 <= regs_111;
				regs_111 <= regs_112;
				regs_112 <= regs_113;
				regs_113 <= regs_114;
				regs_114 <= regs_115;
				regs_115 <= regs_116;
				regs_116 <= regs_117;
				regs_117 <= regs_118;
				regs_118 <= regs_119;
				regs_119 <= regs_120;
				regs_120 <= regs_121;
				regs_121 <= regs_122;
				regs_122 <= regs_123;
				regs_123 <= regs_124;
				regs_124 <= regs_125;
				regs_125 <= regs_126;
				regs_126 <= regs_127;
				regs_127 <= regs_128;
				regs_128 <= regs_129;
				regs_129 <= regs_130;
				regs_130 <= regs_131;
				regs_131 <= regs_132;
				regs_132 <= regs_133;
				regs_133 <= regs_134;
				regs_134 <= regs_135;
				regs_135 <= regs_136;
				regs_136 <= regs_137;
				regs_137 <= regs_138;
				regs_138 <= regs_139;
				regs_139 <= regs_140;
				regs_140 <= regs_141;
				regs_141 <= regs_142;
				regs_142 <= regs_143;
				regs_143 <= regs_144;
				regs_144 <= regs_145;
				regs_145 <= regs_146;
				regs_146 <= regs_147;
				regs_147 <= regs_148;
				regs_148 <= regs_149;
				regs_149 <= regs_150;
				regs_150 <= regs_151;
				regs_151 <= regs_152;
				regs_152 <= regs_153;
				regs_153 <= regs_154;
				regs_154 <= regs_155;
				regs_155 <= regs_156;
				regs_156 <= regs_157;
				regs_157 <= regs_158;
				regs_158 <= regs_159;
				regs_159 <= regs_160;
				regs_160 <= regs_161;
				regs_161 <= _se_io_bit_out_bits;
			end
			if (_se_io_done)
				ctr <= 8'h00;
		end
	StringEncoder se(
		.clock(clock),
		.reset(reset),
		.io_config_in_valid(io_config_in_valid),
		.io_config_in_bits(io_config_in_bits),
		.io_start(io_start),
		.io_done(_se_io_done),
		.io_bit_out_valid(_se_io_bit_out_valid),
		.io_bit_out_bits(_se_io_bit_out_bits)
	);
	assign io_bit_out_bits = {regs_0, _GEN[ctr]};
endmodule
module TopLevel (
	clock,
	reset,
	io_config_bits_in,
	io_config_valid_in,
	io_config_start,
	io_rf_start,
	io_rf_out,
	io_bit_out
);
	input clock;
	input reset;
	input [7:0] io_config_bits_in;
	input io_config_valid_in;
	input io_config_start;
	input io_rf_start;
	output wire io_rf_out;
	output wire [1:0] io_bit_out;
	wire [1:0] _se_io_bit_out_bits;
	reg [7:0] config_regs_0;
	reg [7:0] config_regs_1;
	reg [7:0] config_regs_2;
	reg [7:0] config_regs_3;
	reg [7:0] config_regs_4;
	reg [7:0] config_regs_5;
	reg [7:0] config_regs_6;
	reg [7:0] config_regs_7;
	reg [7:0] config_regs_8;
	reg [7:0] config_regs_9;
	reg [31:0] symbol_time_ctr;
	reg [31:0] osc_time_ctr;
	reg [7:0] symbol_ctr;
	wire _GEN = symbol_time_ctr == 32'h00000000;
	always @(posedge clock) begin : sv2v_autoblock_1
		reg [31:0] symbol_time;
		symbol_time = {config_regs_0, config_regs_1, config_regs_2, config_regs_3};
		if (io_config_valid_in) begin
			config_regs_0 <= config_regs_1;
			config_regs_1 <= config_regs_2;
			config_regs_2 <= config_regs_3;
			config_regs_3 <= config_regs_4;
			config_regs_4 <= config_regs_5;
			config_regs_5 <= config_regs_6;
			config_regs_6 <= config_regs_7;
			config_regs_7 <= config_regs_8;
			config_regs_8 <= config_regs_9;
			config_regs_9 <= io_config_bits_in;
		end
		if (_GEN) begin
			symbol_time_ctr <= symbol_time;
			symbol_ctr <= symbol_ctr - 8'h01;
		end
		else begin
			if (|symbol_ctr)
				symbol_time_ctr <= symbol_time_ctr - 32'h00000001;
			else if (io_rf_start)
				symbol_time_ctr <= symbol_time;
			if (io_rf_start)
				symbol_ctr <= 8'ha2;
		end
		if (|symbol_ctr)
			osc_time_ctr <= (osc_time_ctr + {config_regs_4, config_regs_5, config_regs_6, config_regs_7}) + {14'h0000, {16'h0000, _se_io_bit_out_bits} * {2'h0, config_regs_8, config_regs_9}};
		else if (io_rf_start)
			osc_time_ctr <= 32'h00000000;
	end
	BitGenerator se(
		.clock(clock),
		.reset(reset),
		.io_config_in_valid(io_config_valid_in),
		.io_config_in_bits(io_config_bits_in),
		.io_start(io_config_start),
		.io_bit_out_ready(_GEN),
		.io_bit_out_bits(_se_io_bit_out_bits)
	);
	assign io_rf_out = osc_time_ctr[31];
	assign io_bit_out = _se_io_bit_out_bits;
endmodule
