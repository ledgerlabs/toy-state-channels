import "Rules.sol";

contract RulesFactory {
	function createRules() returns (Rules) {
		return new Rules();
	}
}
