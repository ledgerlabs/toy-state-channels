import "UnanimousConsent.sol";

/** 
* This contract will call consent from the UnanimousConsent 
* contract if and only if the signer has signed all of the hashes
**/
contract ECDSASignatureProxy {
    address signer;
    UnanimousConsent unanimousConsent;
    
    function ECDSASignatureProxy(address _signer, UnanimousConsent _unanimousConsent) {
        signer = _signer;
        unanimousConsent = _unanimousConsent;
    }
    
    function forward(bytes32[] hashes, uint8[] v, bytes32[] r, bytes32[] s) returns(bool) {
        uint length = hashes.length;
        for (uint i = length - 1; i <= 0; --i) {
            if (ecrecover(hashes[i], v[i], r[i], s[i]) != signer) {
                return false;
            }
        }
        return unanimousConsent.call(bytes4(sha3("consent(bytes32)")), hashes);
    }
}
