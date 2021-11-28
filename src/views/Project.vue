<template lang="html">
  <div>
    Give your project a name
    <form @submit.prevent="create">
      <card
        title="Project name"
      >
        <input
          type="text"
          class="input-username"
          v-model="name"
          placeholder="Type your project name here"
        />
        <div class="center">
          <input class="btn" type="submit" value="Create" />
        </div>
      </card>
    </form>
  </div>
  <spacer :size="24" />
  <div>
    <div
      class="project-item"
      v-for="project in projects"
      v-bind:key="project.id"
    >
      <div>Id: {{ project.id }}</div>
      <div>Name: {{ project.name }}</div>
      <div>Balance: {{ project.balance }} token</div>
      <div>
        <input v-model="donations[project.id]">
        <label>tokens</label>
        <button @click="sponsor(project.id)">Give support</button>
      </div>
      <spacer :size="24" />
      <div v-if="project.balance > 0">
        <label>You can create a bounty for this project</label>
        <button
          @click="
            $router.push({ name: 'CreateBounty', params: { id: project.id } })
          "
        >
          Create Bounty
        </button>
      </div>
      <div v-if="project.balance == 0">
        Your project does not have enough balance to create a Bounty
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
    const projects: any[] = []
    const name = "My Project"
    const donations: Record<number, number> = {}
    return { projects, name, donations }
  },
  methods: {
    async updateProjects() {
      const { contract, donations } = this
      this.projects = await contract.methods.getProjects().call()
      this.projects.forEach(p => (donations[p.id] = 10))
    },
    async create() {
      const { contract, name } = this
      await contract.methods.createProject(name).send()
      await this.updateProjects()
      this.name = ""
    },
    async sponsor(id: number) {
      const { contract, donations } = this
      await contract.methods.sponsorProject(id, donations[id]).send()
      await this.updateProjects()
    },
  },
  async mounted() {
    await this.updateProjects()
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

.project-item {
  border: 1px solid white;
  padding: 5px;
}
</style>
