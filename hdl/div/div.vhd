-- megafunction wizard: %LPM_DIVIDE%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: LPM_DIVIDE

-- ============================================================
-- File Name: div.vhd
-- Megafunction Name(s):
-- 			LPM_DIVIDE
--
-- Simulation Library Files(s):
-- 			lpm
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

LIBRARY lpm;
USE lpm.all;

library work;
use work.slogic_pkg.all;
use work.normalization_pkg.all;

ENTITY div IS
	PORT
	(
		clken		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		denom		: IN STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0)
	);
END div;


ARCHITECTURE SYN OF div IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);



	COMPONENT lpm_divide
	GENERIC (
		lpm_drepresentation		: STRING;
		lpm_hint		: STRING;
		lpm_nrepresentation		: STRING;
		lpm_pipeline		: NATURAL;
		lpm_type		: STRING;
		lpm_widthd		: NATURAL;
		lpm_widthn		: NATURAL
	);
	PORT (
			clock	: IN STD_LOGIC ;
			remain	: OUT STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
			clken	: IN STD_LOGIC ;
			denom	: IN STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
			numer	: IN STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0);
			quotient	: OUT STD_LOGIC_VECTOR (MSB+2*LSB-1 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	remain    <= sub_wire0(MSB+2*LSB-1 DOWNTO 0);
	quotient    <= sub_wire1(MSB+2*LSB-1 DOWNTO 0);

	LPM_DIVIDE_component : LPM_DIVIDE
	GENERIC MAP (
		lpm_drepresentation => "SIGNED",
		lpm_hint => "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=FALSE",
		lpm_nrepresentation => "SIGNED",
		lpm_pipeline => QT_DIV_CYCLES,
		lpm_type => "LPM_DIVIDE",
		lpm_widthd => MSB+2*LSB,
		lpm_widthn => MSB+2*LSB
	)
	PORT MAP (
		clock => clock,
		clken => clken,
		denom => denom,
		numer => numer,
		remain => sub_wire0,
		quotient => sub_wire1
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
-- Retrieval info: PRIVATE: PRIVATE_LPM_REMAINDERPOSITIVE STRING "FALSE"
-- Retrieval info: PRIVATE: PRIVATE_MAXIMIZE_SPEED NUMERIC "-1"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: USING_PIPELINE NUMERIC "1"
-- Retrieval info: PRIVATE: VERSION_NUMBER NUMERIC "2"
-- Retrieval info: PRIVATE: new_diagram STRING "1"
-- Retrieval info: LIBRARY: lpm lpm.lpm_components.all
-- Retrieval info: CONSTANT: LPM_DREPRESENTATION STRING "SIGNED"
-- Retrieval info: CONSTANT: LPM_HINT STRING "LPM_REMAINDERPOSITIVE=FALSE"
-- Retrieval info: CONSTANT: LPM_NREPRESENTATION STRING "SIGNED"
-- Retrieval info: CONSTANT: LPM_PIPELINE NUMERIC "10"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_DIVIDE"
-- Retrieval info: CONSTANT: LPM_WIDTHD NUMERIC "32"
-- Retrieval info: CONSTANT: LPM_WIDTHN NUMERIC "32"
-- Retrieval info: USED_PORT: clken 0 0 0 0 INPUT NODEFVAL "clken"
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
-- Retrieval info: USED_PORT: denom 0 0 32 0 INPUT NODEFVAL "denom[31..0]"
-- Retrieval info: USED_PORT: numer 0 0 32 0 INPUT NODEFVAL "numer[31..0]"
-- Retrieval info: USED_PORT: quotient 0 0 32 0 OUTPUT NODEFVAL "quotient[31..0]"
-- Retrieval info: USED_PORT: remain 0 0 32 0 OUTPUT NODEFVAL "remain[31..0]"
-- Retrieval info: CONNECT: @clken 0 0 0 0 clken 0 0 0 0
-- Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: @denom 0 0 32 0 denom 0 0 32 0
-- Retrieval info: CONNECT: @numer 0 0 32 0 numer 0 0 32 0
-- Retrieval info: CONNECT: quotient 0 0 32 0 @quotient 0 0 32 0
-- Retrieval info: CONNECT: remain 0 0 32 0 @remain 0 0 32 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL div.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL div.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL div.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL div.bsf TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL div_inst.vhd TRUE
-- Retrieval info: LIB_FILE: lpm
