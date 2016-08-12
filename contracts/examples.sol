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
    uint numOps = 4

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

  function sendActions(uint[] _actionsToSend) {

  }

  function sendConsent(bytes32 _hashes) {

  }

  function requestEvals(bytes32[] _actionHashes) {

  }

  function calculateTxData(string _functionSignature) returns(bytes32) {
    return bytes4(sha3(_functionSignature));
  }


}
