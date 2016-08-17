library CallLib {
	function doCall(address _target, uint _value, bytes4 _methodSignature, bytes32[] _calldata) {
		if (!_target.call.value(_value)(_methodSignature, _calldata)) {
			throw;
		}
	}
	// TODO: Make a counterfactually addressing version of the function above!
}
