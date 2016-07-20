contract Adjudicator {

	bool frozen = false;
	uint nonce = 0;
	uint lastTimestamp = 0;
	address owner;
	uint timeout;
	bytes32[] state;

	modifier onlyOwner {
		if (msg.sender == owner) {
			_
		} else {
			throw;
		}
	}

	modifier notFrozen {
		if (frozen) {
			throw;
		} else {
			_
		}
	}

	function Adjudicator(address _owner, uint _timeout) {
		owner = _owner;
		timeout = _timeout;
	}

	function getStateLength() constant returns (uint) {
		return state.length;
	}

	function getStateIndex(uint _index) constant returns (bytes32) {
		return state[_index];
	}

	function submit(bytes32[] _state) external onlyOwner notFrozen {
		state = _state;
	}

	function appeal() external onlyOwner notFrozen;// this will have something to do with the rules

	function giveConsent() external onlyOwner notFrozen {
		frozen = true;
	}

	function finalize() external notFrozen returns (bool) {
		if (lastTimestamp > 0 && now > lastTimestamp + timeout) {
			frozen = true;
			return true;
		} else {
			return false;
		}
	}

	function kill(address _recipient) external onlyOwner {
		selfdestruct(_recipient);
	}
}
