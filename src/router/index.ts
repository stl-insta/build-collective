import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },
  {
    path: '/company',
    name: 'Company',
    component: () => import('@/views/Company.vue'),
  },
  {
    path: '/company/:id',
    name: 'CompanyDetail',
    component: () => import('@/views/CompanyDetail.vue'),
  },
  {
    path: '/project',
    name: 'Project',
    component: () => import('@/views/Project.vue'),
  },
  {
    path: '/project/:id',
    name: 'ProjectDetail',
    component: () => import('@/views/ProjectDetail.vue'),
  },
  {
    path: '/bounty/create/:id',
    name: 'Bounty',
    component: () => import('@/views/Bounty.vue'),
  },
  {
    path: '/bounty',
    name: 'Bounty',
    component: () => import('@/views/Bounty.vue'),
  },
  {
    path: '/bounty/:id',
    name: 'BountyDetail',
    component: () => import('@/views/BountyDetail.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
