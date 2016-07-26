/**
 * This contract keeps an entry of contracts, addressed by a hash.
 */
contract BulletinBoard {

	// The owner of this contract
	address owner;

	// The registry of hashes to contract addresses
	mapping (bytes32 => address) public registry;

	modifier onlyOwner {
		if (msg.sender == owner) {
			_
		} else {
			throw;
		}
	}

	/**
	 * Creates a new BulletinBoard contract.
	 *
	 * _owner: The owner of this contract
	 */
	function BulletinBoard(address _owner) {
		owner = _owner;
	}

	/**
	 * Updates the registry's value at a certain key.
	 *
	 * _key: The hash that is used to find the contract
	 * _value: The address of the contract associated with a hash
	 */
	function updateRegistry(bytes32 _key, address _value) onlyOwner {
		registry[_key] = _value;
	}

	/**
	 * Kills the current contract.
	 *
	 * _recipient: The recipient of funds from the `selfdestruct` call
	 */
	function kill(address _recipient) external onlyOwner {
		selfdestruct(_recipient);
	}
}
