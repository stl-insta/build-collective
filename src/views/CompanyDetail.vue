<template lang="html">
  <div class="home" v-if="company">
    <Card :title="`Company Details : ${company.name}`">
      <Spacer :size="24" />
      <div class="label">Id :</div>
      <p>{{ company.id }}</p>
      <div class="label">Name :</div>
      <p>{{ company.name }}</p>
      <div class="label">Owner :</div>
      <p>{{ company.owner }}</p>
      <div class="label">Balance :</div>
      <p>{{ company.balance }}</p>
      <div class="label">List of members</div>
      <div v-if="members.length > 0" id="members">
        <ul v-for="member in members" :key="member">
          <li>
            {{ member }}
          </li>
        </ul>
      </div>
      <p v-else>No member in this company, you can add</p>
      <Spacer :size="24" />
      <div class="center">
        <button class="btn" @click="toggle = !toggle">Add Members</button>
      </div>
      <form v-show="toggle" @submit.prevent="addMember(company.id, users)">
        <Spacer :size="24" />
        <div class="label">List of users</div>
        <div id="users">
          <ul v-for="user in users" :key="user">
            <li>
              <label :for="user">
                <input
                  type="checkbox"
                  :id="user"
                  :value="user"
                  v-model="selectedUsers"
                />
                {{ user }}
              </label>
            </li>
          </ul>
        </div>
        <Spacer :size="24" />
        <div class="center">
          <input class="btn" type="submit" value="Submit" />
        </div>
        <Spacer :size="24" />
      </form>
      <Spacer :size="24" />
    </Card>
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
    const users = Array<string>()
    const selectedUsers = Array<string>()
    const members: any[] = []
    const company: any = []
    const toggle = false
    return { users, selectedUsers, members, company, toggle }
  },
  methods: {
    async updateMembers() {
      const { contract, company } = this
      this.members = await contract.methods.getCompanyMember(company.id).call()
    },
    async addMember() {
      const { contract, company, selectedUsers } = this
      for (let i = 0; i < selectedUsers.length; i++) {
        await contract.methods.addMember(company.id, selectedUsers[i]).send()
      }
      await this.updateMembers()
    },
  },
  async mounted() {
    const { contract } = this
    const companyId = this.$route.params.id
    if (companyId) {
      this.company = await contract.methods.getCompany(companyId).call()
      this.members = await contract.methods.getCompanyMember(companyId).call()
    }
    this.users = await contract.methods.getAllUsers().call()
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

.label {
  padding: 4px 12px;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  font-weight: 900;
}

.label ~ p {
  margin: 0;
  padding: 0 12px;
  padding-bottom: 1rem;
  font-size: 1rem;
}

.center {
  display: flex;
  justify-content: center;
}

form ul {
  margin: 0;
  padding: 4px 12px;
  list-style-type: none;
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
