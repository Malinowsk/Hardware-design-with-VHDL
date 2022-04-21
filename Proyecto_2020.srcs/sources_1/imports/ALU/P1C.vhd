library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--Entidad de la alu, aca se definen sus entradas y salidas
entity ALU is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC);
end ALU;

--Arquitectura de la alu, aca definimos su funcionamiento
architecture PRACTICA of ALU is
signal x: STD_LOGIC_VECTOR (31 downto 0);
begin   

    --Proceso - lista de sensibilidad: a, b, control
    P1C: Process(a, b, control)
    begin
        --Funcionamiento del control de la alu, con todos sus codigos de operacion
        case (control) is
            when "000" => x <= a and b;
            when "001" => x <= a or b;
            when "010" => x <= a + b;
            when "110" => x <= a - b;
            when "100" => x <= b(15 downto 0) & x"0000";
            when "111" =>
                if (a < b) then
                    x <= x"00000001";
                else
                    x <= x"00000000";
                end if;
            when others => x <= (others => '0');
           end case;
    end  process;
    
    --sentencia concurrente - asigno al resultado el valor de la señal X
    result <= x;
    
    --Proceso - lista de sensibilidad: signal X
    Z: process(x)
    begin
        --Funcionamiento de la salida zero, devuelve un 1 en caso de que el resultado de operacion sea 0
        if (x = x"00000000") then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;

end PRACTICA;
