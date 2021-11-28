<template lang="html">
  <div class="create" v-if="project">
    <div>
      Create a bounty for bounty {{ project.name }}
      <form @submit.prevent="create">
        <card
          title="Bounty name"
        >
          <input
            type="text"
            class="input-username"
            v-model="name"
            placeholder="Type your bounty name here"
          />
          <input
            type="number"
            class="input-username"
            v-model="reward"
            placeholder="Type your reward here"
          />
          <div class="center">
            <input class="btn" type="submit" value="Create" />
          </div>
        </card>
      </form>
    </div>
    <spacer :size="24" />
  </div>

  <div class="list">
    <label>List of all bounties</label>
    <div
      class="bounty-item"
      v-for="bounty in bounties"
      v-bind:key="bounty.id"
    >
      <div>Id: {{ bounty.id }}</div>
      <div>Name: {{ bounty.name }}</div>
      <div>Reward: {{ bounty.reward }} token</div>
      <div>Status: {{ bounty.status == 1 ? "In Progress" : "Fixed" }}</div>
      <div v-if="bountiesProject[bounty.id]">
        <div>Project name: {{ bountiesProject[bounty.id].name }}</div>
        <div>Project id: {{ bountiesProject[bounty.id].id }}</div>
      </div>
      <spacer :size="24" />

      <div v-if="bounty.status == 1">
        <div>
          <label>You can propose a fix for this bounty</label>
          <input type="text" v-model="fixPropositions[bounty.id]" placeholder="What's your solution">
          <button @click="createFixForBounty(bounty.id)">Propose Fix</button>
        </div>
        <spacer :size="24" />
        <label>List of all proposed fix</label>
        <div v-if="fixesOfBounty[bounty.id]">
          <div v-for="fix in fixesOfBounty[bounty.id]"
               v-bind:key="fix">
            <div>Proposition: {{ fix.proposition }}</div>
            <div>Owner: {{ fix.owner }}</div>
            <button @click="accept(fix.id)">Accept this fix</button>
          </div>
        </div>
      </div>

      <div v-if="bounty.status == 0">
        This bounty is fixed, you can no longer propose a fix
      </div>

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
    const name = "Fix me if you can"
    const reward = 10
    const project: any = null
    const bounties: any[] = []
    const bountiesProject: Record<number, any> = {}
    const fixPropositions: Record<number, any> = {}
    const fixesOfBounty: Record<number, any[]> = {}
    return {
      name,
      reward,
      project,
      bounties,
      bountiesProject,
      fixPropositions,
      fixesOfBounty,
    }
  },
  methods: {
    async create() {
      const { contract, name, reward, project } = this
      await contract.methods.createBounty(project.id, name, reward).send()
      await this.updateBounties()
      this.name = ""
    },
    async updateBounties() {
      const { contract } = this
      this.bounties = await contract.methods.getBounties().call()
      for (const bounty of this.bounties) {
        this.bountiesProject[bounty.id] = await contract.methods.getProjectOfBounty(bounty.id).call()
        const fixes = await contract.methods.getFixesOfBounty(bounty.id).call()
        this.fixesOfBounty[bounty.id] = fixes.filter((f: any) => f.proposition !== "")
      }
    },
    async createFixForBounty(id: number) {
      const { contract } = this
      await contract.methods.createFix(id, this.fixPropositions[id]).send()
      await this.updateBounties()
    },
    async accept(id: number) {
      const { contract } = this
      await contract.methods.acceptFix(id).send()
      await this.updateBounties()
    },
  },
  async mounted() {
    const { contract } = this
    const projectId = this.$route.params.id
    if (projectId) {
      this.project = await contract.methods.getProject(projectId).call()
    }
    await this.updateBounties()
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

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.bounty-item {
  border: 1px solid white;
  padding: 5px;
}
</style>
