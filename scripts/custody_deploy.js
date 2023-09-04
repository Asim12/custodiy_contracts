
require('dotenv').config();
const {scriptionId} = process.env;
async function main() {
    const Contract = await ethers.getContractFactory("custody")
    const contractInstance = await Contract.deploy()
    console.log(`Contract deployed to "${contractInstance.address}"`);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })