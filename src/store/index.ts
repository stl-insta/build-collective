import { createStore } from 'vuex'
import * as Ethereum from '../services/ethereum'

export default createStore({
  state: {
    contract: null,
    account: {
      address: null,
      balance: 0,
    },
    // members: [
    //   { id: 1, name: 'wlin', selected: true },
    //   { id: 2, name: 'mamy', selected: true },
    //   { id: 3, name: 'prof', selected: false },
    //   { id: 4, name: 'leo', selected: false },
    //   { id: 5, name: 'ale', selected: false },
    // ],
    members: [],
  },
  mutations: {
    updateEthereum(state, { address, contract, balance }) {
      state.account.address = address
      state.account.balance = balance
      state.contract = contract
    },
  },
  actions: {
    async ethereumConnect(context) {
      const response = await Ethereum.connect()
      if (response) {
        const { address, contract, balance } = response
        context.commit('updateEthereum', { address, contract, balance })
      }
    },
    updateMembers({ commit }, items) {
      console.log('store', items)
      commit('updateMembers', items)
    },
  },
  modules: {},
})
