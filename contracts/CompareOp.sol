contract CompareOp {
	function isSuperior(bytes32[] _new, bytes32[] _old) constant returns (bool);
	function isFinal(bytes32[] _state) constant returns (bool);
}
