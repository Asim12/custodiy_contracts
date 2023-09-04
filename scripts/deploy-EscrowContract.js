require('dotenv').config();
const { ether_mai, PUBLIC_KEY_OWNER } = process.env;
async function main() {
    const Web3 = require('web3');
    // const web3 = new Web3(ether_mai);

    const web3 = new Web3(new Web3.providers.HttpProvider(ether_mai));
    let balance = await web3.eth.getBalance(PUBLIC_KEY_OWNER)
    const balanceInEth = web3.utils.fromWei(balance, 'ether');
    const gasPrice = await web3.eth.getGasPrice();
    const newGasPrice = gasPrice*2;
    const gasPriceInEth = web3.utils.fromWei(newGasPrice.toString(), 'ether');
    let gasLimitM = 57090197
    const gasLimitMan = web3.utils.fromWei(gasLimitM.toString(), 'ether');

    console.log("gasLimitMan ====>>>>>>", gasLimitMan)
    console.log("balanceInEth ====>>>>>>", balanceInEth)
    console.log("gas price ===>>>>>",gasPriceInEth, " Gas price in gei ==>>>", newGasPrice);
    console.log("balance ===>>>>>>", balanceInEth, " > ",  (Number(gasPriceInEth) + Number(gasLimitMan)).toString());

    const Contract = await ethers.getContractFactory("EscrowContract")
    const contractInstance = await Contract.deploy()
    // const contractInstance = await Contract.deploy({
    //     gasLimit: gasLimitM,
    //     gasPrice: newGasPrice 
    // })
    console.log(`Contract deployed to "${contractInstance.address}"`);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })