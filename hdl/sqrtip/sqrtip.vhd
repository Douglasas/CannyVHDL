-- megafunction wizard: %ALTSQRT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: ALTSQRT 

-- ============================================================
-- File Name: sqrtip.vhd
-- Megafunction Name(s):
-- 			ALTSQRT
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 13.1.4 Build 182 03/12/2014 SJ Web Edition
-- ************************************************************


--Copyright (C) 1991-2014 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, Altera MegaCore Function License 
--Agreement, or other applicable license agreement, including, 
--without limitation, that your use is for the sole purpose of 
--programming logic devices manufactured by Altera and sold by 
--Altera or its authorized distributors.  Please refer to the 
--applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY sqrtip IS
	PORT
	(
		clk		: IN STD_LOGIC ;
		ena		: IN STD_LOGIC ;
		radical		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		remainder		: OUT STD_LOGIC_VECTOR (32 DOWNTO 0)
	);
END sqrtip;


ARCHITECTURE SYN OF sqrtip IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (32 DOWNTO 0);



	COMPONENT altsqrt
	GENERIC (
		pipeline		: NATURAL;
		q_port_width		: NATURAL;
		r_port_width		: NATURAL;
		width		: NATURAL;
		lpm_type		: STRING
	);
	PORT (
			clk	: IN STD_LOGIC ;
			ena	: IN STD_LOGIC ;
			radical	: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			q	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			remainder	: OUT STD_LOGIC_VECTOR (32 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	q    <= sub_wire0(31 DOWNTO 0);
	remainder    <= sub_wire1(32 DOWNTO 0);

	ALTSQRT_component : ALTSQRT
	GENERIC MAP (
		pipeline => 10,
		q_port_width => 32,
		r_port_width => 33,
		width => 64,
		lpm_type => "ALTSQRT"
	)
	PORT MAP (
		clk => clk,
		ena => ena,
		radical => radical,
		q => sub_wire0,
		remainder => sub_wire1
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: PIPELINE NUMERIC "10"
-- Retrieval info: CONSTANT: Q_PORT_WIDTH NUMERIC "32"
-- Retrieval info: CONSTANT: R_PORT_WIDTH NUMERIC "33"
-- Retrieval info: CONSTANT: WIDTH NUMERIC "64"
-- Retrieval info: USED_PORT: clk 0 0 0 0 INPUT NODEFVAL "clk"
-- Retrieval info: USED_PORT: ena 0 0 0 0 INPUT NODEFVAL "ena"
-- Retrieval info: USED_PORT: q 0 0 32 0 OUTPUT NODEFVAL "q[31..0]"
-- Retrieval info: USED_PORT: radical 0 0 64 0 INPUT NODEFVAL "radical[63..0]"
-- Retrieval info: USED_PORT: remainder 0 0 33 0 OUTPUT NODEFVAL "remainder[32..0]"
-- Retrieval info: CONNECT: @clk 0 0 0 0 clk 0 0 0 0
-- Retrieval info: CONNECT: @ena 0 0 0 0 ena 0 0 0 0
-- Retrieval info: CONNECT: @radical 0 0 64 0 radical 0 0 64 0
-- Retrieval info: CONNECT: q 0 0 32 0 @q 0 0 32 0
-- Retrieval info: CONNECT: remainder 0 0 33 0 @remainder 0 0 33 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL sqrtip.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL sqrtip.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL sqrtip.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL sqrtip.bsf TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL sqrtip_inst.vhd FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL sqrtip_syn.v TRUE
-- Retrieval info: LIB_FILE: altera_mf
