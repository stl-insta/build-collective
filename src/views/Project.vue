<template lang="html">
  <div class="home">
    <form @submit.prevent="create">
      <Card title="Create your project">
        <Spacer :size="24" />
        <label for="name">Project name</label>
        <input
          id="name"
          type="text"
          class="input"
          v-model="name"
          placeholder="Type your project name here"
          required="required"
        />
        <Spacer :size="24" />
        <div class="center">
          <input class="btn" type="submit" value="Create" />
        </div>
        <Spacer :size="24" />
      </Card>
    </form>

    <h3>List of project (click on project name to see details)</h3>
    <table>
      <tr>
        <th>Id</th>
        <th>Name</th>
        <th>Balance</th>
      </tr>
      <tr v-for="project in projects" v-bind:key="project.id">
        <td>{{ project.id }}</td>
        <td>
          <router-link class="link" :to="`/project/${project.id}`">
            {{ project.name }}
          </router-link>
        </td>
        <td>{{ project.balance }} token</td>
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
    const projects: any[] = []
    const name = ""
    return { projects, name }
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

.project-item {
  border: 1px solid white;
  padding: 5px;
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
