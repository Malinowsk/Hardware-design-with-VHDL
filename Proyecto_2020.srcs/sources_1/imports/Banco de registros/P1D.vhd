library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Registers is
	port(clk, reset, wr: in std_logic;
		 reg1_rd, reg2_rd, reg_wr : in std_logic_vector(4 downto 0);
		 data_wr : in std_logic_vector(31 downto 0);
		 data1_rd, data2_rd : out std_logic_vector(31 downto 0));
end Registers;

architecture PRACTICA of Registers is

TYPE T_REG is ARRAY(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal reg:T_REG;
begin
    process(clk,reset)
    begin
        if(reset='1') then
            reg<=(others=>x"00000000");
        elsif(Falling_Edge(clk)) then
            if(wr = '1') then
                reg(CONV_Integer(reg_wr))<=data_wr;
            end if;
        end if;
    end process;

data1_rd<=x"00000000" when (reg1_rd= "00000") else  reg(CONV_Integer(reg1_rd));

data2_rd<=x"00000000" when (reg2_rd= "00000") else  reg(CONV_Integer(reg2_rd));


end PRACTICA;
