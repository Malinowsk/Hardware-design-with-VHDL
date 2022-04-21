library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DU is
    Port ( Instruction : in STD_LOGIC_VECTOR (5 downto 0);
           RegDest : out STD_LOGIC;
          -- Jump : out STD_LOGIC;
           Branch : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           AluOp : out STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end DU;

architecture Behavioral of DU is

begin
Control:process(Instruction)
    begin
        case Instruction is
            when "000000" => --TIPO R
                RegDest <= '1';
                Alusrc <= '0';
                Memtoreg <= '0';
                Regwrite <= '1';
                Memread <= '0';
                Memwrite <= '0';
                Branch <= '0';
                AluOp <= "10";
            when "100011" => --LW
                RegDest <= '0';
                Alusrc <= '1';
                Memtoreg <= '1';
                Regwrite <= '1';
                Memread <= '1';
                Memwrite <= '0';
                Branch <= '0';
                AluOp <= "00";
            when "101011" => -- SW
                Alusrc <= '1';
                Regwrite <= '0';
                Memread <= '0';
                Memwrite <= '1';
                Branch <= '0';
                AluOp <= "00";
             when "000100" => -- BEQ
                Alusrc <= '0';
                Regwrite <= '0';
                Memread <= '0';
                Memwrite <= '0';
                Branch <= '1';
                AluOp <= "01";
             when "001111" => -- LUI
                Regwrite <= '1';
                AluOp <= "11";
                Alusrc <= '1';
                RegDest <= '0';
                Memread <= '0';
                Memwrite <= '0';
                Memtoreg <= '0';
			 when "000101" =>
				Alusrc <= '0';
                Regwrite <= '0';
                Memread <= '0';
                Memwrite <= '0';
                Branch <= '1';
                AluOp <= "10";
             when others =>
        end case;
    end process;

end Behavioral;
