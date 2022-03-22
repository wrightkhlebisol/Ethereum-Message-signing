const EthCrypto = require("eth-crypto");
const signerIdentity = EthCrypto.createIdentity();
console.log({ signerIdentity });
const hashedMessage = EthCrypto.hash.keccak256([
	{ type: "uint256", value: "5" },
	{ type: "string", value: "Hello World!" }
]);
const signature = EthCrypto.sign(signerIdentity.privateKey, hashedMessage);

console.log(`Hashed Message: ${hashedMessage}`);
console.log(`Signature: ${signature}`);
console.log(`Signer Address: ${signerIdentity.address}`);
