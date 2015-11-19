LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY PC_register IS
   PORT( 
      PC_next : IN     std_logic_vector (31 DOWNTO 0);
      clk     : IN     std_logic;
      rst     : IN     std_logic;
      PC      : OUT    std_logic_vector (31 DOWNTO 0)
   );
END PC_register ;


ARCHITECTURE struct OF PC_register IS


BEGIN
   ---------------------------------------------------------------------------
   process1 : PROCESS (clk, rst)
   ---------------------------------------------------------------------------
   BEGIN
      -- Asynchronous Reset
      IF (rst = '1') THEN
         -- Reset Actions
         PC <= x"00400000"; -- Text Segment Start

      ELSIF (clk'EVENT AND clk = '1') THEN
         PC <= PC_next;
      END IF;
   END PROCESS process1;
END struct;
