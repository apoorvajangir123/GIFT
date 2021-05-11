----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:10:04 01/30/2020 
-- Design Name: 
-- Module Name:    perm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity perm is
Port (enable: in std_logic;
	  perm_in:in std_logic_vector(63 downto 0);
	  perm_out: out std_logic_vector(63 downto 0));
end perm;

architecture Behavioral of perm is
signal temp: std_logic_vector(63 downto 0);
begin
process(enable,perm_in)
begin
if enable='0' then
temp<=(others=>'0');
else
temp(0)<= perm_in(0);
temp(17)<= perm_in(1);
temp(34)<= perm_in(2);
temp(51)<= perm_in(3);
temp(48)<= perm_in(4);
temp(1)<= perm_in(5);
temp(18)<= perm_in(6);
temp(35)<= perm_in(7);
temp(32)<= perm_in(8);
temp(49)<= perm_in(9);
temp(2)<= perm_in(10);
temp(19)<=perm_in(11);
temp(16)<= perm_in(12);
temp(33)<= perm_in(13);
temp(50)<= perm_in(14);
temp(3)<= perm_in(15);
temp(4)<= perm_in(16);
temp(21)<= perm_in(17);
temp(38)<= perm_in(18);
temp(55)<= perm_in(19);
temp(52)<= perm_in(20);
temp(5)<= perm_in(21);
temp(22)<= perm_in(22);
temp(39)<=perm_in(23);
temp(36)<= perm_in(24);
temp(53)<= perm_in(25);
temp(6)<=perm_in(26);
temp(23)<= perm_in(27);
temp(20)<= perm_in(28);
temp(37)<= perm_in(29);
temp(54)<= perm_in(30);
temp(7)<= perm_in(31);
temp(8)<= perm_in(32);
temp(25)<= perm_in(33);
temp(42)<= perm_in(34);
temp(59)<= perm_in(35);
temp(56)<= perm_in(36);
temp(9)<= perm_in(37);
temp(26)<= perm_in(38);
temp(43)<= perm_in(39);
temp(40)<= perm_in(40);
temp(57)<= perm_in(41);
temp(10)<= perm_in(42);
temp(27)<= perm_in(43);
temp(24)<= perm_in(44);
temp(41)<= perm_in(45);
temp(58)<=perm_in(46);
temp(11)<= perm_in(47);
temp(12)<= perm_in(48);
temp(29)<= perm_in(49);
temp(46)<= perm_in(50);
temp(63)<= perm_in(51);
temp(60)<= perm_in(52);
temp(13)<= perm_in(53);
temp(30)<= perm_in(54);
temp(47)<= perm_in(55);
temp(44)<= perm_in(56);
temp(61)<= perm_in(57);
temp(14)<= perm_in(58);
temp(31)<= perm_in(59);
temp(28)<= perm_in(60);
temp(45)<= perm_in(61);
temp(62)<= perm_in(62);
temp(15)<= perm_in(63);
end if;
end process;
perm_out<=temp;




end Behavioral;

