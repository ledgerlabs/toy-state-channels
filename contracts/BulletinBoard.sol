contract BulletinBoard {
	address owner;
	mapping (bytes32 => address) public registry;

	modifier onlyOwner {
		if (msg.sender == owner) {
			_
		} else {
			throw;
		}
	}

	function BulletinBoard(address _owner) {
		owner = _owner;
	}

	function updateRegistry(bytes32 _key, address _value) onlyOwner {
		registry[_key] = _value;
	}
}
