contract CompareOp {
	function isSuperior(bytes32[] _old, bytes32[] _new) constant returns (bool);
	function isFinal(bytes32[] _state) constant returns (bool);
}
