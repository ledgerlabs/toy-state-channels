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
* In case client is the one making ECDSASignatureProxy
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
function nonceOpAddActionInstantiation(form) {
        var rawTransaction = counterfactualCalls(
                'addAction(address,bytes4,bytes32[])',
                // TODO: define NonceCompareOpSingletonAddress
                NonceCompareOpSingletonAddress,
                web3.sha3('getNonceCompareOp()').slice(0, 10)
        );

        var hash = web3.sha3(
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

function nonceOpConsentInstantiation(form) {
        var rawTransaction = counterfactualCalls(
                'consent(bytes32[])',
                form.actionHash.value
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

function nonceOpInstantiate(form) {
        var rawTransaction = counterfactualCalls(
                'eval(bytes32[])',
                form.actionHashEval.value
        );

        $('#NonceOpEval').append(
                '<tr><td>' +
                form.actionHashEval.value +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}

//////Counterfactually instantiate adjudicator/////////////////
function adjudicatorConsentInstantiation(form) {
        var rawTransaction = counterfactualCall(
                'addAction(address,bytes4,bytes32[])',
                // TODO: define adjudicatorFactoryAddress
                adjudicatorFactoryAddress,
                // TODO; get actual method name from adjudicator factory
                web3.sha3('addAdjudicator(CompareOp,address,uint)').slice(0, 10),
                bytes32Padding(localStorage.getItem('nonceCompareOpAddress').slice(-40)),
                bytes32Padding(localStorage.getItem('unanimousAddress').slice(-40)),
                bytes32Padding(parseInt(form.timeout.value).toString(16))
        );

        var hash = web3.sha3(
                adjudicatorFactoryAddress,
                'addAdjudicator(CompareOp,address,uint)',
                bytes32Padding(localStorage.getItem('nonceCompareOpAddress').slice(-40)),
                bytes32Padding(localStorage.getItem('unanimousAddress').slice(-40)),
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

function adjudicatorConsentInstantiation(form) {
        // Sign consent
        var signature = web3.eth.sign(form.actionHash.value);
        var r = signature.slice(0, 66);
        var s = '0x' + signature.slice(66, 130);
        var v = '0x' + signature.slice(-2);

        var rawTransaction = counterfactualCall(
                'consent(bytes32[])',
                form.actoinHash.value
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

function adjudicatorInstantiate(form) {
        var rawTransaction = counterfactualCalls(
                'eval(bytes32[])',
                form.actionHashEval.value
        );

        $('#AdjudicatorEval').append(
                '<tr><td>' +
                form.actionHashEval.value +
                '</td><td>' +
                rawTransaction +
                '</td>'
        );
}
