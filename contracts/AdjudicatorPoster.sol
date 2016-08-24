import "./Adjudicator.sol";
import "./BulletinBoard.sol";

library AdjudicatorPoster {
	function postAdjudicator(
		BulletinBoard _bulletinBoard, 
		bytes32 _hash, 
		CompareOp _compareOp, 
		address _owner, 
		uint _timeout
	) {
		_bulletinBoard.updateRegistry(_hash, new Adjudicator(_compareOp, _owner, _timeout));
	}
}
