----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2020 09:31:35 AM
-- Design Name: 
-- Module Name: rc_ram - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rc_ram is
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (5 downto 0);
           address : in  integer range 0 to 27;
           data_out : out  STD_LOGIC_VECTOR (5 downto 0));
end rc_ram;

architecture Behavioral of rc_ram is
type mem_array is array(0 to 27)  of std_logic_vector(5 downto 0);
signal memory: MEM_array;-- := (others => '0'); 
begin
process (clk)
begin
if clk'event and clk = '1' then
 if cs = '1' then
  if we = '1' then
   memory(address)<= data_in;--memory(to_integer(unsigned(address))) <= data_in;
   data_out <= data_in;
  else
   data_out <= memory(address);--data_out <= memory( to_integer(unsigned(address)));
  end if;
 end if;
end if;
end process;



end Behavioral;
