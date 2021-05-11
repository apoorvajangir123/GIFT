----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2020 03:11:07 PM
-- Design Name: 
-- Module Name: sbox - Behavioral
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

entity sbox is
 Port ( enable: in STD_LOGIC;
	        sbox_in : in  STD_LOGIC_VECTOR (3 downto 0);
           sbox_out : out  STD_LOGIC_VECTOR (3 downto 0)); 
end sbox;

architecture Behavioral of sbox is

begin
process(enable,sbox_in)
begin
if enable='0' then
sbox_out<="0000";
else
sbox_out(3)<=((not sbox_in(3)) and sbox_in(0)) or ((not sbox_in(2)) and (not sbox_in(1)) and sbox_in(0)) or (sbox_in(2) and sbox_in(1) and sbox_in(0)) or (sbox_in(3) and sbox_in(1) and (not sbox_in(0)));

sbox_out(2)<=((not sbox_in(3))and(not sbox_in(2)) and sbox_in(1)) or ((not sbox_in(3)) and sbox_in(2) and (not sbox_in(1))) or (sbox_in(2) and (not sbox_in(1)) and (not sbox_in(0))) or (sbox_in(3) and (not sbox_in(2)) and sbox_in(0)) or (sbox_in(3) and sbox_in(1) and sbox_in(0));

sbox_out(1)<=((not sbox_in(3)) and (not sbox_in(1)) and sbox_in(0)) or ((not sbox_in(3)) and sbox_in(2) and (not sbox_in(0))) or (sbox_in(3) and (not sbox_in(2)) and (not sbox_in(0))) or ( sbox_in(3) and sbox_in(1) and sbox_in(0));

sbox_out(0)<=((not sbox_in(3)) and sbox_in(2) and sbox_in(0))or ((not sbox_in(3)) and sbox_in(2) and sbox_in(1)) or(sbox_in(3) and (not sbox_in(2)) and sbox_in(0)) or(sbox_in(3) and (not sbox_in(2)) and sbox_in(1)) or ((not sbox_in(3)) and (not sbox_in(2)) and (not sbox_in(1)) and (not sbox_in(0))) or (sbox_in(3) and sbox_in(2) and (not sbox_in(1))and(not sbox_in(0)));

end if;
end process;

end Behavioral;
