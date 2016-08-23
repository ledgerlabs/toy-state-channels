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
        privateKey,
        rawTx
) {
        var args = Array.prototype.slice.call(arguments, 0);
        privateKey = EthJS.Buffer.Buffer(privateKey, 'hex');
        var tx = new EthJS.Tx(rawTx);
        tx.sign(privateKey);
        var serializedTx = tx.serialize();
        return serializedTx.toString('hex');
}
