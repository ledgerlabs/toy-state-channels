import "UnanimousConsent.sol"
import "Adjudicator.sol"
import "CompareOp.sol"

contract examples {

  UnanimousConsent unanimousContract;




  function examples() {
    address[] mees = new address[](2);
    mees[0] = this;
    mees[1] = this;
    
    unanimousContract = new UnanimousConsent(mees);

  }


  function fullOnChainPaymentChannel() returns(bool) {

  }


}
