import "./BulletinBoard.sol";

/**
 * This library contains functions which support calling of arbitrary functions
 * with variable arguments.
 */
library CallLib {

    /**
     * Executes a call to a function in a contract.
     *
     * _target: The target contract to call
     * _value: The amount of Ether to send
     * _methodSignature: The signature of the method being called
     * _calldata: The arguments passed to the function
     */
    function doCall(address _target, uint _value, bytes4 _methodSignature, bytes32[] _calldata) {
        if (!_target.call.value(_value)(_methodSignature, _calldata)) {
            throw;
        }
    }

    /**
     * Finds a contract from a BulletinBoard and calls it.
     *
     * _bulletinBoard: The BulletinBoard where the contract can be foundg
     * _contractID: The ID of the contract that is being foundg
     * _value: The amount of Ether to send
     * _methodSignature: The signature of the method being called
     * _calldata: The arguments passed to the function
     */
    function callFromBulletinBoard(
        BulletinBoard _bulletinBoard,
        bytes32 _contractID,
        uint _value,
        bytes4 _methodSignature,
        bytes32[] _calldata
    ) {
        address target = _bulletinBoard.registry(_contractID);
        if (target == 0 || !target.call.value(_value)(_methodSignature, _calldata)) {
            throw;
        }
    }
}
