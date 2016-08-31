import "./UnanimousConsent.sol";

/**
* This contract will consent to some hashes on behalf of a specified
* address if and only if the specified address has signed off on it
*/
contract ECDSASignatureProxy {

    event HashesForwarded(bytes32[] _hashes);

    address signer;
    UnanimousConsent unanimousConsent;

    function ECDSASignatureProxy(address _signer, UnanimousConsent _unanimousConsent) {
        signer = _signer;
        unanimousConsent = _unanimousConsent;
    }

    // Checks if all of the hashes have been signed off on
    function forward(bytes32[] _hashes, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool) {
        bytes32 hash = sha3(_hashes);
        if (ecrecover(hash, _v, _r, _s) != signer) {
            return false;
        } else {
            unanimousConsent.consent(_hashes);
            HashesForwarded(_hashes);
            return true;
        }
    }
}
