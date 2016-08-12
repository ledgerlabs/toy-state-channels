import "NonceCompareOp.sol";

contract NonceCompareOpSingleton {
	NonceCompareOp nonceCompareOp;

	function getNonceCompareOp() returns (NonceCompareOp) {
		if (nonceCompareOp == 0) {
			nonceCompareOp = new NonceCompareOp();
		}
		return nonceCompareOp;
	}
}
