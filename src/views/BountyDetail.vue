<template lang="html">
  <div class="home" v-if="bounty">
    <Card :title="`Bounty Details : ${bounty.name}`">
      <Spacer :size="24" />
      <div class="label">Id :</div>
      <p>{{ bounty.id }}</p>
      <div class="label">Name :</div>
      <p>{{ bounty.name }}</p>
      <div class="label">Reward :</div>
      <p>{{ bounty.reward }} token</p>
      <div class="label">Project :</div>
      <p>
        <router-link class="link" :to="`/project/${bountyProject.id}`">
          {{ bountyProject.name }}
        </router-link>
      </p>
      <div v-if="bounty.status == 1">
        <p class="label">You can propose a fix for this bounty</p>
        <div class="center">
          <input
            type="text"
            v-model="fixPropositions[bounty.id]"
            placeholder="What's your solution"
          />
          <button class="btn btn-secondary" @click="createFixForBounty()">
            Propose Fix
          </button>
        </div>
        <Spacer :size="24" />
        <label>List of all proposed fix</label>
        <div class="p-4">
          <table v-if="fixesOfBounty">
            <tr>
              <th>Proposition</th>
              <th>Owner</th>
              <th>Action</th>
            </tr>
            <tr v-for="fix in fixesOfBounty" v-bind:key="fix.id">
              <td>{{ fix.proposition }}</td>
              <td>{{ fix.owner }}</td>
              <td>
                <button class="btn btn-secondary" @click="accept(fix.id)">
                  Accept this fix
                </button>
              </td>
            </tr>
          </table>
        </div>
      </div>
      <div v-if="bounty.status == 0">
        This bounty is fixed, you can no longer propose a fix
      </div>
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
    const project: any = null
    const bounty: any = []
    const bountyProject: any = []
    const fixPropositions: Record<number, any> = {}
    const fixesOfBounty: Record<number, any[]> = {}
    return {
      project,
      bounty,
      bountyProject,
      fixPropositions,
      fixesOfBounty,
    }
  },
  methods: {
    async updateBounty() {
      const { contract, bounty } = this
      this.bounty = await contract.methods.getBounty(bounty.id).call()
      this.fixesOfBounty = await contract.methods
        .getFixesOfBounty(bounty.id)
        .call()
    },
    async createFixForBounty() {
      const { contract, bounty } = this
      await contract.methods
        .createFix(bounty.id, this.fixPropositions[bounty.id])
        .send()
      await this.updateBounty()
    },
  },
  async mounted() {
    const { contract } = this
    const bountyId = this.$route.params.id
    if (bountyId) {
      this.bounty = await contract.methods.getBounty(bountyId).call()
    }
    await this.updateBounty()
    this.bountyProject = await contract.methods
      .getProjectOfBounty(bountyId)
      .call()
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
  background: transparent;
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

p {
  margin: 0;
  padding: 0 12px;
  font-size: 1rem;
}

.center {
  display: flex;
  justify-content: center;
  justify-content: space-around;
}

.bounty-item {
  border: 1px solid white;
  padding: 5px;
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

.btn-secondary {
  background: transparent;
  border: 2px solid rgb(114, 53, 161);
  padding: 0.5rem;
  color: rgb(114, 53, 161);
}

.link {
  cursor: pointer;
}
.link:hover {
  color: rgb(78, 125, 187);
}

.block {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 4px 12px;
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

.p-4 {
  padding: 1rem;
}
</style>
