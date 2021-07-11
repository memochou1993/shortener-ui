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
          :src="`http://localhost/api/objects/${object}`"
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
    const fetch = async () => {
      try {
        await api.get(`http://localhost/api/objects/${object}`);
      } catch {
        router.push('/');
      }
    };
    fetch();
    return {
      object,
    };
  },
});
</script>
