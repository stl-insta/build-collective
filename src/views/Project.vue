<template lang="html">
  <div>
    Create project here
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
      </card>
    </form>
  </div>
  <div>
    <div v-for="project in projects" v-bind:key="project.id">
      <div>Id: {{ project.id }}</div>
      <div>Name: {{ project.name }}</div>
      <div>Balance: {{ project.balance }} token</div>
      <div>
        <input v-model="donations[project.id]">
        <button @click="sponsor(project.id)">Give support</button>
      </div>

    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from "vue"
import { useStore } from "vuex"
import Card from "@/components/Card.vue"

export default defineComponent({
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const projects: any[] = []
    const name = ""
    const donations: Record<number, number> = {}
    return { projects, name, donations }
  },
  methods: {
    async updateProjects() {
      const { contract } = this
      this.projects = await contract.methods.getProjects().call()
    },
    async create() {
      const { contract, name } = this
      await contract.methods.createProject(name).send()
      await this.updateProjects()
      this.name = ""
    },
    async sponsor(id: number) {
      const { contract, donations } = this
      console.log(donations[id])
      await contract.methods.sponsorProject(id, donations[id]).send()
      await this.updateProjects()
      this.donations[id] = 0
    },
  },
  async mounted() {
    const { contract } = this
    this.projects = await contract.methods.getProjects().call()
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
</style>
