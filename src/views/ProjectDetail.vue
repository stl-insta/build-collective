<template lang="html">
  <div class="home" v-if="project">
    <Card :title="`Project Details : ${project.name}`">
      <Spacer :size="24" />
      <div class="label">Id :</div>
      <p>{{ project.id }}</p>
      <div class="label">Name :</div>
      <p>{{ project.name }}</p>
      <div class="label">Balance :</div>
      <p>{{ project.balance }} tokens</p>
      <Spacer :size="24" />
      <div class="block label">
        You can support this project
        <div class="pb">Make sure you have tokens (not Ether)</div>
        <div>
          <input v-model="donations[project.id]" />
          <label>tokens</label>
          <button class="btn btn-secondary" @click="sponsor(project.id)">
            Give support
          </button>
        </div>
      </div>
      <Spacer :size="24" />
      <div>
        <p class="label">You can also create a bounty</p>
        <div class="center">
          <router-link class="btn" :to="`/bounty/create/${project.id}`">
            Create Bounty
          </router-link>
        </div>
        <Spacer :size="24" />
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
    const project: any = []
    const name = "My Project"
    const donations: Record<number, number> = {}
    return { project, name, donations }
  },
  methods: {
    async updateProject() {
      const { contract, project, donations } = this
      this.project = await contract.methods.getProject(project.id).call()
      donations[project.id] = 10
    },
    async create() {
      const { contract, name } = this
      await contract.methods.createProject(name).send()
      await this.updateProject()
      this.name = ""
    },
    async sponsor(id: number) {
      const { contract, donations } = this
      await contract.methods.sponsorProject(id, donations[id]).send()
      await this.updateProject()
    },
  },
  async mounted() {
    const { contract } = this
    const projectId = this.$route.params.id
    if (projectId) {
      this.project = await contract.methods.getProject(projectId).call()
    }
    await this.updateProject()
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

.center {
  display: flex;
  justify-content: center;
}

.block {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 4px 12px;
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

.pb {
  padding-bottom: 0.5rem;
}
</style>
