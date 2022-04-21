library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity P1D_TB is
end P1D_TB;

architecture PRACTICA of P1D_TB is
    COMPONENT Registers
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               wr : in STD_LOGIC;
               reg1_rd : in STD_LOGIC_VECTOR (4 downto 0);
               reg2_rd : in STD_LOGIC_VECTOR (4 downto 0);
               reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
               data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
               data2_rd : out STD_LOGIC_VECTOR (31 downto 0);
               data_wr : in STD_LOGIC_VECTOR (31 downto 0));
    end COMPONENT;
    
    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL wr : STD_LOGIC;
    SIGNAL reg1_rd : STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL reg2_rd : STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL reg_wr : STD_LOGIC_VECTOR (4 downto 0);
    SIGNAL data1_rd : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL data2_rd : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL data_wr : STD_LOGIC_VECTOR (31 downto 0);
    
    constant delay: time:= 100 ns;
begin
    uut: Registers PORT MAP(
        clk => clk, reset => reset, wr => wr, reg1_rd => reg1_rd, reg2_rd => reg2_rd, reg_wr => reg_wr, data1_rd => data1_rd, data2_rd => data2_rd, data_wr => data_wr
    );
    -- tiempo de clock, el clock iterativamente cambia cada 50 ns de "0" a "1" y "1" a "0".
    tclk : process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;
	
    process
    begin
        reset <= '1';        --en los primeros 100 ns pongo en 0 el reset
        wait for delay;
        reset <= '0';        --en los segundos 100 ns--> escribo en el registro 1 el dato x"11111111"
        wr <= '1';
        report "Escribo en el registro 1";
        reg_wr <= "00001";
        data_wr <= x"22222222";
        wait for delay;
        report "Escribo en el registro 2";  -- en los terceros 100 ns, lo mismo pero en el registro 2
        reg_wr <= "00010";
        data_wr <= x"11111111";
        wait for delay;                      -- en los cuartos 100 ns, dejo de escribir y leo los 2 registros "1 y 2" 
        data_wr <= (others => '0');
        wr <= '0';
        report "Leo los registros";
        reg1_rd <= "00001";
        reg2_rd <= "00010";
        report "TestBench finalizado";
        wait;
    end process;
end PRACTICA;