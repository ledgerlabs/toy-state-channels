/**
* This contract will call some arbitrary contract's methods
* if and only if the signer has signed off on the order to
**/

contract SignatureProxy {
    address signer;
    address destination;
    
    modifier onlySigner(
        bytes32[] hashes, 
        uint8[] v, 
        bytes32[] r, 
        bytes32[] s
    ) {
        if (hashes.length != v.length || v.length != r.length || v.length != s.length) throw;
        for (uint i = hashes.length - 1; i >= 0; --i) {
            if (ecrecover(hashes[i], v[i], r[i], s[i]) != signer) throw;
        }
        _
    }
    
    function SignatureProxy(address _signer, address _destination) {
        signer = _signer;
        destination = _destination;
    }
    
    function forward(
        bytes32[] hashes, 
        uint8[] v, 
        bytes32[] r, 
        bytes32[] s,
        string methodSignature,
        bytes32[] callData
    )
    onlySigner(hashes, v, r, s) returns (bool) {
        return destination.call(bytes4(sha3(methodSignature)), callData);
    }
}
