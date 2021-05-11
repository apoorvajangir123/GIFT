----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2020 03:09:32 PM
-- Design Name: 
-- Module Name: gift64 - Behavioral
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

entity gift64 is
   Port ( clk : in  STD_LOGIC;
	        reset: in STD_LOGIC;
			  enin,enk: in STD_LOGIC;
	        GIFT_input: in  STD_LOGIC_VECTOR (63 downto 0);
			  key_input:in STD_LOGIC_VECTOR (127 downto 0);
           GIFT_output: out  STD_LOGIC_VECTOR (7 downto 0));
end gift64;

architecture Behavioral of gift64 is
component sbox
  Port ( enable: in STD_LOGIC;
	      sbox_in : in  STD_LOGIC_VECTOR (3 downto 0);
         sbox_out : out  STD_LOGIC_VECTOR (3 downto 0));
end component;
component perm
  Port (enable:in std_logic;
	  perm_in:in std_logic_vector(63 downto 0);
	  perm_out: out std_logic_vector(63 downto 0));
end component;

component lfsr
Port ( clk : in  STD_LOGIC;
           reset,enable : in  STD_LOGIC;
			  ld_rc : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

signal input_8bit,sbox_out : STD_LOGIC_VECTOR (63 downto 0);
signal round_key: STD_LOGIC_VECTOR (127 downto 0);
signal count:integer range 0 to 55 ;
signal p_out:STD_LOGIC_VECTOR (63 downto 0);
signal r0,r1,r2,r3,r4,r5,r6:STD_LOGIC;
signal rc_out:STD_LOGIC_VECTOR (63 downto 0);
signal r_const:STD_LOGIC_VECTOR (5 downto 0);
signal k0,k1:std_logic_vector(15 downto 0);
signal ld_in,en_sbpm,ld_rc,ld_key,add_rk,add_rc: STD_LOGIC;
signal out_reg,out_txt: STD_LOGIC_VECTOR (63 downto 0);
signal rounds_complete,done:STD_LOGIC;


type state is (st0,st1,st2,st3);
signal pr_st,nx_st : state;

begin

load_input: process (clk,reset)
           begin
           if (reset = '1') then
           input_8bit <= (others=>'0');
           elsif (clk'event and clk='1')then
			  if enin='1' then
			  if ld_in='1' then
           input_8bit <= GIFT_input;
			  else
			  input_8bit<=out_reg;
			  end if;
			  else 
			  input_8bit <= (others=>'0');
           end if;
			  end if;
           end process;

key_generation:process(clk,reset)
               begin
               if reset='1' then 
               round_key<=(others=>'0');
               elsif clk'event and clk='1' then
                if enk='1' then
               if ld_key='1' then
               round_key<=key_input;
               else
               round_key<=round_key(17 downto 16) & round_key(31 downto 18)&round_key(11 downto 0) & round_key(15 downto 12)&round_key(127 downto 32);
               end if;
               end if;
               end if;
               end process;			
               --key_out<=round_key;

 
s0: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(3 downto 0),sbox_out=>sbox_out(3 downto 0));
s1: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(7 downto 4),sbox_out=>sbox_out(7 downto 4));
s2: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(11 downto 8),sbox_out=>sbox_out(11 downto 8));
s3: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(15 downto 12),sbox_out=>sbox_out(15 downto 12));
s4: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(19 downto 16),sbox_out=>sbox_out(19 downto 16));
s5: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(23 downto 20),sbox_out=>sbox_out(23 downto 20));
s6: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(27 downto 24),sbox_out=>sbox_out(27 downto 24));
s7: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(31 downto 28),sbox_out=>sbox_out(31 downto 28));
s8: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(35 downto 32),sbox_out=>sbox_out(35 downto 32));
s9: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(39 downto 36),sbox_out=>sbox_out(39 downto 36));
s10: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(43 downto 40),sbox_out=>sbox_out(43 downto 40));
s11: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(47 downto 44),sbox_out=>sbox_out(47 downto 44));
s12: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(51 downto 48),sbox_out=>sbox_out(51 downto 48));
s13: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(55 downto 52),sbox_out=>sbox_out(55 downto 52));
s14: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(59 downto 56),sbox_out=>sbox_out(59 downto 56));
s15: sbox port map (enable=>en_sbpm,sbox_in=>input_8bit(63 downto 60),sbox_out=>sbox_out(63 downto 60));

permutation: perm port map(enable=>en_sbpm,perm_in=>sbox_out,perm_out=>p_out);

round_constant_generation: lfsr port map (clk=>clk,reset=>reset,enable=>enk,ld_rc=>ld_rc,output=>r_const);

add_roundconst:process(add_rc,p_out,r_const)
begin
if add_rc='0' then
r0<='0';
r1<='0';
r2<='0';
r3<='0';
r4<='0';
r5<='0';
r6<='0';
else
r0<=(p_out(63) xor '1');
r1<=(p_out(3) xor r_const(0));
r2<=(p_out(7) xor r_const(1));
r3<=(p_out(11) xor r_const(2));
r4<=(p_out(15) xor r_const(3));
r5<=(p_out(19) xor r_const(4));
r6<=(p_out(23) xor r_const(5));
end if;
end process;

rc_out<=r0&p_out(62 downto 24)&r6&p_out(22 downto 20)&r5&p_out(18 downto 16)&r4&p_out(14 downto 12)&r3&p_out(10 downto 8)&r2&p_out(6 downto 4)&r1&p_out(2 downto 0);


k0<=round_key(15 downto 0); 
k1<=round_key(31 downto 16);
 
roundkey_addition:process(rc_out,k0,k1,add_rk)
                  begin
						if add_rk='0' then
						out_reg<=(others=>'0');
						else
                 for i in 15 downto 0 loop
                 out_reg(4*i+1)<=rc_out(4*i+1) xor k1(i);   
                 out_reg(4*i)<=rc_out(4*i) xor k0(i);
                 end loop;
					  out_reg(63 downto 62)<=rc_out(63 downto 62);
                 out_reg(59 downto 58)<=rc_out(59 downto 58);
                 out_reg(55 downto 54)<=rc_out(55 downto 54);
                 out_reg(51 downto 50)<=rc_out(51 downto 50);
                 out_reg(47 downto 46)<=rc_out(47 downto 46);
                 out_reg(43 downto 42)<=rc_out(43 downto 42);
                 out_reg(39 downto 38)<=rc_out(39 downto 38);
                 out_reg(35 downto 34)<=rc_out(35 downto 34);
                 out_reg(31 downto 30)<=rc_out(31 downto 30);
                 out_reg(27 downto 26)<=rc_out(27 downto 26);
                 out_reg(23 downto 22)<=rc_out(23 downto 22);
                 out_reg(19 downto 18)<=rc_out(19 downto 18);
                 out_reg(15 downto 14)<=rc_out(15 downto 14);
                 out_reg(11 downto 10)<=rc_out(11 downto 10);
                 out_reg(7 downto 6)<=rc_out(7 downto 6);
                 out_reg(3 downto 2)<=rc_out(3 downto 2);
					  
					  end if;
					  end process;
		
bit8_out: process (clk,reset)
           begin
			  if (reset = '1') then
			  out_txt<=(others=>'0');
			  
			  elsif (clk'event and clk='1')then
			    if rounds_complete='0' then
			    out_txt <= out_reg;
             else
             out_txt <= out_txt(55 downto 0)&"00000000";
           end if;
			 end if;
          end process; 
			  
loadouput: process (clk,reset)
           begin
           if (reset = '1') then
           GIFT_output <= (others=>'0');
           elsif (clk'event and clk='1')then
			  if done='1' then
			   GIFT_output <=out_txt(63 downto 56);

			 end if;
			  end if;
           end process; 
			  
counter:process (clk,reset)     
                    begin
                        if (reset='1') then
                        count<=0;
                        elsif (clk='1' and clk'event)  then 
                          if enk='1' then
                        if (count=39) then
                            count<=0;
                            else
                        count<=count + 1;
                    end if;
                end if;end if;
                end process;
					 
state_reg : process (clk,reset)
           begin
           if (reset = '1') then
           pr_st <= st0;
           elsif (clk'event and clk='1')then
           pr_st <= nx_st;
           end if;
           end process;
           
next_state_logic : process (pr_st,count)
                     begin
                     case pr_st is
                     when st0 =>
							if (count=0)then
                  nx_st <= st0; 
							else
							nx_st<=st1;
           end if;
							
							when st1 =>
						--if (count=9)then
                     nx_st <= st2; 
					--	else
					--	nx_st<=st1;
                  --end if;
              
                     when st2 =>
							if (count=30)then
                     nx_st <= st3; 
							else
							nx_st<=st2;
                     end if;
                  
						   when st3 =>
							if (count= 39)then
                     nx_st <= st0; 
							else
							nx_st<=st3;
							end if;
							
--							when st4 =>
--							if (count=45)then
--                     nx_st <= st5; 
--							else
--							nx_st<=st4;
--                     end if;
--							                                      
--							when st5 =>
--							if (count=54)then
--                     nx_st <= st0; 
--							else
--							nx_st<=st5;
--                     end if;
							
                     end case;
                 end process;
                 
control_output_generation : process (pr_st)
                               begin
                               case pr_st is
										 when st0 => 
                               ld_in<='0';
										 --enable_in<='0';
										-- enable_key<='0';
										  en_sbpm <= '0';
										   ld_key<='0';
											 ld_rc<='0';
											rounds_complete<='0';
                                 done<='0';	
                                add_rc<='0';								
                                add_rk<='0';			
											when st1 => 
                               ld_in<='1';						
										 --enable_in<='1';
										-- enable_key<='1';
										  en_sbpm <='0';
										   ld_key<='1';
											 ld_rc<='1';
                              rounds_complete<='0';
                                 done<='0';
                               add_rc<='0';								
                                add_rk<='0';												
--										when  st2 =>
--                              ld_in<='0';
--								 	  --enable_in<='1';
--										  --enable_key<='1';
--										  en_sbpm <= '0';
--										   ld_key<='1';
--											 ld_rc<='0' ;
--                               rounds_complete<='0';
--                               done<='0';	
--                              add_rc<='1';								
--                                add_rk<='1';											 
--									  when  st3 =>
--                                ld_in<='0';
--										  ld_key<='0';
--                                --enable_in<='1';
--										  --enable_key<='1';
--										  en_sbpm <= '0';
--										  ld_rc<='1';
--                              rounds_complete<='0';	
--										done<='0';	
--										add_rc<='0';								
--                                add_rk<='0';	
                             when  st2 =>
                                ld_in<='0';
										  ld_key<='0';
                                --enable_in<='0';
										  --enable_key<='0';
										  en_sbpm <= '1';
										 	 ld_rc<='1';
											 rounds_complete<='0';	
											 done<='0';
                                  add_rc<='1';								
                                add_rk<='1';												 
									  when  st3 =>
                                ld_in<='0';
										  ld_key<='0';
                                --enable_in<='0';
										  --enable_key<='0';
										  en_sbpm <= '0';
											 ld_rc<='0';
											 rounds_complete<='1';	
                                  done<='1';						
                                  add_rc<='0';								
                                add_rk<='0';												 
												 
                            end case;
                          end process;  


end Behavioral;
