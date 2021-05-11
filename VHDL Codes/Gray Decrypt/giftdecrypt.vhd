----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2020 09:22:40 AM
-- Design Name: 
-- Module Name: giftdecrypt - Behavioral
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

entity giftdecrypt is
Port ( clk : in  STD_LOGIC;
           reset,enable_decrypt : in  STD_LOGIC;
			  decrypt_in : in  STD_LOGIC_VECTOR (63 downto 0);
           decrypt_out : out  STD_LOGIC_VECTOR (7 downto 0);
           decrypt_key : in  STD_LOGIC_VECTOR (127 downto 0));
end giftdecrypt;
architecture Behavioral of giftdecrypt is
component key_ram
Port ( clk : in  STD_LOGIC; 
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (127 downto 0);
           address : in  integer range 0 to 28 ;
           data_out : out  STD_LOGIC_VECTOR (127 downto 0));
end component;

component rc_ram
 Port ( clk : in  STD_LOGIC; 
           cs : in  STD_LOGIC;
           we : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (5 downto 0);
           address : in  integer range 0 to 28 ;
           data_out : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

component lfsr
Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ld_rc : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (5 downto 0)); 
end component;

component key_gen
Port ( clk,reset,ld_key,en_key: in std_logic;
			input : in  STD_LOGIC_VECTOR (127 downto 0);
           output : out  STD_LOGIC_VECTOR (127 downto 0));
end component;


component inverse_perm
Port ( enable : in  STD_LOGIC;
           p_input : in  STD_LOGIC_vector(63 downto 0);
           p_output : out  STD_LOGIC_vector(63 downto 0));
 
end component;

component inverse_sbox
 Port ( enable : in  STD_LOGIC;
           sbox_in : in  STD_LOGIC_VECTOR (3 downto 0);
           sbox_out : out  STD_LOGIC_VECTOR (3 downto 0));
end component;
signal ld_reg: STD_LOGIC;
signal in_reg: STD_LOGIC_VECTOR (63 downto 0);
signal p_out: STD_LOGIC_VECTOR (63 downto 0);
signal address:integer range 0 to 28;
signal key_out:STD_LOGIC_VECTOR (127 downto 0);
signal round_key:STD_LOGIC_VECTOR (127 downto 0);
signal out_reg: STD_LOGIC_VECTOR (63 downto 0);
signal output,out_txt: STD_LOGIC_VECTOR (63 downto 0);
signal rc_out:STD_LOGIC_VECTOR (5 downto 0);
signal perm_in: STD_LOGIC_VECTOR (63 downto 0);
signal r0,r1,r2,r3,r4,r5,r6:STD_LOGIC;
signal k0,k1:std_logic_vector(15 downto 0);
signal round_constant:STD_LOGIC_VECTOR (5 downto 0);
signal en_sbpm,upcount,ld_key,ld_rc,rw,en_ram,en_count,en_keygen,rounds_complete,done: STD_LOGIC;
type state is (st0,st1,st2,st3,st4,st5);
signal pr_st,nx_st : state;
signal count_2:integer range 0 to 70;
--signal count_1: integer range 0 to 27;

begin
loadinput: process (clk,reset)
           begin
           if (reset = '1') then
           in_reg <= (others=>'0');
           elsif (clk'event and clk='1')then
           if enable_decrypt='1' then
			  if ld_reg='1' then
           in_reg <= decrypt_in;
			  else
			  in_reg<=output;
			  end if;
			  end if;
           end if;
           end process;

counter_1:process(clk,reset)
          variable count_1: integer range 0 to 27;
          begin
           if (reset='1') then
            count_1:=0;
           elsif (clk='1' and clk'event)  then 
            if (en_count='1') then
             if (upcount='1') then
              if count_1=27 then 
	            count_1:=0;
	            else
              count_1:= count_1+1;
              end if;
             else
              if count_1=0 then 
	            count_1:=27;
	            else
              count_1:=count_1-1;
             end if;
            end if;
          else
            count_1:=0;
           end if;
          end if;
			address<=count_1;
         end process;



g0:key_gen port map (clk=>clk,reset=>reset,ld_key=>ld_key,en_key=>en_keygen,input=>decrypt_key,output=>key_out);

g2:key_ram port map (clk=>clk,cs=>en_ram,we=>rw,data_in=>key_out,address=>address,data_out=>round_key);

c0:lfsr port map (clk=>clk,reset=>reset,ld_rc=>ld_rc,output=>rc_out);
c1:rc_ram port map (clk=>clk,cs=>en_ram,we=>rw,data_in=>rc_out,address=>address,data_out=>round_constant);

k0<=round_key(15 downto 0);  
k1<=round_key(31 downto 16);
 
roundkey_addition:process(rc_out,k0,k1)
                  begin
                 for i in 15 downto 0 loop
                 out_reg(4*i+1)<=in_reg(4*i+1) xor k1(i);   
                 out_reg(4*i)<=in_reg(4*i) xor k0(i);
                 end loop;
					  out_reg(63 downto 62)<=in_reg(63 downto 62);
                 out_reg(59 downto 58)<=in_reg(59 downto 58);
                 out_reg(55 downto 54)<=in_reg(55 downto 54);
                 out_reg(51 downto 50)<=in_reg(51 downto 50);
                 out_reg(47 downto 46)<=in_reg(47 downto 46);
                 out_reg(43 downto 42)<=in_reg(43 downto 42);
                 out_reg(39 downto 38)<=in_reg(39 downto 38);
                 out_reg(35 downto 34)<=in_reg(35 downto 34);
                 out_reg(31 downto 30)<=in_reg(31 downto 30);
                 out_reg(27 downto 26)<=in_reg(27 downto 26);
                 out_reg(23 downto 22)<=in_reg(23 downto 22);
                 out_reg(19 downto 18)<=in_reg(19 downto 18);
                 out_reg(15 downto 14)<=in_reg(15 downto 14);
                 out_reg(11 downto 10)<=in_reg(11 downto 10);
                 out_reg(7 downto 6)<=in_reg(7 downto 6);
                 out_reg(3 downto 2)<=in_reg(3 downto 2);
                 end process;
					  
					  
r0<=(out_reg(63) xor '1');
r1<=(out_reg(3) xor round_constant(0));
r2<=(out_reg(7) xor round_constant(1));
r3<=(out_reg(11) xor round_constant(2));
r4<=(out_reg(15) xor round_constant(3));
r5<=(out_reg(19) xor round_constant(4));
r6<=(out_reg(23) xor round_constant(5));

perm_in<=r0&out_reg(62 downto 24)&r6&out_reg(22 downto 20)&r5&out_reg(18 downto 16)&r4&out_reg(14 downto 12)&r3&out_reg(10 downto 8)&r2&out_reg(6 downto 4)&r1&out_reg(2 downto 0);

permutation: inverse_perm  port map(enable=>en_sbpm,p_input=>perm_in,p_output=>p_out);

s0: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(3 downto 0),sbox_out=>output(3 downto 0));
s1: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(7 downto 4),sbox_out=>output(7 downto 4));
s2: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(11 downto 8),sbox_out=>output(11 downto 8));
s3: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(15 downto 12),sbox_out=>output(15 downto 12));
s4: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(19 downto 16),sbox_out=>output(19 downto 16));
s5: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(23 downto 20),sbox_out=>output(23 downto 20));
s6: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(27 downto 24),sbox_out=>output(27 downto 24));
s7: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(31 downto 28),sbox_out=>output(31 downto 28));
s8: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(35 downto 32),sbox_out=>output(35 downto 32));
s9: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(39 downto 36),sbox_out=>output(39 downto 36));
s10: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(43 downto 40),sbox_out=>output(43 downto 40));
s11: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(47 downto 44),sbox_out=>output(47 downto 44));
s12: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(51 downto 48),sbox_out=>output(51 downto 48));
s13: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(55 downto 52),sbox_out=>output(55 downto 52));
s14: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(59 downto 56),sbox_out=>output(59 downto 56));
s15: inverse_sbox port map (enable=>en_sbpm,sbox_in=>p_out(63 downto 60),sbox_out=>output(63 downto 60));
--decrypt_out<=output;
bit8_out: process (clk,reset)
           begin
			  if (reset = '1') then
			  out_txt<=(others=>'0');
			  
			  elsif (clk'event and clk='1')then
			    if rounds_complete='0' then
			    out_txt <= output;
             else
             out_txt <= out_txt(55 downto 0)&"00000000";
           end if;
			 end if;
          end process; 
			  
loadouput: process (clk,reset)
           begin
           if (reset = '1') then
           decrypt_out <= (others=>'0');
           elsif (clk'event and clk='1')then
			  if done='1' then
			   decrypt_out <=out_txt(63 downto 56);

			 end if;
			  end if;
           end process; 
counter_2:process (clk,reset)     
                    begin
                        if (reset='1') then
                        count_2<=0;
                        elsif (clk='1' and clk'event)  then 
                        if (count_2=68) then
                            count_2<=0;
                           else
                        count_2<=count_2 + 1;
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
next_state_logic : process (pr_st,count_2)
                     begin
                     case pr_st is
							
                    when st0 =>
                     nx_st <= st1;
                     
                     when st1 =>
                     nx_st <= st2;
						
                     when st2 =>
							if (count_2=29)then
                     nx_st <= st3; 
							else
							nx_st<=st2; 
                     end if;
                  
						   when st3 =>
							 if (count_2=31)then 
                     nx_st <= st4; 
							else
							nx_st<=st3;
							end if;
							
							when st4 =>
							if (count_2=59)then 
                     nx_st <= st5; 
							else
							nx_st<=st4;
							end if;
							when st5 => 
							if (count_2=68)then
                     nx_st <= st0; 
							else
							nx_st<=st5;
							end if;
							
                     end case;
                 end process; 
					  
control_output_generation : process (pr_st)
                               begin
                               case pr_st is
                                 
                                     when st0 =>
									     ld_reg<='0';
                                upcount<='0';
										  rw<='0';
										  ld_key<='0';
										  ld_rc<='0';
										  en_sbpm <= '0';
                                en_ram<='0';
										  en_count<='0';
									     en_keygen<='0';
									     rounds_complete<='0';
									     done<='0';
                             when st1 =>
									     ld_reg<='0';
                                upcount<='0';
										  rw<='1';
										  ld_key<='1';
										  ld_rc<='1';
										  en_sbpm <= '0';
                                en_ram<='1';
										  en_count<='0';
									     en_keygen<='1';
									     									     rounds_complete<='0';
                                         done<='0';
									 when st2 =>
									     ld_reg<='1';
                                upcount<='1';
										  rw<='1';
										  ld_key<='0';
										  ld_rc<='1';
										  en_sbpm <= '0';
                                en_ram<='1';
										  en_count<='1';	
										  en_keygen<='1';
									     rounds_complete<='0';
                                          done<='0'; 
									  when  st3 =>
									     ld_reg<='1';
                                upcount<='0';
										  rw<='0';
										  ld_key<='0';
										  ld_rc<='0';
										  en_sbpm <= '0';
                                en_ram<='0';
										  en_count<='1';
										  en_keygen<='0';
									     rounds_complete<='0';
                                          done<='0';                            
                             when  st4 =>
									     ld_reg<='0';
                                upcount<='0';
										  rw<='0';
										  ld_key<='0';
										  ld_rc<='0';
										  en_sbpm <= '1';
                                en_ram<='1';
										  en_count<='1';
										  en_keygen<='0';
									     rounds_complete<='0';
                                          done<='0';
                                             when  st5 =>
                                                                                ld_reg<='0';
                                                                       upcount<='0';
                                                                                 rw<='0';
                                                                                 ld_key<='0';
                                                                                 ld_rc<='0';
                                                                                 en_sbpm <= '0';
                                                                       en_ram<='1';
                                                                                 en_count<='1';
                                                                                 en_keygen<='0';
                                                                                rounds_complete<='1';
                                                                                 done<='1';
                            end case;
                          end process;  

end Behavioral;