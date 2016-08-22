var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var Tx = require('ethereumjs-tx');
var privateKey = new Buffer('e331b6d69882b4cb4ea581d88e0b604039a3de5967688d3dcffdd2270c0fd109', 'hex')

function getRawTransactionString(
        privateKey,
        rawTx
) {
        var args = Array.prototype.slice.call(arguments, 0);
        privateKey = new Buffer(privateKey, 'hex');
        var tx = new Tx(rawTx);
        tx.sign(privateKey);
        var serializedTx = tx.serialize();
        console.log(serializedTx.toString('hex'));
}

/** Example
* getRawTransactionString(
*         'e331b6d69882b4cb4ea581d88e0b604039a3de5967688d3dcffdd2270c0fd109',
*         {
*                 nonce: '0x00',
*                 gasPrice: '0x09184e72a000',
*                 gasLimit: '0x2710',
*                 to: '0x0000000000000000000000000000000000000000',
*                 value: '0x00',
*                 data: '0x7f7465737432000000000000000000000000000000000000000000000000000000600057'
*         }
* );
**/
