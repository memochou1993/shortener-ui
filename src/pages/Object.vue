<template>
  <div
    class="row items-center justify-center q-my-xl"
  >
    <div
      class="col-xs-12 col-md-8"
    >
      <q-responsive
        :ratio="16/9"
      >
        <iframe
          :src="src"
          style="border: 0;"
        />
      </q-responsive>
    </div>
  </div>
</template>

<script>
import {
  api,
} from 'boot/axios';
import {
  computed,
  defineComponent,
} from 'vue';
import {
  useRoute,
  useRouter,
} from 'vue-router';

export default defineComponent({
  name: 'PageObject',
  setup() {
    const route = useRoute();
    const router = useRouter();
    const { object } = route.params;
    const src = computed(() => `${process.env.API_URL}/api/objects/${object}`);
    const fetch = async () => {
      try {
        await api.get(src.value);
      } catch {
        router.push('/');
      }
    };
    fetch();
    return {
      src,
    };
  },
});
</script>
