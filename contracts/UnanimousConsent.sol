import "BulletinBoard.sol";

contract UnanimousConsent {

	enum ConsentState {
		NONE,
		CONSENTED,
		EXECUTED
	}

	mapping (bytes32 =>
			mapping (address => ConsentState)) consentStates;
	address[] participants;
	BulletinBoard public bulletinBoard;

	modifier onlySelf {
		if (msg.sender == address(this)) {
			_
		} else {
			throw;
		}
	}

	function StateChannel(address[] _participants) {
		participants = _participants;
		bulletinBoard = new BulletinBoard(this);
	}

	function eval(
		address[] _calledContracts,
		bytes4[] _methodSignatures,
		uint[] _argumentLengths,
		bytes32[] _arguments
	) {
		if (
			_calledContracts.length != _methodSignatures.length ||
			_calledContracts.length != _argumentLengths.length
		) {
			throw;
		}

		uint i;
		uint j;
		bytes32 hash = sha3(_calledContracts, _methodSignatures, _argumentLengths, _arguments);

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

			if (!_calledContracts[i].call(_methodSignatures[i], arguments[i])) {
				throw;
			}
		}
	}

	function consent(bytes32 _hash) {
		consentStates[_hash][msg.sender] = ConsentState.CONSENTED;
	}

	function sendEther(address _recipient, uint _amount) external onlySelf {
		if (!_recipient.send(_amount)) {
			throw;
		}
	}

	function changeParticipants(address[] _participants) external onlySelf {
		participants = _participants;
	}

	function clean(bytes32[] _hashes, address[] _participants) external onlySelf {
		for (uint i = 0; i < _hashes.length; i++) {
			for (uint j = 0; j < _participants.length; j++) {
				delete consentStates[_hashes[i]][_participants[j]];
			}
		}
	}

	function kill(address _recipient) external onlySelf {
		selfdestruct(_recipient);
	}
}
