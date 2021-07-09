<template>
  <q-layout
    view="hHh lpr fFf"
  >
    <q-header
      elevated
    >
      <q-toolbar>
        <q-toolbar-title
          class="text-h6 text-weight-regular"
        >
          URL Shortener
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'MainLayout',
});
</script>
