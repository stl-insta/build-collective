import { createStore } from 'vuex'
import * as Ethereum from '../services/ethereum'

export default createStore({
  state: {
    contracts: {},
    account: {
      address: null,
      balance: 0,
    },
  },
  mutations: {
    updateEthereum(state, { address, contracts, balance }) {
      state.account.address = address
      state.account.balance = balance
      state.contracts = contracts
    },
  },
  actions: {
    async ethereumConnect(context) {
      const response = await Ethereum.connect()
      if (response) {
        const { address, contracts, balance } = response
        context.commit('updateEthereum', { address, contracts, balance })
      }
    },
  },
  modules: {},
})
