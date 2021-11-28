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
      <div>
        <div>Project name: {{ bountiesProject[bounty.id].name }}</div>
        <div>Project id: {{ bountiesProject[bounty.id].id }}</div>
      </div>
      <spacer :size="24" />
      <div>
        <label>You can propose a fix for this bounty</label>
        <button @click="$router.push({ name: 'fix' })">Propose Fix</button>
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
    return { name, reward, project, bounties, bountiesProject }
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
      }
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
