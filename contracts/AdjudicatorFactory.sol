import "Adjudicator.sol";

contract AdjudicatorFactory {
	function createAdjudicator(CompareOp _compareOp, address _owner, uint _timeout)
		returns (Adjudicator)
	{
		return new Adjudicator(CompareOp _compareOp, address _owner, uint _timeout);
	}
}
