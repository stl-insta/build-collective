<template>
  <ul>
    <!-- <Checkbox name="All" v-model="checkAll" /> -->
    <Checkbox
      v-for="item in items"
      :key="item.id"
      :name="item.name"
      :selected="item.selected"
      @change="this.onChangeItem(item, $event)"
    />
  </ul>
</template>

<script>
import { defineComponent } from 'vue'
import Checkbox from '@/components/Checkbox.vue'

export default defineComponent({
  components: { Checkbox },
  name: 'CheckboxContainer',
  props: {
    items: Array,
  },
  methods: {
    onChangeItem(changeItem, event) {
      const result = this.items.map(item => {
        const updateItem = Object.assign({}, item)
        // console.log('changeItem =>', changeItem.id)
        // console.log('updateItem.id =>', updateItem.id)
        if (updateItem.id === changeItem.id) {
          updateItem.selected = event.target.checked
        }
        return updateItem
      })
      this.$emit('updateItems', result)
      console.log('result =>', result)
    },
  },
  computed: {
    // checkAll: {
    //   get() {
    //     console.log('items all =>', this.items)
    //     return this.items.every(item => item.selected)
    //   },
    //   set(event) {
    //     const result = this.items.map(item => {
    //       const updateItem = Object.assign({}, item)
    //       updateItem.selected = event.target.checked
    //       return updateItem
    //     })
    //     this.$emit('updateItems', result)
    //     console.log('result all =>', result)
    //   },
    // },
  },
})
</script>

<style lang="css" scoped></style>
