library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity P1C_TB is --entidad vacia como todo test bench
end P1C_TB;

architecture PRACTICA of P1C_TB is
    component ALU is --declaracion de los componentes de la ALU
        port (a       : in std_logic_vector (31 downto 0);
              b       : in std_logic_vector (31 downto 0);
              control : in std_logic_vector (2 downto 0);
              result  : out std_logic_vector (31 downto 0);
              zero    : out std_logic);
    end component;
    
    --señales de estimulacion del circuito - señales de entrada
    signal a_signal        : std_logic_vector (31 downto 0);
    signal b_signal        : std_logic_vector (31 downto 0);
    signal control_signal  : std_logic_vector (2 downto 0);
    --señales de observacion - señales de salida
    signal result_signal   : std_logic_vector (31 downto 0);
    signal zero_signal     : std_logic;

begin
    --especificacion de las conecciones d la alu
    TB : ALU port map (
        a => a_signal,
        b => b_signal,
        control => control_signal,
        result => result_signal,
        zero => zero_signal);

    OP: process
    begin
        -- Asignamos valores a las variables de la lista de sensibilidad
        a_signal <= x"10101010";
        b_signal <= x"01010101";
        --and
        control_signal <= "000";
        wait for 10 ns;
        
        --or
        control_signal <= "001";
        wait for 10 ns;

        --suma
        control_signal <= "010";
        a_signal <= x"5A5A5A5A";
        b_signal <= x"00000001";
        wait for 10 ns;
        
        --resta
        control_signal <= "110";
        wait for 10 ns;
        
        --a < b
        control_signal <= "111";
        a_signal <= x"11111110";
        b_signal <= x"11111111";
        wait for 10 ns;
        
        --desplazamiento
        control_signal <= "100";
        wait for 10 ns;

        --caso por defecto
        control_signal <= "101";

        wait;
    end process;
end PRACTICA;
