<template>
  <li>
    <label>
      {{ name }}
      <input
        type="checkbox"
        :checked="selected"
        @click="$emit('change', event.target.checked)"
      />
    </label>
  </li>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Checkbox',
  props: {
    selected: Boolean,
    name: String,
  },
  // emits: ['change'],
  model: {
    prop: 'selected',
    event: 'change',
  },
})
</script>

<style lang="css" scoped></style>
