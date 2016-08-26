if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
} else {
        // set the provider you want from Web3.providers
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

var UnanimousConsent;

function addUnanimousConsentParticipant(form) {
        $(form).find(".participants").append("<li>" +web3.eth.accounts[form.participant.value] +"</li>");
}

function clearUnanimousConsentParticipants(form) {
        $(form).find(".participants").empty();
}

function createUnanimousConsent(form) {
        var addresses = $(form).find(".participants li").map(
                        function () {
                                return $(this).text();
                        }).get();

        UnanimousConsent = web3.eth.contract(UNANIMOUSCONSENT_ABI).new(
                        addresses,
                        {
                                from: web3.eth.accounts[$('#sender').val()],
                                data: UNANIMOUSCONSENT_BIN,
                                gas: 4700000
                        }, function (e, contract) {
                                if (e) {
                                        console.log(e);
                                }
                                if (typeof contract.address !== 'undefined') {
                                        // TODO: make this work $('#existingContract input[name=address]').val(contract.address);
                                        localStorage.setItem('unanimousAddress', contract.address);
                                        alert('Contract has been mined at: ' +contract.address);
                                } else {
                                        alert('Contract transaction: ' +contract.transactionHash);
                                }
                        });
}

function attach(form) {}

// This function padds its input until it's 32 bytes long
function bytes32Padding(input) {
        var padded = ''
        for (var i = 0; i < 64; ++i) {
                padded += '0';
        }
        return (padded + input).slice(-64);
}

// Helper function that passes in parameters for getRawTransactionString
// (Not entirely sure if this helper function is 100% necessary)
function counterfactualCall(methodString) {
        var parameters = Array.prototype.slice.call(arguments, 1);
        var callData = web3.sha3(methodString).slice(0, 10);
        for (var i = 0; i < parameters.length; ++i) {
                callData += bytes32Padding(parameters[i]);
        }

        var rawTransaction = getRawTransactionString(
                web3.eth.accounts[$('#sender').val()],
                localStorage.getItem('unanimousAddress'),
                '0x47b760',
                '0x00',
                callData
        );

        return rawTransaction;
}

/**
* // In case client is the one making ECDSASignatureProxy
* function createECDSASignatureProxy() {
*       web3.eth.contract(NONCECOMPAREOP_ABI).new(
*               {
*                       from: web3.eth.accounts[$('#sender').val()],
*                       data: NONCECOMPAREOP_BIN,
*                       gas: 4700000
*               }, function(e, contract) {
*                       if (e) {
*                               console.error(e);
*                               return;
*                       }
*                       if (typeof contract.address !== 'undefined') {
*                               localStorage.setItem('ECDSAAddress' + $('#sender').val(), contract.address);
*                               alert("Contract has been mined at: " + contract.address);
*                       } else {
*                               alert("Contract transaction: " + contract.transactionHash);
*                       }
*               }
*       );
* }
**/

//////Counterfactually instantiate nonceCompareOp///////////////////////
// FOLLOW THESE STEPS EXACTLY

// Step 1: sign a transaction to add the action of instantiating a nonceCompareOp
function nonceOpAddActionInstantiation(form) {
        var rawTransaction = counterfactualCalls(
                'addAction(address,bytes4,bytes32[])',
                // TODO: define NonceCompareOpSingletonAddress
                NonceCompareOpSingletonAddress,
                web3.sha3('getNonceCompareOp()').slice(0, 10)
        );

        var hash = web3.sha3(
                // NonceCompareOpSingletonAddress still needs to be defined
                NonceCompareOpSingletonAddress +
                web3.sha3('getNonceCompareOp()').slice(0, 10)
        );

        #('#NonceOpAddAction').append(
                '<tr><td>' +
                hash +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

// Step 2: all parties must sign transactions of them consenting to the action hash generated in Step 1
function nonceOpConsentInstantiation(form) {
        // TODO: test out omitting a parameter when calling a contract method
        var rawTransaction = counterfactualCalls(
                'consent(bytes32[])',
                bytes32Padding(form.actionHash.value)
        );

        $('#NonceOpConsent').append(
                '<tr><td>' +
                web3.eth.accounts[$('#sender').val()] +
                '</td><td>' +
                form.actionHash.value +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

// Step 3: sign the transaction to call eval to execute the instantiation
function nonceOpInstantiate(form) {
        var rawTransaction = counterfactualCalls(
                'eval(bytes32[])',
                bytes32Padding(form.actionHashEval.value)
        );

        // TODO: counterfactually store the address of the nonceCompareOp somewhere and somehow

        $('#NonceOpEval').append(
                '<tr><td>' +
                form.actionHashEval.value +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

// For getting NonceOpAddress
function addNonceOpAddress(rawTransaction) {
        UnanimousConsent.sendRawTransaction(rawTransaction, function(error, hash) {
                if (error) {
                        console.error(error);
                        return;
                }
                var filter = web3.eth.filter('latest');
                filter.watch(function (error, result) {
                        var receipt = web3.eth.getTransactionReceipt(hash);
                        if (receipt && receipt.transactionHash == hash && ) {
                                if (receipt.logs.topics && receipt.logs.topics.length >= 2) {
                                        // Assumption made is that NonceCompareOpSingleton has an indexed event 
                                        // that gives the address of the newly created NonceCompareOp and no other                                         // events are fired (this can be modified)
                                        localStorage.setItem('nonceCompareOpAddress', '0x' + receipt.logs.topics[1].slice(-40));
                                }
                        }
                }
        });
}

//////Counterfactually instantiate adjudicator/////////////////
// FOLLOW THESE STEPS EXACTLY ONCE NONCEOP HAS (OR COUNTERFACTUALLY HAS) AN ADDRESS

// Step 1: sign a transaction to add the action of instantiating an adjudicator 
function adjudicatorAddActionInstantiation(form) {
        var rawTransaction = counterfactualCall(
                'addAction(address,bytes4,bytes32[])',
                // TODO: define callLibAddress
                callLibAddress,
                web3.sha3('postAdjudicator(BulletinBoard,bytes32,CompareOp,address,uint256)').slice(0, 10),
                // TODO: define bulletinBoardAddress somewhere
                bytes32Padding(localStorage.getItem('bulletinBoardAddress')),
                // TODO: define id
                bytes32Padding(id),
                // TODO: call addNonceOpAddress somewhere
                bytes32Padding(localStorage.getItem('nonceCompareOpAddress').slice(-40)),
                bytes32Padding(localStorage.getItem('unanimousAddress').slice(-40)),
                bytes32Padding(parseInt(form.timeout.value).toString(16))
        );

        // See above for notes on the following to be concatenated strings
        var hash = web3.sha3(
                callLibAddress +
                web3.sha3('postAdjudicator(BulletinBoard,bytes32,CompareOp,address,uint256)').slice(0, 10) +
                bytes32Padding(localStorage.getItem('bulletinBoardAddress')) +
                bytes32Padding(someHash) +
                bytes32Padding(localStorage.getItem('nonceCompareOpAddress').slice(-40)) +
                bytes32Padding(localStorage.getItem('unanimousAddress').slice(-40)) +
                bytes32Padding(parseInt(form.timeout.value).toString(16))
        );

        $('#AdjudicatorAddAction').append(
                '<tr><td>' +
                hash +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

// Step 2: all parties must sign transactions of them consenting to the action hash generated in Step 1
function adjudicatorConsentInstantiation(form) {
        // Sign consent
        var signature = web3.eth.sign(form.actionHash.value);
        var r = signature.slice(0, 66);
        var s = '0x' + signature.slice(66, 130);
        var v = '0x' + signature.slice(-2);

        var rawTransaction = counterfactualCall(
                'consent(bytes32[])',
                bytes32Padding(form.actionHash.value)
        );

        $('#AdjudicatorConsent').append(
                '<tr><td>' +
                web3.eth.accounts[$('#sender').val()] +
                '</td><td>' +
                form.actionHash.value +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

// Step 3: sign the transaction to call eval to execute the instantiation
function adjudicatorInstantiate(form) {
        var rawTransaction = counterfactualCalls(
                'eval(bytes32[])',
                bytes32Padding(form.actionHashEval.value)
        );

        $('#AdjudicatorEval').append(
                '<tr><td>' +
                form.actionHashEval.value +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

$(document).ready(function () {
        for (var i = 0; i < web3.eth.accounts.length; i++) {
                $('.addresses').append("<option value=\"" +i +"\">" +web3.eth.accounts[i] +"</option>");
        }

        // TODO: Persistent state
        // if (localStorage.getItem('address')) {
        //      $('#existingContract input[name=address]').val(localStorage.getItem('unanimousAddress'));
        // }
});
