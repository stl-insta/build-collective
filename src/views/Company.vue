<template lang="html">
  <div class="home">
    <form @submit.prevent="create">
      <Card
        title="Enter your company information"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <spacer :size="24" />
        <label for="name">Company name</label>
        <input
          type="text"
          class="input"
          id="name"
          v-model="name"
          placeholder="Type your company name here"
        />
        <label for="companyBalance">Balance</label>
        <input
          type="number"
          class="input"
          id="companyBalance"
          v-model="companyBalance"
          placeholder="Type your balance here (only number)"
        />
        <label for="members">List of members</label>
        <div id="members">
          <ul v-for="user in users" :key="user">
            <li>
              <label>
                <input type="checkbox" />
                {{ user }}
              </label>
            </li>
          </ul>
          <p>Selected members: {{ users }}</p>
        </div>
        <spacer :size="24" />
        <div class="center">
          <input class="btn" type="submit" value="Create" />
        </div>
        <spacer :size="24" />
      </Card>
    </form>

    <div v-for="company in companies" v-bind:key="company.id">
      <div>Name: {{ company.name }}</div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from "vue"
import { useStore } from "vuex"
import Card from "@/components/Card.vue"
import Spacer from "@/components/Spacer.vue"

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
    const name = ""
    const companyBalance = 0
    const users = Array<string>()
    const companies = Array<string>()
    return { account, name, companyBalance, users, companies }
  },
  methods: {
    async updateUsers() {
      const { contract } = this
      this.users = await contract.methods.getAllUsers().call()
      this.companies = await contract.methods.getCompanies().call()
    },
    async create() {
      const { contract, name } = this
      await contract.methods.createCompany(name).send()
      await this.updateUsers()
      this.name = ""
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    this.users = await contract.methods.getAllUsers().call()
    this.companies = await contract.methods.getCompanies().call()
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
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
.select {
  display: block;
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

label {
  padding: 12px;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  font-weight: 900;
}

#members label {
  text-transform: unset;
  font-size: 1rem;
  font-weight: normal;
}

p {
  margin: 0;
  padding: 0 12px;
  font-size: 1rem;
}

.center {
  display: flex;
  justify-content: center;
}
</style>
