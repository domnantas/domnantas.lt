import './styles/vars.css';
import Layout from './Layout.vue'
import NotFound from './NotFound.vue'

export default {
  Layout,
  NotFound,
  enhanceApp({ app, router, siteData }) {
    // app is the Vue 3 app instance from `createApp()`. router is VitePress'
    // custom router. `siteData`` is a `ref`` of current site-level metadata.
  }
}