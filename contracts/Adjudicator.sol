/**
 * This contract ensures that the latest signed state between some parties is
 * revealed. This solves the data availability contest problem.
 */
contract Adjudicator {

	// The maximum integer value that can be stored in an uint256 (uint)
	uint public constant UINT_MAX = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

	// Whether the state has been frozen or not
	bool public frozen = false;

	// The current nonce of the state
	uint nonce = 0;

	// The timestamp of the last state sent
	uint lastTimestamp = 0;

	// The address of the owner of this contract
	address owner;

	// The timeout period before this contract can be frozen
	uint timeout;

	// The last hash of the latest state
	bytes32 public stateHash;

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

	/**
	 * Creates a new Adjudicator contract.
	 *
	 * _owner: The owner of this contract
	 * _timeout: The timeout period before this contract can be frozen
	 */
	function Adjudicator(address _owner, uint _timeout) {
		owner = _owner;
		timeout = _timeout;
	}

	/**
	 * Submits a potential hash of state into this contract.
	 *
	 * _newNonce: The nonce of the new state
	 * _stateHash: The hash of the latest state
	 *
	 * returns: `true` if sucessful, otherwise `false`
	 */
	function submit(uint _newNonce, bytes32 _stateHash)
		external
		onlyOwner
		notFrozen
		returns (bool)
	{
		if (_newNonce > nonce) {
			nonce = _newNonce;
			stateHash = _stateHash;
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Unfreezes the contract and prevents last sent state from being frozen.
	 *
	 * returns: `true` if successful, otherwise `false`
	 */
	function unfreeze() external onlyOwner returns (bool) {
		if (nonce != UINT_MAX) {
			lastTimestamp = 0;
			frozen = false;
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Freezes the contract if the nonce is final or if the timeout period has
	 * been reached.
	 *
	 * returns: `true` if successful, otherwise `false`
	 */
	function finalize() external notFrozen returns (bool) {
		if (nonce == UINT_MAX || (lastTimestamp != 0 && now > lastTimestamp + timeout)) {
			frozen = true;
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Kills the current contract.
	 *
	 * _recipient: The recipient of funds from the `selfdestruct` call
	 */
	function kill(address _recipient) external onlyOwner {
		selfdestruct(_recipient);
	}
}
