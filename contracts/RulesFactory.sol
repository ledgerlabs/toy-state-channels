import "Rules.sol";

contract RulesFactory {

	Rules lastRules;

	function getLastCreatedRules() returns (Rules returnedRules) {
		if (lastRules != 0) {
			returnedRules = lastRules;
			lastRules = 0;
		} else {
			throw;
		}
	}
}
