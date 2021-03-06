
-- This code implements a parameterizable subtractor followed by multiplier which will be packed into DSP Block. Widths must be less than or equal to what is supported by the DSP block else exta logic will be inferred
-- Operation : (a-b) * c
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity presubmult is
  generic (
           AWIDTH : natural := 12;  -- Width of A input
           BWIDTH : natural := 16;  -- Width of B input
           CWIDTH : natural := 17   -- Width of C input
          );
  port (
        clk  : in  std_logic;     -- Clock
        ain  : in  std_logic_vector(AWIDTH-1 downto 0); -- A input
        bin  : in  std_logic_vector(BWIDTH-1 downto 0); -- B input
        cin  : in  std_logic_vector(CWIDTH-1 downto 0); -- C input
        pout : out std_logic_vector(BWIDTH+CWIDTH downto 0) -- Output
       );
       
attribute USE_DSP : string;
attribute USE_DSP of presubmult : entity is "YES";       
end presubmult;

architecture rtl of presubmult is

signal a       : signed(AWIDTH-1 downto 0);
signal b       : signed(BWIDTH-1 downto 0);
signal c       : signed(CWIDTH-1 downto 0);
signal add     : signed(BWIDTH downto 0);
signal mult, p : signed(BWIDTH+CWIDTH downto 0);

begin

process(clk)
 begin
  if rising_edge(clk) then
     a    <= signed(ain);
     b    <= signed(bin);
     c    <= signed(cin);
     add  <= resize(a, BWIDTH+1) - resize(b, BWIDTH+1);
     mult <= add * c;
     p    <= mult;
  end if;
end process;

--
-- Type conversion for output
--
pout <= std_logic_vector(p);

end rtl;	