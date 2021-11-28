<template lang="html">
  <div class="home">
    <form @submit.prevent="create">
      <Card
        title="Enter your company information"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <Spacer :size="24" />
        <label for="name">Company name</label>
        <input
          type="text"
          class="input"
          id="name"
          v-model="name"
          placeholder="Type your company name here"
          required="required"
        />
        <label for="companyBalance">Balance</label>
        <input
          type="number"
          class="input"
          id="companyBalance"
          v-model="companyBalance"
          placeholder="Type your balance here (only number)"
        />
        <Spacer :size="24" />
        <div class="center">
          <input class="btn" type="submit" value="Create" />
        </div>
        <Spacer :size="24" />
      </Card>
    </form>

    <h3>List of companies (click on company name to add members)</h3>
    <table>
      <tr>
        <th>Id</th>
        <th>Name</th>
        <th>Owner</th>
        <th>Balance</th>
      </tr>
      <tr v-for="company in companies" v-bind:key="company.id">
        <td>{{ company.id }}</td>
        <td>
          <router-link class="link" :to="`/company/${company.id}`">
            {{ company.name }}
          </router-link>
        </td>
        <td>{{ company.owner }}</td>
        <td>{{ company.balance }} token</td>
      </tr>
    </table>
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
      const { contract, name, companyBalance } = this
      await contract.methods.createCompany(name, companyBalance).send()
      await this.updateUsers()
      this.name = ""
      this.companyBalance = 0
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

label {
  padding: 12px;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  font-weight: 900;
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

table {
  border-collapse: collapse;
  width: 100%;
}

table td,
table th {
  border: 1px solid #ddd;
  padding: 8px;
}

table th {
  padding-top: 12px;
  padding-bottom: 12px;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  font-weight: 900;
  text-align: left;
  background: rgb(89, 25, 138);
}

.link {
  cursor: pointer;
}
.link:hover {
  color: rgb(78, 125, 187);
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
