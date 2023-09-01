const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.pushesloja = functions.firestore
	.document('Solicitacoes-Entregas/{token}')
	.onUpdate((change, context) => {

		const document = change.after.exists ? change.after.data() : null;

		console.log('document is', document);

		admin.firestore().collection("DeviceTokens").get().then(
			result  => {
				var registrationToken = [];
				result.docs.forEach(
					tokenDocument => {		
						registrationToken.push(tokenDocument.data().token);
					}
				);
				var message = {
					data: {
						title: "O status da sua entrega mudou!",
						body: "O produto " + document.NomedoProduto +" mudou o status da entrega mudou para  "  + document.statusDoProduto + ". " + "Com o entregador: " + document.entreguePor + " " + document.idLoja,
					},
					tokens: registrationToken,
				}
				
				console.log(message);
		
				console.log('token é :', registrationToken);
		
				admin.messaging().sendMulticast(message)
					.then((response) => {
						if (response.failureCount > 0) {
							const failedTokens = [];
							response.responses.forEach((resp, idx) => {
							  if (!resp.success) {
								failedTokens.push(registrationTokens[idx]);
							  }
							});
							console.log('List of tokens that caused failures: ' + failedTokens);
						  }
					})
			}
		);
		return Promise.resolve(0);
	});

