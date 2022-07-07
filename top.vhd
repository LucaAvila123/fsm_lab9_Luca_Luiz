library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
           clk : in STD_LOGIC;
           led : out std_logic_vector(3 downto 0);
           sseg: out std_logic_vector(7 downto 0);
           an  : out std_logic_vector(7 downto 0)
          );
end top;


architecture arch_top of top is

constant N : integer := 99999999; 
signal enable : std_logic;
signal divide_clk : integer range 0 to N;
signal counter:  std_logic_vector(2 downto 0);

begin

    fsm_7seg : entity work.led_mux8(arch)
          port map(
                    clk      => clk,
                    reset    => '0',
                    in0     =>  "11000000",
                    in1     =>  "11111001",
                    in2     =>  "10100100",
                    in3     =>  "10110000",
                    in4     =>  "10011001",
                    in5     =>  "10010010",
                    in6     =>  "10000010",
                    in7     =>  "11111000",
                    an => an,
                    sseg => sseg,
                    select_new => counter
          );

    bin_counter_unit_0 : entity work.free_run_bin_counter
          port map(
                    clk      => clk,
                    reset    => '0',
                    enable   => enable,
                    max_tick => led(3),
                    q        => counter
          );
        
     enable <= '1' when divide_clk = N else '0';
     
     PROCESS (clk)
        BEGIN
            IF (clk'EVENT AND clk='1') THEN
                divide_clk <= divide_clk+1;
                IF divide_clk = N THEN
                    divide_clk <= 0;
                END IF;
            END IF;
     END PROCESS;
     
     led(2 downto 0) <= counter;
     
end arch_top;
