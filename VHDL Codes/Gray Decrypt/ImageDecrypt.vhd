----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/04/2020 04:41:48 PM
-- Design Name: 
-- Module Name: ImageDecrypt - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ImageDecrypt is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
      Key : in  STD_LOGIC_VECTOR (127 downto 0);
           output : out  integer range 0 to 255);
end ImageDecrypt;

architecture Behavioral of ImageDecrypt is
component input_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer range 0 to 1048575;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;

--component round_key_ram
--Port ( clk : in  STD_LOGIC;
--           cs : in  STD_LOGIC;
--           we : in  STD_LOGIC;
--           address : in  STD_LOGIC_VECTOR (2 downto 0);
--           data_out : out  STD_LOGIC_VECTOR (127 downto 0));
--end component;
component output_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer range 0 to 1048575;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end component;
component giftdecrypt
Port ( clk : in  STD_LOGIC;
           reset,enable_decrypt : in  STD_LOGIC;
			  decrypt_in : in  STD_LOGIC_VECTOR (63 downto 0);
           decrypt_out : out  STD_LOGIC_VECTOR (7 downto 0);
           decrypt_key : in  STD_LOGIC_VECTOR (127 downto 0));
end component;

signal cs,enable,en,rw,enable_count,enable_reg,write_count:std_logic;
signal in_reg:integer range 0 to 255;--std_logic_vector(63 downto 0);
--signal round_key:std_logic_vector(127 downto 0);
signal count: integer range 0 to 1048575;
signal count1,count2: integer range 0 to 1048575;
--signal address1: STD_LOGIC_VECTOR(2 downto 0);
signal input_8bit: STD_LOGIC_VECTOR(63 downto 0);
signal gift_out: STD_LOGIC_VECTOR(7 downto 0);
signal GIFT_input:STD_LOGIC_VECTOR(7 downto 0);
signal out_int:integer range 0 to 255;
type state is (st1,st0,st2,st3);
signal pr_st,nx_st : state;

begin
load_input:process(reset,clk)
           begin
           if reset='1' then
           input_8bit<=(others=>'0');
           elsif clk'event and clk='1' then
           if enable_reg='1' then
           if count1>0 then
             input_8bit<=input_8bit(55 downto 0)& GIFT_input;
			-- else
			-- input_8bit<=out_reg;
             end if;
          -- else
         --  input_8bit<=(others=>'0');
           end if;
           end if;
           end process;
           
g1:input_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_reg );
--g2:round_key_ram port map(clk=>clk,cs=>cs,we=>we ,address=>address1 ,data_out=>round_key );
g3:giftdecrypt port map (clk => clk,reset => reset,enable_decrypt=>enable,decrypt_in => input_8bit,decrypt_key => Key,decrypt_out => gift_out);
g4:output_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_int, data_out=>output);

GIFT_input<=std_logic_vector(to_unsigned(in_reg, 8));
out_int<=to_integer(unsigned(gift_out));
counter:process (clk,reset)     
                    begin 
                        if (reset='1') then
                        count<=0;
                        elsif (clk='1' and clk'event)  then
                        								
                        if enable_count='1' then
								--(count=38) then
                            --count<=0;
                           -- else
                        count<=count + 1;
                    end if;
                end if;
                end process;
					-- address1 <= std_logic_vector(to_unsigned(count,3));
counter2:process (clk,reset)     
                                        begin
                                            if (reset='1') then
                                            count2<=0;
                                            elsif (clk='1' and clk'event)  then
                                                                            
                                            if write_count='1' then
                                                    --(count=38) then
                                                --count<=0;
                                               -- else
                                            count2<=count2 + 1;
                                        end if;
                                    end if;
                                    end process;
                                     --  address1 <= std_logic_vector(to_unsigned(count2,3));
counter1:process (clk,reset)     
                    begin
                        if (reset='1') then
                        count1<=0;
                        elsif (clk='1' and clk'event)  then 
                        if (count1=68) then
                            count1<=0;
                            else
                        count1<=count1 + 1;
                    end if;
                end if;
                end process;			  
state_reg : process (clk,reset)
           begin
           if (reset = '1') then
           pr_st <= st1;
           elsif (clk'event and clk='1')then
           pr_st <= nx_st;
           end if;
           end process;
           
next_state_logic : process (pr_st,count1)
                     begin
                     case pr_st is
--							when st0 =>
----							--if (count=27)then
--                     nx_st <= st1; 
--							--else
--							--nx_st<=st1;
--							--end if;
							
--                     when st1 =>
--                     nx_st <= st2;
             
--                     when st0 =>
--							--if (count=38)then
--                     nx_st <= st1; 
--						--	else
							--nx_st<=st1;
                    -- end if;enable_reg
                  when st1 =>
                                                if (count1=7)then
                                         nx_st <= st0; 
                                                else
                                                nx_st<=st1;
                                              end if;
                                when st0 =>
                                                                                            -- if (count1=7)then
                                                                                      nx_st <= st2; 
                                                                                            -- else
                                                                                           --  nx_st<=st0;
                                                                                         --  end if;               
                     when st2 =>
							if (count1=60)then
                                nx_st <= st3; 
							else
							     nx_st<=st2;
                            end if;
							
					when st3 =>
							if (count1=68)then
                                nx_st <= st1; 
							else
							     nx_st<=st3;
							
                     end if;
--						   
                     end case;
                 end process; 
                 
control_output_generation : process (pr_st)
                               begin
                               case pr_st is
--										  when  st0 =>
--                              cs<='1';
--                                                                                   -- we<='1';
--                                                                                    enable<='0';
--                                                                                    en<='0';
--                                                                                    rw<='0'; 
--                                                                                    enable_count<='1';
--                                                                                    enable_reg<='0';
--                                                                                    write_count<='0';
--                                when st0 => 
--                                cs<='0';
--										 -- we<='0';
--										  enable<='0';
--										  en<='0';
--										  rw<='0';
--										  enable_count<='0';
--										  enable_reg<='0';
--										  write_count<='0';
										  when  st1 =>
                                cs<='1';
										 -- we<='1';
										  enable<='1';
										  en<='0';
										  rw<='0'; 
										  enable_count<='1';
										  enable_reg<='1';
										  write_count<='0';
										   when st0 => 
                                                                         cs<='0';
                                                                                  -- we<='0';
                                                                                   enable<='0';
                                                                                   en<='0';
                                                                                   rw<='0';
                                                                                   enable_count<='0';
                                                                                   enable_reg<='1';
                                                                                   write_count<='0';
				                    when  st2 =>
                                cs<='0';
										--  we<='0';
										  enable<='1';
										  en<='0';
										  rw<='0';
										  enable_count<='0';
										  enable_reg<='0';
										  write_count<='0';
								when  st3 =>
                                cs<='0';
                               -- we<='0';
                                enable<='0';
                                en<='1';
                                rw<='1';
                                enable_count<='0';
                                enable_reg<='0';
                                write_count<='1';
                            end case;
                          end process;
end Behavioral;
