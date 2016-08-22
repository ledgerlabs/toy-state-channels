/**
* This contract will call some arbitrary contract's methods
* if and only if the signer has signed off on the order to
**/

contract SignatureProxy {
    address signer;
    // Destination is the address of the contract that method calls are sent to
    address destination;
    
    // Ensures that the signer has signed the hash of the desired method call
     modifier onlySigner(
        // hash is sha3("methodName(paramType,paraType...)")
        bytes32 hash, 
        uint8 v, 
        bytes32 r, 
        bytes32 s
    ) {
            if (ecrecover(hash, v, r, s) != signer) throw;
        _
    }
    
    function SignatureProxy(address _signer, address _destination) {
        signer = _signer;
        destination = _destination;
    }
    
    // Returns true upon success and false upon failure
    function forward(
        bytes32 hash, 
        uint8 v, 
        bytes32 r, 
        bytes32 s,
        bytes32[] callData
    )
    onlySigner(hash, v, r, s) returns (bool) {
        return destination.call(bytes4(hash), callData);
    }
}
