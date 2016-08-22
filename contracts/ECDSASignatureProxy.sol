import "UnanimousConsent.sol";

/**
* This contract will consent to some hashes on behalf of a specified
* address if and only if the specified address has signed off on it
**/

contract ECDSASignatureProxy {
    address signer;
    UnanimousConsent unanimousConsent;
    
    function ECDSASignatureProxy(address _signer, UnanimousConsent _unanimousConsent) {
        signer = _signer;
        unanimousConsent = _unanimousConsent;
    }
    
    // Checks if all of the hashes have been signed off on
    function forward(bytes32[] hashes, uint8 v, bytes32 r, bytes32 s) returns(bool) {
        bytes32 hash = sha3(hashes);
        if (ecrecover(hash, v, r, s) != signer) return false;
        unanimousConsent.consent(hashes);
        return true;
    }
}
