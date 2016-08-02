/**
 * An abstract contract which verifies states for certain properties.
 */
contract CompareOp {
	/**
	 * Checks if a newer state is strictly superior to the old one.
	 *
	 * _new: The new state to be compared
	 * _old: The old state to be compared
	 *
	 * returns: `true` iff the newer state is strictly superior, `false`
	 *   otherwise
	 */
	function isSuperior(bytes32[] _new, bytes32[] _old) constant returns (bool);

	/**
	 * Checks if a state can be considered final.
	 *
	 * _state: The state to be checked
	 *
	 * returns: `true` iff the state can be consider final, `false` otherwise
	 */
	function isFinal(bytes32[] _state) constant returns (bool);
}
