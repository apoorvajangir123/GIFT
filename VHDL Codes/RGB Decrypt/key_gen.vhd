----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2020 10:29:04 AM
-- Design Name: 
-- Module Name: key_gen - Behavioral
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

entity key_gen is
Port ( clk,reset,ld_key,en_key: in std_logic;
			input : in  STD_LOGIC_VECTOR (127 downto 0);
           output : out  STD_LOGIC_VECTOR (127 downto 0));
end key_gen;

architecture Behavioral of key_gen is
signal round_key:STD_LOGIC_VECTOR (127 downto 0);
begin
key_generation:process(clk,reset)
               begin
               if reset='1' then 
               round_key<=(others=>'0');
               elsif clk'event and clk='1' then
					if en_key='1' then
               if ld_key='1' then
               round_key<=input;
               else
               round_key<=round_key(17 downto 16) & round_key(31 downto 18)&round_key(11 downto 0) & round_key(15 downto 12)&round_key(127 downto 32);
                              
               end if;
					end if;
               end if;
               end process;		
output<=round_key;

end Behavioral;
