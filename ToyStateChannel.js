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

function address(form) {
        var participants = window.open("", "", "");
        participants.document.write('<script src="https://code.jquery.com/jquery-3.0.0.min.js" integrity="sha256-JmvOoLtYsmqlsWxa7mDSLMwa6dZ9rrIdtrrVYRnDRH0=" crossorigin="anonymous"></script>');
        participants.document.write('<script src="/web3.js/dist/web3.min.js"></script>');
        participants.document.write('<script src="/constants.js"></script>');
        participants.document.write('<script src="/tests.js"></script>');
        participants.document.write('<script src="/ToyStateChannel.js"></script>');
	participants.document.write('<link rel="stylesheet" type="text/css" href="styles.css" />');
        participants.document.write('<form>');
        participants.document.write('<h1> Enter Your Addresses </h1>');
        for (var i = 0; i < form.numParticipants.value; ++i) {
                participants.document.write('<input type="text" name="participant" class="text" />');
                participants.document.write('<br /><br />');
        }
        participants.document.write('<input type="button" class="button" value="Create" onclick="create(this.form)"/>');
        participants.document.write('</form>');
}

function create(form) {
        var list = '[';
        $(':input[name="participant"]').each(function() {
                list += ($(this).val()) + ',';
        });
        list = list.slice(0, list.length - 1);
        list += ']';
        creationPromise(
                'UnanimousConsent',
                'UnanimousConsentABI',
                web3.eth.accounts[0],
                '0',
                UnanimousConsentBytecode,
                list
        ).then(function(result) {
                alert("Now close this window to use your state channel!");
        }, function(error) {
                console.error(error);
        });
}

function attachToContract(form) {
	UnanimousConsent = web3.eth.contract(UnanimousConsentABI).at(form.attachAddress.value);
	alert("You are attached to contract " + form.attachAddress.value);
}
