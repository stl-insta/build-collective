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
        <label for="balance">Balance</label>
        <input
          type="number"
          class="input"
          id="balance"
          v-model="balance"
          placeholder="Type your balance here (only number)"
        />
        <!-- <label for="members">List of members</label>
        <div id="members" :key="index" v-for="(member, index) in members">
          <input
            type="checkbox"
            id="member"
            value="member"
            v-model="selectedMembers"
          />
          <label for="member">{{ member }}</label>
        </div>
        <p>Selected: {{ selectedMembers }}</p> -->
        <CheckboxContainer :items="members" @update="updateMembers" />
        <p>Selected: {{ members }}</p>
      </Card>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore, mapState, mapActions } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'
import CheckboxContainer from '@/components/CheckboxContainer.vue'

export default defineComponent({
  components: { Card, Spacer, CheckboxContainer },
  setup() {
    const store = useStore()
    const members = computed(() => store.state.members)
    return { members }
  },
  computed: {
    ...mapState(['members']),
  },
  methods: {
    ...mapActions(['updateMembers']),
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
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  font-weight: 900;
}

#members label {
  text-transform: unset;
  font-size: 1rem;
  font-weight: normal;
}

p {
  margin: 0;
  padding: 0 12px;
  font-size: 1rem;
}
</style>
