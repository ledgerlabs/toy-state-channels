import "CompareOp.sol";

contract NonceCompareOp is CompareOp {
	uint public constant UINT_MAX = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

	function getNonce(bytes32[] _state) constant internal returns (uint) {
		if (_state.length < 1) {
			throw;
		} else {
			return uint(_state[0]);
		}
	}

	function isSuperior(bytes32[] _new, bytes32[] _old) constant returns (bool) {
		return getNonce(_new) > getNonce(_old);
	}

	function isFinal(bytes32[] _state) constant returns (bool) {
		return getNonce(_state) == UINT_MAX;
	}
}
