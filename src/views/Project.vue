<template lang="html">
  <div class="home">
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
  <div class="home">
    <ul v-for="project in projects" v-bind:key="project.name">
      <li>{{ project.name }}</li>
    </ul>
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
    const contracts = computed(() => store.state.contracts)
    return { address, contracts, balance }
  },
  data() {
    const projects: any[] = []
    const name = ""
    return { projects, name }
  },
  methods: {
    async updateProjects() {
      const { contracts } = this
      this.projects = await contracts.ProjectFactory.methods.getProjects().call()
    },
    async create() {
      const { contracts, name } = this
      await contracts.ProjectFactory.methods.createProject(name).send()
      await this.updateProjects()
      this.name = ""
    },
  },
  async mounted() {
    const { contracts } = this
    this.projects = await contracts.ProjectFactory.methods.getProjects().call()
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
