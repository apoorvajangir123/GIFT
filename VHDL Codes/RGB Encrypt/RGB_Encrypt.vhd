----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2020 10:11:34 AM
-- Design Name: 
-- Module Name: RGB_Encrypt - Behavioral
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

entity RGB_Encrypt is
   Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
     Key : in  STD_LOGIC_VECTOR (127 downto 0);
          output_red : out  integer range 0 to 255;
           output_green : out  integer range 0 to 255;
            output_blue : out  integer range 0 to 255);
end RGB_Encrypt;

architecture Behavioral of RGB_Encrypt is
component red_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer range 0 to 1048575;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;
component green_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer range 0 to 1048575; -- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;
component blue_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
        --   we : in  STD_LOGIC;
          address : in integer range 0 to 1048575;-- range 0 to 65535;--STD_LOGIC_VECTOR(2 downto 0);
                  data_out : out  integer range 0 to 255);--STD_LOGIC_VECTOR (63 downto 0));
end component;
component out_red_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer range 0 to 1048575;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end component;
component out_green_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer range 0 to 1048575;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end component;
component out_blue_ram
Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
        data_in : in  integer range 0 to 255;
          address : in integer range 0 to 1048575;--STD_LOGIC_VECTOR(2 downto 0);
                   data_out : out  integer range 0 to 255);
end component;

component gift64
Port ( clk : in  STD_LOGIC;
	        reset: in STD_LOGIC;
			  enin,enk: in STD_LOGIC;
	        GIFT_input: in  STD_LOGIC_VECTOR (63 downto 0);
			  key_input:in STD_LOGIC_VECTOR (127 downto 0);
           GIFT_output: out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal cs,enable,en,rw,enable_count,enable_i,write_count:std_logic;
signal in_regR,in_regG,in_regB:integer range 0 to 255;--std_logic_vector(63 downto 0);
--signal round_key:std_logic_vector(127 downto 0);
signal count: integer;-- range 0 to 65535;
signal count1,count2: integer;
--signal address1: STD_LOGIC_VECTOR(2 downto 0);
signal input_red: STD_LOGIC_VECTOR(63 downto 0);
signal input_green: STD_LOGIC_VECTOR(63 downto 0);
signal input_blue: STD_LOGIC_VECTOR(63 downto 0);

--signal key1: STD_LOGIC_VECTOR(127 downto 0);
signal gift_outR,gift_outG,gift_outB: STD_LOGIC_VECTOR(7 downto 0);
signal GIFT_inputR,GIFT_inputG,GIFT_inputB:STD_LOGIC_VECTOR(7 downto 0);
signal out_intR,out_intG,out_intB:integer range 0 to 255;
type state is (st0,st1,st2,st3);
signal pr_st,nx_st : state;

begin
load_red:process(reset,clk)
           begin
           if reset='1' then
         input_red<=(others=>'0');
          elsif clk'event and clk='1' then
           if enable_i='1' then
             --if ld_in='1' then
             input_red<=input_red(55 downto 0) & GIFT_inputR;
			-- else
			-- input_8bit<=out_reg;
           --  end if;
          -- else
         --  input_8bit<=(others=>'0');
           end if;
         end if;
           end process;
load_green:process(reset,clk)
                      begin
                      if reset='1' then
                    input_green<=(others=>'0');
                     elsif clk'event and clk='1' then
                      if enable_i='1' then
                        --if ld_in='1' then
                        input_green<=input_green(55 downto 0) & GIFT_inputG;
                       -- else
                       -- input_8bit<=out_reg;
                      --  end if;
                     -- else
                    --  input_8bit<=(others=>'0');
                      end if;
                    end if;
                      end process;
load_blue:process(reset,clk)
                                 begin
                                 if reset='1' then
                               input_blue<=(others=>'0');
                                elsif clk'event and clk='1' then
                                 if enable_i='1' then
                                   --if ld_in='1' then
                                   input_blue<=input_blue(55 downto 0) & GIFT_inputB;
                                  -- else
                                  -- input_8bit<=out_reg;
                                 --  end if;
                                -- else
                               --  input_8bit<=(others=>'0');
                                 end if;
                               end if;
                                 end process;
 -- Key<="0x2b7e151628aed2a6abf7158809cf4f3c";        
g1:red_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_regR );
g2:green_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_regG );
g3:blue_ram port map (clk=>clk,cs=>cs,address=>count ,data_out=>in_regB );

--g2:round_key_ram port map(clk=>clk,cs=>cs,we=>we ,address=>address1 ,data_out=>round_key );
g4:gift64 port map (clk => clk,reset => reset,enin=>enable,enk=>enable,GIFT_input => input_red,key_input => Key,GIFT_output => gift_outR);
g5:gift64 port map (clk => clk,reset => reset,enin=>enable,enk=>enable,GIFT_input => input_green,key_input => Key,GIFT_output => gift_outG);
g6:gift64 port map (clk => clk,reset => reset,enin=>enable,enk=>enable,GIFT_input => input_blue,key_input => Key,GIFT_output => gift_outB);

g7:out_red_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_intR, data_out=>output_red);
g8:out_green_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_intG, data_out=>output_green);
g9:out_blue_ram port map (clk=>clk,cs=>en,we=>rw ,address=>count2 ,data_in=>out_intB, data_out=>output_blue);

GIFT_inputR<=std_logic_vector(to_unsigned(in_regR, 8));
GIFT_inputG<=std_logic_vector(to_unsigned(in_regG, 8));
GIFT_inputB<=std_logic_vector(to_unsigned(in_regB, 8));

out_intR<=to_integer(unsigned(gift_outR));
out_intG<=to_integer(unsigned(gift_outG));
out_intB<=to_integer(unsigned(gift_outB));
counter:process (clk,reset)     
                    begin
                        if (reset='1') then
                        count<=0;
                        elsif (clk='1' and clk'event)  then
                        								
                        if enable_count='1' then
                        if count1<9 then
								--(count=38) then
                            --count<=0;
                           -- else
                        count<=count + 1;
                        end if;
                         if count=1048575 then
                                                       --(count=38) then
                                                   --count<=0;
                                                  -- else
                                               count<=0;
                                               end if;
                       -- elsif count=65535 then
                       -- count<=0;
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
                        if (count1=49) then
                            count1<=0;
                            else
                        count1<=count1 + 1;
                    end if;
                end if;
                end process;			  
state_reg : process (clk,reset)
           begin
           if (reset = '1') then
           pr_st <= st0;
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
             
                     when st0 =>
							--if (count=38)then
                     nx_st <= st1; 
						--	else
							--nx_st<=st1;
                    -- end if;enable_reg
                  when st1 =>
                                                if (count1=9)then
                                         nx_st <= st2; 
                                                else
                                                nx_st<=st1;
                                                end if;
                     when st2 =>
							if (count1=41)then
                     nx_st <= st3; 
							else
							nx_st<=st2;
                     end if;
							
							when st3 =>
							if (count1=49)then
                     nx_st <= st0; 
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
--                                cs<='0';
--										  we<='0';
--										  enable<='0';
--										  en<='0';
--										  rw<='0';
--										  enable_count<='0';
                                when st0 => 
                                cs<='0';
										 -- we<='0';
										  enable<='0';
										  en<='0';
										  rw<='0';
										  enable_count<='0';
										  enable_i<='0';
										  write_count<='0';
										  when  st1 =>
                                cs<='1';
										 -- we<='1';
										  enable<='0';
										  en<='0';
										  rw<='0'; 
										  enable_count<='1';
										  enable_i<='1';
										  write_count<='0';
				                    when  st2 =>
                                cs<='0';
										--  we<='0';
										  enable<='1';
										  en<='0';
										  rw<='0';
										  enable_count<='0';
										  enable_i<='0';
										  write_count<='0';
								when  st3 =>
                                cs<='0';
                               -- we<='0';
                                enable<='1';
                                en<='1';
                                rw<='1';
                                enable_count<='0';
                                enable_i<='0';
                                write_count<='1';
                            end case;
                          end process;

end Behavioral;
