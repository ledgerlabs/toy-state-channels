import "./Adjudicator.sol";
import "./BulletinBoard.sol";

library AdjudicatorPoster {

    event AdjudicatorCreated(address indexed _owner, bytes32 indexed _id, address _address);

    function postAdjudicator(
        BulletinBoard _bulletinBoard,
        bytes32 _id,
        CompareOp _compareOp,
        address _owner,
        uint _timeout
    ) {
        Adjudicator adjudicator = new Adjudicator(_compareOp, _owner, _timeout);
        _bulletinBoard.updateRegistry(_id, adjudicator);
        AdjudicatorCreated(_owner, _id, adjudicator);
    }
}
