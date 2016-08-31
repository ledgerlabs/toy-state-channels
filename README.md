# Toy State Channels

**WARNING: This code is a TOY implementation designed for educational and
explanatory purposes only and is NOT SAFE for production use.**  Numerous key
safety features have been left purposely unimplemented for the sake of
readability and brevity.

The Toy State Channels project is a work-in-progress project aiming to provide a
clear, readable example of a fully abstracted [state
channel](http://www.jeffcoleman.ca/state-channels/) framework, where a single
blockchain-based commitment of assets or permissions can be used for an
unlimited number of payments, smart contracts, etc. without further operations
needing to be performed on the blockchain itself. This project uses Solidity
contracts on the Ethereum blockchain and implements client-side functionality
using HTML5/Javascript.  It takes advantage of previous work done at [Ledger
Labs](http://ledgerlabs.com/) by Jeff Coleman, Denton Liu, and Anna Wang, with
assistance from many others.  Code for this project is MIT licensed, and
documentation is CC BY-SA 4.0.

## Running Toy State Channels Examples and Tests
*to be completed*

## Overview of Toy State Channels
*to be completed*

## Contracts
### [UnanimousConsent](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/UnanimousConsent.sol)
`UnanimousConsent` is essentially a multisignature eval contract. It allows a
defined group of members to execute many arbitrary `delegatecall` if all parties
in the group have consented to the calls being performed.

### [BulletinBoard](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/BulletinBoard.sol)
A `BulletinBoard` is a contract which maps a `bytes32` key to an `address`
value. The purpose of this contract is to allow a counterfactually created
contract to be posted to the `BulletinBoard` and addressed by its ID because the
final address is not known for certain until it is actually created.

### [CallLib](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/CallLib.sol)
Since `UnanimousConsent` performs `delegatecall`, this library provides basic
functions, which `UnanimousConsent` is expected to call, from which you can call
other contracts, either using their counterfactual ID or using their Ethereum
address.

### [Adjudicator](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/Adjudicator.sol)
This contract is used to resolve data availability contests. In order to
determine what the *newest* state is, this contract will accept submissions for
a predetermined timeout. If a new entry is sent, the timeout will reset.
Finally, once the timeout period ends (or all parties agree to a *final* state),
the state is finalized and this is assumed to be the *newest* state that has
been agreed upon by all parties.

### [CompareOp](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/CompareOp.sol)
In an `Adjudicator`, the definition of *newest* is vague. In many cases, this
will be the state with the greatest nonce however, a nonce is not necessary in
all cases. Take, for example, a game of Tic-Tac-Toe. The newest state is the
(valid) board with the most pieces on it. Therefore, a nonce is not even
required in this case as you can implicitly use the number of pieces on the
board instead.

In addition to this, the definition of *final* is also vague. Take the case of
Tic-Tac-Toe, again. In that case, the definition of *final* is a win, loss or
tie because you cannot add anything onto the board past that.

### [NonceCompareOp](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/NonceCompareOp.sol)
This is an implementation of `CompareOp` where the nonce is given in the first
32 bytes of the state. In this case, the definition of *newest* is that the
nonce is greater than the older one. Also, the definition of *final* is that the
nonce is the maximum value that a `uint256` can hold.

### [NonceCompareOpSingleton](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/NonceCompareOpSingleton.sol)
`NonceCompareOp` would be better written as a `library`. Unfortunately, due to
the nature of Solidity, a `library` cannot be inheritable or inherited. As a
result, `NonceCompareOp` had to be written as a `contract`. This contract
supplies a singleton-wrapped `NonceCompareOp`, which is intended to be used by
all contracts.

### [ECDSASignatureProxy](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/ECDSASignatureProxy.sol)
Unlike Bitcoin, whenever a transaction is sent from an Ethereum account, a
remaining balance is expected for transactions to go through because
transactions require gas.  This means that signed strings of raw transactions
can be trivially invalidated by simply emptying ones account of Ether. In order
to prevent this, the members of `UnanimousConsent` should be multiple copies of
this contract so that signed consents cannot be invalidated.

### [AdjudicatorPoster](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/AdjudicatorPoster.sol)
`AdjudicatorPoster` is a helper contract which shall create an `Adjudicator`
and then post it to a `BulletinBoard` with its `bytes32` ID (presumably a hash
of some features of the contract) as the key and its address as the value. This
allows an `UnanimousConsent` contract to counterfactually create and call
`Adjudicator` while only knowing its predetermined ID.

### [Rules](https://github.com/ledgerlabs/toy-state-channels/blob/master/contracts/Rules.sol)
`Rules` is a, presently, ill-defined contract. Its purpose is to handle dangling
conditions such as what an `Adjudicator` should do with excess funds sent.
Although much discussion has been had on this, a decision has yet to be made on
where in the contract hierarchy this should be placed.

## More Documentation
*to be completed*
