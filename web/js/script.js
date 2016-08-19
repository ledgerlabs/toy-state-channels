if (typeof web3 !== 'undefined') {
	web3 = new Web3(web3.currentProvider);
} else {
	// set the provider you want from Web3.providers
	web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

var UnanimousConsent;

function addUnanimousConsentParticipant(form) {
	$(form).find(".participants").append("<li>" +form.address.value +"</li>");
}

function clearUnanimousConsentParticipants(form) {
	$(form).find(".participants").empty();
}

function createUnanimousConsent(form) {
	var addresses = $(form).find(".participants li").map(
			function () {
				return $(this).text();
			}).get();

//	UnanimousConsent = web3.eth.contract(/*unanimous interface*/).new(
//			addresses,
//			{
//				from: web3.eth.accounts[$('#sender').val()],
//				data: /*unanimous code*/,
//				gas: 4700000
//			},
//			if (typeof contract.address !== 'undefined') {
//				// TODO: make this work $('#existingContract input[name=address]').val(contract.address);
//				localStorage.setItem('unanimousAddress', contract.address);
//				alert('Contract has been mined at: ' +contract.address);
//			} else {
//				alert('Contract transaction: ' +contract.transactionHash);
//			});
}

$(document).ready(function () {
	for (var i = 0; i < web3.eth.accounts.length; i++) {
		$('.addresses').append("<option value=\"" +i +"\">" +web3.eth.accounts[i] +"</option>");
	}

	// TODO: Persistent state
	// if (localStorage.getItem('address')) {
	// 	$('#existingContract input[name=address]').val(localStorage.getItem('unanimouAddress'));
	// }
});
