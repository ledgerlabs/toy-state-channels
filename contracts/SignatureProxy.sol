/**
* This contract will call some arbitrary contract's methods
* if and only if the signer has signed off on the order to
**/

contract SignatureProxy {
    address signer;
    // Destination is the address of the contract that method calls are sent to
    address destination;
    
    // Ensures that the signer has signed all the hashes
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
    
    // Returns true upon success and false upon failure
    function forward(
        // hashes are the method signatures
        bytes32[] hashes, 
        uint8[] v, 
        bytes32[] r, 
        bytes32[] s,
        bytes32[] callData
    )
    onlySigner(hashes, v, r, s) returns (bool) {
        uint length = hashes.length;
        for (uint i = 0; i < length; ++i) {
                if (destination.call(bytes4(hashes[i]), callData)) {
                return false;
            }
        }
        return true;
    }
}
