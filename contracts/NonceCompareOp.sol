import "./CompareOp.sol";

/**
 * A CompareOp which works specifically for nonce-based states.
 */
contract NonceCompareOp is CompareOp {
	// The maximum possible value for a 32-byte uint
	uint public constant UINT_MAX = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

	/**
	 * Gets the nonce from a compliant state. The nonce should be the first
	 * element of the state array.
	 *
	 * _state: The state which will be "parsed"
	 *
	 * returns: The nonce associated with the state
	 */
	function getNonce(bytes32[] _state) constant returns (uint) {
		if (_state.length < 1) {
			throw;
		} else {
			return uint(_state[0]);
		}
	}

	/**
	 * Checks if the new state's nonce is greater than the old state's nonce.
	 *
	 * _new: The new state
	 * _old: The old state
	 *
	 * returns: `true` iff the new state's nonce is greater, `false` otherwise
	 */
	function isSuperior(bytes32[] _new, bytes32[] _old) constant returns (bool) {
		return getNonce(_new) > getNonce(_old);
	}

	/**
	 * Checks if the state is final (i.e. UINT_MAX).
	 *
	 * _state: The state being checked
	 *
	 * returns: `true` iff the nonce is UINT_MAX, `false` otherwise
	 */
	function isFinal(bytes32[] _state) constant returns (bool) {
		return getNonce(_state) == UINT_MAX;
	}
}
