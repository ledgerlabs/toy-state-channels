import "./CompareOp.sol";

/**
 * This contract ensures that the latest signed state between some parties is
 * revealed. This solves the data availability contest problem.
 */
contract Adjudicator {

    event StateSubmitted(bytes32[] _state);
    event AdjudicatorUnfrozen();
    event AdjudicatorFinalized(bytes32[] _state);

    // Whether the state has been frozen or not
    bool public frozen = false;

    // The timestamp of the last state sent
    uint lastTimestamp = 0;

    // The CompareOp which will be used to validate states
    CompareOp compareOp;

    // The address of the owner of this contract
    address owner;

    // The timeout period before this contract can be frozen
    uint timeout;

    // The newest state sent
    bytes32[] state;

    modifier onlyOwner {
        if (msg.sender == owner) {
            _
        } else {
            throw;
        }
    }

    modifier notFrozen {
        if (frozen) {
            throw;
        } else {
            _
        }
    }

    /**
     * Creates a new Adjudicator contract.
     *
     * _compareOp: The CompareOp which will be used to validate states
     * _owner: The owner of this contract
     * _timeout: The timeout period before this contract can be frozen
     */
    function Adjudicator(CompareOp _compareOp, address _owner, uint _timeout) {
        compareOp = _compareOp;
        owner = _owner;
        timeout = _timeout;
    }

    /**
     * Submits a state into this contract.
     *
     * _state: The state to be submitted
     *
     * returns: `true` if sucessful, otherwise `false`
     */
    function submit(bytes32[] _state)
        external
        onlyOwner
        notFrozen
        returns (bool)
    {
        if (compareOp.isSuperior(_state, state)) {
            state = _state;
            StateSubmitted(_state);
            return true;
        } else {
            return false;
        }
    }

    /**
     * Unfreezes the contract and prevents last sent state from being frozen.
     *
     * returns: `true` if successful, otherwise `false`
     */
    function unfreeze() external onlyOwner returns (bool) {
        if (!compareOp.isFinal(state)) {
            lastTimestamp = 0;
            frozen = false;
            AdjudicatorUnfrozen();
            return true;
        } else {
            return false;
        }
    }

    /**
     * Freezes the contract if the nonce is final or if the timeout period has
     * been reached.
     *
     * returns: `true` if successful, otherwise `false`
     */
    function finalize() external notFrozen returns (bool) {
        if (compareOp.isFinal(state) || (lastTimestamp != 0 && now > lastTimestamp + timeout)) {
            frozen = true;
            AdjudicatorFinalized(state);
            return true;
        } else {
            return false;
        }
    }

    /**
     * Kills the current contract.
     *
     * _recipient: The recipient of funds from the `selfdestruct` call
     */
    function kill(address _recipient) external onlyOwner {
        selfdestruct(_recipient);
    }
}
