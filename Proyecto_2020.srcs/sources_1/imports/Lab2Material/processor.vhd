library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
port(Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
	);
end processor;

architecture processor_arq of processor is 
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

COMPONENT DU
        Port (Instruction : in STD_LOGIC_VECTOR (5 downto 0);
           RegDest : out STD_LOGIC;
       --    Jump : out STD_LOGIC;
           Branch : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           AluOp : out STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
    end COMPONENT;

    --Alu
COMPONENT ALU
Port(a: in STD_LOGIC_VECTOR(31 downto 0);
b: in STD_LOGIC_VECTOR(31 downto 0);
            control: in STD_LOGIC_VECTOR(2 downto 0);
            result: out STD_LOGIC_VECTOR(31 downto 0);
        	zero: out STD_LOGIC);
end COMPONENT;

-----señales IF
SIGNAL IF_PcOut: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL IF_PcIn: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL IF_Next: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL IF_OutMemoryInst: STD_LOGIC_VECTOR(31 downto 0);



------señales IFID
signal IFID_NextAddr: STD_LOGIC_VECTOR(31 downto 0);
signal IFID_Inst: STD_LOGIC_VECTOR(31 downto 0);

--señales ID
signal ID_Dato1: STD_LOGIC_VECTOR(31 downto 0);
signal ID_Dato2: STD_LOGIC_VECTOR(31 downto 0);
signal ID_SingExt: STD_LOGIC_VECTOR(31 downto 0);
signal ID_AluOp: STD_LOGIC_VECTOR (1 downto 0);
signal ID_RegDest: STD_LOGIC;
signal ID_Branch: STD_LOGIC;
signal ID_Memread: STD_LOGIC;
signal ID_Memtoreg: STD_LOGIC;
signal ID_Memwrite: STD_LOGIC;
signal ID_Alusrc: STD_LOGIC;
signal ID_Regwrite: STD_LOGIC;

-- señales IDEX

signal IDEX_Regwrite: STD_LOGIC;
signal IDEX_RegDest: STD_LOGIC;
signal IDEX_Alusrc: STD_LOGIC;
signal IDEX_Memread: STD_LOGIC;
signal IDEX_Memwrite: STD_LOGIC;
signal IDEX_Memtoreg: STD_LOGIC;
signal IDEX_AluOp: STD_LOGIC_VECTOR(1 downto 0); 
signal IDEX_Branch: STD_LOGIC;  
signal IDEX_DirNextInst: STD_LOGIC_VECTOR(31 downto 0); 
signal IDEX_Dato1: STD_LOGIC_VECTOR(31 downto 0); 
signal IDEX_Dato2: STD_LOGIC_VECTOR(31 downto 0);
signal IDEX_Signextend: STD_LOGIC_VECTOR(31 downto 0);
signal IDEX_Rt: STD_LOGIC_VECTOR(4 downto 0);
signal IDEX_Rd: STD_LOGIC_VECTOR(4 downto 0);

-- señales EX

signal Ex_Oper1: STD_LOGIC_VECTOR(31 downto 0);
signal Ex_Oper2: STD_LOGIC_VECTOR(31 downto 0);
signal Ex_ControlAlu: STD_LOGIC_VECTOR(2 downto 0);
signal Ex_ResultAlu: STD_LOGIC_VECTOR(31 downto 0);
signal Ex_Zero: STD_LOGIC;
signal Ex_RegDest: STD_LOGIC_VECTOR(4 downto 0);
signal Ex_Funct: STD_LOGIC_VECTOR(5 downto 0);
signal Ex_DirSaltoDespl: STD_LOGIC_VECTOR(31 downto 0);
signal Ex_OutAdd: STD_LOGIC_VECTOR(31 downto 0);


-- SEÑALES EXMEM

    signal ExMem_Regwrite: std_logic;
    signal ExMem_Memread: std_logic;
    signal ExMem_Memwrite: std_logic;
    signal ExMem_Memtoreg : std_logic;
    signal ExMem_Branch : std_logic;
    signal ExMem_dataWrite: std_logic_vector(31 downto 0);
    signal ExMem_ResultAlu: std_logic_vector(31 downto 0);
    signal ExMem_Zero: std_logic;
    signal ExMem_DirNextInst: std_logic_vector(31 downto 0);
    signal ExMem_Regdestino: std_logic_vector(4 downto 0);

-- señales MEM

signal Mem_Address: std_logic_vector(31 downto 0);
signal Mem_OutDataMemory : std_logic_vector(31 downto 0);
signal MEM_Pcsrc: std_logic;

-- SEÑALES MEMWB

signal MemWb_Regwrite : std_logic;
signal MemWb_Memtoreg : std_logic;
signal Memwb_Regdestino : std_logic_vector(4 downto 0);
signal Memwb_DataMemoryReadDate : std_logic_vector(31 downto 0);
signal Memwb_ResultAlu : std_logic_vector(31 downto 0);
signal Memwb_InDatawr : std_logic_vector(31 downto 0);

--señales WB

signal WB_RegWrite: std_logic;
signal WB_InDatawr: std_logic_vector(31 downto 0); --WB_InDatawr
--signal WB_Regdestino: std_logic_vector(4 downto 0); --WB_Regdestino

begin 	
 
 -- Conexión de entradas/salidas de la  memoria de instrucción a señales internas del MIPS


I_Addr <= IF_PcOut;
I_RdStb <= '1'; 
I_WrStb <= '0'; 
I_DataOut <= x"00000000";
IF_OutMemoryInst <= I_DataIn;


--Esto sería la carga de la direccion de la instrucción (PC)
--PC_reg:
 process(Clk,Reset)
    begin
        if (Reset = '1') then 
            IF_PcOut <= (others => '0');
        elsif (rising_edge(Clk)) then
            IF_PcOut <= IF_PcIn;
        end if;
    end process;



-- Sumador 

IF_Next <= IF_PcOut +x"00000004";

--Multiplexor entre la proxima instruccion y el salto
    IF_PcIn <= IF_Next when MEM_Pcsrc='0' else ExMem_DirNextInst;
    

 --Registro IF/ID (si el reset es "0" pone los 2 registros en "0", sino si el hubo franco ascendente de clock copio las 2 señales)
--IFID :
     process(Clk,Reset)
    begin
        if (Reset = '1') then
            IFID_NextAddr <= (others=>'0');
            IFID_Inst <= (others=>'0');
        elsif (rising_edge(Clk)) then
            IFID_NextAddr <= IF_Next;
            IFID_Inst <= IF_OutMemoryInst;
        end if;
    end process;

    --ETAPA ID

    --Extencion del signo

ID_SingExt <= x"0000" & IFID_Inst(15 downto 0) when (IFID_Inst(15)= '0') else x"FFFF" & IFID_Inst(15 downto 0) ;
   
 --Instanciación del Banco de registros

  
  uutBancoRegistros : Registers port map(
        clk => Clk,
        reset => Reset,
        wr => MemWb_Memtoreg,
        reg1_rd => IFID_Inst(25 downto 21),
        reg2_rd => IFID_Inst(20 downto 16),
        reg_wr => Memwb_Regdestino,
        data1_rd => ID_Dato1,
        data2_rd => ID_Dato2,  
        data_wr => WB_InDatawr
        );

--DUInstruction: process(Instruction)

uutControl: DU port map(
	Instruction => IFID_Inst(31 downto 26),
	RegDest => ID_RegDest,
	Branch => ID_Branch,
	MemRead => ID_MemRead,
	Memtoreg => ID_Memtoreg,
	AluOp => ID_AluOp,
	Memwrite => ID_Memwrite,
	Alusrc => ID_Alusrc,
	Regwrite => ID_Regwrite
);

 --Alu
    uutAL : ALU port map(
        a => Ex_Oper1,
        b => Ex_Oper2,
        control => Ex_ControlAlu,
        result =>  Ex_ResultAlu,
        zero => Ex_Zero
        );


 --Registro ID/EX  (SEGMENTADO)
--IDEX :
     process(Clk,Reset)
    begin
        if (Reset = '1') then
            IDEX_Regwrite <= '0';
            IDEX_RegDest <= '0';
            IDEX_Alusrc <= '0';
            IDEX_Memread <= '0';
            IDEX_Memwrite <= '0';
            IDEX_Memtoreg <= '0';
            IDEX_AluOp <= "00"; 
            IDEX_Branch <= '0';  
            IDEX_DirNextInst <= (others=>'0'); 
            IDEX_Dato1 <= (others=>'0'); 
            IDEX_Dato2 <= (others=>'0');
            IDEX_Signextend <= (others=>'0');
            IDEX_Rt <= (others=>'0');
            IDEX_Rd <= (others=>'0');
        elsif (rising_edge(Clk)) then
            IDEX_Regwrite <= ID_Regwrite;
            IDEX_RegDest <= ID_RegDest;
            IDEX_Alusrc <= ID_Alusrc;
            IDEX_Memread <= ID_Memread;
            IDEX_Memwrite <= ID_Memwrite;
            IDEX_Memtoreg <= ID_Memtoreg;
            IDEX_AluOp <= ID_AluOp; 
            IDEX_Branch <= ID_Branch;  
            IDEX_Dato1 <= Id_Dato1; 
            IDEX_Dato2 <= Id_Dato2;
            IDEX_Signextend <= ID_SingExt; 
            IDEX_DirNextInst <= IFID_NextAddr;
            IDEX_Rt <= IFID_Inst(20 downto 16);
            IDEX_Rd <= IFID_Inst(15 downto 11);
        end if;
    end process;


         --ETAPA EX 
    Ex_Funct <= Idex_Signextend(5 downto 0);
    Ex_Oper1 <= Idex_Dato1;

    --Multiplixor entre el dato de rt y el inmediato
    Ex_Oper2 <= IDEX_Dato2 when IDEX_Alusrc = '0' else IDEX_Signextend;  

    --Multiplixor entre rt y rd
    Ex_RegDest <= IDEX_Rt when IDEX_RegDest='0' else IDEX_Rd;
   
 --Desplazamiento de la direccion de salto
    Ex_DirSaltoDespl <= Idex_Signextend(29 downto 0) & "00";

    --Multipliexor entre Direccion de salto y Direccion de la prox instrucion
    Ex_OutAdd <= Idex_DirNextInst +  Ex_DirSaltoDespl;
   
    --AluControl
    
    
--AluControl :
     process(Ex_Funct,IDex_AluOp)
    begin
        case IDex_AluOp is
                when "00" =>                     -- LW Y TW
                    Ex_ControlAlu <= "010"; --suma
                when "01" =>                      -- BEQ
                    Ex_ControlAlu <= "110"; --resta
                when "10" =>                   --TIPO R
                    case Ex_Funct is
                        when "100000" =>
                            Ex_ControlAlu <= "010";  --suma 
                        when "100010" =>
                            Ex_ControlAlu <= "110";  --resta
                        when "100100" =>
                            Ex_ControlAlu <= "000"; --and
                        when "100101" =>
                            Ex_ControlAlu <= "001"; --or
                        when "101010" =>
                            Ex_ControlAlu <= "111";  --a menor b
                        when others =>
                            Ex_ControlAlu <= "000"; --and
                    end case;
                when others =>
                    Ex_ControlAlu <= "100"; -- b << 16
        end case;
    end process;


  
 --Alu
 
    AL : ALU port map(
        a => Ex_Oper1,
        b => Ex_Oper2,
        control => Ex_ControlAlu,
        result =>  Ex_ResultAlu,
        zero => Ex_Zero
        );





  --Registro Ex/MEM (SEGMENTACION)
--EXMEM :
     process(Clk,Reset)
    begin
        if (Reset = '1') then
            ExMem_Regwrite <= '0';
            ExMem_Memread <= '0';
            ExMem_Memwrite <= '0';
            ExMem_Memtoreg <= '0';
            ExMem_Branch <= '0';
            ExMem_dataWrite <= (others=>'0');
            ExMem_ResultAlu <= (others=>'0');
            ExMem_Zero <= '0';
            ExMem_DirNextInst <= (others=>'0');
            ExMem_Regdestino <= (others=>'0');
        elsif (rising_edge(Clk)) then
            ExMem_Regwrite <= IDex_Regwrite;
            ExMem_Memread <= IDex_Memread;
            ExMem_Memwrite <= IDex_Memwrite;
            ExMem_Memtoreg <= IDex_Memtoreg;
            ExMem_Branch <= IDex_Branch;
            ExMem_dataWrite <= Idex_Dato2;
            ExMem_ResultAlu <= Ex_ResultAlu;
            ExMem_Zero <= Ex_Zero;
            ExMem_DirNextInst <= Ex_OutAdd;
            ExMem_Regdestino <= Ex_Regdest;
        end if;
    end process;  


-----------------------------------------------------------------------------

      --ETAPA MEM
    D_Addr <= Mem_Address;
    D_RdStb <= ExMem_Memread;
    D_WrStb <= ExMem_Memwrite;
    D_DataOut <= ExMem_dataWrite;
    Mem_OutDataMemory <= D_DataIn;
    --Calculo de signal Pcsrc
    MEM_Pcsrc <= ExMem_Branch and ExMem_Zero;
    Mem_Address <= ExMem_ResultAlu;

--MEMwb :
     process(Clk,Reset)
    begin
        if (Reset = '1') then
            MemWb_Regwrite <= '0';
            MemWb_Memtoreg <= '0';
            Memwb_Regdestino <= (others=>'0');
            Memwb_DataMemoryReadDate <= (others=>'0');
            Memwb_ResultAlu <= (others=>'0');
            Memwb_InDatawr <= (others=>'0');
        elsif (rising_edge(Clk)) then
            MemWb_Regwrite <= '0';
            MemWb_Memtoreg <= ExMem_Memtoreg;
            Memwb_Regdestino <= ExMem_Regdestino;
            Memwb_DataMemoryReadDate <= Mem_OutDataMemory;
            Memwb_ResultAlu <= ExMem_ResultAlu;
            Memwb_InDatawr <= ExMem_dataWrite;
        end if;
    end process;

             --ETAPA WB
    WB_InDatawr <= Memwb_DataMemoryReadDate when ExMem_Memtoreg='0' else Memwb_ResultAlu;    


end processor_arq;
