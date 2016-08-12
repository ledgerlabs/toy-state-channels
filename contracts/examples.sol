import "UnanimousConsent.sol";
import "Adjudicator.sol";
import "NonceCompareOp.sol";
import "CompareOp.sol";

contract examples {

  UnanimousConsent unanimousContract;
  CompareOp compareContract;


  struct Action {
		address target;
		uint value;
		bytes32[] calldata;
		bool initialized;
	}

  mapping(uint => Action) actionLibrary;

  function examples() {
    address[] mees = new address[](2);
    mees[0] = this;
    mees[1] = this;

    unanimousContract = new UnanimousConsent(mees);
    compareContract = new NonceCompareOp();

  }


  function fullOnChainPaymentChannel() returns(bool) {
    uint numOps = 4;

    //register actions with the universal consent contract
    uint[] actionsToSend = new uint[](numOps);
    actionsToSend[0] = Action(_target, _value, _calldata, true); //instantiate lockAdjudicator
    actionsToSend[1] = Action(_target, _value, _calldata, true); //instantiate payment channel adjudicator
    actionsToSend[2] = Action(_target, _value, _calldata, true); //update the state of the payment adjudicator
    actionsToSend[3] = Action(_target, _value, _calldata, true); //make the payment based on the finalised state
    sendActions(actionsToSend);

    //send consents to the universal consent contract
    bytes32[] hashesToConsent = new bytes32[](numOps);

    for(uint i = 0; i < numOps; i++){
      hashesToConsent[i] = sha3(actionLibrary[actionsToSend[i]].target, actionLibrary[actionsToSend[i]].value, actionLibrary[actionsToSend[i]].calldata);
    }

    bytes32 packageHash = sha3(hashesToConsent);
    sendConsent(packageHash);

    //send evals to instantiate lockAdjudicator, the payment channel adjudicator, to update the state of the payment channel adjudicator, and to make the payment
		requestEvals(packageHash);
  }

  //helper function to send actions to the unanimous consent contract
  function sendActions(uint[] _actionsToSend) {
    for(uint i = 0; i < _actionsToSend.length; i++){
      unanimousContract.addAction(actionLibrary[_actionsToSend[i]].target, actionLibrary[_actionsToSend[i]].value, actionLibrary[_actionsToSend[i]].calldata);
    }
  }

  //helper function to send a consent to the unanimous consent contract
  function sendConsent(bytes32 _hash) {
    bytes32[] hashArray = new bytes32[](1);
    hashArray[0] = _hash;
    sendConsents(hashArray);
  }

  //helper function to send multiple consents to the unanimous consent contract
  function sendConsents(bytes32[] _hashes) {
    unanimousContract.consent(_hashes);
  }

  //helper function to request evals from the unanimous consent contract
  function requestEvals(bytes32[] _actionHashes) {
    unanimousContract.eval(_actionHashes);
  }

  //helper function to calculate what should go in the calldata field for a given function call
  function calculateTxData(string _functionSignature, bytes32[] _args) returns(bytes32) {
    //todo: finish properly forming the actual thing
    return bytes4(sha3(_functionSignature));
  }


}
