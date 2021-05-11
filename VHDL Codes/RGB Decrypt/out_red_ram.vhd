----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2020 10:19:19 AM
-- Design Name: 
-- Module Name: out_red_ram - Behavioral
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

entity out_red_ram is
   Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end out_red_ram;

architecture Behavioral of out_red_ram is
type mem_array is array(1048575 downto 0)  of integer range 0 to 255;
signal memory: MEM_array;--:=(x"2b7e151628aed2a6abf7158809cf4f3c", x"6609bc34ad74ff3f21abde347681cbea", x"efbccdf1846254afcd762851aacf672e", x"1b726cd68343bc87254c4c1eafaa8087", x"ff721863efcabbb87213901309efabde",x"90bc52736ade8f871de89213bcdaffff",x"bc87138adef86df098f87fbc2138708a",x"217308bcd980ee1f23fa98ec9821bd34");--,x"921890243bcecfe87acab84375bcea98",x"b54100de439cd98e67a98f78b67c8720");  
begin
process (clk)
begin
if clk'event and clk = '1' then
 if cs = '1' then
  if we = '1' then
  -- memory(address)<= data_in; 
memory(address) <= data_in;
  data_out <= data_in;
  else
 data_out <= memory(address);
  end if;
 end if;
end if;
end process;



end Behavioral;
