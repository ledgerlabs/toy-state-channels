contract Rules {
	bytes32[] decidedState;

	function getDecidedStateLength() constant returns (uint) {
		return decidedState.length;
	}

	function getDecidedStateAt(uint _index) constant returns (bytes32) {
		return decidedState[_index];
	}

	// define rules and exposure conditions in here
}
