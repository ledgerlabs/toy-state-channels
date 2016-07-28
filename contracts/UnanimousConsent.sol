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

	// Records the current state of consent for a given hash and address
	mapping (bytes32 =>
			mapping (address => ConsentState)) consentStates;

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

	/**
	 * Evaluates arbitrary functions of contracts, but only with universal
	 * consent. Note that any `eval` sub-calls should `throw` in the event that
	 * there is a contract execution failure (such as if a precondition isn't
	 * met or if a verification of some sort fails) to prevent this call from
	 * finishing.
	 *
	 * _calledContracts: The addresses of the called contracts
	 * _methodSignatures: The method signatures of the functions
	 * _argumentLengths: The lengths of the arguments for each function call
	 * _arguments: The arguments of all function calls concatenated
	 * _values: Amount of Ether to send for each respective call
	 */
	function eval(
		address[] _calledContracts,
		bytes4[] _methodSignatures,
		uint[] _argumentLengths,
		bytes32[] _arguments,
		uint[] _values
	) {
		if (
			_calledContracts.length != _methodSignatures.length ||
			_calledContracts.length != _argumentLengths.length ||
			_calledContracts.length != _values.length
		) {
			throw;
		}

		uint i;
		uint j;
		bytes32 hash = sha3(_calledContracts, _methodSignatures, _argumentLengths, _arguments, _values);

		for (i = 0; i < participants.length; i++) {
			if (consentStates[hash][participants[i]] == ConsentState.CONSENTED) {
				consentStates[hash][participants[i]] = ConsentState.EXECUTED;
			} else {
				throw;
			}
		}

		uint argumentsIndex = 0;
		for (i = 0; i < _calledContracts.length; i++) {

			bytes32[] memory arguments = new bytes32[](_argumentLengths[i]);
			for (j = 0; j < _argumentLengths[i]; j++) {
				arguments[j] = _arguments[argumentsIndex++];
			}

			if (!_calledContracts[i].call.value(_values[i])(_methodSignatures[i], arguments[i])) {
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
	 * Sends the Ether stored in the currenct contract. Intended to only be
	 * called by this contract's `eval`.
	 *
	 * _recipient: The recipient of the Ether.
	 * _amount: The amount of Ether to send.
	 */
	function sendEther(address _recipient, uint _amount) external onlySelf {
		if (!_recipient.send(_amount)) {
			throw;
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
