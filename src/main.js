// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import './assets/css/bootstrap.css'
import './assets/css/reset.css'
import './assets/css/index.css'
import './assets/css/font-awesome.min.css'
import './assets/css/livemap.css'
import './assets/css/leftCtrl.css'
import './assets/css/velset.css'
import './assets/css/login.css'

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
