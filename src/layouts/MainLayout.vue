<template>
  <q-layout
    view="hHh lpr fff"
  >
    <q-header
      elevated
    >
      <q-toolbar>
        <q-toolbar-title
          class="text-h6 text-weight-regular"
        >
          <span
            v-text="'URL Shortener'"
          />
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page-container>
      <router-view />
    </q-page-container>
    <q-footer
      v-show="mounted"
      elevated
    >
      <q-toolbar>
        <q-toolbar-title
          class="text-caption text-weight-light text-center"
        >
          <span
            style="cursor: pointer;"
            @click="explore"
            v-text="`© ${new Date().getFullYear()} Memo Chou`"
          />
        </q-toolbar-title>
      </q-toolbar>
    </q-footer>
  </q-layout>
</template>

<script>
import {
  defineComponent,
  onMounted,
  ref,
} from 'vue';

export default defineComponent({
  name: 'MainLayout',
  setup() {
    const mounted = ref(false);
    onMounted(() => {
      mounted.value = true;
    });
    const explore = () => {
      window.open('https://github.com/memochou1993/shortener', '_blank', 'noopener noreferrer');
    };
    return {
      mounted,
      explore,
    };
  },
});
</script>
