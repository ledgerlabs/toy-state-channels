contract Adjudicator {

	uint nonce = 0;
	uint lastTimestamp = 0;
	uint timeout;

	function Adjudicator(uint _timeout) {
		timeout = _timeout;
	}
}
