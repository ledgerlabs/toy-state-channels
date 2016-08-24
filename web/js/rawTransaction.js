/**
* Include the ethereumjs-tx.js file in the index.html file
* Download it here: https://github.com/ethereumjs/browser-builds
**/

if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

function getRawTransactionString(
        senderAddress,
        to,
        gas,
        value,
        bytecode
) {
        var rawTx = {
                to: to,
                gas: gas,
                value: value,
                data: bytecode
        }
        var tx = new EthJS.Tx(rawTx);
        var rawArray = EthJS.Util.rlphash(tx.raw.slice(0, 6));
        var toBeHashed = '0x';
        for (var i = 0; i < rawArray.length; ++i) {
                toBeHashed += ('00' + rawArray[i].toString(16)).slice(-2);
        }
        var signature = web3.eth.sign(senderAddress, toBeHashed);
        tx.r = new EthJS.Buffer.Buffer(signature.slice(2, 66), 'hex');
        tx.s = new EthJS.Buffer.Buffer(signature.slice(66, 130), 'hex');
        tx.v = new EthJS.Buffer.Buffer(signature.slice(-2), 'hex');
        console.log(tx);
        var serializedTx = tx.serialize();
        return serializedTx.toString('hex');
}

/**
* Example call:
* var woo = getRawTransactionString(
*       '0xfb09946a02bd28edf25c8b35618822e86ac0de96',
*       '0x0000000000000000000000000000000000000000',
*       '0x47b760',
*       '0x00',
*       '0x'
* );
**/

