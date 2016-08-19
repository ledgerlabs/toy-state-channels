contract UnanimousConsentSignatureProxy {
    address signer;
    address unanimousConsent;
    
    function UnanimousConsentSignatureProxy(address _signer, address _unanimousConsent) {
        signer = _signer;
        unanimousConsent = _unanimousConsent;
    }
    
    function forward(bytes32[] hashes, uint8[] v, bytes32[] r, bytes32[] s) returns(bool) {
        uint length = hashes.length;
        for (uint i = 0; i < length; ++i) {
            if (ecrecover(hashes[i], v[i], r[i], s[i]) != signer) {
                return false;
            }
        }
        return unanimousConsent.call(bytes4(sha3("consent(bytes32)")), hashes);
    }
}
