contract CompareOp {
	function isSuperior(bytes _old, bytes _new) constant returns (bool);
	function isFinal(bytes _state) constant returns (bool);
}
