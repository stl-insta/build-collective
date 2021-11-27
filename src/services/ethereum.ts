import Web3 from 'web3'
import BuildCollectiveInterface from '../build/contracts/BuildCollective.json'
import ProjectFactoryInterface from '../build/contracts/ProjectFactory.json'

const win: any = window

const getAccount = async (): Promise<string> => {
  const method = 'eth_requestAccounts'
  const [account] = await win.ethereum.request({ method })
  return account
}

const getBalance = async (account: string) => {
  const method = 'eth_getBalance'
  const params = [account, 'latest']
  const balance = await win.ethereum.request({ method, params })
  return Web3.utils.fromWei(balance)
}

export const connect = async () => {
  if (win.ethereum) {
    const web3 = new Web3(win.ethereum)
    try {
      const account = await getAccount()
      const balance = await getBalance(account)
      const bc_abi: any = BuildCollectiveInterface.abi
      const pf_abi: any = ProjectFactoryInterface.abi
      const bc_address = BuildCollectiveInterface.networks['5777'].address
      const pf_address = ProjectFactoryInterface.networks['5777'].address
      const contracts = {
        BuildCollective: new web3.eth.Contract(bc_abi, bc_address, { from: account }),
        ProjectFactory: new web3.eth.Contract(pf_abi, pf_address, { from: account }),
      }
      return { address: account, contracts, balance }
    } catch (error) {
      console.error(error)
    }
  } else {
    console.log('Not Dapp browser.')
  }
}
