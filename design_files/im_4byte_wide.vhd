LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY IM IS
   PORT(
      ReadAddress : IN     std_logic_vector (31 DOWNTO 0);
      rst         : IN     std_logic;
      Instruction : OUT    std_logic_vector (31 DOWNTO 0)
   );
END IM ;


ARCHITECTURE struct_4byte_wide OF IM IS

   -- Architecture declarations
   constant program_size : natural := 16; -- Number of instructions

   constant text_segment_start : std_logic_vector(31 downto 0) := x"00400000";

   type im_mem_type is array(0 to program_size-1) of std_logic_vector(31 downto 0);
   constant nop : std_logic_vector(31 downto 0) := (others => '0');

   SIGNAL im_mem : im_mem_type;


   constant program : im_mem_type :=
      -- Insert your program binaries (machine code) here --
      (
      "00100000000010000000000000000101",
      "00100000000010010000000000000111",
      "10101111101010000000000000000000",
      "10101111101010011111111111111100",
      "10001111101100000000000000000000",
      "10001111101100011111111111111100",
      "00010010000100010000000000000010",
      "00000010000100011001100000100000",
      "00001000000100000000000000001010",
      "00000010000100011001100000100010",
      "00000010000100111000000000100000",
      "00000010001100111000100000100101",
      "00100001000010000000000000000011",
      "00100001001010010000000000000011",
      "00100011101111011111111111111000",
      "00001000000100000000000000000010"
      );
      ------------------------------------------------------

BEGIN

    process1 : process(ReadAddress, im_mem, rst)

    begin
        if (rst = '1') then
            Instruction <= nop;
             im_mem <= program;
        else
            Instruction <= im_mem( CONV_INTEGER(ReadAddress - text_segment_start) / 4 );
        end if;

    end process;

END struct_4byte_wide;
