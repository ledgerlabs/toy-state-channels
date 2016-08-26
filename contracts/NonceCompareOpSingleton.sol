import "./NonceCompareOp.sol";

contract NonceCompareOpSingleton {
	NonceCompareOp nonceCompareOp;
	
	event CreateNonceCompareOp(address indexed nonceCompareOp);

	function getNonceCompareOp() returns (NonceCompareOp) {
		if (address(nonceCompareOp) == 0) {
			nonceCompareOp = new NonceCompareOp();
		}
		CreatedNonceCompareOp(nonceCompareOp);
		return nonceCompareOp;
	}
}
