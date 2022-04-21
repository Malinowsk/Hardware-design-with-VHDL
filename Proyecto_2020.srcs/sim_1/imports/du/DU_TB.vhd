library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DU_TB is
end DU_TB;

architecture Behavioral of DU_TB is
component DU is --declaracion de los componentes de la ALU
        port (Instruction : in STD_LOGIC_VECTOR (5 downto 0);
           RegDest : out STD_LOGIC;
           Jump : out STD_LOGIC;
           Branch : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           AluOp : out STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
    end component;
    
    --señales de estimulacion del circuito - señales de entrada
    signal Instruction_signal : STD_LOGIC_VECTOR (5 downto 0);
    signal RegDest_signal : STD_LOGIC;
    signal Jump_signal : STD_LOGIC;
    signal Branch_signal : STD_LOGIC;
    signal MemRead_signal : STD_LOGIC;
    signal MemtoReg_signal : STD_LOGIC;
    signal AluOp_signal : STD_LOGIC_VECTOR(1 downto 0);
    signal MemWrite_signal : STD_LOGIC;
    signal AluSrc_signal : STD_LOGIC;
    signal RegWrite_signal : STD_LOGIC;

begin
    --especificacion de las conecciones d la alu
    TB : DU port map (
        Instruction => Instruction_signal,
        RegDest => RegDest_signal,
        Jump => Jump_signal,
        Branch => Branch_signal,
        MemRead => MemRead_signal,
        MemtoReg => MemtoReg_signal,
        AluOp => AluOp_signal,
        MemWrite => MemWrite_signal,
        AluSrc => AluSrc_signal,
        RegWrite => RegWrite_signal);

    OP: process
    begin

        Instruction_signal <= "000000";
        wait for 10 ns;

        Instruction_signal <= "100011";
        wait for 10 ns;
        
        Instruction_signal <= "101011";
        wait for 10 ns;
        
        Instruction_signal <= "000100";
        wait for 10 ns;
        
        Instruction_signal <= "001111";
        wait for 10 ns;
        
        Instruction_signal <= "101010";
		wait for 10 ns;
        
        Instruction_signal <= "000101";
        wait;
    end process;

end Behavioral;
