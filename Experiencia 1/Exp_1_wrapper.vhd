--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Wed Mar 25 12:03:11 2026
--Host        : JorgeApud running 64-bit major release  (build 9200)
--Command     : generate_target Exp_1_wrapper.bd
--Design      : Exp_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Exp_1_wrapper is
  port (
    Led_0 : out STD_LOGIC;
    Switch_0 : in STD_LOGIC;
    anodo_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    catodo_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    clk_in_0 : in STD_LOGIC;
    rst_0 : in STD_LOGIC;
    serial_in_0 : in STD_LOGIC
  );
end Exp_1_wrapper;

architecture STRUCTURE of Exp_1_wrapper is
  component Exp_1 is
  port (
    clk_in_0 : in STD_LOGIC;
    Switch_0 : in STD_LOGIC;
    Led_0 : out STD_LOGIC;
    catodo_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    anodo_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    rst_0 : in STD_LOGIC;
    serial_in_0 : in STD_LOGIC
  );
  end component Exp_1;
begin
Exp_1_i: component Exp_1
     port map (
      Led_0 => Led_0,
      Switch_0 => Switch_0,
      anodo_0(3 downto 0) => anodo_0(3 downto 0),
      catodo_0(7 downto 0) => catodo_0(7 downto 0),
      clk_in_0 => clk_in_0,
      rst_0 => rst_0,
      serial_in_0 => serial_in_0
    );
end STRUCTURE;
