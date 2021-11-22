<template lang="html">
  <div class="home">
    <!-- <div class="home" v-if="company"> -->
    <!-- <form @submit.prevent="signUp"> -->
    <form>
      <Card
        title="Enter your company information"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <spacer :size="24" />
        <label for="name">Company name</label>
        <input
          type="text"
          class="input"
          id="name"
          v-model="name"
          placeholder="Type your company name here"
        />
        <!-- <label for="owner">Company owner</label>
        <select class="select" id="owner" v-model="selectedOwner">
          <option value="" disabled>Select an owner</option>
          <option :key="index" v-for="(owner, index) in users" selectedOwner>
            {{ owner }}
          </option>
        </select> -->
        <p>Selected: {{ selectedOwner }}</p>
        <label for="member">List of members</label>
        <select class="select" id="member" v-model="selectedMembers">
          <option selectedMembers>A</option>
          <option>B</option>
          <option>C</option>
        </select>
        <p>Selected: {{ selectedMembers }}</p>
        <label for="owner">List of projects</label>
        <select class="select" id="owner" v-model="selectedProjects">
          <option selectedProjects>A</option>
          <option>B</option>
          <option>C</option>
        </select>
        <p>Selected: {{ selectedProjects }}</p>
      </Card>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
// import { defineComponent, computed } from 'vue'
// import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'

export default defineComponent({
  components: { Card, Spacer },
  // setup() {},
  // data() {
  //   const users = ['wlin', 'mamy', 'prof']
  //   const selectedOwner = ''
  // },
  // // methods: {},
  // async mounted() {
  //   this.selectedOwner = 'prof'
  // },
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
.select {
  display: block;
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

label {
  padding: 12px;
  font-size: 1.2rem;
}

p {
  margin: 0;
  padding: 0 12px;
  font-size: 1rem;
}
</style>
