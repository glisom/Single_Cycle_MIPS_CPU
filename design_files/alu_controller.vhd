LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY ALU_controller IS
   PORT( 
      ALU_op      : IN     std_logic_vector (1 DOWNTO 0);
      funct       : IN     std_logic_vector (5 DOWNTO 0);
      ALU_control : OUT    std_logic_vector (3 DOWNTO 0)
   );
END ALU_controller ;


ARCHITECTURE struct OF ALU_controller IS

BEGIN
   ---------------------------------------------------------------------------
   process1 : PROCESS (ALU_op, funct)
   ---------------------------------------------------------------------------
   BEGIN
      CASE ALU_op IS
      WHEN "00" =>
         ALU_control <= "0010"; -- lw & sw --> add
      WHEN "01" =>
         ALU_control <= "0110"; -- beq --> sub
      WHEN "10" =>
         CASE funct IS
         WHEN "100000" =>
            ALU_control <= "0010"; -- add
         WHEN "100010" =>
            ALU_control <= "0110"; -- sub
         WHEN "100100" =>
            ALU_control <= "0000"; -- and
         WHEN "100101" =>
            ALU_control <= "0001"; -- or
         WHEN "101010" =>
            ALU_control <= "0111"; -- slt
         WHEN others =>
            ALU_control <= "1111"; -- default
         END CASE;
      WHEN others =>
         ALU_control <= "1111"; -- default
      END CASE;
   END PROCESS process1;
END struct;
