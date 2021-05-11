----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2020 05:45:09 PM
-- Design Name: 
-- Module Name: RGB_Decrypt - Behavioral
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

entity RGB_Decrypt is
    Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
     Key : in  STD_LOGIC_VECTOR (127 downto 0);
          output_red : out  integer range 0 to 255;
          output_green : out  integer range 0 to 255;output_blue : out  integer range 0 to 255);
end RGB_Decrypt;

architecture Behavioral of RGB_Decrypt is
component red_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;
component green_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;
component blue_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;
component out_red_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end component;
component out_green_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end component;
component out_blue_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
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
signal in_R,in_G,in_B:integer range 0 to 255;--std_logic_vector(63 downto 0);
--signal round_key:std_logic_vector(127 downto 0);
signal count: integer range 0 to 65535;
signal count1,count2: integer range 0 to 65535;
--signal address1: STD_LOGIC_VECTOR(2 downto 0);
signal input_B,input_R,input_G: STD_LOGIC_VECTOR(63 downto 0);
signal gift_outR,gift_outG,gift_outB: STD_LOGIC_VECTOR(7 downto 0);
signal GIFT_R,GIFT_G,GIFT_B:STD_LOGIC_VECTOR(7 downto 0);
signal out_intR,out_intG,out_intB:integer range 0 to 255;
type state is (st1,st0,st2,st3);
signal pr_st,nx_st : state;

begin
load_inputR:process(reset,clk)
           begin
           if reset='1' then
           input_R<=(others=>'0');
           elsif clk'event and clk='1' then
           if enable_reg='1' then
           if count1>0 then
             input_R<=input_R(55 downto 0)& GIFT_R;
			-- else
			-- input_8bit<=out_reg;
             end if;
          -- else
         --  input_8bit<=(others=>'0');
           end if;
           end if;
           end process;
           load_inputG:process(reset,clk)
                      begin
                      if reset='1' then
                      input_G<=(others=>'0');
                      elsif clk'event and clk='1' then
                      if enable_reg='1' then
                      if count1>0 then
                        input_G<=input_G(55 downto 0)& GIFT_G;
                       -- else
                       -- input_8bit<=out_reg;
                        end if;
                     -- else
                    --  input_8bit<=(others=>'0');
                      end if;
                      end if;
                      end process;
                      load_inputB:process(reset,clk)
                                 begin
                                 if reset='1' then
                                 input_B<=(others=>'0');
                                 elsif clk'event and clk='1' then
                                 if enable_reg='1' then
                                 if count1>0 then
                                   input_B<=input_B(55 downto 0)& GIFT_B;
                                  -- else
                                  -- input_8bit<=out_reg;
                                   end if;
                                -- else
                               --  input_8bit<=(others=>'0');
                                 end if;
                                 end if;
                                 end process;
           
g1:red_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_R );
g2:green_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_G );
g3:blue_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_B );
--g2:round_key_ram port map(clk=>clk,cs=>cs,we=>we ,address=>address1 ,data_out=>round_key );
g4:giftdecrypt port map (clk => clk,reset => reset,enable_decrypt=>enable,decrypt_in => input_R,decrypt_key => Key,decrypt_out => gift_outR);
g5:giftdecrypt port map (clk => clk,reset => reset,enable_decrypt=>enable,decrypt_in => input_G,decrypt_key => Key,decrypt_out => gift_outG);
g6:giftdecrypt port map (clk => clk,reset => reset,enable_decrypt=>enable,decrypt_in => input_B,decrypt_key => Key,decrypt_out => gift_outB);

g7:out_red_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_intR, data_out=>output_red);
g8:out_green_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_intG, data_out=>output_green);
g9:out_blue_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_intB, data_out=>output_blue);

GIFT_R<=std_logic_vector(to_unsigned(in_R, 8));
GIFT_G<=std_logic_vector(to_unsigned(in_G, 8));
GIFT_B<=std_logic_vector(to_unsigned(in_B, 8));

out_intR<=to_integer(unsigned(gift_outR));
out_intG<=to_integer(unsigned(gift_outG));
out_intB<=to_integer(unsigned(gift_outB));

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
