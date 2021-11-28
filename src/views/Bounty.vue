<template lang="html">
  <div class="home" v-if="project">
    <form @submit.prevent="create">
      <Card :title="`Create bounty description for ${project.name}`">
        <Spacer :size="24" />
        <label for="name">Bounty name</label>
        <input
          type="text"
          class="input"
          id="name"
          v-model="name"
          placeholder="Type your bounty name here"
        />
        <label for="reward">Reward</label>
        <input
          type="number"
          class="input"
          id="reward"
          v-model="reward"
          placeholder="Type your reward here"
        />
        <Spacer :size="24" />
        <div class="center">
          <input class="btn" type="submit" value="Create" />
        </div>
        <Spacer :size="24" />
      </Card>
    </form>
  </div>
  <div class="home">
    <h3>List of all bounties (click on bounty name to see details)</h3>
    <table>
      <tr>
        <th>Id</th>
        <th>Name</th>
        <th>Reward</th>
        <th>Status</th>
        <th>Project Name</th>
      </tr>
      <tr v-for="bounty in bounties" v-bind:key="bounty.id">
        <td>{{ bounty.id }}</td>
        <td>
          <router-link class="link" :to="`/bounty/${bounty.id}`">
            {{ bounty.name }}
          </router-link>
        </td>
        <td>{{ bounty.reward }} token</td>
        <td>{{ bounty.status == 1 ? "In Progress" : "Fixed" }}</td>
        <td>
          <router-link
            class="link"
            :to="`/project/${bountiesProject[bounty.id].id}`"
          >
            {{ bountiesProject[bounty.id].name }}
          </router-link>
        </td>
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
        this.bountiesProject[bounty.id] = await contract.methods
          .getProjectOfBounty(bounty.id)
          .call()
        const fixes = await contract.methods.getFixesOfBounty(bounty.id).call()
        this.fixesOfBounty[bounty.id] = fixes.filter(
          (f: any) => f.proposition !== ""
        )
      }
    },
    async createFixForBounty(id: number) {
      const { contract } = this
      await contract.methods.createFix(id, this.fixPropositions[id]).send()
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
</style>
