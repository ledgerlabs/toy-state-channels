if (typeof web3 !== 'undefined') {
	web3 = new Web3(web3.currentProvider);
} else {
	// set the provider you want from Web3.providers
	web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

function transactionPromise(contract, method, from, value) {
        var params = Array.prototype.slice.call(arguments, 4);
        var transaction = '';
        transaction += contract + '.' + method + '.sendTransaction(';
        var length = params.length;
        for (var i = 0; i < length; ++i) {
                transaction += params[i] + ',';
        }
        transaction += '{from:"' + from + '",value:' + value + ',gas:4700000},';
        transaction += 'function(err, result) {' +
                                'if (err) {' +
                                        'console.log(err);' +
                                        'return;' +
                                '}' +
                                'var txhash = result;' +
                                'var filter = web3.eth.filter("latest");' +
                                'filter.watch(function(error, result) {' +
                                        'var receipt = web3.eth.getTransactionReceipt(txhash);' +
                                        'if(receipt && receipt.transactionHash == txhash) {' +
                                                'console.log("Transaction was mined");' +
                                                'filter.stopWatching();' +
						'resolve(result)' +
                                        '}' +
                                '});' +
                        '});';
        return new Promise(function(resolve, reject) {
		eval(transaction)
	});
}

function creationPromise(contract, abi, from, value, bytecode) {
        var params = Array.prototype.slice.call(arguments, 5);
        var create = 'new Promise(function (resolve, reject) {' +
                        contract + '= web3.eth.contract(' + abi + ').new(';
        var length = params.length;
        for (var i = 0; i < length; ++i) {
                create += params[i] + ',';
        }
        create += '{from:"' + from + '",value:' + value + ',data:"' + bytecode + '",gas:4700000},' +
                'function(e, contract) {' +
			'if (e) {' +
				'console.log(e);' +
			'}' +
                        'if (typeof contract.address !== "undefined") {' +
                                'console.log("Contract mined at: " + contract.address);' +
                                'resolve(contract.address);'+
                        '}' +
                '})' +
        '});';
        return eval(create);
}

var Adjudicator;
var LockAdjudicator
var BulletinBoard;
var Rules;
var LockRules;
var UnanimousConsent;

var hash;
var address;

function replaceStateChannel() {
	creationPromise('UnanimousConsent',
			'UnanimousConsentABI',
			web3.eth.accounts[0],
			'0',
			UnanimousConsentBytecode,
			web3.eth.accounts
	).then(function(result) {
		address = result;
		hash = web3.sha3(
			'000000000000000000000000' + result.slice(-40) +
			'cbf0b0c000000000000000000000000000000000000000000000000000000000' +
			'0000000000000000000000000000000000000000000000000000000000000001' +
			'000000000000000000000000' + web3.eth.accounts[0].slice(-40),
			{ encoding: 'hex' }
		);
		return transactionPromise(
			'UnanimousConsent', 
			'consent', 
			web3.eth.accounts[0], 
			'0',
			hash
		);
	}).then(function() {
		console.log("%c 1/2 consent given", "color: #00ff00");
		return transactionPromise(
			'UnanimousConsent', 
			'consent', 
			web3.eth.accounts[1], 
			'0',
			hash
		);
	}).then(function() {
		console.log("%c 2/2 consent given", "color: #00ff00");
		return transactionPromise(
			'UnanimousConsent', 
			'eval', 
			web3.eth.accounts[0], 
			'0',
			'["0x000000000000000000000000' + address.slice(-40) + '"]',
			'["0xcbf0b0c000000000000000000000000000000000000000000000000000000000"]',
			'[1]',
			'["0x00000000000000000000000035924497da1cfdab80eaeca2e852ddf47a28c05f"]'
		);
	}).then(function() {
		return new Promise(function(resolve, reject) {
			web3.eth.getCode(address, function(error, result) {
				if (result == 0 || result == "0x") {
					console.log("%c Kill was Successful", "color: #00ff00");
				} else {
					console.log("%c Kill was Unsuccessful", "color: #ff0000");
				}
				resolve(result);
			});
		});
	}).then(function() {
		return creationPromise('UnanimousConsent',
					'UnanimousConsentABI',
					web3.eth.accounts[0],
					'0',
					UnanimousConsentBytecode,
					web3.eth.accounts);
	}).then(function(result) {
		console.log("%c State Channels successfully switched", "color: #00ff00");
		address = result;
		hash = '';
	}, function (error) {
		console.error(error);
	});
}
