import "CompareOp.sol";

contract Adjudicator {

	bool public frozen = false;
	uint lastTimestamp = 0;
	CompareOp compareOp;
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

	function Adjudicator(CompareOp _compareOp, address _owner, uint _timeout) {
		compareOp = _compareOp;
		owner = _owner;
		timeout = _timeout;
	}

	function submit(bytes32[] _state)
		external
		onlyOwner
		notFrozen
		returns (bool)
	{
		if (compareOp.isSuperior(state, _state) {
			state = _state;
			return true;
		} else {
			return false;
		}
	}

	function unfreeze() external onlyOwner returns (bool) {
		if (frozen && !CompareOp.isFinal(state)) {
			lastTimestamp = 0;
			frozen = false;
			return true;
		} else {
			return false;
		}
	}

	function finalize() external notFrozen returns (bool) {
		if (CompareOp.isFinal(state) || (lastTimestamp != 0 && now > lastTimestamp + timeout)) {
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
