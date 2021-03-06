<template lang="html">
  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Enter your username here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <input
          type="text"
          class="input"
          v-model="username"
          placeholder="Type your username here"
        />
      </card>
    </form>
  </div>
  <div class="home" v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">1 eth = 200 tokens</div>
        <div class="explanations">
          <label>Top up your account with :</label>
          <input type="number" v-model="amount" />
          <Spacer :size="24" />
          <div class="center">
            <button class="btn" @click="addTokens">Credit</button>
          </div>
          <Spacer :size="24" />
        </div>
      </card>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from "vue"
import { useStore } from "vuex"
import Card from "@/components/Card.vue"
import Spacer from "@/components/Spacer.vue"
import Web3 from "web3"

export default defineComponent({
  components: { Card, Spacer },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const username = ""
    const amount = 200
    return { account, username, amount }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
    },
    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, "_")
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ""
    },
    async addTokens() {
      const { contract, address } = this
      const fee: string = await contract.methods.getTopUpFee(this.amount).call()
      const wei = Web3.utils.toWei(fee, "ether")
      await contract.methods.addBalance(this.amount).send({
        from: address,
        value: +wei,
      })
      await this.updateAccount()
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.input {
  background: #1e1922;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.center {
  display: flex;
  justify-content: center;
}

.btn {
  background-color: rgb(89, 25, 138);
  border: none;
  color: white;
  padding: 1rem;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 1rem;
  font-weight: bold;
  margin: 4px 2px;
  cursor: pointer;
  border-radius: 6px;
}
</style>
