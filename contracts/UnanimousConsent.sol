import "BulletinBoard.sol";

/**
 * This contract performs an "eval" on arbitrary contracts but only with the
 * consent of all participants named.
 */
contract UnanimousConsent {

	enum ConsentState {
		NONE,
		CONSENTED,
		EXECUTED
	}

	struct Action {
		address target;
		uint value;
		bytes calldata;
		bool initialized;
	}

	// Records the current state of consent for a given hash and address
	mapping (bytes32 =>
			mapping (address => ConsentState)) consentStates;

	// TODO Document this
	mapping (bytes32 => Action) actions;

	// Holds all of the participants in the current UnanimousConsent contract
	address[] participants;

	// Holds the BulletinBoard for counterfactual addressing
	BulletinBoard public bulletinBoard;

	modifier onlySelf {
		if (msg.sender == address(this)) {
			_
		} else {
			throw;
		}
	}

	/**
	 * Creates a new UnanimousConsent contract.
	 *
	 * _participants: The initial participants in the contract
	 */
	function UnanimousConsent(address[] _participants) {
		participants = _participants;
		bulletinBoard = new BulletinBoard(this);
	}

	// TODO Document this
	function addAction(address _target, uint _value, bytes _calldata) external {
		Action memory action = Action(_target, _value, _calldata, true);
		actions[sha3(action)] = action;// hashing a struct is broken
	}

	// TODO Document this
	function cleanActions(bytes32[] _actionHashes) external onlySelf {
		for (uint i = 0; i < _actionHash.length; i++) {
			delete actions[_actionHashes[i]];
		}
	}

	/**
	 * Evaluates arbitrary functions of contracts, but only with universal
	 * consent. Note that any `eval` sub-calls should `throw` in the event that
	 * there is a contract execution failure (such as if a precondition isn't
	 * met or if a verification of some sort fails) to prevent this call from
	 * finishing.
	 *
	 * TODO: Fix this
	 */
	function eval(bytes32[] _actionHashes) {
		uint i;
		bytes32 hash = sha3(_actionHashes);

		for (i = 0; i < participants.length; i++) {
			if (consentStates[hash][participants[i]] == ConsentState.CONSENTED) {
				consentStates[hash][participants[i]] = ConsentState.EXECUTED;
			} else {
				throw;
			}
		}

		for (i = 0; i < _actionHashes.length; i++) {
			Action memory action = actions[_actionHashes[i]];
			if (action.initialized && !action.target.call.value(action.value)(action.calldata)) {
				throw;
			}
		}
	}

	/**
	 * Provides consent for the hash of an execution call for the sender of the
	 * message.
	 *
	 * _hash: The hash of the execution call
	 *
	 * returns: `true` if successful, otherwise `false`
	 */
	function consent(bytes32 _hash) returns (bool) {
		if (consentStates[_hash][msg.sender] == ConsentState.NONE) {
			consentStates[_hash][msg.sender] = ConsentState.CONSENTED;
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Changes the participants in the current contract. Intended to only be
	 * called by this contract's `eval`.
	 *
	 * _participants: The new participants in the contract
	 */
	function changeParticipants(address[] _participants) external onlySelf {
		participants = _participants;
	}

	/**
	 * Cleans up previously approved consents. Intended to only be called by
	 * this contract's `eval`.
	 *
	 * _hashes: The list of hashes to clean
	 * _participants: The list of address whose hashes should be cleaned
	 */
	function clean(bytes32[] _hashes, address[] _participants) external onlySelf {
		for (uint i = 0; i < _hashes.length; i++) {
			for (uint j = 0; j < _participants.length; j++) {
				delete consentStates[_hashes[i]][_participants[j]];
			}
		}
	}

	/**
	 * Kills the current contract. Intended to only be called by this contract's
	 * eval.
	 *
	 * _recipient: The recipient of funds from the `selfdestruct` call
	 */
	function kill(address _recipient) external onlySelf {
		selfdestruct(_recipient);
	}
}
