----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2020 09:31:56 AM
-- Design Name: 
-- Module Name: inverse_perm - Behavioral
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

entity inverse_perm is
   Port ( enable : in  STD_LOGIC;
           p_input : in  STD_LOGIC_VECTOR (63 downto 0);
           p_output : out  STD_LOGIC_VECTOR (63 downto 0));
end inverse_perm;

architecture Behavioral of inverse_perm is
signal temp: std_logic_vector(63 downto 0);
begin
process(enable,p_input)
begin
if enable='0' then
temp<=(others=>'0');
else
temp(0)<=p_input(0);
temp(1)<=p_input(17);
temp(2)<=p_input(34);
temp(3)<=p_input(51);
temp(4)<=p_input(48);
temp(5)<=p_input(1);
temp(6)<=p_input(18);
temp(7)<=p_input(35);
temp(8)<=p_input(32);
temp(9)<=p_input(49);
temp(10)<=p_input(2);
temp(11)<=p_input(19);
temp(12)<=p_input(16);
temp(13)<=p_input(33);
temp(14)<=p_input(50);
temp(15)<=p_input(3);
temp(16)<=p_input(4);
temp(17)<=p_input(21);
temp(18)<=p_input(38);
temp(19)<=p_input(55);
temp(20)<=p_input(52);
temp(21)<=p_input(5);
temp(22)<=p_input(22);
temp(23)<=p_input(39);
temp(24)<=p_input(36);
temp(25)<=p_input(53);
temp(26)<=p_input(6);
temp(27)<=p_input(23);
temp(28)<=p_input(20);
temp(29)<=p_input(37);
temp(30)<=p_input(54);
temp(31)<=p_input(7);
temp(32)<=p_input(8);
temp(33)<=p_input(25);
temp(34)<=p_input(42);
temp(35)<=p_input(59);
temp(36)<=p_input(56);
temp(37)<=p_input(9);
temp(38)<=p_input(26);
temp(39)<=p_input(43);
temp(40)<=p_input(40);
temp(41)<=p_input(57);
temp(42)<=p_input(10);
temp(43)<=p_input(27);
temp(44)<=p_input(24);
temp(45)<=p_input(41);
temp(46)<=p_input(58);
temp(47)<=p_input(11);
temp(48)<=p_input(12);
temp(49)<=p_input(29);
temp(50)<=p_input(46);
temp(51)<=p_input(63);
temp(52)<=p_input(60);
temp(53)<=p_input(13);
temp(54)<=p_input(30);
temp(55)<=p_input(47);
temp(56)<=p_input(44);
temp(57)<=p_input(61);
temp(58)<=p_input(14);
temp(59)<=p_input(31);
temp(60)<=p_input(28);
temp(61)<=p_input(45);
temp(62)<=p_input(62);
temp(63)<=p_input(15);
end if;
end process;
p_output<=temp;


end Behavioral;
