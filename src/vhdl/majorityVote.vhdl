library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library work;
use work.rf_types.all;



--------------------------------------------------------------------------------
--
-- Occurrence counter for n-Bit class labels.
--
--------------------------------------------------------------------------------
--
-- For each given class label (=reference), loops over all class label inputs
--  and compares them with the referenced label. Increases the referenced class'
--  counter on match, and immediately compares the current match counter to
--  the currently stored match count. Stores the referenced label and its match
--  counter if its match count exceeds whichever was previously stored.
--
-- Outputs a completion flag once calculation has finished. The selected label
--  may change during calculation and should NOT be read before the completion
--  flag has been set.
--
-- Once the ready-flag was set, the returned class label is the label whose
--  number of occurences within given input labels is at least equal to or
--  greater than the number of occurences of all other class labels.
-- Therefore, if an input contains two or more class labels which appear more
--  often than other class labels but share the same number of occurrences
--  within the input, the class label closest to index 0 with those exact number
--  of occurences will be returned.
--
-- Ignores empty class label inputs (i.e. values of type 0x00..00).
--
--------------------------------------------------------------------------------
--
-- This component requires a reset over at least one (1) clock tick before
--  usage. Once reset, its inputs can be set and computation may be initiated.
-- Computation generally completes after  (n^2)+1  full (!) clock cycles, where
--  variable  n  corresponds to the number of classes, i.e.
--
--     n = 2**CLASS_COUNT_LOG_2
--
-- Given class label is only valid while the output-ready flag is raised.
-- Ticking this component after completion without prior reset has no effect
--  on either its output or its ready-flag. Class label inputs must remain
--  stable until computation has finished, or else the result is undefined.
--
--------------------------------------------------------------------------------
--
-- @generic CLASS_COUNT_LOG_2 - Base-2 log of the number of available classes.
-- @generic CLASS_LABEL_BITS  - Number of bits a single class label has.
--
-- @in in_clock   - Clock input used to update the counter and queue components.
-- @in in_labels  - Class label values from which to find the most prevalent.
-- @in in_reset   - Synchronously resets the current calculation and outputs.
--
-- @out out_ready - Outputs '1' once calculation has finished.
-- @out out_class - Selected class value; only valid while out_ready is '1'.
--
-- @complexity    2^(m+1) * (n + m) + 81m + 20n + 32
--					(n = input_bits; m = select_bits)
--
--------------------------------------------------------------------------------

entity MajorityVote is
    generic(
        CLASS_COUNT_LOG_2 : positive;
        CLASS_LABEL_BITS  : positive
    );
    port(
        in_clock  : in  std_logic;
        in_labels : in  std_logic_matrix(0 to (2**CLASS_COUNT_LOG_2)-1)(CLASS_LABEL_BITS-1 downto 0);
        in_reset  : in  std_logic;
        out_ready : out std_logic;
        out_class : out std_logic_vector(CLASS_LABEL_BITS-1 downto 0)
    );
end MajorityVote;



--------------------------------------------------------------------------------
-- Architecture implementation.
--------------------------------------------------------------------------------

architecture arch of MajorityVote is
    
    -----------------------------
    --  Component declaration  --
    -----------------------------
    
    component Comparator_n_Bit is
        generic(
            INPUT_BITS : positive
        );
        port(
            in_threshold : in  std_logic_vector(INPUT_BITS-1 downto 0);
            in_value     : in  std_logic_vector(INPUT_BITS-1 downto 0);
            out_equal    : out std_logic;
            out_greater  : out std_logic;
            out_less     : out std_logic
        );
    end component;
    
    component Counter is
        generic(
            OUTPUT_BITS : positive
        );
        port(
            in_clock  : in  std_logic;
			in_enable : in  std_logic;
            in_reset  : in  std_logic;
            out_wrap  : out std_logic;
            out_value : out std_logic_vector(OUTPUT_BITS-1 downto 0)
        );
    end component;
	
	component D_Flip_Flop is
		port(
			in_resetNot : in  std_logic;
			in_value    : in  std_logic;
			in_write    : in  std_logic;
			out_value   : out std_logic
		);
	end component;
    
    component Mux_n_Bit is
        generic(
            INPUT_BITS  : positive;
            SELECT_BITS : positive
        );
        port(
            in_select  : in  std_logic_vector(SELECT_BITS-1 downto 0);
            in_values  : in  std_logic_matrix((2**SELECT_BITS)-1 downto 0)(INPUT_BITS-1 downto 0);
            out_value  : out std_logic_vector(INPUT_BITS-1 downto 0)
        );
    end component;
    
    component Pipo is
        generic(
            INPUT_BITS : positive
        );
        port(
            in_clock  : in  std_logic;
            in_reset  : in  std_logic;
            in_value  : in  std_logic_vector(INPUT_BITS-1 downto 0);
            out_value : out std_logic_vector(INPUT_BITS-1 downto 0)
        );
    end component;
    
    
    --------------------------
    --  Signal declaration  --
    --------------------------
	
	-- Various boolean flags
	signal computationComplete            : std_logic;
	signal currentLabelHasMoreMatches     : std_logic;
	signal isCurrentLabelMatching         : std_logic;
	signal updateStoredLabelValue         : std_logic;
	signal updateStoredLabelValue_compute : std_logic;
	signal updateStoredLabelValue_force   : std_logic;
	
	-- Currently-selected label
	signal currentLabel                   : std_logic_vector(CLASS_LABEL_BITS-1 downto 0);
	signal currentLabelIndex              : std_logic_vector(CLASS_COUNT_LOG_2-1 downto 0);
	signal currentLabelIndex_hasWrapped   : std_logic;
	
	-- Counter for reference-value-matches
	signal currentLabelMatches            : std_logic_vector(CLASS_COUNT_LOG_2-1 downto 0);
	signal resetCurrentLabelMatches       : std_logic;
	signal storedLabelMatches             : std_logic_vector(CLASS_COUNT_LOG_2-1 downto 0);
	
	-- Reference label
	signal referenceLabel                 : std_logic_vector(CLASS_LABEL_BITS-1 downto 0);
	signal referenceLabel_isNotEmpty      : std_logic_vector(CLASS_LABEL_BITS-1 downto 0);
	signal referenceLabelIndex            : std_logic_vector(CLASS_COUNT_LOG_2-1 downto 0);
	signal referenceLabelIndex_raw        : std_logic_vector((2*CLASS_COUNT_LOG_2)-1 downto 0);
	signal referenceLabelIndex_hasWrapped : std_logic;

begin

    ----------------------------
    --  Component generation  --
    ----------------------------

    -- Comparators
    comparator_is_matching : Comparator_n_Bit
    generic map(
        INPUT_BITS => CLASS_LABEL_BITS
    )
    port map(
        in_threshold => referenceLabel,
        in_value     => currentLabel,
        out_equal    => isCurrentLabelMatching
    );
	
	comparator_match_count : Comparator_n_Bit
    generic map(
        INPUT_BITS => CLASS_COUNT_LOG_2
    )
    port map(
        in_threshold => storedLabelMatches,
        in_value     => currentLabelMatches,
        out_greater  => currentLabelHasMoreMatches
    );

    -- Counters
    counter_current_label_index : Counter
    generic map(
        OUTPUT_BITS => CLASS_COUNT_LOG_2
    )
    port map(
        in_clock  => in_clock,
		in_enable => (NOT computationComplete),
        in_reset  => in_reset,
        out_wrap  => currentLabelIndex_hasWrapped,
        out_value => currentLabelIndex
    );
	
	counter_label_matches : Counter
	generic map(
	    OUTPUT_BITS => CLASS_COUNT_LOG_2
	)
	port map(
        in_clock  => NOT in_clock,
		in_enable => isCurrentLabelMatching,
        in_reset  => resetCurrentLabelMatches,
        out_value => currentLabelMatches
	);
    
    counter_reference_label_index : Counter
    generic map(
        OUTPUT_BITS => 2 * CLASS_COUNT_LOG_2
    )
    port map(
        in_clock  => in_clock,
		in_enable => (NOT computationComplete),
        in_reset  => in_reset,
		out_wrap  => referenceLabelIndex_hasWrapped,
        out_value => referenceLabelIndex_raw
    );
	
	-- D-Flip-Flops
	dff_computation_done : D_Flip_Flop
	port map(
		in_resetNot => NOT in_reset,
		in_value    => '1',
		in_write    => in_clock AND (referenceLabelIndex_hasWrapped OR in_reset),
		out_value   => computationComplete
	);
    
    -- Multiplexers
    mux_label_reference : Mux_n_bit
    generic map(
        INPUT_BITS  => CLASS_LABEL_BITS,
        SELECT_BITS => CLASS_COUNT_LOG_2
    )
    port map(
        in_select => referenceLabelIndex,
        in_values => in_labels,
        out_value => referenceLabel
    );
    
    mux_label_value : Mux_n_bit
    generic map(
        INPUT_BITS  => CLASS_LABEL_BITS,
        SELECT_BITS => CLASS_COUNT_LOG_2
    )
    port map(
        in_select => currentLabelIndex,
        in_values => in_labels,
        out_value => currentLabel
    );
    
    -- PIPO registers
    pipo_label_reference_matches : Pipo
    generic map(
        INPUT_BITS => CLASS_COUNT_LOG_2
    )
    port map(
        in_clock  => updateStoredLabelValue,
        in_reset  => in_reset,
        in_value  => currentLabelMatches,
        out_value => storedLabelMatches
    );
    
    pipo_label_reference : Pipo
    generic map(
        INPUT_BITS => CLASS_LABEL_BITS
    )
    port map(
        in_clock  => updateStoredLabelValue,
        in_reset  => in_reset,
        in_value  => referenceLabel,
        out_value => out_class
    );
    
    
    ------------------------
    --  Generation loops  --
    ------------------------
	
	genReferenceLabelVerifier:
	for i in CLASS_LABEL_BITS-1 downto 0 generate
	
		genReferenceLabelVerifier_init:
		if (i = CLASS_LABEL_BITS-1) generate
			referenceLabel_isNotEmpty(i) <= referenceLabel(i);
		end generate;
		
		genReferenceLabelVerifier_loop:
		if (i < CLASS_LABEL_BITS-1) generate
			referenceLabel_isNotEmpty(i) <= referenceLabel(i) OR referenceLabel_isNotEmpty(i + 1);
		end generate;
	
	end generate;
    
    
    --------------------------
    --  Connect components  --
    --------------------------
	
	referenceLabelIndex      <= referenceLabelIndex_raw((2*CLASS_COUNT_LOG_2)-1 downto CLASS_COUNT_LOG_2);
	resetCurrentLabelMatches <= (in_reset OR currentLabelIndex_hasWrapped);
	updateStoredLabelValue   <= (
									(NOT in_clock) AND
									(NOT computationComplete) AND
									referenceLabel_isNotEmpty(0) AND
									currentLabelHasMoreMatches
								)
					            OR
								(
									in_clock AND
									in_reset
								);
	
	out_ready <= computationComplete;

end arch;

